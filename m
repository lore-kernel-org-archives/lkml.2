Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1F3LvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:51:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43655 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1F3Lu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:50:56 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 3/3] ideapad: add backlight driver
Date: Thu, 30 Jun 2011 19:50:52 +0800
Message-Id: <1309434652-4734-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309434584-4636-1-git-send-email-ike.pan@canonical.com>
References: <1309434584-4636-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_backlight=vendor in cmdline or no backlight support in acpi video
device, ideapad-laptop will register backlight device and control brightness
and backlight power via the command in VPC2004.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |  123 +++++++++++++++++++++++++++++++--
 1 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 1612abd..8811c68 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -32,6 +32,8 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/backlight.h>
+#include <linux/fb.h>
 
 #define IDEAPAD_RFKILL_DEV_NUM	(3)
 
@@ -44,6 +46,7 @@ struct ideapad_private {
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
 	struct platform_device *platform_device;
 	struct input_dev *inputdev;
+	struct backlight_device *blightdev;
 	unsigned long cfg;
 };
 
@@ -309,8 +312,7 @@ static int __devinit ideapad_register_rfkill(struct acpi_device *adevice,
 	return 0;
 }
 
-static void __devexit ideapad_unregister_rfkill(struct acpi_device *adevice,
-						int dev)
+static void ideapad_unregister_rfkill(struct acpi_device *adevice, int dev)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 
@@ -418,6 +420,98 @@ static void ideapad_input_report(struct ideapad_private *priv,
 }
 
 /*
+ * backlight
+ */
+static int ideapad_backlight_get_brightness(struct backlight_device *blightdev)
+{
+	unsigned long now;
+
+	if (read_ec_data(ideapad_handle, 0x12, &now))
+		return -EIO;
+	return now;
+}
+
+static int ideapad_backlight_update_status(struct backlight_device *blightdev)
+{
+	if (write_ec_cmd(ideapad_handle, 0x13, blightdev->props.brightness))
+		return -EIO;
+	if (write_ec_cmd(ideapad_handle, 0x33,
+			 blightdev->props.power == FB_BLANK_POWERDOWN ? 0 : 1))
+		return -EIO;
+
+	return 0;
+}
+
+static const struct backlight_ops ideapad_backlight_ops = {
+	.get_brightness = ideapad_backlight_get_brightness,
+	.update_status = ideapad_backlight_update_status,
+};
+
+static int ideapad_backlight_init(struct ideapad_private *priv)
+{
+	struct backlight_device *blightdev;
+	struct backlight_properties props;
+	unsigned long max, now, power;
+
+	if (read_ec_data(ideapad_handle, 0x11, &max))
+		return -EIO;
+	if (read_ec_data(ideapad_handle, 0x12, &now))
+		return -EIO;
+	if (read_ec_data(ideapad_handle, 0x18, &power))
+		return -EIO;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = max;
+	props.type = BACKLIGHT_PLATFORM;
+	blightdev = backlight_device_register("ideapad",
+					      &priv->platform_device->dev,
+					      priv,
+					      &ideapad_backlight_ops,
+					      &props);
+	if (IS_ERR(blightdev)) {
+		pr_err("Could not register backlight device\n");
+		return PTR_ERR(blightdev);
+	}
+
+	priv->blightdev = blightdev;
+	blightdev->props.brightness = now;
+	blightdev->props.power = power ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
+	backlight_update_status(blightdev);
+
+	return 0;
+}
+
+static void ideapad_backlight_exit(struct ideapad_private *priv)
+{
+	if (priv->blightdev)
+		backlight_device_unregister(priv->blightdev);
+	priv->blightdev = NULL;
+}
+
+static void ideapad_backlight_notify_power(struct ideapad_private *priv)
+{
+	unsigned long power;
+	struct backlight_device *blightdev = priv->blightdev;
+
+	if (read_ec_data(ideapad_handle, 0x18, &power))
+		return;
+	blightdev->props.power = power ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
+}
+
+static void ideapad_backlight_notify_brightness(struct ideapad_private *priv)
+{
+	unsigned long now;
+
+	/* if we control brightness via acpi video driver */
+	if (priv->blightdev == NULL) {
+		read_ec_data(ideapad_handle, 0x12, &now);
+		return;
+	}
+
+	backlight_force_update(priv->blightdev, BACKLIGHT_UPDATE_HOTKEY);
+}
+
+/*
  * module init/exit
  */
 static const struct acpi_device_id ideapad_device_ids[] = {
@@ -458,8 +552,17 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 	}
 	ideapad_sync_rfk_state(adevice);
 
+	if (!acpi_video_backlight_support()) {
+		ret = ideapad_backlight_init(priv);
+		if (ret && ret != -ENODEV)
+			goto backlight_failed;
+	}
+
 	return 0;
 
+backlight_failed:
+	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
+		ideapad_unregister_rfkill(adevice, i);
 input_failed:
 	ideapad_platform_exit(priv);
 platform_failed:
@@ -472,6 +575,7 @@ static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int i;
 
+	ideapad_backlight_exit(priv);
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		ideapad_unregister_rfkill(adevice, i);
 	ideapad_input_exit(priv);
@@ -496,12 +600,19 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 	vpc1 = (vpc2 << 8) | vpc1;
 	for (vpc_bit = 0; vpc_bit < 16; vpc_bit++) {
 		if (test_bit(vpc_bit, &vpc1)) {
-			if (vpc_bit == 9)
+			switch (vpc_bit) {
+			case 9:
 				ideapad_sync_rfk_state(adevice);
-			else if (vpc_bit == 4)
-				read_ec_data(handle, 0x12, &vpc2);
-			else
+				break;
+			case 4:
+				ideapad_backlight_notify_brightness(priv);
+				break;
+			case 2:
+				ideapad_backlight_notify_power(priv);
+				break;
+			default:
 				ideapad_input_report(priv, vpc_bit);
+			}
 		}
 	}
 }
-- 
1.7.4.1

