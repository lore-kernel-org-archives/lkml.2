Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767Ab2JYOLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:11:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61800 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab2JYOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:14 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] HID: introduce Scan Time
Date: Thu, 25 Oct 2012 16:09:48 +0200
Message-Id: <1351174189-24719-10-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win 8 digitizer devices provides the actual scan time computed by the
hardware itself. The value is global to the frame and is not specific
to the multitouch protocol (though only touch, not pen, should use it
according to the specification).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 Documentation/input/event-codes.txt |  7 +++++++
 drivers/hid/hid-input.c             |  4 ++++
 drivers/hid/hid-multitouch.c        | 13 ++++++++++---
 include/linux/hid.h                 |  1 +
 include/linux/input.h               |  1 +
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index 53305bd..8f8c908 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -174,6 +174,13 @@ A few EV_ABS codes have special meanings:
     the input device may be used freely in three dimensions, consider ABS_Z
     instead.
 
+* ABS_SCAN_TIME:
+  - Used when the device provides a timestamp for each frame. The unit must be
+    100us, and may be reset when the device don't send any events for a
+    period of time. The values increment at each frame and thus, it can roll
+    back to 0 when reach logical_max. If the device does not provide this
+    information, the driver must not provide it to the user space.
+
 * ABS_MT_<name>:
   - Used to describe multitouch input events. Please see
     multi-touch-protocol.txt for details.
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 16cc89a..5fe7bd3 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -675,6 +675,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			map_key_clear(BTN_STYLUS2);
 			break;
 
+		case 0x56: /* Scan Time */
+			map_abs(ABS_SCAN_TIME);
+			break;
+
 		default:  goto unknown;
 		}
 		break;
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5aebbff..5d7fd39 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -447,19 +447,26 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
+		case HID_DG_SCANTIME:
+			hid_map_usage(hi, usage, bit, max,
+				EV_ABS, ABS_SCAN_TIME);
+			set_abs(hi->input, ABS_SCAN_TIME, field, 0);
+			td->last_field_index = field->index;
+			return 1;
 		case HID_DG_CONTACTCOUNT:
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
-			/* we don't set td->last_slot_field as contactcount and
-			 * contact max are global to the report */
+			/* we don't set td->last_slot_field as scan time,
+			 * contactcount and contact max are global to the
+			 * report */
 			td->last_field_index = field->index;
 			return -1;
-		}
 		case HID_DG_TOUCH:
 			/* Legacy devices use TIPSWITCH and not TOUCH.
 			 * Let's just ignore this field. */
 			return -1;
+		}
 		/* let hid-input decide for the others */
 		return 0;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 6216529..99a6418 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -279,6 +279,7 @@ struct hid_item {
 #define HID_DG_DEVICEINDEX	0x000d0053
 #define HID_DG_CONTACTCOUNT	0x000d0054
 #define HID_DG_CONTACTMAX	0x000d0055
+#define HID_DG_SCANTIME		0x000d0056
 
 /*
  * HID report types --- Ouch! HID spec says 1 2 3!
diff --git a/include/linux/input.h b/include/linux/input.h
index ba48743..73c3a96 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -796,6 +796,7 @@ struct input_keymap_entry {
 #define ABS_TILT_X		0x1a
 #define ABS_TILT_Y		0x1b
 #define ABS_TOOL_WIDTH		0x1c
+#define ABS_SCAN_TIME		0x1d
 
 #define ABS_VOLUME		0x20
 
-- 
1.7.11.7

