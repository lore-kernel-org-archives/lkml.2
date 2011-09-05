Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1IEScC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:32:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1IESby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:31:54 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/5] ideapad: define vpc commands
Date: Tue,  6 Sep 2011 02:31:53 +0800
Message-Id: <1315247513-8924-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
References: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better then write hex number everywhere.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   57 +++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 0d94eec..0a1ceaa 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -42,6 +42,30 @@
 #define CFG_WIFI_BIT	(18)
 #define CFG_CAMERA_BIT	(19)
 
+enum {
+	VPCCMD_R_VPC1 = 0x10,
+	VPCCMD_R_BL_MAX,
+	VPCCMD_R_BL,
+	VPCCMD_W_BL,
+	VPCCMD_R_WIFI,
+	VPCCMD_W_WIFI,
+	VPCCMD_R_BT,
+	VPCCMD_W_BT,
+	VPCCMD_R_BL_POWER,
+	VPCCMD_R_NOVO,
+	VPCCMD_R_VPC2,
+	VPCCMD_R_TOUCHPAD,
+	VPCCMD_W_TOUCHPAD,
+	VPCCMD_R_CAMERA,
+	VPCCMD_W_CAMERA,
+	VPCCMD_R_3G,
+	VPCCMD_W_3G,
+	VPCCMD_R_ODD, /* 0x21 */
+	VPCCMD_R_RF = 0x23,
+	VPCCMD_W_RF,
+	VPCCMD_W_BL_POWER = 0x33,
+};
+
 struct ideapad_private {
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
 	struct platform_device *platform_device;
@@ -172,7 +196,7 @@ static ssize_t show_ideapad_cam(struct device *dev,
 {
 	unsigned long result;
 
-	if (read_ec_data(ideapad_handle, 0x1D, &result))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_CAMERA, &result))
 		return sprintf(buf, "-1\n");
 	return sprintf(buf, "%lu\n", result);
 }
@@ -187,7 +211,7 @@ static ssize_t store_ideapad_cam(struct device *dev,
 		return 0;
 	if (sscanf(buf, "%i", &state) != 1)
 		return -EINVAL;
-	ret = write_ec_cmd(ideapad_handle, 0x1E, state);
+	ret = write_ec_cmd(ideapad_handle, VPCCMD_W_CAMERA, state);
 	if (ret < 0)
 		return ret;
 	return count;
@@ -244,9 +268,9 @@ struct ideapad_rfk_data {
 };
 
 const struct ideapad_rfk_data ideapad_rfk_data[] = {
-	{ "ideapad_wlan",      CFG_WIFI_BIT, 0x15, RFKILL_TYPE_WLAN },
-	{ "ideapad_bluetooth", CFG_BT_BIT,   0x17, RFKILL_TYPE_BLUETOOTH },
-	{ "ideapad_3g",        CFG_3G_BIT,   0x20, RFKILL_TYPE_WWAN },
+	{ "ideapad_wlan",    CFG_WIFI_BIT, VPCCMD_W_WIFI, RFKILL_TYPE_WLAN },
+	{ "ideapad_bluetooth", CFG_BT_BIT, VPCCMD_W_BT, RFKILL_TYPE_BLUETOOTH },
+	{ "ideapad_3g",        CFG_3G_BIT, VPCCMD_W_3G, RFKILL_TYPE_WWAN },
 };
 
 static int ideapad_rfk_set(void *data, bool blocked)
@@ -266,7 +290,7 @@ static void ideapad_sync_rfk_state(struct acpi_device *adevice)
 	unsigned long hw_blocked;
 	int i;
 
-	if (read_ec_data(ideapad_handle, 0x23, &hw_blocked))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_RF, &hw_blocked))
 		return;
 	hw_blocked = !hw_blocked;
 
@@ -426,16 +450,17 @@ static int ideapad_backlight_get_brightness(struct backlight_device *blightdev)
 {
 	unsigned long now;
 
-	if (read_ec_data(ideapad_handle, 0x12, &now))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_BL, &now))
 		return -EIO;
 	return now;
 }
 
 static int ideapad_backlight_update_status(struct backlight_device *blightdev)
 {
-	if (write_ec_cmd(ideapad_handle, 0x13, blightdev->props.brightness))
+	if (write_ec_cmd(ideapad_handle, VPCCMD_W_BL,
+			 blightdev->props.brightness))
 		return -EIO;
-	if (write_ec_cmd(ideapad_handle, 0x33,
+	if (write_ec_cmd(ideapad_handle, VPCCMD_W_BL_POWER,
 			 blightdev->props.power == FB_BLANK_POWERDOWN ? 0 : 1))
 		return -EIO;
 
@@ -453,11 +478,11 @@ static int ideapad_backlight_init(struct ideapad_private *priv)
 	struct backlight_properties props;
 	unsigned long max, now, power;
 
-	if (read_ec_data(ideapad_handle, 0x11, &max))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_BL_MAX, &max))
 		return -EIO;
-	if (read_ec_data(ideapad_handle, 0x12, &now))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_BL, &now))
 		return -EIO;
-	if (read_ec_data(ideapad_handle, 0x18, &power))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_BL_POWER, &power))
 		return -EIO;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -495,7 +520,7 @@ static void ideapad_backlight_notify_power(struct ideapad_private *priv)
 
 	if (!blightdev)
 		return;
-	if (read_ec_data(ideapad_handle, 0x18, &power))
+	if (read_ec_data(ideapad_handle, VPCCMD_R_BL_POWER, &power))
 		return;
 	blightdev->props.power = power ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
 }
@@ -506,7 +531,7 @@ static void ideapad_backlight_notify_brightness(struct ideapad_private *priv)
 
 	/* if we control brightness via acpi video driver */
 	if (priv->blightdev == NULL) {
-		read_ec_data(ideapad_handle, 0x12, &now);
+		read_ec_data(ideapad_handle, VPCCMD_R_BL, &now);
 		return;
 	}
 
@@ -595,9 +620,9 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 	acpi_handle handle = adevice->handle;
 	unsigned long vpc1, vpc2, vpc_bit;
 
-	if (read_ec_data(handle, 0x10, &vpc1))
+	if (read_ec_data(handle, VPCCMD_R_VPC1, &vpc1))
 		return;
-	if (read_ec_data(handle, 0x1A, &vpc2))
+	if (read_ec_data(handle, VPCCMD_R_VPC2, &vpc2))
 		return;
 
 	vpc1 = (vpc2 << 8) | vpc1;
-- 
1.7.5.4

