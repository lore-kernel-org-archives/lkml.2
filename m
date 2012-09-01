Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2IATn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:43:57 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:37008 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2IATny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:43:54 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnxPADRlQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG6OBSSHAObR40R
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="404070778"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH v3 19/20] HID: hid-multitouch: Remove the redundant touch state
Date: Sat,  1 Sep 2012 21:47:14 +0200
Message-Id: <1346528835-363-20-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the input_mt_sync_frame() function in place, there is no longer
any need to keep the full touch state in the driver. This patch
removes the slot state and replaces the lookup code with the input-mt
equivalent.

Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-multitouch.c | 88 ++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 65 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1df86a7..eee19c9 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -56,7 +56,6 @@ struct mt_slot {
 	__s32 x, y, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
-	bool seen_in_this_frame;/* has this slot been updated */
 };
 
 struct mt_class {
@@ -94,7 +93,6 @@ struct mt_device {
 				* > 1 means hybrid (multitouch) protocol */
 	bool serial_maybe;	/* need to check for serial protocol */
 	bool curvalid;		/* is the current contact valid? */
-	struct mt_slot *slots;
 	unsigned mt_flags;	/* flags to pass to input-mt */
 };
 
@@ -136,25 +134,6 @@ static int cypress_compute_slot(struct mt_device *td)
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
@@ -448,7 +427,7 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 	return -1;
 }
 
-static int mt_compute_slot(struct mt_device *td)
+static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
 {
 	__s32 quirks = td->mtclass.quirks;
 
@@ -464,42 +443,23 @@ static int mt_compute_slot(struct mt_device *td)
 	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE)
 		return td->curdata.contactid - 1;
 
-	return find_slot_from_contactid(td);
+	return input_mt_get_slot_by_key(input, td->curdata.contactid);
 }
 
 /*
  * this function is called when a whole contact has been processed,
  * so that it can assign it to a slot and store the data there
  */
-static void mt_complete_slot(struct mt_device *td)
+static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 {
-	td->curdata.seen_in_this_frame = true;
 	if (td->curvalid) {
-		int slotnum = mt_compute_slot(td);
-
-		if (slotnum >= 0 && slotnum < td->maxcontacts)
-			td->slots[slotnum] = td->curdata;
-	}
-	td->num_received++;
-}
-
-
-/*
- * this function is called when a whole packet has been received and processed,
- * so that it can decide what to send to the input layer.
- */
-static void mt_emit_event(struct mt_device *td, struct input_dev *input)
-{
-	int i;
+		int slotnum = mt_compute_slot(td, input);
+		struct mt_slot *s = &td->curdata;
 
-	for (i = 0; i < td->maxcontacts; ++i) {
-		struct mt_slot *s = &(td->slots[i]);
-		if ((td->mtclass.quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
-			!s->seen_in_this_frame) {
-			s->touch_state = false;
-		}
+		if (slotnum < 0 || slotnum >= td->maxcontacts)
+			return;
 
-		input_mt_slot(input, i);
+		input_mt_slot(input, slotnum);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
 			s->touch_state);
 		if (s->touch_state) {
@@ -516,24 +476,29 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
 		}
-		s->seen_in_this_frame = false;
-
 	}
 
+	td->num_received++;
+}
+
+/*
+ * this function is called when a whole packet has been received and processed,
+ * so that it can decide what to send to the input layer.
+ */
+static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
+{
 	input_mt_sync_frame(input);
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
@@ -586,11 +551,11 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		}
 
 		if (usage->hid == td->last_slot_field)
-			mt_complete_slot(td);
+			mt_complete_slot(td, field->hidinput->input);
 
 		if (field->index == td->last_field_index
 			&& td->num_received >= td->num_expected)
-			mt_emit_event(td, field->hidinput->input);
+			mt_sync_frame(td, field->hidinput->input);
 
 	}
 
@@ -690,6 +655,9 @@ static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	if (cls->is_indirect)
 		td->mt_flags |= INPUT_MT_POINTER;
 
+	if (cls->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
+		td->mt_flags |= INPUT_MT_DROP_UNUSED;
+
 	input_mt_init_slots(input, td->maxcontacts, td->mt_flags);
 
 	td->mt_flags = 0;
@@ -743,15 +711,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
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
@@ -782,7 +741,6 @@ static void mt_remove(struct hid_device *hdev)
 	struct mt_device *td = hid_get_drvdata(hdev);
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
-	kfree(td->slots);
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.7.12

