Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2GCSzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:55:38 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62278 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:55:36 -0400
From: Yufeng Shen <miletus@chromium.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Yufeng Shen <miletus@chromium.org>
Subject: [PATCH 2/2 v2] HID: magicmouse: Implement Multi-touch Protocol B (MT-B)
Date: Tue,  3 Jul 2012 14:55:34 -0400
Message-Id: <1341341734-15764-1-git-send-email-miletus@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver for Apple Magic Trackpad/Mouse currently uses
Multi-touch Protocol A (MT-A) to report touch events and uses
ABS_MT_TRACKING_ID to do finger tracking. The fact of the device
being able to track individual finger makes it possible to
report touch events using MT-B. This patch converts the driver
to use MT-B as it is preferred to MT-A.

V2: Converting entirely to MT-B as Henrik Rydberg suggested.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/hid/hid-magicmouse.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index fd88f21..0d6957e 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -16,6 +16,7 @@
 
 #include <linux/device.h>
 #include <linux/hid.h>
+#include <linux/input/mt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
@@ -271,9 +272,11 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 	} else if (msc->single_touch_id == id)
 		msc->single_touch_id = SINGLE_TOUCH_UP;
 
+	input_mt_slot(input, id);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, down);
+
 	/* Generate the input events for this touch. */
 	if (down) {
-		input_report_abs(input, ABS_MT_TRACKING_ID, id);
 		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
 		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
 		input_report_abs(input, ABS_MT_ORIENTATION, -orientation);
@@ -286,8 +289,6 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 			else /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
 				input_event(input, EV_MSC, MSC_RAW, tdata[8]);
 		}
-
-		input_mt_sync(input);
 	}
 }
 
@@ -383,8 +384,10 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 	return 1;
 }
 
-static void magicmouse_setup_input(struct input_dev *input, struct hid_device *hdev)
+static int magicmouse_setup_input(struct input_dev *input, struct hid_device *hdev)
 {
+	int error;
+
 	__set_bit(EV_KEY, input->evbit);
 
 	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
@@ -421,7 +424,9 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 
 	__set_bit(EV_ABS, input->evbit);
 
-	input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
+	error = input_mt_init_slots(input, 16);
+	if (error)
+		return error;
 	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
 			     4, 0);
 	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,
@@ -468,6 +473,8 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		__set_bit(EV_MSC, input->evbit);
 		__set_bit(MSC_RAW, input->mscbit);
 	}
+
+	return 0;
 }
 
 static int magicmouse_input_mapping(struct hid_device *hdev,
@@ -523,8 +530,13 @@ static int magicmouse_probe(struct hid_device *hdev,
 	/* We do this after hid-input is done parsing reports so that
 	 * hid-input uses the most natural button and axis IDs.
 	 */
-	if (msc->input)
-		magicmouse_setup_input(msc->input, hdev);
+	if (msc->input) {
+		ret = magicmouse_setup_input(msc->input, hdev);
+		if (ret) {
+			hid_err(hdev, "magicmouse setup input failed\n");
+			goto err_stop_hw;
+		}
+	}
 
 	if (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
 		report = hid_register_report(hdev, HID_INPUT_REPORT,
-- 
1.7.7.3

