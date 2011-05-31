Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab1EaROs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:14:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:15213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab1EaROr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,298,1304319600"; 
   d="scan'208";a="7339047"
Date: Tue, 31 May 2011 10:14:46 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
Message-ID: <20110531171446.GB6776@xanatos>
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
 <4DE4F166.8020207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE4F166.8020207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:47:18PM +0200, Maarten Lankhorst wrote:
> Hey Andiry,
> 
> Op 31-05-11 02:34, Xu, Andiry schreef:
> >>-----Original Message-----
> >>From:linux-usb-owner@vger.kernel.org  [mailto:linux-usb-
> >>owner@vger.kernel.org] On Behalf Of Maarten Lankhorst
> >>Sent: Monday, May 30, 2011 5:57 PM
> >>To:linux-usb@vger.kernel.org
> >>Cc: Sarah Sharp;linux-kernel@vger.kernel.org; Maarten Lankhorst
> >>Subject: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
> >>
> >>My asrock P67 chipset sends code 192 on device reset. Allowing>= 192
> >>to be treated as success fixes it, and allows me to use my USB3 port.
> >>
> >TRB completion code 192-223 is defined as Vendor defined error. Your
> >host
> >controller returns a error - don't know what causes the error since it's
> >vendor defined.
> Ahh, making it the same as COMP_EBADSLT/COMP_CTX_STATE I get this:
> [72677.470421] xhci_hcd 0000:04:00.0: Can't reset device (slot ID 1)
> in enabled/disabled state

Yes, because that's what those error codes mean.  But your host
controller did not return that error code, it returned a vendor-specific
error code.

> Should reset_device even be called when in that state? The comments
> above claim:
> /* The Reset Device command can't fail, according to the 0.95/0.96 spec,
>  * unless we tried to reset a slot ID that wasn't enabled,
>  * or the device wasn't in the addressed or configured state.
>  */

The code shouldn't happen, but we cover the error condition in case
there is a future bug in the USB core, or a buggy host controller.  But
that's really beside the point.  Your host returned a different error
code, and there's no telling what that means without vendor specific
documentation.  Can you send me the lspci for the host?

> Ignoring the error seems to make it work fine. It seems to me that
> device reset shouldn't even be attempted since it hasn't been
> brought up yet. The reset that fails is the one that happens on the
> original hub_port_init when it calls hub_port_reset which calls
> xhci_discover_or_reset_device. The failure I'm getting seems to be a
> vendor specific variant of "you're trying to reset the device while
> it wasn't enabled".

Yes, the USB core resets a device during the standard enumeration
process.  The host controller is supposed to be able to handle that
case.  Why it returns a vendor specific error is something that company
needs to answer.

Can you send me the full dmesg with CONFIG_USB_XHCI_HCD_DEBUGGING turned
on?  I'd like to see the full debug log for this and see if the host or
driver is falling over in an earlier spot.

> Signed-off-by: Maarten Lankhorst<m.b.lankhorst@gmail.com>
> 
> ---
> index 81b976e..9a869b2 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -2307,6 +2307,10 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>  			return -EINVAL;
>  	}
> 
> +	if (GET_SLOT_STATE(xhci_get_slot_ctx(xhci, virt_dev->out_ctx)->dev_state) == 0&&
> +	    (xhci_get_ep_ctx(xhci, virt_dev->out_ctx, 0)->ep_info&  EP_STATE_MASK) == EP_STATE_DISABLED)
> +		return 0;
> +

Why are you looking at the endpoint state?  The control endpoint state
has nothing to do with the outcome of the Reset Device command.  The
host controller is only allowed to reject the command if the device slot
is not in the addressed or configured state (according to the 0.96 spec,
I assume this host isn't a 1.0 host).  So the control endpoint state
should have nothing to do with whether the command succeeds.

I'm also confused as to why this code works.  The control endpoint is
never disabled until the USB core deallocates a device.  Once the xHCI
driver allocates a slot and issues an Address Device command, the
control endpoint's output context should move from the disabled state to
the running state.  But if this conditional actually ran, then either
the host controller didn't update the output context for the control
endpoint, the Address Device command failed, or something very strange
is going on.

Full dmesg with the xHCI driver debug will help me figure this out.
What kernel are you running?

Sarah Sharp
