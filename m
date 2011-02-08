Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1BHKlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:41:04 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33088 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab1BHKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:40:53 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 8 Feb 2011 11:39:23 +0100
To: Anton Chikin <kverlin@gmail.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Chikin <anton.chikin@dataart.com>
Subject: Re: [PATCH] HID: added new driver for Panasonic Elite Panaboard
 UB-T780 and UB-T880
Message-ID: <20110208103923.GA2009@polaris.bitmath.org>
References: <1297157786-2004-1-git-send-email-kverlin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297157786-2004-1-git-send-email-kverlin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PmkyH-0006BP-8R.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PmkyH-0006BP-8R aa0822fdecc8948f61ab91eaaa5e199a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

> From: Anton Chikin <anton.chikin@dataart.com>
> 
> Panasonic UB-T780 is a HID whiteboard with infrared detectors.
> UB-T880 is a multitouch-enabled HID whiteboard.
> Both of them use projector to present desktop, so they need calibration.
> I've used my own IOCTL's to switch board modes and feed calibration data from userspace.
> Sorry for previous ugly effort. I've missed some files in commit and forgot about copyrights.
> 
> Signed-off-by: Anton Chikin <kverlin@gmail.com>
> ---

At large, it does look like the same patch, though. Please find some
initial comments below.

>  drivers/hid/Kconfig      |    6 +
>  drivers/hid/Makefile     |    1 +
>  drivers/hid/hid-ids.h    |    5 +
>  drivers/hid/hid-ubt880.c | 1205 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-ubt880.h |  162 +++++++
>  5 files changed, 1379 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hid-ubt880.c
>  create mode 100644 drivers/hid/hid-ubt880.h
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 2560f01..8be6226 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -312,6 +312,12 @@ config HID_MULTITOUCH
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called hid-multitouch.
>  
> +config HID_PANASONIC
> +	tristate "Panasonic Elite Panaboards"
> +	depends on USB_HID
> +	---help---
> +	Support for Panasonic Elite Panaboard UB-T780 and UB-T880.
> +

I believe these should be ordered alphabetically.

>  config HID_NTRIG
>  	tristate "N-Trig touch screen"
>  	depends on USB_HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 6efc2a0..85f3495 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -73,6 +73,7 @@ obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
>  obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
>  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
>  obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
> +obj-$(CONFIG_HID_PANASONIC)     += hid-ubt880.o
>  
>  obj-$(CONFIG_USB_HID)		+= usbhid/
>  obj-$(CONFIG_USB_MOUSE)		+= usbhid/
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 92a0d61..3ca7171 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -468,6 +468,11 @@
>  #define USB_VENDOR_ID_ORTEK		0x05a4
>  #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
>  
> +#define USB_VENDOR_ID_PANASONIC		0x04da
> +#define USB_DEVICE_ID_PANABOARD_780	0x1044
> +#define USB_DEVICE_ID_PANABOARD_880	0x104d
> +#define USB_DEVICE_ID_PANABOARD_880_PEN 0x104e
> +
>  #define USB_VENDOR_ID_PANJIT		0x134c
>  
>  #define USB_VENDOR_ID_PANTHERLORD	0x0810
> diff --git a/drivers/hid/hid-ubt880.c b/drivers/hid/hid-ubt880.c
> new file mode 100644
> index 0000000..098864d
> --- /dev/null
> +++ b/drivers/hid/hid-ubt880.c
> @@ -0,0 +1,1205 @@
> +/*
> + *  USB HID driver for Panasonic elite Panaboard UTB780
> + *   Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
> + *   Copyright (c) 2010-2011 Anton Chikin<anton.chikin@dataart.com> for Panasonic.
> + *
> + *  Information.
> + *  It's driver for supporting Panasonic Elite Panaboard HID USB device.
> + *  This code was inspired by hid-cando.c and hid-roccat.c(chrdev part)
> + *
> + *
> + *  This file is part of USB HID driver for Panasonic elite Panaboard UTB780.
> + *
> + *  This driver is free software: you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation, either version 3 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This driver is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this driver.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +#include <linux/fs.h>
> +#include <linux/cdev.h>
> +#include "hid-ids.h"
> +#include "hid-ubt880.h"
> +
> +#define UBT780_DEBUG
> +
> +#ifdef UBT780_DEBUG
> +#define UBT_DUMMY_DEBUG if (ubt_debug) printk(KERN_DEBUG "ubt880: %s:%s line %i\n", __FILE__, __func__ , __LINE__);

Check dev_dbg().

> +#else
> +#define UBT_DUMMY_DEBUG
> +#endif
> +
> +static int ubt_major;
> +static struct cdev ubt_cdev;
> +static struct class *ubt_class;
> +static struct ubt_chrdev *ubt_table[UBT780_MAX_DEVICES];
> +static DEFINE_MUTEX(minors_lock);
> +static int ubt_debug = 0;
> +module_param_named(debug_enabled, ubt_debug, int, 0600);
> +MODULE_PARM_DESC(debug_enabled, "Toggle huge and ugly UBT debugging messages.");

Perhaps the heavy debugging has been done already, and the mainline
code can be trimmed a bit, no?

> +
> +static int isCalibrated = 0;
> +
> +static int mode = 0;
> +
> +static int LTx = -1;
> +static int LTy = -1;
> +static int LBx = -1;
> +static int LBy = -1;
> +static int RTx = -1;
> +static int RTy = -1;
> +static int RBx = -1;
> +static int RBy = -1;
> +
> +static int LTX = -1;
> +static int LTY = -1;
> +static int LBX = -1;
> +static int LBY = -1;
> +static int RTX = -1;
> +static int RTY = -1;
> +static int RBX = -1;
> +static int RBY = -1;
> +
> +static int Xoff_A = -1;
> +static int Xmag_A = -1;
> +static int Xmag_B = -1;
> +static int Yoff_A = -1;
> +static int Ymag_A = -1;
> +static int Ymag_B = -1;

This is a lot of variables. Surely it can be simplified someway?

> +
> +module_param(mode, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(mode, "1 - digitizer mode, 0 - mouse mode");
> +
> +module_param(isCalibrated, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(isCalibrated, "Calibration data is set to driver.");
> +/*---------------------------------------------------------------------*/
> +
> +module_param(LTx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LTx, "point x of left-up corner, screen coordinate");
> +
> +module_param(LTy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LTy, "point y of left-up corner, screen coordinate");
> +
> +module_param(LBx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LBx, "point x of left-bot corner, screen coordinate");
> +
> +module_param(LBy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LBy, "point y of left-bot corner, screen coordinate");
> +
> +module_param(RTx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RTx, "point x of rigth-up corner, screen coordinate");
> +
> +module_param(RTy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RTy, "point y of rigth-up corner, screen coordinate");
> +
> +module_param(RBx, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RBx, "point x of rigth-bot corner, screen coordinate");
> +
> +module_param(RBy, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RBy, "point y of rigth-bot corner, screen coordinate");
> +
> +/*---------------------------------------------------------------------*/
> +
> +module_param(LTX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LTX, "point x of left-up corner, board coordinate");
> +
> +module_param(LTY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LTY, "point y of left-up corner, board coordinate");
> +
> +module_param(LBX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LBX, "point x of left-bot corner, board coordinate");
> +
> +module_param(LBY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(LBY, "point y of left-bot corner, board coordinate");
> +
> +module_param(RTX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RTX, "point x of rigth-up corner, board coordinate");
> +
> +module_param(RTY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RTY, "point y of rigth-up corner, board coordinate");
> +
> +module_param(RBX, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RBX, "point x of rigth-bot corner, board coordinate");
> +
> +module_param(RBY, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(RBY, "point y of rigth-bot corner, board coordinate");
> +/*-----------------------------------------------------------------*/
> +module_param(Xoff_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(Xoff_A, "point x of rigth-up corner, board coordinate");
> +
> +module_param(Xmag_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(Xmag_A, "point y of rigth-up corner, board coordinate");
> +
> +module_param(Xmag_B, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(Xmag_B, "point x of rigth-bot corner, board coordinate");
> +
> +module_param(Ymag_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(Ymag_A, "point y of rigth-bot corner, board coordinate");
> +
> +module_param(Ymag_B, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(Ymag_B, "point y of rigth-bot corner, board coordinate");
> +
> +module_param(Yoff_A, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
> +MODULE_PARM_DESC(Yoff_A, "point x of rigth-up corner, board coordinate");

Uh-ho. I can see this either becoming a single coded parameter, or
better still, zero. We also have sysfs to consider for such things.

> +
> +/*Character device forward declarations*/
> +static int ubt880_open_io(struct inode *node, struct file *file);
> +static int ubt880_release_io(struct inode *node, struct file *file);
> +static long ubt880_ioctl(struct file *iofile, unsigned int command, unsigned long data);
> +static int ubt_chrdev_connect(struct hid_device *, struct ubt880_data *);
> +static void ubt_chrdev_disconnect(struct hid_device *hid);

Please reorganize your code to get rid of forward declarations.

> +#ifdef UBT780_DEBUG
> +static void send_test_packet(struct hid_device *hdev);
> +static void fake_calibration(struct hid_device *hdev, unsigned short *coords);
> +#endif

Such code should not be part of a mainline driver.

> +static struct input_dev *ubt880_get_input(struct hid_device *hdev);
> +static int ubt880_raw_event(struct hid_device *hdev, struct hid_report *report, u8 *data, int size);
> +/*We are using function from usbhid module*/
> +extern void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, unsigned char dir);

An #include would be appropriate.

> +static void set_calib_to_device(struct ubt880_data *drvdata);
> +
> +/*switch_mode : Our device has two modes: mouse mode in which it is acting like mouse, producing
> + * absolute coordinates [0 - 4095]
> + * The second mode is digitizer mode, which produce two raw clock measurments from ultrasound
> + * recievers in the top-left corner of the board. This mode more flexible and also reports batterey
> + * status of digitizer pen and penID.
> + */
> +static int ubt880_switch_mode(struct hid_device *hid, unsigned char mode)
> +{
> +	int rc = 0;
> +
> +	struct hid_report *report = NULL;
> +	struct hid_report *report_cur = NULL;
> +	__s32 *val = NULL;
> +	/** Packet forming */
> +
> +	UBT_DUMMY_DEBUG
> +
> +	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
> +	{
> +		if (hid->report_enum[HID_FEATURE_REPORT].numbered) {
> +			report_cur = report;
> +		}
> +	}
> +
> +	if (report_cur == NULL) {
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880 : switch mode : report_cur = 0");
> +		return rc;
> +	}
> +
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt880: switch mode: reportid = %d", report_cur->id);
> +	val = report_cur->field[0]->value;
> +
> +	switch (mode) {
> +	case MODE_MOUSE: {
> +		mode = 0x0;
> +		break;
> +	}
> +	case MODE_SINGLETOUCH: {
> +		mode = 0x01;
> +		break;
> +	}
> +	case MODE_DGTZR: {
> +		mode = 0x02;
> +		break;
> +	}
> +	default: {
> +		rc = -EIO;
> +		return rc;
> +	}
> +	}
> +	val[0] = mode;
> +	UBT_DUMMY_DEBUG
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt880 :switch_mode: usbhid_submit_report drv=%p p=%p mode=%d", hid, report_cur, mode);
> +	/*Send report to device*/
> +
> +	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
> +	UBT_DUMMY_DEBUG
> +	return rc;
> +}

There ought to be a function in hid to help you achieve this.

> +
> +static int ubt780_switch_mode(struct hid_device *hid, unsigned char mode)
> +{
> +	int rc = 0;
> +
> +	struct hid_report *report = NULL;
> +	struct hid_report *report_cur = NULL;
> +	__s32 *val = NULL;
> +	/** Packet forming */
> +	UBT_DUMMY_DEBUG
> +
> +	list_for_each_entry(report,
> +			&hid->report_enum[HID_OUTPUT_REPORT].report_list,
> +			list)
> +	{
> +		if (hid->report_enum[HID_OUTPUT_REPORT].numbered)
> +			report_cur = report;
> +	}
> +
> +	switch (mode) {
> +	case MODE_MOUSE: {
> +		mode = 0x00;
> +		break;
> +	}
> +	case MODE_DGTZR: {
> +		mode = 0x01;
> +		break;
> +	}
> +	default: {
> +		rc = -EIO;
> +		return rc;
> +	}
> +	}
> +	val = report_cur->field[0]->value;
> +	val[0] = 0x7e;
> +	val[1] = 0x04;
> +	val[2] = 0x4d;
> +	val[3] = mode;
> +	val[4] = 0x00;
> +	val[5] = 0x0a;
> +	val[6] = 0x00;
> +	val[7] = 0x00;
> +
> +	UBT_DUMMY_DEBUG
> +
> +	if (report_cur == NULL) {
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt780 : switch mode : report_cur = 0");
> +		return rc;
> +	}
> +
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt780 :switch_mode:\
> +				usbhid_submit_report\
> +				drv=%p p=%p mode=%d",
> +				hid, report_cur, mode);
> +	/*Send report to device*/
> +
> +	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
> +	UBT_DUMMY_DEBUG
> +	return rc;
> +}

Similar code as above, so simplifications are definitely possible.

> +
> +/* PenToInt : converts ultrasound clock measurements to screen coordinates.*/
> +/*Apply calibration to ultrasound clock measurements*/

Please use kernel-style comments.

> +int xold = 0, yold = 0;

static

> +bool ubt_pen_to_int(int *pLeft, int *pRight)

static

> +{
> +	int left2, right2 , n, w_n, sqr, xx, yy;
> +	bool bRet = false;
> +	static int w = 1164;
> +
> +	left2  = (*pLeft)*(*pLeft);
> +	right2 = (*pRight)*(*pRight);

This is style violation - please check your patches with checkpatch before submission.

> +	UBT_DUMMY_DEBUG
> +	if (left2 == 0 && right2 == 0) {
> +		*pLeft = (int)xold;
> +		*pRight = (int)yold;
> +		if (ubt_debug)
> +			printk(KERN_DEBUG
> +				"ubt780_XY old values: %d,%d", xold, yold);
> +	    return true;
> +	}

This seems to rely on a special state of the hardware and should
probably we lifted out of this function.

> +
> +	n = (right2 - left2) / (2*w);
> +	w_n = w-n;
> +
> +	sqr = (2*left2 - (w_n * w_n));
> +
> +	if (sqr < 0)
> +		return bRet;
> +
> +	xx = (w_n + int_sqrt(sqr)) / 2;
> +	yy = xx + n;
> +
> +	if (xx < 0 || yy < 0)
> +		return bRet;
> +
> +	*pLeft = (int)xx;
> +	*pRight = (int)yy;
> +	bRet = true;
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt780_XY: %d,%d", xx, yy);
> +
> +	return bRet;
> +}

Without even trying to understand what this code does, the return
values look odd. Just skip bRet altogether.

> +
> +static bool ubt_calibrate(int inX, int inY, int *outX, int *outY, struct ubt_calib *calib)
> +{
> +	int Y_LTY, X_LTX, Xoff, Xmag, Yoff, Ymag;
> +	unsigned int x, y;
> +	xold = inX;
> +	yold = inY;
> +
> +	Y_LTY = inY - calib->LTY;
> +	X_LTX = inX - calib->LTX;
> +
> +	Xoff = Y_LTY * calib->Xoff_A + calib->LTX * 10000;
> +	Xmag = (Y_LTY * calib->Xmag_A) / 10000;
> +	Xmag += calib->Xmag_B;
> +	Yoff = X_LTX * calib->Yoff_A + calib->LTY * 10000;
> +	Ymag = X_LTX * calib->Ymag_A / 10000;
> +	Ymag += calib->Ymag_B;
> +
> +	if (!Xmag)
> +		Xmag = 1;

Why?

> +	x  = (inX * 10000 - Xoff) / Xmag;
> +	x  += calib->LTx;
> +
> +	if (!Ymag)
> +		Ymag = 1;
> +	y  = (inY * 10000 - Yoff) / Ymag;
> +	y  += calib->LTy;
> +
> +	if (x < 0)
> +		x = 0;
> +	if (x > UBT880_MAX_AXIS_X)
> +		x = UBT880_MAX_AXIS_X;
> +	if (y < 0)
> +		y = 0;
> +	if (y > UBT880_MAX_AXIS_Y)
> +		y = UBT880_MAX_AXIS_Y;

clamp_val()

> +
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "%d - %d", x, y);
> +	*outX = x;
> +	*outY = y;
> +	return true;
> +}

Seems the above function could be void.

> +
> +/*
> +input_mapping : Set appropriate bits for input device according to current field, usage and usage page.
> +For info about valid usage pages and usages see include/linux/hid.h
> +For more info on input see Documentation/input/input.txt and Documentation/input/input-programming.txt
> +and of course include/linux/input.h
> +What to return?
> +return < 0 - field was ignored
> +return > 0 - field was mapped
> +return == 0 - let hid driver map this field for you
> +*/
> +static int ubt880_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> +		struct hid_field *field, struct hid_usage *usage,
> +		unsigned long **bit, int *max)
> +{
> +	/*Just ignore all fields*/
> +	return -1;
> +}

This function is not doing anything extraordinary, so it has a
disproportional amount of comments.

> +/*
> + * input_mapped : called from hidinput_configure_usage after input is mapped.
> + * Never called if you have returned negative value from input_mapping.
> + * Return values:
> + * return < 0 - ignore field
> + * return >= 0 - do further processing
> + */
> +/*static int ubt880_input_mapped(struct hid_device *hdev, struct hid_input *hi,
> +		struct hid_field *field, struct hid_usage *usage,
> +		unsigned long **bit, int *max)
> +{
> +	return -1;
> +}*/

Ditto

> +
> +
> +/* event : Called on every single report field.
> + * Return :
> + * return == 0 - do generic input hidinput and hiddev processing. See hid_process_event in hid-core.c.
> + * return > 0 - finish processing.
> + */
> +static int ubt880_event(struct hid_device *hid, struct hid_field *field,
> +				struct hid_usage *usage, __s32 value)
> +{
> +	/*Just prevent further processing by hid*/
> +	return 1;
> +}

Remove altogether

> +static void ubt880_set_input(struct input_dev *input)
> +{
> +	/* Basics */
> +	/*We have a key*/
> +	__set_bit(EV_KEY, input->evbit);
> +	__set_bit(BTN_LEFT, input->keybit);
> +	__set_bit(BTN_RIGHT, input->keybit);
> +	/*two absolute axis*/
> +	__set_bit(EV_ABS, input->evbit);
> +	__set_bit(ABS_X, input->absbit);
> +	__set_bit(ABS_Y, input->absbit);
> +	/*two absolute MT axis and tracking IDs*/
> +	input_set_abs_params(input, ABS_MT_POSITION_X, 0, UBT880_MAX_AXIS_X, 0, 0);
> +	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, UBT880_MAX_AXIS_Y, 0, 0);
> +	input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 3, 0, 0);
> +	input_set_abs_params(input, ABS_X, 0, UBT880_MAX_AXIS_X, 0, 0);
> +	input_set_abs_params(input, ABS_Y, 0, UBT880_MAX_AXIS_Y, 0, 0);
> +}

Please use slotted protocol instead (see 2.6.38 Documentation/input/).

> +
> +static void ubt780_set_input(struct input_dev *input)
> +{
> +	input->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS);
> +	input->absbit[0] |= BIT(ABS_X) | BIT(ABS_Y);
> +	set_bit(BTN_LEFT, input->keybit);
> +	set_bit(BTN_RIGHT, input->keybit);
> +
> +	input->absmax[ABS_X] = UBT780_MAX_AXIS_X;
> +	input->absmax[ABS_Y] = UBT780_MAX_AXIS_Y;
> +	input->absmin[ABS_X] = 0;
> +	input->absmin[ABS_Y] = 0;
> +}

This looks like standard HID stuff, and could probably be setup automatically.

> +
> +int ubt_set_device(struct ubt880_data *data, __u32 devid)
> +{
> +	int ret;
> +	data->calib.calibrated = 0;
> +	data->ubt_packet.report = 0;
> +	set_calib_to_device(data);
> +	switch (devid) {
> +	case USB_DEVICE_ID_PANABOARD_UBT780: {
> +		data->switch_mode = ubt780_switch_mode;
> +		data->set_input = ubt780_set_input;
> +		break;
> +	}
> +	case USB_DEVICE_ID_PANABOARD_UBT880: {
> +		data->switch_mode = ubt880_switch_mode;
> +		data->set_input = ubt880_set_input;
> +		break;
> +	}
> +	default: {
> +		ret = -1;
> +	}
> +	}
> +	return 0;
> +}

Static table would work too.

> +static int ubt880_probe(struct hid_device *hdev, const struct hid_device_id *id)
> +{
> +	int ret;
> +	struct ubt880_data *drvdata;
> +	struct hid_input *hidinput = NULL;
> +	struct input_dev *input;
> +
> +	UBT_DUMMY_DEBUG

remove

> +
> +	drvdata = kmalloc(sizeof(struct ubt880_data), GFP_KERNEL);
> +	if (!drvdata) {
> +		dev_err(&hdev->dev, "cannot allocate UB-T880 data\n");
> +		return -ENOMEM;
> +	}
> +
> +	hid_set_drvdata(hdev, drvdata);
> +
> +	ret = hid_parse(hdev);
> +	if (!ret) {
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "Trying hid_hw_start");

please use simpler debug function or remove

> +		/*We need HIDINPUT dev only. We have our own char device instead of hidraw*/
> +		ret = hid_hw_start(hdev, HID_CONNECT_HIDINPUT);
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "hid_hw_start() returned : %d", ret);
> +	}
> +
> +	if (ret) {
> +		kfree(drvdata);
> +		goto skip_input;
> +	}
> +	ubt_chrdev_connect(hdev, drvdata);
> +	ubt_set_device(drvdata, hdev->product);
> +
> +	drvdata->switch_mode(hdev, MODE_MOUSE);
> +	drvdata->current_mode = MODE_MOUSE;

surely there is a HID way to do this

> +
> +	UBT_DUMMY_DEBUG
> +	hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
> +	if (hidinput == NULL) {
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880: probe : Failed to get valid hidinput");
> +		goto skip_input;
> +	}
> +	UBT_DUMMY_DEBUG
> +	input = hidinput->input;
> +
> +	UBT_DUMMY_DEBUG
> +	drvdata->set_input(input);
> +skip_input:
> +	return ret;
> +}
> +/* Our own char device for ioctls */
> +/*---------------------------------------------------------------------------------------------*/
> +

Why??

> +
> +static const struct file_operations ubt880_fops = {
> +	.owner = THIS_MODULE,
> +	.open = ubt880_open_io,
> +	.release = ubt880_release_io,
> +	.unlocked_ioctl = ubt880_ioctl,
> +};

And this is used solely to communicate with the device for calibration
and such? Why is it even part of this driver?

> +
> +static int ubt_chrdev_init(void)
> +{
> +	int result;
> +	dev_t dev_id;
> +
> +	result = alloc_chrdev_region(&dev_id, UBT780_FIRST_MINOR,
> +		UBT780_MAX_DEVICES, "ubt_chr");
> +
> +	ubt_major = MAJOR(dev_id);
> +
> +	if (result < 0) {
> +		printk(KERN_WARNING "ubt: can't get major number\n");
> +		result = 0;
> +		goto out;
> +	}
> +
> +	ubt_class = class_create(THIS_MODULE, "ubt_chr");
> +	if (IS_ERR(ubt_class)) {
> +		result = PTR_ERR(ubt_class);
> +		unregister_chrdev(ubt_major, "ubt_chr");
> +		goto out;
> +	}
> +
> +	cdev_init(&ubt_cdev, &ubt880_fops);
> +	cdev_add(&ubt_cdev, dev_id, UBT780_MAX_DEVICES);
> +out:
> +	return result;
> +}
> +
> +static void ubt_chrdev_cleanup(void)
> +{
> +	dev_t dev_id = MKDEV(ubt_major, 0);
> +	cdev_del(&ubt_cdev);
> +	class_destroy(ubt_class);
> +	unregister_chrdev_region(dev_id, UBT780_MAX_DEVICES);
> +}
> +static int ubt_chrdev_connect(struct hid_device *hid, struct ubt880_data *drvdata)
> +{
> +	int minor, result;
> +	struct ubt_chrdev *dev;
> +
> +	dev = kzalloc(sizeof(struct ubt_chrdev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	result = -EINVAL;
> +
> +	mutex_lock(&minors_lock);
> +
> +	for (minor = 0; minor < UBT780_MAX_DEVICES; minor++) {
> +		if (ubt_table[minor])
> +			continue;
> +		ubt_table[minor] = dev;
> +		result = 0;
> +		break;
> +	}
> +	UBT_DUMMY_DEBUG
> +	printk(KERN_DEBUG "ubt_chrdev_connect : result = %X", result);
> +
> +	if (result) {
> +		mutex_unlock(&minors_lock);
> +		kfree(dev);
> +		goto out;
> +	}
> +	printk(KERN_DEBUG "ubt : chrdev_connect : ubt_majo=%d, minor=%d", ubt_major, minor);
> +	dev->dev = device_create(ubt_class, &hid->dev, MKDEV(ubt_major, minor),
> +				 NULL, "%s%d", "ubt_", minor);
> +
> +	if (IS_ERR(dev->dev)) {
> +		ubt_table[minor] = NULL;
> +		mutex_unlock(&minors_lock);
> +		result = PTR_ERR(dev->dev);
> +		kfree(dev);
> +		drvdata->chrdev = NULL;
> +		goto out;
> +	}
> +
> +	UBT_DUMMY_DEBUG
> +	printk(KERN_DEBUG "ubt_chrdev_connect : result = %X", result);
> +
> +	mutex_unlock(&minors_lock);
> +
> +	dev->hid = hid;
> +	drvdata->chrdev = dev;
> +	dev->minor = minor;
> +
> +	dev->exist = 1;
> +
> +out:
> +	printk(KERN_DEBUG "ubt_chrdev_connect : result = %X", result);
> +	return result;
> +
> +}
> +
> +static void ubt_chrdev_disconnect(struct hid_device *hid)
> +{
> +
> +	struct ubt880_data *ubt880_drv = hid_get_drvdata(hid);
> +	struct ubt_chrdev *ubt880 = ubt880_drv->chrdev;
> +
> +	if (!ubt880)
> +		return;
> +
> +	ubt880->exist = 0;
> +
> +	mutex_lock(&minors_lock);
> +	ubt_table[ubt880->minor] = NULL;
> +	mutex_unlock(&minors_lock);
> +
> +	device_destroy(ubt_class, MKDEV(ubt_major, ubt880->minor));
> +
> +	if (ubt880->open) {
> +		hid->ll_driver->close(hid);
> +	} else {
> +		kfree(ubt880);
> +	}
> +}
> +
> +
> +static int ubt880_open_io(struct inode *node, struct file *file)
> +{
> +	unsigned int minor = iminor(node);
> +	struct ubt_chrdev *device;
> +	int error = 0;
> +
> +	mutex_lock(&minors_lock);
> +	UBT_DUMMY_DEBUG
> +	device = ubt_table[minor];
> +
> +	if (!device) {
> +		printk(KERN_EMERG "ubt880 device with minor %d doesn't exist\n",
> +				minor);
> +		error = -ENODEV;
> +		goto exit_unlock;
> +	}
> +
> +	if (!device->open) {
> +		device->open++;
> +		/* power on device */
> +		if (device->hid->ll_driver->power) {
> +			error = device->hid->ll_driver->power(device->hid,
> +					PM_HINT_FULLON);
> +			if (error < 0) {
> +				--device->open;
> +				goto exit_unlock;
> +			}
> +		}
> +		error = device->hid->ll_driver->open(device->hid);
> +		if (error < 0) {
> +			if (device->hid->ll_driver->power)
> +				device->hid->ll_driver->power(device->hid,
> +						PM_HINT_NORMAL);
> +			--device->open;
> +			goto exit_unlock;
> +		}
> +	} else {
> +		device->open++;
> +		/*error = -EBUSY;*/
> +	}
> +
> +exit_unlock:
> +	mutex_unlock(&minors_lock);
> +	return error;
> +}
> +
> +static int ubt880_release_io(struct inode *node, struct file *file)
> +{
> +	unsigned int minor = iminor(node);
> +	struct ubt_chrdev *dev;
> +	int ret = 0;
> +	UBT_DUMMY_DEBUG
> +	mutex_lock(&minors_lock);
> +	if (!ubt_table[minor]) {
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
> +	dev = ubt_table[minor];
> +	if (dev->open) {
> +		dev->open--;
> +		if (dev->open)
> +			goto unlock;
> +		if (dev->hid->ll_driver->power)
> +				dev->hid->ll_driver->power(dev->hid, PM_HINT_NORMAL);
> +		dev->hid->ll_driver->close(dev->hid);
> +	}
> +
> +	ret = 0;
> +unlock:
> +	mutex_unlock(&minors_lock);
> +
> +	return ret;
> +}
> +static void set_calib_to_driver(struct ubt_calib *calib)
> +{
> +
> +	if (!calib)
> +		return;
> +	LTx = calib->LTx;
> +	LTy = calib->LTy;
> +	LBx = calib->LBx;
> +	LBy = calib->LBy;
> +	RTx = calib->RTx;
> +	RTy = calib->RTy;
> +	RBx = calib->RBx;
> +	RBy = calib->RBy;
> +
> +	LTX = calib->LTX;
> +	LTY = calib->LTY;
> +	LBX = calib->LBX;
> +	LBY = calib->LBY;
> +	RTX = calib->RTX;
> +	RTY = calib->RTY;
> +	RBX = calib->RBX;
> +	RBY = calib->RBY;
> +
> +	Xoff_A = calib->Xoff_A;
> +	Xmag_A = calib->Xmag_A;
> +	Xmag_B = calib->Xmag_B;
> +	Yoff_A = calib->Yoff_A;
> +	Ymag_A = calib->Ymag_A;
> +	Ymag_B = calib->Ymag_B;
> +
> +	isCalibrated = 1;
> +}
> +
> +
> +static void set_calib_to_device(struct ubt880_data *drvdata)
> +{
> +
> +	if (!drvdata)
> +		return;
> +	if (!isCalibrated)
> +		return;
> +	drvdata->calib.LTx = LTx;
> +	drvdata->calib.LTy = LTy;
> +	drvdata->calib.LBx = LBx;
> +	drvdata->calib.LBy = LBy;
> +	drvdata->calib.RTx = RTx;
> +	drvdata->calib.RTy = RTy;
> +	drvdata->calib.RBx = RBx;
> +	drvdata->calib.RBy = RBy;
> +
> +	drvdata->calib.LTX = LTX;
> +	drvdata->calib.LTY = LTY;
> +	drvdata->calib.LBX = LBX;
> +	drvdata->calib.LBY = LBY;
> +	drvdata->calib.RTX = RTX;
> +	drvdata->calib.RTY = RTY;
> +	drvdata->calib.RBX = RBX;
> +	drvdata->calib.RBY = RBY;
> +
> +	drvdata->calib.Xoff_A = Xoff_A;
> +	drvdata->calib.Xmag_A = Xmag_A;
> +	drvdata->calib.Xmag_B = Xmag_B;
> +	drvdata->calib.Yoff_A = Yoff_A;
> +	drvdata->calib.Ymag_A = Ymag_A;
> +	drvdata->calib.Ymag_B = Ymag_B;
> +
> +	drvdata->calib.calibrated = 1;
> +}
> +
> +static long ubt880_ioctl(struct file *iofile, unsigned int command, unsigned long data)
> +{
> +
> +	int retval = 0;
> +	struct inode *inode = iofile->f_path.dentry->d_inode;
> +	unsigned int minor = iminor(inode);
> +	struct ubt_chrdev *dev;
> +	struct ubt880_data *drvdata;
> +	mutex_lock(&minors_lock);
> +	dev = ubt_table[minor];
> +	if (!dev) {
> +		retval = -ENODEV;
> +		goto out;
> +	}
> +	drvdata = hid_get_drvdata(dev->hid);
> +	switch (command) {
> +	case GET_BATTERY_STATUS:
> +	{
> +		int *in = (int *) data;
> +		*in = 0;
> +		retval = 0;
> +		break;
> +	}
> +	case GET_LAST_PACKET_OLD:
> +	case GET_LAST_PACKET:
> +	{
> +		struct ubt880_dgtzr *packsrc = &drvdata->ubt_packet;
> +		struct ubt880_dgtzr *packdst = (struct ubt880_dgtzr *) data;
> +
> +		if (packsrc->report != 0x00) {
> +			memcpy((void *)packdst, (void *)packsrc, sizeof(struct ubt880_dgtzr));
> +			packsrc->report = 0;
> +			if (ubt_debug)
> +				printk(KERN_DEBUG "ubt880_ioctl_io : GET_LAST_PACKET2");
> +		}
> +
> +		retval = 0;
> +		break;
> +	}
> +	case GET_MODE:
> +	{
> +		int *in = (int *) data;
> +		printk(KERN_DEBUG "ubt880_ioctl_io : GET_MODE");
> +		*in = drvdata->current_mode;
> +		retval = 0;
> +		break;
> +	}
> +	case SET_MODE:
> +	{
> +		int *dt = (int *)data;
> +		printk(KERN_DEBUG "ubt_ioctl_io : SET_MODE");
> +		drvdata->ubt_packet.report = 0;
> +
> +		if (drvdata->switch_mode(dev->hid, *dt) != 0) {
> +				retval = -EIO;
> +				if (ubt_debug)
> +					printk(KERN_DEBUG "ubt_ioctl_io : SET_MODE error");
> +		} else {
> +			drvdata->current_mode = *dt;
> +			if (ubt_debug)
> +				printk(KERN_DEBUG "ubt_ioctl_io : SET_MODE ok, mode = %d", drvdata->current_mode);
> +			retval = 0;
> +		}
> +		break;
> +	}
> +	case SET_CALIB: {
> +		struct ubt_calib *calib = (struct ubt_calib *) data;
> +
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880_ioctl_io : SET_CALIB");
> +
> +		set_calib_to_driver(calib);
> +		set_calib_to_device(drvdata);
> +
> +		retval = 0;
> +		break;
> +	}
> +	case GET_DEVICE_ID: {
> +		int *in = (int *) data;
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt_ioctl_io : get device id");
> +		*in = dev->hid->product;
> +		retval = 0;
> +		break;
> +	}
> +#ifdef UBT780_DEBUG
> +	case TEST_MT_PACKET: {
> +
> +		send_test_packet(dev->hid);
> +		retval = 0;
> +		break;
> +	}
> +	case TEST_CALIBRATION: {
> +
> +		unsigned short *coord = (unsigned short *)data;
> +		fake_calibration(dev->hid, coord);
> +		retval = 0;
> +		break;
> +	}
> +#endif
> +	default:
> +	{
> +		retval = -EIO;
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880_ioctl_io : unknown command %d", command);
> +		break;
> +	}
> +	}
> +out:
> +	mutex_unlock(&minors_lock);
> +	return retval;
> +}

The above seems like a different driver altogether, and possibly
better implemented in userland.

> +/*-----------------------------------------------------------------------------------------------*/
> +static void ubt_report_input(struct input_dev *input, unsigned int x, unsigned int y, int btn_left, int btn_right)
> +{
> +	/* To prevent situation when new coords arrive before unpess */
> +	/* and a line is drawn istead of 2 dots */
> +	input_report_key(input, BTN_LEFT, btn_left);
> +	input_report_key(input, BTN_RIGHT, btn_right);
> +	/*if (btn)*/
> +		input_report_abs(input, ABS_X, x);
> +		input_report_abs(input, ABS_Y, y);
> +
> +	input_sync(input);
> +}
> +/* Debug output of raw MT packet from device */
> +static void ubt880_print_multitouch(struct ubt_mt_contact *pack, int size)
> +{
> +	int i;
> +	printk(KERN_DEBUG "-------------------------------------");
> +	for (i = 0; i < size; i++) {
> +		printk(KERN_DEBUG "-----------%d------------", i);
> +		printk(KERN_DEBUG "ubt880: mt packet: flags : inrange %X | tipswitch %X", pack[i].flags & 0x02, pack[i].flags & 0x01);
> +		printk(KERN_DEBUG "ubt880: mt packet: id | %d", pack[i].id);
> +		printk(KERN_DEBUG "ubt880: mt packet: X | %d", pack[i].x);
> +		printk(KERN_DEBUG "ubt880: mt packet: Y | %d", pack[i].y);
> +		printk(KERN_DEBUG "-------------------------");
> +	}
> +	printk(KERN_DEBUG "ubt880: mt packet: count: %d", size);
> +}

please remove excessive debugging

> +/* Report MT to the input subsystem*/
> +static void ubt880_report_contact(struct input_dev *input, struct ubt_mt_contact *contact)
> +{
> +	if (!contact || !input)
> +		return;
> +	input_report_abs(input, ABS_MT_TRACKING_ID, contact->id);
> +	input_report_abs(input, ABS_MT_POSITION_X, contact->x);
> +	input_report_abs(input, ABS_MT_POSITION_Y, contact->y);
> +	input_mt_sync(input);
> +}

please use slotted protocol instead

> +static void ubt880_report_mt(struct input_dev *input, struct ubt_mt_contact *pack, int size, struct ubt_calib *calib)
> +{
> +	int i = 0;
> +	/* Report MT contacts */
> +	if (size < 1)
> +		return;
> +	if (!input || !pack || !calib)
> +		return;

what do these error paths mean?

> +
> +	for (i = 0; i < size; i++) {
> +		/* If Tip Switch bit is set */
> +		if (pack[i].flags & 0x01) {
> +			if (calib->calibrated) {
> +				ubt_calibrate(pack[i].x,
> +						pack[i].y,
> +						(int *)&pack[i].x,
> +						(int *)&pack[i].y,
> +						calib);
> +			}
> +			ubt880_report_contact(input, &pack[i]);
> +		}
> +	}
> +	input_sync(input);
> +	/* Emulate single-touch device. Only first contact is used. */
> +	/* Note that is already calibrated */
> +	ubt_report_input(input, pack[0].x, pack[0].y, pack[0].flags & 0x01, 0);
> +}
> +
> +#ifdef UBT780_DEBUG
> +static void fake_calibration(struct hid_device *hdev, unsigned short *coord)
> +{
> +	char pack[6];
> +	unsigned short *pack_coord = (unsigned short *)&pack[2];
> +	pack[0] = 0x01;
> +	pack[1] = coord[0];
> +	pack_coord[0] = coord[1];
> +	pack_coord[1] = coord[2];
> +	ubt880_raw_event(hdev, 0, (u8 *)&pack, 6);
> +}
> +static void send_test_packet(struct hid_device *hdev)
> +{
> +	char testdata[20];
> +	struct ubt_mt_contact *contacts;
> +	struct ubt_calib calib;
> +
> +	calib.calibrated = 0;
> +
> +	testdata[0] = 0x03;
> +	contacts = (struct ubt_mt_contact *)&testdata[1];
> +	contacts[0].flags = 0x01;
> +	contacts[0].id = 0x01;
> +	contacts[0].x = 205;
> +	contacts[0].y = 1023;
> +
> +	contacts[1].flags = 0x01;
> +	contacts[1].id = 0x02;
> +	contacts[1].x = 1283;
> +	contacts[1].y = 1048;
> +
> +	contacts[2].flags = 0x01;
> +	contacts[2].id = 0x03;
> +	contacts[2].x = 508;
> +	contacts[2].y = 2473;
> +
> +	testdata[19] = 3;
> +
> +	ubt880_raw_event(hdev, 0, (u8 *)&testdata, 20);
> +}
> +#endif

please remove

> +
> +static struct input_dev *ubt880_get_input(struct hid_device *hdev)
> +{
> +	struct hid_input *hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
> +	struct input_dev *input;
> +
> +	if (!hidinput)
> +		return 0;
> +	input = hidinput->input;
> +	return input;
> +}
> +static int ubt880_raw_event(struct hid_device *hdev, struct hid_report *report, u8 *data, int size)
> +{
> +	struct ubt880_data *driver_data = hid_get_drvdata(hdev);
> +	struct ubt880_dgtzr *pack = &driver_data->ubt_packet;
> +
> +	struct input_dev *input = ubt880_get_input(hdev);
> +	if (!input)
> +		return -1;
> +
> +	if (!driver_data)
> +		return -1;
> +	/*Save the packet for userspace processing*/
> +	/*Mouse mode packet*/
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt880:raw_event: report = %X", data[0]);
> +	switch (data[0]) {
> +	case 0x01: {
> +		int X, Y;
> +		memcpy((void *)pack, (void *)data, size);
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880_mode: Mouse");
> +
> +		if (driver_data->current_mode == MODE_UKN)
> +			driver_data->current_mode = MODE_MOUSE;
> +
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880: mouse packet: X=%d,Y=%d,Button=%d",
> +				pack->data[0], pack->data[1], pack->command);
> +		X = pack->data[0];
> +		Y = pack->data[1];
> +		if (driver_data->calib.calibrated) {
> +			ubt_calibrate(X, Y, &X, &Y, &driver_data->calib);
> +			if (ubt_debug)
> +				printk(KERN_DEBUG "ubt880: mouse packet calibrated: X=%d,Y=%d",
> +					X, Y);
> +		}
> +
> +		ubt_report_input(input, X, Y, pack->command & 0x01, pack->command & 0x02);

Transformation seems to appear both inside and outside of this function.

> +		/*Switch to digitizer*/
> +		if (driver_data->current_mode != MODE_MOUSE)
> +			ubt880_switch_mode(hdev, MODE_MOUSE);
> +		break;
> +	}
> +	case 0x02: {
> +		struct ubt780_dgtzr *pack = (struct ubt780_dgtzr *)data;
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt780_mode: DIG");
> +		if (driver_data->current_mode == MODE_UKN)
> +			driver_data->current_mode = MODE_DGTZR;
> +
> +		if (driver_data->current_mode == MODE_MOUSE) {
> +			pack->report = 0;
> +			if (ubt_debug)
> +				printk(KERN_DEBUG "ubt780_current_mode: MOUSE");
> +			/*Switch to mouse*/
> +			driver_data->switch_mode(hdev, MODE_MOUSE);
> +		} else if (driver_data->current_mode == MODE_DGTZR) {
> +			unsigned short *pCoord = (unsigned short *)(&pack->data[3]);
> +			struct ubt_calib *calib = &driver_data->calib;
> +			int X = (int) pCoord[0];
> +			int Y = (int) pCoord[1];
> +			int leftBtn = pack->data[2] >> 5 & 0x01;
> +			int rightBtn = pack->data[2] >> 4 & 0x01;
> +
> +			ubt_pen_to_int(&X, &Y);
> +
> +			driver_data->ubt_packet.report = 0x02;
> +			driver_data->ubt_packet.command = pack->data[2];
> +			driver_data->ubt_packet.data[0] = X;
> +			driver_data->ubt_packet.data[1] = Y;
> +
> +			if (driver_data->calib.calibrated) {
> +				if (ubt_calibrate(X, Y, &X, &Y, calib)) {
> +					if (ubt_debug)
> +						printk(KERN_DEBUG "ubt780_mode:\
> +							Calibrated;\
> +							x=%d y=%d,left_btn=%d\n",
> +							X, Y, leftBtn);
> +					ubt_report_input(input, X, Y, leftBtn, rightBtn);
> +				}
> +			} else {
> +				ubt_report_input(input, X, Y, leftBtn, rightBtn);
> +				if (ubt_debug)
> +					printk(KERN_DEBUG "ubt780_mode:\
> +						Not calibrated;\
> +						x=%d y=%d,left_btn=%d\n",
> +						X, Y, leftBtn);
> +			}
> +		}
> +		break;
> +	}
> +	case 0x03: {
> +		struct ubt_mt_packet *packet = (struct ubt_mt_packet *)data;
> +		if (ubt_debug) {
> +			printk(KERN_DEBUG "ubt880_mode: Multitouch");
> +			printk(KERN_DEBUG "ubt880_driver_mode : %d", driver_data->current_mode);
> +		}
> +		if (driver_data->current_mode == MODE_UKN)
> +			driver_data->current_mode = MODE_DGTZR;
> +
> +		if (ubt_debug)
> +			ubt880_print_multitouch((struct ubt_mt_contact *)&packet->data[1], packet->data[19]);
> +
> +		if (driver_data->current_mode == MODE_MOUSE) {
> +			driver_data->switch_mode(hdev, MODE_MOUSE);
> +		} else if (driver_data->current_mode == MODE_DGTZR) {
> +			ubt880_report_mt(input, (struct ubt_mt_contact *)&packet->data[1], packet->data[19], &driver_data->calib);
> +		}
> +		break;
> +	}
> +	default:
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880: raw_report: Unknown report %X", pack->report);
> +	}
> +
> +
> +	UBT_DUMMY_DEBUG
> +	return 0;
> +}
> +static void ubt880_remove(struct hid_device *hdev)
> +{
> +	UBT_DUMMY_DEBUG
> +	ubt_chrdev_disconnect(hdev);
> +	hid_hw_stop(hdev);
> +	kfree(hid_get_drvdata(hdev));
> +	hid_set_drvdata(hdev, NULL);
> +}
> +
> +static struct hid_device_id ubt880_devices[] = {
> +	{ HID_USB_DEVICE(0x04da, 0x104d) },
> +	{ HID_USB_DEVICE(0x04da, 0x1044) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, ubt880_devices);
> +
> +static struct hid_driver ubt880_driver = {
> +	.name = "ubt880",
> +	.id_table = ubt880_devices,
> +	.probe = ubt880_probe,
> +	.remove = ubt880_remove,
> +	.input_mapping = ubt880_input_mapping,
> +	.raw_event = ubt880_raw_event,
> +	.event = ubt880_event,
> +};
> +
> +static int __init ubt880_init(void)
> +{
> +	int retval = ubt_chrdev_init();
> +	retval = hid_register_driver(&ubt880_driver);
> +	UBT_DUMMY_DEBUG
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt880 : init : chrdev_init : retval = %X", retval);
> +	return retval;
> +}
> +
> +static void __exit ubt880_exit(void)
> +{
> +	UBT_DUMMY_DEBUG
> +	hid_unregister_driver(&ubt880_driver);
> +	ubt_chrdev_cleanup();
> +}
> +
> +module_init(ubt880_init);
> +module_exit(ubt880_exit);
> +
> +MODULE_AUTHOR("Anton Chikin <kverlin@gmail.com>");
> +MODULE_DESCRIPTION("Panasonic UB-T780 driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/hid/hid-ubt880.h b/drivers/hid/hid-ubt880.h
> new file mode 100644
> index 0000000..961b03f
> --- /dev/null
> +++ b/drivers/hid/hid-ubt880.h
> @@ -0,0 +1,162 @@
> +/*
> + *  USB HID driver for Panasonic elite Panaboard UTB780
> + *   Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
> + *   Copyright (c) 2010-2011 Anton Chikin<anton.chikin@dataart.com> for Panasonic.
> + *
> + *  Information.
> + *  It's driver for supporting Panasonic Elite Panaboard HID USB device.
> + *
> + *  This file is part of USB HID driver for Panasonic elite Panaboard UTB780.
> + *
> + *  This driver is free software: you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation, either version 3 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This driver is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this driver.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/hid.h>
> +#ifndef UBT780CTRL
> +#define UBT780CTRL
> +
> +/*IOCTRL codes*/
> +/** Battary status IOCTL defines */
> +#define GET_BATTERY_STATUS		0x01 /*get battery status, return BATTERY_STATUS_UKN, BATTERY_STATUS_FINE, BATTERY_STATUS_WEAK*/
> +#define GET_LAST_PACKET_OLD		0x02 /*get last packet (ubt780_dgtzr). It is necessary for calibration*/
> +
> +/** Modes of work IOCTL */
> +#define GET_MODE			0x10 /*get current mode, return MODE_MOUSE, MODE_DGTZR*/
> +#define SET_MODE			0x11 /*switch to mouse mode, MODE_MOUSE, MODE_DGTZR*/
> +#define SET_CALIB			0x20 /*set calibration mode*/
> +#define GET_LAST_PACKET			0x21 /*get last packet (ubt780_dgtzr). It is necessary for calibration*/
> +#define GET_DEVICE_ID			0x22 /*get device id to recognize the device version*/
> +#define TEST_MT_PACKET			0x23
> +#define TEST_CALIBRATION		0x24
> +/*return values for ioctrl*/
> +/** Battary status defines */
> +#define BATTERY_STATUS_FINE		0x00 /*battery is fine*/
> +#define BATTERY_STATUS_WEAK		0x01 /*battery is weak*/
> +#define BATTERY_STATUS_UKN		0x02 /*unknown status. Status will be known after the first pen touch*/
> +
> +/** Mode status defines */
> +#define MODE_MOUSE			0x10 /*current mode is mouse*/
> +#define MODE_DGTZR			0x11 /*current mode is digitizer*/
> +#define MODE_UKN			0x12 /*current mode is unknown. It will be known after the first pen touch*/
> +#define MODE_SINGLETOUCH		0x13
> +
> +/*Char device declarations*/
> +#define UBT780_MAX_DEVICES		0x05
> +#define UBT780_FIRST_MINOR		0
> +
> +#define UBT780_MAX_AXIS_X	4095
> +#define UBT780_MAX_AXIS_Y	4095
> +#define UBT880_MAX_AXIS_X	32767
> +#define UBT880_MAX_AXIS_Y	32767
> +#define NUM_CONTACTS		0x03
> +/** Digitizer mode stucture: contains packet data */
> +struct ubt880_dgtzr {
> +	/** Report contains the type of packet: 0 - mouse, 1 - digitize */
> +	unsigned char report;
> +	/** Command is coming from device */
> +	unsigned char command;
> +	/** Packet size */
> +	unsigned short data[2];
> +};
> +
> +struct ubt780_dgtzr {
> +	/** Report contains the type of packet: 0 - mouse, 1 - digitize */
> +	unsigned char report;
> +	/** Command is coming from device */
> +	unsigned char command;
> +	/** Packet size */
> +	unsigned char number;
> +	/** Data part of packet */
> +	unsigned char data[17];
> +};
> +/** Calibration stucture: contains calibration data */
> +struct ubt_calib {
> +	/** Screen coordinates: Left Top X */
> +	int LTx;
> +	/** Screen coordinates: Left Top Y */
> +	int LTy;
> +	/** Screen coordinates: Left Bottom X */
> +	int LBx;
> +	/** Screen coordinates: Left Bottom Y */
> +	int LBy;
> +	/** Screen coordinates: Right Top X */
> +	int RTx;
> +	/** Screen coordinates: Right Top Y */
> +	int RTy;
> +	/** Screen coordinates: Right Bottom X */
> +	int RBx;
> +	/** Screen coordinates: Right Bottom Y */
> +	int RBy;
> +
> +	/** Board coordinates: Left Top X */
> +	int LTX;
> +	/** Board coordinates: Left Top Y */
> +	int LTY;
> +	/** Board coordinates: Left Bottom X */
> +	int LBX;
> +	/** Board coordinates: Left Bottom Y */
> +	int LBY;
> +	/** Board coordinates: Right Top X */
> +	int RTX;
> +	/** Board coordinates: Right Top Y */
> +	int RTY;
> +	/** Board coordinates: Right Bottom X */
> +	int RBX;
> +	/** Board coordinates: Right Bottom Y */
> +	int RBY;
> +
> +	/** Calculated values */
> +	int Xoff_A;
> +	int Xmag_A;
> +	int Xmag_B;
> +	int Yoff_A;
> +	int Ymag_A;
> +	int Ymag_B;
> +	int calibrated;
> +};
> +/*Character device data structure*/
> +struct ubt_chrdev {
> +	unsigned int minor;
> +	int exist;
> +	int open;
> +	struct hid_device *hid;
> +	struct device *dev;
> +};
> +/*Driver data structure*/
> +struct ubt780_data {
> +	struct ubt_calib calib;
> +	struct ubt780_dgtzr ubt_packet;
> +	struct ubt_chrdev *chrdev;
> +	unsigned char current_mode;
> +};
> +
> +struct ubt880_data {
> +	struct ubt_calib calib;
> +	struct ubt880_dgtzr ubt_packet;
> +	struct ubt_chrdev *chrdev;
> +	unsigned char current_mode;
> +	int (*switch_mode) (struct hid_device *hid, unsigned char mode);
> +	void (*set_input) (struct input_dev *input);
> +};
> +/*ubt880 multitouch structures*/
> +struct ubt_mt_contact {
> +	unsigned char flags;
> +	unsigned char id;
> +	unsigned short x;
> +	unsigned short y;
> +};
> +struct ubt_mt_packet {
> +	unsigned char data[20];
> +};
> +#endif /* UBT780CTRL */
> -- 
> 1.7.1
> 

Thanks,
Henrik
