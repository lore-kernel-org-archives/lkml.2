Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0JRTHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:07:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37125 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756250Ab0JRTHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:07:05 -0400
Date: Mon, 18 Oct 2010 15:07:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: linux-usb@vger.kernel.org, <linux-arm-msm@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 3/3] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <1287414296-25331-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010181444170.28752-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Tatyana Brokhman wrote:

> USB 3.0 hub includes 2 hubs - HS and SS ones.
> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).

All of your new kerneldoc comments are invalid.  The patch cannot be
accepted until you fix them.

> @@ -750,16 +865,24 @@ static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
>  int
>  usb_gadget_register_driver (struct usb_gadget_driver *driver)
>  {
> -	struct dummy	*dum = the_controller;
> +	struct dummy	*dum;
>  	int		retval, i;
> +	enum usb_device_speed	speed = USB_SPEED_UNKNOWN;
> +
> +	if (!driver->bind || !driver->setup
> +			|| driver->speed == USB_SPEED_UNKNOWN)
> +		return -EINVAL;
> +
> +	speed = driver->speed;

What do you need "speed" for?  Can't you use driver->speed?

> +static int dummy_ss_udc_probe(struct platform_device *pdev)
> +{
> +	struct dummy	*dum = the_ss_controller;
> +	int		rc;
> +
> +	dum->gadget.name = gadget_name;
> +	dum->gadget.ops = &dummy_ops;
> +	dum->gadget.is_dualspeed = 1;

Is this setting appropriate?  The "is_dualspeed" field indicates that
the gadget runs at both full speed and high speed.  But that's not what
you want -- you want to indicate that the gadget runs at SuperSpeed.

> @@ -1384,6 +1559,9 @@ static void dummy_timer (unsigned long _dum)
>  	case USB_SPEED_HIGH:
>  		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
>  		break;
> +	case USB_SPEED_SUPER:
> +		total = 1024/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
> +		break;

I don't know what the transfer parameters for SuperSpeed are, but I do
know that these are wrong.  With over 60000 bytes per uframe there is
certainly room for more than thirteen 1024-byte packets.

> +/**
> + * dummy_address_device() - Assign an address for the connected
> + * device
> + * @param hcd - host controller of the device
> + * @param udev - device to address
> + *
> + * @return int - 0 on success, or an error code (refer to
> + *	   errno-base.h for details)
> + *
> + * Issue an Address Device command (which will issue a
> + * SetAddress request to the device). We should be protected by
> + * the usb_address0_mutex in khubd's hub_port_init, so we should
> + * only issue and wait on one address command at the same time.
> + *
> + * This function is used only for SS hcd drivers.
> + */
> +static int dummy_address_device(struct usb_hcd *hcd, struct usb_device *udev)
> +{
> +	udev->devnum = 3;
> +	return usb_control_msg(udev, (PIPE_CONTROL << 30),
> +		USB_REQ_SET_ADDRESS, 0, udev->devnum, 0,
> +		NULL, 0, USB_CTRL_SET_TIMEOUT);
> +}

This looks very suspicious.  Why have this function if it's only going 
to do the same thing that usbcore would do if it weren't present?

Also, the address_device routine should not change udev->devnum.  The
code that does this in the xhci driver is being removed, because it
causes bugs.

Alan Stern

