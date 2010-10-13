Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0JMOAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:00:12 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44623 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548Ab0JMOAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:00:09 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 6/6] hid: egalax: Convert to MT slots
Date: Wed, 13 Oct 2010 15:58:22 +0200
Message-Id: <1286978302-30034-7-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P61ro-0008MN-5G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1P61ro-0008MN-5G b92a048cb5f96e71df513c38bd8eb580
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The joojoo reports touches sequentially, one per report, which
confuses the current driver. Convert to the MT slots protocol and use
the stored slot information to emulate pointer movement in a stable
manner.

Tested-by: Philipp Merkel <mail@philmerk.de>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-egalax.c |  133 ++++++++++++++++++++++++---------------------
 1 files changed, 71 insertions(+), 62 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index b21e7dc..1ca0f84 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -2,6 +2,8 @@
  *  HID driver for eGalax dual-touch panels
  *
  *  Copyright (c) 2010 Stephane Chatty <chatty@enac.fr>
+ *  Copyright (c) 2010 Henrik Rydberg <rydberg@euromail.se>
+ *  Copyright (c) 2010 Canonical, Ltd.
  *
  */
 
@@ -25,19 +27,25 @@ MODULE_LICENSE("GPL");
 
 #include "hid-ids.h"
 
+#define MAX_SLOTS		2
+#define MAX_TRKID		USHRT_MAX
 #define MAX_EVENTS		120
 
 /* estimated signal-to-noise ratios */
 #define SN_MOVE			1024
 #define SN_PRESSURE		32
 
+struct egalax_contact {
+	int touch;
+	int x, y, z;
+};
+
 struct egalax_data {
-	__u16 x, y, z;
-	__u8 id;
-	bool first;		/* is this the first finger in the frame? */
-	bool valid;		/* valid finger data, or just placeholder? */
-	bool activity;		/* at least one active finger previously? */
-	__u16 lastx, lasty, lastz;	/* latest valid (x, y, z) in the frame */
+	struct egalax_contact contact[MAX_SLOTS];
+	struct egalax_contact single, tmp;
+	int valid;
+	int slot;
+	int trkid;
 };
 
 static void set_abs(struct input_dev *input, unsigned int code,
@@ -91,10 +99,13 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTMAX:
 			return -1;
 		case HID_DG_CONTACTID:
+			field->logical_maximum = MAX_TRKID;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TRACKING_ID);
 			set_abs(input, ABS_MT_TRACKING_ID, field, 0);
 			input_set_events_per_packet(input, MAX_EVENTS);
+			if (!input->mt)
+				input_mt_create_slots(input, MAX_SLOTS);
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			field->logical_minimum = 0;
@@ -122,64 +133,61 @@ static int egalax_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 	return -1;
 }
 
+static void emulate_pointer(struct egalax_data *td, struct input_dev *input)
+{
+	struct egalax_contact *s = &td->single;
+	struct egalax_contact *best = 0;
+	int dbest, i;
+
+	for (i = 0; i < MAX_SLOTS; i++) {
+		struct egalax_contact *f = &td->contact[i];
+		if (f->touch) {
+			int d = abs(f->x - s->x) + abs(f->y - s->y);
+			if (!best || d < dbest) {
+				best = f;
+				dbest = d;
+			}
+		}
+	}
+
+	if (best) {
+		input_event(input, EV_KEY, BTN_TOUCH, 1);
+		input_event(input, EV_ABS, ABS_X, best->x);
+		input_event(input, EV_ABS, ABS_Y, best->y);
+		input_event(input, EV_ABS, ABS_PRESSURE, best->z);
+		*s = *best;
+	} else {
+		input_event(input, EV_KEY, BTN_TOUCH, 0);
+	}
+}
+
+
 /*
  * this function is called when a whole finger has been parsed,
  * so that it can decide what to send to the input layer.
  */
 static void egalax_filter_event(struct egalax_data *td, struct input_dev *input)
 {
-	td->first = !td->first; /* touchscreen emulation */
-
-	if (td->valid) {
-		/* emit multitouch events */
-		input_event(input, EV_ABS, ABS_MT_TRACKING_ID, td->id);
-		input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x >> 3);
-		input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y >> 3);
-		input_event(input, EV_ABS, ABS_MT_PRESSURE, td->z);
-
-		input_mt_sync(input);
-
-		/*
-		 * touchscreen emulation: store (x, y) as
-		 * the last valid values in this frame
-		 */
-		td->lastx = td->x;
-		td->lasty = td->y;
-		td->lastz = td->z;
-	}
-
-	/*
-	 * touchscreen emulation: if this is the second finger and at least
-	 * one in this frame is valid, the latest valid in the frame is
-	 * the oldest on the panel, the one we want for single touch
-	 */
-	if (!td->first && td->activity) {
-		input_event(input, EV_ABS, ABS_X, td->lastx >> 3);
-		input_event(input, EV_ABS, ABS_Y, td->lasty >> 3);
- 		input_event(input, EV_ABS, ABS_PRESSURE, td->lastz);
-	}
-
-	if (!td->valid) {
-		/*
-		 * touchscreen emulation: if the first finger is invalid
-		 * and there previously was finger activity, this is a release
-		 */ 
-		if (td->first && td->activity) {
-			input_event(input, EV_KEY, BTN_TOUCH, 0);
-			td->activity = false;
+	struct egalax_contact *old = &td->contact[td->slot];
+	struct egalax_contact *f = &td->tmp;
+
+	input_mt_slot(input, td->slot);
+	if (f->touch) {
+		if (!old->touch) {
+			int id = td->trkid++ & MAX_TRKID;
+			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, id);
 		}
-		return;
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, f->x);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, f->y);
+		input_event(input, EV_ABS, ABS_MT_PRESSURE, f->z);
+	} else {
+		input_event(input, EV_ABS, ABS_MT_TRACKING_ID, -1);
 	}
+	*old = *f;
 
-
-	/* touchscreen emulation: if no previous activity, emit touch event */
-	if (!td->activity) {
-		input_event(input, EV_KEY, BTN_TOUCH, 1);
-		td->activity = true;
-	}
+	emulate_pointer(td, input);
 }
 
-
 static int egalax_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
@@ -189,37 +197,38 @@ static int egalax_event(struct hid_device *hid, struct hid_field *field,
 	 * uses a standard parallel multitouch protocol (product ID ==
 	 * 48xx).  The second is capacitive and uses an unusual "serial"
 	 * protocol with a different message for each multitouch finger
-	 * (product ID == 72xx).  We do not yet generate a correct event
-	 * sequence for the capacitive/serial protocol.
+	 * (product ID == 72xx).
 	 */
 	if (hid->claimed & HID_CLAIMED_INPUT) {
 		struct input_dev *input = field->hidinput->input;
 
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
+			td->valid = value;
+			break;
 		case HID_DG_CONFIDENCE:
 			/* avoid interference from generic hidinput handling */
 			break;
 		case HID_DG_TIPSWITCH:
-			td->valid = value;
+			td->tmp.touch = value;
 			break;
 		case HID_DG_TIPPRESSURE:
-			td->z = value;
+			td->tmp.z = value;
 			break;
 		case HID_DG_CONTACTID:
-			td->id = value;
+			td->slot = clamp_val(value, 0, MAX_SLOTS - 1);
 			break;
 		case HID_GD_X:
-			td->x = value;
+			td->tmp.x = value;
 			break;
 		case HID_GD_Y:
-			td->y = value;
+			td->tmp.y = value;
 			/* this is the last field in a finger */
-			egalax_filter_event(td, input);
+			if (td->valid)
+				egalax_filter_event(td, input);
 			break;
 		case HID_DG_CONTACTCOUNT:
 			/* touch emulation: this is the last field in a frame */
-			td->first = false;
 			break;
 
 		default:
-- 
1.7.1

