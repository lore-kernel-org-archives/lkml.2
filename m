Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2AESBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:01:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60846 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2AESBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:01:33 -0500
Date: Thu, 5 Jan 2012 10:01:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
Message-ID: <20120105180123.GA8035@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1201051035330.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051035330.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Jan 05, 2012 at 11:31:00AM -0500, Alan Stern wrote:
> Greg and Kay:
> 
> There are some nasty problems connected with the driver core's
> get_driver(), put_driver(), and driver_attach().  Not just
> implementation bugs, but deeper conceptual difficulties.
> 
> Let's start with get_driver().  Its comment says that it increments the 
> driver's refcount, just like get_device() and a lot of other utility 
> routines.
> 
> But a struct driver is _not_ like a struct device!  It resembles a
> piece of code more than a piece of data -- it acts as an encapsulation
> of a driver.  Incrementing its refcount doesn't have much meaning
> because a driver's lifetime isn't determined by the structure's
> refcount; it's determined by when the driver's module gets unloaded.
> 
> What really matters for a driver is whether or not it is registered.  
> Drivers expect, for example, that none of their methods will be called
> after driver_unregister() returns.  It doesn't matter if some other
> thread still holds a reference to the driver structure; that reference
> mustn't be used for accessing the driver code after unregistration.  
> And of course, driver_attach() does access the driver code, by calling 
> the probe routine.

Agree here.

> 
> An example where this is violated occurs in the usb-serial core.  Each
> serial driver module registers (at least) two driver structures, one on
> the usb_serial_bus and one on the usb_bus.  The usb_serial_driver
> structure contains a pointer to the usb_driver structure, and this
> pointer is passed to get_driver() when the serial driver's new_id sysfs
> attribute is written to.
> 
> Now, udev scripts are capable of writing to sysfs attributes very soon
> after the attribute is created.  In the case of USB serial drivers, we
> have a bug report of a situation where this write took place after the
> usb_serial_driver was registered but before the usb_driver was
> registered.  Thus, get_driver() was handed a pointer to a driver
> structure that had not even been initialized, let alone registered, and
> so naturally it crashed.
> 
> Almost as bad is what can happen when a driver is unregistered while
> some thread is holding a reference obtained from get_driver().  The
> reference prevents the driver structure from being freed, but it
> doesn't prevent the thread from calling driver_attach() after the
> unregistration is complete, at which time the driver code does not
> expect to be invoked.
> 
> To fix these problems, we need to change the semantics of get_driver()  
> and put_driver().  Instead of taking a reference to the driver
> structure, get_driver() should check whether the driver is currently
> registered.  If not, return NULL; otherwise, pin the driver (i.e.,
> block it from being unregistered) until put_driver() is called.

Or maybe we should just drop get_driver() and put_driver() and just make
sure that driver_attach() does not race with driver_unregister()?
I think pinning driver so that it can't be unregistered (and
consequently module unload hangs) its a mis-feature.

> 
> This will require some code auditing, because there are places where
> get_driver() is called without checking the return value (see
> drivers/pci/pci_driver.c:pci_add_dynid() for an example; there are
> others).  It should be marked __must_check.
> 
> Also, there are places that call driver_attach() without first calling
> get_driver() (see drivers/input/gameport/gameport.c,
> drivers/input/serio/serio.c, and drivers/char/agp/amd64-agp.c).  They
> may or may not be safe; I don't know.

Serio and gameport are safe as everyting is protected by serio_mutex so
it is not possible to yank the driver our while we are trying to attach
it to a device.

> 
> One more thing.  The new_id sysfs attribute can cause problems of its 
> own.  Writes to it cause a dynamic ID structure to be allocated, and 
> these structures will leak unless they are properly deallocated.  
> Normally they are freed when the driver is unregistered.  But what if 
> registration fails to begin with?  It might fail at a point after the 
> new_id attribute was created, which means the attribute could have been 
> written to.  The dynamic IDs need to be freed after registration fails, 
> but nobody does this currently.
> 

Don't we create corresponding sysfs attributes only after driver
successfully registered? And attributes are the only way to add (and
thus allocate) new ids so I do not see why we'd be leaking here.

Thanks.

-- 
Dmitry
