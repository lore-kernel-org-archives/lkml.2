Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1EMSxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:53:01 -0400
Received: from relay.pcl-ipout01.plus.net ([212.159.7.99]:43540 "EHLO
	relay.pcl-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab1EMSxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:53:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMWAPN8zU1UXeb6/2dsb2JhbACCNIJkkj6OMne1HAKHIIkdDoYHBJQ1hByGJw
Subject: [PATCH v4 1/2] mfd: Add ASIC3 LED support
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <sameo@linux.intel.com>, <philipp.zabel@gmail.com>
Date: Fri, 13 May 2011 18:52:56 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QKxTt-0007mc-JV@outmx05.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LED support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and leds/leds-asic3 drivers. An example configuration is provided by the pxa/hx4700 platform.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
Identical to v3 but submitted as 2 separate patches as requested: one for the LED driver and the asic3.h changes and a second one for the asic3.c changes.
diff -uprN clean-2.6.39-rc7/drivers/leds/Kconfig linux-2.6.39-rc7/drivers/leds/Kconfig
--- clean-2.6.39-rc7/drivers/leds/Kconfig	2011-05-11 00:54:16.419282175 +0100
+++ linux-2.6.39-rc7/drivers/leds/Kconfig	2011-05-13 19:38:51.178956499 +0100
@@ -379,6 +379,16 @@ config LEDS_NETXBIG
 	  and 5Big Network v2 boards. The LEDs are wired to a CPLD and are
 	  controlled through a GPIO extension bus.
 
+config LEDS_ASIC3
+	bool "LED support for the HTC ASIC3"
+	depends on MFD_ASIC3
+	default y
+	help
+	  This option enables support for the LEDs on the HTC ASIC3. The HTC
+	  ASIC3 LED GPIOs are inputs, not outputs, thus the leds-gpio driver
+	  cannot be used. This driver supports hardware blinking with an on+off
+	  period from 62ms to 125s. Say Y to enable LEDs on the HP iPAQ hx4700.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff -uprN clean-2.6.39-rc7/drivers/leds/Makefile linux-2.6.39-rc7/drivers/leds/Makefile
--- clean-2.6.39-rc7/drivers/leds/Makefile	2011-05-11 00:54:16.419282175 +0100
+++ linux-2.6.39-rc7/drivers/leds/Makefile	2011-05-13 19:38:51.178956499 +0100
@@ -42,6 +42,7 @@ obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell
 obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
+obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -uprN clean-2.6.39-rc7/drivers/leds/leds-asic3.c linux-2.6.39-rc7/drivers/leds/leds-asic3.c
--- clean-2.6.39-rc7/drivers/leds/leds-asic3.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.39-rc7/drivers/leds/leds-asic3.c	2011-05-13 19:38:51.178956499 +0100
@@ -0,0 +1,165 @@
+/*
+ *  Copyright (C) 2011 Paul Parsons <lost.distance@yahoo.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/asic3.h>
+#include <linux/mfd/core.h>
+
+/*
+ *	The HTC ASIC3 LED GPIOs are inputs, not outputs.
+ *	Hence we turn the LEDs on/off via the TimeBase register.
+ */
+
+/*
+ *	When TimeBase is 4 the clock resolution is about 32Hz.
+ *	This driver supports hardware blinking with an on+off
+ *	period from 62ms (2 clocks) to 125s (4000 clocks).
+ */
+#define MS_TO_CLK(ms)	DIV_ROUND_CLOSEST(((ms)*1024), 32000)
+#define CLK_TO_MS(clk)	(((clk)*32000)/1024)
+#define MAX_CLK		4000            /* Fits into 12-bit Time registers */
+#define MAX_MS		CLK_TO_MS(MAX_CLK)
+
+static const unsigned int led_n_base[ASIC3_NUM_LEDS] = {
+	[0] = ASIC3_LED_0_Base,
+	[1] = ASIC3_LED_1_Base,
+	[2] = ASIC3_LED_2_Base,
+};
+
+static void brightness_set(struct led_classdev *cdev,
+	enum led_brightness value)
+{
+	struct platform_device *pdev = to_platform_device(cdev->dev->parent);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+	u32 timebase;
+	unsigned int base;
+
+	timebase = (value == LED_OFF) ? 0 : (LED_EN|0x4);
+
+	base = led_n_base[cell->id];
+	asic3_write_register(asic, (base + ASIC3_LED_PeriodTime), 32);
+	asic3_write_register(asic, (base + ASIC3_LED_DutyTime), 32);
+	asic3_write_register(asic, (base + ASIC3_LED_AutoStopCount), 0);
+	asic3_write_register(asic, (base + ASIC3_LED_TimeBase), timebase);
+}
+
+static int blink_set(struct led_classdev *cdev,
+	unsigned long *delay_on,
+	unsigned long *delay_off)
+{
+	struct platform_device *pdev = to_platform_device(cdev->dev->parent);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+	u32 on;
+	u32 off;
+	unsigned int base;
+
+	if (*delay_on > MAX_MS || *delay_off > MAX_MS)
+		return -EINVAL;
+
+	if (*delay_on == 0 && *delay_off == 0) {
+		/* If both are zero then a sensible default should be chosen */
+		on = MS_TO_CLK(500);
+		off = MS_TO_CLK(500);
+	} else {
+		on = MS_TO_CLK(*delay_on);
+		off = MS_TO_CLK(*delay_off);
+		if ((on + off) > MAX_CLK)
+			return -EINVAL;
+	}
+
+	base = led_n_base[cell->id];
+	asic3_write_register(asic, (base + ASIC3_LED_PeriodTime), (on + off));
+	asic3_write_register(asic, (base + ASIC3_LED_DutyTime), on);
+	asic3_write_register(asic, (base + ASIC3_LED_AutoStopCount), 0);
+	asic3_write_register(asic, (base + ASIC3_LED_TimeBase), (LED_EN|0x4));
+
+	*delay_on = CLK_TO_MS(on);
+	*delay_off = CLK_TO_MS(off);
+
+	return 0;
+}
+
+static int __devinit asic3_led_probe(struct platform_device *pdev)
+{
+	struct asic3_led *led = pdev->dev.platform_data;
+	int ret;
+
+	ret = mfd_cell_enable(pdev);
+	if (ret < 0)
+		goto ret0;
+
+	led->cdev = kzalloc(sizeof(struct led_classdev), GFP_KERNEL);
+	if (!led->cdev) {
+		ret = -ENOMEM;
+		goto ret1;
+	}
+
+	led->cdev->name = led->name;
+	led->cdev->default_trigger = led->default_trigger;
+	led->cdev->brightness_set = brightness_set;
+	led->cdev->blink_set = blink_set;
+
+	ret = led_classdev_register(&pdev->dev, led->cdev);
+	if (ret < 0)
+		goto ret2;
+
+	return 0;
+
+ret2:
+	kfree(led->cdev);
+ret1:
+	(void) mfd_cell_disable(pdev);
+ret0:
+	return ret;
+}
+
+static int __devexit asic3_led_remove(struct platform_device *pdev)
+{
+	struct asic3_led *led = pdev->dev.platform_data;
+
+	led_classdev_unregister(led->cdev);
+
+	kfree(led->cdev);
+
+	return mfd_cell_disable(pdev);
+}
+
+static struct platform_driver asic3_led_driver = {
+	.probe		= asic3_led_probe,
+	.remove		= __devexit_p(asic3_led_remove),
+	.driver		= {
+		.name	= "leds-asic3",
+		.owner	= THIS_MODULE,
+	},
+};
+
+MODULE_ALIAS("platform:leds-asic3");
+
+static int __init asic3_led_init(void)
+{
+	return platform_driver_register(&asic3_led_driver);
+}
+
+static void __exit asic3_led_exit(void)
+{
+	platform_driver_unregister(&asic3_led_driver);
+}
+
+module_init(asic3_led_init);
+module_exit(asic3_led_exit);
+
+MODULE_AUTHOR("Paul Parsons <lost.distance@yahoo.com>");
+MODULE_DESCRIPTION("HTC ASIC3 LED driver");
+MODULE_LICENSE("GPL");
diff -uprN clean-2.6.39-rc7/include/linux/mfd/asic3.h linux-2.6.39-rc7/include/linux/mfd/asic3.h
--- clean-2.6.39-rc7/include/linux/mfd/asic3.h	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.39-rc7/include/linux/mfd/asic3.h	2011-05-13 19:38:51.178956499 +0100
@@ -16,6 +16,13 @@
 
 #include <linux/types.h>
 
+struct led_classdev;
+struct asic3_led {
+	const char	*name;
+	const char	*default_trigger;
+	struct led_classdev *cdev;
+};
+
 struct asic3_platform_data {
 	u16 *gpio_config;
 	unsigned int gpio_config_num;
@@ -23,6 +30,8 @@ struct asic3_platform_data {
 	unsigned int irq_base;
 
 	unsigned int gpio_base;
+
+	struct asic3_led *leds;
 };
 
 #define ASIC3_NUM_GPIO_BANKS	4
@@ -111,9 +120,9 @@ struct asic3_platform_data {
 #define ASIC3_GPIOA11_PWM0		ASIC3_CONFIG_GPIO(11, 1, 1, 0)
 #define ASIC3_GPIOA12_PWM1		ASIC3_CONFIG_GPIO(12, 1, 1, 0)
 #define ASIC3_GPIOA15_CONTROL_CX	ASIC3_CONFIG_GPIO(15, 1, 1, 0)
-#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 1, 0)
-#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 1, 0)
-#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 1, 0)
+#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 0, 0)
+#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 0, 0)
+#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 0, 0)
 #define ASIC3_GPIOC3_SPI_RXD		ASIC3_CONFIG_GPIO(35, 1, 0, 0)
 #define ASIC3_GPIOC4_CF_nCD		ASIC3_CONFIG_GPIO(36, 1, 0, 0)
 #define ASIC3_GPIOC4_SPI_TXD		ASIC3_CONFIG_GPIO(36, 1, 1, 0)
@@ -152,6 +161,7 @@ struct asic3_platform_data {
 #define PWM_TIMEBASE_VALUE(x)    ((x)&0xf)   /* Low 4 bits sets time base */
 #define PWM_TIMEBASE_ENABLE     (1 << 4)   /* Enable clock */
 
+#define ASIC3_NUM_LEDS                  3
 #define ASIC3_LED_0_Base                0x0700
 #define ASIC3_LED_1_Base                0x0800
 #define ASIC3_LED_2_Base 		      0x0900
@@ -293,4 +303,10 @@ struct asic3_platform_data {
 #define ASIC3_MAP_SIZE_32BIT	0x2000
 #define ASIC3_MAP_SIZE_16BIT	0x1000
 
+/* Functions needed by leds-asic3 */
+
+struct asic3;
+extern void asic3_write_register(struct asic3 *asic, unsigned int reg, u32 val);
+extern u32 asic3_read_register(struct asic3 *asic, unsigned int reg);
+
 #endif /* __ASIC3_H__ */

