Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966318Ab2EOSdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:33:31 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:55116 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966047Ab2EOScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:32:53 -0400
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz
Cc: linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 3/3] HID: wacom: unify speed setting
Date: Tue, 15 May 2012 19:32:27 +0100
Message-Id: <1337106748-28437-3-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337106748-28437-1-git-send-email-przemo@firszt.eu>
References: <1337106748-28437-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies speed setting for both supported tablets. Functionality
of "wacom_poke" (used only by Graphire) is now in "wacom_set_features".
Reporting speed for both tablets can be changed by somethinkg like:

echo 1 > /sys/class/bluetooth/hci0/hci0:1/{device No}/speed

Accepted values:
0 - low speed,
1 - high speed.

The way of changing reporting speed is the same for Graphire and Intuos4 WL.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |  102 ++++++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 55 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 5f6ce70..fe23a1e 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -231,45 +231,12 @@ static int wacom_ac_get_property(struct power_supply *psy,
 static void wacom_set_features(struct hid_device *hdev, u8 speed)
 {
 	struct wacom_data *wdata = hid_get_drvdata(hdev);
-	int ret;
-	__u8 rep_data[2];
-
-	if (speed == 1)
-		wdata->features &= ~0x20;
-	else
-		wdata->features |= 0x20;
-
-	rep_data[0] = 0x03;
-	rep_data[1] = wdata->features;
-
-	ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
-				HID_FEATURE_REPORT);
-	if (ret >= 0)
-		wdata->high_speed = speed;
-
-	return;
-}
-
-static void wacom_poke(struct hid_device *hdev, u8 speed)
-{
-	struct wacom_data *wdata = hid_get_drvdata(hdev);
 	int limit, ret;
-	char rep_data[2];
-
-	rep_data[0] = 0x03 ; rep_data[1] = 0x00;
-	limit = 3;
-	do {
-		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
-				HID_FEATURE_REPORT);
-	} while (ret < 0 && limit-- > 0);
-
-	if (ret >= 0) {
-		if (speed == 0)
-			rep_data[0] = 0x05;
-		else
-			rep_data[0] = 0x06;
+	__u8 rep_data[2];
 
-		rep_data[1] = 0x00;
+	switch (hdev->product) {
+	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
+		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
 		limit = 3;
 		do {
 			ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
@@ -277,17 +244,47 @@ static void wacom_poke(struct hid_device *hdev, u8 speed)
 		} while (ret < 0 && limit-- > 0);
 
 		if (ret >= 0) {
-			wdata->high_speed = speed;
-			return;
+			if (speed == 0)
+				rep_data[0] = 0x05;
+			else
+				rep_data[0] = 0x06;
+
+			rep_data[1] = 0x00;
+			limit = 3;
+			do {
+				ret = hdev->hid_output_raw_report(hdev,
+					rep_data, 2, HID_FEATURE_REPORT);
+			} while (ret < 0 && limit-- > 0);
+
+			if (ret >= 0) {
+				wdata->high_speed = speed;
+				return;
+			}
 		}
+
+		/*
+		 * Note that if the raw queries fail, it's not a hard failure
+		 * and it is safe to continue
+		 */
+		hid_warn(hdev, "failed to poke device, command %d, err %d\n",
+			 rep_data[0], ret);
+		break;
+	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
+		if (speed == 1)
+			wdata->features &= ~0x20;
+		else
+			wdata->features |= 0x20;
+
+		rep_data[0] = 0x03;
+		rep_data[1] = wdata->features;
+
+		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+					HID_FEATURE_REPORT);
+		if (ret >= 0)
+			wdata->high_speed = speed;
+		break;
 	}
 
-	/*
-	 * Note that if the raw queries fail, it's not a hard failure and it
-	 * is safe to continue
-	 */
-	hid_warn(hdev, "failed to poke device, command %d, err %d\n",
-		 rep_data[0], ret);
 	return;
 }
 
@@ -311,7 +308,7 @@ static ssize_t wacom_store_speed(struct device *dev,
 		return -EINVAL;
 
 	if (new_speed == 0 || new_speed == 1) {
-		wacom_poke(hdev, new_speed);
+		wacom_set_features(hdev, new_speed);
 		return strnlen(buf, PAGE_SIZE);
 	} else
 		return -EINVAL;
@@ -720,22 +717,17 @@ static int wacom_probe(struct hid_device *hdev,
 		hid_warn(hdev,
 			 "can't create sysfs speed attribute err: %d\n", ret);
 
-	switch (hdev->product) {
-	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
-		/* Set Wacom mode 2 with high reporting speed */
-		wacom_poke(hdev, 1);
-		break;
-	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
+	wdata->features = 0;
+	wacom_set_features(hdev, 1);
+
+	if (hdev->product == USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH) {
 		sprintf(hdev->name, "%s", "Wacom Intuos4 WL");
-		wdata->features = 0;
-		wacom_set_features(hdev, 1);
 		ret = wacom_initialize_leds(hdev);
 		if (ret) {
 			hid_warn(hdev,
 				 "can't create led attribute, err: %d\n", ret);
 			goto destroy_leds;
 		}
-		break;
 	}
 
 	wdata->battery.properties = wacom_battery_props;
-- 
1.7.10.1

