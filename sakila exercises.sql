USE sakila;

-- List all actors
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name` FROM `actor`;

-- Find the surname of the actor with first name 'John'
SELECT `last_name` FROM `actor` WHERE `first_name`='John';

-- Find all actors with the surname 'Neeson'
SELECT * FROM `actor` WHERE `last_name`='Neeson';

-- Find all actors with Actor IDs divisble by 10
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name` FROM `actor` WHERE MOD(`actor_id`, 10)=0;

-- Description of movie with id 100
SELECT `description` FROM `film` WHERE `film_id`=100;

-- Find every R rated movie
SELECT `title` FROM `film` WHERE `rating`='R';

-- Find every non-R rated movie
SELECT `title` FROM `film` WHERE `rating`!= 'R';

-- Find the 10 shortest movies
SELECT `title`, `length` FROM `film` ORDER BY `length` ASC LIMIT 10;

-- Find the movies with the longest runtimes (without using LIMIT)
SELECT `title`, `length` FROM `film` WHERE `length` = (SELECT MAX(`length`) FROM `film`);

-- Find all movies that have deleted scenes
SELECT `special_features`, `title` FROM `film` WHERE `special_features` = 'Deleted Scenes';

-- Using HAVING, reverse-alphabetically list the last names that are not repeated
SELECT COUNT(*) AS `frequency`, `last_name` FROM `actor` GROUP BY `last_name` HAVING `frequency`=1 ORDER BY `last_name` DESC;

-- Using HAVING, list the last names that appear more than once, from highest to lowest frequency
SELECT COUNT(`last_name`) AS `frequency`, `last_name` FROM `actor` GROUP BY `last_name` HAVING `frequency`>1 ORDER BY `frequency` DESC;

-- Which actor has appeared in the most films?
SELECT `actor_id`, COUNT(`actor_id`) AS `films_appeared_in` FROM `film_actor` GROUP BY `actor_id` ORDER BY `films_appeared_in` DESC LIMIT 1;

-- When is Academy Dinosaur due?
SELECT `rental_date`, `rental_duration`, DATE_ADD(`rental_date`, INTERVAL `rental_duration` DAY) AS `due_date` FROM `rental` `r` JOIN `inventory` `i` ON `r`.`inventory_id` = `i`.`inventory_id` JOIN `film` `f` ON `i`.`film_id` = `f`.`film_id` WHERE `return_date` IS NULL AND `r`.`inventory_id` IN (SELECT `i`.`inventory_id` FROM `inventory` WHERE `i`.`film_id` = (SELECT `film_id` FROM `film` WHERE `title` = 'ACADEMY DINOSAUR'));


-- What is the average runtime of all films?
SELECT AVG(`length`) FROM `film`;

-- List the average runtime for each film category
SELECT `c`.`name`, AVG(`length`)
FROM `film`
JOIN `film_category` `fc` ON `film`.`film_id`=`fc`.`film_id`
JOIN `category` `c` ON `fc`.`category_id` = `c`.`category_id`
GROUP BY `name`;

-- Or using Views
SELECT AVG(`length`) AS `average_runtime`, `category` FROM `film_list` GROUP BY `category`;

-- List all movies featuring a robot
SELECT `description` FROM `film` WHERE `description` LIKE '%Robot%';

-- How many movies were released in 2010?
SELECT COUNT(*) FROM `film` WHERE `release_year` = 2010;

-- Find the titles of all the horror movies
SELECT `title` FROM `film` WHERE `film_id` IN (SELECT `film_id` FROM `film_category` WHERE `category_id` = (SELECT `category_id` FROM `category` WHERE `name` = 'Horror'));

-- List the full name of the staff member with ID 2
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name` FROM `staff` WHERE `staff_id` = 2;

-- List all the films that Fred Costner has appeared in
SELECT `title` FROM `film` WHERE `film_id` IN (
SELECT `film_id` FROM `film_actor` WHERE `actor_id` = (
SELECT `actor_id` FROM `actor` WHERE `first_name` = 'Fred' AND `last_name` = 'Costner'));

-- How many distinct countries are there?
SELECT COUNT(*) FROM `country`;

-- List the name of every language in reverse-alphabetical order
SELECT `name` FROM `language` ORDER BY `name` DESC;

-- List the full names of every actor whose surname ends in '-son' in alphabetical order by their forename
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name` FROM `actor` WHERE `last_name` LIKE '%son' ORDER BY `first_name` ASC;

-- Which category contains the most films
SELECT `name` FROM `category` WHERE `category_id` = (
SELECT `category_id`FROM `film_category` GROUP BY `category_id` ORDER BY COUNT(*) DESC LIMIT 1);