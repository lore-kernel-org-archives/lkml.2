Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0KVKbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:31:41 -0500
Received: from mxvs2.esa.t-systems.com ([81.7.202.143]:40759 "EHLO
	mxvs2.esa.t-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0KVKbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:31:40 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 05:31:39 EST
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] USB: g_serial: Allow to override the default VID/PID
Date: Mon, 22 Nov 2010 11:20:55 +0100
Message-ID: <D6DB9C7EDECDA944B870F62B587008622C8A42@NL-EXC-06.intra.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: g_serial: Allow to override the default VID/PID
Thread-Index: AcuJBybGYHIuh6MbToOKmvoI7XQy4wBFfRHQ
References: <4CE6F807.1090607@telenet.be> <1290209554-7026-1-git-send-email-jefdriesen@telenet.be> <20101120001247.GB17421@kroah.com> <4CE853BF.80504@telenet.be>
From: "Robert Lukassen" <Robert.Lukassen@tomtom.com>
To: "Jef Driesen" <jefdriesen@telenet.be>, "Greg KH" <greg@kroah.com>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Nov 2010 10:20:55.0549 (UTC) FILETIME=[F2B862D0:01CB8A2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just revisited the patch I submitted and I can see that it needs 
fixing. The intention of the patch was to provide the idVendor & 
idProduct kernel module parameter overrides to the individual 
functions at 'bind()' time. Prior to the patch, the overrides were 
done after the bind, making it hard for individual functions to 
determine the correct value for idVendor (some functions may need 
to use that value, e.g. USB audio when it registers itself
as an ALSA device; it would want to use the same Vendor id).

The patch makes sure that that happens, however, right after the bind()
the patched values are lost due to the copying of the gadget specific
device descriptor. Here's the snippet from 2.6.34:

 999        usb_gadget_set_selfpowered(gadget);
1000

1001        /* interface and string IDs start at zero via kzalloc.
1002         * we force endpoints to start unassigned; few controller
1003         * drivers will zero ep->driver_data.
1004         */
1005        usb_ep_autoconfig_reset(cdev->gadget);
1006
1007        /* composite gadget needs to assign strings for whole device (like
1008         * serial number), register function drivers, potentially update
1009         * power state and consumption, etc
1010         */
1011        status = composite->bind(cdev);
1012        if (status < 0)
1013                goto fail;
1014
1015        cdev->desc = *composite->dev;
1016        cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
1017
1018        /* standardized runtime overrides for device ID data */
1019        if (idVendor)
1020                cdev->desc.idVendor = cpu_to_le16(idVendor);
1021        if (idProduct)
1022                cdev->desc.idProduct = cpu_to_le16(idProduct);
1023        if (bcdDevice)
1024                cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
1025

In line 1015, the composite device descriptor is copied to the cdev->desc
field. Then the values get patched.

My patch just moved lines 1018-1024, so that the functions could access
the patched values. The ill side effect is that these patched values
are lost when the *composite->dev (== device descriptor) is copied 
in line 1015.

It would seem that the patch should also have moved lines 1015-1016 in front 
of the composite->bind(cdev) call.

It would require all composite gadgets (such as serial.c) and all functions
(such as f_acm.c) to do any modifications to the device descriptor as passed 
to them in the 'bind' call. For functions that is natural, as they should be
unaware of the gadget that uses them. 

The composite gadgets such as 'serial' seem to deal with it differently.
The serial.c gadget refers to the device descriptor as 'device_desc', and it
is a static struct. It references it in its 'init' function (which is ok, it is
prior to the registration point) and in the gs_bind() call. At that point it should
probably not be using 'device_desc', but cdev->desc.

I think we can go one of two ways. I'd be happy to go over the composite gadgets and 
change their use of their device descriptors, such that they use cdev->desc at
bind() time. Combining that with the moving the copying of the *composite->dev
to before calling 'composite->bind()' would make things consistent.

The other way is reverting my original patch. For those functions that need access
to the overridden idVendor/idProduct code, we'll need to work out another
(generic) solution.

Robert 

> -----Original Message-----
> From: Jef Driesen [mailto:jefdriesen@telenet.be] 
> Sent: Sunday, November 21, 2010 12:03 AM
> To: Greg KH
> Cc: Robert Lukassen; David Brownell; Greg Kroah-Hartman; 
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB: g_serial: Allow to override the 
> default VID/PID
> 
> On 20/11/10 01:12, Greg KH wrote:
> > On Sat, Nov 20, 2010 at 12:32:34AM +0100, Jef Driesen wrote:
> >> Override the default VID/PID if custom values are supplied through 
> >> the idVendor and idProduct kernel module parameters.
> >>
> >> Signed-off-by: Jef Driesen<jefdriesen@telenet.be>
> >
> > So this patch resolves the bug found in
> > 1ab83238740ff1e1773d5c13ecac43c60cf4aec4 which showed up in 
> .35-rc1, 
> > right?
> 
> Yes, although I'm really sure it is the best way to fix the 
> problem. The way I understand this code is that before that 
> commit, the idVendor/idProduct/bcdDevice module parameters 
> where set after the bind(). Thus whatever was set as the 
> default there got replaced with the values of the module 
> parameters. Exactly what I would consider the correct 
> behavior. After the commit, they get set before bind(), where 
> they are changed back to the hardcoded values, which I think 
> is wrong. My patch sets them back to the right values, but 
> maybe it makes more sense to not set the default values in 
> the first place (if there are already values in place of 
> course). But I didn't knew how to accomplish that.
> 
> There might be similar problems for the other gadget drivers 
> as well. I haven't checked that.
> 
> >> ---
> >>   drivers/usb/gadget/serial.c |    5 +++++
> >>   1 files changed, 5 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/usb/gadget/serial.c 
> >> b/drivers/usb/gadget/serial.c index f46a609..77b410e 100644
> >> --- a/drivers/usb/gadget/serial.c
> >> +++ b/drivers/usb/gadget/serial.c
> >> @@ -271,6 +271,11 @@ static int __init init(void)
> >>   	}
> >>   	strings_dev[STRING_DESCRIPTION_IDX].s = 
> >> serial_config_driver.label;
> >>
> >> +	if (idVendor)
> >> +		device_desc.idVendor = idVendor;
> >> +	if (idProduct)
> >> +		device_desc.idProduct = idProduct;
> >> +
> >>   	return usb_composite_register(&gserial_driver);
> >>   }
> >>   module_init(init);
> >> --
> >> 1.7.1
> 
