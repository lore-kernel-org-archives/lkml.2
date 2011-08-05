Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1HEQcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:32:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab1HEQcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:32:53 -0400
X-Greylist: delayed 950 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 12:32:53 EDT
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: magicmouse: Set resolution of touch surfaces
Date: Fri,  5 Aug 2011 09:16:57 -0700
Message-Id: <1312561017-23548-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add touch surface resolution information. The size of the touch surfaces
has been determined to the hundredth of a mm by viewing the device
properties in IORegistryExplorer in OS X.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/hid/hid-magicmouse.c |   57 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 698e645..8fdf702 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -81,6 +81,29 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
 #define NO_TOUCHES -1
 #define SINGLE_TOUCH_UP -2
 
+/* Touch surface information. Dimension is in hundredths of a mm, min and max
+ * are in units. Dimensions gathered from IORegistryExplorer in OS X. Min and
+ * max gathered through testing of devices. */
+#define MOUSE_DIMENSION_X (float)9056
+#define MOUSE_MIN_X -1100
+#define MOUSE_MAX_X 1258
+#define MOUSE_RES_X ((MOUSE_MAX_X - MOUSE_MIN_X) / (MOUSE_DIMENSION_X / 100))
+#define MOUSE_DIMENSION_Y (float)5152
+#define MOUSE_MIN_Y -1589
+#define MOUSE_MAX_Y 2047
+#define MOUSE_RES_Y ((MOUSE_MAX_Y - MOUSE_MIN_Y) / (MOUSE_DIMENSION_Y / 100))
+
+#define TRACKPAD_DIMENSION_X (float)13000
+#define TRACKPAD_MIN_X -2909
+#define TRACKPAD_MAX_X 3167
+#define TRACKPAD_RES_X \
+	((TRACKPAD_MAX_X - TRACKPAD_MIN_X) / (TRACKPAD_DIMENSION_X / 100))
+#define TRACKPAD_DIMENSION_Y (float)11000
+#define TRACKPAD_MIN_Y -2456
+#define TRACKPAD_MAX_Y 2565
+#define TRACKPAD_RES_Y \
+	((TRACKPAD_MAX_Y - TRACKPAD_MIN_Y) / (TRACKPAD_DIMENSION_Y / 100))
+
 /**
  * struct magicmouse_sc - Tracks Magic Mouse-specific data.
  * @input: Input device through which we report events.
@@ -406,17 +429,31 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		 * inverse of the reported Y.
 		 */
 		if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
-			input_set_abs_params(input, ABS_MT_POSITION_X, -1100,
-				1358, 4, 0);
-			input_set_abs_params(input, ABS_MT_POSITION_Y, -1589,
-				2047, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_X,
+				MOUSE_MIN_X, MOUSE_MAX_X, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_Y,
+				MOUSE_MIN_Y, MOUSE_MAX_Y, 4, 0);
+
+			input_abs_set_res(input, ABS_MT_POSITION_X,
+				MOUSE_RES_X);
+			input_abs_set_res(input, ABS_MT_POSITION_Y,
+				MOUSE_RES_Y);
 		} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
-			input_set_abs_params(input, ABS_X, -2909, 3167, 4, 0);
-			input_set_abs_params(input, ABS_Y, -2456, 2565, 4, 0);
-			input_set_abs_params(input, ABS_MT_POSITION_X, -2909,
-				3167, 4, 0);
-			input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
-				2565, 4, 0);
+			input_set_abs_params(input, ABS_X, TRACKPAD_MIN_X,
+				TRACKPAD_MAX_X, 4, 0);
+			input_set_abs_params(input, ABS_Y, TRACKPAD_MIN_Y,
+				TRACKPAD_MAX_Y, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_X,
+				TRACKPAD_MIN_X, TRACKPAD_MAX_X, 4, 0);
+			input_set_abs_params(input, ABS_MT_POSITION_Y,
+				TRACKPAD_MIN_Y, TRACKPAD_MAX_Y, 4, 0);
+
+			input_abs_set_res(input, ABS_X, TRACKPAD_RES_X);
+			input_abs_set_res(input, ABS_Y, TRACKPAD_RES_Y);
+			input_abs_set_res(input, ABS_MT_POSITION_X,
+				TRACKPAD_RES_X);
+			input_abs_set_res(input, ABS_MT_POSITION_Y,
+				TRACKPAD_RES_Y);
 		}
 	}
 
-- 
1.7.4.1

