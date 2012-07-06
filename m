Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2GFIIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:08:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2GFIIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:08:09 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH 3/4] ideapad: add Lenovo IdeaPad Z570 support (part 2)
Date: Fri,  6 Jul 2012 16:08:00 +0800
Message-Id: <1341562080-7054-1-git-send-email-ike.pan@canonical.com>
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

This is part 2 for touchpad toggle

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/Kconfig          |    1 +
 drivers/platform/x86/ideapad-laptop.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2a262f5..355d840 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -289,6 +289,7 @@ config IDEAPAD_LAPTOP
 	tristate "Lenovo IdeaPad Laptop Extras"
 	depends on ACPI
 	depends on RFKILL && INPUT
+	depends on SERIO_I8042
 	select INPUT_SPARSEKMAP
 	help
 	  This is a driver for the rfkill switches on Lenovo IdeaPad netbooks.
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 36c76d0..b577766 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -36,6 +36,7 @@
 #include <linux/fb.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/i8042.h>
 
 #define IDEAPAD_RFKILL_DEV_NUM	(3)
 
@@ -526,6 +527,8 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY, 17, { KEY_PROG2 } },
 	{ KE_KEY, 64, { KEY_PROG3 } },
 	{ KE_KEY, 65, { KEY_PROG4 } },
+	{ KE_KEY, 66, { KEY_TOUCHPAD_OFF } },
+	{ KE_KEY, 67, { KEY_TOUCHPAD_ON } },
 	{ KE_END, 0 },
 };
 
@@ -718,6 +721,24 @@ static const struct acpi_device_id ideapad_device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
+static void ideapad_sync_touchpad_state(struct acpi_device *adevice)
+{
+	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
+	unsigned long value;
+
+	/* Without reading from EC touchpad LED doesn't switch state */
+	if (!read_ec_data(adevice->handle, VPCCMD_R_TOUCHPAD, &value)) {
+		/* Some IdeaPads don't really turn off touchpad - they only
+		 * switch the LED state. We (de)activate KBC AUX port to turn
+		 * touchpad off and on. We send KEY_TOUCHPAD_OFF and
+		 * KEY_TOUCHPAD_ON to not to get out of sync with LED */
+		unsigned char param;
+		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE :
+				I8042_CMD_AUX_DISABLE);
+		ideapad_input_report(priv, value ? 67 : 66);
+	}
+}
+
 static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 {
 	int ret, i, cfg;
@@ -753,6 +774,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 			priv->rfk[i] = NULL;
 	}
 	ideapad_sync_rfk_state(priv);
+	ideapad_sync_touchpad_state(adevice);
 
 	if (!acpi_video_backlight_support()) {
 		ret = ideapad_backlight_init(priv);
@@ -816,6 +838,9 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 			case 6:
 				ideapad_input_report(priv, vpc_bit);
 				break;
+			case 5:
+				ideapad_sync_touchpad_state(adevice);
+				break;
 			case 4:
 				ideapad_backlight_notify_brightness(priv);
 				break;
@@ -835,6 +860,13 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 	}
 }
 
+static int ideapad_acpi_resume(struct acpi_device *adevice)
+{
+	ideapad_sync_rfk_state(ideapad_priv);
+	ideapad_sync_touchpad_state(adevice);
+	return 0;
+}
+
 static struct acpi_driver ideapad_acpi_driver = {
 	.name = "ideapad_acpi",
 	.class = "IdeaPad",
@@ -842,6 +874,7 @@ static struct acpi_driver ideapad_acpi_driver = {
 	.ops.add = ideapad_acpi_add,
 	.ops.remove = ideapad_acpi_remove,
 	.ops.notify = ideapad_acpi_notify,
+	.ops.resume = ideapad_acpi_resume,
 	.owner = THIS_MODULE,
 };
 
-- 
1.7.9.5

