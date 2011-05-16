Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1EPSul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:50:41 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48951 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab1EPSuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:50:39 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 4/5] TPS65911: Add support for added GPIO line
Date: Mon, 16 May 2011 13:50:34 -0500
Message-Id: <F41F2AE1-C4B5-4033-9225-7F2B83CBCCA1@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO 1 to 8 are added for TPS65911 chip version. The gpio driver
now handles more than one gpio lines. Subsequent versions of the
chip family can add new GPIO lines with minimal driver changes.

The GPIO driver should reside in drivers/gpio/ for better
organization.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/gpio/tps65910-gpio.c |  100 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/tps65910-gpio.c  |   91 --------------------------------------
 include/linux/mfd/tps65910.h |   90 ++++++--------------------------------
 3 files changed, 114 insertions(+), 167 deletions(-)
 create mode 100644 drivers/gpio/tps65910-gpio.c
 delete mode 100644 drivers/mfd/tps65910-gpio.c

diff --git a/drivers/gpio/tps65910-gpio.c b/drivers/gpio/tps65910-gpio.c
new file mode 100644
index 0000000..8d1ddfd
--- /dev/null
+++ b/drivers/gpio/tps65910-gpio.c
@@ -0,0 +1,100 @@
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
+	tps65910->read(tps65910, TPS65910_GPIO0 + offset, 1, &val);
+
+	if (val & GPIO_STS_MASK)
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
+		tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_SET_MASK);
+	else
+		tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_SET_MASK);
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
+	return tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_CFG_MASK);
+}
+
+static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
+
+	return tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
+						GPIO_CFG_MASK);
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
+
+	switch(tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		tps65910->gpio.ngpio	= 6;
+	case TPS65911:
+		tps65910->gpio.ngpio	= 9;
+	default:
+		return;
+	}
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
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 32bb7b8..5f77006 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -101,6 +101,9 @@
 #define TPS65910_GPIO3					0x63
 #define TPS65910_GPIO4					0x64
 #define TPS65910_GPIO5					0x65
+#define TPS65910_GPIO6					0x66
+#define TPS65910_GPIO7					0x67
+#define TPS65910_GPIO8					0x68
 #define TPS65910_JTAGVERNUM				0x80
 #define TPS65910_MAX_REGISTER				0x80
 
@@ -650,82 +653,17 @@
 #define INT_MSK3_GPIO4_R_IT_MSK_SHIFT			0
 
 
-/*Register GPIO0  (0x80) register.RegisterDescription */
-#define GPIO0_GPIO_DEB_MASK				0x10
-#define GPIO0_GPIO_DEB_SHIFT				4
-#define GPIO0_GPIO_PUEN_MASK				0x08
-#define GPIO0_GPIO_PUEN_SHIFT				3
-#define GPIO0_GPIO_CFG_MASK				0x04
-#define GPIO0_GPIO_CFG_SHIFT				2
-#define GPIO0_GPIO_STS_MASK				0x02
-#define GPIO0_GPIO_STS_SHIFT				1
-#define GPIO0_GPIO_SET_MASK				0x01
-#define GPIO0_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO1  (0x80) register.RegisterDescription */
-#define GPIO1_GPIO_DEB_MASK				0x10
-#define GPIO1_GPIO_DEB_SHIFT				4
-#define GPIO1_GPIO_PUEN_MASK				0x08
-#define GPIO1_GPIO_PUEN_SHIFT				3
-#define GPIO1_GPIO_CFG_MASK				0x04
-#define GPIO1_GPIO_CFG_SHIFT				2
-#define GPIO1_GPIO_STS_MASK				0x02
-#define GPIO1_GPIO_STS_SHIFT				1
-#define GPIO1_GPIO_SET_MASK				0x01
-#define GPIO1_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO2  (0x80) register.RegisterDescription */
-#define GPIO2_GPIO_DEB_MASK				0x10
-#define GPIO2_GPIO_DEB_SHIFT				4
-#define GPIO2_GPIO_PUEN_MASK			 	0x08
-#define GPIO2_GPIO_PUEN_SHIFT				3
-#define GPIO2_GPIO_CFG_MASK				0x04
-#define GPIO2_GPIO_CFG_SHIFT				2
-#define GPIO2_GPIO_STS_MASK				0x02
-#define GPIO2_GPIO_STS_SHIFT				1
-#define GPIO2_GPIO_SET_MASK				0x01
-#define GPIO2_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO3  (0x80) register.RegisterDescription */
-#define GPIO3_GPIO_DEB_MASK				0x10
-#define GPIO3_GPIO_DEB_SHIFT				4
-#define GPIO3_GPIO_PUEN_MASK				0x08
-#define GPIO3_GPIO_PUEN_SHIFT				3
-#define GPIO3_GPIO_CFG_MASK				0x04
-#define GPIO3_GPIO_CFG_SHIFT				2
-#define GPIO3_GPIO_STS_MASK			 	0x02
-#define GPIO3_GPIO_STS_SHIFT				1
-#define GPIO3_GPIO_SET_MASK				0x01
-#define GPIO3_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO4  (0x80) register.RegisterDescription */
-#define GPIO4_GPIO_DEB_MASK				0x10
-#define GPIO4_GPIO_DEB_SHIFT				4
-#define GPIO4_GPIO_PUEN_MASK				0x08
-#define GPIO4_GPIO_PUEN_SHIFT				3
-#define GPIO4_GPIO_CFG_MASK				0x04
-#define GPIO4_GPIO_CFG_SHIFT				2
-#define GPIO4_GPIO_STS_MASK				0x02
-#define GPIO4_GPIO_STS_SHIFT				1
-#define GPIO4_GPIO_SET_MASK				0x01
-#define GPIO4_GPIO_SET_SHIFT				0
-
-
-/*Register GPIO5  (0x80) register.RegisterDescription */
-#define GPIO5_GPIO_DEB_MASK				0x10
-#define GPIO5_GPIO_DEB_SHIFT				4
-#define GPIO5_GPIO_PUEN_MASK				0x08
-#define GPIO5_GPIO_PUEN_SHIFT				3
-#define GPIO5_GPIO_CFG_MASK				0x04
-#define GPIO5_GPIO_CFG_SHIFT				2
-#define GPIO5_GPIO_STS_MASK				0x02
-#define GPIO5_GPIO_STS_SHIFT				1
-#define GPIO5_GPIO_SET_MASK				0x01
-#define GPIO5_GPIO_SET_SHIFT				0
+/*Register GPIO  (0x80) register.RegisterDescription */
+#define GPIO_DEB_MASK                           0x10
+#define GPIO_DEB_SHIFT                          4
+#define GPIO_PUEN_MASK                          0x08
+#define GPIO_PUEN_SHIFT                         3
+#define GPIO_CFG_MASK                           0x04
+#define GPIO_CFG_SHIFT                          2
+#define GPIO_STS_MASK                           0x02
+#define GPIO_STS_SHIFT                          1
+#define GPIO_SET_MASK                           0x01
+#define GPIO_SET_SHIFT                          0
 
 
 /*Register JTAGVERNUM  (0x80) register.RegisterDescription */
-- 
1.7.1

