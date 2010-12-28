Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0L1Rp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:45:59 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44462 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0L1Rp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NM+QPKr64XP0d9hhijJd+1uiA9GHZLEbIrgxOZZf3Cmv7nvOFJWTDKN9jmkUxdVfcw
         DqcW/hdLOO4YbgzTvM0dWX7vdabixlkaxThBOPmHZkjJJEOV1XDm+ultrMTGCwUMKH88
         aEjTlLYq/0nKIusIwjX6qrDood2lVpPHDPKMQ=
From: Anton Chikin <kverlin@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Anton Chikin <anton.chikin@dataart.com>
Subject: [PATCH] HID: New driver for Panasonic Elite Panaboard UB-T780 usb hid device.
Date: Tue, 28 Dec 2010 09:45:23 -0800
Message-Id: <1293558323-22367-1-git-send-email-anton.chikin@dataart.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Chikin <kverlin@ubuntu.(none)>

Signed-off-by: Anton Chikin <anton.chikin@dataart.com>
---
 drivers/hid/Kconfig      |    6 +
 drivers/hid/Makefile     |    1 +
 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-ids.h    |    3 +
 drivers/hid/hid-ubt780.c |  885 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ubt780.h |  140 ++++++++
 6 files changed, 1036 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-ubt780.c
 create mode 100644 drivers/hid/hid-ubt780.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3052e29..a191093 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -296,6 +296,12 @@ config HID_ORTEK
 	---help---
 	Support for Ortek WKB-2000 wireless keyboard + mouse trackpad.
 
+config HID_PANASONIC_WHITEBOARD
+	tristate "Panasonic Elite Panaboard UB-T780"
+	depends on USB_HID
+	---help---
+	Support for Panasonic Elite Panaboard - touch-enabled whiteboard from Panasonic.
+
 config HID_PANTHERLORD
 	tristate "Pantherlord/GreenAsia game controller"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index c335605..4e32b8b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
 obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
 obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
 obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
+obj-$(CONFIG_HID_PANASONIC_WHITEBOARD)	+= hid-ubt780.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 88cb04e..63da114 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1365,6 +1365,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANABOARD_UBT780) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3341baa..fa5f914 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -446,6 +446,9 @@
 #define USB_VENDOR_ID_ORTEK		0x05a4
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
+#define USB_VENDOR_ID_PANASONIC		0x04da
+#define USB_DEVICE_ID_PANABOARD_UBT780  0x1044
+
 #define USB_VENDOR_ID_PANJIT		0x134c
 
 #define USB_VENDOR_ID_PANTHERLORD	0x0810
diff --git a/drivers/hid/hid-ubt780.c b/drivers/hid/hid-ubt780.c
new file mode 100644
index 0000000..7f3c8db
--- /dev/null
+++ b/drivers/hid/hid-ubt780.c
@@ -0,0 +1,885 @@
+/*
+*  USB HID driver for Panasonic elite Panaboard UTB780
+*  Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
+*  Copyright (c) 2010-2011 Anton Chikin<anton.chikin@dataart.com> for Panasonic.
+
+* Information.
+* It's driver for supporting Panasonic Elite Panaboard HID USB device.
+* This code was inspired by hid-cando.c and hid-roccat.c(chrdev part)
+*/
+
+/* This file is part of USB HID driver for Panasonic elite Panaboard UTB780.
+*
+*   This driver is free software: you can redistribute it and/or modify
+*   it under the terms of the GNU General Public License as published by
+*   the Free Software Foundation, either version 3 of the License, or
+*   (at your option) any later version.
+*
+*   This driver is distributed in the hope that it will be useful,
+*   but WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+*   GNU General Public License for more details.
+*
+*   You should have received a copy of the GNU General Public License
+*   along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+*/
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+
+#include "hid-ids.h"
+#include "hid-ubt780.h"
+#define UBT780_DEBUG
+
+#ifdef UBT780_DEBUG
+#define UBT_DUMMY_DEBUG if (ubt_debug) printk(KERN_DEBUG "ubt780: %s:%s line %i\n", __FILE__, __func__, __LINE__);
+#else
+#define UBT_DUMMY_DEBUG
+#endif
+
+static int ubt780_major;
+static struct cdev ubt780_cdev;
+static struct class *ubt780_class;
+static struct ubt780_chrdev *ubt780_table[UBT780_MAX_DEVICES];
+static DEFINE_MUTEX(minors_lock);
+
+static int ubt_debug = 0;
+module_param_named(debug_enabled, ubt_debug, int, 0600);
+MODULE_PARM_DESC(debug_enabled, "toggle UBT debugging messages");
+
+/*Calibration data module params*/
+static int isCalibrated = 0;
+
+static int LTx = -1;
+static int LTy = -1;
+static int LBx = -1;
+static int LBy = -1;
+static int RTx = -1;
+static int RTy = -1;
+static int RBx = -1;
+static int RBy = -1;
+
+static int LTX = -1;
+static int LTY = -1;
+static int LBX = -1;
+static int LBY = -1;
+static int RTX = -1;
+static int RTY = -1;
+static int RBX = -1;
+static int RBY = -1;
+
+static int Xoff_A = -1;
+static int Xmag_A = -1;
+static int Xmag_B = -1;
+static int Yoff_A = -1;
+static int Ymag_A = -1;
+static int Ymag_B = -1;
+
+module_param(mode, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(mode, "1 - digitizer mode, 0 - mouse mode");
+
+/*---------------------------------------------------------------------*/
+
+module_param(LTx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LTx, "point x of left-up corner, screen coordinate");
+
+module_param(LTy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LTy, "point y of left-up corner, screen coordinate");
+
+module_param(LBx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LBx, "point x of left-bot corner, screen coordinate");
+
+module_param(LBy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LBy, "point y of left-bot corner, screen coordinate");
+
+module_param(RTx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RTx, "point x of rigth-up corner, screen coordinate");
+
+module_param(RTy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RTy, "point y of rigth-up corner, screen coordinate");
+
+module_param(RBx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RBx, "point x of rigth-bot corner, screen coordinate");
+
+module_param(RBy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RBy, "point y of rigth-bot corner, screen coordinate");
+
+/*---------------------------------------------------------------------*/
+
+module_param(LTX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LTX, "point x of left-up corner, board coordinate");
+
+module_param(LTY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LTY, "point y of left-up corner, board coordinate");
+
+module_param(LBX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LBX, "point x of left-bot corner, board coordinate");
+
+module_param(LBY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(LBY, "point y of left-bot corner, board coordinate");
+
+module_param(RTX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RTX, "point x of rigth-up corner, board coordinate");
+
+module_param(RTY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RTY, "point y of rigth-up corner, board coordinate");
+
+module_param(RBX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RBX, "point x of rigth-bot corner, board coordinate");
+
+module_param(RBY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(RBY, "point y of rigth-bot corner, board coordinate");
+
+/**********************************************************************/
+
+module_param(Xoff_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(Xoff_A, "Precalculated data");
+
+module_param(Xmag_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(Xmag_A, "Precalculated data");
+
+module_param(Xmag_B, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(Xmag_B, "Precalculated data");
+
+module_param(Yoff_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(Yoff_A, "Precalculated data");
+
+module_param(Ymag_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(Ymag_A, "Precalculated data");
+
+module_param(Ymag_B, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+MODULE_PARM_DESC(Ymag_B, "Precalculated data");
+
+/* Character device forward declarations*/
+static int ubt780_open_io(struct inode *node, struct file *file);
+static int ubt780_release_io(struct inode *node, struct file *file);
+static long ubt780_ioctl(struct file *iofile,
+			unsigned int command,
+			unsigned long data);
+static int ubt780_chrdev_connect(struct hid_device *dev,
+				struct ubt780_data *data);
+static void ubt780_chrdev_disconnect(struct hid_device *hid);
+/*We are using function from usbhid module*/
+extern void usbhid_submit_report(struct hid_device *hid,
+				struct hid_report *report,
+				unsigned char dir);
+
+
+/* switch_mode : Our device has two modes: mouse mode in which it is acting like
+ * mouse, producing absolute coordinates [0 - 4095]
+ * The second mode is digitizer mode, which produce two raw clock measurments
+ * from ultrasound recievers in the top-left corner of the board. This mode more
+ * flexible and also reports batterey status of digitizer pen and penID.
+ */
+static int ubt780_switch_mode(struct hid_device *hid, unsigned char mode)
+{
+	int rc = 0;
+
+	struct hid_report *report = NULL;
+	struct hid_report *report_cur = NULL;
+	__s32 *val = NULL;
+	/** Packet forming */
+	UBT_DUMMY_DEBUG
+
+	list_for_each_entry(report,
+			&hid->report_enum[HID_OUTPUT_REPORT].report_list,
+			list)
+	{
+		if (hid->report_enum[HID_OUTPUT_REPORT].numbered)
+			report_cur = report;
+	}
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
+
+	UBT_DUMMY_DEBUG
+
+	if (report_cur == NULL) {
+		if (ubt_debug)
+			printk(KERN_DEBUG "ubt780 : switch mode : report_cur = 0");
+		return rc;
+	}
+
+	if (ubt_debug)
+		printk(KERN_DEBUG "ubt780 :switch_mode:
+				usbhid_submit_report
+				drv=%p p=%p mode=%d",
+				hid, report_cur, mode);
+	/*Send report to device*/
+
+	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
+	UBT_DUMMY_DEBUG
+	return rc;
+}
+
+int xold = 0, yold = 0;
+
+/* PenToInt : converts ultrasound clock measurements to screen coordinates.*/
+bool ubt780_pen_to_int(int *pLeft, int *pRight)
+{
+	int left2, right2 , n, w_n, sqr, xx, yy;
+	bool bRet = false;
+	static int w = 1164;
+
+	left2  = (*pLeft)*(*pLeft);
+	right2 = (*pRight)*(*pRight);
+	UBT_DUMMY_DEBUG
+	if (left2 == 0 && right2 == 0) {
+		*pLeft = (int)xold;
+		*pRight = (int)yold;
+		if (ubt_debug)
+			printk(KERN_DEBUG
+				"ubt780_XY old values: %d,%d", xold, yold);
+	    return true;
+	}
+
+	n = (right2 - left2) / (2*w);
+	w_n = w-n;
+
+	sqr = (2*left2 - (w_n * w_n));
+
+	if (sqr < 0)
+		return bRet;
+
+	xx = (w_n + int_sqrt(sqr)) / 2;
+	yy = xx + n;
+
+	if (xx < 0 || yy < 0)
+		return bRet;
+
+	*pLeft = (int)xx;
+	*pRight = (int)yy;
+	bRet = true;
+	if (ubt_debug)
+		printk(KERN_DEBUG "ubt780_XY: %d,%d", xx, yy);
+
+	return bRet;
+}
+/*Apply calibration to ultrasound clock measurements*/
+static bool ubt780_calibrate(int inX, int inY, int *outX, int *outY,
+				struct ubt780_calib *calib)
+{
+	int x, y, Y_LTY, X_LTX, Xoff, Xmag, Yoff, Ymag;
+
+	if (ubt780_pen_to_int(&inX, &inY)) {
+		xold = inX;
+		yold = inY;
+
+		Y_LTY = inY - calib->LTY;
+		X_LTX = inX - calib->LTX;
+		Xoff = Y_LTY * calib->Xoff_A + calib->LTX * 10000;
+		Xmag = (Y_LTY * calib->Xmag_A) / 10000;
+		Xmag += calib->Xmag_B;
+		Yoff = X_LTX * calib->Yoff_A + calib->LTY * 10000;
+		Ymag = X_LTX * calib->Ymag_A / 10000;
+		Ymag += calib->Ymag_B;
+
+		if (!Xmag)
+			Xmag = 1;
+		x  = (inX * 10000 - Xoff) / Xmag;
+		x  += calib->LTx;
+
+		if (!Ymag)
+			Ymag = 1;
+		y  = (inY * 10000 - Yoff) / Ymag;
+		y  += calib->LTy;
+
+		if (x < 0)
+			x = 0;
+		if (x > UBT780_MAX_AXIS_X)
+			x = UBT780_MAX_AXIS_X;
+
+		if (y < 0)
+			y = 0;
+		if (y > UBT780_MAX_AXIS_Y)
+			y = UBT780_MAX_AXIS_Y;
+
+		*outX = x;
+		*outY = y;
+		return true;
+	}
+	return false;
+}
+/*
+* input_mapping : Set appropriate bits for input device according to current
+* field, usage and usage page. For info about valid usage pages and usages
+* see include/linux/hid.h. For more info on input see
+* Documentation/input/input.txt and Documentation/input/input-programming.txt
+* and of course include/linux/input.h
+* What to return?
+* return < 0 - field was ignored
+* return > 0 - field was mapped
+* return == 0 - let hid driver map this field for you
+*/
+static int ubt780_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	/*Just ignore all fields*/
+	return -1;
+}
+
+/* event : Called on every single report field.
+ * Return :
+ * return == 0 - do generic input hidinput and hiddev processing.
+ * See hid_process_event in hid-core.c.
+ * return > 0 - finish processing.
+ */
+static int ubt780_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
+	/*Just prevent further processing by hid*/
+	return 1;
+}
+
+/*Set last known calibration data to device*/
+static void ubt780_set_calib_data(struct ubt780_data *drvdata)
+{
+
+	drvdata->calib.LTx = LTx;
+	drvdata->calib.LTy = LTy;
+	drvdata->calib.LBx = LBx;
+	drvdata->calib.LBy = LBy;
+	drvdata->calib.RTx = RTx;
+	drvdata->calib.RTy = RTy;
+	drvdata->calib.RBx = RBx;
+	drvdata->calib.RBy = RBy;
+
+	drvdata->calib.LTX = LTX;
+	drvdata->calib.LTY = LTY;
+	drvdata->calib.LBX = LBX;
+	drvdata->calib.LBY = LBY;
+	drvdata->calib.RTX = RTX;
+	drvdata->calib.RTY = RTY;
+	drvdata->calib.RBX = RBX;
+	drvdata->calib.RBY = RBY;
+
+	drvdata->calib.Xoff_A = Xoff_A;
+	drvdata->calib.Xmag_A = Xmag_A;
+	drvdata->calib.Xmag_B = Xmag_B;
+	drvdata->calib.Yoff_A = Yoff_A;
+	drvdata->calib.Ymag_A = Ymag_A;
+	drvdata->calib.Ymag_B = Ymag_B;
+
+	drvdata->calib.isCalibrated = isCalibrated;
+}
+
+static int ubt780_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+	struct ubt780_data *drvdata;
+	struct hid_input *hidinput = NULL;
+	struct input_dev *input;
+
+	UBT_DUMMY_DEBUG
+	drvdata = kmalloc(sizeof(struct ubt780_data), GFP_KERNEL);
+	if (!drvdata) {
+		dev_err(&hdev->dev, "cannot allocate UB-T780 data\n");
+		return -ENOMEM;
+	}
+	/*Set last known calibration data for new deivce*/
+	ubt780_set_calib_data(drvdata);
+
+	hid_set_drvdata(hdev, drvdata);
+
+	ret = hid_parse(hdev);
+	if (!ret) {
+		if (ubt_debug)
+			printk(KERN_DEBUG "Trying hid_hw_start");
+		/*We need HIDINPUT dev only.*/
+		ret = hid_hw_start(hdev, HID_CONNECT_HIDINPUT);
+		if (ubt_debug)
+			printk(KERN_DEBUG "hid_hw_start() ret : %d", ret);
+	}
+
+	if (ret)
+		kfree(drvdata);
+	ubt780_chrdev_connect(hdev, drvdata);
+	/*Input mapping. We have 2 absolute axis and two buttons.*/
+	UBT_DUMMY_DEBUG
+	hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
+	if (hidinput == NULL) {
+		if (ubt_debug)
+			printk(KERN_DEBUG "ubt780:probe:Failed to get hidinput");
+		goto skip_input;
+	}
+	UBT_DUMMY_DEBUG
+	input = hidinput->input;
+
+	UBT_DUMMY_DEBUG
+	/* Basics */
+	input->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS);
+	input->absbit[0] |= BIT(ABS_X) | BIT(ABS_Y);
+	set_bit(BTN_LEFT, input->keybit);
+	set_bit(BTN_RIGHT, input->keybit);
+
+	input->absmax[ABS_X] = UBT780_MAX_AXIS_X;
+	input->absmax[ABS_Y] = UBT780_MAX_AXIS_Y;
+	input->absmin[ABS_X] = 0;
+	input->absmin[ABS_Y] = 0;
+skip_input:
+	return ret;
+}
+/* Our own char device for ioctls */
+/*------------------------------------------------------------*/
+
+
+static const struct file_operations ubt780_fops = {
+	.owner = THIS_MODULE,
+	.open = ubt780_open_io,
+	.release = ubt780_release_io,
+	.unlocked_ioctl = ubt780_ioctl,
+};
+
+static int ubt780_chrdev_init(void)
+{
+	int result;
+	dev_t dev_id;
+
+	result = alloc_chrdev_region(&dev_id, UBT780_FIRST_MINOR,
+			UBT780_MAX_DEVICES, "ubt780_chr");
+
+	ubt780_major = MAJOR(dev_id);
+
+	if (result < 0) {
+		printk(KERN_WARNING "ubt780: can't get major number\n");
+		result = 0;
+		goto out;
+	}
+
+	ubt780_class = class_create(THIS_MODULE, "ubt780_chr");
+	if (IS_ERR(ubt780_class)) {
+		result = PTR_ERR(ubt780_class);
+		unregister_chrdev(ubt780_major, "ubt780_chr");
+		goto out;
+	}
+
+	cdev_init(&ubt780_cdev, &ubt780_fops);
+	cdev_add(&ubt780_cdev, dev_id, UBT780_MAX_DEVICES);
+out:
+	return result;
+}
+
+static void ubt780_chrdev_cleanup(void)
+{
+	dev_t dev_id = MKDEV(ubt780_major, 0);
+	cdev_del(&ubt780_cdev);
+	class_destroy(ubt780_class);
+	unregister_chrdev_region(dev_id, UBT780_MAX_DEVICES);
+}
+static int ubt780_chrdev_connect(struct hid_device *hid,
+				struct ubt780_data *drvdata)
+{
+	int minor, result;
+	struct ubt780_chrdev *dev;
+
+	dev = kzalloc(sizeof(struct ubt780_chrdev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	result = -EINVAL;
+
+	mutex_lock(&minors_lock);
+
+	for (minor = 0; minor < UBT780_MAX_DEVICES; minor++) {
+		if (ubt780_table[minor])
+			continue;
+		ubt780_table[minor] = dev;
+		result = 0;
+		break;
+	}
+	UBT_DUMMY_DEBUG
+	if (ubt_debug)
+		printk(KERN_DEBUG "ubt780_chrdev_connect:ret=%X", result);
+
+	if (result) {
+		mutex_unlock(&minors_lock);
+		kfree(dev);
+		goto out;
+	}
+
+	dev->dev = device_create(ubt780_class,
+				&hid->dev,
+				MKDEV(ubt780_major, minor),
+				NULL, "%s%d", "ubt780_", minor);
+
+	if (IS_ERR(dev->dev)) {
+		ubt780_table[minor] = NULL;
+		mutex_unlock(&minors_lock);
+		result = PTR_ERR(dev->dev);
+		kfree(dev);
+		drvdata->chrdev = NULL;
+		goto out;
+	}
+
+	UBT_DUMMY_DEBUG
+
+	mutex_unlock(&minors_lock);
+
+	dev->hid = hid;
+	drvdata->chrdev = dev;
+	dev->minor = minor;
+
+	dev->exist = 1;
+out:
+	return result;
+
+}
+
+static void ubt780_chrdev_disconnect(struct hid_device *hid)
+{
+
+	struct ubt780_data *ubt780_drv = hid_get_drvdata(hid);
+	struct ubt780_chrdev *ubt780 = ubt780_drv->chrdev;
+
+	if (!ubt780)
+		return;
+
+	ubt780->exist = 0;
+
+	mutex_lock(&minors_lock);
+	ubt780_table[ubt780->minor] = NULL;
+	mutex_unlock(&minors_lock);
+
+	device_destroy(ubt780_class, MKDEV(ubt780_major, ubt780->minor));
+
+	if (ubt780->open)
+		hid->ll_driver->close(hid);
+	else
+		kfree(ubt780);
+}
+
+
+static int ubt780_open_io(struct inode *node, struct file *file)
+{
+	unsigned int minor = iminor(node);
+	struct ubt780_chrdev *device;
+	int error = 0;
+
+	mutex_lock(&minors_lock);
+
+	device = ubt780_table[minor];
+
+	if (!device) {
+		printk(KERN_EMERG "ubt780 device with minor %d doesn't exist\n",
+				minor);
+		error = -ENODEV;
+		goto exit_unlock;
+	}
+
+	if (!device->open) {
+		device->open++;
+		/* power on device */
+		if (device->hid->ll_driver->power) {
+			error = device->hid->ll_driver->power(device->hid,
+					PM_HINT_FULLON);
+			if (error < 0) {
+				--device->open;
+				goto exit_unlock;
+			}
+		}
+		error = device->hid->ll_driver->open(device->hid);
+		if (error < 0) {
+			if (device->hid->ll_driver->power)
+				device->hid->ll_driver->power(device->hid,
+						PM_HINT_NORMAL);
+			--device->open;
+			goto exit_unlock;
+		}
+	} else
+		error = -EBUSY;
+
+exit_unlock:
+	mutex_unlock(&minors_lock);
+	return error;
+}
+
+static int ubt780_release_io(struct inode *node, struct file *file)
+{
+	unsigned int minor = iminor(node);
+	struct ubt780_chrdev *dev;
+	int ret;
+
+	mutex_lock(&minors_lock);
+	if (!ubt780_table[minor]) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	dev = ubt780_table[minor];
+	if (dev->open) {
+		dev->open--;
+		if (dev->hid->ll_driver->power)
+				dev->hid->ll_driver->power(dev->hid, PM_HINT_NORMAL);
+		dev->hid->ll_driver->close(dev->hid);
+	}
+
+	ret = 0;
+unlock:
+	mutex_unlock(&minors_lock);
+
+	return ret;
+}
+static long ubt780_ioctl(struct file *iofile, unsigned int command, unsigned long data)
+{
+
+	int retval = 0;
+	struct inode *inode = iofile->f_path.dentry->d_inode;
+	unsigned int minor = iminor(inode);
+	struct ubt780_chrdev *dev;
+	struct ubt780_data *drvdata;
+	mutex_lock(&minors_lock);
+	dev = ubt780_table[minor];
+	if (!dev) {
+		retval = -ENODEV;
+		goto out;
+	}
+	drvdata = hid_get_drvdata(dev->hid);
+	switch (command) {
+	case GET_BATTERY_STATUS: {
+		int *in = (int *) data;
+		struct ubt780_dgtzr *pack = &(drvdata->ubt_packet);
+		printk(KERN_DEBUG "ubt780_ioctl_io : GET_BATTERY_STATUS");
+		/* needs one toch of pen or DIGITIZER mode */
+		if (drvdata->current_mode == MODE_MOUSE || pack->report != 0x02) {
+			*in = BATTERY_STATUS_UKN;
+		} else {
+		    unsigned char *data = pack->data;
+		    *in = ((data[2] >> 3) & 0x01) ? BATTERY_STATUS_WEAK : BATTERY_STATUS_FINE;
+		}
+		retval = 0;
+		break;
+	}
+	case GET_LAST_PACKET_OLD:
+	case GET_LAST_PACKET:
+	{
+		struct ubt780_dgtzr *packsrc = &drvdata->ubt_packet;
+		struct ubt780_dgtzr *packdst = (struct ubt780_dgtzr *) data;
+		if (packsrc->report != 0x00) {
+			memcpy((void *)packdst, (void *)packsrc, sizeof(struct ubt780_dgtzr));
+			packsrc->report = 0;
+			if (ubt_debug)
+				printk(KERN_DEBUG "ubt780_ioctl_io : GET_LAST_PACKET2");
+		}
+		retval = 0;
+		break;
+	}
+	case GET_MODE:
+	{
+		int *in = (int *)data;
+		printk(KERN_DEBUG "ubt780_ioctl_io : GET_MODE");
+		*in = drvdata->current_mode;
+		retval = 0;
+		break;
+	}
+	case SET_MODE:
+	{
+		int *in = (int *)data;
+		unsigned char mode = (*in == MODE_MOUSE) ? 0 : 1;
+
+		drvdata->ubt_packet.report = 0;
+
+		if (ubt780_switch_mode(dev->hid, mode) != 0) {
+			retval = -EIO;
+			if (ubt_debug)
+				printk(KERN_DEBUG "ubt780_ioctl_io : SET_MODE error");
+		} else {
+			drvdata->current_mode = *in;
+			if (ubt_debug)
+				printk(KERN_DEBUG "ubt780_ioctl_io : SET_MODE ok");
+			retval = 0;
+		}
+		break;
+	}
+	case SET_CALIB:
+	{
+		struct ubt780_calib *calib = (struct ubt780_calib *) data;
+
+		if (ubt_debug)
+			printk(KERN_DEBUG "ubt780_ioctl_io : SET_CALIB");
+		LTx = calib->LTx;
+		LTy = calib->LTy;
+		LBx = calib->LBx;
+		LBy = calib->LBy;
+		RTx = calib->RTx;
+		RTy = calib->RTy;
+		RBx = calib->RBx;
+		RBy = calib->RBy;
+
+		LTX = calib->LTX;
+		LTY = calib->LTY;
+		LBX = calib->LBX;
+		LBY = calib->LBY;
+		RTX = calib->RTX;
+		RTY = calib->RTY;
+		RBX = calib->RBX;
+		RBY = calib->RBY;
+
+		Xoff_A = calib->Xoff_A;
+		Xmag_A = calib->Xmag_A;
+		Xmag_B = calib->Xmag_B;
+		Yoff_A = calib->Yoff_A;
+		Ymag_A = calib->Ymag_A;
+		Ymag_B = calib->Ymag_B;
+
+		isCalibrated = 1;
+
+		ubt780_set_calib_data(drvdata);
+
+		retval = 0;
+		break;
+	}
+	default:
+	{
+		retval = -EIO;
+		if (ubt_debug)
+			printk(KERN_DEBUG "ubt780_ioctl_io : unknown command %d", command);
+		break;
+	}
+	}
+out:
+	mutex_unlock(&minors_lock);
+	return retval;
+}
+/*----------------------------------------------------------------*/
+static void ubt780_report_input(struct input_dev *input,
+				unsigned int x,
+				unsigned int y,
+				int leftBtn,
+				int rightBtn)
+{
+	input_report_key(input, BTN_LEFT, leftBtn);
+	input_report_key(input, BTN_RIGHT, rightBtn);
+	input_sync(input);
+	input_report_abs(input, ABS_X, x);
+	input_report_abs(input, ABS_Y, y);
+	input_sync(input);
+}
+/*Called on raw reports frmo device*/
+static int ubt780_raw_event(struct hid_device *hdev,
+				struct hid_report *report,
+				u8 *data, int size)
+{
+	struct ubt780_data *driver_data = hid_get_drvdata(hdev);
+	struct ubt780_dgtzr *pack = &driver_data->ubt_packet;
+
+	struct hid_input *hidinput =
+		list_entry(hdev->inputs.next, struct hid_input, list);
+	struct input_dev *input = hidinput->input;
+
+	/*Save the packet for userspace processing*/
+	memcpy((void *)pack, (void *)data, size);
+	/*Mouse mode packet*/
+	if (pack->report == 0x01) {
+		if (ubt_debug)
+			printk(KERN_DEBUG "ubt780_mode: MM");
+
+		if (driver_data->current_mode == MODE_UKN)
+			driver_data->current_mode = MODE_MOUSE;
+		/*Switch to digitizer*/
+		if (driver_data->current_mode != MODE_MOUSE)
+			ubt780_switch_mode(hdev, 1);
+	}
+	/*Digitizer mode packet*/
+	else if (pack->report == 0x02) {
+		if (ubt_debug)
+			printk(KERN_DEBUG "ubt780_mode: DIG");
+		if (driver_data->current_mode == MODE_UKN)
+			driver_data->current_mode = MODE_DGTZR;
+
+		if (driver_data->current_mode == MODE_MOUSE) {
+			pack->report = 0;
+			if (ubt_debug)
+				printk(KERN_DEBUG "ubt780_current_mode: MOUSE");
+			/*Switch to mouse*/
+			ubt780_switch_mode(hdev, 0);
+		} else if (driver_data->current_mode == MODE_DGTZR) {
+			unsigned short * pCoord = (unsigned short *)(&pack->data[3]);
+			struct ubt780_calib *calib = &driver_data->calib;
+
+			int X = (int) pCoord[0];
+			int Y = (int) pCoord[1];
+
+			int leftBtn = pack->data[2] >> 5 & 0x01;
+			int rightBtn = pack->data[2] >> 4 & 0x01;
+
+			if (driver_data->calib.isCalibrated) {
+				if (ubt780_calibrate(X, Y, &X, &Y, calib)) {
+					if (ubt_debug)
+						printk(KERN_DEBUG "ubt780_mode:
+							Calibrated;
+							x=%d y=%d,left_btn=%d\n",
+							X, Y, leftBtn);
+					ubt780_report_input(input, X, Y, leftBtn, rightBtn);
+				}
+			} else {
+				if (ubt780_pen_to_int(&X, &Y))
+					ubt780_report_input(input, X, Y, leftBtn, rightBtn);
+				if (ubt_debug)
+					printk(KERN_DEBUG "ubt780_mode:
+						Not calibrated;
+						x=%d y=%d,left_btn=%d\n",
+						X, Y, leftBtn);
+			}
+		}
+	}
+	UBT_DUMMY_DEBUG
+	return 0;
+}
+static void ubt780_remove(struct hid_device *hdev)
+{
+	UBT_DUMMY_DEBUG
+	ubt780_chrdev_disconnect(hdev);
+	hid_hw_stop(hdev);
+	kfree(hid_get_drvdata(hdev));
+	hid_set_drvdata(hdev, NULL);
+}
+
+static struct hid_device_id ubt780_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANABOARD_UBT780) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, ubt780_devices);
+
+static struct hid_driver ubt780_driver = {
+	.name = "ubt780",
+	.id_table = ubt780_devices,
+	.probe = ubt780_probe,
+	.remove = ubt780_remove,
+	.input_mapping = ubt780_input_mapping,
+	.raw_event = ubt780_raw_event,
+	.event = ubt780_event,
+};
+
+static int __init ubt780_init(void)
+{
+	int retval = ubt780_chrdev_init();
+	retval = hid_register_driver(&ubt780_driver);
+	UBT_DUMMY_DEBUG
+	return retval;
+}
+
+static void __exit ubt780_exit(void)
+{
+	UBT_DUMMY_DEBUG
+	hid_unregister_driver(&ubt780_driver);
+	ubt780_chrdev_cleanup();
+}
+
+module_init(ubt780_init);
+module_exit(ubt780_exit);
+
+MODULE_AUTHOR("Anton Chikin <kverlin@gmail.com>");
+MODULE_DESCRIPTION("Panasonic UB-T780 driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ubt780.h b/drivers/hid/hid-ubt780.h
new file mode 100644
index 0000000..c620630
--- /dev/null
+++ b/drivers/hid/hid-ubt780.h
@@ -0,0 +1,140 @@
+/*
+ *  USB HID driver for Panasonic elite Panaboard UTB780
+ *  Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
+ *  Copyright (c) 2011 Anton Chikin <anton.chikin@dataart.com> for Panasonic
+
+ * Information.
+ * It's driver for supporting Panasonic Elite Panaboard HID USB device.
+ */
+
+/* This file is part of USB HID driver for Panasonic elite Panaboard UTB780.
+*
+*   This driver is free software: you can redistribute it and/or modify
+*   it under the terms of the GNU General Public License as published by
+*   the Free Software Foundation, either version 3 of the License, or
+*   (at your option) any later version.
+*
+*   This driver is distributed in the hope that it will be useful,
+*   but WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+*   GNU General Public License for more details.
+*
+*   You should have received a copy of the GNU General Public License
+*   along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+*/
+
+
+
+#ifndef UBT780CTRL
+#define UBT780CTRL
+
+/*IOCTRL codes*/
+/** Battary status IOCTL defines */
+/*get battery status, return BATTERY_STATUS_UKN, BATTERY_STATUS_FINE, BATTERY_STATUS_WEAK*/
+#define GET_BATTERY_STATUS		0x01
+/*get last packet (ubt780_dgtzr). It is necessary for calibration*/
+#define GET_LAST_PACKET_OLD		0x02
+
+/** Modes of work IOCTL */
+/*get current mode, return MODE_MOUSE, MODE_DGTZR*/
+#define GET_MODE			0x10
+/*switch to mouse mode, MODE_MOUSE, MODE_DGTZR*/
+#define SET_MODE			0x11
+/*set calibration mode*/
+#define SET_CALIB			0x20
+/*get last packet (ubt780_dgtzr). It is necessary for calibration*/
+#define GET_LAST_PACKET			0x21
+
+/*return values for ioctrl*/
+/** Battary status defines */
+#define BATTERY_STATUS_FINE		0x00 /*battery is fine*/
+#define BATTERY_STATUS_WEAK		0x01 /*battery is weak*/
+/*unknown status. Status will be known after the first pen touch*/
+#define BATTERY_STATUS_UKN		0x02
+
+/** Mode status defines */
+#define MODE_MOUSE			0x10 /*current mode is mouse*/
+#define MODE_DGTZR			0x11 /*current mode is digitizer*/
+/*current mode is unknown. It will be known after the first pen touch*/
+#define MODE_UKN			0x12
+
+/*Char device declarations*/
+#define UBT780_MAX_DEVICES		0x05
+#define UBT780_FIRST_MINOR		0
+
+#define UBT780_MAX_AXIS_X		4095
+#define UBT780_MAX_AXIS_Y		4095
+/** Digitizer mode stucture: contains packet data */
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
+
+/** Calibration stucture: contains calibration data */
+struct ubt780_calib {
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
+
+	int isCalibrated;
+};
+/*Character device data structure*/
+struct ubt780_chrdev {
+	unsigned int minor;
+	int exist;
+	int open;
+	struct hid_device *hid;
+	struct device *dev;
+};
+/*Driver data structure*/
+struct ubt780_data {
+	struct ubt780_calib calib;
+	struct ubt780_dgtzr ubt_packet;
+	struct ubt780_chrdev *chrdev;
+	unsigned char current_mode;
+};
+#endif /*UBT780CTRL*/
-- 
1.7.1

