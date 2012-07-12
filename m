Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162179Ab2GLWoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:44:06 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47681 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162116Ab2GLWn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 144/187] HID: hid-multitouch: fix wrong protocol detection
Date: Thu, 12 Jul 2012 15:35:00 -0700
Message-Id: <20120712191535.760384887@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit 3ac36d15557d1bedfb1151d9911b9587b2d40759 upstream.

The previous implementation introduced a randomness in the splitting
of the different touches reported by the device. This version is more
robust as we don't rely on hi->input->absbit, but on our own structure.

This also prepares hid-multitouch to better support Win8 devices.

[Jiri Kosina <jkosina@suse.cz>: fix build]

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/hid/hid-multitouch.c |   58 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 12 deletions(-)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -70,9 +70,16 @@ struct mt_class {
 	bool is_indirect;	/* true for touchpads */
 };
 
+struct mt_fields {
+	unsigned usages[HID_MAX_FIELDS];
+	unsigned int length;
+};
+
 struct mt_device {
 	struct mt_slot curdata;	/* placeholder of incoming data */
 	struct mt_class mtclass;	/* our mt device class */
+	struct mt_fields *fields;	/* temporary placeholder for storing the
+					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
@@ -275,11 +282,15 @@ static void set_abs(struct input_dev *in
 	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
 }
 
-static void set_last_slot_field(struct hid_usage *usage, struct mt_device *td,
+static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 		struct hid_input *hi)
 {
-	if (!test_bit(usage->hid, hi->input->absbit))
-		td->last_slot_field = usage->hid;
+	struct mt_fields *f = td->fields;
+
+	if (f->length >= HID_MAX_FIELDS)
+		return;
+
+	f->usages[f->length++] = usage->hid;
 }
 
 static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -330,7 +341,7 @@ static int mt_input_mapping(struct hid_d
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_GD_Y:
@@ -340,7 +351,7 @@ static int mt_input_mapping(struct hid_d
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		}
@@ -349,24 +360,24 @@ static int mt_input_mapping(struct hid_d
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONFIDENCE:
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTID:
 			if (!td->maxcontacts)
 				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
 			input_mt_init_slots(hi->input, td->maxcontacts);
-			td->last_slot_field = usage->hid;
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
 			return 1;
@@ -375,7 +386,7 @@ static int mt_input_mapping(struct hid_d
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
 			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 				cls->sn_width);
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
@@ -385,7 +396,7 @@ static int mt_input_mapping(struct hid_d
 				cls->sn_height);
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
@@ -396,7 +407,7 @@ static int mt_input_mapping(struct hid_d
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_PRESSURE, field,
 				cls->sn_pressure);
-			set_last_slot_field(usage, td, hi);
+			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
@@ -635,6 +646,16 @@ static void mt_set_maxcontacts(struct hi
 	}
 }
 
+static void mt_post_parse(struct mt_device *td)
+{
+	struct mt_fields *f = td->fields;
+
+	if (td->touches_by_report > 0) {
+		int field_count_per_touch = f->length / td->touches_by_report;
+		td->last_slot_field = f->usages[field_count_per_touch - 1];
+	}
+}
+
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret, i;
@@ -666,6 +687,13 @@ static int mt_probe(struct hid_device *h
 	td->maxcontact_report_id = -1;
 	hid_set_drvdata(hdev, td);
 
+	td->fields = kzalloc(sizeof(struct mt_fields), GFP_KERNEL);
+	if (!td->fields) {
+		dev_err(&hdev->dev, "cannot allocate multitouch fields data\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	ret = hid_parse(hdev);
 	if (ret != 0)
 		goto fail;
@@ -674,6 +702,8 @@ static int mt_probe(struct hid_device *h
 	if (ret)
 		goto fail;
 
+	mt_post_parse(td);
+
 	if (!id && td->touches_by_report == 1) {
 		/* the device has been sent by hid-generic */
 		mtclass = &td->mtclass;
@@ -697,9 +727,13 @@ static int mt_probe(struct hid_device *h
 	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 
+	kfree(td->fields);
+	td->fields = NULL;
+
 	return 0;
 
 fail:
+	kfree(td->fields);
 	kfree(td);
 	return ret;
 }


