Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0KRK7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:59:04 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48117 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0KRK7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:59:01 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6170"; a="63366068"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Greg KH'" <greg@kroah.com>
Cc: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
References: <1289916492-28402-1-git-send-email-tlinder@codeaurora.org> <20101117213535.GD10541@kroah.com>
In-Reply-To: <20101117213535.GD10541@kroah.com>
Subject: RE: [PATCH v5 1/1] usb: Adding SuperSpeed support to dummy_hcd
Date: Thu, 18 Nov 2010 13:01:17 +0200
Message-ID: <000001cb870f$efbc8600$cf359200$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuGn8OdJBQwd5omQ8GiBWQ/KPp0yAAaAulA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

Thank you for your comments. Please see my answers inline.

-----Original Message-----
From: linux-usb-owner@vger.kernel.org
[mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Greg KH
Sent: Wednesday, November 17, 2010 11:36 PM
To: Tatyana Brokhman
Cc: gregkh@suse.de; linux-usb@vger.kernel.org;
linux-arm-msm@vger.kernel.org; David Brownell; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] usb: Adding SuperSpeed support to dummy_hcd

On Tue, Nov 16, 2010 at 04:08:12PM +0200, Tatyana Brokhman wrote:
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/dummy_hcd.c |  500
++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 487 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/usb/gadget/dummy_hcd.c
b/drivers/usb/gadget/dummy_hcd.c
> index 13b9f47..ec6adf6 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -5,6 +5,7 @@
>   *
>   * Copyright (C) 2003 David Brownell
>   * Copyright (C) 2003-2005 Alan Stern
> + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.

Does your lawyers agree that this is correct to add based on the size of
the file?  Hint, it doesn't pass the rule that some lawyers I work with
go by, so I would be surprised that it passes theirs.

Also, I didn't think that "Code Aurora Forum" was a "real" legal entity
last time I looked, so how can it own copyrights?  Who is the "real"
owner here?  (hint, who does your lawyers work for...)
[Brokhman, Tanya] I was following the instructions given to me by our legal
team but I'll forward your comment to them and ask them once more.

>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -61,10 +62,13 @@
>  
>  #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing
*/
>  
> -static const char	driver_name [] = "dummy_hcd";
> -static const char	driver_desc [] = "USB Host+Gadget Emulator";
> +static const char	driver_name[] = "dummy_hcd";

While cleaning up coding style is always nice, please don't do it in the
same patch that you are adding a new feature.
[Brokhman, Tanya] Np. I'll remove this in the next version of the patch.

> +static const char	ss_driver_name[] = "ss_dummy_hcd";
> +static const char	driver_desc[] = "USB Host+Gadget Emulator";
> +static const char	ss_driver_desc[] = "SS USB Host+Gadget Emulator";
>  
> -static const char	gadget_name [] = "dummy_udc";
> +static const char	gadget_name[] = "dummy_udc";
> +static const char	ss_gadget_name[] = "ss_dummy_udc";
>  
>  MODULE_DESCRIPTION (DRIVER_DESC);
>  MODULE_AUTHOR ("David Brownell");
> @@ -220,6 +224,7 @@ static inline struct dummy *gadget_dev_to_dummy
(struct device *dev)
>  }
>  
>  static struct dummy			*the_controller;
> +static struct dummy			*the_ss_controller;
>  
>
/*-------------------------------------------------------------------------*
/
>  
> @@ -259,10 +264,94 @@ stop_activity (struct dummy *dum)
>  	/* driver now does any non-usb quiescing necessary */
>  }
>  
> -/* caller must hold lock */
> +/**
> + * set_ss_link_state() - Sets the current state of the SuperSpeed link
> + * @dum: pointer to the dummy_hcd structure to update the link
> + *     state for
> + *
> + * This function updates the port_status according to the link
> + * state. The old status is saved befor updating.
> + * Note: this function should be called only for SuperSpeed
> + * master and the caller must hold the lock.
> + */
> +static void
> +set_ss_link_state(struct dummy *dum)
> +{
> +	dum->active = 0;
> +	if ((dum->port_status & USB_SS_PORT_STAT_POWER) == 0)
> +		dum->port_status = 0;
> +
> +	/* UDC suspend must cause a disconnect */
> +	else if (!dum->pullup || dum->udc_suspended) {
> +		dum->port_status &= ~(USB_PORT_STAT_CONNECTION |
> +					USB_PORT_STAT_ENABLE);
> +		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0)
> +			dum->port_status |=
> +					(USB_PORT_STAT_C_CONNECTION << 16);
> +	} else {
> +		/* device is connected and not suspended */
> +		dum->port_status |= (USB_PORT_STAT_CONNECTION |
> +				     USB_PORT_STAT_SUPER_SPEED);
> +		if ((dum->old_status & USB_PORT_STAT_CONNECTION) == 0)
> +			dum->port_status |=
> +				(USB_PORT_STAT_C_CONNECTION << 16);
> +		if ((dum->port_status & USB_PORT_STAT_ENABLE) == 1 &&
> +		    (dum->port_status & USB_SS_PORT_LS_U0) == 1 &&
> +		    dum->rh_state != DUMMY_RH_SUSPENDED)
> +			dum->active = 1;
> +	}
> +
> +
> +	if ((dum->port_status & USB_PORT_STAT_ENABLE) == 0 || dum->active)
> +		dum->resuming = 0;
> +
> +	/* if !connected or reset */
> +	if ((dum->port_status & USB_PORT_STAT_CONNECTION) == 0 ||
> +			(dum->port_status & USB_PORT_STAT_RESET) != 0) {
> +		/*
> +		 * We're connected and not reseted (reset occured now),
> +		 * and driver attached - disconnect!
> +		 */
> +		if ((dum->old_status & USB_PORT_STAT_CONNECTION) != 0 &&
> +		    (dum->old_status & USB_PORT_STAT_RESET) == 0 &&
> +		    dum->driver) {
> +			stop_activity(dum);
> +			spin_unlock(&dum->lock);
> +			dum->driver->disconnect(&dum->gadget);
> +			spin_lock(&dum->lock);
> +		}
> +	} else if (dum->active != dum->old_active) {
> +		if (dum->old_active && dum->driver->suspend) {
> +			spin_unlock(&dum->lock);
> +			dum->driver->suspend(&dum->gadget);
> +			spin_lock(&dum->lock);
> +		} else if (!dum->old_active &&  dum->driver->resume) {
> +			spin_unlock(&dum->lock);
> +			dum->driver->resume(&dum->gadget);
> +			spin_lock(&dum->lock);
> +		}
> +	}
> +
> +	dum->old_status = dum->port_status;
> +	dum->old_active = dum->active;
> +}
> +
> +/**
> + * set_link_state() - Sets the current state of the link
> + * @dum: pointer to the dummy_hcd structure to update the link
> + *     state for
> + *
> + * This function updates the port_status according to the link
> + * state. The old status is saved befor updating.
> + * Note: caller must hold the lock.
> + */
>  static void
>  set_link_state (struct dummy *dum)
>  {
> +	if (dum == the_ss_controller) {
> +		set_ss_link_state(dum);
> +		return;
> +	}
>  	dum->active = 0;
>  	if ((dum->port_status & USB_PORT_STAT_POWER) == 0)
>  		dum->port_status = 0;
> @@ -343,7 +432,13 @@ dummy_enable (struct usb_ep *_ep, const struct
usb_endpoint_descriptor *desc)
>  	dum = ep_to_dummy (ep);
>  	if (!dum->driver || !is_enabled (dum))
>  		return -ESHUTDOWN;
> -	max = le16_to_cpu(desc->wMaxPacketSize) & 0x3ff;
> +	max = le16_to_cpu(desc->wMaxPacketSize) ;
> +	/*
> +	 * For HS/FS devices only bits 0..9 of the wMaxPacketSize represent
the
> +	 * maximum packet size
> +	 */
> +	if (dum->gadget.speed < USB_SPEED_SUPER)
> +		max &= 0x3ff;
>  
>  	/* drivers must not request bad settings, since lower levels
>  	 * (hardware or its drivers) may not check.  some endpoints
> @@ -361,6 +456,10 @@ dummy_enable (struct usb_ep *_ep, const struct
usb_endpoint_descriptor *desc)
>  			goto done;
>  		}
>  		switch (dum->gadget.speed) {
> +		case USB_SPEED_SUPER:
> +			if (max == 1024)
> +				break;
> +			goto done;
>  		case USB_SPEED_HIGH:
>  			if (max == 512)
>  				break;
> @@ -379,6 +478,7 @@ dummy_enable (struct usb_ep *_ep, const struct
usb_endpoint_descriptor *desc)
>  			goto done;
>  		/* real hardware might not handle all packet sizes */
>  		switch (dum->gadget.speed) {
> +		case USB_SPEED_SUPER:
>  		case USB_SPEED_HIGH:
>  			if (max <= 1024)
>  				break;
> @@ -399,6 +499,7 @@ dummy_enable (struct usb_ep *_ep, const struct
usb_endpoint_descriptor *desc)
>  			goto done;
>  		/* real hardware might not handle all packet sizes */
>  		switch (dum->gadget.speed) {
> +		case USB_SPEED_SUPER:
>  		case USB_SPEED_HIGH:
>  			if (max <= 1024)
>  				break;
> @@ -751,15 +852,21 @@ int
>  usb_gadget_probe_driver(struct usb_gadget_driver *driver,
>  		int (*bind)(struct usb_gadget *))
>  {
> -	struct dummy	*dum = the_controller;
> +	struct dummy	*dum;
>  	int		retval, i;
>  
> +	if (!bind || !driver->setup || driver->speed == USB_SPEED_UNKNOWN)
> +		return -EINVAL;
> +
> +	if (driver->speed == USB_SPEED_SUPER)
> +		dum = the_ss_controller;
> +	else
> +		dum = the_controller;
> +
>  	if (!dum)
>  		return -EINVAL;
>  	if (dum->driver)
>  		return -EBUSY;
> -	if (!bind || !driver->setup || driver->speed == USB_SPEED_UNKNOWN)
> -		return -EINVAL;

Why did you move this check up in the function?
[Brokhman, Tanya] I'll revert it to where it was.

And finally, did you check that this code works properly and the
existing functionlity did not break?  How?
[Brokhman, Tanya] Of course I did. I've also uploaded a patch series that
implements SuperSpeed support in the Gadget Framework (still waiting on
inputs on it). I'll upload a new version of that series today, rebased on
top of rc1. 
I verified the dummy_hcd functionality using that patch series and of course
tested it both with a HS device and with a SS device. 
In order to test our development of SuperSpeed we implemented a set of
unittests (based on GoogleTest). It includes both tests for HS and for SS
devices. The code was verified using that test set. 


thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

