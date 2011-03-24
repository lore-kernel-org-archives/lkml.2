Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073Ab1CXUEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:04:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34527 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab1CXUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:04:06 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] asus-wmi: Add callback for hotkey filtering
Date: Thu, 24 Mar 2011 15:03:54 -0500
Message-Id: <1300997035-14104-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110324195720.GB31713@thinkpad-t410>
References: <20110324195720.GB31713@thinkpad-t410>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for the T101MT home key, which behaves differently
than other hotkeys.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/asus-wmi.c |   12 +++++++++++-
 drivers/platform/x86/asus-wmi.h |    6 ++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 5b779a9..c98b787 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1058,6 +1058,8 @@ static void asus_wmi_notify(u32 value, void *context)
 	acpi_status status;
 	int code;
 	int orig_code;
+	int key_value = 1;
+	int autorelease = 1;
 
 	status = wmi_get_event_data(value, &response);
 	if (status != AE_OK) {
@@ -1073,6 +1075,13 @@ static void asus_wmi_notify(u32 value, void *context)
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
@@ -1082,7 +1091,8 @@ static void asus_wmi_notify(u32 value, void *context)
 	if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
 		if (!acpi_video_backlight_support())
 			asus_wmi_backlight_notify(asus, orig_code);
-	} else if (!sparse_keymap_report_event(asus->inputdev, code, 1, true))
+	} else if (!sparse_keymap_report_event(asus->inputdev, code,
+					       key_value, autorelease))
 		pr_info("Unknown key %x pressed\n", code);
 
 exit:
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index c044522..58dd019 100644
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
+			    int *value, int *autorelease);
 
 	int (*probe) (struct platform_device *device);
 	void (*quirks) (struct asus_wmi_driver *driver);
-- 
1.7.4.1

