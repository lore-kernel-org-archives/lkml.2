Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1GAJjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:39:07 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:38962 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1GAJf2 (ORCPT
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
Subject: [PATCH 03/16] eeepc-wmi: Add support for T101MT Home/Express Gate key
Date: Fri,  1 Jul 2011 11:34:28 +0200
Message-Id: <1309512881-2901-4-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

This key is different than other hotkeys, having seperate scan
codes for press, release, and hold, so it requires some special
filtering. Press and release events are passed on, and hold events
are ignored since sparse-keymap does not support hardware
autorepeat.

Note that "Home" in the context of this button doesn't mean the
same thing as the usual Home key, and it really isn't clear at
all what is meant by "Home". The manufacurer's description of the
button indicates that it should launch some sort of touch screen
settings interface on short press and apply a desktop rotation on
long press.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/eeepc-wmi.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 4aa867a..f41a977 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -56,6 +56,11 @@ MODULE_PARM_DESC(hotplug_wireless,
 		 "If your laptop needs that, please report to "
 		 "acpi4asus-user@lists.sourceforge.net.");
 
+/* Values for T101MT "Home" key */
+#define HOME_PRESS	0xe4
+#define HOME_HOLD	0xea
+#define HOME_RELEASE	0xe5
+
 static const struct key_entry eeepc_wmi_keymap[] = {
 	/* Sleep already handled via generic ACPI code */
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
@@ -71,6 +76,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
 	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
+	{ KE_KEY, HOME_PRESS, { KEY_CONFIG } }, /* Home/Express gate key */
 	{ KE_KEY, 0xe8, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
 	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
@@ -81,6 +87,25 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_END, 0},
 };
 
+static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
+				 unsigned int *value, bool *autorelease)
+{
+	switch (*code) {
+	case HOME_PRESS:
+		*value = 1;
+		*autorelease = 0;
+		break;
+	case HOME_HOLD:
+		*code = ASUS_WMI_KEY_IGNORE;
+		break;
+	case HOME_RELEASE:
+		*code = HOME_PRESS;
+		*value = 0;
+		*autorelease = 0;
+		break;
+	}
+}
+
 static acpi_status eeepc_wmi_parse_device(acpi_handle handle, u32 level,
 						 void *context, void **retval)
 {
@@ -151,6 +176,7 @@ static struct asus_wmi_driver asus_wmi_driver = {
 	.keymap = eeepc_wmi_keymap,
 	.input_name = "Eee PC WMI hotkeys",
 	.input_phys = EEEPC_WMI_FILE "/input0",
+	.key_filter = eeepc_wmi_key_filter,
 	.probe = eeepc_wmi_probe,
 	.quirks = eeepc_wmi_quirks,
 };
-- 
1.7.3.4

