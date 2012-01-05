Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab2AEUF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:05:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab2AEUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:05:22 -0500
Date: Thu, 5 Jan 2012 12:05:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
Message-ID: <20120105200515.GA1071@core.coreip.homeip.net>
References: <20120105180123.GA8035@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1201051323110.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051323110.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 01:55:41PM -0500, Alan Stern wrote:
> On Thu, 5 Jan 2012, Dmitry Torokhov wrote:
> 
> > > To fix these problems, we need to change the semantics of get_driver()  
> > > and put_driver().  Instead of taking a reference to the driver
> > > structure, get_driver() should check whether the driver is currently
> > > registered.  If not, return NULL; otherwise, pin the driver (i.e.,
> > > block it from being unregistered) until put_driver() is called.
> > 
> > Or maybe we should just drop get_driver() and put_driver() and just make
> > sure that driver_attach() does not race with driver_unregister()?
> 
> If that could be done, it would be best.  But I'm not sure it can be 
> done, at least, not without adding a significant amount of mutual 
> exclusion.

So I looked at the users of device_attach():

- we call it from generic bus code when adding a new driver so naturally
  driver is valid there;
- serio and gameport call it by hand but they ensure that the driver is
  valid because they protected by subsystem-private mutex;
- PCI, PCMCI, HID and USB new_id handling is tied to the driver itself
  and attributes are removed when driver is unregistered so there is no
  chance driver will be attached through newid after it has been
  unregistered;
- agp_amd64_init calls it once immediately after registering the driver;
- pci-stub driver is safe as well.

That leaves only usb-serial which is problematic exactly as you
described below. So I think we should remove get_driver() and
put_driver(); document that caller if driver_attach() should ensure
that driver is live and let usb-serial code solve this issue as this
is the only code that plays games with drivers it does not own.

> 
> In the USB serial core, for example, the problem arises because the
> usb_serial_driver is always registered _before_ the corresponding
> usb_driver.  Changing the order would fix the problem, but I don't know
> if there's some good reason for the way it's done now.  Greg is more
> familiar with that code than I am; maybe he knows.
> 
> (The underlying issue is that the store_new_id method for one driver
> ends up calling driver_attach() for the other driver.  You can see how
> this easily leads to races.  Adding a mutex could also solve the
> problem, at the price of allowing only one USB driver to be registered
> at a time.)
> 
> > I think pinning driver so that it can't be unregistered (and
> > consequently module unload hangs) its a mis-feature.
> 
> I suspect that references obtained from get_driver() aren't held very 
> long.  However I haven't checked every case.

Unless we stop exporting them we can not make any assumptions on how
long they will be held - code is changing constantly.

> 
> > > One more thing.  The new_id sysfs attribute can cause problems of its 
> > > own.  Writes to it cause a dynamic ID structure to be allocated, and 
> > > these structures will leak unless they are properly deallocated.  
> > > Normally they are freed when the driver is unregistered.  But what if 
> > > registration fails to begin with?  It might fail at a point after the 
> > > new_id attribute was created, which means the attribute could have been 
> > > written to.  The dynamic IDs need to be freed after registration fails, 
> > > but nobody does this currently.
> > > 
> > 
> > Don't we create corresponding sysfs attributes only after driver
> > successfully registered?
> 
> No, some attribute files are created during registration;
> driver_register() calls driver_add_groups().

But new_id only created by individual bus code after registering the
driver. No individual drivers involved here.

> 
> > And attributes are the only way to add (and
> > thus allocate) new ids so I do not see why we'd be leaking here.
> 
> Here's one example of what can happen:
> 
> 	A module calls driver_register()
> 
> 	The registration routine creates the
> 	new_id sysfs attribute
> 
> 					A udev process writes to the 
> 					new_id attribute, causing a
> 					dynamic_id structure to be
> 					allocated
> 
> 	Creation of some other attribute fails
> 
> 	The new_id attribute is removed and
> 	driver_register() returns an error
> 
> At the end the driver isn't registered, but the dynamic_id structure 
> has been allocated and will never be freed.
> 
> Another example, taken from drivers/pci/pci-driver.c:
> 
> 	__pci_register_driver() calls
> 	driver_register()
> 
> 	pci_create_newid_file() creates the new_id
> 	sysfs attribute
> 
> 					A udev process writes to the 
> 					new_id attribute, causing a
> 					dynamic_id structure to be
> 					allocated
> 
> 	pci_create_removeid_file() fails
> 
> 	__pci_register_driver() calls
> 	pci_remove_newid_file() and
> 	driver_unregister(), but it doesn't
> 	call pci_free_dynids()

So this is a simple bug in pci bus error unwinding code...

Thanks.

-- 
Dmitry
