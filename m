Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab1HTNlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 09:41:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57431 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751848Ab1HTNlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 09:41:18 -0400
Date: Sat, 20 Aug 2011 09:41:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/4] usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED
In-Reply-To: <a96af7281232576b790fa8913012bb7c1a8e6c8b.1313791722.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1108200932190.26680-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> This commit removes USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
> Kconfig options.  Since now kernel allows many UDC drivers to be
> compiled, those options may turn to no longer be valid.  For
> instance, if someone decides to build UDC that supports super
> speed and UDC that supports high speed only, the latter will be
> "assumed" to support super speed since USB_GADGET_SUPERSPEED will
> be selected by the former.
> 
> The test of whether CONFIG_USB_GADGET_*SPEED was defined was just
> an optimisation which removed otherwise dead code (ie. if UDC is
> not dual speed, there is no need to handle cases that can happen
> if speed is high).  This commit removes those checks.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

...

> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -985,7 +985,7 @@ static int dummy_udc_probe (struct platform_device *pdev)
>  
>  	dum->gadget.name = gadget_name;
>  	dum->gadget.ops = &dummy_ops;
> -	dum->gadget.max_speed = USB_SPEED_SUPER;;
> +	dum->gadget.max_speed = USB_SPEED_SUPER;

You might as well get this right in patch 2/4.  Then this hunk
wouldn't be needed.


> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
...
> @@ -1773,11 +1767,7 @@ gadgetfs_suspend (struct usb_gadget *gadget)
>  }
>  
>  static struct usb_gadget_driver gadgetfs_driver = {
> -#ifdef	CONFIG_USB_GADGET_DUALSPEED
>  	.max_speed	= USB_SPEED_HIGH,
> -#else
> -	.max_speed	= USB_SPEED_FULL,
> -#endif

I'm not sure that a static definition is correct here.  The actual 
max_speed depends on what descriptors the userspace program sends.  
Take a look at the ep_config() routine.

Alan Stern

