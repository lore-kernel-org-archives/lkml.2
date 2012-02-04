Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2BDQJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:09:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39290 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2BDQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:09:06 -0500
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] HID: multitouch: add support for trackpads
Date: Sat,  4 Feb 2012 17:08:48 +0100
Message-Id: <1328371730-10944-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

* some multitouch trackpads present the touch usage. This needs to be
filtered as it will conflict with mt-implementation.
* trackpads send BTN_TOOL_* to notify how many fingers are present
(this is used by xorg to use synaptics instead of generic evdev)
* trackpads like Perixx 701 are not different from a hid point of view
from a touchscreen, and we need to manually set them as touchpad.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 24fc442..4c69749 100644
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
@@ -389,9 +404,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
+		code = BTN_MOUSE + ((usage->hid - 1) & HID_USAGE);
+		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
+		input_set_capability(hi->input, EV_KEY, code);
+		return 1;
+
 	case 0xff000000:
 		/* we do not want to map these: no input-oriented meaning */
 		return -1;
@@ -538,6 +563,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			if (value)
 				td->num_expected = value;
 			break;
+		case HID_DG_TOUCH:
+			/* do nothing */
+			break;
 
 		default:
 			/* fallback to the generic hidinput handling */
-- 
1.7.7.6

