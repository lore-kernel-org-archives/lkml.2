Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab0IJKho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:37:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57902 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751356Ab0IJKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:37:42 -0400
Date: Fri, 10 Sep 2010 11:37:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v3
Message-ID: <20100910103739.GG3068@rakim.wolfsonmicro.main>
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com>
 <20100908155114.880463fc.akpm@linux-foundation.org>
 <4C887837.6060508@nokia.com>
 <20100909093810.GA1988@rakim.wolfsonmicro.main>
 <4C88D97F.2080804@nokia.com>
 <20100909131251.GE25855@rakim.wolfsonmicro.main>
 <4C8A02E6.4080906@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8A02E6.4080906@nokia.com>
X-Cookie: Did I do an INCORRECT THING??
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 01:05:26PM +0300, Adrian Hunter wrote:
> Mark Brown wrote:
> >On Thu, Sep 09, 2010 at 03:56:31PM +0300, Adrian Hunter wrote:

> >                                                I would expect that
> >anything that needs pre and post change notifications like this is
> >actually changing the configuration itself (since if it's that sensitive
> >to changes it seems likely that it wouldn't be enthused about having the
> >configuration changed while it's trying to do stuff).

> Yes, except when it is the regulator core trying to set the initial power
> state on or off.

Like I say, I'd not expect anything that needs this sort of fiddly
control in the hardware to be happy with doing this outside the driver
itself - this includes via the constraints.  If it's important that two
bits of hardware be updated in lockstep then I'd expect you to need to
probe both bits of hardware and control them from one place, which means
that using notifiers from constraints would be very limited due to probe
ordering issues.  You'd need to make sure that the notifiers had access
to whatever other hardware they need to fiddle with before we started
applying the constraints which just feels like asking for initialisation
ordering fun.

> >>For OMAP3 (and OMAP2 in some cases) the 1st SD/SDIO/MMC controller
> >>can operate at either 1.8V or 3V, however at 3V the board must apply
> >>voltage level shifting (PBIAS configuation).  Currently the

> >This really sounds like something that's internal to the MMC controller
> >driver - based on your description I'm very surprised that boards even
> >get visibility of this.  Surely the MMC controller driver should be
> >taking care of configuring PBIAS itself, assuming it's something
> >internal to the chip?

> It is considered that the driver should know only about hsmmc ip not
> all of OMAP.  Additionally the OMAP community does not allow the use
> of the necessary system control registers outside of the board level
> i.e. arch/arm/mach-omap2 etc.  Hence the driver calls down to the
> board level.  That is ugly but not a problem.

That sounds like you'll end up with a lot of cut'n'paste for this in
boards but if it works I guess it's OK.  Are there situations where
different boards need to do different things?

> >                       Adding code to the regulator API so that the OMAP
> >MMC driver can be notified of the configuration it has applied to itself
> >(and any failures that ensue) feels baroque.

> As you wish.  That rules out using the core to turn off the regulator at
> boot up, but that is OK, the driver can do it.  At present the driver
> makes the mistake of just doing regulator_enable() / disable() to ensure the
> regulator is off, without calling down to the board level for the PBIAS
> configuration.  It also comments the code as an "ugly hack" whereas
> it is really the only way to do it, if the regulator can't do the
> PBIAS configuration automatically.  I will just fix the driver and add
> better comments.

With the description you've given it really does feel like handling this
in the MMC driver is the best approach.
