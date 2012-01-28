Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab2A1FDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 00:03:00 -0500
Received: from mail.redfish-solutions.com ([66.232.79.143]:54874 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab2A1FC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 00:02:59 -0500
From: Philip Prindeville <philipp@redfish-solutions.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] net5501: platform driver for Soekris Engineering net5501 single-board computer
Date: Fri, 27 Jan 2012 22:02:19 -0700
Message-Id: <1327726939-20845-1-git-send-email-philipp@redfish-solutions.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1325323722-25930-1-git-send-email-philipp@redfish-solutions.com>
References: <1325323722-25930-1-git-send-email-philipp@redfish-solutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip A. Prindeville" <philipp@redfish-solutions.com>

Andrew: this is from the console when booting 3.2.1:

[    0.308194] platform rtc_cmos: registered platform RTC device (no PNP device
found)
[    0.325158] net5501: system is recognized as "net5501"
[    0.375991] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.390948] JFFS2 version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY
) (c) 2001-2006 Red Hat, Inc.
[    0.400301] msgmni has been set to 500
[    0.412818] io scheduler noop registered
[    0.416325] io scheduler deadline registered (default)

so the driver seems to be working as expected.

---
Trivial platform driver for Soekris Engineering net5501 single-board
computer. Probes well-known locations in ROM for BIOS signature to
confirm correct platform. Registers 1 LED and 1 GPIO-based button
(typically used for soft reset).

Changes in v2 per Andrew:
Bug out early if ioremap() fails.
Elevate warning message for ioremap() failure to KERN_ERR.
Remove duplicated calls to is_geode() and net5501_register().

Other changes in v2:
Prefix printk() messages with KBUILD_MODNAME.
Add missing <linux/module.h> #include.
Add missing newline to ioremap() error message.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
---
 arch/x86/Kconfig                  |    6 ++
 arch/x86/platform/geode/Makefile  |    1 +
 arch/x86/platform/geode/net5501.c |  154 +++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-net5501.c       |   97 -----------------------
 4 files changed, 161 insertions(+), 97 deletions(-)
 create mode 100644 arch/x86/platform/geode/net5501.c
 delete mode 100644 drivers/leds/leds-net5501.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2f18a15..7a4f34b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2174,6 +2174,12 @@ config GEOS
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
 
+config NET5501
+	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
+	select GPIOLIB
+	---help---
+	  This option enables system support for the Soekris Engineering net5501.
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/platform/geode/Makefile b/arch/x86/platform/geode/Makefile
index d8ba564..5b51194 100644
--- a/arch/x86/platform/geode/Makefile
+++ b/arch/x86/platform/geode/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ALIX)		+= alix.o
+obj-$(CONFIG_NET5501)		+= net5501.o
 obj-$(CONFIG_GEOS)		+= geos.o
diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
new file mode 100644
index 0000000..66d377e
--- /dev/null
+++ b/arch/x86/platform/geode/net5501.c
@@ -0,0 +1,154 @@
+/*
+ * System Specific setup for Soekris net5501
+ * At the moment this means setup of GPIO control of LEDs and buttons
+ * on net5501 boards.
+ *
+ *
+ * Copyright (C) 2008-2009 Tower Technologies
+ * Written by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
+ * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+#include <asm/geode.h>
+
+#define BIOS_REGION_BASE		0xffff0000
+#define BIOS_REGION_SIZE		0x00010000
+
+static struct gpio_keys_button net5501_gpio_buttons[] = {
+	{
+		.code = KEY_RESTART,
+		.gpio = 24,
+		.active_low = 1,
+		.desc = "Reset button",
+		.type = EV_KEY,
+		.wakeup = 0,
+		.debounce_interval = 100,
+		.can_disable = 0,
+	}
+};
+static struct gpio_keys_platform_data net5501_buttons_data = {
+	.buttons = net5501_gpio_buttons,
+	.nbuttons = ARRAY_SIZE(net5501_gpio_buttons),
+	.poll_interval = 20,
+};
+
+static struct platform_device net5501_buttons_dev = {
+	.name = "gpio-keys-polled",
+	.id = 1,
+	.dev = {
+		.platform_data = &net5501_buttons_data,
+	}
+};
+
+static struct gpio_led net5501_leds[] = {
+	{
+		.name = "net5501:1",
+		.gpio = 6,
+		.default_trigger = "default-on",
+		.active_low = 1,
+	},
+};
+
+static struct gpio_led_platform_data net5501_leds_data = {
+	.num_leds = ARRAY_SIZE(net5501_leds),
+	.leds = net5501_leds,
+};
+
+static struct platform_device net5501_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &net5501_leds_data,
+};
+
+static struct __initdata platform_device *net5501_devs[] = {
+	&net5501_buttons_dev,
+	&net5501_leds_dev,
+};
+
+static void __init register_net5501(void)
+{
+	/* Setup LED control through leds-gpio driver */
+	platform_add_devices(net5501_devs, ARRAY_SIZE(net5501_devs));
+}
+
+struct net5501_board {
+	u16	offset;
+	u16	len;
+	char	*sig;
+};
+
+static struct net5501_board __initdata boards[] = {
+	{ 0xb7b, 7, "net5501" },	/* net5501 v1.33/1.33c */
+	{ 0xb1f, 7, "net5501" },	/* net5501 v1.32i */
+};
+
+static bool __init net5501_present(void)
+{
+	int i;
+	unsigned char *rombase, *bios;
+	bool found = false;
+
+	rombase = ioremap(BIOS_REGION_BASE, BIOS_REGION_SIZE - 1);
+	if (!rombase) {
+		printk(KERN_ERR "%s: failed to get rombase\n", KBUILD_MODNAME);
+		return found;
+	}
+
+	bios = rombase + 0x20;	/* null terminated */
+
+	if (memcmp(bios, "comBIOS", 7))
+		goto unmap;
+
+	for (i = 0; i < ARRAY_SIZE(boards); i++) {
+		unsigned char *model = rombase + boards[i].offset;
+
+		if (!memcmp(model, boards[i].sig, boards[i].len)) {
+			printk(KERN_INFO "%s: system is recognized as \"%s\"\n",
+			       KBUILD_MODNAME, model);
+
+			found = true;
+			break;
+		}
+	}
+
+unmap:
+	iounmap(rombase);
+	return found;
+}
+
+static int __init net5501_init(void)
+{
+	if (!is_geode())
+		return 0;
+
+	if (!net5501_present())
+		return 0;
+
+	register_net5501();
+
+	return 0;
+}
+
+module_init(net5501_init);
+
+MODULE_AUTHOR("Philip Prindeville <philipp@redfish-solutions.com>");
+MODULE_DESCRIPTION("Soekris net5501 System Setup");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/leds-net5501.c b/drivers/leds/leds-net5501.c
deleted file mode 100644
index 0555d47..0000000
--- a/drivers/leds/leds-net5501.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Soekris board support code
- *
- * Copyright (C) 2008-2009 Tower Technologies
- * Written by Alessandro Zummo <a.zummo@towertech.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/string.h>
-#include <linux/leds.h>
-#include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/module.h>
-
-#include <asm/geode.h>
-
-static const struct gpio_led net5501_leds[] = {
-	{
-		.name = "error",
-		.gpio = 6,
-		.default_trigger = "default-on",
-	},
-};
-
-static struct gpio_led_platform_data net5501_leds_data = {
-	.num_leds = ARRAY_SIZE(net5501_leds),
-	.leds = net5501_leds,
-};
-
-static struct platform_device net5501_leds_dev = {
-	.name = "leds-gpio",
-	.id = -1,
-	.dev.platform_data = &net5501_leds_data,
-};
-
-static void __init init_net5501(void)
-{
-	platform_device_register(&net5501_leds_dev);
-}
-
-struct soekris_board {
-	u16	offset;
-	char	*sig;
-	u8	len;
-	void	(*init)(void);
-};
-
-static struct soekris_board __initdata boards[] = {
-	{ 0xb7b, "net5501", 7, init_net5501 },	/* net5501 v1.33/1.33c */
-	{ 0xb1f, "net5501", 7, init_net5501 },	/* net5501 v1.32i */
-};
-
-static int __init soekris_init(void)
-{
-	int i;
-	unsigned char *rombase, *bios;
-
-	if (!is_geode())
-		return 0;
-
-	rombase = ioremap(0xffff0000, 0xffff);
-	if (!rombase) {
-		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");
-		return 0;
-	}
-
-	bios = rombase + 0x20;	/* null terminated */
-
-	if (strncmp(bios, "comBIOS", 7))
-		goto unmap;
-
-	for (i = 0; i < ARRAY_SIZE(boards); i++) {
-		unsigned char *model = rombase + boards[i].offset;
-
-		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
-			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
-
-			if (boards[i].init)
-				boards[i].init();
-			break;
-		}
-	}
-
-unmap:
-	iounmap(rombase);
-	return 0;
-}
-
-arch_initcall(soekris_init);
-
-MODULE_LICENSE("GPL");
-- 
1.7.7.5

