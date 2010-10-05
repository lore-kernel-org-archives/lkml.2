Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0JESLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:11:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:52499 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab0JESLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:11:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,285,1283756400"; 
   d="scan'208";a="844036852"
Date: Tue, 5 Oct 2010 11:11:26 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: tlinder@codeaurora.org
Cc: linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20101005181126.GB7383@xanatos>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
 <20101004072602.GB2256@xanatos>
 <0daac081a669f0cc8e024644f223c0c2.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0daac081a669f0cc8e024644f223c0c2.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 04:53:40AM -0700, tlinder@codeaurora.org wrote:
> > Hi Tatyana,
> >
> > Comments inline.  I'm not familiar with the gadget framework; I'm just
> > curious about some descriptor choices.
> >
> > On Sun, Oct 03, 2010 at 10:02:15AM +0200, tlinder wrote:
> >> +/** Default endpoint companion descriptor */
> >> +static struct usb_ss_ep_comp_descriptor ep_comp_desc = {
> >> +		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> >> +		.bLength = 0x06,
> >> +		.bMaxBurst = 0, /*the default is we don't support bursting*/
> >> +		.bmAttributes = 0, /*2^0 streams supported*/
> >> +		.wBytesPerInterval = 0,
> >> +};
> >
> > Can you please set wBytesPerInterval to something sane for periodic
> > endpoints?  Perhaps have it set to the maximum packet size times the max
> > burst size times Mult plus one, or less if the device *knows* it's going
> > to send less data.  It's used for xHC host controller scheduling, so
> > it's important to get right for maximum bandwidth usage.
> 
> This descriptor holds default values so both bMaxBurst and bmAttributes
> are set to 0, meaning bursting and streaming are not not supported. So
> Mult will be set to 0 as well. Mult defined only for iso endpoints and not
> for interrupt.
> Due to the above I propose setting wBytesPerInterval to maxpacketsize for
> periodic endpoints.

Sounds good.

> >> +	while (*src) {
> >> +		/*Copy the original descriptor*/
> >> +		memcpy(mem, *src, (*src)->bLength);
> >> +		switch ((*src)->bDescriptorType) {
> >> +		case USB_DT_ENDPOINT:
> >> +			/*update ep descriptor*/
> >> +			ep_desc = (struct usb_endpoint_descriptor *)mem;
> >> +			switch (ep_desc->bmAttributes &
> >> +				USB_ENDPOINT_XFERTYPE_MASK) {
> >> +			case USB_ENDPOINT_XFER_CONTROL:
> >> +				ep_desc->wMaxPacketSize = 512;
> >> +				ep_desc->bInterval = 0;
> >> +				break;
> >> +			case USB_ENDPOINT_XFER_BULK:
> >> +				ep_desc->wMaxPacketSize = 1024;
> >> +				ep_desc->bInterval = 0;
> >> +				break;
> >> +			case USB_ENDPOINT_XFER_INT:
> >> +			case USB_ENDPOINT_XFER_ISOC:
> >
> > Why are you not setting wMaxPacketSize for periodic endpoints?  Does it
> > get set later?  (I can't tell from this snippet.)
> 
> It's not set later. According to the USB30 Spec Table 9-18, the
> description of wMaxPacketSize for interrupt and iso endpoints:
> "..if bMuxBurst field is set to zero then this field can have any value
> from 0..1024 for isochronous endpoints and 1..1042 for an interrupt
> endpoint." Since bMuxBurst default is 0 we decided to leave this fields
> value as it was in the HighSpeed descriptor.

Ok.  I suppose whatever gadget application is being used can reset these
values later?  So that if you had a gadget webcam, it could set the
wMaxPacketSize to the frame size or whatever it needed?

> >> +	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
> >> +	ss_cap->bU1devExitLat = 0;
> >> +	ss_cap->bU2DevExitLat = 0;
> >
> > Are you really sure you want to set the exit latency for low power
> > states to less than 1 microsecond?  Without real hardware it would be
> > difficult to test, but this seems overly optimistic.
> 
> We will set it to the maximum value according to the USB30 spec:
> ss_cap->bU1devExitLat = 0x0A (less then 10 microsec)
> ss_cap->bU2DevExitLat = 0x07FF (less then 2047 microsec)

That will give you *horrible* power management.  The whole point of the
link power management is to allow the device to go to sleep between
packets.  Pick some non-zero, lower default.

How are you going to implement link power management on the gadget side,
btw?  I know that the Linux USB host side doesn't support link PM yet,
but if it did, how would the gadget power down pieces of itself when it
receives a link PM request?  Do you need some hooks that specific
hardware implementations can register with the gadget interface?

Sarah Sharp
