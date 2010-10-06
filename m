Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab0JFJQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:16:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45798 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab0JFJQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:16:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56779219"
Message-ID: <207c0a821ef60e21a605f0b45c2d3777.squirrel@www.codeaurora.org>
In-Reply-To: <20101005181126.GB7383@xanatos>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
    <20101004072602.GB2256@xanatos>
    <0daac081a669f0cc8e024644f223c0c2.squirrel@www.codeaurora.org>
    <20101005181126.GB7383@xanatos>
Date: Wed, 6 Oct 2010 02:16:41 -0700 (PDT)
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the 
     Gadget Framework
From: tlinder@codeaurora.org
To: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Cc: tlinder@codeaurora.org, linux-usb@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Robert Lukassen" <robert.lukassen@tomtom.com>,
        "Matthew Wilcox" <willy@linux.intel.com>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 05, 2010 at 04:53:40AM -0700, tlinder@codeaurora.org wrote:
>> > Hi Tatyana,
>> >
>> > Comments inline.  I'm not familiar with the gadget framework; I'm just
>> > curious about some descriptor choices.
>> >
>> > On Sun, Oct 03, 2010 at 10:02:15AM +0200, tlinder wrote:
>> >> +/** Default endpoint companion descriptor */
>> >> +static struct usb_ss_ep_comp_descriptor ep_comp_desc = {
>> >> +		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
>> >> +		.bLength = 0x06,
>> >> +		.bMaxBurst = 0, /*the default is we don't support bursting*/
>> >> +		.bmAttributes = 0, /*2^0 streams supported*/
>> >> +		.wBytesPerInterval = 0,
>> >> +};
>> >
>> > Can you please set wBytesPerInterval to something sane for periodic
>> > endpoints?  Perhaps have it set to the maximum packet size times the
>> max
>> > burst size times Mult plus one, or less if the device *knows* it's
>> going
>> > to send less data.  It's used for xHC host controller scheduling, so
>> > it's important to get right for maximum bandwidth usage.
>>
>> This descriptor holds default values so both bMaxBurst and bmAttributes
>> are set to 0, meaning bursting and streaming are not not supported. So
>> Mult will be set to 0 as well. Mult defined only for iso endpoints and
>> not
>> for interrupt.
>> Due to the above I propose setting wBytesPerInterval to maxpacketsize
>> for
>> periodic endpoints.
>
> Sounds good.
>
>> >> +	while (*src) {
>> >> +		/*Copy the original descriptor*/
>> >> +		memcpy(mem, *src, (*src)->bLength);
>> >> +		switch ((*src)->bDescriptorType) {
>> >> +		case USB_DT_ENDPOINT:
>> >> +			/*update ep descriptor*/
>> >> +			ep_desc = (struct usb_endpoint_descriptor *)mem;
>> >> +			switch (ep_desc->bmAttributes &
>> >> +				USB_ENDPOINT_XFERTYPE_MASK) {
>> >> +			case USB_ENDPOINT_XFER_CONTROL:
>> >> +				ep_desc->wMaxPacketSize = 512;
>> >> +				ep_desc->bInterval = 0;
>> >> +				break;
>> >> +			case USB_ENDPOINT_XFER_BULK:
>> >> +				ep_desc->wMaxPacketSize = 1024;
>> >> +				ep_desc->bInterval = 0;
>> >> +				break;
>> >> +			case USB_ENDPOINT_XFER_INT:
>> >> +			case USB_ENDPOINT_XFER_ISOC:
>> >
>> > Why are you not setting wMaxPacketSize for periodic endpoints?  Does
>> it
>> > get set later?  (I can't tell from this snippet.)
>>
>> It's not set later. According to the USB30 Spec Table 9-18, the
>> description of wMaxPacketSize for interrupt and iso endpoints:
>> "..if bMuxBurst field is set to zero then this field can have any value
>> from 0..1024 for isochronous endpoints and 1..1042 for an interrupt
>> endpoint." Since bMuxBurst default is 0 we decided to leave this fields
>> value as it was in the HighSpeed descriptor.
>
> Ok.  I suppose whatever gadget application is being used can reset these
> values later?  So that if you had a gadget webcam, it could set the
> wMaxPacketSize to the frame size or whatever it needed?

Yes but resetting it later in the SuperSpeed descriptor will be a bit
complicated. A better approach will be setting the desired values in the
HighSpeed descriptors. This way they will be copied to the SuperSpeed
descriptors automatically.

>
>> >> +	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
>> >> +	ss_cap->bU1devExitLat = 0;
>> >> +	ss_cap->bU2DevExitLat = 0;
>> >
>> > Are you really sure you want to set the exit latency for low power
>> > states to less than 1 microsecond?  Without real hardware it would be
>> > difficult to test, but this seems overly optimistic.
>>
>> We will set it to the maximum value according to the USB30 spec:
>> ss_cap->bU1devExitLat = 0x0A (less then 10 microsec)
>> ss_cap->bU2DevExitLat = 0x07FF (less then 2047 microsec)
>
> That will give you *horrible* power management.  The whole point of the
> link power management is to allow the device to go to sleep between
> packets.  Pick some non-zero, lower default.
I've consulted out HW team and we came up with the flowing solution:
These values are determined by the controller and the PHY. The gadget SW
has no impact on them what so ever. Therefore, we will add another
callback to gadget_ops that will retrieve these values from the DCD. If
this callback is not supplied we will report the flowing default values:
ss_cap->bU1devExitLat = 0x01 (less then 1 microsec)
ss_cap->bU2DevExitLat = 0x1F4 (less then 500 microsec)

>
> How are you going to implement link power management on the gadget side,
> btw?  I know that the Linux USB host side doesn't support link PM yet,
> but if it did, how would the gadget power down pieces of itself when it
> receives a link PM request?  Do you need some hooks that specific
> hardware implementations can register with the gadget interface?
Link power management is mostly implemented by the DCD and not the gadget.
Once it will be implemented necessary changes will be applied to the
gadget framework as well.

> Sarah Sharp
>


