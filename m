Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0H2N1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:27:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56444 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752374Ab0H2N1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:27:01 -0400
Date: Sun, 29 Aug 2010 14:27:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Daniel Mack <daniel@caiaq.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Pierre Ossman <pierre@ossman.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        Madhusudhan <madhu.cr@ti.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: move regulator handling to core
Message-ID: <20100829132711.GB10233@opensource.wolfsonmicro.com>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
 <20100827190306.GB20407@void.printf.net>
 <AANLkTi=20KrUy334JRmMYwK7rbaVYrYCqW-BHZYGPrwT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=20KrUy334JRmMYwK7rbaVYrYCqW-BHZYGPrwT@mail.gmail.com>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 04:48:58PM +0200, Linus Walleij wrote:
> 2010/8/27 Chris Ball <cjb@laptop.org>:

> > Looks like this patch got dropped because of the missing modifications
> > to arch/arm/mach-omap2/mmc-twl4030.c.  Are we still interested in the
> > patch otherwise, and can anyone help with that?

> Actually just before the summer I submitted something not quite similar:
> I moved all regulator handling *out* of the MMC core because I didn't
> trust the way reference counting was being handled.

This seems like the wrong approach; if there's a problem it'd seem much
better to fix the core code that everything is sharing rather than
factor it out - the location of the code is orthogonal to its
helpfulness.

> There is something very disturbing about this code from
> regulator/core/core.c mmc_regulator_set_ocr():

The MMC code in the core was last time I looked explicitly reliant on
the regulators not being shared - it wants the regulators to be grebbed
with regulator_get_exclusive() which guarantees that.  When the code was
added there was a strong insistance that shared supplies could not be
used with MMC so this was fine.

> So it looks to me like it is possible for one slot to enable the
> regulator and race with another slot which disables it at the
> same time and end up with the regulator disabled :-(

It's not really a race, it's just a simple inability to cope with
something else sharing the same regulator - at the minute it'll do
things like turn off the regulator when one port is done even if the
other port still needs it.

> My solution would still be to move the enable/disable out
> of the core, so I need to follow up on that.

The code needs to be changed so that the port remembers internally if
it itself needs the regulator enabled or disabled rather than inspecting
the current hardware state since that may differ as a result of being
forced by the system or the activity of other ports.
