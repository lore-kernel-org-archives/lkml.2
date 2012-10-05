Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2JEIKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:10:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47111 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2JEIKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:10:21 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/28] leds: leds-lp55xx: add common driver
Thread-Topic: [PATCH 01/28] leds: leds-lp55xx: add common driver
Thread-Index: Ac2i0Nc7bgy8AZ7cQpejlF5IhGBTzA==
Date: Fri, 5 Oct 2012 08:10:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641766F3@DQHE02.ent.ti.com>
Accept-Language: en-US
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
   general chip control such like the I2c and platform data.

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

 ( Chip Dependent Code )

 To support device specific configurations,
 special structure 'lpxx_device_config' is used.

  Reset command, chip enable command
  Brightness control register access
  Setting LED output current
  Chip specific initialization
  Program memory address access for running patterns

 ( Platform Data )

 LP5521 and LP5523/55231 have own specific platform data.
 However, this data can be handled with just one platform data structure.
 The lp55xx platform data is declared in the header.
 This structure is derived from leds-lp5521.h and leds-lp5523.h

 ( Firmware Interface )

 LP55xx family devices have the internal program memory
 for running various LED patterns.
 This pattern data can saved as a file in the user-land or hex byte string is
 written into the memory through the I2C by the application.
 To support this feature, the firmware structure is defined in the header.
 Detailed implementation will be submit as separate patches.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig                      |   15 +++-
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lp55xx-common.c         |   65 +++++++++++++++
 drivers/leds/leds-lp55xx-common.h         |  124 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lp55xx.h |   55 +++++++++++++
 5 files changed, 258 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/leds-lp55xx-common.c
 create mode 100644 drivers/leds/leds-lp55xx-common.h
 create mode 100644 include/linux/platform_data/leds-lp55xx.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f508def..dbe25b2 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -193,9 +193,19 @@ config LEDS_LP3944
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-lp3944.
 
+config LEDS_LP55XX_COMMON
+	bool "Common Code for TI/National LP5521, LP5523/55231 device"
+	depends on LEDS_LP5521 || LEDS_LP5523
+	depends on I2C
+	select FW_LOADER
+	help
+	  This option supports common operations for LP5521, LP5523/55231
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
@@ -204,7 +214,8 @@ config LEDS_LP5521
 
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
index 0000000..58c5fb8
--- /dev/null
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -0,0 +1,65 @@
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
+
+struct lp55xx_led *cdev_to_lp55xx_led(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct lp55xx_led, cdev);
+}
+EXPORT_SYMBOL_GPL(cdev_to_lp55xx_led);
+
+struct lp55xx_led *dev_to_lp55xx_led(struct device *dev)
+{
+	return cdev_to_lp55xx_led(dev_get_drvdata(dev));
+}
+EXPORT_SYMBOL_GPL(dev_to_lp55xx_led);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
new file mode 100644
index 0000000..91a6afc
--- /dev/null
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -0,0 +1,124 @@
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
+ * Derived from leds-lp5521.h, leds-lp5523.h
+ */
+
+#ifndef __LINUX_LP55XX_COMMON_H
+#define __LINUX_LP55XX_COMMON_H
+
+enum lp55xx_engine_index {
+	LP55XX_ENGINE_INVALID,
+	LP55XX_ENGINE_1,
+	LP55XX_ENGINE_2,
+	LP55XX_ENGINE_3,
+};
+
+struct lp55xx_led;
+struct lp55xx_chip;
+
+/*
+ * struct lp55xx_reg
+ * @addr : Register address
+ * @val  : Register value
+ */
+struct lp55xx_reg {
+	u8 addr;
+	u8 val;
+};
+
+/*
+ * struct lp55xx_device_config
+ * @max_channel        : Maximum number of channels
+ * @reset              : Chip specific reset command
+ * @enable             : Chip specific enable command
+ * @post_init_device   : Chip specific initialization code
+ * @set_led_current    : Current setting operation
+ * @brightness_work_fn : Brightness work function
+ * @run_engine         : Run internal engine for pattern
+ * @firmware_cb        : Call function when the firmware is loaded
+ * @dev_attr_group     : Device specific attributes
+ */
+struct lp55xx_device_config {
+	const int max_channel;
+
+	const struct lp55xx_reg reset;
+	const struct lp55xx_reg enable;
+
+	/* define if the device has specific initialization process */
+	int (*post_init_device) (struct lp55xx_chip *chip);
+
+	/* current setting function */
+	void (*set_led_current) (struct lp55xx_led *led, u8 led_current);
+
+	/* access brightness register */
+	void (*brightness_work_fn)(struct work_struct *work);
+
+	/* used for running firmware LED patterns */
+	void (*run_engine) (struct lp55xx_chip *chip, bool start);
+
+	/* access program memory when the firmware is loaded */
+	void (*firmware_cb)(struct lp55xx_chip *chip);
+
+	/* additional device specific attributes */
+	const struct attribute_group *dev_attr_group;
+};
+
+/*
+ * struct lp55xx_chip
+ * @cl         : I2C communication for access registers
+ * @pdata      : Platform specific data
+ * @lock       : Lock for user-space interface
+ * @cfg        : Device specific configuration data
+ * @num_leds   : Number of registered LEDs
+ * @engine_idx : Selected engine number
+ * @fw         : Firmware data for running a LED pattern
+ */
+struct lp55xx_chip {
+	struct i2c_client *cl;
+	struct lp55xx_platform_data *pdata;
+	struct mutex lock;	/* lock for user-space interface */
+	struct lp55xx_device_config *cfg;
+	int num_leds;
+	enum lp55xx_engine_index engine_idx;
+	const struct firmware *fw;
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
+extern struct lp55xx_led *cdev_to_lp55xx_led(struct led_classdev *cdev);
+extern struct lp55xx_led *dev_to_lp55xx_led(struct device *dev);
+
+#endif /* __LINUX_LP55XX_COMMON_H */
diff --git a/include/linux/platform_data/leds-lp55xx.h b/include/linux/platform_data/leds-lp55xx.h
new file mode 100644
index 0000000..3c9b658
--- /dev/null
+++ b/include/linux/platform_data/leds-lp55xx.h
@@ -0,0 +1,55 @@
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
+#ifndef __LINUX_LP55XX_H
+#define __LINUX_LP55XX_H
+
+#define LP55XX_CLOCK_AUTO	0
+#define LP55XX_CLOCK_INT	1
+#define LP55XX_CLOCK_EXT	2
+
+/* Bits in LP5521 CONFIG register */
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
+	const char	*name;
+	u8		chan_nr;
+	u8		led_current; /* mA x10, 0 if led is not connected */
+	u8		max_current;
+};
+
+struct lp55xx_platform_data {
+	/* Common Platform Data */
+	struct lp55xx_led_config *led_config;
+	u8	num_channels;
+	u8	clock_mode;
+	int	(*setup_resources)(void);
+	void	(*release_resources)(void);
+	void	(*enable)(bool state);
+	const char *label;
+
+	/* LP5521 Specific Data */
+	u8	update_config;
+};
+
+#endif /* __LINUX_LP55XX_H */
-- 
1.7.9.5


Best Regards,
Milo


