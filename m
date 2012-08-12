Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2HLVoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:44:30 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:44578 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2HLVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:40:34 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OAIQiKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRti8UkS8DmzaNBoFUIw
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="392235168"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH 19/19] HID: multitouch: Remove the redundant touch state
Date: Sun, 12 Aug 2012 23:42:37 +0200
Message-Id: <1344807757-2217-20-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the input_mt_sync_frame() function in place, there is no longer
any need to keep the full touch state in the driver. This patch
removes the slot state and replaces the lookup code with the input-mt
equivalent. The initialization code is moved to mt_input_configured(),
to make sure the full HID report has been seen.

Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-multitouch.c | 162 ++++++++++++++++++-------------------------
 1 file changed, 66 insertions(+), 96 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b15133c..bd4bc3c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -52,13 +52,6 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
 
-struct mt_slot {
-	__s32 x, y, p, w, h;
-	__s32 contactid;	/* the device ContactID assigned to this slot */
-	bool touch_state;	/* is the touch valid? */
-	bool seen_in_this_frame;/* has this slot been updated */
-};
-
 struct mt_class {
 	__s32 name;	/* MT_CLS */
 	__s32 quirks;
@@ -76,7 +69,6 @@ struct mt_fields {
 };
 
 struct mt_device {
-	struct mt_slot curdata;	/* placeholder of incoming data */
 	struct mt_class mtclass;	/* our mt device class */
 	struct mt_fields *fields;	/* temporary placeholder for storing the
 					   multitouch fields */
@@ -93,7 +85,9 @@ struct mt_device {
 				* 1 means we should use a serial protocol
 				* > 1 means hybrid (multitouch) protocol */
 	bool curvalid;		/* is the current contact valid? */
-	struct mt_slot *slots;
+	__s32 x, y, p, w, h;
+	__s32 contactid;	/* the device ContactID assigned to this slot */
+	bool touch_state;	/* is the touch valid? */
 };
 
 /* classes of device behavior */
@@ -128,31 +122,12 @@ struct mt_device {
 
 static int cypress_compute_slot(struct mt_device *td)
 {
-	if (td->curdata.contactid != 0 || td->num_received == 0)
-		return td->curdata.contactid;
+	if (td->contactid != 0 || td->num_received == 0)
+		return td->contactid;
 	else
 		return -1;
 }
 
-static int find_slot_from_contactid(struct mt_device *td)
-{
-	int i;
-	for (i = 0; i < td->maxcontacts; ++i) {
-		if (td->slots[i].contactid == td->curdata.contactid &&
-			td->slots[i].touch_state)
-			return i;
-	}
-	for (i = 0; i < td->maxcontacts; ++i) {
-		if (!td->slots[i].seen_in_this_frame &&
-			!td->slots[i].touch_state)
-			return i;
-	}
-	/* should not occurs. If this happens that means
-	 * that the device sent more touches that it says
-	 * in the report descriptor. It is ignored then. */
-	return -1;
-}
-
 static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
@@ -390,7 +365,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTID:
 			if (!td->maxcontacts)
 				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
-			input_mt_init_slots(hi->input, td->maxcontacts, 0);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
@@ -464,12 +438,31 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 	return -1;
 }
 
-static int mt_compute_slot(struct mt_device *td)
+static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
+
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	struct mt_class *cls = &td->mtclass;
+	struct input_dev *input = hi->input;
+	unsigned int flags = 0;
+
+	if (test_bit(INPUT_PROP_POINTER, input->propbit))
+		flags |= INPUT_MT_POINTER;
+	if (test_bit(INPUT_PROP_DIRECT, input->propbit))
+		flags |= INPUT_MT_DIRECT;
+
+	if (cls->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
+		flags |= INPUT_MT_DROP_UNUSED;
+
+	input_mt_init_slots(input, td->maxcontacts, flags);
+}
+
+static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
 {
 	__s32 quirks = td->mtclass.quirks;
 
 	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID)
-		return td->curdata.contactid;
+		return td->contactid;
 
 	if (quirks & MT_QUIRK_CYPRESS)
 		return cypress_compute_slot(td);
@@ -478,25 +471,43 @@ static int mt_compute_slot(struct mt_device *td)
 		return td->num_received;
 
 	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE)
-		return td->curdata.contactid - 1;
+		return td->contactid - 1;
 
-	return find_slot_from_contactid(td);
+	return input_mt_assign_slot_by_id(input, td->contactid);
 }
 
 /*
  * this function is called when a whole contact has been processed,
  * so that it can assign it to a slot and store the data there
  */
-static void mt_complete_slot(struct mt_device *td)
+static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 {
-	td->curdata.seen_in_this_frame = true;
-	if (td->curvalid) {
-		int slotnum = mt_compute_slot(td);
+	int slot;
 
-		if (slotnum >= 0 && slotnum < td->maxcontacts)
-			td->slots[slotnum] = td->curdata;
-	}
 	td->num_received++;
+	if (!td->curvalid)
+		return;
+
+	slot = mt_compute_slot(td, input);
+	if (slot < 0 || slot >= td->maxcontacts)
+		return;
+
+	input_mt_slot(input, slot);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, td->touch_state);
+	if (td->touch_state) {
+		/* this finger is on the screen */
+		int wide = (td->w > td->h);
+		/* divided by two to match visual scale of touch */
+		int major = max(td->w, td->h) >> 1;
+		int minor = min(td->w, td->h) >> 1;
+
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y);
+		input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
+		input_event(input, EV_ABS, ABS_MT_PRESSURE, td->p);
+		input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
+		input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
+	}
 }
 
 
@@ -504,52 +515,20 @@ static void mt_complete_slot(struct mt_device *td)
  * this function is called when a whole packet has been received and processed,
  * so that it can decide what to send to the input layer.
  */
-static void mt_emit_event(struct mt_device *td, struct input_dev *input)
+static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 {
-	int i;
-
-	for (i = 0; i < td->maxcontacts; ++i) {
-		struct mt_slot *s = &(td->slots[i]);
-		if ((td->mtclass.quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
-			!s->seen_in_this_frame) {
-			s->touch_state = false;
-		}
-
-		input_mt_slot(input, i);
-		input_mt_report_slot_state(input, MT_TOOL_FINGER,
-			s->touch_state);
-		if (s->touch_state) {
-			/* this finger is on the screen */
-			int wide = (s->w > s->h);
-			/* divided by two to match visual scale of touch */
-			int major = max(s->w, s->h) >> 1;
-			int minor = min(s->w, s->h) >> 1;
-
-			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
-			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
-			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
-			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
-			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
-			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
-		}
-		s->seen_in_this_frame = false;
-
-	}
-
-	input_mt_report_pointer_emulation(input, true);
+	input_mt_sync_frame(input);
 	input_sync(input);
 	td->num_received = 0;
 }
 
-
-
 static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
 
-	if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
+	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
 			if (quirks & MT_QUIRK_ALWAYS_VALID)
@@ -560,29 +539,29 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		case HID_DG_TIPSWITCH:
 			if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
 				td->curvalid = value;
-			td->curdata.touch_state = value;
+			td->touch_state = value;
 			break;
 		case HID_DG_CONFIDENCE:
 			if (quirks & MT_QUIRK_VALID_IS_CONFIDENCE)
 				td->curvalid = value;
 			break;
 		case HID_DG_CONTACTID:
-			td->curdata.contactid = value;
+			td->contactid = value;
 			break;
 		case HID_DG_TIPPRESSURE:
-			td->curdata.p = value;
+			td->p = value;
 			break;
 		case HID_GD_X:
-			td->curdata.x = value;
+			td->x = value;
 			break;
 		case HID_GD_Y:
-			td->curdata.y = value;
+			td->y = value;
 			break;
 		case HID_DG_WIDTH:
-			td->curdata.w = value;
+			td->w = value;
 			break;
 		case HID_DG_HEIGHT:
-			td->curdata.h = value;
+			td->h = value;
 			break;
 		case HID_DG_CONTACTCOUNT:
 			/*
@@ -602,11 +581,11 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		}
 
 		if (usage->hid == td->last_slot_field)
-			mt_complete_slot(td);
+			mt_complete_slot(td, field->hidinput->input);
 
 		if (field->index == td->last_field_index
 			&& td->num_received >= td->num_expected)
-			mt_emit_event(td, field->hidinput->input);
+			mt_sync_frame(td, field->hidinput->input);
 
 	}
 
@@ -733,15 +712,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
 		mt_post_parse_default_settings(td);
 
-	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
-				GFP_KERNEL);
-	if (!td->slots) {
-		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
-		hid_hw_stop(hdev);
-		ret = -ENOMEM;
-		goto fail;
-	}
-
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
 	mt_set_maxcontacts(hdev);
@@ -772,7 +742,6 @@ static void mt_remove(struct hid_device *hdev)
 	struct mt_device *td = hid_get_drvdata(hdev);
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
-	kfree(td->slots);
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
@@ -1085,6 +1054,7 @@ static struct hid_driver mt_driver = {
 	.remove = mt_remove,
 	.input_mapping = mt_input_mapping,
 	.input_mapped = mt_input_mapped,
+	.input_configured = mt_input_configured,
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
-- 
1.7.11.4

