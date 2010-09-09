Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0IINM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:12:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57457 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751314Ab0IINMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:12:54 -0400
Date: Thu, 9 Sep 2010 14:12:52 +0100
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
Message-ID: <20100909131251.GE25855@rakim.wolfsonmicro.main>
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com>
 <20100908155114.880463fc.akpm@linux-foundation.org>
 <4C887837.6060508@nokia.com>
 <20100909093810.GA1988@rakim.wolfsonmicro.main>
 <4C88D97F.2080804@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C88D97F.2080804@nokia.com>
X-Cookie: Phone call for chucky-pooh.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:56:31PM +0300, Adrian Hunter wrote:
> Mark Brown wrote:

> >What do you mean when you say that you would like boards to "hook
> >directly into the regulator" - what do you want to be able to do?
> >Is this the notifiers?  Do you need more of them?

> There would need to be notifiers before and after any change to the
> voltage.  However the notifiers would have to be set up before or
> during regulator initialisation because initialisation already can
> change the voltage e.g. in set_machine_constraints.

Why do you believe these notifiers are needed?  I would expect that
anything that needs pre and post change notifications like this is
actually changing the configuration itself (since if it's that sensitive
to changes it seems likely that it wouldn't be enthused about having the
configuration changed while it's trying to do stuff).

> >I can't parse this at all I'm afraid.  Could you be more specific about
> >what you mean by using enable and disable independantly of the board -
> >clearly the consumer drivers are already able to be board independant?

> For OMAP3 (and OMAP2 in some cases) the 1st SD/SDIO/MMC controller
> can operate at either 1.8V or 3V, however at 3V the board must apply
> voltage level shifting (PBIAS configuation).  Currently the
> level-shifting is done by board code that must be called before and
> after the voltage changes.  The omap_hsmmc driver calls the board
> code via callbacks in platform data (.before_set_reg and
> .after_set_reg).

This really sounds like something that's internal to the MMC controller
driver - based on your description I'm very surprised that boards even
get visibility of this.  Surely the MMC controller driver should be
taking care of configuring PBIAS itself, assuming it's something
internal to the chip?  Adding code to the regulator API so that the OMAP
MMC driver can be notified of the configuration it has applied to itself
(and any failures that ensue) feels baroque.
