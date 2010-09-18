Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0IRMvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 08:51:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43352 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0IRMvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 08:51:04 -0400
Subject: Re: [RFC PATCH] hid-magicmouse: Map inputs rather than munging
 input devices
From: Chase Douglas <chase.douglas@canonical.com>
To: Michael Poole <mdpoole@troilus.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1283699801.26830.4.camel@graviton>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
	 <1283306184-28833-2-git-send-email-chase.douglas@canonical.com>
	 <4C7E94F6.9050806@gmail.com>
	 <AANLkTi=z5s8mbjG54930Lxj-O9Of2fXHE6kDJhijyOb7@mail.gmail.com>
	 <4C7F6E26.2030301@gmail.com>
	 <AANLkTikb=eNzek-vQ=d3jZxitsbtJ5gD6BNDipAUpUcJ@mail.gmail.com>
	 <4C80DB38.9040101@gmail.com>  <1283699801.26830.4.camel@graviton>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 14:50:32 +0200
Message-ID: <1284814232.2257.6.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 11:16 -0400, Michael Poole wrote:
> Let the HID core handle input device setup and HID-compliant reports.
> This driver then only has to worry about the non-standard reports.
> 
> Signed-off-by: Michael Poole <mdpoole@troilus.org>

I have tested this patch and it does prevent the magic trackpad from
panicking the machine on device removal. I am acking this patch because
it resolves the issue and the changes are reasonable when looking at the
driver. I do not know much about the internal HID layer, so I have no
comment on the overall approach taken.

Acked-by: Chase Douglas <chase.douglas@canonical.com>

When pushing to the input tree, I suggest rebasing the magic trackpad
enablement patch after this patch so someone bisecting commits won't hit
the panic.

Thanks Michael!

> ---
> Jiri (Slaby), is this the kind of change you had in mind for getting rid
> of the input device setup for hid-magicmouse?
> 
> (This applies on top of commit a462230e16 from the magicmouse branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git.)
> 
>  drivers/hid/hid-magicmouse.c |   87
> +++++++++++------------------------------
>  1 files changed, 24 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 8791a08..3778f9b 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -278,14 +278,12 @@ static int magicmouse_raw_event(struct hid_device
> *hdev,
>  	struct input_dev *input = msc->input;
>  	int x = 0, y = 0, ii, clicks = 0, npoints;
>  
> +	/* Slightly paranoid, but "input" only gets set when our
> +	 * input_mapping sees the right field. */
> +	if (!input)
> +		return 0;
> +
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
> @@ -343,13 +341,6 @@ static int magicmouse_raw_event(struct hid_device
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
> @@ -377,36 +368,8 @@ static int magicmouse_raw_event(struct hid_device
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
> @@ -466,11 +429,22 @@ static void magicmouse_setup_input(struct
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
> @@ -500,8 +474,12 @@ static int magicmouse_probe(struct hid_device
> *hdev,
>  		goto err_free;
>  	}
>  
> -	/* we are handling the input ourselves */
> -	hidinput_disconnect(hdev);
> +	/* We do this after HID maps its inputs so that the
> +	 * Magic Mouse's HID-compliant report gets the right
> +	 * button and axis IDs.
> +	 */
> +	if (msc->input)
> +		magicmouse_setup_input(msc->input, hdev);
>  
>  	if (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
>  		report = hid_register_report(hdev, HID_INPUT_REPORT,
> @@ -528,24 +506,7 @@ static int magicmouse_probe(struct hid_device
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
> @@ -558,7 +519,6 @@ static void magicmouse_remove(struct hid_device
> *hdev)
>  	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
>  
>  	hid_hw_stop(hdev);
> -	input_unregister_device(msc->input);
>  	kfree(msc);
>  }
>  
> @@ -577,6 +537,7 @@ static struct hid_driver magicmouse_driver = {
>  	.probe = magicmouse_probe,
>  	.remove = magicmouse_remove,
>  	.raw_event = magicmouse_raw_event,
> +	.input_mapping = magicmouse_input_mapping,
>  };
>  
>  static int __init magicmouse_init(void)

