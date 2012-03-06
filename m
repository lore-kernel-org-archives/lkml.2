Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2CFRAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:00:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab2CFQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:57:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.216.134.39 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] HID: multitouch: fix handling of buggy reports descriptors for Dell ST2220T
Date: Tue,  6 Mar 2012 17:57:03 +0100
Message-Id: <1331053026-21272-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

LG multitouch panels, such as the one found in Dell ST2220T, has buggy
reports descriptors. With the previous implementation, it was impossible
to rely on the reports descriptors to determine how the different
touches are emitted from the device.

This patch changes the splitting of the different touches in the report
in a more robust way.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---

This one gives me warning under Ubuntu (11.10 and 12.04 at least):
drivers/hid/hid-multitouch.c: In function 'mt_input_mapping':
arch/x86/include/asm/bitops.h:312:8: warning: array subscript is above array bounds [-Warray-bounds]
arch/x86/include/asm/bitops.h:312:8: warning: array subscript is above array bounds [-Warray-bounds]

I don't get any warnings under Fedora. Any help would be great.

Thanks,
Benjamin


 drivers/hid/hid-multitouch.c |   64 ++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 019de83..2088ab4 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -75,7 +75,6 @@ struct mt_device {
 	struct mt_class mtclass;	/* our mt device class */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
-	int last_mt_collection;	/* last known mt-related collection */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
@@ -273,6 +272,13 @@ static void set_abs(struct input_dev *input, unsigned int code,
 	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
 }
 
+static void set_last_slot_field(struct hid_usage *usage, struct mt_device *td,
+		struct hid_input *hi)
+{
+	if (!test_bit(usage->hid, hi->input->absbit))
+		td->last_slot_field = usage->hid;
+}
+
 static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -321,10 +327,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_GD_Y:
 			hid_map_usage(hi, usage, bit, max,
@@ -333,10 +337,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		}
 		return 0;
@@ -344,24 +346,18 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONFIDENCE:
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTID:
 			if (!td->maxcontacts)
@@ -369,17 +365,14 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
 			td->last_field_index = field->index;
-			td->last_mt_collection = usage->collection_index;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
 			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 				cls->sn_width);
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
@@ -388,10 +381,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_height);
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			hid_map_usage(hi, usage, bit, max,
@@ -401,20 +392,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_PRESSURE, field,
 				cls->sn_pressure);
-			if (td->last_mt_collection == usage->collection_index) {
-				td->last_slot_field = usage->hid;
-				td->last_field_index = field->index;
-			}
+			set_last_slot_field(usage, td, hi);
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
-			if (td->last_mt_collection == usage->collection_index)
-				td->last_field_index = field->index;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
 			/* we don't set td->last_slot_field as contactcount and
 			 * contact max are global to the report */
-			if (td->last_mt_collection == usage->collection_index)
-				td->last_field_index = field->index;
+			td->last_field_index = field->index;
 			return -1;
 		}
 		case HID_DG_TOUCH:
@@ -670,7 +657,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	td->mtclass = *mtclass;
 	td->inputmode = -1;
 	td->maxcontact_report_id = -1;
-	td->last_mt_collection = -1;
 	hid_set_drvdata(hdev, td);
 
 	ret = hid_parse(hdev);
-- 
1.7.7.6

