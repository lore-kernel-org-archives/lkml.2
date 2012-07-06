Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2GFIIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:08:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GFIH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:07:56 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH 2/4] ideapad: add Lenovo IdeaPad Z570 support (part 1)
Date: Fri,  6 Jul 2012 16:07:50 +0800
Message-Id: <1341562070-7020-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
References: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

The patch adds support for Lenovo IdeaPad Z570 laptop. It makes all special
keys working, adds possibility to control fan like Windows does, controls
Touchpad Disabled LED, toggles touchpad state via keyboard controller and
corrects touchpad behavior on resume from suspend. It is new, modified
version of patch. Now it does not depend on psmouse and does not need patching
of input subsystem.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>

This is part 1 for special button handling.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 5fdd1aa..36c76d0 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -65,6 +65,7 @@ enum {
 	VPCCMD_R_ODD, /* 0x21 */
 	VPCCMD_R_RF = 0x23,
 	VPCCMD_W_RF,
+	VPCCMD_R_SPECIAL_BUTTONS = 0x31,
 	VPCCMD_W_BL_POWER = 0x33,
 };
 
@@ -518,9 +519,13 @@ static void ideapad_platform_exit(struct ideapad_private *priv)
  */
 static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY, 6,  { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 7,  { KEY_CAMERA } },
+	{ KE_KEY, 11, { KEY_F16 } },
 	{ KE_KEY, 13, { KEY_WLAN } },
 	{ KE_KEY, 16, { KEY_PROG1 } },
 	{ KE_KEY, 17, { KEY_PROG2 } },
+	{ KE_KEY, 64, { KEY_PROG3 } },
+	{ KE_KEY, 65, { KEY_PROG4 } },
 	{ KE_END, 0 },
 };
 
@@ -587,6 +592,28 @@ static void ideapad_input_novokey(struct ideapad_private *priv)
 		ideapad_input_report(priv, 16);
 }
 
+static void ideapad_check_special_buttons(struct ideapad_private *priv)
+{
+	unsigned long bit, value;
+
+	read_ec_data(ideapad_handle, VPCCMD_R_SPECIAL_BUTTONS, &value);
+
+	for (bit = 0; bit < 16; bit++) {
+		if (test_bit(bit, &value)) {
+			switch (bit) {
+			case 6:
+				/* Thermal Management button */
+				ideapad_input_report(priv, 65);
+				break;
+			case 1:
+				/* OneKey Theater button */
+				ideapad_input_report(priv, 64);
+				break;
+			}
+		}
+	}
+}
+
 /*
  * backlight
  */
@@ -784,6 +811,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 				ideapad_sync_rfk_state(priv);
 				break;
 			case 13:
+			case 11:
+			case 7:
 			case 6:
 				ideapad_input_report(priv, vpc_bit);
 				break;
@@ -796,6 +825,9 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 			case 2:
 				ideapad_backlight_notify_power(priv);
 				break;
+			case 0:
+				ideapad_check_special_buttons(priv);
+				break;
 			default:
 				pr_info("Unknown event: %lu\n", vpc_bit);
 			}
-- 
1.7.9.5

