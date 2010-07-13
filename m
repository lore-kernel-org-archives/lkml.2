Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0GMHzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:55:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45825 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab0GMHzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DNokemL1eN4ngXubUKpjpYQzIQjNeoI1kGrXl4fg28w17Q7fpUTwxtxlC6OhQprw6l
         Yxjx/9zIU2LCDDNZQ3rrQdPSTcAl8KgMBs4JlEQ+82xBhdjiAmdNcSUd3eqDj77/7bl7
         i8tBlWp9eXFFJLV51ijtOhh7uGPABrVtHDpZ4=
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: mjg@redhat.com, gregkh@suse.de, jlee@novell.com, Dennis.Jansen@web.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Support MSI Poulsbo netbook U110/U115
Date: Tue, 13 Jul 2010 15:54:45 +0800
Message-Id: <1279007685-11993-1-git-send-email-jlee@novell.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSI U110/U115's DSDT have opregion declare, but i915 drm driver
does not support Poulsbo ship. It causes the acpi backlight control
interface not generate by i915 drm driver.
But, we are sure the MSI Poulsbo netbook U110/U115 have workable
_BCM,_BQC implementation in DSDT and it control brightness by using
EC but not opregion.

So, put a dmi detection in msi-laptop driver and also add wlan/bluetooth
rfkill support on U110/U115.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/platform/x86/msi-laptop.c |   41 +++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index afd762b..5f62ad8 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -60,6 +60,7 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/i8042.h>
+#include <acpi/video.h>
 
 #define MSI_DRIVER_VERSION "0.5"
 
@@ -524,6 +525,42 @@ static struct dmi_system_id __initdata msi_load_scm_models_dmi_table[] = {
 		},
 		.callback = dmi_check_cb
 	},
+	{
+		.ident = "MSI U110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U110"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "MSI U115",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U115"),
+		},
+		.callback = dmi_check_cb
+	},
+	{ }
+};
+
+static struct dmi_system_id __initdata msi_poulsbo_dmi_table[] = {
+	{
+		.ident = "MSI U110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U110"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "MSI U115",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U115"),
+		},
+		.callback = dmi_check_cb
+	},
 	{ }
 };
 
@@ -801,6 +838,8 @@ static int __init msi_init(void)
 	if (acpi_video_backlight_support()) {
 		printk(KERN_INFO "MSI: Brightness ignored, must be controlled "
 		       "by ACPI video driver\n");
+		if (dmi_check_system(msi_poulsbo_dmi_table))
+			acpi_video_register();
 	} else {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
@@ -919,3 +958,5 @@ MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
 MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N051:*");
 MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N014:*");
 MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnCR620:*");
+MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnU110:*");
+MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnU115:*");
-- 
1.6.0.2

