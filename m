Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab0IHQoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:44:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36539 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0IHQof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:44:35 -0400
Date: Wed, 8 Sep 2010 10:44:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Jassi Brar <jassi.brar@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/spi_s3c64xx: Move to subsys_initcall()
Message-ID: <20100908164432.GG3686@angua.secretlab.ca>
References: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTim=ArPyqC7K-aaer97deGeR6yU-FS1Hpm3D_1ER@mail.gmail.com>
 <20100908091242.GB31253@rakim.wolfsonmicro.main>
 <AANLkTimvc52yXuMFN2=qLKX1MSyTum1GHnLdDW8dMR=2@mail.gmail.com>
 <20100908161245.GC3686@angua.secretlab.ca>
 <20100908162251.GA15562@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908162251.GA15562@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 05:22:51PM +0100, Mark Brown wrote:
> On Wed, Sep 08, 2010 at 10:12:45AM -0600, Grant Likely wrote:
> 
> [reflowed into 80 columns]

Sorry about that.  I'm in the process of switching to mutt+vim for my
mailer.  gmail is just not efficient enough when managing patches.

> > ... but it seems to me that there is a systemic problem in the way the
> > driver model is being used if SPI (and I2C) bus drivers need to be
> > 'special' in this regard.  What are the ordering requirements on things
> > like PMICs?  (My uneducated assumption is that other devices depend on
> > them being enabled before being probed.)  Would it be better to have a
> 
> Pretty much this, yes - if you might want to turn on your supplies
> when you're probed it's rather helpful if the subsystem needed to
> control the regulators is available when you probe.
> 
> > mechanism to defer probing on certain devices until other devices are
> > probed?  Then the relationships could be made explicit instead of the
> > rather coarse-grained (and potentially fragile) approach of changing the
> > init order.
> 
> That would be much nicer (and this is far from the only case where we
> need to deal with it) but it's a substantial change to core kernel
> infrastructure so it's being worked around like this.  Given how all the
> discussions about sorting and dependencies for suspend and resume went
> it might be an uphill struggle to do much more, especially while we are
> able to continue to deal with things fairly easily using the current
> infrastructure.
> 
> Doing dependencies could get pretty complicated, especially once you
> handle optional dependencies ("is this missing because it didn't probe
> yet or because it's just not there?") so it's not entirely clear to me
> that it's worth the hassle.

I think it might be doable.  I had a similar problem with Ethernet
MACs and PHYs where the PHY was on a completely separate bus from the
MAC with zero guarantees on probe order.  I had some code that made it
simple to use a bus notifier to defer MAC initialization until the
required phy turned up and was probed.  I eventually abandoned it
because accessing the PHY could be deferred until .ndo_open() time.
However, it would be easy to resurrect, and might be a reasonable
solution.  At the very least it is worth an investigation.

g.
