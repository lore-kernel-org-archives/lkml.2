Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2KGQiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:38:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56378 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KGQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:12 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/13] HID: hid-multitouch: forwards ABS_SCAN_TIME
Date: Wed,  7 Nov 2012 17:37:36 +0100
Message-Id: <1352306256-12180-14-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Computes the scan time according to the specification.
It also ensures that if the time between two events is greater
than MAX_SCAN_INTERVAL, the scan time will be reset.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 45 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1f3d1e0..5902567 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/input/mt.h>
+#include <linux/jiffies.h>
 #include "usbhid/usbhid.h"
 
 
@@ -98,6 +99,9 @@ struct mt_device {
 	bool serial_maybe;	/* need to check for serial protocol */
 	bool curvalid;		/* is the current contact valid? */
 	unsigned mt_flags;	/* flags to pass to input-mt */
+	__s32 dev_time;		/* the scan time provided by the device */
+	unsigned long jiffies;	/* the frame's jiffies */
+	unsigned scan_time;	/* the scan time to be sent */
 };
 
 /* classes of device behavior */
@@ -126,6 +130,9 @@ struct mt_device {
 #define MT_DEFAULT_MAXCONTACT	10
 #define MT_MAX_MAXCONTACT	250
 
+#define MAX_SCAN_TIME		INT_MAX
+#define MAX_SCAN_INTERVAL	500000
+
 #define MT_USB_DEVICE(v, p)	HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH, v, p)
 #define MT_BT_DEVICE(v, p)	HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH, v, p)
 
@@ -451,12 +458,20 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
+		case HID_DG_SCANTIME:
+			hid_map_usage(hi, usage, bit, max,
+				EV_ABS, ABS_SCAN_TIME);
+			input_set_abs_params(hi->input,
+				ABS_SCAN_TIME, 0, MAX_SCAN_TIME, 0, 0);
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
 		}
@@ -565,11 +580,34 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
  */
 static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 {
+	input_event(input, EV_ABS, ABS_SCAN_TIME, td->scan_time);
 	input_mt_sync_frame(input);
 	input_sync(input);
 	td->num_received = 0;
 }
 
+static void mt_compute_scan_time(struct mt_device *td, struct hid_field *field,
+		__s32 value)
+{
+	long delta = value - td->dev_time;
+	unsigned long jdelta = jiffies_to_usecs(jiffies - td->jiffies);
+
+	td->jiffies = jiffies;
+	td->dev_time = value;
+
+	if (delta < 0)
+		delta += field->logical_maximum;
+
+	/* HID_DG_SCANTIME is expressed in 100us, we want it in ms. */
+	delta *= 100;
+
+	if (abs(delta - jdelta) > MAX_SCAN_INTERVAL)
+		/* obviously wrong clock -> the device time has been reset */
+		td->scan_time = 0;
+	else
+		td->scan_time += delta;
+}
+
 static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
@@ -617,6 +655,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		case HID_DG_HEIGHT:
 			td->curdata.h = value;
 			break;
+		case HID_DG_SCANTIME:
+			mt_compute_scan_time(td, field, value);
+			break;
 		case HID_DG_CONTACTCOUNT:
 			/*
 			 * Includes multi-packet support where subsequent
-- 
1.7.11.7

