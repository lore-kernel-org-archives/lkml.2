Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2AEUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:48:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46659 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757073Ab2AEUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:48:21 -0500
Date: Thu, 5 Jan 2012 15:48:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
In-Reply-To: <20120105200515.GA1071@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1201051531410.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012, Dmitry Torokhov wrote:

> So I looked at the users of device_attach():
> 
> - we call it from generic bus code when adding a new driver so naturally
>   driver is valid there;
> - serio and gameport call it by hand but they ensure that the driver is
>   valid because they protected by subsystem-private mutex;
> - PCI, PCMCI, HID and USB new_id handling is tied to the driver itself
>   and attributes are removed when driver is unregistered so there is no
>   chance driver will be attached through newid after it has been
>   unregistered;
> - agp_amd64_init calls it once immediately after registering the driver;
> - pci-stub driver is safe as well.

Okay, that's all good.

> That leaves only usb-serial which is problematic exactly as you
> described below. So I think we should remove get_driver() and
> put_driver(); document that caller if driver_attach() should ensure
> that driver is live and let usb-serial code solve this issue as this
> is the only code that plays games with drivers it does not own.

If Greg confirms that there's nothing with registering the usb driver 
before the usb_serial driver, I can fix the usb-serial code easily.

Greg, do you know offhand whether this will break anything?  It really 
seems like the right thing to do, because the usb_serial driver uses 
the usb driver but not vice versa.


> > > Don't we create corresponding sysfs attributes only after driver
> > > successfully registered?
> > 
> > No, some attribute files are created during registration;
> > driver_register() calls driver_add_groups().
> 
> But new_id only created by individual bus code after registering the
> driver. No individual drivers involved here.

In usb/serial/bus.c, the usb_serial_bus_type structure contains a
.drv_attrs field with an entry for the new_id attribute.  Thus
driver_register calls bus_add_driver, which calls driver_add_attrs,
which creates the attribute file -- all during registration.

> > Another example, taken from drivers/pci/pci-driver.c:
> > 
> > 	__pci_register_driver() calls
> > 	driver_register()
> > 
> > 	pci_create_newid_file() creates the new_id
> > 	sysfs attribute
> > 
> > 					A udev process writes to the 
> > 					new_id attribute, causing a
> > 					dynamic_id structure to be
> > 					allocated
> > 
> > 	pci_create_removeid_file() fails
> > 
> > 	__pci_register_driver() calls
> > 	pci_remove_newid_file() and
> > 	driver_unregister(), but it doesn't
> > 	call pci_free_dynids()
> 
> So this is a simple bug in pci bus error unwinding code...

That was my point -- the places that use new_id attributes don't unwind 
their registration errors correctly.  Fortunately there aren't very 
many such places...

Alan Stern

