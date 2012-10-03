Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2JCJ23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:28:29 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59349 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2JCJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:28:23 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] asus-wmi: add display toggle quirk
Date: Wed,  3 Oct 2012 11:26:31 +0200
Message-Id: <1349256392-20320-9-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
References: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

For machines with AMD graphic chips, it will send out WMI event and ACPI
interrupt at the same time while hitting the hotkey. BIOS will notify the
system the next display output mode throught WMI event code, so that
windows' application can show an OSD to tell the user which mode will be
taken effect. User can hit the display toggle key many times within 2
seconds to choose the mode they want. After 2 seconds, WMI dirver should
send a WMIMethod(SDSP) command to tell the BIOS which mode the user chose.
And then BIOS will raise another ACPI interrupt to tell the system to
really switch the display mode.

In Linux desktop, we don't have this kind of OSD to let users to choose
the mode they want, so we don't need to call WMIMethod(SDSP) to have
another ACPI interrupt. To simplify the problem, we just have to ignore
the WMI event, and let the first ACPI interrupt to send out the key event.

For the need, here comes another quirk to add machines with this kind of
behavior. When the WMI driver receives the display toggle WMI event, and
found the machin is in the list, it will do nothing and let ACPI video
driver to report the key event.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-nb-wmi.c |   31 ++++++++++++++++++++++++++++++-
 drivers/platform/x86/asus-wmi.c    |   31 ++++++++++++++++++++++++++++---
 drivers/platform/x86/asus-wmi.h    |    7 +++++++
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 87d45e0..9aa6642 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -59,6 +59,17 @@ static struct quirk_entry quirk_asus_unknown = {
 	.wapf = 0,
 };
 
+/*
+ * For those machines that need software to control bt/wifi status
+ * and can't adjust brightness through ACPI interface
+ * and have duplicate events(ACPI and WMI) for display toggle
+ */
+static struct quirk_entry quirk_asus_x55u = {
+	.wapf = 4,
+	.wmi_backlight_power = true,
+	.no_display_toggle = true,
+};
+
 static struct quirk_entry quirk_asus_x401u = {
 	.wapf = 4,
 };
@@ -77,6 +88,15 @@ static struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "X401U"),
 		},
+		.driver_data = &quirk_asus_x55u,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X401A",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X401A"),
+		},
 		.driver_data = &quirk_asus_x401u,
 	},
 	{
@@ -95,6 +115,15 @@ static struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "X501U"),
 		},
+		.driver_data = &quirk_asus_x55u,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X501A",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X501A"),
+		},
 		.driver_data = &quirk_asus_x401u,
 	},
 	{
@@ -131,7 +160,7 @@ static struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "X55U"),
 		},
-		.driver_data = &quirk_asus_x401u,
+		.driver_data = &quirk_asus_x55u,
 	},
 	{
 		.callback = dmi_matched,
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 912ec7d..b4db530 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1341,6 +1341,23 @@ static void asus_wmi_backlight_exit(struct asus_wmi *asus)
 	asus->backlight_device = NULL;
 }
 
+static int is_display_toggle(int code)
+{
+	/* display toggle keys */
+	if ((code >= 0x61 && code <= 0x67) ||
+	    (code >= 0x8c && code <= 0x93) ||
+	    (code >= 0xa0 && code <= 0xa7) ||
+	    (code >= 0xd0 && code <= 0xd5))
+		return 1;
+
+	return 0;
+}
+
+static void do_nothing(void)
+{
+	return;
+}
+
 static void asus_wmi_notify(u32 value, void *context)
 {
 	struct asus_wmi *asus = context;
@@ -1380,10 +1397,18 @@ static void asus_wmi_notify(u32 value, void *context)
 		code = NOTIFY_BRNDOWN_MIN;
 
 	if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
-		if (!acpi_video_backlight_support())
+		if (!acpi_video_backlight_support()) {
 			asus_wmi_backlight_notify(asus, orig_code);
-	} else if (!sparse_keymap_report_event(asus->inputdev, code,
-					       key_value, autorelease))
+		}
+		goto exit;
+	}
+
+	if (is_display_toggle(code) &&
+	    asus->driver->quirks->no_display_toggle) {
+		goto exit;
+
+	if (!sparse_keymap_report_event(asus->inputdev, code,
+					key_value, autorelease))
 		pr_info("Unknown key %x pressed\n", code);
 
 exit:
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 4c9bd38..776524c 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -41,6 +41,13 @@ struct quirk_entry {
 	bool store_backlight_power;
 	bool wmi_backlight_power;
 	int wapf;
+	/*
+	 * For machines with AMD graphic chips, it will send out WMI event
+	 * and ACPI interrupt at the same time while hitting the hotkey.
+	 * To simplify the problem, we just have to ignore the WMI event,
+	 * and let the ACPI interrupt to send out the key event.
+	 */
+	int no_display_toggle;
 };
 
 struct asus_wmi_driver {
-- 
1.7.8.6

