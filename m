Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1BET2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:28:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1BET2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:28:34 -0500
Date: Sat, 5 Feb 2011 11:28:31 -0800
From: Greg KH <gregkh@suse.de>
To: Maciej Szmigiero <mhej@o2.pl>
Cc: Johan Hovold <jhovold@gmail.com>, Joe Perches <joe@perches.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [USB]Add Samsung SGH-I500/Android modem ID switch to visor
 driver
Message-ID: <20110205192831.GA334@suse.de>
References: <4D4D9F37.4010201@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4D9F37.4010201@o2.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 08:04:23PM +0100, Maciej Szmigiero wrote:
> [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
> 
> Samsung decided to reuse USB ID of its old CDMA phone SGH-I500 for the
> modem part of some of their Android phones. At least Galaxy Spica
> is affected.

Ick, no way, that's horrible.

> This modem needs ACM driver and does not work with visor driver which
> binds the conflicting ID for SGH-I500.
> Because SGH-I500 is pretty an old hardware its best to add switch to visor
> driver in cause somebody still wants to use that phone with Linux.
> 
> Note that this is needed only when using the Android phone as modem,
> not in USB storage or ADB mode.

If the phone switches to modem mode, does it show up as a ACM class
device?

> 
> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
> diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
> index 15a5d89..5e56ab3 100644
> --- a/drivers/usb/serial/visor.c
> +++ b/drivers/usb/serial/visor.c
> @@ -52,6 +52,7 @@ static int palm_os_4_probe(struct usb_serial *serial,
>  
>  /* Parameters that may be passed into the module. */
>  static int debug;
> +static int enable_i500;
>  static __u16 vendor;
>  static __u16 product;
>  
> @@ -479,6 +480,10 @@ static int visor_probe(struct usb_serial *serial,
>  
>  	dbg("%s", __func__);
>  
> +	if ((!enable_i500) && (id->idVendor == SAMSUNG_VENDOR_ID) &&
> +		(id->idProduct == SAMSUNG_SPH_I500_ID))
> +		return -ENODEV;
> +
>  	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
>  		dev_err(&serial->dev->dev, "active config #%d != 1 ??\n",
>  			serial->dev->actconfig->desc.bConfigurationValue);
> @@ -718,6 +723,11 @@ MODULE_LICENSE("GPL");
>  module_param(debug, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Debug enabled or not");
>  
> +module_param(enable_i500, bool, S_IRUGO);
> +MODULE_PARM_DESC(enable_i500, "Enable support for Samsung SPH-I500. "
> +				"Causes USBID conflict with modem in Samsung "
> +				"Android phones");
> +

Is there any way to dynamically detect this?  We don't want it to be a
module parameter, as we will never know to set it.

Surely the configuration of the device looks different somehow?  If it
reports itself as an ACM device, we should be able to detect that,
right?

thanks,

greg k-h
