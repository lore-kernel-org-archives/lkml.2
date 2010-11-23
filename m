Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0KWQWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:22:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64514 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab0KWQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kuhqayJSTJ8Ulc0dejIds8aYwBwC6XDJjKRcB3oAP1aSQUm22gWfPqXawUguw9mBo/
         rob6Jkbh7zGt7ntc/ggmMeTm9wsn2zwgggdczv2KEYDG933A9vzpwzVU9rHz0J3NJR3N
         dkWUiWg3xFShom13YZr/LxECEomF/GMV8f/18=
From: kverlin@gmail.com
To: jkosina@suse.de
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rydberg@euromail.se
Subject: [PATCH] USB: HID: Panasonic ub-t780 whiteboard hid driver stub.
Date: Tue, 23 Nov 2010 16:22:38 +0000
Message-Id: <1290529358-6616-1-git-send-email-Anton.Chikin@dataart.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Chikin <kverlin@panasonic-box.(none)>

---
 drivers/hid/Kconfig      |    6 +
 drivers/hid/Makefile     |    1 +
 drivers/hid/hid-core.c   |    2 +
 drivers/hid/hid-ubt780.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/ubt780ctrl.h |  109 +++++++++++++++++++++
 5 files changed, 355 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-ubt780.c
 create mode 100644 drivers/hid/ubt780ctrl.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3052e29..ee912e2 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -114,6 +114,12 @@ config HID_CHICONY
 	---help---
 	Support for Chicony Tactical pad.
 
+config HID_PANASONIC
+	tristate "Panasonic UB-T780 whiteboard"
+	depends on USB_HID
+	---help---
+	Support for Panasonic Elite Panaboard UB-T780
+
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
 	depends on USB_HID && SND
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index c335605..7404929 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
 obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
 obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
 obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
+obj-$(CONFIG_HID_PANASONIC)	+= hid-ubt780.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 515345b..263210a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1366,6 +1366,8 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T780)},
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T880)},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
diff --git a/drivers/hid/hid-ubt780.c b/drivers/hid/hid-ubt780.c
new file mode 100644
index 0000000..c2c2e20
--- /dev/null
+++ b/drivers/hid/hid-ubt780.c
@@ -0,0 +1,237 @@
+/*
+ *  HID driver for Cando dual-touch panels
+ *
+ *  Copyright (c) 2010 Stephane Chatty <chatty@enac.fr>
+ *
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+
+#include "hid-ids.h"
+#define UBT780_DEBUG
+
+#ifdef UBT780_DEBUG
+#define UBT_DUMMY_DEBUG if(ubt_debug) printk(KERN_DEBUG "ubt780: %s:%s line %i\n", __FILE__,__FUNCTION__ , __LINE__);
+#else
+#define UBT_DUMMY_DEBUG
+#endif
+
+static int ubt_debug=0;
+module_param_named(debug_enabled, ubt_debug, int, 0600);
+MODULE_PARM_DESC(debug_enabled, "toggle UBT debugging messages");
+
+struct ubt780_data {
+	struct ubt780_calib calib;
+	struct ubt780_dgtzr ubt_packet;
+};
+
+static int ubt780_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	UBT_DUMMY_DEBUG
+	switch (usage->hid & HID_USAGE_PAGE) {
+
+	case HID_UP_GENDESK:
+		switch (usage->hid) {
+		case HID_GD_X:
+			hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_POSITION_X);
+			/* touchscreen emulation */
+			input_set_abs_params(hi->input, ABS_X,
+						field->logical_minimum,
+						field->logical_maximum, 0, 0);
+			return 1;
+		case HID_GD_Y:
+			hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_POSITION_Y);
+			/* touchscreen emulation */
+			input_set_abs_params(hi->input, ABS_Y,
+						field->logical_minimum,
+						field->logical_maximum, 0, 0);
+			return 1;
+		}
+		return 0;
+
+	case HID_UP_DIGITIZER:
+		switch (usage->hid) {
+		case HID_DG_TIPSWITCH:
+		case HID_DG_CONTACTMAX:
+			return -1;
+		case HID_DG_INRANGE:
+			/* touchscreen emulation */
+			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
+			return 1;
+		case HID_DG_CONTACTID:
+			hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_TRACKING_ID);
+			return 1;
+		}
+		return 0;
+	}
+
+	return 0;
+}
+
+static int ubt780_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	UBT_DUMMY_DEBUG
+	if (usage->type == EV_KEY || usage->type == EV_ABS)
+		clear_bit(usage->code, *bit);
+
+	return 0;
+}
+
+/*
+ * this function is called when a whole finger has been parsed,
+ * so that it can decide what to send to the input layer.
+ */
+
+
+static int ubt780_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
+	struct ubt780_data *td = hid_get_drvdata(hid);
+
+	UBT_DUMMY_DEBUG
+
+	if (hid->claimed & HID_CLAIMED_INPUT) {
+		struct input_dev *input = field->hidinput->input;
+
+		switch (usage->hid) {
+		case HID_DG_INRANGE:
+			//td->valid = value;
+			 UBT_DUMMY_DEBUG
+			break;
+		case HID_DG_CONTACTID:
+			//td->id = value;
+			UBT_DUMMY_DEBUG
+			break;
+		case HID_GD_X:
+			//td->x = value;
+			UBT_DUMMY_DEBUG
+			break;
+		case HID_GD_Y:
+			//td->y = value;
+			UBT_DUMMY_DEBUG
+			//ubt780_filter_event(td, input);
+			break;
+		case HID_DG_TIPSWITCH:
+			/* avoid interference from generic hidinput handling */
+			UBT_DUMMY_DEBUG
+			break;
+
+		default:
+			/* fallback to the generic hidinput handling */
+			return 0;
+		}
+	}
+
+	/* we have handled the hidinput part, now remains hiddev */
+	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
+		hid->hiddev_hid_event(hid, field, usage, value);
+
+	return 1;
+}
+
+static int ubt780_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+	struct ubt780_data *td;
+
+	UBT_DUMMY_DEBUG
+	printk(KERN_DEBUG "Device : %X",hdev->product);
+	td = kmalloc(sizeof(struct ubt780_data), GFP_KERNEL);
+	if (!td) {
+		dev_err(&hdev->dev, "cannot allocate UB-T780 data\n");
+		return -ENOMEM;
+	}
+
+
+	hid_set_drvdata(hdev, td);
+	/*td->first = false;
+	td->oldest = -1;
+	td->valid = false;*/
+
+	ret = hid_parse(hdev);
+	printk(KERN_DEBUG "hid_parse() returned : %d",ret);
+	if (!ret)
+	{
+		printk(KERN_DEBUG "Trying hid_hw_start");
+		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT );
+	}
+
+	printk(KERN_DEBUG "hid_hw_start() returned : %d",ret);
+	if (ret)
+		kfree(td);
+
+	return ret;
+}
+
+static void ubt780_remove(struct hid_device *hdev)
+{
+	UBT_DUMMY_DEBUG
+	hid_hw_stop(hdev);
+	kfree(hid_get_drvdata(hdev));
+	hid_set_drvdata(hdev, NULL);
+}
+
+static struct hid_device_id ubt780_devices[] = {
+	{ HID_USB_DEVICE(0x04da, 0x1044) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, ubt780_devices);
+
+static const struct hid_usage_id ubt780_grabbed_usages[] = {
+	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
+	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1}
+};
+
+static struct hid_driver ubt780_driver = {
+	.name = "ubt780",
+	.id_table = ubt780_devices,
+	.probe = ubt780_probe,
+	.remove = ubt780_remove,
+	.input_mapping = ubt780_input_mapping,
+	.input_mapped = ubt780_input_mapped,
+	.usage_table = ubt780_grabbed_usages,
+	.event = ubt780_event,
+};
+
+static int __init ubt780_init(void)
+{
+	UBT_DUMMY_DEBUG
+	int retval = hid_register_driver(&ubt780_driver);
+
+
+	if(retval)
+		UBT_DUMMY_DEBUG
+
+	return 0;
+}
+
+static void __exit ubt780_exit(void)
+{
+	UBT_DUMMY_DEBUG
+	hid_unregister_driver(&ubt780_driver);
+}
+
+module_init(ubt780_init);
+module_exit(ubt780_exit);
+
+MODULE_AUTHOR("Anton Chikin <kverloin@gmail.com>");
+MODULE_DESCRIPTION("Panasonic UB-T780 driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/ubt780ctrl.h b/drivers/hid/ubt780ctrl.h
new file mode 100644
index 0000000..11810c8
--- /dev/null
+++ b/drivers/hid/ubt780ctrl.h
@@ -0,0 +1,108 @@
+/*
+ *  USB HID driver for Panasonic elite Panaboard UTB780
+ *  Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
+
+ * Information.
+ * It's driver for supporting Panaboard elite USB device.
+ * The driver is redesigned using usb hid core driver:
+ * Copyright (c) 1999 Andreas Gal
+ * Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
+ * Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
+ * Copyright (c) 2010 Panasonic
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef UBT780CTRL
+#define UBT780CTRL
+
+//////////////////////////////////////////////////////////////////////////////////////////////////
+//IOCTRL codes
+/** Battary status IOCTL defines */
+#define GET_BATTERY_STATUS		0x01 /*get battery status, return BATTERY_STATUS_UKN, BATTERY_STATUS_FINE, BATTERY_STATUS_WEAK*/
+#define GET_LAST_PACKET_OLD		0x02 /*get last packet (ubt780_dgtzr). It is necessary for calibration*/
+
+/** Modes of work IOCTL */
+#define GET_MODE			0x10 /*get current mode, return MODE_MOUSE, MODE_DGTZR*/
+#define SET_MODE			0x11 /*switch to mouse mode, MODE_MOUSE, MODE_DGTZR*/
+#define SET_CALIB			0x20 /*set calibration mode*/
+#define GET_LAST_PACKET			0x21 /*get last packet (ubt780_dgtzr). It is necessary for calibration*/
+
+////////////////////////////////
+//return values for ioctrl
+/** Battary status defines */
+#define BATTERY_STATUS_FINE		0x00 /*battery is fine*/
+#define BATTERY_STATUS_WEAK		0x01 /*battery is weak*/
+#define BATTERY_STATUS_UKN		0x02 /*unknown status. Status will be known after the first pen touch*/
+
+/** Mode status defines */
+#define MODE_MOUSE			0x10 /*current mode is mouse*/
+#define MODE_DGTZR			0x11 /*current mode is digitizer*/
+#define MODE_UKN			0x12 /*current mode is unknown. It will be known after the first pen touch*/
+
+////////////////////////////////
+/** Digitize mode stucture: contains packet data */
+struct ubt780_dgtzr
+{
+	/** Report contains the type of packet: 0 - mouse, 1 - digitize */
+	unsigned char report;
+	/** Command is coming from device */
+	unsigned char command;
+	/** Packet size */
+	unsigned char number;
+	/** Data part of packet */
+	unsigned char data[17];
+};
+
+/** Calibration stucture: contains calibration data */
+struct ubt780_calib
+{
+	/** Screen coordinates: Left Top X */
+	int LTx;
+	/** Screen coordinates: Left Top Y */
+	int LTy;
+	/** Screen coordinates: Left Bottom X */
+	int LBx;
+	/** Screen coordinates: Left Bottom Y */
+	int LBy;
+	/** Screen coordinates: Right Top X */
+	int RTx;
+	/** Screen coordinates: Right Top Y */
+	int RTy;
+	/** Screen coordinates: Right Bottom X */
+	int RBx;
+	/** Screen coordinates: Right Bottom Y */
+	int RBy;
+
+	/** Board coordinates: Left Top X */
+	int LTX;
+	/** Board coordinates: Left Top Y */
+	int LTY;
+	/** Board coordinates: Left Bottom X */
+	int LBX;
+	/** Board coordinates: Left Bottom Y */
+	int LBY;
+	/** Board coordinates: Right Top X */
+	int RTX;
+	/** Board coordinates: Right Top Y */
+	int RTY;
+	/** Board coordinates: Right Bottom X */
+	int RBX;
+	/** Board coordinates: Right Bottom Y */
+	int RBY;
+
+	/** Calculated values */
+	int Xoff_A;
+	int Xmag_A;
+	int Xmag_B;
+	int Yoff_A;
+	int Ymag_A;
+	int Ymag_B;
+};
+
+#endif //UBT780CTRL
-- 
1.6.3.3

