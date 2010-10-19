Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0JSOr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:47:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48832 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752205Ab0JSOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:47:56 -0400
Date: Tue, 19 Oct 2010 10:47:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: linux-usb@vger.kernel.org, <linux-arm-msm@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 3/3] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <217d07c2bcc41c06a975cbe7b2465d64.squirrel@www.codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010191045150.1786-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 tlinder@codeaurora.org wrote:

> >> +/**
> >> + * dummy_address_device() - Assign an address for the connected
> >> + * device
> >> + * @param hcd - host controller of the device
> >> + * @param udev - device to address
> >> + *
> >> + * @return int - 0 on success, or an error code (refer to
> >> + *	   errno-base.h for details)
> >> + *
> >> + * Issue an Address Device command (which will issue a
> >> + * SetAddress request to the device). We should be protected by
> >> + * the usb_address0_mutex in khubd's hub_port_init, so we should
> >> + * only issue and wait on one address command at the same time.
> >> + *
> >> + * This function is used only for SS hcd drivers.
> >> + */
> >> +static int dummy_address_device(struct usb_hcd *hcd, struct usb_device
> >> *udev)
> >> +{
> >> +	udev->devnum = 3;
> >> +	return usb_control_msg(udev, (PIPE_CONTROL << 30),
> >> +		USB_REQ_SET_ADDRESS, 0, udev->devnum, 0,
> >> +		NULL, 0, USB_CTRL_SET_TIMEOUT);
> >> +}
> >
> > This looks very suspicious.  Why have this function if it's only going
> > to do the same thing that usbcore would do if it weren't present?
> 
> Upon new device connection the host addresses the device from
> hub_set_address() that if the address_device cb was provided for the hcd -
> calls it. This function begins with a verification that either this cb was
> supplied or the usbcore already addresses the device (meaning udev->devnum
> > 1).
> usbcore addresses the device in choose_address() that is called from
> hub_port_connect_change but only if it's not a SuperSpeed hcd:
> if (!(hcd->driver->flags & HCD_USB3)) {
> 	/* set the address */
>         choose_address(udev);
>         ...
> }
> Since our hcd is SuperSpeed, choose_address() isn't called and
> udev->devnum remains 0.
> Due to the above in order for this implementation to work properly we have
> to provide the address_device cb for a SuperSpeed hcd.
> Perhaps this was already fixed but I'm not familiar with such patch. I
> would be happy to pick it up if you could refer me to it.

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-07-usb/usb-core-use-kernel-assigned-address-for-devices-under-xhci.patch

> > Also, the address_device routine should not change udev->devnum.  The
> > code that does this in the xhci driver is being removed, because it
> > causes bugs.
> 
> A better solution might be to call choose_address() for SuperSpeed hcd as
> well. If that sounds good to everyone I can make the change.

The patch listed above already contains these changes.

Alan Stern

