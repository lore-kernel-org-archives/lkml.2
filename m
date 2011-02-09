Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1BIRmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:42:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46103 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab1BIRmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oViBvvYHomvVO2eu3VsI0mgLC1/8BhCsuITi0CU4zZLqZJrIrCR/foFbTiGNANwrK+
         Hp/OSGPu55QaixkQSmTOWhR2agsMH0n+4NrOe0SIqoPVnPRpMKeLAzAhUPOgrAZsuqJn
         97FzaoOK69Qy9MhcYTu5V2710B8Z6HM8yOcPk=
From: kverlin@gmail.com
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        rydberg@euromail.se
Cc: Anton Chikin <anton.chikin@dataart.com>
Subject: [PATCH] hid: Panasonic UB-T780 and UB-T880 driver
Date: Wed,  9 Feb 2011 09:42:03 -0800
Message-Id: <1297273323-8015-1-git-send-email-kverlin@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Chikin <anton.chikin@dataart.com>

Panasonic Elite Panaboard UB-T* hid driver.
Removed all unnesessary comments and debug stuff. Multitouch now uses Protocol B.
Still parsing by hands because of incompatible report descriptor in UB-T780.
---
 drivers/hid/Kconfig      |    6 +
 drivers/hid/Makefile     |    1 +
 drivers/hid/hid-ids.h    |    5 +
 drivers/hid/hid-ubt880.c |  381 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ubt880.h |   81 ++++++++++
 5 files changed, 474 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-ubt880.c
 create mode 100644 drivers/hid/hid-ubt880.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 2560f01..5c96c63 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -324,6 +324,12 @@ config HID_ORTEK
 	---help---
 	Support for Ortek WKB-2000 wireless keyboard + mouse trackpad.
 
+config HID_PANASONIC
+	tristate "Panasonic Elite Panaboards"
+	depends on USB_HID
+	---help---
+	Support for Panasonic Elite Panaboard UB-T780 and UB-T880.
+
 config HID_PANTHERLORD
 	tristate "Pantherlord/GreenAsia game controller"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 6efc2a0..85f3495 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
 obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
 obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
 obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
+obj-$(CONFIG_HID_PANASONIC)     += hid-ubt880.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92a0d61..3ca7171 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -468,6 +468,11 @@
 #define USB_VENDOR_ID_ORTEK		0x05a4
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
+#define USB_VENDOR_ID_PANASONIC		0x04da
+#define USB_DEVICE_ID_PANABOARD_780	0x1044
+#define USB_DEVICE_ID_PANABOARD_880	0x104d
+#define USB_DEVICE_ID_PANABOARD_880_PEN 0x104e
+
 #define USB_VENDOR_ID_PANJIT		0x134c
 
 #define USB_VENDOR_ID_PANTHERLORD	0x0810
diff --git a/drivers/hid/hid-ubt880.c b/drivers/hid/hid-ubt880.c
new file mode 100644
index 0000000..bbcb817
--- /dev/null
+++ b/drivers/hid/hid-ubt880.c
@@ -0,0 +1,381 @@
+/*
+ *  USB HID driver for Panasonic elite Panaboard UTB780
+ *   Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
+ *   Copyright (c) 2010-2011 Anton Chikin<anton.chikin@dataart.com> for Panasonic.
+ *
+ *  Information.
+ *  It's driver for supporting Panasonic Elite Panaboard HID USB device.
+ *
+ *  This file is part of USB HID driver for Panasonic elite Panaboard UTB780.
+ *
+ *  This driver is free software: you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation, either version 3 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This driver is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include "hid-ids.h"
+#include "hid-ubt880.h"
+#include "usbhid/usbhid.h"
+/*switch_mode : Our device has two modes: mouse mode in which it is acting like mouse, producing
+ * absolute coordinates [0 - 4095]
+ * The second mode is digitizer mode, which produce two raw clock measurments from ultrasound
+ * recievers in the top-left corner of the board. This mode more flexible and also reports batterey
+ * status of digitizer pen and penID.
+ */
+static int ubt880_switch_mode(struct hid_device *hid, unsigned char mode)
+{
+	struct hid_report *report = NULL;
+	struct hid_report *report_cur = NULL;
+	__s32 *val = NULL;
+	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
+	{
+		if (hid->report_enum[HID_FEATURE_REPORT].numbered)
+			report_cur = report;
+	}
+	if (report_cur == NULL)
+		return -EIO;
+
+	val = report_cur->field[0]->value;
+	val[0] = mode;
+	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
+	return 0;
+}
+
+static int ubt780_switch_mode(struct hid_device *hid, unsigned char mode)
+{
+	struct hid_report *report = NULL;
+	struct hid_report *report_cur = NULL;
+	__s32 *val = NULL;
+	list_for_each_entry(report, &hid->report_enum[HID_OUTPUT_REPORT].report_list, list)
+	{
+		if (hid->report_enum[HID_OUTPUT_REPORT].numbered)
+			report_cur = report;
+	}
+
+	if (report_cur == NULL)
+		return -EIO;
+
+	val = report_cur->field[0]->value;
+	val[0] = 0x7e;
+	val[1] = 0x04;
+	val[2] = 0x4d;
+	val[3] = mode;
+	val[4] = 0x00;
+	val[5] = 0x0a;
+	val[6] = 0x00;
+	val[7] = 0x00;
+	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
+	return 0;
+}
+
+/* PenToInt : converts ultrasound clock measurements to screen coordinates.*/
+static bool ubt_pen_to_int(int *pLeft, int *pRight, struct ubt_data *drvdata)
+{
+	int left2, right2 , n, w_n, sqr, xx, yy;
+	static int w = 1164;
+
+	left2  = (*pLeft) * (*pLeft);
+	right2 = (*pRight) * (*pRight);
+
+	if (left2 == 0 && right2 == 0) {
+		*pLeft = drvdata->xold;
+		*pRight = drvdata->yold;
+	    return true;
+	}
+
+	n = (right2 - left2) / (2 * w);
+	w_n = w-n;
+
+	sqr = (2 * left2 - (w_n * w_n));
+
+	if (sqr < 0)
+		return false;
+
+	xx = (w_n + int_sqrt(sqr)) / 2;
+	yy = xx + n;
+
+	if (xx < 0 || yy < 0)
+		return false;
+
+	*pLeft = xx;
+	*pRight = yy;
+	drvdata->xold = xx;
+	drvdata->yold = yy;
+
+	return true;
+}
+
+static int ubt880_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	/*Just ignore all fields*/
+	return -1;
+}
+static int ubt880_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
+	/*Just prevent further processing by hid*/
+	return 1;
+}
+static void ubt880_set_input(struct input_dev *input)
+{
+	/* Basics */
+	/*We have a key*/
+	__set_bit(EV_KEY, input->evbit);
+	__set_bit(BTN_LEFT, input->keybit);
+	__set_bit(BTN_RIGHT, input->keybit);
+	/*two absolute axis*/
+	__set_bit(EV_ABS, input->evbit);
+	__set_bit(ABS_X, input->absbit);
+	__set_bit(ABS_Y, input->absbit);
+	/*two absolute MT axis and tracking IDs*/
+	input_set_abs_params(input, ABS_MT_POSITION_X, 0, UBT880_MAX_AXIS_X, 0, 0);
+	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, UBT880_MAX_AXIS_Y, 0, 0);
+	input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 3, 0, 0);
+	input_set_abs_params(input, ABS_X, 0, UBT880_MAX_AXIS_X, 0, 0);
+	input_set_abs_params(input, ABS_Y, 0, UBT880_MAX_AXIS_Y, 0, 0);
+	input_mt_create_slots(input, NUM_CONTACTS);
+}
+
+static void ubt780_set_input(struct input_dev *input)
+{
+	input->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS);
+	input->absbit[0] |= BIT(ABS_X) | BIT(ABS_Y);
+	set_bit(BTN_LEFT, input->keybit);
+	set_bit(BTN_RIGHT, input->keybit);
+
+	input->absmax[ABS_X] = UBT780_MAX_AXIS_X;
+	input->absmax[ABS_Y] = UBT780_MAX_AXIS_Y;
+	input->absmin[ABS_X] = 0;
+	input->absmin[ABS_Y] = 0;
+}
+
+int ubt_set_device(struct ubt_data *data, struct hid_device *hdev)
+{
+	int ret;
+	switch (hdev->product) {
+	case USB_DEVICE_ID_PANABOARD_UBT780: {
+		data->switch_mode = ubt780_switch_mode;
+		data->set_input = ubt780_set_input;
+		ubt780_switch_mode(hdev, MODE_DGTZR);
+		data->current_mode = MODE_DGTZR;
+		break;
+	}
+	case USB_DEVICE_ID_PANABOARD_UBT880: {
+		data->switch_mode = ubt880_switch_mode;
+		data->set_input = ubt880_set_input;
+		ubt880_switch_mode(hdev, MODE_MULTITOUCH);
+		data->current_mode = MODE_MULTITOUCH;
+		break;
+	}
+	default: {
+		ret = -1;
+	}
+	}
+	return 0;
+}
+static int ubt880_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+	struct ubt_data *drvdata;
+	struct hid_input *hidinput = NULL;
+	struct input_dev *input;
+
+	drvdata = kmalloc(sizeof(struct ubt_data), GFP_KERNEL);
+	if (!drvdata) {
+		dev_err(&hdev->dev, "cannot allocate UB-T880 data\n");
+		return -ENOMEM;
+	}
+
+	hid_set_drvdata(hdev, drvdata);
+
+	ret = hid_parse(hdev);
+	if (!ret) {
+		/*We need HIDINPUT dev only. We have our own char device instead of hidraw*/
+		ret = hid_hw_start(hdev, HID_CONNECT_HIDINPUT);
+	}
+
+	if (ret) {
+		kfree(drvdata);
+		goto skip_input;
+	}
+	ubt_set_device(drvdata, hdev);
+
+	hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
+	if (hidinput == NULL)
+		goto skip_input;
+
+	input = hidinput->input;
+	drvdata->set_input(input);
+skip_input:
+	return ret;
+}
+
+static void ubt_report_input(struct input_dev *input, unsigned int x, unsigned int y, int btn_left, int btn_right)
+{
+	input_report_key(input, BTN_LEFT, btn_left);
+	input_report_key(input, BTN_RIGHT, btn_right);
+	input_report_abs(input, ABS_X, x);
+	input_report_abs(input, ABS_Y, y);
+	input_sync(input);
+}
+/* Report MT to the input subsystem*/
+static void ubt880_report_contact(struct input_dev *input, struct ubt_mt_contact *contact)
+{
+	/* Contact id's are allways 1..3 so we can determine slot
+	 * without keeping contact data in device data.
+	 */
+	input_mt_slot(input, contact->id - 1);
+	if (!contact->flags) {
+		input_report_abs(input, ABS_MT_TRACKING_ID, -1);
+	} else {
+		input_report_abs(input, ABS_MT_TRACKING_ID, contact->id);
+		input_report_abs(input, ABS_MT_POSITION_X, contact->x);
+		input_report_abs(input, ABS_MT_POSITION_Y, contact->y);
+	}
+}
+static void ubt880_report_mt(struct input_dev *input, struct ubt_mt_contact *pack, int size)
+{
+	int i = 0;
+	/* Report MT contacts */
+	if (size < 1)
+		return;
+	if (!input || !pack)
+		return;
+
+	for (i = 0; i < size; i++)
+		ubt880_report_contact(input, &pack[i]);
+
+	input_sync(input);
+	/* Emulate single-touch device. Only first contact is used. */
+	/* Note that is already calibrated */
+	ubt_report_input(input, pack[0].x, pack[0].y, pack[0].flags & 0x01, 0);
+}
+
+static struct input_dev *ubt880_get_input(struct hid_device *hdev)
+{
+	struct hid_input *hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
+	struct input_dev *input;
+
+	if (!hidinput)
+		return 0;
+	input = hidinput->input;
+	return input;
+}
+static int ubt880_raw_event(struct hid_device *hdev, struct hid_report *report, u8 *data, int size)
+{
+	struct ubt_data *driver_data = hid_get_drvdata(hdev);
+
+	struct input_dev *input = ubt880_get_input(hdev);
+	if (!input)
+		return -1;
+
+	if (!driver_data)
+		return -1;
+	/*Save the packet for userspace processing*/
+	/*Mouse mode packet*/
+	switch (data[0]) {
+	case 0x01: {
+		int leftbtn, rightbtn;
+		struct ubt880_dgtzr *pack = (struct ubt880_dgtzr *)data;
+		if (driver_data->current_mode == MODE_UKN)
+			driver_data->current_mode = MODE_MOUSE;
+		leftbtn = pack->command & 0x01;
+		rightbtn = (pack->command & 0x02) >> 1;
+		ubt_report_input(input, pack->data[0], pack->data[1], leftbtn, rightbtn);
+		if (driver_data->current_mode != MODE_MOUSE)
+			ubt880_switch_mode(hdev, MODE_MOUSE);
+		break;
+	}
+	case 0x02: {
+		struct ubt780_dgtzr *pack = (struct ubt780_dgtzr *)data;
+		if (driver_data->current_mode == MODE_UKN)
+			driver_data->current_mode = MODE_DGTZR;
+
+		if (driver_data->current_mode == MODE_MOUSE) {
+			driver_data->switch_mode(hdev, MODE_MOUSE);
+		} else if (driver_data->current_mode == MODE_DGTZR) {
+			unsigned short *pCoord = (unsigned short *)(&pack->data[3]);
+			int X = (int) pCoord[0];
+			int Y = (int) pCoord[1];
+			int leftBtn = pack->data[2] >> 5 & 0x01;
+			int rightBtn = pack->data[2] >> 4 & 0x01;
+			if (ubt_pen_to_int(&X, &Y, driver_data))
+				ubt_report_input(input, X, Y, leftBtn, rightBtn);
+		}
+		break;
+	}
+	case 0x03: {
+		struct ubt_mt_packet *packet = (struct ubt_mt_packet *)data;
+		if (driver_data->current_mode == MODE_UKN)
+			driver_data->current_mode = MODE_MULTITOUCH;
+
+		if (driver_data->current_mode == MODE_MOUSE) {
+			driver_data->switch_mode(hdev, MODE_MOUSE);
+		} else if (driver_data->current_mode == MODE_MULTITOUCH) {
+			ubt880_report_mt(input, (struct ubt_mt_contact *)&packet->data[1], packet->data[19]);
+		}
+		break;
+	}
+	}
+
+	return 0;
+}
+static void ubt880_remove(struct hid_device *hdev)
+{
+
+	hid_hw_stop(hdev);
+	kfree(hid_get_drvdata(hdev));
+	hid_set_drvdata(hdev, NULL);
+}
+
+static struct hid_device_id ubt880_devices[] = {
+	{ HID_USB_DEVICE(0x04da, 0x104d) },
+	{ HID_USB_DEVICE(0x04da, 0x1044) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, ubt880_devices);
+
+static struct hid_driver ubt880_driver = {
+	.name = "ubt880",
+	.id_table = ubt880_devices,
+	.probe = ubt880_probe,
+	.remove = ubt880_remove,
+	.input_mapping = ubt880_input_mapping,
+	.raw_event = ubt880_raw_event,
+	.event = ubt880_event,
+};
+
+static int __init ubt880_init(void)
+{
+	int retval = hid_register_driver(&ubt880_driver);
+	return retval;
+}
+
+static void __exit ubt880_exit(void)
+{
+	hid_unregister_driver(&ubt880_driver);
+}
+
+module_init(ubt880_init);
+module_exit(ubt880_exit);
+
+MODULE_AUTHOR("Anton Chikin <kverlin@gmail.com>");
+MODULE_DESCRIPTION("Panasonic UB-T780 driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ubt880.h b/drivers/hid/hid-ubt880.h
new file mode 100644
index 0000000..ac76165
--- /dev/null
+++ b/drivers/hid/hid-ubt880.h
@@ -0,0 +1,81 @@
+/*
+ *  USB HID driver for Panasonic elite Panaboard UTB780
+ *   Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
+ *   Copyright (c) 2010-2011 Anton Chikin<anton.chikin@dataart.com> for Panasonic.
+ *
+ *  Information.
+ *  It's driver for supporting Panasonic Elite Panaboard HID USB device.
+ *
+ *  This file is part of USB HID driver for Panasonic elite Panaboard UTB780.
+ *
+ *  This driver is free software: you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation, either version 3 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This driver is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/hid.h>
+#ifndef UBT780CTRL
+#define UBT780CTRL
+
+/** Battary status defines */
+#define BATTERY_STATUS_FINE		0x00 /*battery is fine*/
+#define BATTERY_STATUS_WEAK		0x01 /*battery is weak*/
+#define BATTERY_STATUS_UKN		0x02 /*unknown status. Status will be known after the first pen touch*/
+
+/** Mode status defines */
+#define MODE_MOUSE			0x00 /*current mode is mouse*/
+#define MODE_DGTZR			0x01 /*current mode is digitizer*/
+#define MODE_MULTITOUCH                 0x02
+#define MODE_UKN			0x05 /*current mode is unknown. It will be known after the first pen touch*/
+
+#define UBT780_MAX_AXIS_X	4095
+#define UBT780_MAX_AXIS_Y	4095
+#define UBT880_MAX_AXIS_X	32767
+#define UBT880_MAX_AXIS_Y	32767
+#define NUM_CONTACTS		0x03
+/** Digitizer mode stucture: contains packet data */
+struct ubt880_dgtzr {
+	/** Report contains the type of packet: 0 - mouse, 1 - digitize */
+	unsigned char report;
+	/** Command is coming from device */
+	unsigned char command;
+	/** Packet size */
+	unsigned short data[2];
+};
+
+struct ubt780_dgtzr {
+	/** Report contains the type of packet: 0 - mouse, 1 - digitize */
+	unsigned char report;
+	/** Command is coming from device */
+	unsigned char command;
+	/** Packet size */
+	unsigned char number;
+	/** Data part of packet */
+	unsigned char data[17];
+};
+struct ubt_data {
+	unsigned char current_mode;
+	int (*switch_mode) (struct hid_device *hid, unsigned char mode);
+	void (*set_input) (struct input_dev *input);
+	int xold;
+	int yold;
+};
+/*ubt880 multitouch structures*/
+struct ubt_mt_contact {
+	unsigned char flags;
+	unsigned char id;
+	unsigned short x;
+	unsigned short y;
+};
+struct ubt_mt_packet {
+	unsigned char data[20];
+};
+#endif /* UBT780CTRL */
-- 
1.7.1

