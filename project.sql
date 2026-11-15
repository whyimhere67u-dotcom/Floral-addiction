PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Flowers;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Florists;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Suppliers (
    supplier_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name   TEXT NOT NULL UNIQUE,
    country        TEXT NOT NULL,
    contact_person TEXT NOT NULL,
    phone          TEXT NOT NULL UNIQUE
);

CREATE TABLE Flowers (
    flower_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    supplier_id    INTEGER NOT NULL,
    flower_name    TEXT NOT NULL,
    variety        TEXT NOT NULL,
    color          TEXT NOT NULL,
    price_per_stem REAL NOT NULL CHECK (price_per_stem > 0),
    stock_qty      INTEGER NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Customers (
    customer_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name        TEXT NOT NULL,
    last_name         TEXT NOT NULL,
    phone             TEXT NOT NULL UNIQUE,
    email             TEXT UNIQUE,
    registration_date DATE NOT NULL
);

CREATE TABLE Florists (
    florist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    position   TEXT NOT NULL CHECK (position IN ('Старший флорист', 'Флорист', 'Стажёр')),
    phone      TEXT NOT NULL UNIQUE,
    hire_date  DATE NOT NULL
);

CREATE TABLE Orders (
    order_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id      INTEGER NOT NULL,
    florist_id       INTEGER NOT NULL,
    order_date       DATETIME NOT NULL,
    delivery_type    TEXT NOT NULL CHECK (delivery_type IN ('Доставка', 'Самовывоз')),
    delivery_address TEXT,
    order_status     TEXT NOT NULL DEFAULT 'Новый'
                     CHECK (order_status IN ('Новый', 'Собирается', 'Доставлен', 'Отменён')),
    CHECK (delivery_type = 'Самовывоз' OR delivery_address IS NOT NULL),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (florist_id)  REFERENCES Florists(florist_id)
);

CREATE TABLE Order_Items (
    item_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id      INTEGER NOT NULL,
    flower_id     INTEGER NOT NULL,
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    price_at_sale REAL NOT NULL CHECK (price_at_sale > 0),
    FOREIGN KEY (order_id)  REFERENCES Orders(order_id),
    FOREIGN KEY (flower_id) REFERENCES Flowers(flower_id)
);

INSERT INTO Suppliers (company_name, country, contact_person, phone) VALUES
('Ecuador Roses S.A.',        'Эквадор',    'Карлос Мендоса',   '+593990001122'),
('Kenya Bloom Ltd',           'Кения',      'Джозеф Киптоо',    '+254700123456'),
('Royal FloraHolland',        'Нидерланды', 'Ян ван Дейк',      '+31297391111'),
('ООО «Флора Импорт»',        'Россия',     'Ирина Соколова',   '+79043211010'),
('Тепличный комбинат «Тюменский»', 'Россия', 'Сергей Ларин',   '+73452505050');

INSERT INTO Flowers (supplier_id, flower_name, variety, color, price_per_stem, stock_qty) VALUES
(1, 'Роза',         'Explorer',        'красный',    250, 180),
(2, 'Роза',         'Red Naomi',       'красный',    150, 240),
(1, 'Роза',         'Pink Floyd',      'розовый',    270, 90),
(5, 'Тюльпан',      'Strong Gold',     'жёлтый',      90, 300),
(3, 'Пион',         'Sarah Bernhardt', 'розовый',    350, 40),
(3, 'Гортензия',    'Magical Ruby',    'бордовый',   450, 25),
(4, 'Эустома',      'Rosita',          'белый',      180, 120),
(5, 'Хризантема',   'Бакарди',         'белый',      120, 200),
(4, 'Альстромерия', 'Virginia',        'белый',      100, 150),
(3, 'Лилия',        'Siberia',         'белый',      220, 60);

INSERT INTO Customers (first_name, last_name, phone, email, registration_date) VALUES
('Анна',      'Морозова',  '+79220010001', 'morozova.anna@mail.ru',  '2025-02-14'),
('Илья',      'Кузнецов',  '+79220010002', 'kuznetsov.i@yandex.ru',  '2025-09-01'),
('Ольга',     'Белова',    '+79220010003', NULL,                     '2026-03-08'),
('Максим',    'Орлов',     '+79220010004', 'orlov.max@gmail.com',    '2026-03-07'),
('Дарья',     'Савельева', '+79220010005', 'dasha.sav@mail.ru',      '2026-05-20'),
('Тимур',     'Галиев',    '+79220010006', NULL,                     '2026-09-01'),
('Екатерина', 'Попова',    '+79220010007', 'popova.ek@yandex.ru',    '2026-10-05'),
('Артём',     'Лебедев',   '+79220010008', 'lebedev.art@gmail.com',  '2026-11-01');

INSERT INTO Florists (first_name, last_name, position, phone, hire_date) VALUES
('Марина',   'Ковалёва', 'Старший флорист', '+79120020001', '2022-04-01'),
('Алёна',    'Шарова',   'Флорист',         '+79120020002', '2024-08-15'),
('Кирилл',   'Демин',    'Флорист',         '+79120020003', '2025-03-10'),
('Вероника', 'Титова',   'Стажёр',          '+79120020004', '2026-09-01');

INSERT INTO Orders (customer_id, florist_id, order_date, delivery_type, delivery_address, order_status) VALUES
(1, 1, '2026-11-01 10:15:00', 'Доставка',  'ул. Республики, 45, кв. 12',  'Доставлен'),
(2, 2, '2026-11-01 13:40:00', 'Самовывоз', NULL,                          'Доставлен'),
(4, 1, '2026-11-02 09:05:00', 'Доставка',  'ул. Мельникайте, 106',        'Доставлен'),
(1, 3, '2026-11-03 18:20:00', 'Доставка',  'ул. Республики, 45, кв. 12',  'Доставлен'),
(5, 2, '2026-11-04 11:00:00', 'Самовывоз', NULL,                          'Доставлен'),
(3, 1, '2026-11-05 16:30:00', 'Доставка',  'ул. Широтная, 29, кв. 7',     'Отменён'),
(6, 4, '2026-11-06 12:10:00', 'Самовывоз', NULL,                          'Доставлен'),
(2, 1, '2026-11-07 10:45:00', 'Доставка',  'ул. 50 лет Октября, 8',       'Доставлен'),
(7, 3, '2026-11-08 15:25:00', 'Доставка',  'ул. Пермякова, 74, кв. 33',   'Доставлен'),
(4, 2, '2026-11-09 19:00:00', 'Самовывоз', NULL,                          'Собирается'),
(1, 1, '2026-11-10 08:50:00', 'Доставка',  'ул. Республики, 45, кв. 12',  'Собирается'),
(8, 3, '2026-11-10 11:30:00', 'Доставка',  'ул. Ленина, 2',               'Новый');

INSERT INTO Order_Items (order_id, flower_id, quantity, price_at_sale) VALUES
(1, 1, 15, 250), (1, 7, 6, 180),
(2, 4, 25, 90),
(3, 2, 51, 140),
(4, 5, 7, 350), (4, 9, 5, 100),
(5, 8, 11, 120), (5, 7, 4, 180),
(6, 6, 3, 450),
(7, 4, 15, 90),
(8, 3, 21, 270), (8, 10, 3, 220),
(9, 2, 25, 150), (9, 9, 7, 100),
(10, 5, 9, 350),
(11, 1, 11, 250), (11, 6, 1, 450);

-- Аналитические запросы
-- q1_1
SELECT item_id, order_id, flower_id,
       quantity, price_at_sale
FROM Order_Items
WHERE quantity >= 10
ORDER BY quantity DESC
LIMIT 10;

-- q1_2
SELECT flower_id,
       COUNT(DISTINCT order_id)        AS orders_count,
       SUM(quantity)                   AS total_stems,
       SUM(quantity * price_at_sale)   AS revenue,
       ROUND(AVG(quantity), 1)         AS avg_stems,
       MAX(quantity)                   AS max_stems
FROM Order_Items
GROUP BY flower_id
ORDER BY total_stems DESC;

-- q1_3
SELECT f.flower_name, f.variety, f.color,
       s.company_name                     AS supplier,
       SUM(oi.quantity)                   AS total_stems,
       SUM(oi.quantity * oi.price_at_sale) AS revenue,
       f.stock_qty                        AS in_stock
FROM Order_Items AS oi
INNER JOIN Orders    AS o ON o.order_id    = oi.order_id
INNER JOIN Flowers   AS f ON f.flower_id   = oi.flower_id
INNER JOIN Suppliers AS s ON s.supplier_id = f.supplier_id
WHERE o.order_status <> 'Отменён'
  AND o.order_date BETWEEN '2026-11-01 00:00:00'
                       AND '2026-11-10 23:59:59'
GROUP BY f.flower_id
ORDER BY total_stems DESC
LIMIT 5;

-- q2_1
SELECT order_id, florist_id, order_date,
       delivery_type, order_status
FROM Orders
WHERE order_status IN ('Доставлен', 'Собирается')
  AND order_date >= '2026-11-01'
ORDER BY florist_id, order_date;

-- q2_2
SELECT florist_id,
       COUNT(order_id)  AS orders_count,
       SUM(CASE WHEN delivery_type = 'Доставка'
                THEN 1 ELSE 0 END) AS deliveries,
       MIN(order_date)  AS first_order,
       MAX(order_date)  AS last_order
FROM Orders
WHERE order_status <> 'Отменён'
GROUP BY florist_id
ORDER BY orders_count DESC;

-- q2_3
SELECT fl.first_name || ' ' || fl.last_name AS florist,
       fl.position,
       COUNT(DISTINCT o.order_id)            AS orders_count,
       SUM(oi.quantity)                      AS stems_used,
       SUM(oi.quantity * oi.price_at_sale)   AS revenue,
       ROUND(SUM(oi.quantity * oi.price_at_sale)
             / COUNT(DISTINCT o.order_id), 0) AS avg_check
FROM Florists AS fl
INNER JOIN Orders      AS o  ON o.florist_id = fl.florist_id
INNER JOIN Order_Items AS oi ON oi.order_id  = o.order_id
WHERE o.order_status <> 'Отменён'
GROUP BY fl.florist_id
ORDER BY revenue DESC;

-- q3_1
SELECT customer_id, first_name, last_name,
       phone, registration_date
FROM Customers
WHERE registration_date < '2026-06-01'
ORDER BY registration_date;

-- q3_2
SELECT customer_id,
       COUNT(order_id)  AS orders_count,
       MIN(order_date)  AS first_order,
       MAX(order_date)  AS last_order
FROM Orders
WHERE order_status <> 'Отменён'
GROUP BY customer_id
HAVING COUNT(order_id) >= 2
ORDER BY orders_count DESC;

-- q3_3
SELECT c.first_name || ' ' || c.last_name   AS customer,
       c.phone,
       COUNT(DISTINCT o.order_id)            AS orders_count,
       SUM(oi.quantity * oi.price_at_sale)   AS total_spent,
       ROUND(SUM(oi.quantity * oi.price_at_sale)
             / COUNT(DISTINCT o.order_id), 0) AS avg_check,
       MAX(o.order_date)                     AS last_order
FROM Customers AS c
INNER JOIN Orders      AS o  ON o.customer_id = c.customer_id
INNER JOIN Order_Items AS oi ON oi.order_id   = o.order_id
WHERE o.order_status <> 'Отменён'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;