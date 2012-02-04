Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2BDQJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:09:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63042 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2BDQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:09:07 -0500
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] HID: multitouch: add control of the feature "Maximum Contact Number"
Date: Sat,  4 Feb 2012 17:08:49 +0100
Message-Id: <1328371730-10944-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Some devices, like Perixx Peripad 701 do not work if the feature
"Maximum Contact Number" is not set to the right value.
This patch allows hid-multitouch to control this feature.

If the programmer fills the field maxcontacts in the mt_class,
then the driver will set the feature to this value. It is safe
for current drivers as the feature is read/write in the HID norm
and all devices should implement the norm.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4c69749..825759e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -77,6 +77,8 @@ struct mt_device {
 	unsigned last_slot_field;	/* the last field of a slot */
 	int last_mt_collection;	/* last known mt-related collection */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
+	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
+				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
 	__u8 maxcontacts;
@@ -242,6 +244,7 @@ static void mt_feature_mapping(struct hid_device *hdev,
 		td->inputmode = field->report->id;
 		break;
 	case HID_DG_CONTACTMAX:
+		td->maxcontact_report_id = field->report->id;
 		td->maxcontacts = field->value[0];
 		if (td->mtclass.maxcontacts)
 			/* check if the maxcontacts is given by the class */
@@ -606,6 +609,32 @@ static void mt_set_input_mode(struct hid_device *hdev)
 	}
 }
 
+static void mt_set_maxcontacts(struct hid_device *hdev)
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	struct hid_report *r;
+	struct hid_report_enum *re;
+	int fieldmax, max;
+
+	if (td->maxcontact_report_id < 0)
+		return;
+
+	if (!td->mtclass.maxcontacts)
+		return;
+
+	re = &hdev->report_enum[HID_FEATURE_REPORT];
+	r = re->report_id_hash[td->maxcontact_report_id];
+	if (r) {
+		max = td->mtclass.maxcontacts;
+		fieldmax = r->field[0]->logical_maximum;
+		max = min(fieldmax, max);
+		if (r->field[0]->value[0] != max) {
+			r->field[0]->value[0] = max;
+			usbhid_submit_report(hdev, r, USB_DIR_OUT);
+		}
+	}
+}
+
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret, i;
@@ -631,6 +660,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 	td->mtclass = *mtclass;
 	td->inputmode = -1;
+	td->maxcontact_report_id = -1;
 	td->last_mt_collection = -1;
 	hid_set_drvdata(hdev, td);
 
@@ -653,6 +683,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
+	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 
 	return 0;
@@ -665,6 +696,7 @@ fail:
 #ifdef CONFIG_PM
 static int mt_reset_resume(struct hid_device *hdev)
 {
+	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 	return 0;
 }
-- 
1.7.7.6

