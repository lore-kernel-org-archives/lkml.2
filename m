Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0JGPwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:52:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51470 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab0JGPwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:52:42 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Oct 2010 21:22:32 +0530
Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Topic: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Index: ActmN0SnfyL4J6bhRreUT8WzfvuVdAAAB51w
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D1C1@dbde02.ent.ti.com>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
	 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
	 <1286445948.6145.70.camel@aeonflux>
	 <19F8576C6E063C45BE387C64729E739404AA21D19E@dbde02.ent.ti.com>
	 <1286464659.6145.144.camel@aeonflux>
	 <19F8576C6E063C45BE387C64729E739404AA21D1B4@dbde02.ent.ti.com>
	 <1286465843.6145.157.camel@aeonflux>
	 <19F8576C6E063C45BE387C64729E739404AA21D1BD@dbde02.ent.ti.com>
 <1286466576.6145.161.camel@aeonflux>
In-Reply-To: <1286466576.6145.161.camel@aeonflux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Marcel Holtmann [mailto:marcel@holtmann.org]
> Sent: Thursday, October 07, 2010 10:50 AM
> To: Savoy, Pavan
> Cc: linux-bluetooth@vger.kernel.org; johan.hedberg@gmail.com; greg@kroah.com;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
> 
> Hi Pavan,
> 
> > > > > > > Registering the Bluetooth HCI driver in module_init/module_exit is
> not
> > > > > > > acceptable. Turn your shared transport into a proper bus.
> > > > > >
> > > > > > Yes, you did comment on it before, I remember, I did prototype the
> > > driver as
> > > > > > a bus driver, However I didn't find any advantages by converting it
> to a
> > > bus
> > > > > > driver.
> > > > > > As in, currently the shared transport driver is a line discipline
> driver
> > > > > because
> > > > > > it is the only way it can communicate over TTY without being tightly
> > > coupled
> > > > > with the UART driver.
> > > > > >
> > > > > > > We want to be able to have generic kernels where this module is
> > > enabled,
> > > > > > > but no Shared Transport is available.
> > > > > >
> > > > > > Oh if this is the reason I cannot have hci_register/_unregister in
> > > > > module_init/_exit, Can I do this module "depends" on TI_ST, Then it
> would
> > > not
> > > > > > even be visible to build if TI_ST is not selected.
> > > > >
> > > > > this is not helping either. Then TI_ST can not be selected and so you
> > > > > still end up with some weird platform specific kernels. We don't want
> > > > > that. We want generic kernels that can detect the hardware they are
> > > > > running on.
> > > > >
> > > > > As I said, I will not accept this driver if it registers HCI device in
> > > > > module_init. No other driver is doing this and it is in general a
> really
> > > > > really really bad idea.
> > > > >
> > > >
> > > > Ok, now I am beginning to get what you say, Let me check, may be what
> > > > I can do is, have something like a st_prepare() function called in the
> > > > module_init, and a _probe function of the bluetooth driver will be
> called,
> > > > _ONLY_ if the _probe of my platform driver has been called..
> > > > Do you think this would be a good idea?
> > > >
> > > > Note: the TI_ST driver is also a platform device driver, so that TI_ST's
> > > > Probe is not called, if a arch/xx/board-xx doesn't add it.
> > >
> > > that that should be your bus right there.
> >
> > I understand the perspective, but "bus" is not device-driver type of model
> right? I mean I need a device which will be added in some platform specific
> > board file, and the driver in my driver core file.
> >
> > > Let me repeat this. If you register the HCI device in module_init then
> > > it will be registered on all platform this module is selected. Even if
> > > the kernel runs on x86. And that is not acceptable. Registering devices
> > > in module_init is a bad idea no matter what. That is why all other
> > > drivers just register a driver here and not a device.
> >
> > I did initially think about making each of the protocol drivers a
> > platform devices as well.
> > As in Bluetooth/FM/GPS TI_ST driver would also be a platform device and its
> _probe doing the HCI/v4L2/character device registration.
> >
> > So which one do you think makes more sense here?
> > 1. Do I EXPORT a new symbol called st_prepare? And allow hci registration
> there?
> >
> > 2. Or make Bluetooth device a platform device and this driver a platform
> driver
> > and add this Bluetooth device only when I add TI_ST platform device?
> 
> then make them a platform device. Since you do need a proper parent for
> these devices anyway. Otherwise a lot of logic within sysfs will fail.

Hnm, OK, Thanks. This also sort of helps me out in future if I wanted to support
multiple TI_ST devices (very hypothetical)

Ok, I will send out a patch for this. I will also make sure the patch I send
would be for addition of driver as you suggested and not to move from staging.

Thanks,
Pavan.

> Regards
> 
> Marcel
> 

