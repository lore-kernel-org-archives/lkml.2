Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1DVMP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:15:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1DVMP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:15:56 -0400
Date: Fri, 22 Apr 2011 14:15:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-multitouch: merge hid-mosart into
 hid-multitouch
In-Reply-To: <1303465908-6322-1-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1104221415080.12035@pobox.suse.cz>
References: <1303465908-6322-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, Benjamin Tissoires wrote:

> This patch include MosArt devices into hid-multitouch.
> MosArt devices now support mt-protocol B.
> 
> We also need to introduce a new quirk for mosart devices to support
> their contactID.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> 
> Hi guys,
> 
> this is the integration of hid-mosart into hid-multitouch. Now, I'm just waiting
> for quanta and we are done with the integration of the generic multitouch driver.
> 
> This goes on top of the PenMount patch.

Thanks a lot for continuing of the unification efforts. Applied to my 
'multitouch' branch.

> 
> Cheers,
> Benjamin
> 
>  drivers/hid/Kconfig          |    7 +-
>  drivers/hid/Makefile         |    1 -
>  drivers/hid/hid-mosart.c     |  296 ------------------------------------------
>  drivers/hid/hid-multitouch.c |   20 +++-
>  4 files changed, 20 insertions(+), 304 deletions(-)
>  delete mode 100644 drivers/hid/hid-mosart.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 8058cf1..d2d4e5f 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -288,12 +288,6 @@ config HID_MICROSOFT
>  	---help---
>  	Support for Microsoft devices that are not fully compliant with HID standard.
>  
> -config HID_MOSART
> -	tristate "MosArt dual-touch panels"
> -	depends on USB_HID
> -	---help---
> -	Support for MosArt dual-touch panels.
> -
>  config HID_MONTEREY
>  	tristate "Monterey Genius KB29E keyboard" if EXPERT
>  	depends on USB_HID
> @@ -313,6 +307,7 @@ config HID_MULTITOUCH
>  	  - Cypress TrueTouch panels
>  	  - Hanvon dual touch panels
>  	  - IrTouch Infrared USB panels
> +	  - MosArt dual-touch panels
>  	  - PenMount dual touch panels
>  	  - Pixcir dual touch panels
>  	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 11c9f0b..f8cc4ea 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -45,7 +45,6 @@ obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
>  obj-$(CONFIG_HID_MAGICMOUSE)    += hid-magicmouse.o
>  obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
>  obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
> -obj-$(CONFIG_HID_MOSART)	+= hid-mosart.o
>  obj-$(CONFIG_HID_MULTITOUCH)	+= hid-multitouch.o
>  obj-$(CONFIG_HID_NTRIG)		+= hid-ntrig.o
>  obj-$(CONFIG_HID_ORTEK)		+= hid-ortek.o
> diff --git a/drivers/hid/hid-mosart.c b/drivers/hid/hid-mosart.c
> deleted file mode 100644
> index aed7ffe..0000000
> --- a/drivers/hid/hid-mosart.c
> +++ /dev/null
> @@ -1,296 +0,0 @@
> -/*
> - *  HID driver for the multitouch panel on the ASUS EeePC T91MT
> - *
> - *  Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
> - *  Copyright (c) 2010 Teemu Tuominen <teemu.tuominen@cybercom.com>
> - *
> - */
> -
> -/*
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of the GNU General Public License as published by the Free
> - * Software Foundation; either version 2 of the License, or (at your option)
> - * any later version.
> - */
> -
> -#include <linux/device.h>
> -#include <linux/hid.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/usb.h>
> -#include "usbhid/usbhid.h"
> -
> -MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
> -MODULE_DESCRIPTION("MosArt dual-touch panel");
> -MODULE_LICENSE("GPL");
> -
> -#include "hid-ids.h"
> -
> -struct mosart_data {
> -	__u16 x, y;
> -	__u8 id;
> -	bool valid;		/* valid finger data, or just placeholder? */
> -	bool first;		/* is this the first finger in this frame? */
> -	bool activity_now;	/* at least one active finger in this frame? */
> -	bool activity;		/* at least one active finger previously? */
> -};
> -
> -static int mosart_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> -		struct hid_field *field, struct hid_usage *usage,
> -		unsigned long **bit, int *max)
> -{
> -	switch (usage->hid & HID_USAGE_PAGE) {
> -
> -	case HID_UP_GENDESK:
> -		switch (usage->hid) {
> -		case HID_GD_X:
> -			hid_map_usage(hi, usage, bit, max,
> -					EV_ABS, ABS_MT_POSITION_X);
> -			/* touchscreen emulation */
> -			input_set_abs_params(hi->input, ABS_X,
> -						field->logical_minimum,
> -						field->logical_maximum, 0, 0);
> -			return 1;
> -		case HID_GD_Y:
> -			hid_map_usage(hi, usage, bit, max,
> -					EV_ABS, ABS_MT_POSITION_Y);
> -			/* touchscreen emulation */
> -			input_set_abs_params(hi->input, ABS_Y,
> -						field->logical_minimum,
> -						field->logical_maximum, 0, 0);
> -			return 1;
> -		}
> -		return 0;
> -
> -	case HID_UP_DIGITIZER:
> -		switch (usage->hid) {
> -		case HID_DG_CONFIDENCE:
> -		case HID_DG_TIPSWITCH:
> -		case HID_DG_INPUTMODE:
> -		case HID_DG_DEVICEINDEX:
> -		case HID_DG_CONTACTCOUNT:
> -		case HID_DG_CONTACTMAX:
> -		case HID_DG_TIPPRESSURE:
> -		case HID_DG_WIDTH:
> -		case HID_DG_HEIGHT:
> -			return -1;
> -		case HID_DG_INRANGE:
> -			/* touchscreen emulation */
> -			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
> -			return 1;
> -
> -		case HID_DG_CONTACTID:
> -			hid_map_usage(hi, usage, bit, max,
> -					EV_ABS, ABS_MT_TRACKING_ID);
> -			return 1;
> -
> -		}
> -		return 0;
> -
> -	case 0xff000000:
> -		/* ignore HID features */
> -		return -1;
> -
> -	case HID_UP_BUTTON:
> -		/* ignore buttons */
> -		return -1;
> -	}
> -
> -	return 0;
> -}
> -
> -static int mosart_input_mapped(struct hid_device *hdev, struct hid_input *hi,
> -		struct hid_field *field, struct hid_usage *usage,
> -		unsigned long **bit, int *max)
> -{
> -	if (usage->type == EV_KEY || usage->type == EV_ABS)
> -		clear_bit(usage->code, *bit);
> -
> -	return 0;
> -}
> -
> -/*
> - * this function is called when a whole finger has been parsed,
> - * so that it can decide what to send to the input layer.
> - */
> -static void mosart_filter_event(struct mosart_data *td, struct input_dev *input)
> -{
> -	td->first = !td->first; /* touchscreen emulation */
> -
> -	if (!td->valid) {
> -		/*
> -		 * touchscreen emulation: if no finger in this frame is valid
> -		 * and there previously was finger activity, this is a release
> -		 */ 
> -		if (!td->first && !td->activity_now && td->activity) {
> -			input_event(input, EV_KEY, BTN_TOUCH, 0);
> -			td->activity = false;
> -		}
> -		return;
> -	}
> -
> -	input_event(input, EV_ABS, ABS_MT_TRACKING_ID, td->id);
> -	input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x);
> -	input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y);
> -
> -	input_mt_sync(input);
> -	td->valid = false;
> -
> -	/* touchscreen emulation: if first active finger in this frame... */
> -	if (!td->activity_now) {
> -		/* if there was no previous activity, emit touch event */
> -		if (!td->activity) {
> -			input_event(input, EV_KEY, BTN_TOUCH, 1);
> -			td->activity = true;
> -		}
> -		td->activity_now = true;
> -		/* and in any case this is our preferred finger */
> -		input_event(input, EV_ABS, ABS_X, td->x);
> -		input_event(input, EV_ABS, ABS_Y, td->y);
> -	}
> -}
> -
> -
> -static int mosart_event(struct hid_device *hid, struct hid_field *field,
> -				struct hid_usage *usage, __s32 value)
> -{
> -	struct mosart_data *td = hid_get_drvdata(hid);
> -
> -	if (hid->claimed & HID_CLAIMED_INPUT) {
> -		struct input_dev *input = field->hidinput->input;
> -		switch (usage->hid) {
> -		case HID_DG_INRANGE:
> -			td->valid = !!value;
> -			break;
> -		case HID_GD_X:
> -			td->x = value;
> -			break;
> -		case HID_GD_Y:
> -			td->y = value;
> -			mosart_filter_event(td, input);
> -			break;
> -		case HID_DG_CONTACTID:
> -			td->id = value;
> -			break;
> -		case HID_DG_CONTACTCOUNT:
> -			/* touch emulation: this is the last field in a frame */
> -			td->first = false;
> -			td->activity_now = false;
> -			break;
> -		case HID_DG_CONFIDENCE:
> -		case HID_DG_TIPSWITCH:
> -			/* avoid interference from generic hidinput handling */
> -			break;
> -
> -		default:
> -			/* fallback to the generic hidinput handling */
> -			return 0;
> -		}
> -	}
> -
> -	/* we have handled the hidinput part, now remains hiddev */
> -	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
> -		hid->hiddev_hid_event(hid, field, usage, value);
> -
> -	return 1;
> -}
> -
> -static int mosart_probe(struct hid_device *hdev, const struct hid_device_id *id)
> -{
> -	int ret;
> -	struct mosart_data *td;
> -
> -
> -	td = kmalloc(sizeof(struct mosart_data), GFP_KERNEL);
> -	if (!td) {
> -		hid_err(hdev, "cannot allocate MosArt data\n");
> -		return -ENOMEM;
> -	}
> -	td->valid = false;
> -	td->activity = false;
> -	td->activity_now = false;
> -	td->first = false;
> -	hid_set_drvdata(hdev, td);
> -
> -	/* currently, it's better to have one evdev device only */
> -#if 0
> -	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
> -#endif
> -
> -	ret = hid_parse(hdev);
> -	if (ret == 0)
> -		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> -
> -	if (ret == 0) {
> -		struct hid_report_enum *re = hdev->report_enum
> -						+ HID_FEATURE_REPORT;
> -		struct hid_report *r = re->report_id_hash[7];
> -
> -		r->field[0]->value[0] = 0x02;
> -		usbhid_submit_report(hdev, r, USB_DIR_OUT);
> -	} else 
> -		kfree(td);
> -
> -	return ret;
> -}
> -
> -#ifdef CONFIG_PM
> -static int mosart_reset_resume(struct hid_device *hdev)
> -{
> -	struct hid_report_enum *re = hdev->report_enum
> -						+ HID_FEATURE_REPORT;
> -	struct hid_report *r = re->report_id_hash[7];
> -
> -	r->field[0]->value[0] = 0x02;
> -	usbhid_submit_report(hdev, r, USB_DIR_OUT);
> -	return 0;
> -}
> -#endif
> -
> -static void mosart_remove(struct hid_device *hdev)
> -{
> -	hid_hw_stop(hdev);
> -	kfree(hid_get_drvdata(hdev));
> -	hid_set_drvdata(hdev, NULL);
> -}
> -
> -static const struct hid_device_id mosart_devices[] = {
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(hid, mosart_devices);
> -
> -static const struct hid_usage_id mosart_grabbed_usages[] = {
> -	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
> -	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1}
> -};
> -
> -static struct hid_driver mosart_driver = {
> -	.name = "mosart",
> -	.id_table = mosart_devices,
> -	.probe = mosart_probe,
> -	.remove = mosart_remove,
> -	.input_mapping = mosart_input_mapping,
> -	.input_mapped = mosart_input_mapped,
> -	.usage_table = mosart_grabbed_usages,
> -	.event = mosart_event,
> -#ifdef CONFIG_PM
> -	.reset_resume = mosart_reset_resume,
> -#endif
> -};
> -
> -static int __init mosart_init(void)
> -{
> -	return hid_register_driver(&mosart_driver);
> -}
> -
> -static void __exit mosart_exit(void)
> -{
> -	hid_unregister_driver(&mosart_driver);
> -}
> -
> -module_init(mosart_init);
> -module_exit(mosart_exit);
> -
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 51b5d27..bf46804 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -50,6 +50,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_VALID_IS_INRANGE	(1 << 4)
>  #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 5)
>  #define MT_QUIRK_EGALAX_XYZ_FIXUP	(1 << 6)
> +#define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 7)
>  
>  struct mt_slot {
>  	__s32 x, y, p, w, h;
> @@ -90,6 +91,7 @@ struct mt_class {
>  #define MT_CLS_STANTUM				6
>  #define MT_CLS_3M				7
>  #define MT_CLS_CONFIDENCE			8
> +#define MT_CLS_CONFIDENCE_MINUS_ONE		9
>  
>  #define MT_DEFAULT_MAXCONTACT	10
>  
> @@ -140,7 +142,9 @@ struct mt_class mt_classes[] = {
>  		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
>  			MT_QUIRK_CYPRESS,
>  		.maxcontacts = 10 },
> -
> +	{ .name = MT_CLS_CONFIDENCE_MINUS_ONE,
> +		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
> +			MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE },
>  	{ .name = MT_CLS_EGALAX,
>  		.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
>  			MT_QUIRK_VALID_IS_INRANGE |
> @@ -325,6 +329,9 @@ static int mt_compute_slot(struct mt_device *td)
>  	if (quirks & MT_QUIRK_SLOT_IS_CONTACTNUMBER)
>  		return td->num_received;
>  
> +	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE)
> +		return td->curdata.contactid - 1;
> +
>  	return find_slot_from_contactid(td);
>  }
>  
> @@ -587,6 +594,17 @@ static const struct hid_device_id mt_devices[] = {
>  		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
>  			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
>  
> +	/* MosArt panels */
> +	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> +		HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
> +			USB_DEVICE_ID_ASUS_T91MT)},
> +	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> +		HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
> +			USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
> +	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> +		HID_USB_DEVICE(USB_VENDOR_ID_TURBOX,
> +			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
> +
>  	/* PenMount panels */
>  	{ .driver_data = MT_CLS_CONFIDENCE,
>  		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
> -- 
> 1.7.4.2
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
