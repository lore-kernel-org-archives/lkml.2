Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1LaKIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 05:08:36 -0500
Received: from mail.redfish-solutions.com ([66.232.79.143]:48497 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab1LaKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 05:08:34 -0500
From: Philip Prindeville <philipp@redfish-solutions.com>
To: linux-kernel@vger.kernel.org
Cc: Ed Wildgoose <kernel@wildgooses.com>
Subject: [PATCH 1/1] alix2: supplement driver to include GPIO button support
Date: Sat, 31 Dec 2011 03:08:27 -0700
Message-Id: <1325326107-26620-1-git-send-email-philipp@redfish-solutions.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip A. Prindeville" <philipp@redfish-solutions.com>

GPIO 24 is used in reference designs as a soft-reset button, and
the alix2 is no exception. Add it as a gpio-button.

Use symbolic values to describe BIOS addresses.

Record the model number.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Acked-by: Ed Wildgoose <kernel@wildgooses.com>
---
 arch/x86/platform/geode/alix.c |   53 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
index dc5f1d3..a10476d42 100644
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
@@ -24,14 +25,49 @@
 #include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
 
 #include <asm/geode.h>
 
+#define BIOS_SIGNATURE_TINYBIOS		0x000f0000
+#define BIOS_SIGNATURE_COREBOOT		0x00000050
+#define BIOS_REGION_SIZE		0x00010000
+
+static int model = 0;
+
 static bool force = 0;
 module_param(force, bool, 0444);
 /* FIXME: Award bios is not automatically detected as Alix platform */
 MODULE_PARM_DESC(force, "Force detection as ALIX.2/ALIX.3 platform");
 
+static struct gpio_keys_button alix_gpio_buttons[] = {
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
+
+static struct gpio_keys_platform_data alix_buttons_data = {
+	.buttons = alix_gpio_buttons,
+	.nbuttons = ARRAY_SIZE(alix_gpio_buttons),
+	.poll_interval = 20,
+};
+
+static struct platform_device alix_buttons_dev = {
+	.name = "gpio-keys-polled",
+	.id = 1,
+	.dev = {
+		.platform_data = &alix_buttons_data,
+	}
+};
+
 static struct gpio_led alix_leds[] = {
 	{
 		.name = "alix:1",
@@ -64,17 +100,22 @@ static struct platform_device alix_leds_dev = {
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
 
 static int __init alix_present(unsigned long bios_phys,
 				const char *alix_sig,
 				size_t alix_sig_len)
 {
-	const size_t bios_len = 0x00010000;
+	const size_t bios_len = BIOS_REGION_SIZE;
 	const char *bios_virt;
 	const char *scan_end;
 	const char *p;
@@ -109,7 +150,9 @@ static int __init alix_present(unsigned long bios_phys,
 			*a = '\0';
 
 		tail = p + alix_sig_len;
-		if ((tail[0] == '2' || tail[0] == '3')) {
+		if ((tail[0] == '2' || tail[0] == '3' || tail[0] == '6')) {
+			model = tail[0] - '0';
+
 			printk(KERN_INFO
 			       "%s: system is recognized as \"%s\"\n",
 			       KBUILD_MODNAME, name);
@@ -128,8 +171,8 @@ static int __init alix_init(void)
 	if (!is_geode())
 		return 0;
 
-	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
-	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
+	if (alix_present(BIOS_SIGNATURE_TINYBIOS, tinybios_sig, sizeof(tinybios_sig) - 1) ||
+	    alix_present(BIOS_SIGNATURE_COREBOOT, coreboot_sig, sizeof(coreboot_sig) - 1))
 		register_alix();
 
 	return 0;
-- 
1.7.7.4

