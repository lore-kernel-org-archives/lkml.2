Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1HXUXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:23:49 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:45112 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1HXUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:23:46 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH 3/4] x86: (TS-5500) add LED support
Date: Wed, 24 Aug 2011 16:23:26 -0400
Message-Id: <1314217407-31249-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                            |    1 +
 arch/x86/platform/ts5500/Kconfig       |    7 ++
 arch/x86/platform/ts5500/Makefile      |    3 +-
 arch/x86/platform/ts5500/ts5500.c      |   41 ++++++++++
 arch/x86/platform/ts5500/ts5500_leds.c |  133 ++++++++++++++++++++++++++++++++
 5 files changed, 184 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/platform/ts5500/ts5500_leds.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c6cf870..034a25f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6142,6 +6142,7 @@ F:  arch/x86/platform/ts5500/Makefile
 F:  arch/x86/platform/ts5500/ts5500.c
 F:  arch/x86/platform/ts5500/ts5500_gpio.c
 F:  arch/x86/platform/ts5500/ts5500_gpio.h
+F:  arch/x86/platform/ts5500/ts5500_leds.c
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index bb4ef81..e7fbf34 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -12,3 +12,10 @@ config TS5500_GPIO
 	default y
 	help
 	  This enables support for the DIO headers for GPIO usage.
+
+config TS5500_LEDS
+	bool "TS-5500 LED Support"
+	depends on TS5500 && LEDS_CLASS
+	default y
+	help
+	  This option enables support for the on-chip LED.
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
index 9eb93fe..4d23812 100644
--- a/arch/x86/platform/ts5500/Makefile
+++ b/arch/x86/platform/ts5500/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_TS5500)			+= ts5500.o
-obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
\ No newline at end of file
+obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
+obj-$(CONFIG_TS5500_LEDS)		+= ts5500_leds.o
\ No newline at end of file
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 1ed0097..a455178 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <asm/processor.h>
+#include <linux/leds.h>
 #include <linux/gpio.h>
 #include "ts5500_gpio.h"
 
@@ -143,6 +144,43 @@ error:
 
 #define TS5500_IS_JP_SET(sbc, jmp) (!!(sbc->jumpers & TS5500_JP##jmp))
 
+#ifdef CONFIG_TS5500_LEDS
+static struct led_info ts5500_led_info = {
+	.name = "ts5500_leds",
+	.default_trigger = "ts5500_leds",
+	.flags = TS5500_LED_FLAG
+};
+
+static struct led_platform_data ts5500_led_platform_data = {
+	.num_leds = 1,
+	.leds = &ts5500_led_info
+};
+
+static struct resource ts5500_led_resources[] = {
+	{
+		.name = "ts5500_leds",
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
+	.name = "ts5500_leds",
+	.resource = ts5500_led_resources,
+	.num_resources = ARRAY_SIZE(ts5500_led_resources),
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_led_platform_data,
+		.release = ts5500_led_release
+	}
+};
+#endif
 
 #ifdef CONFIG_TS5500_GPIO
 /* Callback for releasing resources */
@@ -160,6 +198,9 @@ static struct platform_device ts5500_gpio_device = {
 };
 #endif
 static struct platform_device *ts5500_devices[] __initdata = {
+#ifdef CONFIG_TS5500_LEDS
+	&ts5500_led_device,
+#endif
 #ifdef CONFIG_TS5500_GPIO
 	&ts5500_gpio_device,
 #endif
diff --git a/arch/x86/platform/ts5500/ts5500_leds.c b/arch/x86/platform/ts5500/ts5500_leds.c
new file mode 100644
index 0000000..b6be116
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_leds.c
@@ -0,0 +1,133 @@
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
+#include <linux/workqueue.h>
+#include <linux/io.h>
+#include <linux/leds.h>
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
+static struct platform_driver ts5500_led_driver = {
+	.driver = {
+		.name = "ts5500_leds",
+		.owner = THIS_MODULE
+	},
+	.probe = ts5500_led_probe
+};
+
+static const struct platform_device_id ts5500_devices[] = {
+	{ "ts5500_leds", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, ts5500_devices);
+
+static int __init ts5500_led_init(void)
+{
+	return platform_driver_register(&ts5500_led_driver);
+}
+module_init(ts5500_led_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>");
+MODULE_DESCRIPTION("LED driver for Technologic Systems TS-5500");
-- 
1.7.6

