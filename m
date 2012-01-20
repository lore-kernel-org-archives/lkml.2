Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2ATS03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:26:29 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:58193 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2ATS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:26:27 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvlEAGuwGU9V5qrvPGdsb2JhbABDiUukPRkBAQEBNzKBcgEBBAEnExwjBQsIA0YUDRgKGhOHfAK4WROLMGMElRiFZYUdh0s
X-IronPort-AV: E=Sophos;i="4.71,544,1320620400"; 
   d="scan'208";a="34351658"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 20 Jan 2012 19:26:50 +0100
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ogay@logitech.com, jzanone@logitech.com, phorvath@logitech.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] HID: Add full MT support for Logitech Wireless
 Touchpad
Message-ID: <20120120182650.GA19242@polaris.bitmath.org>
References: <1326800683-29439-1-git-send-email-nlopezcasad@logitech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326800683-29439-1-git-send-email-nlopezcasad@logitech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nestor,

Please find some initial comments below.

> diff --git a/drivers/hid/hid-logitech-wtp.c b/drivers/hid/hid-logitech-wtp.c
> new file mode 100644
> index 0000000..d1bdef6
> --- /dev/null
> +++ b/drivers/hid/hid-logitech-wtp.c
> @@ -0,0 +1,434 @@
> +/*
> + *  HID driver for Logitech Wireless Touchpad device
> + *
> + *  Copyright (c) 2011 Logitech (c)
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + * Should you need to contact me, the author, you can do so by e-mail send
> + * your message to Benjamin Tissoires <benjamin.tissoires at gmail com>
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/hid.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/input/mt.h>
> +
> +MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
> +MODULE_AUTHOR("Nestor Lopez Casado <nlopezcasad@logitech.com>");
> +MODULE_DESCRIPTION("Logitech Wireless Touchpad");
> +MODULE_LICENSE("GPL");
> +
> +#include "hid-ids.h"
> +#include "hid-logitech-hidpp.h"
> +
> +#define X_SIZE 3700
> +#define Y_SIZE 2480

Why are these defined, if they are also read from the device?

> +#define CMD_TOUCHPAD_GET_RAW_INFO		0x01
> +#define CMD_TOUCHPAD_GET_RAW_REPORT_STATE	0x11
> +#define CMD_TOUCHPAD_SET_RAW_REPORT_STATE	0x21
> +#define EVENT_TOUCHPAD_RAW_XY			0x30
> +#define EVENT_TOUCHPAD_RAW_XY_			0x00

The last two seem unused.

> +#define WTP_RAW_XY_FEAT_INDEX			0x0F
> +
> +struct hidpp_touchpad_raw_info {
> +	u16 x_size;
> +	u16 y_size;
> +	u8 z_range;
> +	u8 area_range;
> +	u8 timestamp_unit;
> +	u8 origin;
> +	u8 pen_supported;
> +};
> +
> +struct hidpp_touchpad_raw_xy_finger {
> +	u8 contact_type;
> +	u8 contact_status;
> +	u16 x;
> +	u16 y;
> +	u8 z;
> +	u8 area;
> +	u8 finger_id;
> +};
> +
> +struct hidpp_touchpad_raw_xy {
> +	u16 timestamp;
> +	struct hidpp_touchpad_raw_xy_finger fingers[2];
> +	u8 spurious_flag;
> +	u8 end_of_frame;
> +	u8 finger_count;
> +};
> +
> +struct wtp_mt_slot {
> +	bool touch_state;	/* is the touch valid? */
> +	bool seen_in_this_frame;/* has this slot been updated */
> +};
> +
> +struct wtp_data {
> +	struct input_dev *input;
> +	__u16 x_size, y_size;
> +	__u8 p_range, area_range;
> +	__u8 finger_count;
> +	__u8 mt_feature_index;
> +	__u8 button_feature_index;
> +	__u8 maxcontacts;
> +	struct wtp_mt_slot slots[5];
> +};
> +
> +struct touch_hidpp_report {
> +	u8 x_m;
> +	u8 x_l;
> +	u8 y_m;
> +	u8 y_l;
> +	u8 z;
> +	u8 area;
> +	u8 id;
> +};
> +
> +struct dual_touch_hidpp_report {
> +	u8 report_id;
> +	u8 device_index;
> +	u8 feature_index;
> +	u8 broadcast_event;
> +	u16 timestamp;
> +	struct touch_hidpp_report touches[2];
> +};

Seven structs seems a bit much, let's see how things unfold.

> +
> +static void wtp_touch_event(struct wtp_data *fd,
> +	struct hidpp_touchpad_raw_xy_finger *touch_report)
> +{
> +	int slot = touch_report->finger_id - 1;
> +
> +	fd->slots[slot].seen_in_this_frame = true;
> +	fd->slots[slot].touch_state = touch_report->contact_status;
> +
> +	input_mt_slot(fd->input, slot);
> +	input_mt_report_slot_state(fd->input, MT_TOOL_FINGER,
> +					touch_report->contact_status);
> +	if (touch_report->contact_status) {
> +		input_event(fd->input, EV_ABS, ABS_MT_POSITION_X,
> +				touch_report->x);
> +		input_event(fd->input, EV_ABS, ABS_MT_POSITION_Y,
> +				touch_report->y);
> +		input_event(fd->input, EV_ABS, ABS_MT_PRESSURE,
> +				touch_report->area);
> +	}
> +}

At first glance, it seems fd->slots[slot], and hence struct
wtp_mt_slot, can be removed altogether. A local bitmask can keep track
of the slots seen in this frame.

> +
> +static int wtp_touchpad_raw_xy_event(struct hidpp_device *hidpp_dev,
> +				u8 *event_data)
> +{
> +	struct hidpp_touchpad_raw_xy *raw =
> +		(struct hidpp_touchpad_raw_xy *)event_data;

Why does this function not take (struct hidpp_touchpad_raw_xy *) instead of (u8 *)?

> +	struct wtp_data *fd = (struct wtp_data *)hidpp_dev->driver_data;
> +
> +	int finger_count = raw->finger_count;
> +	bool end_of_frame = raw->end_of_frame;
> +
> +	int i;

The variables above were first introduced in a local struct on the
stack in first ontroduced(), then sent via a pointer to a to this
function, only to be put on the stack again. Sending as arguments
instead might be simpler, and save us another struct.

> +
> +	if (!hidpp_dev->initialized)
> +		return 0;
> +
> +	if (finger_count) {
> +		wtp_touch_event(fd, &(raw->fingers[0]));
> +		if ((end_of_frame && finger_count == 4) ||
> +			(!end_of_frame && finger_count >= 2))
> +			wtp_touch_event(fd, &(raw->fingers[1]));

One or two calls to wtp_touch_event(), with data filled in using
similar logic in the calling function. Perhaps two calls with
arguments instead, saving us another struct.

> +	}
> +
> +	if (end_of_frame || finger_count <= 2) {
> +		for (i = 0; i < ARRAY_SIZE(fd->slots); i++) {
> +			if (!fd->slots[i].seen_in_this_frame &&
> +				fd->slots[i].touch_state) {
> +				input_mt_slot(fd->input, i);
> +				input_mt_report_slot_state(fd->input,
> +					MT_TOOL_FINGER, 0);
> +				fd->slots[i].touch_state = 0;
> +			}
> +
> +			fd->slots[i].seen_in_this_frame = false;
> +
> +		}

Logic to report the non-seen fingers as up can be simplified. Please
see the cyttsp driver currently in review for an example.

> +		input_mt_report_pointer_emulation(fd->input, true);
> +		input_report_key(fd->input, BTN_TOOL_FINGER,
> +				 finger_count == 1);
> +		input_report_key(fd->input, BTN_TOOL_DOUBLETAP,
> +				 finger_count == 2);
> +		input_report_key(fd->input, BTN_TOOL_TRIPLETAP,
> +				 finger_count == 3);
> +		input_report_key(fd->input, BTN_TOOL_QUADTAP,
> +				 finger_count == 4);

The button reports here are already included in the call to input_mt_report_pointer_emulation().

> +		input_sync(fd->input);

A comment explaining that we send packets after every two touch updates would be good.

> +	}
> +	return 1;
> +}
> +
> +
> +static void hidpp_touchpad_touch_event(struct touch_hidpp_report *touch_report,

A const here makes it easier to see input vs output.

> +	struct hidpp_touchpad_raw_xy_finger *finger)
> +{
> +	u8 x_m = touch_report->x_m << 2;
> +	u8 y_m = touch_report->y_m << 2;
> +
> +	finger->contact_type = touch_report->x_m >> 6;
> +	finger->x = x_m << 6 | touch_report->x_l;
> +
> +	finger->contact_status = touch_report->y_m >> 6;
> +	finger->y = y_m << 6 | touch_report->y_l;
> +
> +	finger->finger_id = touch_report->id >> 4;

What is hidden in bits [3..0] of report->id?

> +	finger->z = touch_report->z;
> +	finger->area = touch_report->area;
> +}
> +
> +static int hidpp_touchpad_raw_xy_event(struct hidpp_device *hidpp_device,
> +		struct hidpp_report *hidpp_report)
> +{
> +	struct dual_touch_hidpp_report *dual_touch_report;
> +	struct hidpp_touchpad_raw_xy raw_xy;
> +
> +	dual_touch_report = (struct dual_touch_hidpp_report *)hidpp_report;
> +	raw_xy.end_of_frame = dual_touch_report->touches[0].id & 0x01;
> +	raw_xy.spurious_flag = (dual_touch_report->touches[0].id >> 1) & 0x01;
> +	raw_xy.finger_count = dual_touch_report->touches[1].id & 0x0f;

It seems the dual_touch_report data could be named better. End of
frame and finger_count are both extracted from the touch id, from
different "fingers" at that.

> +
> +	if (raw_xy.finger_count) {
> +		hidpp_touchpad_touch_event(&dual_touch_report->touches[0],
> +				&raw_xy.fingers[0]);
> +		if ((raw_xy.end_of_frame && raw_xy.finger_count == 4) ||
> +			(!raw_xy.end_of_frame && raw_xy.finger_count >= 2))
> +			hidpp_touchpad_touch_event(
> +					&dual_touch_report->touches[1],
> +					&raw_xy.fingers[1]);
> +	}
> +	return wtp_touchpad_raw_xy_event(hidpp_device, (u8 *)&raw_xy);

This could probably be simplified to two calls to wtp_touch_event()
directly.

> +}
> +
> +static int hidpp_touchpad_get_raw_info(struct hidpp_device *hidpp_dev,
> +	struct hidpp_touchpad_raw_info *raw_info)
> +{
> +	struct hidpp_report response;
> +	int ret;
> +	u8 *params = (u8 *)response.fap.params;
> +
> +	ret = hidpp_send_fap_command_sync(hidpp_dev, WTP_RAW_XY_FEAT_INDEX,
> +			CMD_TOUCHPAD_GET_RAW_INFO, NULL, 0, &response);
> +
> +	if (ret)
> +		return -ret;
> +
> +	*raw_info = *(struct hidpp_touchpad_raw_info *)params;
> +
> +	raw_info->x_size = params[0] << 8 | params[1];
> +	raw_info->y_size = params[2] << 8 | params[3];

So we get the coordinate sizes here.

> +
> +	return ret;
> +}
> +
> +static int hidpp_touchpad_set_raw_report_state(struct hidpp_device *hidpp_dev,
> +				bool send_raw_reports,
> +				bool force_vs_area,
> +				bool sensor_enhanced_settings)
> +{
> +	struct hidpp_report response;
> +	int ret;
> +	u8 params = send_raw_reports | force_vs_area << 1 |
> +				sensor_enhanced_settings << 2;
> +
> +	ret = hidpp_send_fap_command_sync(hidpp_dev, WTP_RAW_XY_FEAT_INDEX,
> +		CMD_TOUCHPAD_SET_RAW_REPORT_STATE, &params, 1, &response);
> +
> +	if (ret)
> +		return -ret;
> +
> +	return ret;
> +}
> +
> +static int wtp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> +		struct hid_field *field, struct hid_usage *usage,
> +		unsigned long **bit, int *max)
> +{
> +	struct hidpp_device *hidpp_dev = hid_get_drvdata(hdev);
> +	struct wtp_data *fd = (struct wtp_data *)hidpp_dev->driver_data;
> +	struct input_dev *input = hi->input;
> +
> +	dbg_hid("%s:\n", __func__);
> +
> +	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_BUTTON)
> +		return -1;
> +
> +	fd->input = hi->input;
> +
> +	__set_bit(BTN_TOUCH, input->keybit);
> +	__set_bit(BTN_TOOL_FINGER, input->keybit);
> +	__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
> +	__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
> +	__set_bit(BTN_TOOL_QUADTAP, input->keybit);
> +
> +	__set_bit(EV_ABS, input->evbit);
> +
> +	input_mt_init_slots(input, fd->maxcontacts);
> +
> +	input_set_capability(input, EV_KEY, BTN_TOUCH);
> +
> +	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
> +	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
> +	input_set_abs_params(input, ABS_MT_POSITION_X, 0, X_SIZE, 0, 0);
> +	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, Y_SIZE, 0, 0);
> +	input_set_abs_params(input, ABS_X, 0, X_SIZE, 0, 0);
> +	input_set_abs_params(input, ABS_Y, 0, Y_SIZE, 0, 0);

And we use static coordinate sizes here.

> +
> +	return 0;
> +}
> +
> +static void wtp_connect_change(struct hidpp_device *hidpp_dev, bool connected)
> +{
> +	dbg_hid("%s: connected:%d\n", __func__, connected);
> +	if ((connected) && (hidpp_dev->initialized))
> +		hidpp_touchpad_set_raw_report_state(hidpp_dev, true, true, true);
> +}
> +
> +static int wtp_device_init(struct hidpp_device *hidpp_dev)
> +{
> +	int ret;
> +	struct hidpp_touchpad_raw_info raw_info = {};
> +	struct wtp_data *fd = (struct wtp_data *)hidpp_dev->driver_data;
> +
> +	dbg_hid("%s\n", __func__);
> +
> +	ret = hidpp_touchpad_set_raw_report_state(hidpp_dev, true, true, true);
> +
> +	if (ret) {
> +		hid_err(hidpp_dev->hid_dev, "unable to set to raw report mode. "
> +			"The device may not be in range.\n");
> +		return ret;
> +	}
> +
> +	ret = hidpp_touchpad_get_raw_info(hidpp_dev, &raw_info);
> +
> +	if (!ret) {
> +		if ((X_SIZE != raw_info.x_size) || (Y_SIZE != raw_info.y_size))
> +			hid_err(hidpp_dev->hid_dev,
> +				"error getting size. Should have %dx%d, "
> +				"but device reported %dx%d, ignoring\n",
> +				X_SIZE, Y_SIZE,
> +				raw_info.x_size, raw_info.y_size);
> +
> +		fd->x_size = raw_info.x_size;
> +		fd->y_size = raw_info.y_size;

And we bail out if the device coordinates are not the same as the ones
compiled in here. Seems to me we should initialize the input device
based on the device coordinates instead?

> +	}
> +
> +	return ret;
> +}
> +
> +static int wtp_probe(struct hid_device *hdev, const struct hid_device_id *id)
> +{
> +	struct wtp_data *fd;
> +	struct hidpp_device *hidpp_device;
> +	int ret;
> +
> +	dbg_hid("%s\n", __func__);
> +
> +	hidpp_device = kzalloc(sizeof(struct hidpp_device), GFP_KERNEL);
> +	if (!hidpp_device) {
> +		hid_err(hdev, "cannot allocate hidpp_device\n");
> +		return -ENOMEM;
> +	}
> +
> +	fd = kzalloc(sizeof(struct wtp_data), GFP_KERNEL);
> +	if (!fd) {
> +		hid_err(hdev, "cannot allocate wtp Touch data\n");
> +		kfree(hidpp_device);
> +		return -ENOMEM;
> +	}
> +
> +	fd->mt_feature_index = 0x0f;
> +	fd->button_feature_index = 0x02;
> +	fd->maxcontacts = 5;
> +
> +	hidpp_device->driver_data = (void *)fd;
> +	hid_set_drvdata(hdev, hidpp_device);
> +
> +	hidpp_device->device_init = wtp_device_init;
> +	hidpp_device->connect_change = wtp_connect_change;
> +	hidpp_device->raw_event = hidpp_touchpad_raw_xy_event;
> +
> +	ret = hid_parse(hdev);
> +	if (ret)
> +		goto parse_failed;
> +
> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> +	if (ret)
> +		goto failed;
> +
> +	ret = hidpp_init(hidpp_device, hdev);
> +	if (ret)
> +		goto failed;
> +
> +	return 0;
> +
> +failed:
> +	hid_hw_stop(hdev);
> +parse_failed:
> +	kfree(hidpp_device->driver_data);
> +	kfree(hidpp_device);
> +	hid_set_drvdata(hdev, NULL);
> +	return -ENODEV;
> +}
> +
> +static void wtp_remove(struct hid_device *hdev)
> +{
> +	struct hidpp_device *hidpp_dev = hid_get_drvdata(hdev);
> +	struct wtp_data *fd = hidpp_dev->driver_data;
> +	dbg_hid("%s\n", __func__);
> +	hid_hw_stop(hdev);
> +	hidpp_remove(hidpp_dev);
> +	kfree(fd);
> +	kfree(hidpp_dev);
> +	hid_set_drvdata(hdev, NULL);
> +}
> +
> +static const struct hid_device_id wtp_devices[] = {
> +	{HID_DEVICE(BUS_DJ, USB_VENDOR_ID_LOGITECH, UNIFYING_DEVICE_ID_WIRELESS_TOUCHPAD) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, wtp_devices);
> +
> +static struct hid_driver wtp_driver = {
> +	.name = "wtp-touch",
> +	.id_table = wtp_devices,
> +	.probe = wtp_probe,
> +	.remove = wtp_remove,
> +	.input_mapping = wtp_input_mapping,
> +	.raw_event = hidpp_raw_event,
> +};
> +
> +static int __init wtp_init(void)
> +{
> +	return hid_register_driver(&wtp_driver);
> +}
> +
> +static void __exit wtp_exit(void)
> +{
> +	hid_unregister_driver(&wtp_driver);
> +}
> +
> +module_init(wtp_init);
> +module_exit(wtp_exit);
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 3862e32..7e930e6 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -897,6 +897,7 @@ struct input_keymap_entry {
>  #define BUS_GSC			0x1A
>  #define BUS_ATARI		0x1B
>  #define BUS_SPI			0x1C
> +#define BUS_DJ			0x1D
>  
>  /*
>   * MT_TOOL types
> -- 
> 1.7.5.3

Thanks,
Henrik
