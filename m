Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1IWSbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:31:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49516 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751402Ab1IWSbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:31:41 -0400
Date: Fri, 23 Sep 2011 14:31:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthias Dellweg <2500@gmx.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Michal Sojka <sojkam1@fel.cvut.cz>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enable usb control message with class specific request
In-Reply-To: <20110923195726.0cf0e8b5@horus>
Message-ID: <Pine.LNX.4.44L0.1109231427280.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Matthias Dellweg wrote:

> Am Fri, 23 Sep 2011 12:16:40 -0400 (EDT)
> schrieb Alan Stern <stern@rowland.harvard.edu>:
> > This is basically okay.  But your mailer has mangled the whitespace.
> > [...]
> > Alan Stern
> 
> OK, hoping that my mailer doesn't get wild again, this is the polished version
> following your suggestions.
> Thanks for your help!
>   Matthias Dellweg
> 
> From b7c4b6f5780296fd0d53d66e08d5bce0dc450b7f Mon Sep 17 00:00:00 2001
> From: Matthias Dellweg <2500@gmx.de>
> Date: Fri, 23 Sep 2011 19:32:39 +0200
> Subject: [PATCH] drivers/usb/core/devio.c: Check for printer class specific
>  request
> 
> Signed-off-by: Matthias Dellweg <2500@gmx.de>
> ---
>  drivers/usb/core/devio.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 37518df..e4175cc 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -607,9 +607,10 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
>  }
>  
>  static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
> -			   unsigned int index)
> +			   unsigned int request, unsigned int index)
>  {
>  	int ret = 0;
> +	struct usb_host_interface *alt_setting;
>  
>  	if (ps->dev->state != USB_STATE_UNAUTHENTICATED
>  	 && ps->dev->state != USB_STATE_ADDRESS
> @@ -618,6 +619,18 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
>  	if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
>  		return 0;
>  
> +	/*
> +	 * check for the special corner case 'get_device_id' in the printer
> +	 * class specification, where wIndex is (interface << 8 | altsetting)
> +	 */
> +	if (requesttype == 0xa1 && request == 0) {
> +		alt_setting = usb_find_alt_setting(ps->dev->actconfig,
> +						   index >> 8, index & 0xff);
> +		if (alt_setting
> +		 && alt_setting->desc.bInterfaceClass == USB_CLASS_PRINTER)
> +			index >>= 8;
> +	}
> +
>  	index &= 0xff;
>  	switch (requesttype & USB_RECIP_MASK) {
>  	case USB_RECIP_ENDPOINT:
> @@ -770,7 +783,8 @@ static int proc_control(struct dev_state *ps, void __user *arg)
>  
>  	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
>  		return -EFAULT;
> -	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
> +	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest,
> +			      ctrl.wIndex);
>  	if (ret)
>  		return ret;
>  	wLength = ctrl.wLength;		/* To suppress 64k PAGE_SIZE warning */
> @@ -1100,7 +1114,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  			kfree(dr);
>  			return -EINVAL;
>  		}
> -		ret = check_ctrlrecip(ps, dr->bRequestType,
> +		ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
>  				      le16_to_cpup(&dr->wIndex));
>  		if (ret) {
>  			kfree(dr);
> 

This looks fine to me.  Greg may ask you for a non-empty patch
description when you submit it to him.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

