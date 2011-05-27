Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1E0Uzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:55:32 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59303 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1E0Uzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:55:31 -0400
Date: Fri, 27 May 2011 14:55:26 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
Message-ID: <20110527205526.GJ6645@ponder.secretlab.ca>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
 <20110527064238.GA31271@ponder.secretlab.ca>
 <20110527110130.4b3448f2@endymion.delvare>
 <1306506402.22090.14872.camel@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306506402.22090.14872.camel@petert>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 09:26:42AM -0500, Peter Tyser wrote:
> On Fri, 2011-05-27 at 11:01 +0200, Jean Delvare wrote:
> > Hi Grant,
> > 
> > On Fri, 27 May 2011 00:42:38 -0600, Grant Likely wrote:
> > > On Wed, Apr 20, 2011 at 11:35:54AM -0500, Peter Tyser wrote:
> > > > This driver works on many Intel chipsets, including the ICH6, ICH7,
> > > > ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> > > > (Cougar Point), and NM10 (Tiger Point).
> > > > 
> > > > Additional Intel chipsets should be easily supported if needed, eg the
> > > > ICH1-5, EP80579, etc.
> > > > 
> > > > Tested on a QM57 (Ibex Peak), 3100 (Whitmore Lake) , and
> > > > NM10 (Tiger Point).
> > > > 
> > > > Cc: Alek Du <alek.du@intel.com>
> > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > > Cc: Eric Miao <eric.y.miao@gmail.com>
> > > > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > > Cc: Joe Perches <joe@perches.com>
> > > > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > > Cc: Syed S Azam <Syed.Azam@hp.com>
> > > > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > > > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> > > > Tested-by: Vincent Palatin <vpalatin@chromium.org>
> > > 
> > > Hmmm, I merged a patch from Jean Delvare adding support for Intel
> > > 82801 gpio pins[1].  Does this driver support the same hardware?  I see
> > > the same PCI ids.
> > > 
> > > [1] https://lkml.org/lkml/2011/4/19/170
> > 
> > There is indeed a common range in the supported devices: ICH6 to ICH10.
> > My driver also supports older ICH chips (ICH to ICH5), while Peter's
> > support newer devices my driver does not (basically everything after
> > the ICH10).
> > 
> > Another key difference is that my driver is a simple PCI driver, while
> > Peter's is a platform driver. It makes some sense to have a platform
> > driver because the PCI device is a multifunction device so other
> > drivers may want to bind to it. However, I suspect that the other
> > functions (ACPI?) will never need a driver (not in the Linux device
> > driver binding model sense of the term at least) which is why I did not
> > bother. Peter, what was you reason to go for a platform driver? If you
> > really want to it go that route, you'll have to follow the standard MFD
> > model (see drivers/mfd/lpc_sch.c for an example.)
> > 
> > The only device I really care to see supported at the moment is the
> > ICH10, and it is supported by both drivers, so I don't care too much
> > which driver is picked.
> 
> I went with a platform driver because the PCI device IDs we're searching
> for don't contain the "GPIO registers" - they just have pointer to the
> GPIO registers which reside in IO space, in addition to other non-GPIO
> registers as Jean mentioned.  So conceptually a platform driver made
> more sense to me since we're not claiming or using the PCI device, we're
> just using it to get a pointer.
> 
> More importantly, the PCI device that contains the pointer to the GPIO
> IO space also has other uses that prevent it from being claimed.  Eg the
> drivers/mtd/maps/esb2rom.c driver uses the same PCI device to configure
> firmware hub registers.  The esb2rom.c driver isn't a PCI driver either,
> so it wouldn't cause a conflict, but it seemed to support the idea that
> we shouldn't be using a PCI driver.
> 
> The drivers/wdt/iTCO_wdt.c file also uses the same PCI device to get the
> ACPI base (similar to us getting the GPIO base), and it is implemented
> as a platform driver.
> 
> What determines if the driver should use the mfd or platform model?  Eg
> the iTCO_wdt.c that I used as an example doesn't use the mfd model
> despite using the PCI device the same as we are.

An mfd device is merely a bag of platform devices.  It's fine to use a
platform_device, but it should be registered in the context of the pci
probe hook, not from the context of the module_init() hook.

> My own (completely biased) preference would be to use my driver as a
> starting point, primarily because it supports newer chips that require
> different access methods, as well as the older-style chips Jean's
> supports.  Its also been hanging out for about 6 months without many
> complaints, a tested-by, etc.

I like the /structure/ of Jean's driver better, particularly that it doesn't
play games with the device model by registering devices at module load
time.  If one device performs more than one function, then it should
register all the interfaces from a single probe, or go in the
direction of MFD devices and register a bunch of child
platform_devices.

I'm going to merge Jean's driver and leave this one out for now
(sorry), but I reserve the right to replace Jean's with your driver in
the next merge window.  This is pretty much an arbitrary decision, but
I may as well merge at least one of them now instead of kicking both
out for another cycle.  It really seams to me like there is still
a few architectural issues to sort out in both drivers and to make
sure that one driver will be useful for both of you.

g.

