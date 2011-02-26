Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1BZJXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:04 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:43674 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1BZJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:23:00 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.41
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/14] asus-wmi: fix and clean backlight code
Date: Sat, 26 Feb 2011 10:20:37 +0100
Message-Id: <1298712045-17671-9-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |   44 +++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index fd5b08ee..adf7b05 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -765,9 +765,8 @@ static int read_backlight_power(struct asus_wmi *asus)
 	return ret ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
 }
 
-static int read_brightness(struct backlight_device *bd)
+static int read_brightness_max(struct asus_wmi *asus)
 {
-	struct asus_wmi *asus = bl_get_data(bd);
 	u32 retval;
 	int err;
 
@@ -776,6 +775,25 @@ static int read_brightness(struct backlight_device *bd)
 	if (err < 0)
 		return err;
 
+	retval = retval & ASUS_WMI_DSTS_MAX_BRIGTH_MASK;
+	retval >>= 8;
+
+	if (!retval)
+		return -ENODEV;
+
+	return retval;
+}
+
+static int read_brightness(struct backlight_device *bd)
+{
+	struct asus_wmi *asus = bl_get_data(bd);
+	u32 retval, err;
+
+	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_BRIGHTNESS, &retval);
+
+	if (err < 0)
+		return err;
+
 	return retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK;
 }
 
@@ -799,7 +817,7 @@ static int update_bl_status(struct backlight_device *bd)
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT,
 					    ctrl_param, NULL);
 	}
-	return 0;
+	return err;
 }
 
 static const struct backlight_ops asus_wmi_bl_ops = {
@@ -832,23 +850,19 @@ static int asus_wmi_backlight_init(struct asus_wmi *asus)
 	int max;
 	int power;
 
-	max = asus_wmi_get_devstate_bits(asus, ASUS_WMI_DEVID_BRIGHTNESS,
-					 ASUS_WMI_DSTS_MAX_BRIGTH_MASK);
-	power = read_backlight_power(asus);
+	max = read_brightness_max(asus);
 
-	if (max < 0 && power < 0) {
-		/* Try to keep the original error */
-		if (max == -ENODEV && power == -ENODEV)
-			return -ENODEV;
-		if (max != -ENODEV)
-			return max;
-		else
-			return power;
-	}
 	if (max == -ENODEV)
 		max = 0;
+	else if (max < 0)
+		return max;
+
+	power = read_backlight_power(asus);
+
 	if (power == -ENODEV)
 		power = FB_BLANK_UNBLANK;
+	else if (power < 0)
+		return power;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = max;
-- 
1.7.4

