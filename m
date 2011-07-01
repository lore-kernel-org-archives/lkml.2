Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1GAJj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:39:27 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:50573 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab1GAJf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:28 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/16] asus-wmi: Add callback for hotkey filtering
Date: Fri,  1 Jul 2011 11:34:27 +0200
Message-Id: <1309512881-2901-3-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

This is required for the T101MT home key, which behaves differently
than other hotkeys.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |   12 +++++++++++-
 drivers/platform/x86/asus-wmi.h |    6 ++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index d1ddb4a..a09271d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1060,6 +1060,8 @@ static void asus_wmi_notify(u32 value, void *context)
 	acpi_status status;
 	int code;
 	int orig_code;
+	unsigned int key_value = 1;
+	bool autorelease = 1;
 
 	status = wmi_get_event_data(value, &response);
 	if (status != AE_OK) {
@@ -1075,6 +1077,13 @@ static void asus_wmi_notify(u32 value, void *context)
 	code = obj->integer.value;
 	orig_code = code;
 
+	if (asus->driver->key_filter) {
+		asus->driver->key_filter(asus->driver, &code, &key_value,
+					 &autorelease);
+		if (code == ASUS_WMI_KEY_IGNORE)
+			goto exit;
+	}
+
 	if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
 		code = NOTIFY_BRNUP_MIN;
 	else if (code >= NOTIFY_BRNDOWN_MIN &&
@@ -1084,7 +1093,8 @@ static void asus_wmi_notify(u32 value, void *context)
 	if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
 		if (!acpi_video_backlight_support())
 			asus_wmi_backlight_notify(asus, orig_code);
-	} else if (!sparse_keymap_report_event(asus->inputdev, code, 1, true))
+	} else if (!sparse_keymap_report_event(asus->inputdev, code,
+					       key_value, autorelease))
 		pr_info("Unknown key %x pressed\n", code);
 
 exit:
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index c044522..4da6103 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -29,6 +29,8 @@
 
 #include <linux/platform_device.h>
 
+#define ASUS_WMI_KEY_IGNORE (-1)
+
 struct module;
 struct key_entry;
 struct asus_wmi;
@@ -44,6 +46,10 @@ struct asus_wmi_driver {
 	const struct key_entry	*keymap;
 	const char		*input_name;
 	const char		*input_phys;
+	/* Returns new code, value, and autorelease values in arguments.
+	 * Return ASUS_WMI_KEY_IGNORE in code if event should be ignored. */
+	void (*key_filter) (struct asus_wmi_driver *driver, int *code,
+			    unsigned int *value, bool *autorelease);
 
 	int (*probe) (struct platform_device *device);
 	void (*quirks) (struct asus_wmi_driver *driver);
-- 
1.7.3.4

