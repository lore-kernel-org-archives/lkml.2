Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1E0VcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:32:08 -0400
Received: from xes-mad.com ([216.165.139.218]:37630 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1E0VcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:32:05 -0400
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
In-Reply-To: <20110527205526.GJ6645@ponder.secretlab.ca>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
	 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
	 <20110527064238.GA31271@ponder.secretlab.ca>
	 <20110527110130.4b3448f2@endymion.delvare>
	 <1306506402.22090.14872.camel@petert>
	 <20110527205526.GJ6645@ponder.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 16:29:54 -0500
Message-ID: <1306531794.10752.19.camel@ptyser-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

> > More importantly, the PCI device that contains the pointer to the GPIO
> > IO space also has other uses that prevent it from being claimed.  Eg the
> > drivers/mtd/maps/esb2rom.c driver uses the same PCI device to configure
> > firmware hub registers.  The esb2rom.c driver isn't a PCI driver either,
> > so it wouldn't cause a conflict, but it seemed to support the idea that
> > we shouldn't be using a PCI driver.
> > 
> > The drivers/wdt/iTCO_wdt.c file also uses the same PCI device to get the
> > ACPI base (similar to us getting the GPIO base), and it is implemented
> > as a platform driver.
> > 
> > What determines if the driver should use the mfd or platform model?  Eg
> > the iTCO_wdt.c that I used as an example doesn't use the mfd model
> > despite using the PCI device the same as we are.
> 
> An mfd device is merely a bag of platform devices.  It's fine to use a
> platform_device, but it should be registered in the context of the pci
> probe hook, not from the context of the module_init() hook.
> 
> > My own (completely biased) preference would be to use my driver as a
> > starting point, primarily because it supports newer chips that require
> > different access methods, as well as the older-style chips Jean's
> > supports.  Its also been hanging out for about 6 months without many
> > complaints, a tested-by, etc.
> 
> I like the /structure/ of Jean's driver better, particularly that it doesn't
> play games with the device model by registering devices at module load
> time.

But the driver shouldn't be a PCI driver - that's worse in my opinion
than a platform driver.  Multiple drivers currently use the same PCI
device ID as Jean's - they can't all claim the PCI device, so why should
Jean's GPIO driver?  It seems incorrect, and likely to break things in
the future.  Mine has its warts too, but it doesn't have the possibility
of negatively affect other drivers at least, as well as supports more
hardware.

> If one device performs more than one function, then it should
> register all the interfaces from a single probe, or go in the
> direction of MFD devices and register a bunch of child
> platform_devices.

In this case its not really "one device performing more than one
function", its one device specifying the location of other devices.  The
device being claimed is used for FWH and IRQ configuration and happens
to have a pointer to a GPIO device (among other things).  Claiming it
for a GPIO device seems very wrong - it has very little to do with GPIO
at all.

> I'm going to merge Jean's driver and leave this one out for now
> (sorry), but I reserve the right to replace Jean's with your driver in
> the next merge window.  This is pretty much an arbitrary decision, but
> I may as well merge at least one of them now instead of kicking both
> out for another cycle.  It really seams to me like there is still
> a few architectural issues to sort out in both drivers and to make
> sure that one driver will be useful for both of you.

I disagree with the logic, and its a bit frustrating to have a patch
hanging out for 6 months to be superseded by a more recent change that
seems to be more likely to cause conflicts. 

Best,
Peter

