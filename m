Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2AMPxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:53:34 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:34573 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2AMPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:31 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 10:53:30 EST
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 1/2] hid-multitouch: add support for trackpads
Date: Fri, 13 Jan 2012 16:45:30 +0100
Message-Id: <1326469531-26808-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@gmail.com>

* some multitouch trackpads present the touch usage. This needs to be
filtered as it will conflict with mt-implementation.
* trackpads send BTN_TOOL_* to notify how many fingers are present
(this is used by xorg to use synaptics instead of generic evdev)
* trackpads like Perixx 701 are not different from a hid point of view
from a touchscreen, and we need to manually set them as touchpad.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   44 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 24fc442..1ba60d3 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1,9 +1,9 @@
 /*
  *  HID driver for multitouch panels
  *
- *  Copyright (c) 2010-2011 Stephane Chatty <chatty@enac.fr>
- *  Copyright (c) 2010-2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
- *  Copyright (c) 2010-2011 Ecole Nationale de l'Aviation Civile, France
+ *  Copyright (c) 2010-2012 Stephane Chatty <chatty@enac.fr>
+ *  Copyright (c) 2010-2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
+ *  Copyright (c) 2010-2012 Ecole Nationale de l'Aviation Civile, France
  *
  *  This code is partly based on hid-egalax.c:
  *
@@ -67,6 +67,7 @@ struct mt_class {
 	__s32 sn_height;	/* Signal/noise ratio for height events */
 	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
 	__u8 maxcontacts;
+	bool is_indirect;	/* true for touchpads */
 };
 
 struct mt_device {
@@ -265,17 +266,31 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 	struct mt_class *cls = &td->mtclass;
+	int code;
 
 	/* Only map fields from TouchScreen or TouchPad collections.
          * We need to ignore fields that belong to other collections
          * such as Mouse that might have the same GenericDesktop usages. */
 	if (field->application == HID_DG_TOUCHSCREEN)
 		set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
-	else if (field->application == HID_DG_TOUCHPAD)
-		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
-	else
+	else if (field->application != HID_DG_TOUCHPAD)
 		return 0;
 
+	/* In case of an indirect device (touchpad), we need to add
+	 * specific BTN_TOOL_* to be handled by the synaptics xorg
+	 * driver.
+	 * We also consider that touchscreens providing buttons are touchpads.
+	 */
+	if (field->application == HID_DG_TOUCHPAD ||
+	    (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON ||
+	    cls->is_indirect) {
+		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
+		set_bit(BTN_TOOL_FINGER, hi->input->keybit);
+		set_bit(BTN_TOOL_DOUBLETAP, hi->input->keybit);
+		set_bit(BTN_TOOL_TRIPLETAP, hi->input->keybit);
+		set_bit(BTN_TOOL_QUADTAP, hi->input->keybit);
+	}
+
 	/* eGalax devices provide a Digitizer.Stylus input which overrides
 	 * the correct Digitizers.Finger X/Y ranges.
 	 * Let's just ignore this input. */
@@ -389,9 +404,20 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				td->last_field_index = field->index;
 			return -1;
 		}
+		case HID_DG_TOUCH:
+			/* Legacy devices use TIPSWITCH and not TOUCH.
+			 * Let's just ignore this field. */
+			return -1;
 		/* let hid-input decide for the others */
 		return 0;
 
+	case HID_UP_BUTTON:
+		code = ((usage->hid - 1) & HID_USAGE);
+		code += BTN_MOUSE;
+		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
+		input_set_capability(hi->input, EV_KEY, code);
+		return 1;
+
 	case 0xff000000:
 		/* we do not want to map these: no input-oriented meaning */
 		return -1;
@@ -453,6 +479,7 @@ static void mt_complete_slot(struct mt_device *td)
 static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 {
 	int i;
+	int finger_count = 0;
 
 	for (i = 0; i < td->maxcontacts; ++i) {
 		struct mt_slot *s = &(td->slots[i]);
@@ -477,12 +504,14 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
+			finger_count++;
 		}
 		s->seen_in_this_frame = false;
 
 	}
 
 	input_mt_report_pointer_emulation(input, true);
+	input_mt_report_finger_count(input, finger_count);
 	input_sync(input);
 	td->num_received = 0;
 }
@@ -538,6 +567,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			if (value)
 				td->num_expected = value;
 			break;
+		case HID_DG_TOUCH:
+			/* do nothing */
+			break;
 
 		default:
 			/* fallback to the generic hidinput handling */
-- 
1.7.4.4

