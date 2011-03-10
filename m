Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1CJPuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:50:01 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:42495 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158Ab1CJPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:49:59 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Mar 2011 16:52:25 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] hid-multitouch: migrate 3M PCT touch screens to
 hid-multitouch
Message-ID: <20110310155225.GA23034@polaris.bitmath.org>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299686450-5475-5-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299686450-5475-5-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Pxi7I-00032d-Ch.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Pxi7I-00032d-Ch a1e6d881b246c13a92cb0fe398faea46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 02a77f9..0b92dfc 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -5,6 +5,11 @@
>   *  Copyright (c) 2010-2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>   *  Copyright (c) 2010-2011 Ecole Nationale de l'Aviation Civile, France
>   *
> + *  based on hid-3m-pct.c copyrighted as follows:
> + *    Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
> + *    Copyright (c) 2010      Henrik Rydberg <rydberg@euromail.se>
> + *    Copyright (c) 2010      Canonical, Ltd.
> + *
>   */
>  
>  /*
> @@ -62,6 +67,8 @@ struct mt_class {
>  	__s32 name;	/* MT_CLS */
>  	__s32 quirks;
>  	__s32 sn_move;	/* Signal/noise ratio for move events */
> +	__s32 sn_width;	/* Signal/noise ratio for width events */
> +	__s32 sn_height;	/* Signal/noise ratio for height events */
>  	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
>  	__u8 maxcontacts;
>  };
> @@ -72,6 +79,7 @@ struct mt_class {
>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	3
>  #define MT_CLS_CYPRESS				4
>  #define MT_CLS_STANTUM				5
> +#define MT_CLS_3M				6
>  
>  /*
>   * these device-dependent functions determine what slot corresponds
> @@ -123,6 +131,12 @@ struct mt_class mt_classes[] = {
>  		.maxcontacts = 10 },
>  	{ .name = MT_CLS_STANTUM,
>  		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },

I realize several of the entries are missing maxcontacts now, so all
patches needs to be checked...

> +	{ .name = MT_CLS_3M,
> +		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
> +			MT_QUIRK_SLOT_IS_CONTACTID,
> +		.sn_move = 2048,
> +		.sn_width = 128,
> +		.sn_height = 128 },

And this one does too
>  
>  	{ }
>  };
> @@ -206,11 +220,15 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		case HID_DG_WIDTH:
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_TOUCH_MAJOR);
> +			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
> +				cls->sn_width);
>  			td->last_slot_field = usage->hid;
>  			return 1;
>  		case HID_DG_HEIGHT:
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_TOUCH_MINOR);
> +			set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
> +				cls->sn_height);
>  			field->logical_maximum = 1;
>  			field->logical_minimum = 0;

These limits are not right - I doubt they are for any device.

>  			set_abs(hi->input, ABS_MT_ORIENTATION, field, 0);
> @@ -307,11 +325,18 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>  		input_mt_report_slot_state(input, MT_TOOL_FINGER,
>  			s->touch_state);
>  		if (s->touch_state) {
> +			/* this finger is on the screen */
> +			int wide = (s->w > s->h);
> +			/* divided by two to match visual scale of touch */
> +			int major = max(s->w, s->h) >> 1;
> +			int minor = min(s->w, s->h) >> 1;
> +
>  			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
>  			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
> +			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>  			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
> -			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->w);
> -			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, s->h);
> +			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> +			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
>  		}
>  		s->seen_in_this_frame = false;
>  
> @@ -481,6 +506,14 @@ static void mt_remove(struct hid_device *hdev)
>  
>  static const struct hid_device_id mt_devices[] = {
>  
> +	/* 3M panels */
> +	{ .driver_data = MT_CLS_3M,
> +		HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +			USB_DEVICE_ID_3M1968) },
> +	{ .driver_data = MT_CLS_3M,
> +		HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +			USB_DEVICE_ID_3M2256) },
> +
>  	/* Cando panels */
>  	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
>  		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
> -- 
> 1.7.4
> 

Also, this line needs to be added in case no feature reports are sent:

@@ -481,6 +481,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return -ENOMEM;
 	}
 	td->mtclass = mtclass;
+	td->maxcontacts = mtclass->maxcontacts;
 	td->inputmode = -1;
 	hid_set_drvdata(hdev, td);
 
Thanks,
Henrik
