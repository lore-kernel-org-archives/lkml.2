Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030494Ab2GMKrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:47:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3239 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161460Ab2GMKrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:47:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 13 Jul 2012 03:47:00 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 5/5] mfd: tps6586x: remove gpio support from core driver
Date: Fri, 13 Jul 2012 16:09:27 +0530
Message-ID: <1342175967-10087-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>
References: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO functionality of device tps6586x is added through
platform gpio driver and it can be register as the mfd sub
device and hence removing the duplicates code which register
the gpio functionality from core driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/Kconfig    |    2 +-
 drivers/mfd/tps6586x.c |   99 +++++++++---------------------------------------
 2 files changed, 19 insertions(+), 82 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ec885a9..872dfe4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -198,7 +198,7 @@ config MFD_TPS65217
 
 config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	depends on REGULATOR
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 7210fa7..0b76fd5 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -22,7 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
@@ -30,10 +29,6 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6586x.h>
 
-/* GPIO control registers */
-#define TPS6586X_GPIOSET1	0x5d
-#define TPS6586X_GPIOSET2	0x5e
-
 /* interrupt control registers */
 #define TPS6586X_INT_ACK1	0xb5
 #define TPS6586X_INT_ACK2	0xb6
@@ -94,12 +89,23 @@ static const struct tps6586x_irq_data tps6586x_irqs[] = {
 	[TPS6586X_INT_RTC_ALM2] = TPS6586X_IRQ(TPS6586X_INT_MASK4, 1 << 1),
 };
 
+static struct mfd_cell tps6586x_cell[] = {
+	{
+		.name = "tps6586x-gpio",
+	},
+	{
+		.name = "tps6586x-rtc",
+	},
+	{
+		.name = "tps6586x-onkey",
+	},
+};
+
 struct tps6586x {
 	struct device		*dev;
 	struct i2c_client	*client;
 	struct regmap		*regmap;
 
-	struct gpio_chip	gpio;
 	struct irq_chip		irq_chip;
 	struct mutex		irq_lock;
 	int			irq_base;
@@ -173,63 +179,6 @@ int tps6586x_update(struct device *dev, int reg, uint8_t val, uint8_t mask)
 }
 EXPORT_SYMBOL_GPL(tps6586x_update);
 
-static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
-{
-	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
-	uint8_t val;
-	int ret;
-
-	ret = tps6586x_read(tps6586x->dev, TPS6586X_GPIOSET2, &val);
-	if (ret)
-		return ret;
-
-	return !!(val & (1 << offset));
-}
-
-
-static void tps6586x_gpio_set(struct gpio_chip *chip, unsigned offset,
-			      int value)
-{
-	struct tps6586x *tps6586x = container_of(chip, struct tps6586x, gpio);
-
-	tps6586x_update(tps6586x->dev, TPS6586X_GPIOSET2,
-			value << offset, 1 << offset);
-}
-
-static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
-				int value)
-{
-	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
-	uint8_t val, mask;
-
-	tps6586x_gpio_set(gc, offset, value);
-
-	val = 0x1 << (offset * 2);
-	mask = 0x3 << (offset * 2);
-
-	return tps6586x_update(tps6586x->dev, TPS6586X_GPIOSET1, val, mask);
-}
-
-static int tps6586x_gpio_init(struct tps6586x *tps6586x, int gpio_base)
-{
-	if (!gpio_base)
-		return 0;
-
-	tps6586x->gpio.owner		= THIS_MODULE;
-	tps6586x->gpio.label		= tps6586x->client->name;
-	tps6586x->gpio.dev		= tps6586x->dev;
-	tps6586x->gpio.base		= gpio_base;
-	tps6586x->gpio.ngpio		= 4;
-	tps6586x->gpio.can_sleep	= 1;
-
-	/* FIXME: add handling of GPIOs as dedicated inputs */
-	tps6586x->gpio.direction_output	= tps6586x_gpio_output;
-	tps6586x->gpio.set		= tps6586x_gpio_set;
-	tps6586x->gpio.get		= tps6586x_gpio_get;
-
-	return gpiochip_add(&tps6586x->gpio);
-}
-
 static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
@@ -543,9 +492,10 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		}
 	}
 
-	ret = tps6586x_gpio_init(tps6586x, pdata->gpio_base);
-	if (ret) {
-		dev_err(&client->dev, "GPIO registration failed: %d\n", ret);
+	ret = mfd_add_devices(tps6586x->dev, -1,
+			tps6586x_cell, ARRAY_SIZE(tps6586x_cell), NULL, 0);
+	if (ret < 0) {
+		dev_err(&client->dev, "mfd_add_devices failed: %d\n", ret);
 		return ret;
 	}
 
@@ -558,29 +508,16 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 	return 0;
 
 err_add_devs:
-	if (pdata->gpio_base) {
-		ret = gpiochip_remove(&tps6586x->gpio);
-		if (ret)
-			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
-				ret);
-	}
+	mfd_remove_devices(tps6586x->dev);
 	return ret;
 }
 
 static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 {
 	struct tps6586x *tps6586x = i2c_get_clientdata(client);
-	struct tps6586x_platform_data *pdata = client->dev.platform_data;
-	int ret;
-
-	if (pdata->gpio_base) {
-		ret = gpiochip_remove(&tps6586x->gpio);
-		if (ret)
-			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
-				ret);
-	}
 
 	tps6586x_remove_subdevs(tps6586x);
+	mfd_remove_devices(tps6586x->dev);
 	return 0;
 }
 
-- 
1.7.1.1

