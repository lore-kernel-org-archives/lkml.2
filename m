Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2CFQPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:15:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2CFQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:15:00 -0500
Date: Tue, 6 Mar 2012 08:13:58 -0800
From: tip-bot for Philip Prindeville <philipp@redfish-solutions.com>
Message-ID: <tip-sjp6k1rjksitx1pej0c0qxd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, kernel@wildgooses.com, philipp@redfish-solutions.com,
        akpm@linux-foundation.org, dilinger@queued.net, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, kernel@wildgooses.com,
        philipp@redfish-solutions.com, akpm@linux-foundation.org,
        dilinger@queued.net, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/geode/alix2:
  Supplement driver to include GPIO button support
Git-Commit-ID: 373913b568cbfbefcee3263b98bd5a1a8b491f1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:14:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  373913b568cbfbefcee3263b98bd5a1a8b491f1b
Gitweb:     http://git.kernel.org/tip/373913b568cbfbefcee3263b98bd5a1a8b491f1b
Author:     Philip Prindeville <philipp@redfish-solutions.com>
AuthorDate: Mon, 5 Mar 2012 15:05:14 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:23:56 +0100

x86/geode/alix2: Supplement driver to include GPIO button support

GPIO 24 is used in reference designs as a soft-reset button, and
the alix2 is no exception.  Add it as a gpio-button.

Use symbolic values to describe BIOS addresses.

Record the model number.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Acked-by: Ed Wildgoose <kernel@wildgooses.com>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-sjp6k1rjksitx1pej0c0qxd1@git.kernel.org
[ tidied up the code a bit ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/geode/alix.c |   76 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
index dc5f1d3..90e23e7 100644
--- a/arch/x86/platform/geode/alix.c
+++ b/arch/x86/platform/geode/alix.c
@@ -6,6 +6,7 @@
  *
  * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
  * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
  *
  * TODO: There are large similarities with leds-net5501.c
  * by Alessandro Zummo <a.zummo@towertech.it>
@@ -24,14 +25,47 @@
 #include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+#include <linux/dmi.h>
 
 #include <asm/geode.h>
 
+#define BIOS_SIGNATURE_TINYBIOS		0xf0000
+#define BIOS_SIGNATURE_COREBOOT		0x500
+#define BIOS_REGION_SIZE		0x10000
+
 static bool force = 0;
 module_param(force, bool, 0444);
 /* FIXME: Award bios is not automatically detected as Alix platform */
 MODULE_PARM_DESC(force, "Force detection as ALIX.2/ALIX.3 platform");
 
+static struct gpio_keys_button alix_gpio_buttons[] = {
+	{
+		.code			= KEY_RESTART,
+		.gpio			= 24,
+		.active_low		= 1,
+		.desc			= "Reset button",
+		.type			= EV_KEY,
+		.wakeup			= 0,
+		.debounce_interval	= 100,
+		.can_disable		= 0,
+	}
+};
+static struct gpio_keys_platform_data alix_buttons_data = {
+	.buttons			= alix_gpio_buttons,
+	.nbuttons			= ARRAY_SIZE(alix_gpio_buttons),
+	.poll_interval			= 20,
+};
+
+static struct platform_device alix_buttons_dev = {
+	.name				= "gpio-keys-polled",
+	.id				= 1,
+	.dev = {
+		.platform_data		= &alix_buttons_data,
+	}
+};
+
 static struct gpio_led alix_leds[] = {
 	{
 		.name = "alix:1",
@@ -64,17 +98,22 @@ static struct platform_device alix_leds_dev = {
 	.dev.platform_data = &alix_leds_data,
 };
 
+static struct __initdata platform_device *alix_devs[] = {
+	&alix_buttons_dev,
+	&alix_leds_dev,
+};
+
 static void __init register_alix(void)
 {
 	/* Setup LED control through leds-gpio driver */
-	platform_device_register(&alix_leds_dev);
+	platform_add_devices(alix_devs, ARRAY_SIZE(alix_devs));
 }
 
-static int __init alix_present(unsigned long bios_phys,
+static bool __init alix_present(unsigned long bios_phys,
 				const char *alix_sig,
 				size_t alix_sig_len)
 {
-	const size_t bios_len = 0x00010000;
+	const size_t bios_len = BIOS_REGION_SIZE;
 	const char *bios_virt;
 	const char *scan_end;
 	const char *p;
@@ -84,7 +123,7 @@ static int __init alix_present(unsigned long bios_phys,
 		printk(KERN_NOTICE "%s: forced to skip BIOS test, "
 		       "assume system is ALIX.2/ALIX.3\n",
 		       KBUILD_MODNAME);
-		return 1;
+		return true;
 	}
 
 	bios_virt = phys_to_virt(bios_phys);
@@ -109,15 +148,33 @@ static int __init alix_present(unsigned long bios_phys,
 			*a = '\0';
 
 		tail = p + alix_sig_len;
-		if ((tail[0] == '2' || tail[0] == '3')) {
+		if ((tail[0] == '2' || tail[0] == '3' || tail[0] == '6')) {
 			printk(KERN_INFO
 			       "%s: system is recognized as \"%s\"\n",
 			       KBUILD_MODNAME, name);
-			return 1;
+			return true;
 		}
 	}
 
-	return 0;
+	return false;
+}
+
+static bool __init alix_present_dmi(void)
+{
+	const char *vendor, *product;
+
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor || strcmp(vendor, "PC Engines"))
+		return false;
+
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product || (strcmp(product, "ALIX.2D") && strcmp(product, "ALIX.6")))
+		return false;
+
+	printk(KERN_INFO "%s: system is recognized as \"%s %s\"\n",
+	       KBUILD_MODNAME, vendor, product);
+
+	return true;
 }
 
 static int __init alix_init(void)
@@ -128,8 +185,9 @@ static int __init alix_init(void)
 	if (!is_geode())
 		return 0;
 
-	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
-	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
+	if (alix_present(BIOS_SIGNATURE_TINYBIOS, tinybios_sig, sizeof(tinybios_sig) - 1) ||
+	    alix_present(BIOS_SIGNATURE_COREBOOT, coreboot_sig, sizeof(coreboot_sig) - 1) ||
+	    alix_present_dmi())
 		register_alix();
 
 	return 0;
