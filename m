Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1EPXfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:35:44 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:34383 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab1EPXfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:35:42 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv4 4/6] GPIO: TPS65910: Move driver to drivers/gpio/
Date: Mon, 16 May 2011 18:35:37 -0500
Message-Id: <797F9124-08A3-45B9-BA71-284BB3048F1D@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO driver should reside in drivers/gpio/ for better
organization.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/gpio/Kconfig         |    7 +++
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/tps65910-gpio.c |   91 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig          |    3 +-
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65910-gpio.c  |   91 ------------------------------------------
 6 files changed, 102 insertions(+), 93 deletions(-)
 create mode 100644 drivers/gpio/tps65910-gpio.c
 delete mode 100644 drivers/mfd/tps65910-gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..3a49cc5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -419,4 +419,11 @@ config AB8500_GPIO
 	depends on AB8500_CORE && BROKEN
 	help
 	  Select this to enable the AB8500 IC GPIO driver
+
+config GPIO_TPS65910
+	bool "TPS65910 GPIO"
+	depends on MFD_TPS65910
+	help
+	  Select this option to enable GPIO driver for the TPS65910
+	  chip family.
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..8d7eac0 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
diff --git a/drivers/gpio/tps65910-gpio.c b/drivers/gpio/tps65910-gpio.c
new file mode 100644
index 0000000..f3ae376
--- /dev/null
+++ b/drivers/gpio/tps65910-gpio.c
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
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0131d49..3f4bb6e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -673,8 +673,9 @@ config MFD_OMAP_USB_HOST
 
 config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
-	depends on I2C=y && GPIOLIB
+	depends on I2C=y
 	select MFD_CORE
+	select GPIO_TPS65910
 	help
 	  if you say yes here you get support for the TPS65910 series of
 	  Power Management chips.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c771eed..e905d30 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -88,4 +88,4 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
-obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-gpio.o tps65910-irq.o
+obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
diff --git a/drivers/mfd/tps65910-gpio.c b/drivers/mfd/tps65910-gpio.c
deleted file mode 100644
index f3ae376..0000000
--- a/drivers/mfd/tps65910-gpio.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * tps65910-gpio.c  --  TI TPS6591x
- *
- * Copyright 2010 Texas Instruments Inc.
- *
- * Author: Graeme Gregory <gg@slimlogic.co.uk>
- * Author: Jorge Eduardo Candelaria jedu@slimlogic.co.uk>
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under  the terms of the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the License, or (at your
- *  option) any later version.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/gpio.h>
-#include <linux/i2c.h>
-#include <linux/mfd/tps65910.h>
-
-static int tps65910_gpio_get(struct gpio_chip *gc, unsigned offset)
-{
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
-	uint8_t val;
-
-	tps65910->read(tps65910, TPS65910_GPIO0, 1, &val);
-
-	if (val & GPIO0_GPIO_STS_MASK)
-		return 1;
-
-	return 0;
-}
-
-static void tps65910_gpio_set(struct gpio_chip *gc, unsigned offset,
-			      int value)
-{
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
-
-	if (value)
-		tps65910_set_bits(tps65910, TPS65910_GPIO0,
-					GPIO0_GPIO_SET_MASK);
-	else
-		tps65910_clear_bits(tps65910, TPS65910_GPIO0,
-					GPIO0_GPIO_SET_MASK);
-}
-
-static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
-				int value)
-{
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
-
-	/* Set the initial value */
-	tps65910_gpio_set(gc, 0, value);
-
-	return tps65910_set_bits(tps65910, TPS65910_GPIO0, GPIO0_GPIO_CFG_MASK);
-}
-
-static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
-{
-	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
-
-	return tps65910_clear_bits(tps65910, TPS65910_GPIO0,
-					GPIO0_GPIO_CFG_MASK);
-}
-
-void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
-{
-	int ret;
-
-	if (!gpio_base)
-		return;
-
-	tps65910->gpio.owner		= THIS_MODULE;
-	tps65910->gpio.label		= tps65910->i2c_client->name;
-	tps65910->gpio.dev		= tps65910->dev;
-	tps65910->gpio.base		= gpio_base;
-	tps65910->gpio.ngpio		= 1;
-	tps65910->gpio.can_sleep	= 1;
-
-	tps65910->gpio.direction_input	= tps65910_gpio_input;
-	tps65910->gpio.direction_output	= tps65910_gpio_output;
-	tps65910->gpio.set		= tps65910_gpio_set;
-	tps65910->gpio.get		= tps65910_gpio_get;
-
-	ret = gpiochip_add(&tps65910->gpio);
-
-	if (ret)
-		dev_warn(tps65910->dev, "GPIO registration failed: %d\n", ret);
-}
-- 
1.7.1

