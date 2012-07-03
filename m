Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab2GCSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:53:51 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:37152 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab2GCSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:53:50 -0400
From: Yufeng Shen <miletus@chromium.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Yufeng Shen <miletus@chromium.org>
Subject: [PATCH 1/2 v2] HID: magicmouse: Removing report_touches switch
Date: Tue,  3 Jul 2012 14:53:41 -0400
Message-Id: <1341341621-15560-1-git-send-email-miletus@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the report_touches switch as it is not so useful to turn
off reporting touch events for a touch device. Let the userspace
to do the filtering if the turning off is needed.

V2: Remove report_touches as suggeted by Chase Douglas

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/hid/hid-magicmouse.c |   95 ++++++++++++++++++++----------------------
 1 files changed, 45 insertions(+), 50 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 40ac665..fd88f21 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -48,10 +48,6 @@ static bool scroll_acceleration = false;
 module_param(scroll_acceleration, bool, 0644);
 MODULE_PARM_DESC(scroll_acceleration, "Accelerate sequential scroll events");
 
-static bool report_touches = true;
-module_param(report_touches, bool, 0644);
-MODULE_PARM_DESC(report_touches, "Emit touch records (otherwise, only use them for emulation)");
-
 static bool report_undeciphered;
 module_param(report_undeciphered, bool, 0644);
 MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state field using a MSC_RAW event");
@@ -276,7 +272,7 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 		msc->single_touch_id = SINGLE_TOUCH_UP;
 
 	/* Generate the input events for this touch. */
-	if (report_touches && down) {
+	if (down) {
 		input_report_abs(input, ABS_MT_TRACKING_ID, id);
 		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
 		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
@@ -335,7 +331,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
 
-		if (report_touches && msc->ntouches == 0)
+		if (msc->ntouches == 0)
 			input_mt_sync(input);
 
 		/* When emulating three-button mode, it is important
@@ -422,53 +418,52 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 	}
 
-	if (report_touches) {
-		__set_bit(EV_ABS, input->evbit);
-
-		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
-		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
-				     4, 0);
-		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,
-				     4, 0);
-		input_set_abs_params(input, ABS_MT_ORIENTATION, -31, 32, 1, 0);
-
-		/* Note: Touch Y position from the device is inverted relative
-		 * to how pointer motion is reported (and relative to how USB
-		 * HID recommends the coordinates work).  This driver keeps
-		 * the origin at the same position, and just uses the additive
-		 * inverse of the reported Y.
-		 */
-		if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
-			input_set_abs_params(input, ABS_MT_POSITION_X,
-				MOUSE_MIN_X, MOUSE_MAX_X, 4, 0);
-			input_set_abs_params(input, ABS_MT_POSITION_Y,
-				MOUSE_MIN_Y, MOUSE_MAX_Y, 4, 0);
-
-			input_abs_set_res(input, ABS_MT_POSITION_X,
-				MOUSE_RES_X);
-			input_abs_set_res(input, ABS_MT_POSITION_Y,
-				MOUSE_RES_Y);
-		} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
-			input_set_abs_params(input, ABS_X, TRACKPAD_MIN_X,
-				TRACKPAD_MAX_X, 4, 0);
-			input_set_abs_params(input, ABS_Y, TRACKPAD_MIN_Y,
-				TRACKPAD_MAX_Y, 4, 0);
-			input_set_abs_params(input, ABS_MT_POSITION_X,
-				TRACKPAD_MIN_X, TRACKPAD_MAX_X, 4, 0);
-			input_set_abs_params(input, ABS_MT_POSITION_Y,
-				TRACKPAD_MIN_Y, TRACKPAD_MAX_Y, 4, 0);
-
-			input_abs_set_res(input, ABS_X, TRACKPAD_RES_X);
-			input_abs_set_res(input, ABS_Y, TRACKPAD_RES_Y);
-			input_abs_set_res(input, ABS_MT_POSITION_X,
-				TRACKPAD_RES_X);
-			input_abs_set_res(input, ABS_MT_POSITION_Y,
-				TRACKPAD_RES_Y);
-		}
 
-		input_set_events_per_packet(input, 60);
+	__set_bit(EV_ABS, input->evbit);
+
+	input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
+	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
+			     4, 0);
+	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,
+			     4, 0);
+	input_set_abs_params(input, ABS_MT_ORIENTATION, -31, 32, 1, 0);
+
+	/* Note: Touch Y position from the device is inverted relative
+	 * to how pointer motion is reported (and relative to how USB
+	 * HID recommends the coordinates work).  This driver keeps
+	 * the origin at the same position, and just uses the additive
+	 * inverse of the reported Y.
+	 */
+	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
+		input_set_abs_params(input, ABS_MT_POSITION_X,
+				     MOUSE_MIN_X, MOUSE_MAX_X, 4, 0);
+		input_set_abs_params(input, ABS_MT_POSITION_Y,
+				     MOUSE_MIN_Y, MOUSE_MAX_Y, 4, 0);
+
+		input_abs_set_res(input, ABS_MT_POSITION_X,
+				  MOUSE_RES_X);
+		input_abs_set_res(input, ABS_MT_POSITION_Y,
+				  MOUSE_RES_Y);
+	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
+		input_set_abs_params(input, ABS_X, TRACKPAD_MIN_X,
+				     TRACKPAD_MAX_X, 4, 0);
+		input_set_abs_params(input, ABS_Y, TRACKPAD_MIN_Y,
+				     TRACKPAD_MAX_Y, 4, 0);
+		input_set_abs_params(input, ABS_MT_POSITION_X,
+				     TRACKPAD_MIN_X, TRACKPAD_MAX_X, 4, 0);
+		input_set_abs_params(input, ABS_MT_POSITION_Y,
+				     TRACKPAD_MIN_Y, TRACKPAD_MAX_Y, 4, 0);
+
+		input_abs_set_res(input, ABS_X, TRACKPAD_RES_X);
+		input_abs_set_res(input, ABS_Y, TRACKPAD_RES_Y);
+		input_abs_set_res(input, ABS_MT_POSITION_X,
+				  TRACKPAD_RES_X);
+		input_abs_set_res(input, ABS_MT_POSITION_Y,
+				  TRACKPAD_RES_Y);
 	}
 
+	input_set_events_per_packet(input, 60);
+
 	if (report_undeciphered) {
 		__set_bit(EV_MSC, input->evbit);
 		__set_bit(MSC_RAW, input->mscbit);
-- 
1.7.7.3

