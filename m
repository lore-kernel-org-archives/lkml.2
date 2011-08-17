Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1HQVJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:09:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43287 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754428Ab1HQVJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:09:37 -0400
Date: Wed, 17 Aug 2011 17:09:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <fb37566fc5a85ea4e8711221253e5db98d919251.1313594405.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1108171704280.2100-100000@iolanthe.rowland.org>
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


> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1559,12 +1559,6 @@ composite_resume(struct usb_gadget *gadget)
>  /*-------------------------------------------------------------------------*/
>  
>  static struct usb_gadget_driver composite_driver = {
> -#ifdef CONFIG_USB_GADGET_SUPERSPEED
> -	.speed		= USB_SPEED_SUPER,
> -#else
> -	.speed		= USB_SPEED_HIGH,
> -#endif
> -
>  	.unbind		= composite_unbind,
>  
>  	.setup		= composite_setup,
> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct usb_composite_driver *driver,
>  		driver->iProduct = driver->name;
>  	composite_driver.function =  (char *) driver->name;
>  	composite_driver.driver.name = driver->name;
> -	composite_driver.speed = min((u8)composite_driver.speed,
> -				     (u8)driver->max_speed);
> +	composite_driver.speed = driver->max_speed;
>  	composite = driver;
>  	composite_gadget_bind = bind;

I see what's going on here.  Your original patch was wrong and then my 
correction was wrong as well.

This line has to remain the way it was (although those (u8) typecasts
don't seem to be necessary).  Above, you have to initialize
composite_driver.speed to an appropriate value, probably
USB_SPEED_SUPER.

What you didn't realize in your original patch is that 
usb_composite_probe() gets called more than once.  Each time it is 
called, it has to adjust composite_driver.speed.

Alan Stern

