Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1HQOUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:20:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54471 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753924Ab1HQOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:20:17 -0400
Date: Wed, 17 Aug 2011 10:20:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <aeb2d1e4eb36e6a0265ed0e6c279e81880bbfef2.1313585187.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1108171016370.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> This commit removes the use of USB_GADGET_DUALSPEED and
> USB_GADGET_SUPERSPEED Kconfig options.  Those were selected
> by UDC drivers which supported respective speeds.
> 
> However, since kernel now allows multiple UDC drivers to be
> compiled, the options in question may no longer reflect the
> state of all gadgets.
> 
> For instance, if one driver that supports dual speed is selected
> and another that does not, the USB_GADGE_DUALSPEED will be set
> "for both".
> 
> This commit replaces all the #ifdefs by a run-time checks made
> by calling gadget_is_dualspeed().


> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct usb_composite_driver *driver,
>  		driver->iProduct = driver->name;
>  	composite_driver.function =  (char *) driver->name;
>  	composite_driver.driver.name = driver->name;
> -	composite_driver.speed = min((u8)composite_driver.speed,
> -				     (u8)driver->max_speed);
> +	composite_driver.speed = min(USB_SPEED_SUPER, driver->max_speed);

I wonder if the min is needed here at all.  It doesn't seem to be doing 
any good.


> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3562,11 +3562,7 @@ static void fsg_resume(struct usb_gadget *gadget)
>  /*-------------------------------------------------------------------------*/
>  
>  static struct usb_gadget_driver		fsg_driver = {
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>  	.speed		= USB_SPEED_HIGH,
> -#else
> -	.speed		= USB_SPEED_FULL,
> -#endif
>  	.function	= (char *) fsg_string_product,
>  	.unbind		= fsg_unbind,
>  	.disconnect	= fsg_disconnect,

You mustn't remove the .speed field entirely.  Set it to USB_SPEED_HIGH.
The same goes for the other drivers below.


> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index 1b24099..1869478 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c

> @@ -1015,9 +1013,8 @@ ep0_read (struct file *fd, char __user *buf, size_t len, loff_t *ptr)
>  			if (dev->current_config) {
>  				unsigned power;
>  
> -				if (gadget_is_dualspeed(dev->gadget)
> -						&& (dev->gadget->speed
> -							== USB_SPEED_HIGH))
> +				if (gadget_is_dualspeed(dev->gadget) &&
> +				    (dev->gadget->speed == USB_SPEED_HIGH))
>  					power = dev->hs_config->bMaxPower;
>  				else
>  					power = dev->config->bMaxPower;

Please don't mix functional changes with cosmetic whitespace changes.

Alan Stern

