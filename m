Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2CMVL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:11:59 -0400
Received: from host171.canaca.com ([67.55.55.225]:36373 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2CMVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:11:57 -0400
Message-ID: <c23117ac22f05981ab9e7b519d5d8b75.squirrel@mungewell.org>
In-Reply-To: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
References: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
Date: Tue, 13 Mar 2012 17:11:55 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
From: simon@mungewell.org
Cc: "Jiri Kosina" <jkosina@suse.cz>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael Bauer" <michael@m-bauer.org>,
        "Michal Maly" <madcatxster@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20120313171155_37104"
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20120313171155_37104
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> Code snipet below (full file attached):

Whoops, wrong file attached.
Simon.
------=_20120313171155_37104
Content-Type: text/x-csrc; name="hid-lg4ff.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="hid-lg4ff.c"

/*
 *  Force feedback support for Logitech Speed Force Wireless
 *
 *  http://wiibrew.org/wiki/Logitech_USB_steering_wheel
 *
 *  Copyright (c) 2010 Simon Wood <simon@mungewell.org>
 */

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */


#include <linux/input.h>
#include <linux/usb.h>
#include <linux/hid.h>
#include <linux/leds.h>

#include "usbhid/usbhid.h"
#include "hid-lg.h"
#include "hid-ids.h"

#define DFGT_REV_MAJ 0x13
#define DFGT_REV_MIN 0x22
#define DFP_REV_MAJ 0x11
#define DFP_REV_MIN 0x06
#define FFEX_REV_MAJ 0x21
#define FFEX_REV_MIN 0x00
#define G25_REV_MAJ 0x12
#define G25_REV_MIN 0x22
#define G27_REV_MAJ 0x12
#define G27_REV_MIN 0x38

#define to_hid_device(pdev) container_of(pdev, struct hid_device, dev)

static void hid_lg4ff_set_range_dfp(struct hid_device *hid, u16 range);
static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range);
static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);

static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_range_show, lg4ff_range_store);

#if 0
struct g27_leds {
	char * name;
};

static struct g27_leds g27_leds[] = {
#else
static char * g27_leds[] = {
#endif
	"g27:green:rpm1",
	"g27:green:rpm2",
	"g27:yellow:rpm3",
	"g27:yellow:rpm4",
	"g27:red:rpm5"
	};

struct lg4ff_device_entry {
	__u16 range;
	__u16 min_range;
	__u16 max_range;
	__u8  led_state;
	struct led_classdev *led[5];
	void (*set_range)(struct hid_device *hid, u16 range);
};

static const signed short lg4ff_wheel_effects[] = {
	FF_CONSTANT,
	FF_AUTOCENTER,
	-1
};

struct lg4ff_wheel {
	const __u32 product_id;
	const signed short *ff_effects;
	const __u16 min_range;
	const __u16 max_range;
	void (*set_range)(struct hid_device *hid, u16 range);
};

static const struct lg4ff_wheel lg4ff_devices[] = {
	{USB_DEVICE_ID_LOGITECH_WHEEL,       lg4ff_wheel_effects, 40, 270, NULL},
	{USB_DEVICE_ID_LOGITECH_MOMO_WHEEL,  lg4ff_wheel_effects, 40, 270, NULL},
	{USB_DEVICE_ID_LOGITECH_DFP_WHEEL,   lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_dfp},
	{USB_DEVICE_ID_LOGITECH_G25_WHEEL,   lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_g25},
	{USB_DEVICE_ID_LOGITECH_DFGT_WHEEL,  lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_g25},
	{USB_DEVICE_ID_LOGITECH_G27_WHEEL,   lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_g25},
	{USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2, lg4ff_wheel_effects, 40, 270, NULL},
	{USB_DEVICE_ID_LOGITECH_WII_WHEEL,   lg4ff_wheel_effects, 40, 270, NULL}
};

struct lg4ff_native_cmd {
	const u8 cmd_num;	/* Number of commands to send */
	const u8 cmd[];
};

struct lg4ff_usb_revision {
	const u16 rev_maj;
	const u16 rev_min;
	const struct lg4ff_native_cmd *command;
};

static const struct lg4ff_native_cmd native_dfp = {
	1,
	{0xf8, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}
};

static const struct lg4ff_native_cmd native_dfgt = {
	2,
	{0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 1st command */
	 0xf8, 0x09, 0x03, 0x01, 0x00, 0x00, 0x00}	/* 2nd command */
};

static const struct lg4ff_native_cmd native_g25 = {
	1,
	{0xf8, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00}
};

static const struct lg4ff_native_cmd native_g27 = {
	2,
	{0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 1st command */
	 0xf8, 0x09, 0x04, 0x01, 0x00, 0x00, 0x00}	/* 2nd command */
};

static const struct lg4ff_usb_revision lg4ff_revs[] = {
	{DFGT_REV_MAJ, DFGT_REV_MIN, &native_dfgt},	/* Driving Force GT */
	{DFP_REV_MAJ,  DFP_REV_MIN,  &native_dfp},	/* Driving Force Pro */
	{G25_REV_MAJ,  G25_REV_MIN,  &native_g25},	/* G25 */
	{G27_REV_MAJ,  G27_REV_MIN,  &native_g27},	/* G27 */
};

static int hid_lg4ff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
{
	struct hid_device *hid = input_get_drvdata(dev);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	int x;

#define CLAMP(x) if (x < 0) x = 0; if (x > 0xff) x = 0xff

	switch (effect->type) {
	case FF_CONSTANT:
		x = effect->u.ramp.start_level + 0x80;	/* 0x80 is no force */
		CLAMP(x);
		report->field[0]->value[0] = 0x11;	/* Slot 1 */
		report->field[0]->value[1] = 0x08;
		report->field[0]->value[2] = x;
		report->field[0]->value[3] = 0x80;
		report->field[0]->value[4] = 0x00;
		report->field[0]->value[5] = 0x00;
		report->field[0]->value[6] = 0x00;

		usbhid_submit_report(hid, report, USB_DIR_OUT);
		break;
	}
	return 0;
}

/* Sends default autocentering command compatible with
 * all wheels except Formula Force EX */
static void hid_lg4ff_set_autocenter_default(struct input_dev *dev, u16 magnitude)
{
	struct hid_device *hid = input_get_drvdata(dev);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);

	report->field[0]->value[0] = 0xfe;
	report->field[0]->value[1] = 0x0d;
	report->field[0]->value[2] = magnitude >> 13;
	report->field[0]->value[3] = magnitude >> 13;
	report->field[0]->value[4] = magnitude >> 8;
	report->field[0]->value[5] = 0x00;
	report->field[0]->value[6] = 0x00;

	usbhid_submit_report(hid, report, USB_DIR_OUT);
}

/* Sends autocentering command compatible with Formula Force EX */
static void hid_lg4ff_set_autocenter_ffex(struct input_dev *dev, u16 magnitude)
{
	struct hid_device *hid = input_get_drvdata(dev);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	magnitude = magnitude * 90 / 65535;
	

	report->field[0]->value[0] = 0xfe;
	report->field[0]->value[1] = 0x03;
	report->field[0]->value[2] = magnitude >> 14;
	report->field[0]->value[3] = magnitude >> 14;
	report->field[0]->value[4] = magnitude;
	report->field[0]->value[5] = 0x00;
	report->field[0]->value[6] = 0x00;

	usbhid_submit_report(hid, report, USB_DIR_OUT);
}

/* Sends command to set range compatible with G25/G27/Driving Force GT */
static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range)
{
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	dbg_hid("G25/G27/DFGT: setting range to %u\n", range);

	report->field[0]->value[0] = 0xf8;
	report->field[0]->value[1] = 0x81;
	report->field[0]->value[2] = range & 0x00ff;
	report->field[0]->value[3] = (range & 0xff00) >> 8;
	report->field[0]->value[4] = 0x00;
	report->field[0]->value[5] = 0x00;
	report->field[0]->value[6] = 0x00;

	usbhid_submit_report(hid, report, USB_DIR_OUT);
}

/* Sends commands to set range compatible with Driving Force Pro wheel */
static void hid_lg4ff_set_range_dfp(struct hid_device *hid, __u16 range)
{
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	int start_left, start_right, full_range;
	dbg_hid("Driving Force Pro: setting range to %u\n", range);

	/* Prepare "coarse" limit command */
	report->field[0]->value[0] = 0xf8;
	report->field[0]->value[1] = 0x00; 	/* Set later */
	report->field[0]->value[2] = 0x00;
	report->field[0]->value[3] = 0x00;
	report->field[0]->value[4] = 0x00;
	report->field[0]->value[5] = 0x00;
	report->field[0]->value[6] = 0x00;

	if (range > 200) {
		report->field[0]->value[1] = 0x03;
		full_range = 900;
	} else {
		report->field[0]->value[1] = 0x02;
		full_range = 200;
	}
	usbhid_submit_report(hid, report, USB_DIR_OUT);

	/* Prepare "fine" limit command */
	report->field[0]->value[0] = 0x81;
	report->field[0]->value[1] = 0x0b;
	report->field[0]->value[2] = 0x00;
	report->field[0]->value[3] = 0x00;
	report->field[0]->value[4] = 0x00;
	report->field[0]->value[5] = 0x00;
	report->field[0]->value[6] = 0x00;

	if (range == 200 || range == 900) {	/* Do not apply any fine limit */
		usbhid_submit_report(hid, report, USB_DIR_OUT);
		return;
	}

	/* Construct fine limit command */
	start_left = (((full_range - range + 1) * 2047) / full_range);
	start_right = 0xfff - start_left;

	report->field[0]->value[2] = start_left >> 4;
	report->field[0]->value[3] = start_right >> 4;
	report->field[0]->value[4] = 0xff;
	report->field[0]->value[5] = (start_right & 0xe) << 4 | (start_left & 0xe);
	report->field[0]->value[6] = 0xff;

	usbhid_submit_report(hid, report, USB_DIR_OUT);
}

static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_native_cmd *cmd)
{
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	__u8 i, j;

	j = 0;
	while (j < 7*cmd->cmd_num) {
		for (i = 0; i < 7; i++)
			report->field[0]->value[i] = cmd->cmd[j++];

		usbhid_submit_report(hid, report, USB_DIR_OUT);
	}
}

/* Read current range and display it in terminal */
static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	struct hid_device *hid = to_hid_device(dev);
	struct lg_drv_data *drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
	struct lg4ff_device_entry *uninitialized_var(entry);
	size_t count;
	
	if (!drv_data) {
		hid_err(hid, "Device data not found.");
		return 0;
	}
	
	entry = (struct lg4ff_device_entry *)drv_data->dev_props;
	if (!entry) {
		hid_err(hid, "Device properties not found.");
		return 0;
	}

	count = scnprintf(buf, PAGE_SIZE, "%u\n", entry->range);
	return count;
}

/* Set range to user specified value, call appropriate function
 * according to the type of the wheel */
static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct hid_device *hid = to_hid_device(dev);
	struct lg_drv_data* drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
	struct lg4ff_device_entry *uninitialized_var(entry);
	__u16 range = simple_strtoul(buf, NULL, 10);

	if (!drv_data) {
		hid_err(hid, "Device data not found.");
		return count;
	}

	entry = (struct lg4ff_device_entry *)drv_data->dev_props; 
	if (!entry) {
		hid_err(hid, "Device properties not found.");
		return count;
	}

	if (range == 0)
		range = entry->max_range;

	/* Check if the wheel supports range setting
	 * and that the range is within limits for the wheel */
	if (entry->set_range != NULL && range >= entry->min_range && range <= entry->max_range) {
		entry->set_range(hid, range);
		entry->range = range;
	}

	return count;
}

static void lg4ff_set_leds(struct hid_device *hid, __u8 leds)
{
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);

	report->field[0]->value[0] = 0xf8;
	report->field[0]->value[1] = 0x12;
	report->field[0]->value[2] = leds;
	report->field[0]->value[3] = 0x00;
	report->field[0]->value[4] = 0x00;
	report->field[0]->value[5] = 0x00;
	report->field[0]->value[6] = 0x00;
	usbhid_submit_report(hid, report, USB_DIR_OUT);
}

static void lg4ff_led_set_brightness(struct led_classdev *led_cdev,
			enum led_brightness value)
{
	struct device *dev = led_cdev->dev->parent;
	struct hid_device *hid = to_hid_device(dev);
	struct lg_drv_data* drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
	struct lg4ff_device_entry *uninitialized_var(entry);
	int i, state = 0;

	if (!drv_data) {
		hid_err(hid, "Device data not found.");
		return;
	}

	entry = (struct lg4ff_device_entry *)drv_data->dev_props; 
	if (!entry) {
		hid_err(hid, "Device properties not found.");
		return;
	}

	for (i = 0; i < 5; i++) {
		if (led_cdev != entry->led[i])
			continue;
		state = (entry->led_state >> i) & 1;
		if (value == LED_OFF && state) {
			entry->led_state &= ~(1 << i);
			lg4ff_set_leds(hid, entry->led_state);
		} else if (value != LED_OFF && !state) {
			entry->led_state |= 1 << i;
			lg4ff_set_leds(hid, entry->led_state);
		}
		break;
	}
}

static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cdev)
{
	struct device *dev = led_cdev->dev->parent;
	struct hid_device *hid = to_hid_device(dev);
	struct lg_drv_data* drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
	struct lg4ff_device_entry *uninitialized_var(entry);
	int i, value=0;

	if (!drv_data) {
		hid_err(hid, "Device data not found.");
		return LED_OFF;
	}

	entry = (struct lg4ff_device_entry *)drv_data->dev_props; 
	if (!entry) {
		hid_err(hid, "Device properties not found.");
		return LED_OFF;
	}

	for (i = 0; i < 5; i++)
		if (led_cdev == entry->led[i]) {
			value = (entry->led_state >> i) & 1;
			break;
		}

	return value ? LED_FULL : LED_OFF;
}

int lg4ff_init(struct hid_device *hid)
{
	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct input_dev *dev = hidinput->input;
	struct hid_report *report;
	struct hid_field *field;
	struct lg_drv_data *drv_data;
	struct lg4ff_device_entry *entry;
	struct usb_device_descriptor *udesc;
	int error, i, j;
	__u16 bcdDevice, rev_maj, rev_min;
	struct led_classdev *led;
	struct device *dev2 = &dev->dev;

	/* Find the report to use */
	if (list_empty(report_list)) {
		hid_err(hid, "No output report found\n");
		return -1;
	}

	/* Check that the report looks ok */
	report = list_entry(report_list->next, struct hid_report, list);
	if (!report) {
		hid_err(hid, "NULL output report\n");
		return -1;
	}

	field = report->field[0];
	if (!field) {
		hid_err(hid, "NULL field\n");
		return -1;
	}

	/* Check what wheel has been connected */
	for (i = 0; i < ARRAY_SIZE(lg4ff_devices); i++) {
		if (hid->product == lg4ff_devices[i].product_id) {
			dbg_hid("Found compatible device, product ID %04X\n", lg4ff_devices[i].product_id);
			break;
		}
	}

	if (i == ARRAY_SIZE(lg4ff_devices)) {
		hid_err(hid, "Device is not supported by lg4ff driver. If you think it should be, consider reporting a bug to"
			     "LKML, Simon Wood <simon@mungewell.org> or Michal Maly <madcatxster@gmail.com>\n");
		return -1;
	}

	/* Attempt to switch wheel to native mode when applicable */
	udesc = &(hid_to_usb_dev(hid)->descriptor);
	if (!udesc) {
		hid_err(hid, "NULL USB device descriptor\n");
		return -1;
	}
	bcdDevice = le16_to_cpu(udesc->bcdDevice);
	rev_maj = bcdDevice >> 8;
	rev_min = bcdDevice & 0xff;

	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_WHEEL) {
		dbg_hid("Generic wheel detected, can it do native?\n");
		dbg_hid("USB revision: %2x.%02x\n", rev_maj, rev_min);

		for (j = 0; j < ARRAY_SIZE(lg4ff_revs); j++) {
			if (lg4ff_revs[j].rev_maj == rev_maj && lg4ff_revs[j].rev_min == rev_min) {
				hid_lg4ff_switch_native(hid, lg4ff_revs[j].command);
				hid_info(hid, "Switched to native mode\n");
			}
		}
	}

	/* Set supported force feedback capabilities */
	for (j = 0; lg4ff_devices[i].ff_effects[j] >= 0; j++)
		set_bit(lg4ff_devices[i].ff_effects[j], dev->ffbit);

	error = input_ff_create_memless(dev, NULL, hid_lg4ff_play);

	if (error)
		return error;

	/* Check if autocentering is available and
	 * set the centering force to zero by default */
	if (test_bit(FF_AUTOCENTER, dev->ffbit)) {
		if(rev_maj == FFEX_REV_MAJ && rev_min == FFEX_REV_MIN)	/* Formula Force EX expects different autocentering command */
			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_ffex;
		else
			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_default;

		dev->ff->set_autocenter(dev, 0);
	}

	/* Add the device to device_list */
	entry = kzalloc(sizeof(struct lg4ff_device_entry), GFP_KERNEL);
	if (!entry) {
		hid_err(hid, "Cannot add device, insufficient memory.\n");
		return -ENOMEM;
	}
	entry->min_range = lg4ff_devices[i].min_range;
	entry->max_range = lg4ff_devices[i].max_range;
	entry->set_range = lg4ff_devices[i].set_range;
	drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
	drv_data->dev_props = entry;

	/* Create sysfs interface for range */
	error = device_create_file(&hid->dev, &dev_attr_range);
	if (error)
		return error;
	dbg_hid("sysfs interface created for range\n");

	/* Set the maximum range to start with */
	entry->range = entry->max_range;
	if (entry->set_range != NULL)
		entry->set_range(hid, entry->range);

	/* register led subsystem - G27 only */
	//if (rev_maj == G27_REV_MAJ && rev_min == G27_REV_MIN) {
	if (rev_maj != G27_REV_MAJ || rev_min != G27_REV_MIN) {
		for (i = 0; i < 5; i++) {
			led = kzalloc(sizeof(struct led_classdev), GFP_KERNEL);
			if (!led) {
				dev_err(dev2, "can't allocate memory for LED %d\n", i);
				error = -ENOMEM;
				goto err;
			}
			led->name = (void *)(g27_leds[i]);
			led->brightness = 0;
			led->max_brightness = 1;
			led->brightness_get = lg4ff_led_get_brightness;
			led->brightness_set = lg4ff_led_set_brightness;

			entry->led[i] = led;
#if 1
			error = led_classdev_register(dev2, led);
			if (error) {
				dev_err(dev2, "can't register LED %d\n", i);
				goto err;
			}
#endif
		}

		dbg_hid("sysfs interface created for leds\n");

		/* Turn off all leds */
		entry->led_state = 0;
		lg4ff_set_leds(hid, 0);
	}

	hid_info(hid, "Force feedback for Logitech with led subsys\n");
	return 0;

err:
	/* Deregister LEDs (if any) */
	for (i = 0; i < 5; i++) {
		led = entry->led[i];
		entry->led[i] = NULL;
		if (!led)
			continue;
		led_classdev_unregister(led);
		kfree(led);
	}

	return error;
}

int lg4ff_deinit(struct hid_device *hid)
{
	struct lg_drv_data *drv_data = (struct lg_drv_data *)drv_data;
	struct lg4ff_device_entry *uninitialized_var(entry);
	struct led_classdev *led;
	int i;

	if (drv_data) {
		if (drv_data->dev_props) {
			entry = (struct lg4ff_device_entry *)drv_data->dev_props;
			if (entry) {
				/* Deregister LEDs (if any) */
				for (i = 0; i < 5; i++) {
					led = entry->led[i];
					entry->led[i] = NULL;
					if (!led)
						continue;
					led_classdev_unregister(led);
					kfree(led);
				}
			}

			kfree(drv_data->dev_props);
		}
	}

	device_remove_file(&hid->dev, &dev_attr_range);

	dbg_hid("Device successfully unregistered\n");
	return 0;
}
------=_20120313171155_37104--


