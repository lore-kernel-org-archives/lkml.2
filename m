Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1EZGtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:49:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21755 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1EZGtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:49:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6357"; a="93759511"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>, <balbi@ti.com>
Cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <8ce4e30b4a406fadf08af2daff163984.squirrel@www.codeaurora.org> <Pine.LNX.4.44L0.1105251443040.1987-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105251443040.1987-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Thu, 26 May 2011 09:51:17 +0300
Message-ID: <01fc01cc1b71$53e2d210$fba87630$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwbDdZAAUNxedRMSrWtaK6R9FpGfgAX0Cgg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, Felipe,

> >  composite_driver.speed to USB_SPEED_SUPER.
> > >>
> > >> Not sure how to verify this. I need to know whether the driver
> that is
> > >> registered with the UDC is SS or not. This is before the function
> > >> drivers
> > >> are binded to it. So how can I verify at that point that the
> function
> > >> drivers that will bind to this driver will provide SS descriptors?
> > >> (I'm sorry, I don't have the ability to view the code at the
> moment and
> > >> due to the time differences between us I don't want to leave this
> > >> question
> > >> for tomorrow and loose another day...)
> > >
> > > I'm not sure about this either.  I have never used the composite
> > > framework so I'm not familiar with its details.  This has to be
> decided
> > > before the composite gadget driver registers with the UDC driver
> ...
> > Right, but at this point there is no way of knowing what function
> drivers
> > will bind to it and what descriptors they will provide. Most of the
> > function drivers allocate their descriptors at bind() that occurs
> after
> > the UDC already registers.
> 
> Well, there must be an appropriate spot to do this.

Unfortunately in the current implementation there isn't. We must set the
driver speed at usb_composite_probe(). 
The (not full) call stack for composite driver registration is:
1. usb_composite_probe()
2. usb_gadget_probe_driver()
3. composite_bind() - here the device descriptor is updated (fields such as
bMaxPacketSize0, idVendor, etc)
4. the gadgets "bind" function is called. For example for g_zero it's
zero_bind(). Only at this point will the function driver register it's
configurations and for each registered config - add the appropriate
functions. 
So as you can see, whether the gadget driver supports/or not SS can be
determined only at the end of the registration sequence, whether as far as
UDC is concerned, we need to set the correct driver speed at the very
beginning - at usb_composite_probe().

Felipe - please correct me if I'm mistaken. Is there a way to find out at
usb_composite_probe() if the registered function driver will support SS?

> It looks like you need to add a "max_speed" field to struct
> usb_composite_driver.  Each driver will initialize this to the highest
> speed it supports, and it must guarantee that the necessary descriptors
> are available.

I also thought of that. This can be done...
Just to make sure we're on the same page:
We can add a "max_sup_speed" field to struct usb_composite_driver. Each of
the Gadget drivers will set this field prior to calling
usb_composite_probe(). Then, in usb_composite_probe(), we'll update the
composite_driver.speed as follows:

	composite_driver.speed = min(composite_driver.speed,
driver->max_sup_speed);

Of course for SS we'll update the composite_driver.speed @ static struct
usb_gadget_driver composite_driver, as we agreed with Felipe.

How does that sound? Felipe - it seems to me that these should cover your
hesitations about updating the driver speed :)

Now that I think about it, the above will be true for HS as well. I mean the
current speed of composite_driver is set always to HS but if there is a
function driver that supports only FS then the above will update
composite_driver.speed to FS.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





