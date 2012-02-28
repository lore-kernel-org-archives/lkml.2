Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2B1QvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:51:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41301 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753075Ab2B1QvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:51:04 -0500
Date: Tue, 28 Feb 2012 11:51:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>,
        <kevin.wells@nxp.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
In-Reply-To: <201202281553.41332.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1202281107260.1456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012, Arnd Bergmann wrote:

> On Tuesday 28 February 2012, Alan Stern wrote:
> > It's heading in the intended direction, although the details might not 
> > all be quite right -- I didn't check them very closely.
> > 
> > One big thing about it is wrong: Many or most of the functions you
> > exported don't really need to be.  Instead, ohci-hcd.c should define
> > ohci_driver (a bus-agnostic hc_driver structure) and export that.  
> > Then the bus-glue files can copy the structure for their own use during
> > initialization (rather than duplicating the definition all over the
> > place) and override individual methods as needed.
> > 
> > It's a more "object-oriented" approach.  :-)
> 
> Yes, that makes sense. I did not try to actually understand how the
> driver works internally, just tried the mechanical conversion in a way
> that did not require changing any code besides the sb800_prefetch
> function that had to be moved.
> 
> There are still a few symbols that are used by most or all hw specific
> drivers and that will have to remain exported:
> 
> ohci_init, ohci_run, ohci_stop, ohci_finish_controller_resume, and
> ohci_hcd_init

Let's see.  ohci-hcd should get a new bus-agnostic ohci_start routine.  
This would call ohci_run internally, so the bus-glue files wouldn't
need to know about it.

Similarly, ohci_init and ohci_hcd_init could perhaps become part of a
bus-agnostic ohci_reset routine.  Both ohci_start and ohci_reset would
be stored as fields in the ohci_driver structure, so they wouldn't need
to be exported.

On the other hand, ohci_finish_controller_resume really does need to be
exported; I don't see any way around that.

> And then there are a few symbols that are only used by one or two
> drivers, possibly correctly or not:
> 
> ohci_dump (spear)

That's for debugging.  Okay to export, although I don't know that the 
spear driver actually needs it.

> ohci_usb_reset (at91, pci)

Not sure about this one...

> ohci_shutdown (ps3)

This will be stored as the .shutdown field in ohci_driver.

> ohci_restart (pci)

This one appears to be present just to handle a quirk of the NEC chip.  
As such it ought to be moved entirely into ohci-pci.c.

> ohci_hub_control (da8xx)

This will be stored in ohci_driver.

> These ones do not need to get exported following your suggestion:
> 
> ohci_urb_enqueue, ohci_urb_dequeue, ohci_endpoint_disable,
> ohci_get_frame, ohci_irq, ohci_bus_suspend, ohci_bus_resume,
> ohci_hub_status_data, and ohci_start_port_reset
> 
> I would do implementation the other way round and let the bus specific
> driver provide a sparsely populated version of struct hc_driver
> that is completed by a function in the common ohci parts. That would
> keep the logicto combine the two in one place rather than duplicating
> it everywhere, but it's a bit more overhead in the case where you
> build only a single bus glue.
> 
> Certainly either way is possible, whichever you prefer.

It's almost bikeshedding...

I like the idea of exporting ohci_driver, because then its member
methods don't have to be exported.  Instead of calling
ohci_hub_control() directly, a bus-glue file can override it and then
internally invoke (ohci_driver->hub_control)().

In theory we could do both: export ohci_driver _and_ export a routine
to overwrite the uninitialized fields of a different structure with the
corresponding fields from ohci_driver.  On the other hand, that routine
would look pretty mind-numbing:

	if (!drv->reset)
		drv->reset = ohci_driver.reset;
	if (!drv->start)
		drv->start = ohci_driver.start;
	if (!drv->stop)
		drv->stop = ohci_Driver.stop;
	...

My preference is to have the bus-glue files do an explicit structure 
copy and then overwrite by hand the fields that need to be changed.  
The number of overrides in each file will be pretty small.

Alan Stern

