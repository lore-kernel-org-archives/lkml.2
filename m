Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2ASADi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:03:38 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:41623 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2ASADh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:03:37 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Vivien Didelot" <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH v4 3/4] x86/platform: (TS-5500) add LED support
Date: Wed, 18 Jan 2012 18:52:10 -0500
Message-Id: <1326930731-21215-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1326930731-21215-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1326930731-21215-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>

Signed-off-by: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/x86/platform/ts5500/Kconfig      |    7 ++
 arch/x86/platform/ts5500/Makefile     |    1 +
 arch/x86/platform/ts5500/ts5500_led.c |  180 +++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/ts5500/ts5500_led.c

diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index 62095c9..76f777f 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -13,3 +13,10 @@ config TS5500_GPIO
 	default y
 	help
 	  This enables support for the DIO headers for GPIO usage.
+
+config TS5500_LED
+	tristate "TS-5500 LED Support"
+	depends on TS5500 && LEDS_CLASS
+	default y
+	help
+	  This option enables support for the on-chip LED.
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
index 71c1398..88eccc9 100644
--- a/arch/x86/platform/ts5500/Makefile
+++ b/arch/x86/platform/ts5500/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_TS5500)			+= ts5500.o
 obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
+obj-$(CONFIG_TS5500_LED)		+= ts5500_led.o
diff --git a/arch/x86/platform/ts5500/ts5500_led.c b/arch/x86/platform/ts5500/ts5500_led.c
new file mode 100644
index 0000000..1c78ec2
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_led.c
@@ -0,0 +1,180 @@
+/*
+ * Technologic Systems TS-5500 boards - LED driver
+ *
+ * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
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
+#include <linux/io.h>
+#include <linux/leds.h>
+#include "ts5500.h"
+
+/**
+ * struct ts5500_led - LED structure
+ * @cdev:		LED class device structure.
+ * @ioaddr:		LED I/O address.
+ */
+struct ts5500_led {
+	struct led_classdev	cdev;
+	int			ioaddr;
+	int			bit;
+};
+
+static void ts5500_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct ts5500_led *led = container_of(led_cdev, struct ts5500_led,
+					      cdev);
+	outb(!!value, led->ioaddr);
+}
+
+static struct led_info ts5500_led_info = {
+	.name = "ts5500_led",
+	.default_trigger = "ts5500_led",
+	.flags = TS5500_LED_MASK
+};
+
+static struct led_platform_data ts5500_led_platform_data = {
+	.num_leds = 1,
+	.leds = &ts5500_led_info
+};
+
+static struct resource ts5500_led_resources[] = {
+	{
+		.name = "ts5500_led",
+		.start = TS5500_LED_JMPRS_REG,
+		.end = TS5500_LED_JMPRS_REG,
+		.flags = IORESOURCE_IO
+	}
+};
+
+static void ts5500_led_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct platform_device ts5500_led_device = {
+	.name = "ts5500_led",
+	.resource = ts5500_led_resources,
+	.num_resources = ARRAY_SIZE(ts5500_led_resources),
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_led_platform_data,
+		.release = ts5500_led_release
+	}
+};
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
+	.driver = {
+		.name = "ts5500_led",
+		.owner = THIS_MODULE
+	},
+	.probe = ts5500_led_probe,
+	.remove = __devexit_p(ts5500_led_remove)
+};
+
+static int __init ts5500_led_init(void)
+{
+	int ret;
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
+MODULE_AUTHOR("Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>");
+MODULE_DESCRIPTION("LED driver for Technologic Systems TS-5500");
-- 
1.7.6.5

