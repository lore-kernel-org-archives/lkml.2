Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2GDG6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:58:45 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:54002 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2GDG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:58:42 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnZKAKTo809V5qg+PGdsb2JhbABEihmtBRkBAQEBHgMWDSeCGAEBBAEnExwjBQsIAw44FCUKGhOIBgm6aRSQfGADkVeDX4VmjH8
X-IronPort-AV: E=Sophos;i="4.77,520,1336341600"; 
   d="scan'208";a="147494854"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 4 Jul 2012 08:59:02 +0200
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH 2/2 v3] HID: magicmouse: Implement Multi-touch Protocol B
 (MT-B)
Message-ID: <20120704065902.GA2822@polaris.bitmath.org>
References: <1341346951-10974-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341346951-10974-1-git-send-email-miletus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yufeng,

> The driver for Apple Magic Trackpad/Mouse currently uses
> Multi-touch Protocol A (MT-A) to report touch events and uses
> ABS_MT_TRACKING_ID to do finger tracking. The fact of the device
> being able to track individual finger makes it possible to
> report touch events using MT-B. This patch converts the driver
> to use MT-B as it is preferred to MT-A.
> 
> V3: Removed the single touch related logic.
> V2: Converting entirely to MT-B as Henrik Rydberg suggested.
> 
> Change-Id: I7eab3cd06f761e0e76f07540dcd38aa7ad7a048b
> Signed-off-by: Yufeng Shen <miletus@chromium.org>
> ---
>  drivers/hid/hid-magicmouse.c |   65 ++++++++++++++---------------------------
>  1 files changed, 22 insertions(+), 43 deletions(-)

Looking good, just one thing below.

> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index fd88f21..82836e1 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -16,6 +16,7 @@
>  
>  #include <linux/device.h>
>  #include <linux/hid.h>
> +#include <linux/input/mt.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/usb.h>
> @@ -68,15 +69,6 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
>  
>  #define SCROLL_ACCEL_DEFAULT 7
>  
> -/* Single touch emulation should only begin when no touches are currently down.
> - * This is true when single_touch_id is equal to NO_TOUCHES. If multiple touches
> - * are down and the touch providing for single touch emulation is lifted,
> - * single_touch_id is equal to SINGLE_TOUCH_UP. While single touch emulation is
> - * occurring, single_touch_id corresponds with the tracking id of the touch used.
> - */
> -#define NO_TOUCHES -1
> -#define SINGLE_TOUCH_UP -2
> -
>  /* Touch surface information. Dimension is in hundredths of a mm, min and max
>   * are in units. */
>  #define MOUSE_DIMENSION_X (float)9056
> @@ -125,7 +117,6 @@ struct magicmouse_sc {
>  		u8 size;
>  	} touches[16];
>  	int tracking_ids[16];
> -	int single_touch_id;
>  };
>  
>  static int magicmouse_firm_touch(struct magicmouse_sc *msc)
> @@ -264,16 +255,14 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>  		}
>  	}
>  
> -	if (down) {
> +	if (down)
>  		msc->ntouches++;
> -		if (msc->single_touch_id == NO_TOUCHES)
> -			msc->single_touch_id = id;
> -	} else if (msc->single_touch_id == id)
> -		msc->single_touch_id = SINGLE_TOUCH_UP;
> +
> +	input_mt_slot(input, id);
> +	input_mt_report_slot_state(input, MT_TOOL_FINGER, down);
>  
>  	/* Generate the input events for this touch. */
>  	if (down) {
> -		input_report_abs(input, ABS_MT_TRACKING_ID, id);
>  		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
>  		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
>  		input_report_abs(input, ABS_MT_ORIENTATION, -orientation);
> @@ -286,8 +275,6 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>  			else /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
>  				input_event(input, EV_MSC, MSC_RAW, tdata[8]);
>  		}
> -
> -		input_mt_sync(input);
>  	}
>  }
>  
> @@ -308,12 +295,6 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>  		for (ii = 0; ii < npoints; ii++)
>  			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
>  
> -		/* We don't need an MT sync here because trackpad emits a
> -		 * BTN_TOUCH event in a new frame when all touches are released.
> -		 */
> -		if (msc->ntouches == 0)
> -			msc->single_touch_id = NO_TOUCHES;
> -
>  		clicks = data[1];
>  
>  		/* The following bits provide a device specific timestamp. They
> @@ -331,9 +312,6 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>  		for (ii = 0; ii < npoints; ii++)
>  			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
>  
> -		if (msc->ntouches == 0)
> -			input_mt_sync(input);
> -
>  		/* When emulating three-button mode, it is important
>  		 * to have the current touch information before
>  		 * generating a click event.
> @@ -367,24 +345,17 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>  	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
>  		input_report_key(input, BTN_MOUSE, clicks & 1);
>  		input_report_key(input, BTN_TOUCH, msc->ntouches > 0);

This event is also emitted by the pointer emulation, and should thus
be removed here.

> -		input_report_key(input, BTN_TOOL_FINGER, msc->ntouches == 1);
> -		input_report_key(input, BTN_TOOL_DOUBLETAP, msc->ntouches == 2);
> -		input_report_key(input, BTN_TOOL_TRIPLETAP, msc->ntouches == 3);
> -		input_report_key(input, BTN_TOOL_QUADTAP, msc->ntouches == 4);
> -		if (msc->single_touch_id >= 0) {
> -			input_report_abs(input, ABS_X,
> -				msc->touches[msc->single_touch_id].x);
> -			input_report_abs(input, ABS_Y,
> -				msc->touches[msc->single_touch_id].y);
> -		}
> +		input_mt_report_pointer_emulation(input, true);
>  	}
>  
>  	input_sync(input);
>  	return 1;
>  }
>  
> -static void magicmouse_setup_input(struct input_dev *input, struct hid_device *hdev)
> +static int magicmouse_setup_input(struct input_dev *input, struct hid_device *hdev)
>  {
> +	int error;
> +
>  	__set_bit(EV_KEY, input->evbit);
>  
>  	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
> @@ -413,6 +384,7 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>  		__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
>  		__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
>  		__set_bit(BTN_TOOL_QUADTAP, input->keybit);
> +		__set_bit(BTN_TOOL_QUINTTAP, input->keybit);
>  		__set_bit(BTN_TOUCH, input->keybit);
>  		__set_bit(INPUT_PROP_POINTER, input->propbit);
>  		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
> @@ -421,7 +393,9 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>  
>  	__set_bit(EV_ABS, input->evbit);
>  
> -	input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
> +	error = input_mt_init_slots(input, 16);
> +	if (error)
> +		return error;
>  	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
>  			     4, 0);
>  	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,
> @@ -468,6 +442,8 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>  		__set_bit(EV_MSC, input->evbit);
>  		__set_bit(MSC_RAW, input->mscbit);
>  	}
> +
> +	return 0;
>  }
>  
>  static int magicmouse_input_mapping(struct hid_device *hdev,
> @@ -506,8 +482,6 @@ static int magicmouse_probe(struct hid_device *hdev,
>  	msc->quirks = id->driver_data;
>  	hid_set_drvdata(hdev, msc);
>  
> -	msc->single_touch_id = NO_TOUCHES;
> -
>  	ret = hid_parse(hdev);
>  	if (ret) {
>  		hid_err(hdev, "magicmouse hid parse failed\n");
> @@ -523,8 +497,13 @@ static int magicmouse_probe(struct hid_device *hdev,
>  	/* We do this after hid-input is done parsing reports so that
>  	 * hid-input uses the most natural button and axis IDs.
>  	 */
> -	if (msc->input)
> -		magicmouse_setup_input(msc->input, hdev);
> +	if (msc->input) {
> +		ret = magicmouse_setup_input(msc->input, hdev);
> +		if (ret) {
> +			hid_err(hdev, "magicmouse setup input failed (%d)\n", ret);
> +			goto err_stop_hw;
> +		}
> +	}
>  
>  	if (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
>  		report = hid_register_report(hdev, HID_INPUT_REPORT,
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
