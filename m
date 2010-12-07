Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0LGLzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:55:18 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60143 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697Ab0LGLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:55:16 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3] hid: egalax: Convert to MT slots
Date: Tue,  7 Dec 2010 12:54:11 +0100
Message-Id: <1291722851-22909-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PPw7v-0006oE-BE.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PPw7v-0006oE-BE f3ad5099473555e36af4d65165779892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware in the joojoo reports touches sequentially, one per
report, which confuses the current driver. A further complication is
the absense of any indication of a touch frame. This patch converts
the driver to the MT slots protocol, and outputs one full touch frame
per report. This way, proper handling for both firmwares is ensured.

Tested-by: Philipp Merkel <mail@philmerk.de>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Jiri,

This is revision three of the patch, with one line changed to accomodate
the explicit use of tool types. The rest of the patch set is intact.

Thanks,
Henrik

 drivers/hid/hid-egalax.c |   86 ++++++++++++---------------------------------
 1 files changed, 23 insertions(+), 63 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index 5da5ecb..725a5b0 100644
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
 
@@ -16,6 +18,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <linux/input-mt.h>
 #include <linux/slab.h>
 #include "usbhid/usbhid.h"
 
@@ -25,17 +28,17 @@ MODULE_LICENSE("GPL");
 
 #include "hid-ids.h"
 
+#define MAX_SLOTS		2
+
 /* estimated signal-to-noise ratios */
 #define SN_MOVE			4096
 #define SN_PRESSURE		32
 
 struct egalax_data {
-	__u16 x, y, z;
-	__u8 id;
-	bool first;		/* is this the first finger in the frame? */
-	bool valid;		/* valid finger data, or just placeholder? */
-	bool activity;		/* at least one active finger previously? */
-	__u16 lastx, lasty, lastz;	/* latest valid (x, y, z) in the frame */
+	int valid;
+	int slot;
+	int touch;
+	int x, y, z;
 };
 
 static void set_abs(struct input_dev *input, unsigned int code,
@@ -89,9 +92,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTMAX:
 			return -1;
 		case HID_DG_CONTACTID:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TRACKING_ID);
-			set_abs(input, ABS_MT_TRACKING_ID, field, 0);
+			input_mt_init_slots(input, MAX_SLOTS);
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			field->logical_minimum = 0;
@@ -125,58 +126,16 @@ static int egalax_input_mapped(struct hid_device *hdev, struct hid_input *hi,
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
+	input_mt_slot(input, td->slot);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, td->touch);
+	if (td->touch) {
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y);
 		input_event(input, EV_ABS, ABS_MT_PRESSURE, td->z);
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
-		}
-		return;
-	}
-
-
-	/* touchscreen emulation: if no previous activity, emit touch event */
-	if (!td->activity) {
-		input_event(input, EV_KEY, BTN_TOUCH, 1);
-		td->activity = true;
 	}
+	input_mt_report_pointer_emulation(input);
 }
 
-
 static int egalax_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
@@ -186,25 +145,26 @@ static int egalax_event(struct hid_device *hid, struct hid_field *field,
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
+			td->touch = value;
 			break;
 		case HID_DG_TIPPRESSURE:
 			td->z = value;
 			break;
 		case HID_DG_CONTACTID:
-			td->id = value;
+			td->slot = clamp_val(value, 0, MAX_SLOTS - 1);
 			break;
 		case HID_GD_X:
 			td->x = value;
@@ -212,11 +172,11 @@ static int egalax_event(struct hid_device *hid, struct hid_field *field,
 		case HID_GD_Y:
 			td->y = value;
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

