Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab1KVWEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:04:14 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:34417 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab1KVWEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:04:07 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] samsung-laptop: make the dmi check less strict
Date: Tue, 22 Nov 2011 23:02:44 +0100
Message-Id: <1321999366-23784-14-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enable the driver for everything that look like
a laptop and is from vendor "SAMSUNG ELECTRONICS CO., LTD.".
Note that laptop supported by samsung-q10 seem to have a different
vendor strict.

Also remove every log output until we know that we have a SABI interface
(except if the driver is forced to load, or debug is enabled).

Keeping a whitelist of laptop with a model granularity is something that can't
work without close vendor cooperation (and we don't have that).

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |  235 ++------------------------------
 1 files changed, 15 insertions(+), 220 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index c9f574c..9940525 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1250,7 +1250,8 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 
 	samsung->f0000_segment = ioremap_nocache(0xf0000, 0xffff);
 	if (!samsung->f0000_segment) {
-		pr_err("Can't map the segment at 0xf0000\n");
+		if (debug || force)
+			pr_err("Can't map the segment at 0xf0000\n");
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -1265,7 +1266,8 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 	}
 
 	if (loca == 0xffff) {
-		pr_err("This computer does not support SABI\n");
+		if (debug || force)
+			pr_err("This computer does not support SABI\n");
 		ret = -ENODEV;
 		goto exit;
 	}
@@ -1334,244 +1336,34 @@ static int __init samsung_platform_init(struct samsung_laptop *samsung)
 	return 0;
 }
 
-static int __init dmi_check_cb(const struct dmi_system_id *id)
-{
-	pr_info("found laptop model '%s'\n", id->ident);
-	return 1;
-}
-
 static struct dmi_system_id __initdata samsung_dmi_table[] = {
 	{
-		.ident = "N128",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N128"),
-			DMI_MATCH(DMI_BOARD_NAME, "N128"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "N130",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
-			DMI_MATCH(DMI_BOARD_NAME, "N130"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "N510",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N510"),
-			DMI_MATCH(DMI_BOARD_NAME, "N510"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "X125",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X125"),
-			DMI_MATCH(DMI_BOARD_NAME, "X125"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "X120/X170",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X120/X170"),
-			DMI_MATCH(DMI_BOARD_NAME, "X120/X170"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "NC10",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
-			DMI_MATCH(DMI_BOARD_NAME, "NC10"),
-		},
-		.callback = dmi_check_cb,
-	},
-		{
-		.ident = "NP-Q45",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SQ45S70S"),
-			DMI_MATCH(DMI_BOARD_NAME, "SQ45S70S"),
-		},
-		.callback = dmi_check_cb,
-		},
-	{
-		.ident = "X360",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
-			DMI_MATCH(DMI_BOARD_NAME, "X360"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "R410 Plus",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R410P"),
-			DMI_MATCH(DMI_BOARD_NAME, "R460"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "R518",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,
 					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R518"),
-			DMI_MATCH(DMI_BOARD_NAME, "R518"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
 		},
-		.callback = dmi_check_cb,
 	},
 	{
-		.ident = "R519/R719",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,
 					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R519/R719"),
-			DMI_MATCH(DMI_BOARD_NAME, "R519/R719"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /* Laptop */
 		},
-		.callback = dmi_check_cb,
 	},
 	{
-		.ident = "N150/N210/N220",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,
 					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
-			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
 		},
-		.callback = dmi_check_cb,
 	},
 	{
-		.ident = "N220",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,
 					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N220"),
-			DMI_MATCH(DMI_BOARD_NAME, "N220"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
 		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "N150/N210/N220/N230",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220/N230"),
-			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220/N230"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "N150P/N210P/N220P",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N150P/N210P/N220P"),
-			DMI_MATCH(DMI_BOARD_NAME, "N150P/N210P/N220P"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "R700",
-		.matches = {
-		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-		      DMI_MATCH(DMI_PRODUCT_NAME, "SR700"),
-		      DMI_MATCH(DMI_BOARD_NAME, "SR700"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "R530/R730",
-		.matches = {
-		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-		      DMI_MATCH(DMI_PRODUCT_NAME, "R530/R730"),
-		      DMI_MATCH(DMI_BOARD_NAME, "R530/R730"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "NF110/NF210/NF310",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
-			DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "N145P/N250P/N260P",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
-			DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "R70/R71",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR,
-					"SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R70/R71"),
-			DMI_MATCH(DMI_BOARD_NAME, "R70/R71"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "P460",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P460"),
-			DMI_MATCH(DMI_BOARD_NAME, "P460"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "R528/R728",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "R528/R728"),
-			DMI_MATCH(DMI_BOARD_NAME, "R528/R728"),
-		},
-		.callback = dmi_check_cb,
-	},
-	{
-		.ident = "NC210/NC110",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "NC210/NC110"),
-			DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
-		},
-		.callback = dmi_check_cb,
-	},
-		{
-		.ident = "X520",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X520"),
-			DMI_MATCH(DMI_BOARD_NAME, "X520"),
-		},
-		.callback = dmi_check_cb,
 	},
 	{ },
 };
@@ -1596,12 +1388,9 @@ static int __init samsung_init(void)
 
 #ifdef CONFIG_ACPI
 	/* Don't handle backlight here if the acpi video already handle it */
-	if (acpi_video_backlight_support()) {
-		pr_info("Backlight controlled by ACPI video driver\n");
+	if (acpi_video_backlight_support())
 		samsung->handle_backlight = false;
-	}
 #endif
-
 	ret = samsung_platform_init(samsung);
 	if (ret)
 		goto error_platform;
@@ -1610,6 +1399,12 @@ static int __init samsung_init(void)
 	if (ret)
 		goto error_sabi;
 
+#ifdef CONFIG_ACPI
+	/* Only log that if we are really on a sabi platform */
+	if (acpi_video_backlight_support())
+		pr_info("Backlight controlled by ACPI video driver\n");
+#endif
+
 	ret = samsung_sysfs_init(samsung);
 	if (ret)
 		goto error_sysfs;
-- 
1.7.5.4

