Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0ENLzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:55:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab0ENLzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:55:13 -0400
Date: Fri, 14 May 2010 13:55:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Don Prince <dhprince.devel@yahoo.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc5] HID: Zydacron Remote Control HID Driver
In-Reply-To: <4BEAD150.5080305@yahoo.co.uk>
Message-ID: <alpine.LNX.2.00.1005141353020.28092@pobox.suse.cz>
References: <4BEAD150.5080305@yahoo.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Don Prince wrote:

> diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> --- a/drivers/hid/hid-ids.h	2010-04-22 18:52:46.455385039 +0100
> +++ b/drivers/hid/hid-ids.h	2010-05-12 11:38:12.771567630 +0100
> @@ -474,6 +474,9 @@
>  
>  #define USB_VENDOR_ID_ZEROPLUS		0x0c12
>  
> +#define USB_VENDOR_ID_ZYDACRON	0x13EC
> +#define USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL	0x0006
> +
>  #define USB_VENDOR_ID_KYE		0x0458
>  #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
>  #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
> diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
> --- a/drivers/hid/hid-zydacron.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/hid/hid-zydacron.c	2010-05-12 15:29:34.276028189 +0100
> @@ -0,0 +1,291 @@
> +/*
> +*  HID driver for zydacron remote control
> +*
> +*  Copyright (c) 2010 Don Prince

Thanks for the driver!

> +*/
> +
> +/*
> +* This program is free software; you can redistribute it and/or modify it
> +* under the terms of the GNU General Public License as published by the Free
> +* Software Foundation; either version 2 of the License, or (at your option)
> +* any later version.
> +*/
> +
> +#include <linux/device.h>
> +#include <linux/hid.h>
> +#include <linux/module.h>
> +
> +#include "hid-ids.h"
> +
> +/* button layout
> +
> + top:		button id
> + bottom:	button action
> +
> +	Power/Sleep	TV		radio		teletext
> +	default		KEY_TV		KEY_RADIO	KEY_TEXT
> +
> +	music		photo		video		DVD
> +	KEY_AUDIO	KEY_AUX		KEY_VIDEO	KEY_DVD
> +
> +				UP
> +				default
> +
> +			LEFT		RIGHT
> +			default		default
> +
> +				DOWN
> +				default
> +
> +	back			ok			menu
> +	default			default			KEY_MENU
> +
> +	previous		play/pause		next
> +	default			default			default
> +
> +	rewind			stop			forward
> +	default			default			default
> +
> +	volume +					channel +
> +	default						default
> +
> +				home
> +				KEY_PVR
> +
> +	volume -					channel -
> +	default						default
> +
> +	mute			record			mouse toggle
> +	default			default			KEY_MODE
> +
> +	1			2			3
> +	default			default			default
> +
> +	4			5			6
> +	default			default			default
> +
> +	7			8			9
> +	default			default			default
> +
> +	fullscreen		0			info
> +	KEY_SCREEN		default			KEY_INFO

Is this really so special that it is needed at all?

> +*/
> +
> +struct zc_device {
> +	struct input_dev	*input_ep81;
> +	unsigned short		last_key[4];
> +};
> +
> +
> +/*
> +* Zydacron remote control has an invalid HID report descriptor,
> +* that needs fixing before we can parse it.
> +*/
> +static void zc_report_fixup(struct hid_device *hdev, __u8 *rdesc,
> +	unsigned int rsize)
> +{
> +	if (rsize >= 253 &&
> +		rdesc[0x96] == 0xbc && rdesc[0x97] == 0xff &&
> +		rdesc[0xca] == 0xbc && rdesc[0xcb] == 0xff &&
> +		rdesc[0xe1] == 0xbc && rdesc[0xe2] == 0xff) {
> +			dev_info(&hdev->dev,
> +				"fixing up zydacron remote control report "
> +				"descriptor\n");
> +			rdesc[0x96] = rdesc[0xca] = rdesc[0xe1] = 0x0c;
> +			rdesc[0x97] = rdesc[0xcb] = rdesc[0xe2] = 0x00;
> +		}
> +}
> +
> +#define zc_map_key_clear(c) \
> +	hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
> +
> +static int zc_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> +	struct hid_field *field, struct hid_usage *usage,
> +	unsigned long **bit, int *max)
> +{
> +	int i;
> +	struct zc_device *zc = (struct zc_device *)hid_get_drvdata(hdev);

The cast is not needed.

> +	zc->input_ep81 = hi->input;
> +
> +	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
> +		return 0;
> +
> +	dbg_hid("zynacron input mapping event [0x%x]\n",
> +		usage->hid & HID_USAGE);
> +
> +	switch (usage->hid & HID_USAGE) {
> +	/* report 2 */
> +	case 0x10:
> +		zc_map_key_clear(KEY_MODE);
> +		break;
> +	case 0x30:
> +		zc_map_key_clear(KEY_SCREEN);
> +		break;
> +	case 0x70:
> +		zc_map_key_clear(KEY_INFO);
> +		break;
> +	/* report 3 */
> +	case 0x04:
> +		zc_map_key_clear(KEY_RADIO);
> +		break;
> +	/* report 4 */
> +	case 0x0d:
> +		zc_map_key_clear(KEY_PVR);
> +		break;
> +	case 0x25:
> +		zc_map_key_clear(KEY_TV);
> +		break;
> +	case 0x47:
> +		zc_map_key_clear(KEY_AUDIO);
> +		break;
> +	case 0x49:
> +		zc_map_key_clear(KEY_AUX);
> +		break;
> +	case 0x4a:
> +		zc_map_key_clear(KEY_VIDEO);
> +		break;
> +	case 0x48:
> +		zc_map_key_clear(KEY_DVD);
> +		break;
> +	case 0x24:
> +		zc_map_key_clear(KEY_MENU);
> +		break;
> +	case 0x32:
> +		zc_map_key_clear(KEY_TEXT);
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	for (i = 0; i < 4; i++)
> +		zc->last_key[i] = 0;
> +
> +	return 1;
> +}
> +
> +static int zc_raw_event(struct hid_device *hdev, struct hid_report *report,
> +	 u8 *data, int size)
> +{
> +	struct zc_device *zc = (struct zc_device *)hid_get_drvdata(hdev);
> +	int ret = 0;
> +	unsigned key;
> +	unsigned short index;
> +
> +	if (report->id == data[0]) {
> +
> +		/* break keys */
> +		for (index = 0; index < 4; index++) {
> +			key = zc->last_key[index];
> +			if (key) {
> +				input_event(zc->input_ep81, EV_KEY, key, 0);
> +				zc->last_key[index] = 0;
> +			}
> +		}
> +
> +		key = 0;
> +		switch (report->id) {
> +		case 0x02:
> +		case 0x03:
> +			switch (data[1]) {
> +			case 0x10:
> +				key = KEY_MODE;
> +				index = 0;
> +				break;
> +			case 0x30:
> +				key = KEY_SCREEN;
> +				index = 1;
> +				break;
> +			case 0x70:
> +				key = KEY_INFO;
> +				index = 2;
> +				break;
> +			case 0x04:
> +				key = KEY_RADIO;
> +				index = 3;
> +				break;
> +			}
> +
> +			if (key) {
> +				input_event(zc->input_ep81, EV_KEY, key, 1);
> +				zc->last_key[index] = key;
> +			}
> +
> +			ret = 1;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
> +{
> +	int ret;
> +	struct zc_device *zc;
> +
> +	zc = kzalloc(sizeof(*zc), GFP_KERNEL);
> +	if (zc == NULL) {
> +		dev_err(&hdev->dev, "zydacron: can't alloc descriptor\n");
> +		return -ENOMEM;
> +	}
> +
> +	hid_set_drvdata(hdev, zc);
> +
> +	ret = hid_parse(hdev);
> +	if (ret) {
> +		dev_err(&hdev->dev, "zydacron: parse failed\n");
> +		goto err_free;
> +	}
> +
> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> +	if (ret) {
> +		dev_err(&hdev->dev, "zydacron: hw start failed\n");
> +		goto err_free;
> +	}
> +
> +	return 0;
> +err_free:
> +	kfree(zc);
> +
> +	return ret;
> +}
> +
> +static void zc_remove(struct hid_device *hdev)
> +{
> +	struct zc_device *zc = (struct zc_device *)hid_get_drvdata(hdev);
> +
> +	hid_hw_stop(hdev);
> +
> +	if (NULL != zc)
> +		kfree(zc);
> +}
> +
> +static const struct hid_device_id zc_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, zc_devices);
> +
> +static struct hid_driver zc_driver = {
> +	.name = "zydacron",
> +	.id_table = zc_devices,
> +	.report_fixup = zc_report_fixup,
> +	.input_mapping = zc_input_mapping,
> +	.raw_event = zc_raw_event,
> +	.probe = zc_probe,
> +	.remove = zc_remove,
> +};
> +
> +static int __init zc_init(void)
> +{
> +	return hid_register_driver(&zc_driver);
> +}
> +
> +static void __exit zc_exit(void)
> +{
> +	hid_unregister_driver(&zc_driver);
> +}
> +
> +module_init(zc_init);
> +module_exit(zc_exit);
> +MODULE_LICENSE("GPL");
> diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> --- a/drivers/hid/Kconfig	2010-03-09 13:53:05.930183131 +0000
> +++ b/drivers/hid/Kconfig	2010-05-12 11:38:12.773567293 +0100
> @@ -372,6 +372,13 @@ config ZEROPLUS_FF
>  	  Say Y here if you have a Zeroplus based game controller and want
>  	  to have force feedback support for it.
>  
> +config HID_ZYDACRON
> +	tristate "Zydacron remote control support" if EMBEDDED
> +	depends on USB_HID
> +	default !EMBEDDED
> +	---help---
> +	Support for Zydacron remote control.
> +
>  endmenu
>  
>  endif # HID_SUPPORT
> diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/Makefile b/drivers/hid/Makefile
> --- a/drivers/hid/Makefile	2010-03-09 13:53:06.036326844 +0000
> +++ b/drivers/hid/Makefile	2010-05-12 11:38:12.774443286 +0100
> @@ -54,6 +54,7 @@ obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tm
>  obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
>  obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
>  obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
> +obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
>  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
>  
>  obj-$(CONFIG_USB_HID)		+= usbhid/

Otherwise the driver looks OK to me. Could you please resubmit with the 
above comments addressed, so that I could merge it?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
