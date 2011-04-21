Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1DUMQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:16:17 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:47340 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1DUMQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:16:14 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        PenMount <penmount.touch@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: hid-multitouch: refactor last_field_index
Date: Thu, 21 Apr 2011 14:15:59 +0200
Message-Id: <1303388160-2814-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303388160-2814-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1303388160-2814-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the current implementation requires the devices to report
HID_DG_CONTACTCOUNT to set the last_field_index value.
However, devices reporting in serial mode (DWAV and PenMount)
do not send this field.
Other devices (3M) add other fields in the reports descriptor
that are not multitouch related at the end, thus the need to
add a special case in the default case when handling events.

A first work around has been set up but with PenMount devices,
we have reached the limit.

The idea is to calculate the last_field_index by relying only on
multitouch fields the device send. This allows us to remove
the handling of non-multitouch events in hid-multitouch, and
guarantee that the function mt_emit_event is always called.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0175f85..6005e78 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -210,6 +210,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_GD_Y:
 			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
@@ -221,6 +222,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		}
 		return 0;
@@ -229,18 +231,22 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONFIDENCE:
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTID:
 			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -248,6 +254,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 				cls->sn_width);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
@@ -257,6 +264,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
@@ -269,13 +277,15 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			set_abs(hi->input, ABS_PRESSURE, field,
 				cls->sn_pressure);
 			td->last_slot_field = usage->hid;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
-			td->last_field_index = field->report->maxfield - 1;
+			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
 			/* we don't set td->last_slot_field as contactcount and
 			 * contact max are global to the report */
+			td->last_field_index = field->index;
 			return -1;
 		}
 		/* let hid-input decide for the others */
@@ -424,23 +434,12 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
-			if (td->last_field_index
-				&& field->index == td->last_field_index)
-				/* we reach here when the last field in the
-				 * report is not related to multitouch.
-				 * This is not good. As a temporary solution,
-				 * we trigger our mt event completion and
-				 * ignore the field.
-				 */
-				break;
 			/* fallback to the generic hidinput handling */
 			return 0;
 		}
 
 		if (usage->hid == td->last_slot_field) {
 			mt_complete_slot(td);
-			if (!td->last_field_index)
-				mt_emit_event(td, field->hidinput->input);
 		}
 
 		if (field->index == td->last_field_index
-- 
1.7.4.2

