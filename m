Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1EJUep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:34:45 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33818 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab1EJUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:34:43 -0400
MIME-Version: 1.0
Date: Tue, 10 May 2011 15:25:35 -0500
Message-ID: <BANLkTikxbzmSNTMCvrPbfygS+iSUBhE=-Q@mail.gmail.com>
Subject: [PATCH 2/4] tps65912: gpio: add gpio driver
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65912 has five GPIOs that can be configured for different
purposes.

Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
---
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65912-gpio.c  |   94 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/tps65912.c       |   14 ++++++
 include/linux/mfd/tps65912.h |    3 +
 4 files changed, 112 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps65912-gpio.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 9d60cfd..687bd2a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -31,7 +31,7 @@ wm8350-objs			+= wm8350-irq.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
-obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
+obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o tps65912-gpio.o

 obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
diff --git a/drivers/mfd/tps65912-gpio.c b/drivers/mfd/tps65912-gpio.c
new file mode 100644
index 0000000..fa94674
--- /dev/null
+++ b/drivers/mfd/tps65912-gpio.c
@@ -0,0 +1,94 @@
+/*
+ * tps65912-gpio.c  --	TI TPS6591x
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/mfd/tps65912.h>
+
+static int tps6591x_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+	uint8_t val;
+
+	tps65912->read(tps65912, TPS65912_GPIO1 + offset, 1, &val);
+
+	if (val & GPIO_STS_MASK)
+		return 1;
+
+	return 0;
+}
+
+static void tps6591x_gpio_set(struct gpio_chip *gc, unsigned offset,
+			      int value)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+
+	if (value)
+		tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
+							GPIO_SET_MASK);
+	else
+		tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
+							~GPIO_SET_MASK);
+}
+
+static int tps6591x_gpio_output(struct gpio_chip *gc, unsigned offset,
+				int value)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+
+	/* Set the initial value */
+	tps6591x_gpio_set(gc, offset, value);
+
+	return tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
+								GPIO_CFG_MASK);
+}
+
+static int tps6591x_gpio_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
+
+	return tps65912_clear_bits(tps65912, TPS65912_GPIO1 + offset,
+							~GPIO_CFG_MASK);
+
+}
+
+void tps65912_gpio_init(struct tps65912 *tps65912, int gpio_base)
+{
+	int ret;
+
+	if (!gpio_base)
+		return;
+
+	tps65912->gpio.owner		= THIS_MODULE;
+	/* FIXME: should we use compilation macro for SPI */
+	tps65912->gpio.label		= tps65912->i2c_client->name;
+	tps65912->gpio.dev		= tps65912->dev;
+	tps65912->gpio.base		= gpio_base;
+	tps65912->gpio.ngpio		= 5;
+	tps65912->gpio.can_sleep	= 1;
+
+	tps65912->gpio.direction_input	= tps6591x_gpio_input;
+	tps65912->gpio.direction_output	= tps6591x_gpio_output;
+	tps65912->gpio.set		= tps6591x_gpio_set;
+	tps65912->gpio.get		= tps6591x_gpio_get;
+
+	ret = gpiochip_add(&tps65912->gpio);
+
+	if (ret)
+		dev_warn(tps65912->dev, "GPIO registration failed: %d\n", ret);
+}
+
diff --git a/drivers/mfd/tps65912.c b/drivers/mfd/tps65912.c
index a6d5fce..83dbc3a 100644
--- a/drivers/mfd/tps65912.c
+++ b/drivers/mfd/tps65912.c
@@ -88,8 +88,13 @@ static int tps65912_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct tps65912 *tps65912;
+	struct tps65912_board *pmic_plat_data;
 	int ret = 0;

+	pmic_plat_data = dev_get_platdata(&i2c->dev);
+	if (!pmic_plat_data)
+		return -EINVAL;
+
 	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
 	if (tps65912 == NULL)
 		return -ENOMEM;
@@ -107,6 +112,8 @@ static int tps65912_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;

+	tps65912_gpio_init(tps65912, pmic_plat_data->gpio_base);
+
 	return ret;

 err:
@@ -207,9 +214,14 @@ static int tps65912_spi_read(struct tps65912
*tps65912, u8 addr,
 static int __devinit tps65912_spi_probe(struct spi_device *spi)
 {
 	struct tps65912 *tps65912;
+	struct tps65912_board *pmic_plat_data;
 	struct tps65912_platform_data *init_data;
 	int dcdc_avs, value, ret = 0;

+	pmic_plat_data = dev_get_platdata(&spi->dev);
+	if (!pmic_plat_data)
+		return -ENODEV;
+
 	init_data = kzalloc(sizeof(struct tps65912_platform_data),
 								GFP_KERNEL);
 	if (init_data == NULL)
@@ -241,6 +253,8 @@ static int __devinit tps65912_spi_probe(struct
spi_device *spi)
 	if (ret < 0)
 		goto err;

+	tps65912_gpio_init(tps65912, pmic_plat_data->gpio_base);
+
 	return ret;

 err:
diff --git a/include/linux/mfd/tps65912.h b/include/linux/mfd/tps65912.h
index 1d0aab8..bcfdc0d 100644
--- a/include/linux/mfd/tps65912.h
+++ b/include/linux/mfd/tps65912.h
@@ -405,6 +405,7 @@
  * Board platform dat may be used to initialize regulators.
  */
 struct tps65912_board {
+	int gpio_base;
 	struct regulator_init_data *tps65912_pmic_init_data;
 };

@@ -453,5 +454,7 @@ unsigned int tps_chip(void);

 int tps65912_set_bits(struct tps65912 *tps65912, u8 reg, u8 mask);
 int tps65912_clear_bits(struct tps65912 *tps65912, u8 reg, u8 mask);
+void tps65912_gpio_init(struct tps65912 *tps65912, int gpio_base);
+
 #endif /*  __LINUX_MFD_TPS65912_H */

-- 
1.7.0.4
