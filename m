Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1D2WdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:33:17 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47069 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1D2WdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:33:15 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: [RFC 4/5] leds: add support for Technologic Systems TS-5500 leds
Date: Fri, 29 Apr 2011 18:21:51 -0400
Message-Id: <1304115712-5299-5-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                |    1 +
 drivers/leds/Kconfig       |   12 +++
 drivers/leds/Makefile      |    1 +
 drivers/leds/leds-ts5500.c |  211 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 225 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-ts5500.c

diff --git a/MAINTAINERS b/MAINTAINERS
index da3b6d3..c0a646d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6061,6 +6061,7 @@ F:	include/linux/ts5xxx-sbcinfo.h
 F:	drivers/gpio/ts5500-gpio.c
 F:	include/linux/ts5500-gpio.h
 F:	drivers/tty/serial/ts5500-auto485.c
+F:	drivers/leds/leds-ts5500.c
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9bec869..14144df 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -379,6 +379,18 @@ config LEDS_NETXBIG
 	  and 5Big Network v2 boards. The LEDs are wired to a CPLD and are
 	  controlled through a GPIO extension bus.
 
+config LEDS_TS5500
+	tristate "LED Support for TS-5500 SBCs"
+	depends on LEDS_CLASS && TS5500_SBC
+	help
+	  This option enables support for on-chip LED drivers found
+	  on Technologic Systems TS-5500 SBCs.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called leds-ts5500.
+
+comment "LED Triggers"
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 39c80fc..ce5a25f 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell-led.o
 obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
+obj-$(CONFIG_LEDS_TS5500)		+= leds-ts5500.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-ts5500.c b/drivers/leds/leds-ts5500.c
new file mode 100644
index 0000000..aec6d71
--- /dev/null
+++ b/drivers/leds/leds-ts5500.c
@@ -0,0 +1,211 @@
+/*
+ * Technologic Systems TS-5500 boards - LED driver
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *	Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
+ *
+ * Portions Copyright (c) 2008 Compulab, Ltd.
+ *	Mike Rapoport <mike@compulab.co.il>
+ *
+ * Portions Copyright (c) 2006-2008 Marvell International Ltd.
+ *	Eric Miao <eric.miao@marvell.com>
+ *
+ * Based on drivers/leds/leds-da903x.c from linux-2.6.32.8.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/ts5xxx-sbcinfo.h>
+#include <linux/io.h>
+
+#define DRIVER_NAME "leds-ts5500"
+
+/**
+ * struct ts5500_led - LED structure
+ * @cdev:		LED class device structure.
+ * @work:		Work structure.
+ * @new_brightness:	LED brightness.
+ * @ioaddr:		LED I/O address.
+ */
+struct ts5500_led {
+	struct led_classdev	cdev;
+	struct work_struct	work;
+	enum led_brightness	new_brightness;
+	int			ioaddr;
+	int			bit;
+};
+
+static void ts5500_led_work(struct work_struct *work)
+{
+	struct ts5500_led *led = container_of(work, struct ts5500_led, work);
+	u8 val = led->new_brightness ? led->bit : 0;
+
+	outb(val, led->ioaddr);
+}
+
+static void ts5500_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct ts5500_led *led = container_of(led_cdev, struct ts5500_led,
+					      cdev);
+
+	led->new_brightness = value;
+	schedule_work(&led->work);
+}
+
+static int __devinit ts5500_led_probe(struct platform_device *pdev)
+{
+	struct led_platform_data *pdata = pdev->dev.platform_data;
+	struct ts5500_led *led;
+	struct resource *res;
+	int ret;
+
+	if (pdata == NULL || !pdata->num_leds) {
+		dev_err(&pdev->dev, "No platform data available\n");
+		return -ENODEV;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get I/O resource\n");
+		return -EBUSY;
+	}
+
+	led = kzalloc(sizeof(struct ts5500_led), GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "Failed to alloc memory for LED device\n");
+		return -ENOMEM;
+	}
+
+	led->cdev.name = pdata->leds[0].name;
+	led->cdev.default_trigger = pdata->leds[0].default_trigger;
+	led->cdev.brightness_set = ts5500_led_set;
+	led->cdev.brightness = LED_OFF;
+
+	led->ioaddr = res->start;
+	led->bit = pdata->leds[0].flags;
+	led->new_brightness = LED_OFF;
+
+	INIT_WORK(&led->work, ts5500_led_work);
+
+	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register LED\n");
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, led);
+	return 0;
+
+err:
+	kfree(led);
+	return ret;
+}
+
+static int __devexit ts5500_led_remove(struct platform_device *pdev)
+{
+	struct ts5500_led *led = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	led_classdev_unregister(&led->cdev);
+	kfree(led);
+
+	return 0;
+}
+
+static struct platform_driver ts5500_led_driver = {
+	.driver	= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ts5500_led_probe,
+	.remove		= __devexit_p(ts5500_led_remove),
+};
+
+
+static struct led_info ts5500_led_info = {
+	.name = DRIVER_NAME,
+	.default_trigger = DRIVER_NAME,
+	.flags = 0x01,
+};
+
+static struct led_platform_data ts5500_led_platform_data = {
+	.num_leds	= 1,
+	.leds		= &ts5500_led_info,
+};
+
+static struct resource ts5500_led_resources[] = {
+	{
+		.name	= DRIVER_NAME,
+		.start	= 0x77,
+		.end	= 0x77,
+		.flags	= IORESOURCE_IO,
+	}
+};
+
+static void ts5500_led_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct platform_device ts5500_led_device = {
+	.name = DRIVER_NAME,
+	.resource = ts5500_led_resources,
+	.num_resources = ARRAY_SIZE(ts5500_led_resources),
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_led_platform_data,
+		.release = ts5500_led_release,
+	},
+};
+
+static int __init ts5500_led_init(void)
+{
+	struct ts5xxx_sbcinfo sbcinfo;
+	int ret;
+
+	ts5xxx_sbcinfo_set(&sbcinfo);
+
+	if (sbcinfo.board_id != 5500) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": Expected TS5500 but TS-SBC reported TS%d\n",
+		       sbcinfo.board_id);
+		return -ENODEV;
+	}
+
+	ret = platform_driver_register(&ts5500_led_driver);
+	if (ret)
+		goto error_out;
+
+	ret = platform_device_register(&ts5500_led_device);
+	if (ret)
+		goto error_device_register;
+
+	return 0;
+
+error_device_register:
+	platform_driver_unregister(&ts5500_led_driver);
+error_out:
+	return ret;
+}
+module_init(ts5500_led_init);
+
+static void __exit ts5500_led_exit(void)
+{
+	platform_driver_unregister(&ts5500_led_driver);
+	platform_device_unregister(&ts5500_led_device);
+}
+module_exit(ts5500_led_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED driver for Technologic Systems TS5500");
+MODULE_AUTHOR("Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>");
-- 
1.7.1

