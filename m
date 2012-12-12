Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2LLOBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44363 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab2LLOBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:05 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/33] leds-lp55xx: add new common driver for lp5521/5523
Thread-Topic: [PATCH 07/33] leds-lp55xx: add new common driver for
 lp5521/5523
Thread-Index: Ac3YcR1JCB3Y//BgR2i35LddjaJqgg==
Date: Wed, 12 Dec 2012 14:01:00 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAE0@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch supports basic common driver code for LP5521, LP5523/55231 devices.

 ( Driver Structure Data )

 lp55xx_led and lp55xx_chip
 In lp55xx common driver, two different data structure is used.
 o lp55xx_led
   control multi output LED channels such as led current, channel index.
 o lp55xx_chip
   general chip control such like the I2C and platform data.

 For example, LP5521 has maximum 3 LED channels.
 LP5523/55231 has 9 output channels.

 lp55xx_chip for LP5521 ... lp55xx_led #1
                            lp55xx_led #2
                            lp55xx_led #3

 lp55xx_chip for LP5523 ... lp55xx_led #1
                            lp55xx_led #2
                            .
                            .
                            lp55xx_led #9

 ( Platform Data )

 LP5521 and LP5523/55231 have own specific platform data.
 However, this data can be handled with just one platform data structure.
 The lp55xx platform data is declared in the header.
 This structure is derived from leds-lp5521.h and leds-lp5523.h

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig                      |   14 ++++-
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lp55xx-common.c         |   55 ++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h         |   61 ++++++++++++++++++++
 include/linux/platform_data/leds-lp55xx.h |   87 +++++++++++++++++++++++++++++
 5 files changed, 216 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/leds-lp55xx-common.c
 create mode 100644 drivers/leds/leds-lp55xx-common.h
 create mode 100644 include/linux/platform_data/leds-lp55xx.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f508def..36f389f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -193,9 +193,18 @@ config LEDS_LP3944
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-lp3944.
 
+config LEDS_LP55XX_COMMON
+	bool "Common Driver for TI/National LP5521 and LP5523/55231"
+	depends on LEDS_LP5521 || LEDS_LP5523
+	depends on I2C
+	help
+	  This option supports common operations for LP5521 and LP5523/55231
+	  devices.
+
 config LEDS_LP5521
 	tristate "LED Support for N.S. LP5521 LED driver chip"
-	depends on LEDS_CLASS && I2C
+	depends on LEDS_CLASS
+	select LEDS_LP55XX_COMMON
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LP5521 LED driver. It is 3 channel chip with programmable engines.
@@ -204,7 +213,8 @@ config LEDS_LP5521
 
 config LEDS_LP5523
 	tristate "LED Support for TI/National LP5523/55231 LED driver chip"
-	depends on LEDS_CLASS && I2C
+	depends on LEDS_CLASS
+	select LEDS_LP55XX_COMMON
 	help
 	  If you say yes here you get support for TI/National Semiconductor
 	  LP5523/55231 LED driver.
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 3fb9641..215e7e3 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO_REGISTER)	+= leds-gpio-register.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
+obj-$(CONFIG_LEDS_LP55XX_COMMON)	+= leds-lp55xx-common.o
 obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
 obj-$(CONFIG_LEDS_LP5523)		+= leds-lp5523.o
 obj-$(CONFIG_LEDS_LP8788)		+= leds-lp8788.o
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
new file mode 100644
index 0000000..4dc4dc6
--- /dev/null
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -0,0 +1,55 @@
+/*
+ * LP5521/LP5523/LP55231 Common Driver
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Derived from leds-lp5521.c, leds-lp5523.c
+ */
+
+#include <linux/i2c.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/platform_data/leds-lp55xx.h>
+
+#include "leds-lp55xx-common.h"
+
+int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(chip->cl, reg, val);
+}
+EXPORT_SYMBOL_GPL(lp55xx_write);
+
+int lp55xx_read(struct lp55xx_chip *chip, u8 reg, u8 *val)
+{
+	s32 ret;
+
+	ret = i2c_smbus_read_byte_data(chip->cl, reg);
+	if (ret < 0)
+		return ret;
+
+	*val = ret;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lp55xx_read);
+
+int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg, u8 mask, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	ret = lp55xx_read(chip, reg, &tmp);
+	if (ret)
+		return ret;
+
+	tmp &= ~mask;
+	tmp |= val & mask;
+
+	return lp55xx_write(chip, reg, tmp);
+}
+EXPORT_SYMBOL_GPL(lp55xx_update_bits);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
new file mode 100644
index 0000000..369cb9c
--- /dev/null
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -0,0 +1,61 @@
+/*
+ * LP55XX Common Driver Header
+ *
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * Derived from leds-lp5521.c, leds-lp5523.c
+ */
+
+#ifndef _LEDS_LP55XX_COMMON_H
+#define _LEDS_LP55XX_COMMON_H
+
+struct lp55xx_led;
+struct lp55xx_chip;
+
+/*
+ * struct lp55xx_chip
+ * @cl         : I2C communication for access registers
+ * @pdata      : Platform specific data
+ * @lock       : Lock for user-space interface
+ * @num_leds   : Number of registered LEDs
+ */
+struct lp55xx_chip {
+	struct i2c_client *cl;
+	struct lp55xx_platform_data *pdata;
+	struct mutex lock;	/* lock for user-space interface */
+	int num_leds;
+};
+
+/*
+ * struct lp55xx_led
+ * @chan_nr         : Channel number
+ * @cdev            : LED class device
+ * @led_current     : Current setting at each led channel
+ * @max_current     : Maximun current at each led channel
+ * @brightness_work : Workqueue for brightness control
+ * @brightness      : Brightness value
+ * @chip            : The lp55xx chip data
+ */
+struct lp55xx_led {
+	int chan_nr;
+	struct led_classdev cdev;
+	u8 led_current;
+	u8 max_current;
+	struct work_struct brightness_work;
+	u8 brightness;
+	struct lp55xx_chip *chip;
+};
+
+/* register access */
+extern int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val);
+extern int lp55xx_read(struct lp55xx_chip *chip, u8 reg, u8 *val);
+extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
+			u8 mask, u8 val);
+
+#endif /* _LEDS_LP55XX_COMMON_H */
diff --git a/include/linux/platform_data/leds-lp55xx.h b/include/linux/platform_data/leds-lp55xx.h
new file mode 100644
index 0000000..1509570
--- /dev/null
+++ b/include/linux/platform_data/leds-lp55xx.h
@@ -0,0 +1,87 @@
+/*
+ * LP55XX Platform Data Header
+ *
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * Derived from leds-lp5521.h, leds-lp5523.h
+ */
+
+#ifndef _LEDS_LP55XX_H
+#define _LEDS_LP55XX_H
+
+/* Clock configuration */
+#define LP55XX_CLOCK_AUTO	0
+#define LP55XX_CLOCK_INT	1
+#define LP55XX_CLOCK_EXT	2
+
+/* Bits in LP5521 CONFIG register. 'update_config' in lp55xx_platform_data */
+#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
+#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
+#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
+#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
+#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
+#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
+#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
+#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
+#define LP5521_CLK_INT			1	/* Internal clock */
+#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
+
+struct lp55xx_led_config {
+	const char *name;
+	u8 chan_nr;
+	u8 led_current; /* mA x10, 0 if led is not connected */
+	u8 max_current;
+};
+
+struct lp55xx_predef_pattern {
+	u8 *r;
+	u8 *g;
+	u8 *b;
+	u8 size_r;
+	u8 size_g;
+	u8 size_b;
+};
+
+/*
+ * struct lp55xx_platform_data
+ * @led_config        : Configurable led class device
+ * @num_channels      : Number of LED channels
+ * @label             : Used for naming LEDs
+ * @clock_mode        : Input clock mode. LP55XX_CLOCK_AUTO or _INT or _EXT
+ * @setup_resources   : Platform specific function before enabling the chip
+ * @release_resources : Platform specific function after  disabling the chip
+ * @enable            : EN pin control by platform side
+ * @patterns          : Predefined pattern data for RGB channels
+ * @num_patterns      : Number of patterns
+ * @update_config     : Value of CONFIG register
+ */
+struct lp55xx_platform_data {
+
+	/* LED channel configuration */
+	struct lp55xx_led_config *led_config;
+	u8 num_channels;
+	const char *label;
+
+	/* Clock configuration */
+	u8 clock_mode;
+
+	/* Platform specific functions */
+	int (*setup_resources)(void);
+	void (*release_resources)(void);
+	void (*enable)(bool state);
+
+	/* Predefined pattern data */
+	struct lp55xx_predef_pattern *patterns;
+	unsigned int num_patterns;
+
+	/* _CONFIG register */
+	u8 update_config;
+};
+
+#endif /* _LEDS_LP55XX_H */
-- 
1.7.9.5


Best Regards,
Milo


