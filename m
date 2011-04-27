Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab1D0PvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:51:10 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58076 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413Ab1D0PvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:51:08 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
Date: Wed, 27 Apr 2011 10:51:04 -0500
Message-Id: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

TPS65910 has one configurable GPIO that can be used for several
purposes. Subsequent versions of the TPS chip support more than
one GPIO.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65910-gpio.c  |   91 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/tps65910.c       |    7 +++
 include/linux/mfd/tps65910.h |    2 +
 4 files changed, 101 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps65910-gpio.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3afb7ac..012ed17 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -88,4 +88,4 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
-obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o
+obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-gpio.o
diff --git a/drivers/mfd/tps65910-gpio.c b/drivers/mfd/tps65910-gpio.c
new file mode 100644
index 0000000..f3ae376
--- /dev/null
+++ b/drivers/mfd/tps65910-gpio.c
@@ -0,0 +1,91 @@
+/*
+ * tps65910-gpio.c  --  TI TPS6591x
+ *
+ * Copyright 2010 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Jorge Eduardo Candelaria jedu@slimlogic.co.uk>
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
+#include <linux/mfd/tps65910.h>
+
+static int tps65910_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+	uint8_t val;
+
+	tps65910->read(tps65910, TPS65910_GPIO0, 1, &val);
+
+	if (val & GPIO0_GPIO_STS_MASK)
+		return 1;
+
+	return 0;
+}
+
+static void tps65910_gpio_set(struct gpio_chip *gc, unsigned offset,
+			      int value)
+{
+	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+
+	if (value)
+		tps65910_set_bits(tps65910, TPS65910_GPIO0,
+					GPIO0_GPIO_SET_MASK);
+	else
+		tps65910_clear_bits(tps65910, TPS65910_GPIO0,
+					GPIO0_GPIO_SET_MASK);
+}
+
+static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
+				int value)
+{
+	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+
+	/* Set the initial value */
+	tps65910_gpio_set(gc, 0, value);
+
+	return tps65910_set_bits(tps65910, TPS65910_GPIO0, GPIO0_GPIO_CFG_MASK);
+}
+
+static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+
+	return tps65910_clear_bits(tps65910, TPS65910_GPIO0,
+					GPIO0_GPIO_CFG_MASK);
+}
+
+void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
+{
+	int ret;
+
+	if (!gpio_base)
+		return;
+
+	tps65910->gpio.owner		= THIS_MODULE;
+	tps65910->gpio.label		= tps65910->i2c_client->name;
+	tps65910->gpio.dev		= tps65910->dev;
+	tps65910->gpio.base		= gpio_base;
+	tps65910->gpio.ngpio		= 1;
+	tps65910->gpio.can_sleep	= 1;
+
+	tps65910->gpio.direction_input	= tps65910_gpio_input;
+	tps65910->gpio.direction_output	= tps65910_gpio_output;
+	tps65910->gpio.set		= tps65910_gpio_set;
+	tps65910->gpio.get		= tps65910_gpio_get;
+
+	ret = gpiochip_add(&tps65910->gpio);
+
+	if (ret)
+		dev_warn(tps65910->dev, "GPIO registration failed: %d\n", ret);
+}
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 43e73cf..5bd3115 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -137,8 +137,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct tps65910 *tps65910;
+	struct tps65910_board *pmic_plat_data;
 	int ret = 0;
 
+	pmic_plat_data = dev_get_platdata(&i2c->dev);
+	if (!pmic_plat_data)
+		return -EINVAL;
+
 	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
 	if (tps65910 == NULL)
 		return -ENOMEM;
@@ -155,6 +160,8 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
+	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
+
 	return ret;
 
 err:
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index fd2be22..b19cd04 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -714,6 +714,7 @@
  */
 
 struct tps65910_board {
+	int gpio_base;
 	struct regulator_init_data *tps65910_pmic_init_data;
 };
 
@@ -748,5 +749,6 @@ struct tps65910_platform_data {
 
 int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
+void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
 
 #endif /*  __LINUX_MFD_TPS65910_H */
-- 
1.7.1

