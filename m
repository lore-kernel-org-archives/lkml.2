Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab1CXUET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:04:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34598 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113Ab1CXUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:04:11 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate key
Date: Thu, 24 Mar 2011 15:03:55 -0500
Message-Id: <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110324195720.GB31713@thinkpad-t410>
References: <20110324195720.GB31713@thinkpad-t410>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This key is different than other hotkeys, having seperate scan
codes for press, release, and hold, so it requires some special
handling.

Note that "Home" in the context of this button doesn't mean the
same thing as the usual Home key, and it really isn't clear at
all what is meant by "Home". The manufacurer's description of the
button indicates that it should launch some sort of touch screen
settings interface on short press and apply a desktop rotation on
long press.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/eeepc-wmi.c |   87 +++++++++++++++++++++++++++++++++-----
 1 files changed, 76 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 0ddc434..f9b0ee4 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -56,6 +56,19 @@ MODULE_PARM_DESC(hotplug_wireless,
 		 "If your laptop needs that, please report to "
 		 "acpi4asus-user@lists.sourceforge.net.");
 
+struct eeepc_wmi_driver {
+	struct asus_wmi_driver	asus_wmi_driver;
+	int			home_key_state;
+};
+
+#define to_eeepc_wmi_driver(asus_drv) \
+	container_of((asus_drv), struct eeepc_wmi_driver, asus_wmi_driver)
+
+/* Values for T101MT "Home" key */
+#define HOME_PRESS	0xe4
+#define HOME_HOLD	0xea
+#define HOME_RELEASE	0xe5
+
 static const struct key_entry eeepc_wmi_keymap[] = {
 	/* Sleep already handled via generic ACPI code */
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
@@ -70,7 +83,9 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
 	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
+	{ KE_KEY, HOME_PRESS, { BTN_TASK } },
 	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
+	{ KE_KEY, HOME_HOLD, { KEY_PROG2 } },
 	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
 	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
 	{ KE_KEY, 0xed, { KEY_CAMERA_DOWN } },
@@ -79,6 +94,52 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_END, 0},
 };
 
+static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
+				 int *value, int *autorelease)
+{
+	struct eeepc_wmi_driver *eeepc = to_eeepc_wmi_driver(asus_wmi);
+	int is_press;
+
+	/*
+	 * The following behavior is used for T101MT "Home" key:
+	 * 
+	 *   On press:   No event set
+	 *   On hold:    KEY_PROG2 press sent once w/o autorelease
+	 *   On release: If key was held, KEY_PROG2 release sent.
+	 *               Otherwise KEY_HOME press sent w/ autorelease.
+	 *
+	 * The simple state machine below implements this behavior.
+	 */
+	switch (*code) {
+	case HOME_PRESS:
+		eeepc->home_key_state = HOME_PRESS;
+		*code = ASUS_WMI_KEY_IGNORE;
+		break;
+	case HOME_HOLD:
+		if (eeepc->home_key_state == HOME_HOLD) {
+			*code = ASUS_WMI_KEY_IGNORE;
+		} else {
+			eeepc->home_key_state = HOME_HOLD;
+			*value = 1;
+			*autorelease = 0;
+		}
+		break;
+	case HOME_RELEASE:
+		if (eeepc->home_key_state == HOME_RELEASE) {
+			dev_warn(&asus_wmi->platform_device->dev,
+				 "Unexpected home key release event\n");
+			*code = ASUS_WMI_KEY_IGNORE;
+		} else {
+			*code = eeepc->home_key_state;
+			eeepc->home_key_state = HOME_RELEASE;
+			is_press = (*code == HOME_PRESS);
+			*value = is_press;
+			*autorelease = is_press;
+		}
+		break;
+	}
+}
+
 static acpi_status eeepc_wmi_parse_device(acpi_handle handle, u32 level,
 						 void *context, void **retval)
 {
@@ -142,26 +203,30 @@ static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
 	eeepc_dmi_check(driver);
 }
 
-static struct asus_wmi_driver asus_wmi_driver = {
-	.name = EEEPC_WMI_FILE,
-	.owner = THIS_MODULE,
-	.event_guid = EEEPC_WMI_EVENT_GUID,
-	.keymap = eeepc_wmi_keymap,
-	.input_name = "Eee PC WMI hotkeys",
-	.input_phys = EEEPC_WMI_FILE "/input0",
-	.probe = eeepc_wmi_probe,
-	.quirks = eeepc_wmi_quirks,
+static struct eeepc_wmi_driver eeepc_wmi_driver = {
+	.asus_wmi_driver = {
+		.name = EEEPC_WMI_FILE,
+		.owner = THIS_MODULE,
+		.event_guid = EEEPC_WMI_EVENT_GUID,
+		.keymap = eeepc_wmi_keymap,
+		.input_name = "Eee PC WMI hotkeys",
+		.input_phys = EEEPC_WMI_FILE "/input0",
+		.key_filter = eeepc_wmi_key_filter,
+		.probe = eeepc_wmi_probe,
+		.quirks = eeepc_wmi_quirks,
+	},
+	.home_key_state = HOME_RELEASE,
 };
 
 
 static int __init eeepc_wmi_init(void)
 {
-	return asus_wmi_register_driver(&asus_wmi_driver);
+	return asus_wmi_register_driver(&eeepc_wmi_driver.asus_wmi_driver);
 }
 
 static void __exit eeepc_wmi_exit(void)
 {
-	asus_wmi_unregister_driver(&asus_wmi_driver);
+	asus_wmi_unregister_driver(&eeepc_wmi_driver.asus_wmi_driver);
 }
 
 module_init(eeepc_wmi_init);
-- 
1.7.4.1

