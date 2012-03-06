Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2CFQQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:16:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab2CFQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:16:38 -0500
Date: Tue, 6 Mar 2012 08:15:20 -0800
From: tip-bot for Philip Prindeville <philipp@redfish-solutions.com>
Message-ID: <tip-jv5uf34996juqh5syes8mn4h@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, philipp@redfish-solutions.com,
        akpm@linux-foundation.org, dilinger@queued.net, tglx@linutronix.de,
        a.zummo@towertech.it, mingo@elte.hu, rpurdie@rpsys.net
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, philipp@redfish-solutions.com,
        akpm@linux-foundation.org, dilinger@queued.net, tglx@linutronix.de,
        a.zummo@towertech.it, mingo@elte.hu, rpurdie@rpsys.net
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/geode/net5501:
  Add platform driver for Soekris Engineering net5501
Git-Commit-ID: da4e3302949f4a702f1ddfefe067762232d363d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:15:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da4e3302949f4a702f1ddfefe067762232d363d5
Gitweb:     http://git.kernel.org/tip/da4e3302949f4a702f1ddfefe067762232d363d5
Author:     Philip Prindeville <philipp@redfish-solutions.com>
AuthorDate: Mon, 5 Mar 2012 15:05:15 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:23:56 +0100

x86/geode/net5501: Add platform driver for Soekris Engineering net5501

Add platform driver for the Soekris Engineering net5501 single-board
computer.  Probes well-known locations in ROM for BIOS signature
to confirm correct platform.  Registers 1 LED and 1 GPIO-based
button (typically used for soft reset).

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Matthew Garrett <mjg@redhat.com>
[ Removed Kconfig and Makefile detritus from drivers/leds/]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-jv5uf34996juqh5syes8mn4h@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig                  |    6 ++
 arch/x86/platform/geode/Makefile  |    1 +
 arch/x86/platform/geode/net5501.c |  154 +++++++++++++++++++++++++++++++++++++
 drivers/leds/Kconfig              |   10 ---
 drivers/leds/Makefile             |    1 -
 drivers/leds/leds-net5501.c       |   97 -----------------------
 6 files changed, 161 insertions(+), 108 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c0d4931..e76f1db 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2114,6 +2114,12 @@ config ALIX
 
 	  Note: You have to set alix.force=1 for boards with Award BIOS.
 
+config NET5501
+	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
+	select GPIOLIB
+	---help---
+	  This option enables system support for the Soekris Engineering net5501.
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/platform/geode/Makefile b/arch/x86/platform/geode/Makefile
index 07c9cd0..246b788 100644
--- a/arch/x86/platform/geode/Makefile
+++ b/arch/x86/platform/geode/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_ALIX)		+= alix.o
+obj-$(CONFIG_NET5501)		+= net5501.o
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
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9ca28fc..8c7a75d 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -89,16 +89,6 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
-config LEDS_NET5501
-	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_TRIGGERS
-	depends on X86 && GPIO_CS5535
-	select LEDS_TRIGGER_DEFAULT_ON
-	default n
-	help
-	  Add support for the Soekris net5501 board (detection, error led
-	  and GPIO).
-
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 1fc6875..6bcf4f6 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
-obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
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
