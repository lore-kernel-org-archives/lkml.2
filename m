Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2CMVI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:08:28 -0400
Received: from host171.canaca.com ([67.55.55.225]:36746 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2CMVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:08:25 -0400
Message-ID: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
Date: Tue, 13 Mar 2012 17:08:21 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: simon@mungewell.org, "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael Bauer" <michael@m-bauer.org>,
        "Michal Maly" <madcatxster@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20120313170821_49217"
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20120313170821_49217
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> Not really, it's rather simple to use and as Mark said, it's a proper
infrastructure to use here.
> We already have HID drivers which are using this -- you can look at
PicoLCD or Wiimote drivers and you'll see that it's indeed fairly
simple.

So _you_ say.... I'm getting an Oops when device attempts to init the LED
subsytem. :-(
--
Mar 13 12:54:56 ubuntu kernel: [  458.639674] Call Trace:
Mar 13 12:54:56 ubuntu kernel: [  458.641143]  [<c13498ed>] ?
device_create+0x2d/0x30
Mar 13 12:54:56 ubuntu kernel: [  458.641245]  [<c1439119>]
led_classdev_register+0x99/0xf0
Mar 13 12:54:56 ubuntu kernel: [  458.641306]  [<e0977311>]
lg4ff_init+0x2a1/0x570 [hid_logitech]
Mar 13 12:54:56 ubuntu kernel: [  458.641313]  [<e0975427>]
lg_probe+0x147/0x2c0 [hid_logitech]
--

Code snipet below (full file attached):
--
int lg4ff_init(struct hid_device *hid)
{
    struct hid_input *hidinput = list_entry(hid->inputs.next, struct
hid_input, list);
    struct list_head *report_list =
&hid->report_enum[HID_OUTPUT_REPORT].report_list;
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
--
    /* register led subsystem - G27 only */
    //if (rev_maj == G27_REV_MAJ && rev_min == G27_REV_MIN) {
    if (rev_maj != G27_REV_MAJ || rev_min != G27_REV_MIN) {
        for (i = 0; i < 5; i++) {
            led = kzalloc(sizeof(struct led_classdev), GFP_KERNEL); if
(!led) {
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
            error = led_classdev_register(dev2, entry->led[i]);
            if (error) {
                dev_err(dev2, "can't register LED %d\n", i);
                goto err;
            }
#endif
        }

        dbg_hid("sysfs interface created for leds\n");
--

Any suggestions as to what I'm doing wrong?
Simon


------=_20120313170821_49217
Content-Type: text/x-csrc; name="hid-lgff.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="hid-lgff.c"

/*
 * Force feedback support for hid-compliant for some of the devices from
 * Logitech, namely:
 * - WingMan Cordless RumblePad
 * - WingMan Force 3D
 *
 *  Copyright (c) 2002-2004 Johann Deneux
 *  Copyright (c) 2006 Anssi Hannula <anssi.hannula@gmail.com>
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
 *
 * Should you need to contact me, the author, you can do so by
 * e-mail - mail your message to <johann.deneux@it.uu.se>
 */

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/input.h>
#include <linux/usb.h>
#include <linux/hid.h>

#include "usbhid/usbhid.h"
#include "hid-lg.h"

struct dev_type {
	u16 idVendor;
	u16 idProduct;
	const signed short *ff;
};

static const signed short ff_rumble[] = {
	FF_RUMBLE,
	-1
};

static const signed short ff_joystick[] = {
	FF_CONSTANT,
	-1
};

static const signed short ff_joystick_ac[] = {
	FF_CONSTANT,
	FF_AUTOCENTER,
	-1
};

static const struct dev_type devices[] = {
	{ 0x046d, 0xc211, ff_rumble },
	{ 0x046d, 0xc219, ff_rumble },
	{ 0x046d, 0xc283, ff_joystick },
	{ 0x046d, 0xc286, ff_joystick_ac },
	{ 0x046d, 0xc287, ff_joystick_ac },
	{ 0x046d, 0xc293, ff_joystick },
	{ 0x046d, 0xc295, ff_joystick },
};

static int hid_lgff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
{
	struct hid_device *hid = input_get_drvdata(dev);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	int x, y;
	unsigned int left, right;

#define CLAMP(x) if (x < 0) x = 0; if (x > 0xff) x = 0xff

	switch (effect->type) {
	case FF_CONSTANT:
		x = effect->u.ramp.start_level + 0x7f;	/* 0x7f is center */
		y = effect->u.ramp.end_level + 0x7f;
		CLAMP(x);
		CLAMP(y);
		report->field[0]->value[0] = 0x51;
		report->field[0]->value[1] = 0x08;
		report->field[0]->value[2] = x;
		report->field[0]->value[3] = y;
		dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
		usbhid_submit_report(hid, report, USB_DIR_OUT);
		break;

	case FF_RUMBLE:
		right = effect->u.rumble.strong_magnitude;
		left = effect->u.rumble.weak_magnitude;
		right = right * 0xff / 0xffff;
		left = left * 0xff / 0xffff;
		CLAMP(left);
		CLAMP(right);
		report->field[0]->value[0] = 0x42;
		report->field[0]->value[1] = 0x00;
		report->field[0]->value[2] = left;
		report->field[0]->value[3] = right;
		dbg_hid("(left, right)=(%04x, %04x)\n", left, right);
		usbhid_submit_report(hid, report, USB_DIR_OUT);
		break;
	}
	return 0;
}

static void hid_lgff_set_autocenter(struct input_dev *dev, u16 magnitude)
{
	struct hid_device *hid = input_get_drvdata(dev);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
	__s32 *value = report->field[0]->value;
	magnitude = (magnitude >> 12) & 0xf;
	*value++ = 0xfe;
	*value++ = 0x0d;
	*value++ = magnitude;   /* clockwise strength */
	*value++ = magnitude;   /* counter-clockwise strength */
	*value++ = 0x80;
	*value++ = 0x00;
	*value = 0x00;
	usbhid_submit_report(hid, report, USB_DIR_OUT);
}

int lgff_init(struct hid_device* hid)
{
	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
	struct input_dev *dev = hidinput->input;
	struct hid_report *report;
	struct hid_field *field;
	const signed short *ff_bits = ff_joystick;
	int error;
	int i;

	/* Find the report to use */
	if (list_empty(report_list)) {
		hid_err(hid, "No output report found\n");
		return -1;
	}

	/* Check that the report looks ok */
	report = list_entry(report_list->next, struct hid_report, list);
	field = report->field[0];
	if (!field) {
		hid_err(hid, "NULL field\n");
		return -1;
	}

	for (i = 0; i < ARRAY_SIZE(devices); i++) {
		if (dev->id.vendor == devices[i].idVendor &&
		    dev->id.product == devices[i].idProduct) {
			ff_bits = devices[i].ff;
			break;
		}
	}

	for (i = 0; ff_bits[i] >= 0; i++)
		set_bit(ff_bits[i], dev->ffbit);

	error = input_ff_create_memless(dev, NULL, hid_lgff_play);
	if (error)
		return error;

	if ( test_bit(FF_AUTOCENTER, dev->ffbit) )
		dev->ff->set_autocenter = hid_lgff_set_autocenter;

	pr_info("Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>\n");

	return 0;
}
------=_20120313170821_49217--


