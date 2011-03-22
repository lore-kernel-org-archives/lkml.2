Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1CVQds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:33:48 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:59414 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1CVQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:33:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] hid-multitouch: migrate 3M PCT touch screens to hid-multitouch
Date: Tue, 22 Mar 2011 17:34:01 +0100
Message-Id: <1300811641-3327-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <AANLkTimFF3pgMMgOcEhYnRm5adgsCL5S6Hjkz+GFcpCT@mail.gmail.com>
References: <AANLkTimFF3pgMMgOcEhYnRm5adgsCL5S6Hjkz+GFcpCT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the hid-3m-pct driver into hid-multitouch.
To keep devices working the same way they used to with hid-3m-pct,
we need to add two signal/noise ratios for width and height.
We also need to work on width/height to send proper
ABS_MT_ORIENTATION flag.

Importing 3M into hid-multitouch also solved the bug in which
devices handling width and height in their report descriptors
did not show ABS_MT_TOUCH_MAJOR and ABS_MT_TOUCH_MINOR.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Reviewed-by: Stéphane Chatty <chatty@enac.fr>
---
Hi guys,

I've added Henrik's patch and a comment:

/* we reach here when the last field in the
 * report is not related to multitouch.
 * This is not good. As a temporary solution,
 * we trigger our mt event completion and
 * ignore the field.
 */

Henrik, do I still have your Reviewed-and-tested-by ?

Cheers,
Benjamin

 drivers/hid/Kconfig          |    7 +-
 drivers/hid/Makefile         |    1 -
 drivers/hid/hid-3m-pct.c     |  305 ------------------------------------------
 drivers/hid/hid-multitouch.c |   47 ++++++-
 4 files changed, 46 insertions(+), 314 deletions(-)
 delete mode 100644 drivers/hid/hid-3m-pct.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 1edb0bd..996ae3a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -55,12 +55,6 @@ source "drivers/hid/usbhid/Kconfig"
 menu "Special HID drivers"
 	depends on HID
 
-config HID_3M_PCT
-	tristate "3M PCT touchscreen"
-	depends on USB_HID
-	---help---
-	Support for 3M PCT touch screens.
-
 config HID_A4TECH
 	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
@@ -314,6 +308,7 @@ config HID_MULTITOUCH
 	  Generic support for HID multitouch panels.
 
 	  Say Y here if you have one of the following devices:
+	  - 3M PCT touch screens
 	  - Cando dual touch panel
 	  - Cypress TrueTouch panels
 	  - Hanvon dual touch panels
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index f8b90e4..11c9f0b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -25,7 +25,6 @@ ifdef CONFIG_LOGIWII_FF
 	hid-logitech-y	+= hid-lg4ff.o
 endif
 
-obj-$(CONFIG_HID_3M_PCT)	+= hid-3m-pct.o
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
deleted file mode 100644
index 5243ae2..0000000
--- a/drivers/hid/hid-3m-pct.c
+++ /dev/null
@@ -1,305 +0,0 @@
-/*
- *  HID driver for 3M PCT multitouch panels
- *
- *  Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
- *  Copyright (c) 2010      Henrik Rydberg <rydberg@euromail.se>
- *  Copyright (c) 2010      Canonical, Ltd.
- *
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- */
-
-#include <linux/device.h>
-#include <linux/hid.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/usb.h>
-#include <linux/input/mt.h>
-
-MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
-MODULE_DESCRIPTION("3M PCT multitouch panels");
-MODULE_LICENSE("GPL");
-
-#include "hid-ids.h"
-
-#define MAX_SLOTS		60
-
-/* estimated signal-to-noise ratios */
-#define SN_MOVE			2048
-#define SN_WIDTH		128
-
-struct mmm_finger {
-	__s32 x, y, w, h;
-	bool touch, valid;
-};
-
-struct mmm_data {
-	struct mmm_finger f[MAX_SLOTS];
-	__u8 curid;
-	__u8 nexp, nreal;
-	bool touch, valid;
-};
-
-static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
-{
-	int f1 = field->logical_minimum;
-	int f2 = field->logical_maximum;
-	int df = f2 - f1;
-
-	switch (usage->hid & HID_USAGE_PAGE) {
-
-	case HID_UP_BUTTON:
-		return -1;
-
-	case HID_UP_GENDESK:
-		switch (usage->hid) {
-		case HID_GD_X:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_POSITION_X);
-			input_set_abs_params(hi->input, ABS_MT_POSITION_X,
-					     f1, f2, df / SN_MOVE, 0);
-			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_X,
-					     f1, f2, df / SN_MOVE, 0);
-			return 1;
-		case HID_GD_Y:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_POSITION_Y);
-			input_set_abs_params(hi->input, ABS_MT_POSITION_Y,
-					     f1, f2, df / SN_MOVE, 0);
-			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_Y,
-					     f1, f2, df / SN_MOVE, 0);
-			return 1;
-		}
-		return 0;
-
-	case HID_UP_DIGITIZER:
-		switch (usage->hid) {
-		/* we do not want to map these: no input-oriented meaning */
-		case 0x14:
-		case 0x23:
-		case HID_DG_INPUTMODE:
-		case HID_DG_DEVICEINDEX:
-		case HID_DG_CONTACTCOUNT:
-		case HID_DG_CONTACTMAX:
-		case HID_DG_INRANGE:
-		case HID_DG_CONFIDENCE:
-			return -1;
-		case HID_DG_TIPSWITCH:
-			/* touchscreen emulation */
-			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
-			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
-			return 1;
-		case HID_DG_WIDTH:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TOUCH_MAJOR);
-			input_set_abs_params(hi->input, ABS_MT_TOUCH_MAJOR,
-					     f1, f2, df / SN_WIDTH, 0);
-			return 1;
-		case HID_DG_HEIGHT:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TOUCH_MINOR);
-			input_set_abs_params(hi->input, ABS_MT_TOUCH_MINOR,
-					     f1, f2, df / SN_WIDTH, 0);
-			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
-					0, 1, 0, 0);
-			return 1;
-		case HID_DG_CONTACTID:
-			input_mt_init_slots(hi->input, MAX_SLOTS);
-			return 1;
-		}
-		/* let hid-input decide for the others */
-		return 0;
-
-	case 0xff000000:
-		/* we do not want to map these: no input-oriented meaning */
-		return -1;
-	}
-
-	return 0;
-}
-
-static int mmm_input_mapped(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
-{
-	/* tell hid-input to skip setup of these event types */
-	if (usage->type == EV_KEY || usage->type == EV_ABS)
-		set_bit(usage->type, hi->input->evbit);
-	return -1;
-}
-
-/*
- * this function is called when a whole packet has been received and processed,
- * so that it can decide what to send to the input layer.
- */
-static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
-{
-	int i;
-	for (i = 0; i < MAX_SLOTS; ++i) {
-		struct mmm_finger *f = &md->f[i];
-		if (!f->valid) {
-			/* this finger is just placeholder data, ignore */
-			continue;
-		}
-		input_mt_slot(input, i);
-		input_mt_report_slot_state(input, MT_TOOL_FINGER, f->touch);
-		if (f->touch) {
-			/* this finger is on the screen */
-			int wide = (f->w > f->h);
-			/* divided by two to match visual scale of touch */
-			int major = max(f->w, f->h) >> 1;
-			int minor = min(f->w, f->h) >> 1;
-
-			input_event(input, EV_ABS, ABS_MT_POSITION_X, f->x);
-			input_event(input, EV_ABS, ABS_MT_POSITION_Y, f->y);
-			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
-			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
-			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
-		}
-		f->valid = 0;
-	}
-
-	input_mt_report_pointer_emulation(input, true);
-	input_sync(input);
-}
-
-/*
- * this function is called upon all reports
- * so that we can accumulate contact point information,
- * and call input_mt_sync after each point.
- */
-static int mmm_event(struct hid_device *hid, struct hid_field *field,
-				struct hid_usage *usage, __s32 value)
-{
-	struct mmm_data *md = hid_get_drvdata(hid);
-	/*
-	 * strangely, this function can be called before
-	 * field->hidinput is initialized!
-	 */
-	if (hid->claimed & HID_CLAIMED_INPUT) {
-		struct input_dev *input = field->hidinput->input;
-		switch (usage->hid) {
-		case HID_DG_TIPSWITCH:
-			md->touch = value;
-			break;
-		case HID_DG_CONFIDENCE:
-			md->valid = value;
-			break;
-		case HID_DG_WIDTH:
-			if (md->valid)
-				md->f[md->curid].w = value;
-			break;
-		case HID_DG_HEIGHT:
-			if (md->valid)
-				md->f[md->curid].h = value;
-			break;
-		case HID_DG_CONTACTID:
-			value = clamp_val(value, 0, MAX_SLOTS - 1);
-			if (md->valid) {
-				md->curid = value;
-				md->f[value].touch = md->touch;
-				md->f[value].valid = 1;
-				md->nreal++;
-			}
-			break;
-		case HID_GD_X:
-			if (md->valid)
-				md->f[md->curid].x = value;
-			break;
-		case HID_GD_Y:
-			if (md->valid)
-				md->f[md->curid].y = value;
-			break;
-		case HID_DG_CONTACTCOUNT:
-			if (value)
-				md->nexp = value;
-			if (md->nreal >= md->nexp) {
-				mmm_filter_event(md, input);
-				md->nreal = 0;
-			}
-			break;
-		}
-	}
-
-	/* we have handled the hidinput part, now remains hiddev */
-	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
-		hid->hiddev_hid_event(hid, field, usage, value);
-
-	return 1;
-}
-
-static int mmm_probe(struct hid_device *hdev, const struct hid_device_id *id)
-{
-	int ret;
-	struct mmm_data *md;
-
-	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
-
-	md = kzalloc(sizeof(struct mmm_data), GFP_KERNEL);
-	if (!md) {
-		hid_err(hdev, "cannot allocate 3M data\n");
-		return -ENOMEM;
-	}
-	hid_set_drvdata(hdev, md);
-
-	ret = hid_parse(hdev);
-	if (!ret)
-		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-
-	if (ret)
-		kfree(md);
-	return ret;
-}
-
-static void mmm_remove(struct hid_device *hdev)
-{
-	hid_hw_stop(hdev);
-	kfree(hid_get_drvdata(hdev));
-	hid_set_drvdata(hdev, NULL);
-}
-
-static const struct hid_device_id mmm_devices[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M1968) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M2256) },
-	{ }
-};
-MODULE_DEVICE_TABLE(hid, mmm_devices);
-
-static const struct hid_usage_id mmm_grabbed_usages[] = {
-	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
-	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1}
-};
-
-static struct hid_driver mmm_driver = {
-	.name = "3m-pct",
-	.id_table = mmm_devices,
-	.probe = mmm_probe,
-	.remove = mmm_remove,
-	.input_mapping = mmm_input_mapping,
-	.input_mapped = mmm_input_mapped,
-	.usage_table = mmm_grabbed_usages,
-	.event = mmm_event,
-};
-
-static int __init mmm_init(void)
-{
-	return hid_register_driver(&mmm_driver);
-}
-
-static void __exit mmm_exit(void)
-{
-	hid_unregister_driver(&mmm_driver);
-}
-
-module_init(mmm_init);
-module_exit(mmm_exit);
-
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d31301e..0175f85 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -11,6 +11,12 @@
  *  Copyright (c) 2010 Henrik Rydberg <rydberg@euromail.se>
  *  Copyright (c) 2010 Canonical, Ltd.
  *
+ *  This code is partly based on hid-3m-pct.c:
+ *
+ *  Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
+ *  Copyright (c) 2010      Henrik Rydberg <rydberg@euromail.se>
+ *  Copyright (c) 2010      Canonical, Ltd.
+ *
  */
 
 /*
@@ -69,6 +75,8 @@ struct mt_class {
 	__s32 name;	/* MT_CLS */
 	__s32 quirks;
 	__s32 sn_move;	/* Signal/noise ratio for move events */
+	__s32 sn_width;	/* Signal/noise ratio for width events */
+	__s32 sn_height;	/* Signal/noise ratio for height events */
 	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
 	__u8 maxcontacts;
 };
@@ -80,6 +88,7 @@ struct mt_class {
 #define MT_CLS_CYPRESS				4
 #define MT_CLS_EGALAX				5
 #define MT_CLS_STANTUM				6
+#define MT_CLS_3M				7
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -141,6 +150,12 @@ struct mt_class mt_classes[] = {
 	},
 	{ .name = MT_CLS_STANTUM,
 		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
+	{ .name = MT_CLS_3M,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.sn_move = 2048,
+		.sn_width = 128,
+		.sn_height = 128 },
 
 	{ }
 };
@@ -230,11 +245,15 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
+			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
+				cls->sn_width);
 			td->last_slot_field = usage->hid;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
+			set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
+				cls->sn_height);
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
 			td->last_slot_field = usage->hid;
@@ -332,11 +351,18 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
 			s->touch_state);
 		if (s->touch_state) {
+			/* this finger is on the screen */
+			int wide = (s->w > s->h);
+			/* divided by two to match visual scale of touch */
+			int major = max(s->w, s->h) >> 1;
+			int minor = min(s->w, s->h) >> 1;
+
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
-			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->w);
-			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, s->h);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
 		}
 		s->seen_in_this_frame = false;
 
@@ -398,6 +424,15 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
+			if (td->last_field_index
+				&& field->index == td->last_field_index)
+				/* we reach here when the last field in the
+				 * report is not related to multitouch.
+				 * This is not good. As a temporary solution,
+				 * we trigger our mt event completion and
+				 * ignore the field.
+				 */
+				break;
 			/* fallback to the generic hidinput handling */
 			return 0;
 		}
@@ -513,6 +548,14 @@ static void mt_remove(struct hid_device *hdev)
 
 static const struct hid_device_id mt_devices[] = {
 
+	/* 3M panels */
+	{ .driver_data = MT_CLS_3M,
+		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+			USB_DEVICE_ID_3M1968) },
+	{ .driver_data = MT_CLS_3M,
+		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+			USB_DEVICE_ID_3M2256) },
+
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
-- 
1.7.4

