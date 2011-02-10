Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1BJNos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:44:48 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:39333 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab1BJNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:44:46 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Feb 2011 14:45:04 +0100
To: kverlin@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        Anton Chikin <anton.chikin@dataart.com>
Subject: Re: [PATCH] hid: Panasonic UB-T780 and UB-T880 driver
Message-ID: <20110210134504.GA9025@polaris.bitmath.org>
References: <1297273323-8015-1-git-send-email-kverlin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297273323-8015-1-git-send-email-kverlin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PnWot-0006Cj-Ak.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PnWot-0006Cj-Ak 99ccc72dd594530f280eb23a3161ff99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

> Panasonic Elite Panaboard UB-T* hid driver.
> Removed all unnesessary comments and debug stuff. Multitouch now uses Protocol B.
> Still parsing by hands because of incompatible report descriptor in UB-T780.
> ---

Please keep the original commit message above the "---", and add
comments about changes etc below it.

> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 2560f01..5c96c63 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -324,6 +324,12 @@ config HID_ORTEK
>  	---help---
>  	Support for Ortek WKB-2000 wireless keyboard + mouse trackpad.
>  
> +config HID_PANASONIC
> +	tristate "Panasonic Elite Panaboards"
> +	depends on USB_HID
> +	---help---
> +	Support for Panasonic Elite Panaboard UB-T780 and UB-T880.
> +

What is the module called? Please add to the text.

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

This driver should really be placed in input/touchscreen/ instead,
since it seems to not follow the hid standard at all. Perhaps it can
even be merged into one of the existing, more generic drivers like
usbtouchscreen. Even as a standalone driver, there are plenty of
examples to copy from.

> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +#include <linux/fs.h>
> +#include <linux/cdev.h>
> +#include "hid-ids.h"
> +#include "hid-ubt880.h"
> +#include "usbhid/usbhid.h"
> +/*switch_mode : Our device has two modes: mouse mode in which it is acting like mouse, producing
> + * absolute coordinates [0 - 4095]
> + * The second mode is digitizer mode, which produce two raw clock measurments from ultrasound
> + * recievers in the top-left corner of the board. This mode more flexible and also reports batterey
> + * status of digitizer pen and penID.
> + */

Please use kernel-style comment format

> +static int ubt880_switch_mode(struct hid_device *hid, unsigned char mode)
> +{
> +	struct hid_report *report = NULL;
> +	struct hid_report *report_cur = NULL;
> +	__s32 *val = NULL;
> +	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
> +	{
> +		if (hid->report_enum[HID_FEATURE_REPORT].numbered)
> +			report_cur = report;
> +	}
> +	if (report_cur == NULL)
> +		return -EIO;
> +
> +	val = report_cur->field[0]->value;
> +	val[0] = mode;
> +	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
> +	return 0;
> +}
> +
> +static int ubt780_switch_mode(struct hid_device *hid, unsigned char mode)
> +{
> +	struct hid_report *report = NULL;
> +	struct hid_report *report_cur = NULL;
> +	__s32 *val = NULL;
> +	list_for_each_entry(report, &hid->report_enum[HID_OUTPUT_REPORT].report_list, list)
> +	{
> +		if (hid->report_enum[HID_OUTPUT_REPORT].numbered)
> +			report_cur = report;
> +	}
> +
> +	if (report_cur == NULL)
> +		return -EIO;
> +
> +	val = report_cur->field[0]->value;
> +	val[0] = 0x7e;
> +	val[1] = 0x04;
> +	val[2] = 0x4d;
> +	val[3] = mode;
> +	val[4] = 0x00;
> +	val[5] = 0x0a;
> +	val[6] = 0x00;
> +	val[7] = 0x00;
> +	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
> +	return 0;
> +}

Please put the common code in the two functions above into a function.

> +
> +/* PenToInt : converts ultrasound clock measurements to screen coordinates.*/
> +static bool ubt_pen_to_int(int *pLeft, int *pRight, struct ubt_data *drvdata)
> +{
> +	int left2, right2 , n, w_n, sqr, xx, yy;

extra spaces

> +	static int w = 1164;

const static, or define

> +
> +	left2  = (*pLeft) * (*pLeft);
> +	right2 = (*pRight) * (*pRight);
> +
> +	if (left2 == 0 && right2 == 0) {
> +		*pLeft = drvdata->xold;
> +		*pRight = drvdata->yold;
> +	    return true;
> +	}
> +
> +	n = (right2 - left2) / (2 * w);
> +	w_n = w-n;
> +
> +	sqr = (2 * left2 - (w_n * w_n));
> +
> +	if (sqr < 0)
> +		return false;
> +
> +	xx = (w_n + int_sqrt(sqr)) / 2;
> +	yy = xx + n;
> +
> +	if (xx < 0 || yy < 0)
> +		return false;
> +
> +	*pLeft = xx;
> +	*pRight = yy;
> +	drvdata->xold = xx;
> +	drvdata->yold = yy;
> +
> +	return true;
> +}
> +
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

ABS_MT_TRACKING id should not be set - please use input_mt_init_slots() instead.

> +	input_set_abs_params(input, ABS_X, 0, UBT880_MAX_AXIS_X, 0, 0);
> +	input_set_abs_params(input, ABS_Y, 0, UBT880_MAX_AXIS_Y, 0, 0);
> +	input_mt_create_slots(input, NUM_CONTACTS);

Please test against 2.6.38-rc.

> +}

> +static void ubt880_report_contact(struct input_dev *input, struct ubt_mt_contact *contact)
> +{
> +	/* Contact id's are allways 1..3 so we can determine slot
> +	 * without keeping contact data in device data.
> +	 */
> +	input_mt_slot(input, contact->id - 1);
> +	if (!contact->flags) {
> +		input_report_abs(input, ABS_MT_TRACKING_ID, -1);
> +	} else {
> +		input_report_abs(input, ABS_MT_TRACKING_ID, contact->id);
> +		input_report_abs(input, ABS_MT_POSITION_X, contact->x);
> +		input_report_abs(input, ABS_MT_POSITION_Y, contact->y);
> +	}
> +}

Please use input_mt_report_slot_state(). See hid/hid-multitouch.c for examples.

> +static void ubt880_report_mt(struct input_dev *input, struct ubt_mt_contact *pack, int size)
> +{
> +	int i = 0;
> +	/* Report MT contacts */
> +	if (size < 1)
> +		return;
> +	if (!input || !pack)
> +		return;

Either these errors never happen, or they should be properly
handled. Errorpaths are as important as the main code path.

> +
> +	for (i = 0; i < size; i++)
> +		ubt880_report_contact(input, &pack[i]);
> +
> +	input_sync(input);
> +	/* Emulate single-touch device. Only first contact is used. */
> +	/* Note that is already calibrated */
> +	ubt_report_input(input, pack[0].x, pack[0].y, pack[0].flags & 0x01, 0);
> +}

Sync before input report... no need to separate device outputs here.

> +static int ubt880_raw_event(struct hid_device *hdev, struct hid_report *report, u8 *data, int size)
> +{
> +	struct ubt_data *driver_data = hid_get_drvdata(hdev);
> +
> +	struct input_dev *input = ubt880_get_input(hdev);
> +	if (!input)
> +		return -1;
> +
> +	if (!driver_data)
> +		return -1;
> +	/*Save the packet for userspace processing*/
> +	/*Mouse mode packet*/
> +	switch (data[0]) {
> +	case 0x01: {
> +		int leftbtn, rightbtn;
> +		struct ubt880_dgtzr *pack = (struct ubt880_dgtzr *)data;
> +		if (driver_data->current_mode == MODE_UKN)
> +			driver_data->current_mode = MODE_MOUSE;
> +		leftbtn = pack->command & 0x01;
> +		rightbtn = (pack->command & 0x02) >> 1;
> +		ubt_report_input(input, pack->data[0], pack->data[1], leftbtn, rightbtn);
> +		if (driver_data->current_mode != MODE_MOUSE)
> +			ubt880_switch_mode(hdev, MODE_MOUSE);
> +		break;
> +	}
> +	case 0x02: {
> +		struct ubt780_dgtzr *pack = (struct ubt780_dgtzr *)data;
> +		if (driver_data->current_mode == MODE_UKN)
> +			driver_data->current_mode = MODE_DGTZR;
> +
> +		if (driver_data->current_mode == MODE_MOUSE) {
> +			driver_data->switch_mode(hdev, MODE_MOUSE);
> +		} else if (driver_data->current_mode == MODE_DGTZR) {
> +			unsigned short *pCoord = (unsigned short *)(&pack->data[3]);
> +			int X = (int) pCoord[0];
> +			int Y = (int) pCoord[1];
> +			int leftBtn = pack->data[2] >> 5 & 0x01;
> +			int rightBtn = pack->data[2] >> 4 & 0x01;
> +			if (ubt_pen_to_int(&X, &Y, driver_data))
> +				ubt_report_input(input, X, Y, leftBtn, rightBtn);
> +		}
> +		break;
> +	}
> +	case 0x03: {
> +		struct ubt_mt_packet *packet = (struct ubt_mt_packet *)data;
> +		if (driver_data->current_mode == MODE_UKN)
> +			driver_data->current_mode = MODE_MULTITOUCH;
> +
> +		if (driver_data->current_mode == MODE_MOUSE) {
> +			driver_data->switch_mode(hdev, MODE_MOUSE);
> +		} else if (driver_data->current_mode == MODE_MULTITOUCH) {
> +			ubt880_report_mt(input, (struct ubt_mt_contact *)&packet->data[1], packet->data[19]);
> +		}
> +		break;
> +	}
> +	}
> +
> +	return 0;
> +}

Please replace with an urb completion handler in the new driver.

> +static struct hid_device_id ubt880_devices[] = {
> +	{ HID_USB_DEVICE(0x04da, 0x104d) },
> +	{ HID_USB_DEVICE(0x04da, 0x1044) },
> +	{ }
> +};

Please use the stated defines.

Thank you.

Henrik
