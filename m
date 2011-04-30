Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1D3R7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:59:38 -0400
Received: from relay.ptn-ipout01.plus.net ([212.159.7.35]:55147 "EHLO
	relay.ptn-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab1D3R7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:59:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnYZAB9NvE3Unw4U/2dsb2JhbACCNIJfkw2Nd3ezFQKGPokXDoVyBJMSg36GCw
Subject: [PATCH 2/2] leds: Add ASIC3 LED support
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <rpurdie@rpsys.net>
Date: Sat, 30 Apr 2011 17:59:31 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QGES4-0007ft-Ee@outmx08.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LED support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and leds/leds-asic3 drivers. An example configuration is provided by the pxa/hx4700 platform.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
diff -uprN clean-2.6.39-rc5/drivers/leds/Kconfig linux-2.6.39-rc5/drivers/leds/Kconfig
--- clean-2.6.39-rc5/drivers/leds/Kconfig	2011-04-28 11:18:14.818578777 +0100
+++ linux-2.6.39-rc5/drivers/leds/Kconfig	2011-04-30 16:39:48.434871549 +0100
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
diff -uprN clean-2.6.39-rc5/drivers/leds/Makefile linux-2.6.39-rc5/drivers/leds/Makefile
--- clean-2.6.39-rc5/drivers/leds/Makefile	2011-04-28 11:18:14.818578777 +0100
+++ linux-2.6.39-rc5/drivers/leds/Makefile	2011-04-30 15:44:30.288890098 +0100
@@ -42,6 +42,7 @@ obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell
 obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
+obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -uprN clean-2.6.39-rc5/drivers/leds/leds-asic3.c linux-2.6.39-rc5/drivers/leds/leds-asic3.c
--- clean-2.6.39-rc5/drivers/leds/leds-asic3.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.39-rc5/drivers/leds/leds-asic3.c	2011-04-30 16:39:41.066821912 +0100
@@ -0,0 +1,167 @@
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
+#define MS_TO_CLK(ms)	((((ms)*1024)+16000)/32000)     /* Round to nearest */
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
+	struct asic3_led *led = mfd_get_data(pdev);
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
+	struct asic3_led *led = mfd_get_data(pdev);
+
+	led_classdev_unregister(led->cdev);
+
+	kfree(led->cdev);
+
+	(void) mfd_cell_disable(pdev);
+
+	return 0;
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

