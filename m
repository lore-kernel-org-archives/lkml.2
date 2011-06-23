Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1FWRXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab1FWRXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:44 -0400
Date: Thu, 23 Jun 2011 13:23:43 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172343.27685.12487.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 15/35] drivers/leds changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/leds changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/leds/leds-clevo-mail.c |   78 ++++++++++++++++++----------------------
 drivers/leds/leds-ss4200.c     |   23 +++++-------
 2 files changed, 44 insertions(+), 57 deletions(-)

diff --git a/drivers/leds/leds-clevo-mail.c b/drivers/leds/leds-clevo-mail.c
index a498135..63047de 100644
--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -1,14 +1,10 @@
-
-#include <linux/module.h>
-
-#include <linux/platform_device.h>
 #include <linux/err.h>
-#include <linux/leds.h>
-
-#include <linux/io.h>
-#include <linux/dmi.h>
-
 #include <linux/i8042.h>
+#include <linux/io.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfw.h>
 
 #define CLEVO_MAIL_LED_OFF		0x0084
 #define CLEVO_MAIL_LED_BLINK_1HZ	0x008A
@@ -20,11 +16,12 @@ MODULE_LICENSE("GPL");
 
 static unsigned int __initdata nodetect;
 module_param_named(nodetect, nodetect, bool, 0);
-MODULE_PARM_DESC(nodetect, "Skip DMI hardware detection");
+MODULE_PARM_DESC(nodetect, "Skip SMBIOS hardware detection");
 
 static struct platform_device *pdev;
 
-static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
+static int __init
+clevo_mail_led_smbios_callback(const struct sysfw_id *id)
 {
 	printk(KERN_INFO KBUILD_MODNAME ": '%s' found\n", id->ident);
 	return 1;
@@ -39,55 +36,55 @@ static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
  * detected as working, but in reality it is not) as low as
  * possible.
  */
-static struct dmi_system_id __initdata mail_led_whitelist[] = {
+static struct sysfw_id __initdata mail_led_whitelist[] = {
 	{
-		.callback = clevo_mail_led_dmi_callback,
+		.callback = clevo_mail_led_smbios_callback,
 		.ident = "Clevo D410J",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "VIA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "K8N800"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "VT8204B")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "VIA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "K8N800"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "VT8204B")
 		}
 	},
 	{
-		.callback = clevo_mail_led_dmi_callback,
+		.callback = clevo_mail_led_smbios_callback,
 		.ident = "Clevo M5x0N",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M5x0N")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "CLEVO Co."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "M5x0N")
 		}
 	},
 	{
-		.callback = clevo_mail_led_dmi_callback,
+		.callback = clevo_mail_led_smbios_callback,
 		.ident = "Positivo Mobile",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "CLEVO Co. "),
-			DMI_MATCH(DMI_BOARD_NAME, "M5X0V "),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Positivo Mobile"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "VT6198")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "CLEVO Co. "),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "M5X0V "),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Positivo Mobile"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "VT6198")
 		}
 	},
 	{
-		.callback = clevo_mail_led_dmi_callback,
+		.callback = clevo_mail_led_smbios_callback,
 		.ident = "Clevo D400P",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo"),
-			DMI_MATCH(DMI_BOARD_NAME, "D400P"),
-			DMI_MATCH(DMI_BOARD_VERSION, "Rev.A"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0106")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Clevo"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "D400P"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "Rev.A"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0106")
 		}
 	},
 	{
-		.callback = clevo_mail_led_dmi_callback,
+		.callback = clevo_mail_led_smbios_callback,
 		.ident = "Clevo D410V",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo, Co."),
-			DMI_MATCH(DMI_BOARD_NAME, "D400V/D470V"),
-			DMI_MATCH(DMI_BOARD_VERSION, "SS78B"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev. A1")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "Clevo, Co."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "D400V/D470V"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "SS78B"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "Rev. A1")
 		}
 	},
-	{ }
+	{}
 };
 
 static void clevo_mail_led_set(struct led_classdev *led_cdev,
@@ -176,21 +173,16 @@ static struct platform_driver clevo_mail_led_driver = {
 static int __init clevo_mail_led_init(void)
 {
 	int error = 0;
-	int count = 0;
 
 	/* Check with the help of DMI if we are running on supported hardware */
-	if (!nodetect) {
-		count = dmi_check_system(mail_led_whitelist);
-	} else {
-		count = 1;
+	if (nodetect) {
 		printk(KERN_ERR KBUILD_MODNAME ": Skipping DMI detection. "
 		       "If the driver works on your hardware please "
 		       "report model and the output of dmidecode in tracker "
 		       "at http://sourceforge.net/projects/clevo-mailled/\n");
-	}
-
-	if (!count)
+	} else if (!sysfw_callback(mail_led_whitelist)) {
 		return -ENODEV;
+	}
 
 	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
 	if (!IS_ERR(pdev)) {
diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 614ebeb..0b6b6fa 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -21,13 +21,13 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sysfw.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
@@ -73,7 +73,7 @@ static const struct pci_device_id ich7_lpc_pci_id[] =
 
 MODULE_DEVICE_TABLE(pci, ich7_lpc_pci_id);
 
-static int __init ss4200_led_dmi_callback(const struct dmi_system_id *id)
+static int __init ss4200_led_smbios_callback(const struct sysfw_id *id)
 {
 	pr_info("detected '%s'\n", id->ident);
 	return 1;
@@ -81,7 +81,7 @@ static int __init ss4200_led_dmi_callback(const struct dmi_system_id *id)
 
 static unsigned int __initdata nodetect;
 module_param_named(nodetect, nodetect, bool, 0);
-MODULE_PARM_DESC(nodetect, "Skip DMI-based hardware detection");
+MODULE_PARM_DESC(nodetect, "Skip SMBIOS-based hardware detection");
 
 /*
  * struct nas_led_whitelist - List of known good models
@@ -92,14 +92,14 @@ MODULE_PARM_DESC(nodetect, "Skip DMI-based hardware detection");
  * detected as working, but in reality it is not) as low as
  * possible.
  */
-static struct dmi_system_id __initdata nas_led_whitelist[] = {
+static struct sysfw_id __initdata nas_led_whitelist[] = {
 	{
-		.callback = ss4200_led_dmi_callback,
+		.callback = ss4200_led_smbios_callback,
 		.ident = "Intel SS4200-E",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SS4200-E"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Intel"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "SS4200-E"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "1.00.00")
 		}
 	},
 	{}
@@ -504,16 +504,11 @@ static int __init nas_gpio_init(void)
 {
 	int i;
 	int ret = 0;
-	int nr_devices = 0;
 
-	nr_devices = dmi_check_system(nas_led_whitelist);
 	if (nodetect) {
 		pr_info("skipping hardware autodetection\n");
 		pr_info("Please send 'dmidecode' output to dave@sr71.net\n");
-		nr_devices++;
-	}
-
-	if (nr_devices <= 0) {
+	} else if (!sysfw_callback(nas_led_whitelist)) {
 		pr_info("no LED devices found\n");
 		return -ENODEV;
 	}
-- 
1.7.5.4

