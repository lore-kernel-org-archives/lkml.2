Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab0LTSpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:45:43 -0500
Received: from kroah.org ([198.145.64.141]:51936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab0LTSpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:45:41 -0500
Date: Mon, 20 Dec 2010 10:29:34 -0800
From: Greg KH <greg@kroah.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add support for Dream Cheeky DL100B Webmail
 Notifier (1d34:0004)
Message-ID: <20101220182934.GA23715@kroah.com>
References: <201012192310.13431@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012192310.13431@rk-nord.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 11:10:12PM +0100, Melchior FRANZ wrote:
> From: Melchior FRANZ <mfranz@aon.at>
> 
> Add support for Dream Cheeky DL100B Webmail Notifier (1d34:0004) as
> usbled device. Lets hid-core ignore the device's HID-ness.

Nice idea, but a few comments below as to how to make this a bit
"cleaner"

> 
> Signed-off-by: Melchior FRANZ <mfranz@aon.at>
> ---
> 
> So far the USBLED driver only supports Delcom's "USB Visual Signal
> Indicator" (http://www.delcomproducts.com/products_USBLMP.asp). The
> driver generates virtual files "red", "blue", and "green" under the
> device's /sys/ directory, where color values can be read and written to.
> 
> This patch adds support for Dream Cheeky's "DL100B Webmail Notifier"
> (http://www.dreamcheeky.com/webmail-notifier -- available from several
> shops, such as http://www.conrad.at/ce/de/product/777048/USB-WEBMAIL).
> This device isn't as pretty as Delcom's, but it's *far* cheaper, and
> its 3 LEDs can be set in 32 brightness steps each. The grey envelope
> contour can easily be removed, leaving a rather neutral white box (with
> a few small holes), which is useful for generic signalling purposes.
> Of course, the small circuit board can easily be put into a prettier
> case. The price difference to Delcom's thingy lets you a lot of room. :-)
> 
> The DL100B device pretends to be a HID, but the HID descriptor shows
> that it's not overly useful as such (see below). The patch therefore
> removes the "HID-ness" (hid-core.c, hid-ids.h), and adds the necessary
> commands to usbled.c. The protocol comes from the developer's manual
> that Dream Cheeky kindly provided (815DeveloperManual.pdf).
> 
> Please review and consider for inclusion. (The patch is diffed against
> 2.6.36.2.)
> 
> m.
> 
> 
> HID descriptor:
> 
>   0: 05 01   Usage Page 'Generic Desktop Controls'
>   2: 09 10   Usage 'Reserved'
>   4: a1 01   Collection 'Application (mouse, keyboard)'
>   6: 05 00           Usage Page 'Undefined'
>   8: 19 10           Usage Minimum = 16
>  10: 29 11           Usage Maximum = 17
>  12: 15 00           Logical Minimum = 0
>  14: 25 0f           Logical Maximum = 15
>  16: 75 08           Report Size = 8
>  18: 95 08           Report Count = 8
>  20: 91 02           Output data *var abs lin pref-state null-pos non-vol bit-field
>  22: 19 10           Usage Minimum = 16
>  24: 29 11           Usage Maximum = 17
>  26: 15 00           Logical Minimum = 0
>  28: 25 0f           Logical Maximum = 15
>  30: 75 08           Report Size = 8
>  32: 95 08           Report Count = 8
>  34: 81 00           Input data array abs lin pref-state null-pos non-vol bit-field
>  36: c0      End Collection
> 

All of this information should be above the --- line so it would be
included in the changelog.  Please do that next time.


> @@ -20,12 +20,13 @@
>  #define DRIVER_AUTHOR "Greg Kroah-Hartman, greg@kroah.com"
>  #define DRIVER_DESC "USB LED Driver"
>  
> -#define VENDOR_ID	0x0fc5
> -#define PRODUCT_ID	0x1223
> +#define VENDOR_ID_DELCOM       0x0fc5
> +#define VENDOR_ID_DREAM_CHEEKY 0x1d34
>  
>  /* table of devices that work with this driver */
>  static const struct usb_device_id id_table[] = {
> -	{ USB_DEVICE(VENDOR_ID, PRODUCT_ID) },
> +	{ USB_DEVICE(VENDOR_ID_DELCOM, 0x1223) },
> +	{ USB_DEVICE(VENDOR_ID_DREAM_CHEEKY, 0x0004) }, /* DL100B */

Why not put the "device type" in the id table?  Then you don't have to
check the device vendor/product in the probe function and you would
automatically know the type for later on.

Also, make the type an enumerated type, not just a simple flag like you
did here:

> @@ -35,6 +36,7 @@ struct usb_led {
>  	unsigned char		blue;
>  	unsigned char		red;
>  	unsigned char		green;
> +	unsigned char		dream_cheeky:1;
>  };
>  
>  #define BLUE	0x04

Add a enum led_type to this structure that you copy out of the id table
when the device is probed.  Make 0 be the old type so that dynamice
device ids can at least have a chance to work that way.


> @@ -43,7 +45,6 @@ struct usb_led {


>  static void change_color(struct usb_led *led)
>  {
>  	int retval;
> -	unsigned char color = 0x07;
>  	unsigned char *buffer;
>  
>  	buffer = kmalloc(8, GFP_KERNEL);
> @@ -52,25 +53,51 @@ static void change_color(struct usb_led *led)
>  		return;
>  	}
>  
> -	if (led->blue)
> -		color &= ~(BLUE);
> -	if (led->red)
> -		color &= ~(RED);
> -	if (led->green)
> -		color &= ~(GREEN);
> -	dev_dbg(&led->udev->dev,
> -		"blue = %d, red = %d, green = %d, color = %.2x\n",
> -		led->blue, led->red, led->green, color);
> -
> -	retval = usb_control_msg(led->udev,
> -				usb_sndctrlpipe(led->udev, 0),
> -				0x12,
> -				0xc8,
> -				(0x02 * 0x100) + 0x0a,
> -				(0x00 * 0x100) + color,
> -				buffer,	
> -				8,
> -				2000);
> +	if (led->dream_cheeky) {

Then switch on the enumerated type here, instead of a if, making it
easier to add different types here in the future.

Care to make those changes up and resend?

thanks,

greg k-h
