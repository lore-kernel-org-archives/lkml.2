Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1CIQBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:01:11 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:41430 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab1CIQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:01:08 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] hid-multitouch: migrate support for Stantum panels to the unified driver.
Date: Wed,  9 Mar 2011 17:00:48 +0100
Message-Id: <1299686450-5475-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges hid-stantum to the generic multitouch driver.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

no changes since v1 ;)

 drivers/hid/Kconfig          |    7 +-
 drivers/hid/Makefile         |    1 -
 drivers/hid/hid-multitouch.c |   14 ++
 drivers/hid/hid-stantum.c    |  286 ------------------------------------------
 4 files changed, 15 insertions(+), 293 deletions(-)
 delete mode 100644 drivers/hid/hid-stantum.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index b152c91..1c9ca3ad 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -321,6 +321,7 @@ config HID_MULTITOUCH
 	  - IrTouch Infrared USB panels
 	  - Pixcir dual touch panels
 	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
+	  - Stantum multitouch panel
 
 	  If unsure, say N.
 
@@ -487,12 +488,6 @@ config HID_SONY
 	---help---
 	Support for Sony PS3 controller.
 
-config HID_STANTUM
-	tristate "Stantum multitouch panel"
-	depends on USB_HID
-	---help---
-	Support for Stantum multitouch panel.
-
 config HID_SUNPLUS
 	tristate "Sunplus wireless desktop"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 04496ab..397344a 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -67,7 +67,6 @@ obj-$(CONFIG_HID_ROCCAT_PYRA)	+= hid-roccat-pyra.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
-obj-$(CONFIG_HID_STANTUM)	+= hid-stantum.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 8a5fcc0..525529c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -71,6 +71,7 @@ struct mt_class {
 #define MT_CLS_DUAL_INRANGE_CONTACTID		2
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	3
 #define MT_CLS_CYPRESS				4
+#define MT_CLS_STANTUM				5
 
 /*
  * these device-dependent functions determine what slot corresponds
@@ -120,6 +121,8 @@ struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_CYPRESS,
 		.maxcontacts = 10 },
+	{ .name = MT_CLS_STANTUM,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
 
 	{ }
 };
@@ -501,6 +504,17 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
+	/* Stantum panels */
+	{ .driver_data = MT_CLS_STANTUM,
+		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
+			USB_DEVICE_ID_MTP)},
+	{ .driver_data = MT_CLS_STANTUM,
+		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
+			USB_DEVICE_ID_MTP_STM)},
+	{ .driver_data = MT_CLS_STANTUM,
+		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
+			USB_DEVICE_ID_MTP_SITRONIX)},
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
diff --git a/drivers/hid/hid-stantum.c b/drivers/hid/hid-stantum.c
deleted file mode 100644
index b2be1d1..0000000
--- a/drivers/hid/hid-stantum.c
+++ /dev/null
@@ -1,286 +0,0 @@
-/*
- *  HID driver for Stantum multitouch panels
- *
- *  Copyright (c) 2009 Stephane Chatty <chatty@enac.fr>
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
-
-MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
-MODULE_DESCRIPTION("Stantum HID multitouch panels");
-MODULE_LICENSE("GPL");
-
-#include "hid-ids.h"
-
-struct stantum_data {
-	__s32 x, y, z, w, h;	/* x, y, pressure, width, height */
-	__u16 id;		/* touch id */
-	bool valid;		/* valid finger data, or just placeholder? */
-	bool first;		/* first finger in the HID packet? */
-	bool activity;		/* at least one active finger so far? */
-};
-
-static int stantum_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
-{
-	switch (usage->hid & HID_USAGE_PAGE) {
-
-	case HID_UP_GENDESK:
-		switch (usage->hid) {
-		case HID_GD_X:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_POSITION_X);
-			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_X,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
-			return 1;
-		case HID_GD_Y:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_POSITION_Y);
-			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_Y,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
-			return 1;
-		}
-		return 0;
-
-	case HID_UP_DIGITIZER:
-		switch (usage->hid) {
-		case HID_DG_INRANGE:
-		case HID_DG_CONFIDENCE:
-		case HID_DG_INPUTMODE:
-		case HID_DG_DEVICEINDEX:
-		case HID_DG_CONTACTCOUNT:
-		case HID_DG_CONTACTMAX:
-			return -1;
-
-		case HID_DG_TIPSWITCH:
-			/* touchscreen emulation */
-			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
-			return 1;
-
-		case HID_DG_WIDTH:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TOUCH_MAJOR);
-			return 1;
-		case HID_DG_HEIGHT:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TOUCH_MINOR);
-			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
-					1, 1, 0, 0);
-			return 1;
-		case HID_DG_TIPPRESSURE:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_PRESSURE);
-			return 1;
-
-		case HID_DG_CONTACTID:
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TRACKING_ID);
-			return 1;
-
-		}
-		return 0;
-
-	case 0xff000000:
-		/* no input-oriented meaning */
-		return -1;
-	}
-
-	return 0;
-}
-
-static int stantum_input_mapped(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
-{
-	if (usage->type == EV_KEY || usage->type == EV_ABS)
-		clear_bit(usage->code, *bit);
-
-	return 0;
-}
-
-/*
- * this function is called when a whole finger has been parsed,
- * so that it can decide what to send to the input layer.
- */
-static void stantum_filter_event(struct stantum_data *sd,
-					struct input_dev *input)
-{
-	bool wide;
-
-	if (!sd->valid) {
-		/*
-		 * touchscreen emulation: if the first finger is not valid and
-		 * there previously was finger activity, this is a release
-		 */
-		if (sd->first && sd->activity) {
-			input_event(input, EV_KEY, BTN_TOUCH, 0);
-			sd->activity = false;
-		}
-		return;
-	}
-
-	input_event(input, EV_ABS, ABS_MT_TRACKING_ID, sd->id);
-	input_event(input, EV_ABS, ABS_MT_POSITION_X, sd->x);
-	input_event(input, EV_ABS, ABS_MT_POSITION_Y, sd->y);
-
-	wide = (sd->w > sd->h);
-	input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
-	input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, wide ? sd->w : sd->h);
-	input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, wide ? sd->h : sd->w);
-
-	input_event(input, EV_ABS, ABS_MT_PRESSURE, sd->z);
-
-	input_mt_sync(input);
-	sd->valid = false;
-
-	/* touchscreen emulation */
-	if (sd->first) {
-		if (!sd->activity) {
-			input_event(input, EV_KEY, BTN_TOUCH, 1);
-			sd->activity = true;
-		}
-		input_event(input, EV_ABS, ABS_X, sd->x);
-		input_event(input, EV_ABS, ABS_Y, sd->y);
-	}
-	sd->first = false;
-}
-
-
-static int stantum_event(struct hid_device *hid, struct hid_field *field,
-				struct hid_usage *usage, __s32 value)
-{
-	struct stantum_data *sd = hid_get_drvdata(hid);
-
-	if (hid->claimed & HID_CLAIMED_INPUT) {
-		struct input_dev *input = field->hidinput->input;
-
-		switch (usage->hid) {
-		case HID_DG_INRANGE:
-			/* this is the last field in a finger */
-			stantum_filter_event(sd, input);
-			break;
-		case HID_DG_WIDTH:
-			sd->w = value;
-			break;
-		case HID_DG_HEIGHT:
-			sd->h = value;
-			break;
-		case HID_GD_X:
-			sd->x = value;
-			break;
-		case HID_GD_Y:
-			sd->y = value;
-			break;
-		case HID_DG_TIPPRESSURE:
-			sd->z = value;
-			break;
-		case HID_DG_CONTACTID:
-			sd->id = value;
-			break;
-		case HID_DG_CONFIDENCE:
-			sd->valid = !!value;
-			break;
-		case 0xff000002:
-			/* this comes only before the first finger */
-			sd->first = true;
-			break;
-
-		default:
-			/* ignore the others */
-			return 1;
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
-static int stantum_probe(struct hid_device *hdev,
-				const struct hid_device_id *id)
-{
-	int ret;
-	struct stantum_data *sd;
-
-	sd = kmalloc(sizeof(struct stantum_data), GFP_KERNEL);
-	if (!sd) {
-		hid_err(hdev, "cannot allocate Stantum data\n");
-		return -ENOMEM;
-	}
-	sd->valid = false;
-	sd->first = false;
-	sd->activity = false;
-	hid_set_drvdata(hdev, sd);
-
-	ret = hid_parse(hdev);
-	if (!ret)
-		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-
-	if (ret)
-		kfree(sd);
-
-	return ret;
-}
-
-static void stantum_remove(struct hid_device *hdev)
-{
-	hid_hw_stop(hdev);
-	kfree(hid_get_drvdata(hdev));
-	hid_set_drvdata(hdev, NULL);
-}
-
-static const struct hid_device_id stantum_devices[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM, USB_DEVICE_ID_MTP) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM, USB_DEVICE_ID_MTP_STM) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX, USB_DEVICE_ID_MTP_SITRONIX) },
-	{ }
-};
-MODULE_DEVICE_TABLE(hid, stantum_devices);
-
-static const struct hid_usage_id stantum_grabbed_usages[] = {
-	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
-	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1}
-};
-
-static struct hid_driver stantum_driver = {
-	.name = "stantum",
-	.id_table = stantum_devices,
-	.probe = stantum_probe,
-	.remove = stantum_remove,
-	.input_mapping = stantum_input_mapping,
-	.input_mapped = stantum_input_mapped,
-	.usage_table = stantum_grabbed_usages,
-	.event = stantum_event,
-};
-
-static int __init stantum_init(void)
-{
-	return hid_register_driver(&stantum_driver);
-}
-
-static void __exit stantum_exit(void)
-{
-	hid_unregister_driver(&stantum_driver);
-}
-
-module_init(stantum_init);
-module_exit(stantum_exit);
-
-- 
1.7.4

