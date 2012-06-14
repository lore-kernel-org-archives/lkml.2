Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2FNLF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:05:27 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39928 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2FNLFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:05:25 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] asus-wmi: control backlight power through WMI, not ACPI
Date: Thu, 14 Jun 2012 13:05:12 +0200
Message-Id: <1339671912-27715-1-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339572727-24744-7-git-send-email-corentin.chary@gmail.com>
References: <1339572727-24744-7-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

BugLink: https://bugs.launchpad.net/bugs/1000146

Some h/w that can adjust screen brightness through ACPI functions, but
can't turn on/off the backlight power correctly. So, we list those h/w in
quirks and try to turn on/off the backlight power through WMI.
Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c  |    5 +++++
 drivers/platform/x86/asus-wmi.h  |    1 +
 drivers/platform/x86/eeepc-wmi.c |   25 ++++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 77aadde..7e89e04 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -47,6 +47,7 @@
 #include <linux/thermal.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <acpi/video.h>
 
 #include "asus-wmi.h"
 
@@ -1681,7 +1682,11 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (err)
 		goto fail_rfkill;
 
+	if (asus->driver->quirks->wmi_backlight_power)
+		acpi_video_dmi_promote_vendor();
 	if (!acpi_video_backlight_support()) {
+		pr_info("Disabling ACPI video driver\n");
+		acpi_video_unregister();
 		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
 			goto fail_backlight;
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index d43b667..9c1da8b 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -39,6 +39,7 @@ struct quirk_entry {
 	bool hotplug_wireless;
 	bool scalar_panel_brightness;
 	bool store_backlight_power;
+	bool wmi_backlight_power;
 	int wapf;
 };
 
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 6567613..5838332 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -79,7 +79,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
 	{ KE_KEY, HOME_PRESS, { KEY_CONFIG } }, /* Home/Express gate key */
 	{ KE_KEY, 0xe8, { KEY_SCREENLOCK } },
-	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
+	{ KE_KEY, 0xe9, { KEY_DISPLAYTOGGLE } },
 	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
 	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
 	{ KE_KEY, 0xed, { KEY_CAMERA_DOWN } },
@@ -107,6 +107,11 @@ static struct quirk_entry quirk_asus_et2012_type3 = {
 	.store_backlight_power = true,
 };
 
+static struct quirk_entry quirk_asus_x101ch = {
+	/* We need this when ACPI function doesn't do this well */
+	.wmi_backlight_power = true,
+};
+
 static struct quirk_entry *quirks;
 
 static void et2012_quirks(void)
@@ -157,6 +162,24 @@ static struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_unknown,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK Computer INC. X101CH",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X101CH"),
+		},
+		.driver_data = &quirk_asus_x101ch,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK Computer INC. 1015CX",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "1015CX"),
+		},
+		.driver_data = &quirk_asus_x101ch,
+	},
 	{},
 };
 
-- 
1.7.9.5

