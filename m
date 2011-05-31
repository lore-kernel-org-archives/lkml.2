Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab1EaSSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:18:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:51081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab1EaSSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:18:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,298,1304319600"; 
   d="scan'208";a="7377218"
Date: Tue, 31 May 2011 11:18:48 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
Message-ID: <20110531181848.GA6911@xanatos>
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
 <4DE4F166.8020207@gmail.com>
 <20110531171446.GB6776@xanatos>
 <4DE5283A.9070202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE5283A.9070202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:41:14PM +0200, Maarten Lankhorst wrote:
> Hi Sarah,
> 
> Op 31-05-11 19:14, Sarah Sharp schreef:
> > On Tue, May 31, 2011 at 03:47:18PM +0200, Maarten Lankhorst wrote:
> > Can you send me the full dmesg with CONFIG_USB_XHCI_HCD_DEBUGGING turned
> > on?  I'd like to see the full debug log for this and see if the host or
> > driver is falling over in an earlier spot.
> I'm on linux 2.6.39, relevant dmesg spits out this:

Do you also have CONFIG_USB_DEBUGGING turned on and have you run `sudo
dmesg -n 8`?  There should be much more debugging here.

> >> Signed-off-by: Maarten Lankhorst<m.b.lankhorst@gmail.com>
> >>
> >> ---
> >> index 81b976e..9a869b2 100644
> >> --- a/drivers/usb/host/xhci.c
> >> +++ b/drivers/usb/host/xhci.c
> >> @@ -2307,6 +2307,10 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
> >>  			return -EINVAL;
> >>  	}
> >>
> >> +	if (GET_SLOT_STATE(xhci_get_slot_ctx(xhci, virt_dev->out_ctx)->dev_state) == 0&&
> >> +	    (xhci_get_ep_ctx(xhci, virt_dev->out_ctx, 0)->ep_info&  EP_STATE_MASK) == EP_STATE_DISABLED)
> >> +		return 0;
> >> +
> > Why are you looking at the endpoint state?  The control endpoint state
> > has nothing to do with the outcome of the Reset Device command.  The
> > host controller is only allowed to reject the command if the device slot
> > is not in the addressed or configured state (according to the 0.96 spec,
> > I assume this host isn't a 1.0 host).  So the control endpoint state
> > should have nothing to do with whether the command succeeds.
> >
> > I'm also confused as to why this code works.  The control endpoint is
> > never disabled until the USB core deallocates a device.  Once the xHCI
> > driver allocates a slot and issues an Address Device command, the
> > control endpoint's output context should move from the disabled state to
> > the running state.  But if this conditional actually ran, then either
> > the host controller didn't update the output context for the control
> > endpoint, the Address Device command failed, or something very strange
> > is going on.
> >
> > Full dmesg with the xHCI driver debug will help me figure this out.
> > What kernel are you running?
> I think it happens because hub_port_reset is called in hub_port_init since
> commit 07194ab7be63a972096309ab0ea747df455c6a20, so I'd say that is
> what causes the reset to be called in this state?

Yes, but every host controller I've run into, except yours, can handle
this patch, and the xHCI specification says the host should be able to
handle this, so my inclination is that your hardware is just broken.

I'd like to know exactly which host controller it is (`lspci -vvv` will
help with that), and then we can hopefully track down an engineer from
that company and ask them what that error code means.  Once we do
receive confirmation that the error code is just a fluke, we can create
a quirk for that specific host controller to ignore that error condition
for the reset device command.

Sarah Sharp
