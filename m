Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2JZIpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:45:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58210 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab2JZIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:44:51 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/11] HID: hid-multitouch: get rid of usbhid depedency for general path
Date: Fri, 26 Oct 2012 10:44:27 +0200
Message-Id: <1351241067-9521-12-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factorizes the hid set_feature command by using
hid_device->hid_output_raw_report instead of direclty relying on
usbhid. This makes the driver usb independant.

However I still can't remove the 2 usb related headers because the
function mt_resume has a specific patch for usb devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 63 ++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 21a120b..33038c5 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -670,47 +670,58 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	return 1;
 }
 
-static void mt_set_input_mode(struct hid_device *hdev)
+static void mt_set_feature(struct hid_device *hdev, __s8 feature_id,
+	u8 value, size_t index)
 {
-	struct mt_device *td = hid_get_drvdata(hdev);
 	struct hid_report *r;
 	struct hid_report_enum *re;
+	u8 *data;
+	u8 max_value;
+	int len;
+
+	if (feature_id < 0 || !hdev->hid_output_raw_report)
+		return;
+
+	re = &hdev->report_enum[HID_FEATURE_REPORT];
+	r = re->report_id_hash[feature_id];
+	if (!r)
+		return;
+
+	len = ((r->size - 1) >> 3) + 1 + (r->id > 0);
+	max_value = r->field[0]->logical_maximum;
+	value = min(value, max_value);
 
-	if (td->inputmode < 0)
+	if (r->field[0]->value[index] == value || len < 2 || index + 1 >= len)
 		return;
 
-	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
-	r = re->report_id_hash[td->inputmode];
-	if (r) {
-		r->field[0]->value[td->inputmode_index] = 0x02;
-		usbhid_submit_report(hdev, r, USB_DIR_OUT);
+	data = kzalloc(len, GFP_ATOMIC);
+	if (!data) {
+		hid_warn(hdev, "output queueing failed\n");
+		return;
 	}
+
+	data[0] = r->id;
+	data[index + 1] = value;
+	hdev->hid_output_raw_report(hdev, data, len, HID_FEATURE_REPORT);
+	kfree(data);
 }
 
-static void mt_set_maxcontacts(struct hid_device *hdev)
+static void mt_set_input_mode(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
-	struct hid_report *r;
-	struct hid_report_enum *re;
-	int fieldmax, max;
 
-	if (td->maxcontact_report_id < 0)
-		return;
+	mt_set_feature(hdev, td->inputmode, 0x02, td->inputmode_index);
+}
 
-	if (!td->mtclass.maxcontacts)
+static void mt_set_maxcontacts(struct hid_device *hdev)
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	int max = td->mtclass.maxcontacts;
+
+	if (!max)
 		return;
 
-	re = &hdev->report_enum[HID_FEATURE_REPORT];
-	r = re->report_id_hash[td->maxcontact_report_id];
-	if (r) {
-		max = td->mtclass.maxcontacts;
-		fieldmax = r->field[0]->logical_maximum;
-		max = min(fieldmax, max);
-		if (r->field[0]->value[0] != max) {
-			r->field[0]->value[0] = max;
-			usbhid_submit_report(hdev, r, USB_DIR_OUT);
-		}
-	}
+	mt_set_feature(hdev, td->maxcontact_report_id, max, 0);
 }
 
 static void mt_post_parse_default_settings(struct mt_device *td)
-- 
1.7.11.7

