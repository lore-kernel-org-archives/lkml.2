Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0LFIKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:10:02 -0500
Received: from mxvs2.esa.t-systems.com ([81.7.202.143]:40348 "EHLO
	mxvs2.esa.t-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0LFIKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:10:00 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] USB: g_serial: Allow to override the default VID/PID
Date: Mon, 6 Dec 2010 09:09:55 +0100
Message-ID: <D6DB9C7EDECDA944B870F62B587008622C8A4D@NL-EXC-06.intra.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: g_serial: Allow to override the default VID/PID
Thread-Index: AcuTNsabr7QSTVJ7TL2Oar0SB60bdAB5ahag
References: <4CE6F807.1090607@telenet.be> <1290209554-7026-1-git-send-email-jefdriesen@telenet.be> <20101120001247.GB17421@kroah.com> <4CE853BF.80504@telenet.be> <D6DB9C7EDECDA944B870F62B587008622C8A42@NL-EXC-06.intra.local> <20101130174605.GC19977@kroah.com> <4CF96A9D.8070800@telenet.be>
From: "Robert Lukassen" <Robert.Lukassen@tomtom.com>
To: "Jef Driesen" <jefdriesen@telenet.be>, "Greg KH" <greg@kroah.com>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Dec 2010 08:09:55.0466 (UTC) FILETIME=[F78766A0:01CB951C]
X-NAIMIME-Disclaimer: 1
X-NAIMIME-Modified: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yes, providing access to those module parameters was the original goal. I agree that my patch should be reverted and I'll try to come up with a method of accessing these values without violating the information hiding principles too much. I don't like accessing globals.

Robert

> -----Original Message-----
> From: Jef Driesen [mailto:jefdriesen@telenet.be] 
> Sent: Friday, December 03, 2010 11:10 PM
> To: Greg KH
> Cc: Robert Lukassen; David Brownell; Greg Kroah-Hartman; 
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB: g_serial: Allow to override the 
> default VID/PID
> 
> On 30/11/10 18:46, Greg KH wrote:
> > On Mon, Nov 22, 2010 at 11:20:55AM +0100, Robert Lukassen wrote:
> >> Hi,
> >>
> >> I just revisited the patch I submitted and I can see that it needs 
> >> fixing. The intention of the patch was to provide the idVendor& 
> >> idProduct kernel module parameter overrides to the individual 
> >> functions at 'bind()' time. Prior to the patch, the overrides were 
> >> done after the bind, making it hard for individual functions to 
> >> determine the correct value for idVendor (some functions 
> may need to 
> >> use that value, e.g. USB audio when it registers itself as an ALSA 
> >> device; it would want to use the same Vendor id).
> >>
> >> The patch makes sure that that happens, however, right after the 
> >> bind() the patched values are lost due to the copying of 
> the gadget 
> >> specific device descriptor. Here's the snippet from 2.6.34:
> >>
> >>   999        usb_gadget_set_selfpowered(gadget);
> >> 1000
> >>
> >> 1001        /* interface and string IDs start at zero via kzalloc.
> >> 1002         * we force endpoints to start unassigned; few 
> controller
> >> 1003         * drivers will zero ep->driver_data.
> >> 1004         */
> >> 1005        usb_ep_autoconfig_reset(cdev->gadget);
> >> 1006
> >> 1007        /* composite gadget needs to assign strings 
> for whole device (like
> >> 1008         * serial number), register function drivers, 
> potentially update
> >> 1009         * power state and consumption, etc
> >> 1010         */
> >> 1011        status = composite->bind(cdev);
> >> 1012        if (status<  0)
> >> 1013                goto fail;
> >> 1014
> >> 1015        cdev->desc = *composite->dev;
> >> 1016        cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
> >> 1017
> >> 1018        /* standardized runtime overrides for device ID data */
> >> 1019        if (idVendor)
> >> 1020                cdev->desc.idVendor = cpu_to_le16(idVendor);
> >> 1021        if (idProduct)
> >> 1022                cdev->desc.idProduct = cpu_to_le16(idProduct);
> >> 1023        if (bcdDevice)
> >> 1024                cdev->desc.bcdDevice = cpu_to_le16(bcdDevice);
> >> 1025
> >>
> >> In line 1015, the composite device descriptor is copied to the 
> >> cdev->desc field. Then the values get patched.
> >>
> >> My patch just moved lines 1018-1024, so that the functions could 
> >> access the patched values. The ill side effect is that 
> these patched 
> >> values are lost when the *composite->dev (== device descriptor) is 
> >> copied in line 1015.
> >>
> >> It would seem that the patch should also have moved lines 
> 1015-1016 
> >> in front of the composite->bind(cdev) call.
> >>
> >> It would require all composite gadgets (such as serial.c) and all 
> >> functions (such as f_acm.c) to do any modifications to the device 
> >> descriptor as passed to them in the 'bind' call. For 
> functions that 
> >> is natural, as they should be unaware of the gadget that uses them.
> >>
> >> The composite gadgets such as 'serial' seem to deal with 
> it differently.
> >> The serial.c gadget refers to the device descriptor as 
> 'device_desc', 
> >> and it is a static struct. It references it in its 'init' function 
> >> (which is ok, it is prior to the registration point) and in the 
> >> gs_bind() call. At that point it should probably not be 
> using 'device_desc', but cdev->desc.
> >>
> >> I think we can go one of two ways. I'd be happy to go over the 
> >> composite gadgets and change their use of their device 
> descriptors, 
> >> such that they use cdev->desc at
> >> bind() time. Combining that with the moving the copying of the 
> >> *composite->dev to before calling 'composite->bind()' 
> would make things consistent.
> >>
> >> The other way is reverting my original patch. For those functions 
> >> that need access to the overridden idVendor/idProduct code, we'll 
> >> need to work out another
> >> (generic) solution.
> >
> > So, do you want me to revert your original patch and wait 
> for you to 
> > come up with a "better" solution?
> >
> > That seems like the correct thing to do at the moment.
> 
> If the original commit is reverted, the idVendor and 
> idProduct module parameters can still be accessed through the 
> global variables directly (like I did in my own pathc). Since 
> access to those values appears to be the main goal of the 
> patch, I think no functionality will be lost by reverting the commit.
> 


This e-mail message contains information which is confidential and may be privileged. It is intended for use by the addressee only. If you are not the intended addressee, we request that you notify the sender immediately and delete or destroy this e-mail message and any attachment(s), without copying, saving, forwarding, disclosing or using its contents in any other way. TomTom N.V., TomTom International BV or any other company belonging to the TomTom group of companies will not be liable for damage relating to the communication by e-mail of data, documents or any other information.
