Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1E0O25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:28:57 -0400
Received: from xes-mad.com ([216.165.139.218]:59761 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1E0O2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:28:54 -0400
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
From: Peter Tyser <ptyser@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>
In-Reply-To: <20110527110130.4b3448f2@endymion.delvare>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
	 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
	 <20110527064238.GA31271@ponder.secretlab.ca>
	 <20110527110130.4b3448f2@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 09:26:42 -0500
Message-ID: <1306506402.22090.14872.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 11:01 +0200, Jean Delvare wrote:
> Hi Grant,
> 
> On Fri, 27 May 2011 00:42:38 -0600, Grant Likely wrote:
> > On Wed, Apr 20, 2011 at 11:35:54AM -0500, Peter Tyser wrote:
> > > This driver works on many Intel chipsets, including the ICH6, ICH7,
> > > ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> > > (Cougar Point), and NM10 (Tiger Point).
> > > 
> > > Additional Intel chipsets should be easily supported if needed, eg the
> > > ICH1-5, EP80579, etc.
> > > 
> > > Tested on a QM57 (Ibex Peak), 3100 (Whitmore Lake) , and
> > > NM10 (Tiger Point).
> > > 
> > > Cc: Alek Du <alek.du@intel.com>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Cc: Eric Miao <eric.y.miao@gmail.com>
> > > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > Cc: Joe Perches <joe@perches.com>
> > > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > Cc: Syed S Azam <Syed.Azam@hp.com>
> > > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> > > Tested-by: Vincent Palatin <vpalatin@chromium.org>
> > 
> > Hmmm, I merged a patch from Jean Delvare adding support for Intel
> > 82801 gpio pins[1].  Does this driver support the same hardware?  I see
> > the same PCI ids.
> > 
> > [1] https://lkml.org/lkml/2011/4/19/170
> 
> There is indeed a common range in the supported devices: ICH6 to ICH10.
> My driver also supports older ICH chips (ICH to ICH5), while Peter's
> support newer devices my driver does not (basically everything after
> the ICH10).
> 
> Another key difference is that my driver is a simple PCI driver, while
> Peter's is a platform driver. It makes some sense to have a platform
> driver because the PCI device is a multifunction device so other
> drivers may want to bind to it. However, I suspect that the other
> functions (ACPI?) will never need a driver (not in the Linux device
> driver binding model sense of the term at least) which is why I did not
> bother. Peter, what was you reason to go for a platform driver? If you
> really want to it go that route, you'll have to follow the standard MFD
> model (see drivers/mfd/lpc_sch.c for an example.)
> 
> The only device I really care to see supported at the moment is the
> ICH10, and it is supported by both drivers, so I don't care too much
> which driver is picked.

I went with a platform driver because the PCI device IDs we're searching
for don't contain the "GPIO registers" - they just have pointer to the
GPIO registers which reside in IO space, in addition to other non-GPIO
registers as Jean mentioned.  So conceptually a platform driver made
more sense to me since we're not claiming or using the PCI device, we're
just using it to get a pointer.

More importantly, the PCI device that contains the pointer to the GPIO
IO space also has other uses that prevent it from being claimed.  Eg the
drivers/mtd/maps/esb2rom.c driver uses the same PCI device to configure
firmware hub registers.  The esb2rom.c driver isn't a PCI driver either,
so it wouldn't cause a conflict, but it seemed to support the idea that
we shouldn't be using a PCI driver.

The drivers/wdt/iTCO_wdt.c file also uses the same PCI device to get the
ACPI base (similar to us getting the GPIO base), and it is implemented
as a platform driver.

What determines if the driver should use the mfd or platform model?  Eg
the iTCO_wdt.c that I used as an example doesn't use the mfd model
despite using the PCI device the same as we are.

My own (completely biased) preference would be to use my driver as a
starting point, primarily because it supports newer chips that require
different access methods, as well as the older-style chips Jean's
supports.  Its also been hanging out for about 6 months without many
complaints, a tested-by, etc.

Best,
Peter

* The original work was done on an Intel 3100 with PCI device ID
PCI_DEVICE_ID_INTEL_ESB2_0, datasheet at
http://download.intel.com/design/intarch/datashts/31345803.pdf, see
section 16.2.


