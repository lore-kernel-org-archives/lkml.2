Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966319Ab2EOSc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:32:57 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:38443 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966299Ab2EOScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:32:51 -0400
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz
Cc: linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 2/3] HID: wacom: Add speed setting for Intuos4 WL
Date: Tue, 15 May 2012 19:32:26 +0100
Message-Id: <1337106748-28437-2-git-send-email-przemo@firszt.eu>
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

Add option to change reporting speed for Intuos4 WL. The option is only
internal to the module, but it will be extended to allow control over sysfs,
as it is already implemented for Graphire.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 4fc4eeb..5f6ce70 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -228,16 +228,25 @@ static int wacom_ac_get_property(struct power_supply *psy,
 	return ret;
 }
 
-static void wacom_set_features(struct hid_device *hdev)
+static void wacom_set_features(struct hid_device *hdev, u8 speed)
 {
+	struct wacom_data *wdata = hid_get_drvdata(hdev);
 	int ret;
 	__u8 rep_data[2];
 
-	/*set high speed, tablet mode*/
+	if (speed == 1)
+		wdata->features &= ~0x20;
+	else
+		wdata->features |= 0x20;
+
 	rep_data[0] = 0x03;
-	rep_data[1] = 0x20;
+	rep_data[1] = wdata->features;
+
 	ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
 				HID_FEATURE_REPORT);
+	if (ret >= 0)
+		wdata->high_speed = speed;
+
 	return;
 }
 
@@ -719,7 +728,7 @@ static int wacom_probe(struct hid_device *hdev,
 	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
 		sprintf(hdev->name, "%s", "Wacom Intuos4 WL");
 		wdata->features = 0;
-		wacom_set_features(hdev);
+		wacom_set_features(hdev, 1);
 		ret = wacom_initialize_leds(hdev);
 		if (ret) {
 			hid_warn(hdev,
-- 
1.7.10.1

