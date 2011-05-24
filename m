Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1EXFvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:51:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30301 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1EXFvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:51:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93190059"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <BD27AEAC-1E6D-480C-9E18-A970B992AD75@ti.com> <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Tue, 24 May 2011 08:53:15 +0300
Message-ID: <00ed01cc19d6$e1fef520$a5fcdf60$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZkAI2eXBdrKQhQ7WzFOVFCUr6YgARbWNA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > With Tatyana's patches, if we load a USB2 g_zero to dummy_hcd,
> enumeration
> > will fail where it shouldn't. This has been my whole point ;-) Maybe
> I wasn't
> > clear enough.
> 
> I guess not.  I thought Tatyana said she was working to fix that bug...

This bug is fixed with the module parameter. When dummy_hcd is loaded it
registers 2 root hubs: HS & SS but unless the is_super_speed parameter is
true, the device will be connected to the HS hub. This way when loading HS
g_zero  it enumerates under HS root hub successfully. 
Note that if load SS gadget without setting is_super_speed=true for dummy
hcd, it will also enumerate under HS hub! This is basically a way to test
that SS devices are backward compatible.

> > >> What about the case where SuperSpeed enumeration
> > >> fails and you have to fall back to high speed?
> > >
> > > If SuperSpeed enumeration fails, say because the device doesn't
> have
> > > any SuperSpeed descriptors, xhci-hcd doesn't fall back to high
> speed,
> > > does it?  dummy-hcd should behave the same way.
> >
> > it should at least. Isn't that what happens between EHCI/OHCI ? HS
> Chirp
> > sequencing fails, then we fall back to FullSpeed.
> 
> That's a failure in initialization, not a failure in enumeration.
> 
> There are two reasons why the HS chirp might fail: the device doesn't
> support high speed operation or hardware errors prevent the chirp from
> working.  With dummy-hcd there are no hardware errors (because there's
> no hardware).
> 
> As for whether or not the device supports high-speed or SuperSpeed
> operation, that's determined by the usb_gadget_driver->speed field.  If
> the field doesn't specify SuperSpeed then dummy-hcd should connect the
> gadget to the USB-2 root hub rather than the USB-3 root hub.  Isn't
> that what Tatyana's patch does?  It contains a line saying:
> 
> 		dum->gadget.speed = driver->speed;


You're right. This is exactly what is done with a small update: if
is_super_speed=false the gadget will connect to a USB2 root hub even if 
driver->speed=USB_SPEED_SUPER. In that case dum->gadget.speed will be set to
USB_SPEED_HIGH. The code that sets this now is:
	if (mod_data.is_super_speed)
		dum->gadget.speed = driver->speed;
	else
		dum->gadget.speed = min((u8)USB_SPEED_HIGH,
(u8)driver->speed);
	if (dum->gadget.speed < driver->speed)
		dev_dbg(udc_dev(dum), "This device can perform faster if"
				      " you connect it to a "
				      "SupeSpeed port...\n");


> > >> It seems like you really
> > >> need to handle both speeds and the speed fall back parameter in
> the same
> > >> driver.  Isn't there some other gadget driver that has a fall back
> to
> > >> full or low speed when high speed enumeration fails?
> > >
> > > That's a property of the gadget driver, not the UDC driver.  dummy-
> hcd
> > > is a UDC driver (and an HCD too).
> >
> > USB3.0 dummy_hcd should still enumerate USB2.0 gadget drivers.
> 
> Yes, certainly it should.  If it doesn't, that's a bug, not a design
> error.
> 

This version of dummy_hcd enumerates HS devices without any issues.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




