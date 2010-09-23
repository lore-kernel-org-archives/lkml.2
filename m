Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0IWNUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:20:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48849 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab0IWNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:20:46 -0400
Subject: Re: [PATCH v2] HID: magicmouse: Use hid-input parsing rather than
 bypassing it
From: Chase Douglas <chase.douglas@canonical.com>
To: Michael Poole <mdpoole@troilus.org>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1285244139.22958.16.camel@graviton>
References: <1285244139.22958.16.camel@graviton>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 21:20:35 +0800
Message-ID: <1285248035.2964.2.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 08:15 -0400, Michael Poole wrote:
> Let the HID core handle input device setup and HID-compliant reports.
> This driver then only has to worry about the non-standard reports.
> 
> Signed-off-by: Michael Poole <mdpoole@troilus.org>

Michael, do you need me to retest the patch? I haven't looked at this
second version, but if it's pretty much as you describe below and you
don't need me to test it again, then my ACK still stands.

Thanks,

-- Chase

> ---
>  drivers/hid/hid-magicmouse.c |   81
> +++++++++--------------------------------
>  1 files changed, 18 insertions(+), 63 deletions(-)
> 
> This is a rebased and slightly revised version of an RFC patch I sent
> out a few weeks ago (which Chase later acked):
> http://www.spinics.net/lists/linux-input/msg10948.html
> 
> The changes in v2 are to clarify the commit summary line and comments,
> and remove one if() that would pass if the device had any HID input
> descriptors.  If/when someone adds support for a device that has none of
> those, the if() could be restored.
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 8791a08..5e1907a 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -279,13 +279,6 @@ static int magicmouse_raw_event(struct hid_device
> *hdev,
>  	int x = 0, y = 0, ii, clicks = 0, npoints;
>  
>  	switch (data[0]) {
> -	case 0x10:
> -		if (size != 6)
> -			return 0;
> -		x = (__s16)(data[2] | data[3] << 8);
> -		y = (__s16)(data[4] | data[5] << 8);
> -		clicks = data[1];
> -		break;
>  	case TRACKPAD_REPORT_ID:
>  		/* Expect four bytes of prefix, and N*9 bytes of touch data. */
>  		if (size < 4 || ((size - 4) % 9) != 0)
> @@ -343,13 +336,6 @@ static int magicmouse_raw_event(struct hid_device
> *hdev,
>  		magicmouse_raw_event(hdev, report, data + 2 + data[1],
>  			size - 2 - data[1]);
>  		break;
> -	case 0x20: /* Theoretically battery status (0-100), but I have
> -		    * never seen it -- maybe it is only upon request.
> -		    */
> -	case 0x60: /* Unknown, maybe laser on/off. */
> -	case 0x61: /* Laser reflection status change.
> -		    * data[1]: 0 = spotted, 1 = lost
> -		    */
>  	default:
>  		return 0;
>  	}
> @@ -377,36 +363,8 @@ static int magicmouse_raw_event(struct hid_device
> *hdev,
>  	return 1;
>  }
>  
> -static int magicmouse_input_open(struct input_dev *dev)
> -{
> -	struct hid_device *hid = input_get_drvdata(dev);
> -
> -	return hid->ll_driver->open(hid);
> -}
> -
> -static void magicmouse_input_close(struct input_dev *dev)
> -{
> -	struct hid_device *hid = input_get_drvdata(dev);
> -
> -	hid->ll_driver->close(hid);
> -}
> -
>  static void magicmouse_setup_input(struct input_dev *input, struct
> hid_device *hdev)
>  {
> -	input_set_drvdata(input, hdev);
> -	input->event = hdev->ll_driver->hidinput_input_event;
> -	input->open = magicmouse_input_open;
> -	input->close = magicmouse_input_close;
> -
> -	input->name = hdev->name;
> -	input->phys = hdev->phys;
> -	input->uniq = hdev->uniq;
> -	input->id.bustype = hdev->bus;
> -	input->id.vendor = hdev->vendor;
> -	input->id.product = hdev->product;
> -	input->id.version = hdev->version;
> -	input->dev.parent = hdev->dev.parent;
> -
>  	__set_bit(EV_KEY, input->evbit);
>  
>  	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
> @@ -466,11 +424,22 @@ static void magicmouse_setup_input(struct
> input_dev *input, struct hid_device *h
>  	}
>  }
>  
> +static int magicmouse_input_mapping(struct hid_device *hdev,
> +		struct hid_input *hi, struct hid_field *field,
> +		struct hid_usage *usage, unsigned long **bit, int *max)
> +{
> +	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
> +
> +	if (!msc->input)
> +		msc->input = hi->input;
> +
> +	return 0;
> +}
> +
>  static int magicmouse_probe(struct hid_device *hdev,
>  	const struct hid_device_id *id)
>  {
>  	__u8 feature[] = { 0xd7, 0x01 };
> -	struct input_dev *input;
>  	struct magicmouse_sc *msc;
>  	struct hid_report *report;
>  	int ret;
> @@ -500,8 +469,11 @@ static int magicmouse_probe(struct hid_device
> *hdev,
>  		goto err_free;
>  	}
>  
> -	/* we are handling the input ourselves */
> -	hidinput_disconnect(hdev);
> +	/* We do this after hid-input is done parsing reports so that
> +	 * hid-input uses the most natural button and axis IDs.
> +	 */
> +	if (msc->input)
> +		magicmouse_setup_input(msc->input, hdev);
>  
>  	if (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
>  		report = hid_register_report(hdev, HID_INPUT_REPORT,
> @@ -528,24 +500,7 @@ static int magicmouse_probe(struct hid_device
> *hdev,
>  		goto err_stop_hw;
>  	}
>  
> -	input = input_allocate_device();
> -	if (!input) {
> -		dev_err(&hdev->dev, "can't alloc input device\n");
> -		ret = -ENOMEM;
> -		goto err_stop_hw;
> -	}
> -	magicmouse_setup_input(input, hdev);
> -
> -	ret = input_register_device(input);
> -	if (ret) {
> -		dev_err(&hdev->dev, "input device registration failed\n");
> -		goto err_input;
> -	}
> -	msc->input = input;
> -
>  	return 0;
> -err_input:
> -	input_free_device(input);
>  err_stop_hw:
>  	hid_hw_stop(hdev);
>  err_free:
> @@ -558,7 +513,6 @@ static void magicmouse_remove(struct hid_device
> *hdev)
>  	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
>  
>  	hid_hw_stop(hdev);
> -	input_unregister_device(msc->input);
>  	kfree(msc);
>  }
>  
> @@ -577,6 +531,7 @@ static struct hid_driver magicmouse_driver = {
>  	.probe = magicmouse_probe,
>  	.remove = magicmouse_remove,
>  	.raw_event = magicmouse_raw_event,
> +	.input_mapping = magicmouse_input_mapping,
>  };
>  
>  static int __init magicmouse_init(void)



