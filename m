Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab1E3RaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:30:23 -0400
Received: from xes-mad.com ([216.165.139.218]:6172 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab1E3RaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:30:20 -0400
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
From: Peter Tyser <ptyser@xes-inc.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>
In-Reply-To: <BANLkTin9Cy_emoFDs5hgw52ohbbPDKcN9w@mail.gmail.com>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
	 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
	 <20110527064238.GA31271@ponder.secretlab.ca>
	 <20110527110130.4b3448f2@endymion.delvare>
	 <1306506402.22090.14872.camel@petert>
	 <20110527205526.GJ6645@ponder.secretlab.ca>
	 <1306531794.10752.19.camel@ptyser-laptop>
	 <BANLkTin9Cy_emoFDs5hgw52ohbbPDKcN9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 12:27:58 -0500
Message-ID: <1306776478.2882.47.camel@ptyser-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 17:54 -0600, Grant Likely wrote:
> On Fri, May 27, 2011 at 3:29 PM, Peter Tyser <ptyser@xes-inc.com> wrote:
> >> > My own (completely biased) preference would be to use my driver as a
> >> > starting point, primarily because it supports newer chips that require
> >> > different access methods, as well as the older-style chips Jean's
> >> > supports.  Its also been hanging out for about 6 months without many
> >> > complaints, a tested-by, etc.
> >>
> >> I like the /structure/ of Jean's driver better, particularly that it doesn't
> >> play games with the device model by registering devices at module load
> >> time.
> >
> > But the driver shouldn't be a PCI driver - that's worse in my opinion
> > than a platform driver.  Multiple drivers currently use the same PCI
> > device ID as Jean's - they can't all claim the PCI device, so why should
> > Jean's GPIO driver?  It seems incorrect, and likely to break things in
> > the future.  Mine has its warts too, but it doesn't have the possibility
> > of negatively affect other drivers at least, as well as supports more
> > hardware.
> 
> Does it conflict with other drivers in the kernel right now?  If so,
> then I'll drop it.

It'd take some searching of where all the PCI vendor IDs in the new
patch are used.  I did a quick search of ICH7 and ESB2 IDs, and it
looked like:
Conflict:
- drivers/leds/leds-ss4200.c (also uses a PCI driver, also uses the GPIO
functionality of the chip)

Uses the same device, but no conflict:
- drivers/char/sonypi.c (uses platform driver)
- drivers/watchdog/iTCO_wdt.c (uses platform driver)
- drivers/mtd/maps/esb2rom.c (has PCI driver support commented out)

The same search would have to be performed for the other IDs to
determine if there are conflicts.  So there is one conflict, but its
probably not a huge deal because someone using leds-ss4200.c likely
wouldn't be using the ich GPIO driver as well.  leds-ss4200.c should
probably be converted to use the standard GPIO driver in the future.

However, if the above non-conflicting drivers did use the same PCI
driver model as the accepted GPIO patch, there would be conflicts -
that's what I don't care for.  The drivers above are considerate of the
fact that the device being used is a MFD while the Jean's driver is not.

I followed the iTCO_wdt.c and sonypi.c models for my driver in an
attempt to play nice with other drivers that might require the same PCI
device.

> Also, you're directly describing the use case for an MFD type device.
> I certainly expect either this driver or Jean's driver to be reworked
> into an MFD style device in the next cycle.

I was following the very "popular" iTCO_wdt.c driver model.  I'd hope
the current driver could be merged as it follows the current ICHx usage
pattern, and then they (and possibly other drivers) could all be
reworked at the same time into an MFD style driver.

> >> If one device performs more than one function, then it should
> >> register all the interfaces from a single probe, or go in the
> >> direction of MFD devices and register a bunch of child
> >> platform_devices.
> >
> > In this case its not really "one device performing more than one
> > function", its one device specifying the location of other devices.  The
> > device being claimed is used for FWH and IRQ configuration and happens
> > to have a pointer to a GPIO device (among other things).  Claiming it
> > for a GPIO device seems very wrong - it has very little to do with GPIO
> > at all.
> 
> Are you sure?  My reading of the ICH10 manual is that the GPIO
> controller is very much behind the LPC bridge, and that it is entirely
> appropriate for the GPIO controller device to be registered by the PCI
> driver as a child of the PCI device, or to be registered directly by
> the PCI driver.

I was a bit overzealous in my comment - you are correct that the GPIO
controller is behind the LPC bridge.  However, there is a lot of other
stuff in the same device, from the Intel series 5 datasheet : "The LPC
bridge function of the PCH resides in PCI Device 31:Function 0. This
function contains many other functional units, such as DMA and Interrupt
controllers, Timers, Power Management, System Management, GPIO, RTC, and
LPC Configuration Registers."
 
Thus I still don't think its correct to claim the device as only a GPIO
device - its much more, as can be seen by the current drivers which use
the same device.  I'm having a tough time seeing how an monopolistic PCI
driver is considered better than a platform driver that follows the
structure of other drivers in use.

> >
> >> I'm going to merge Jean's driver and leave this one out for now
> >> (sorry), but I reserve the right to replace Jean's with your driver in
> >> the next merge window.  This is pretty much an arbitrary decision, but
> >> I may as well merge at least one of them now instead of kicking both
> >> out for another cycle.  It really seams to me like there is still
> >> a few architectural issues to sort out in both drivers and to make
> >> sure that one driver will be useful for both of you.
> >
> > I disagree with the logic, and its a bit frustrating to have a patch
> > hanging out for 6 months to be superseded by a more recent change that
> > seems to be more likely to cause conflicts.
> 
> Think about it this way; your patch wasn't going to go in this cycle
> anyway due to the current concerns I have about structure,

I attempted to follow the driver model of the existing iTCO_wdt.c file,
which at a minimum will not negatively affect other drivers unlike the
potential of the accepted driver.  Any comments about the platform
driver GPIO approach can also be made to the iTCO_wdt.c driver, as well
as the sonypi.c driver.  Since cleanup needs to be done anyway on those
drivers, my hope would be that the platform GPIO driver would be
accepted since it follows the status quo, and then cleanup on them all
would occur.

Best,
Peter

