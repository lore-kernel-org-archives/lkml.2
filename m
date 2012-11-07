Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2KGQim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:38:42 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54334 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2KGQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:11 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/13] HID: introduce Scan Time
Date: Wed,  7 Nov 2012 17:37:35 +0100
Message-Id: <1352306256-12180-13-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win 8 digitizer devices provides the actual scan time computed by the
hardware itself. The value is global to the frame and is not specific
to the multitouch protocol (though only touch, not pen, should use it
according to the specification).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 Documentation/input/event-codes.txt | 9 +++++++++
 drivers/hid/hid-input.c             | 4 ++++
 include/linux/hid.h                 | 1 +
 include/linux/input.h               | 1 +
 4 files changed, 15 insertions(+)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index 53305bd..80c06e5 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -174,6 +174,15 @@ A few EV_ABS codes have special meanings:
     the input device may be used freely in three dimensions, consider ABS_Z
     instead.
 
+* ABS_SCAN_TIME:
+  - Used to report the number of microseconds since the last reset. This event
+    should be coded as an uint32 value, which is allowed to wrap around with
+    no special consequence. It is assumed that the time difference between two
+    consecutive events is reliable on a reasonable time scale (hours).
+    A reset to zero can happen, in which case the time since the last event is
+    unknown.  If the device does not provide this information, the driver must
+    not provide it to the user space.
+
 * ABS_MT_<name>:
   - Used to describe multitouch input events. Please see
     multi-touch-protocol.txt for details.
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7015080..1c96238 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -677,6 +677,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			map_key_clear(BTN_STYLUS2);
 			break;
 
+		case 0x56: /* Scan Time */
+			map_abs(ABS_SCAN_TIME);
+			break;
+
 		default:  goto unknown;
 		}
 		break;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 6b4f322..0337e50 100644
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

