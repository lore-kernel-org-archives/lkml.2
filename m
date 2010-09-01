Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0IAB5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:57:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41840 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0IAB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:56:44 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7 v3] HID: magicmouse: enable Magic Trackpad support
Date: Tue, 31 Aug 2010 21:56:23 -0400
Message-Id: <1283306184-28833-7-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trackpad speaks a similar, but different, protocol from the magic
mouse. However, only small code tweaks here and there are needed to make
basic multitouch work.

Extra logic is required for single-touch emulation of the touchpad. The
changes made here take the approach that only one finger may emulate the
single pointer when multiple fingers have touched the screen. Once that
finger is raised, all touches must be raised before any further single
touch events can be sent.

Sometimes the magic trackpad sends two distinct touch reports as one big
report. Simply splitting the packet in two and resending them through
magicmouse_raw_event ensures they are handled properly.

I also added myself to the copyright statement.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Acked-by: Michael Poole <mdpoole@troilus.org>
---
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-magicmouse.c |  192 +++++++++++++++++++++++++++++++++---------
 3 files changed, 155 insertions(+), 39 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 616bddc..5226fd1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1248,6 +1248,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICMOUSE) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICTRACKPAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7b3ca1d..9204cac 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -63,6 +63,7 @@
 #define USB_VENDOR_ID_APPLE		0x05ac
 #define USB_DEVICE_ID_APPLE_MIGHTYMOUSE	0x0304
 #define USB_DEVICE_ID_APPLE_MAGICMOUSE	0x030d
+#define USB_DEVICE_ID_APPLE_MAGICTRACKPAD	0x030e
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI	0x020e
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_ISO	0x020f
 #define USB_DEVICE_ID_APPLE_GEYSER_ANSI	0x0214
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 9fc272f..6f13e56 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -2,6 +2,7 @@
  *   Apple "Magic" Wireless Mouse driver
  *
  *   Copyright (c) 2010 Michael Poole <mdpoole@troilus.org>
+ *   Copyright (c) 2010 Chase Douglas <chase.douglas@canonical.com>
  */
 
 /*
@@ -53,7 +54,9 @@ static bool report_undeciphered;
 module_param(report_undeciphered, bool, 0644);
 MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state field using a MSC_RAW event");
 
-#define TOUCH_REPORT_ID   0x29
+#define TRACKPAD_REPORT_ID 0x28
+#define MOUSE_REPORT_ID    0x29
+#define DOUBLE_REPORT_ID   0xf7
 /* These definitions are not precise, but they're close enough.  (Bits
  * 0x03 seem to indicate the aspect ratio of the touch, bits 0x70 seem
  * to be some kind of bit mask -- 0x20 may be a near-field reading,
@@ -67,6 +70,15 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
 
 #define SCROLL_ACCEL_DEFAULT 7
 
+/* Single touch emulation should only begin when no touches are currently down.
+ * This is true when single_touch_id is equal to NO_TOUCHES. If multiple touches
+ * are down and the touch providing for single touch emulation is lifted,
+ * single_touch_id is equal to SINGLE_TOUCH_UP. While single touch emulation is
+ * occuring, single_touch_id corresponds with the tracking id of the touch used.
+ */
+#define NO_TOUCHES -1
+#define SINGLE_TOUCH_UP -2
+
 /**
  * struct magicmouse_sc - Tracks Magic Mouse-specific data.
  * @input: Input device through which we report events.
@@ -93,6 +105,7 @@ struct magicmouse_sc {
 		u8 size;
 	} touches[16];
 	int tracking_ids[16];
+	int single_touch_id;
 };
 
 static int magicmouse_firm_touch(struct magicmouse_sc *msc)
@@ -158,15 +171,29 @@ static void magicmouse_emit_buttons(struct magicmouse_sc *msc, int state)
 static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tdata)
 {
 	struct input_dev *input = msc->input;
-	int id = (tdata[6] << 2 | tdata[5] >> 6) & 0xf;
-	int x = (tdata[1] << 28 | tdata[0] << 20) >> 20;
-	int y = -((tdata[2] << 24 | tdata[1] << 16) >> 20);
-	int size = tdata[5] & 0x3f;
-	int orientation = (tdata[6] >> 2) - 32;
-	int touch_major = tdata[3];
-	int touch_minor = tdata[4];
-	int state = tdata[7] & TOUCH_STATE_MASK;
-	int down = state != TOUCH_STATE_NONE;
+	int id, x, y, size, orientation, touch_major, touch_minor, state, down;
+
+	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
+		id = (tdata[6] << 2 | tdata[5] >> 6) & 0xf;
+		x = (tdata[1] << 28 | tdata[0] << 20) >> 20;
+		y = -((tdata[2] << 24 | tdata[1] << 16) >> 20);
+		size = tdata[5] & 0x3f;
+		orientation = (tdata[6] >> 2) - 32;
+		touch_major = tdata[3];
+		touch_minor = tdata[4];
+		state = tdata[7] & TOUCH_STATE_MASK;
+		down = state != TOUCH_STATE_NONE;
+	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+		id = (tdata[7] << 2 | tdata[6] >> 6) & 0xf;
+		x = (tdata[1] << 27 | tdata[0] << 19) >> 19;
+		y = -((tdata[3] << 30 | tdata[2] << 22 | tdata[1] << 14) >> 19);
+		size = tdata[6] & 0x3f;
+		orientation = (tdata[7] >> 2) - 32;
+		touch_major = tdata[4];
+		touch_minor = tdata[5];
+		state = tdata[8] & TOUCH_STATE_MASK;
+		down = state != TOUCH_STATE_NONE;
+	}
 
 	/* Store tracking ID and other fields. */
 	msc->tracking_ids[raw_id] = id;
@@ -217,6 +244,13 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 		}
 	}
 
+	if (down) {
+		msc->ntouches++;
+		if (msc->single_touch_id == NO_TOUCHES)
+			msc->single_touch_id = id;
+	} else if (msc->single_touch_id == id)
+		msc->single_touch_id = SINGLE_TOUCH_UP;
+
 	/* Generate the input events for this touch. */
 	if (report_touches && down) {
 		input_report_abs(input, ABS_MT_TRACKING_ID, id);
@@ -226,14 +260,15 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 		input_report_abs(input, ABS_MT_POSITION_X, x);
 		input_report_abs(input, ABS_MT_POSITION_Y, y);
 
-		if (report_undeciphered)
-			input_event(input, EV_MSC, MSC_RAW, tdata[7]);
+		if (report_undeciphered) {
+			if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
+				input_event(input, EV_MSC, MSC_RAW, tdata[7]);
+			else /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+				input_event(input, EV_MSC, MSC_RAW, tdata[8]);
+		}
 
 		input_mt_sync(input);
 	}
-
-	if (down)
-		msc->ntouches++;
 }
 
 static int magicmouse_raw_event(struct hid_device *hdev,
@@ -241,7 +276,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
 	struct input_dev *input = msc->input;
-	int x, y, ii, clicks, npoints;
+	int x = 0, y = 0, ii, clicks = 0, npoints;
 
 	switch (data[0]) {
 	case 0x10:
@@ -251,7 +286,30 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		y = (__s16)(data[4] | data[5] << 8);
 		clicks = data[1];
 		break;
-	case TOUCH_REPORT_ID:
+	case TRACKPAD_REPORT_ID:
+		/* Expect four bytes of prefix, and N*9 bytes of touch data. */
+		if (size < 4 || ((size - 4) % 9) != 0)
+			return 0;
+		npoints = (size - 4) / 9;
+		msc->ntouches = 0;
+		for (ii = 0; ii < npoints; ii++)
+			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
+
+		/* We don't need an MT sync here because trackpad emits a
+		 * BTN_TOUCH event in a new frame when all touches are released.
+		 */
+		if (msc->ntouches == 0)
+			msc->single_touch_id = NO_TOUCHES;
+
+		clicks = data[1];
+
+		/* The following bits provide a device specific timestamp. They
+		 * are unused here.
+		 *
+		 * ts = data[1] >> 6 | data[2] << 2 | data[3] << 10;
+		 */
+		break;
+	case MOUSE_REPORT_ID:
 		/* Expect six bytes of prefix, and N*8 bytes of touch data. */
 		if (size < 6 || ((size - 6) % 8) != 0)
 			return 0;
@@ -277,6 +335,14 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		 * ts = data[3] >> 6 | data[4] << 2 | data[5] << 10;
 		 */
 		break;
+	case DOUBLE_REPORT_ID:
+		/* Sometimes the trackpad sends two touch reports in one
+		 * packet.
+		 */
+		magicmouse_raw_event(hdev, report, data + 2, data[1]);
+		magicmouse_raw_event(hdev, report, data + 2 + data[1],
+			size - 2 - data[1]);
+		break;
 	case 0x20: /* Theoretically battery status (0-100), but I have
 		    * never seen it -- maybe it is only upon request.
 		    */
@@ -288,9 +354,25 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		return 0;
 	}
 
-	magicmouse_emit_buttons(msc, clicks & 3);
-	input_report_rel(input, REL_X, x);
-	input_report_rel(input, REL_Y, y);
+	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
+		magicmouse_emit_buttons(msc, clicks & 3);
+		input_report_rel(input, REL_X, x);
+		input_report_rel(input, REL_Y, y);
+	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+		input_report_key(input, BTN_MOUSE, clicks & 1);
+		input_report_key(input, BTN_TOUCH, msc->ntouches > 0);
+		input_report_key(input, BTN_TOOL_FINGER, msc->ntouches == 1);
+		input_report_key(input, BTN_TOOL_DOUBLETAP, msc->ntouches == 2);
+		input_report_key(input, BTN_TOOL_TRIPLETAP, msc->ntouches == 3);
+		input_report_key(input, BTN_TOOL_QUADTAP, msc->ntouches == 4);
+		if (msc->single_touch_id >= 0) {
+			input_report_abs(input, ABS_X,
+				msc->touches[msc->single_touch_id].x);
+			input_report_abs(input, ABS_Y,
+				msc->touches[msc->single_touch_id].y);
+		}
+	}
+
 	input_sync(input);
 	return 1;
 }
@@ -326,18 +408,27 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 	input->dev.parent = hdev->dev.parent;
 
 	__set_bit(EV_KEY, input->evbit);
-	__set_bit(BTN_LEFT, input->keybit);
-	__set_bit(BTN_RIGHT, input->keybit);
-	if (emulate_3button)
-		__set_bit(BTN_MIDDLE, input->keybit);
-	__set_bit(BTN_TOOL_FINGER, input->keybit);
-
-	__set_bit(EV_REL, input->evbit);
-	__set_bit(REL_X, input->relbit);
-	__set_bit(REL_Y, input->relbit);
-	if (emulate_scroll_wheel) {
-		__set_bit(REL_WHEEL, input->relbit);
-		__set_bit(REL_HWHEEL, input->relbit);
+
+	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
+		__set_bit(BTN_LEFT, input->keybit);
+		__set_bit(BTN_RIGHT, input->keybit);
+		if (emulate_3button)
+			__set_bit(BTN_MIDDLE, input->keybit);
+
+		__set_bit(EV_REL, input->evbit);
+		__set_bit(REL_X, input->relbit);
+		__set_bit(REL_Y, input->relbit);
+		if (emulate_scroll_wheel) {
+			__set_bit(REL_WHEEL, input->relbit);
+			__set_bit(REL_HWHEEL, input->relbit);
+		}
+	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+		__set_bit(BTN_MOUSE, input->keybit);
+		__set_bit(BTN_TOOL_FINGER, input->keybit);
+		__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
+		__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
+		__set_bit(BTN_TOOL_QUADTAP, input->keybit);
+		__set_bit(BTN_TOUCH, input->keybit);
 	}
 
 	if (report_touches) {
@@ -347,16 +438,26 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
 		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
 		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 1, 0);
-		input_set_abs_params(input, ABS_MT_POSITION_X, -1100, 1358,
-				4, 0);
+
 		/* Note: Touch Y position from the device is inverted relative
 		 * to how pointer motion is reported (and relative to how USB
 		 * HID recommends the coordinates work).  This driver keeps
 		 * the origin at the same position, and just uses the additive
 		 * inverse of the reported Y.
 		 */
-		input_set_abs_params(input, ABS_MT_POSITION_Y, -1589, 2047,
-				4, 0);
+		if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
+			input_set_abs_params(input, ABS_MT_POSITION_X, -1100,
+				1358, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_Y, -1589,
+				2047, 4, 0);
+		} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+			input_set_abs_params(input, ABS_X, -2909, 3167, 4, 0);
+			input_set_abs_params(input, ABS_Y, -2456, 2565, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_X, -2909,
+				3167, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
+				2565, 4, 0);
+		}
 	}
 
 	if (report_undeciphered) {
@@ -385,6 +486,8 @@ static int magicmouse_probe(struct hid_device *hdev,
 	msc->quirks = id->driver_data;
 	hid_set_drvdata(hdev, msc);
 
+	msc->single_touch_id = NO_TOUCHES;
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		dev_err(&hdev->dev, "magicmouse hid parse failed\n");
@@ -405,7 +508,16 @@ static int magicmouse_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
-	report = hid_register_report(hdev, HID_INPUT_REPORT, TOUCH_REPORT_ID);
+	if (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
+		report = hid_register_report(hdev, HID_INPUT_REPORT,
+			MOUSE_REPORT_ID);
+	else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+		report = hid_register_report(hdev, HID_INPUT_REPORT,
+			TRACKPAD_REPORT_ID);
+		report = hid_register_report(hdev, HID_INPUT_REPORT,
+			DOUBLE_REPORT_ID);
+	}
+
 	if (!report) {
 		dev_err(&hdev->dev, "unable to register touch report\n");
 		ret = -ENOMEM;
@@ -456,8 +568,10 @@ static void magicmouse_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id magic_mice[] = {
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGICMOUSE),
-		.driver_data = 0 },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+		USB_DEVICE_ID_APPLE_MAGICMOUSE), .driver_data = 0 },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+		USB_DEVICE_ID_APPLE_MAGICTRACKPAD), .driver_data = 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, magic_mice);
-- 
1.7.1

