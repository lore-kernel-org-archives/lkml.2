Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2ARLvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:51:39 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:58453 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2ARLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:51:37 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] HID: multitouch: add control of the feature "Maximum Contact Number"
Date: Wed, 18 Jan 2012 12:51:07 +0100
Message-Id: <1326887468-5148-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices, like Perixx Peripad 701 do not work if the feature
"Maximum Contact Number" is not set to the right value.
This patch allows hid-multitouch to control this feature.

If the programmer fills the field maxcontacts in the mt_class,
then the driver will set the feature to this value. It is safe
for current drivers as the feature is read/right in the HID norm
and all devices should implement the norm.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ef59140..fd978c9 100644
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
@@ -609,6 +612,36 @@ static void mt_set_input_mode(struct hid_device *hdev)
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
+	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
+	r = re->report_id_hash[td->maxcontact_report_id];
+	if (r) {
+		max = td->mtclass.maxcontacts;
+		fieldmax = r->field[0]->logical_maximum;
+		hid_info(hdev, "%s: value = %d / %d / %d\n", __func__,
+			r->field[0]->value[0],
+			td->mtclass.maxcontacts,
+			fieldmax);
+		max = fieldmax < max ? fieldmax : max;
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
@@ -634,6 +667,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 	td->mtclass = *mtclass;
 	td->inputmode = -1;
+	td->maxcontact_report_id = -1;
 	td->last_mt_collection = -1;
 	hid_set_drvdata(hdev, td);
 
@@ -656,6 +690,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
+	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 
 	return 0;
@@ -668,6 +703,7 @@ fail:
 #ifdef CONFIG_PM
 static int mt_reset_resume(struct hid_device *hdev)
 {
+	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 	return 0;
 }
-- 
1.7.4.4

