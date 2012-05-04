Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2EDH2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:28:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53429 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2EDH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:28:23 -0400
Date: Fri, 4 May 2012 08:27:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Deepak Saxena <dsaxena@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jon Medhurst <tixy@linaro.org>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504072756.GA26481@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de> <20120503140428.GB897@n2100.arm.linux.org.uk> <CAK2p4sLagEw+ubrG-oAk_bjWeSkEnCQyS_mJFPLCkpbnMfOZ_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK2p4sLagEw+ubrG-oAk_bjWeSkEnCQyS_mJFPLCkpbnMfOZ_A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:31:13PM -0700, Deepak Saxena wrote:
> On 3 May 2012 07:04, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> >> Hi everyone,
> >>
> >> I've been discussing multiplatform kernels with a few people recently,
> >> and we will have a lot of discussion sessions about this at Linaro
> >> Connect in Hong Kong.
> >>
> >> One question that came up repeatedly is whether we should support all
> >> possible board files for each platform in a multiplatform kernel,
> >> or just the ones that are already using DT probing. I would like
> >> to get a quick poll of opinions on that and I've tried to put those
> >> people on Cc that would be most impacted by this, i.e. the maintainers
> >> for platforms that have both DT and non-DT board files at the moment.
> >>
> >> My feeling is that we should just mandate DT booting for multiplatform
> >> kernels, because it significantly reduces the combinatorial space
> >> at compile time, avoids a lot of legacy board files that we cannot
> >> test anyway, reduces the total kernel size and gives an incentive
> >> for people to move forward to DT with their existing boards.
> >>
> >> The counterargument is that we won't be able to support all the
> >> boards we currently do when the user switches on multiplatform,
> >> but I think that is acceptable.
> >> Note that I would still want to allow users to build platforms
> >> separately in order to enable the ATAG style board files, even
> >> for platforms that are not multiplatform capable.
> >
> > I'm basing my comments off mach-zynq.
> >
> > How about we take the following steps towards it?
> >
> > 1. create arch/arm/include/mach/ which contains standardized headers
> >   for DT based implementations.  This must include all headers included
> >   by asm/ or linux/ includes.  This will also be the only mach/ header
> >   directory included for code outside of arch/arm/mach-*.  This also
> >   acts as the 'default' set of mach/* includes for stuff like timex.h
> >   and the empty hardware.h
> >
> > 2. DT based mach-* directories do not have an include directory; their
> >   include files must be located in the main include/ heirarchy if shared
> >   with other parts of the kernel, otherwise they must be in the mach-*
> >   directory.
> 
> What do we do about all the mach-specific driver related headers that are
> currently littered all over arch/arm/mach*? Things like <mach/mx3fb.h> and
> <mach/ohci.h>?

Such platforms with that kind of stuff haven't fully converted to DT,
because these sorts of things are platform dependent yet aren't represented
in DT.

> Arnd (or maybe Nicolas?) suggested something along the lines
> of scripting something to figure out the constants required for a
> specific driver and pulling them out of <mach/*.h> and into that
> driver as a starting point.

But that doesn't solve the problem.  Take a USB driver where the register
layouts are different.  To have it work on two different platforms, you'd
need to build the driver twice.  Not only that, you'd also need to figure
out some way to register only one copy of that.

So really, the header file thing is just a sign of larger blocking issues
to getting those kinds of drivers working on a multiplatform kernel, and
no amount of header munging will sort it out.  The fact of that situation
is the driver concerned is _not_ multiplatform and shouldn't be built in
that situation until it is fixed.

> > 3. Allow build multiple mach-* directories (which we already do... see
> >   the samsung stuff.)
> >
> > We still have irqs.h being SoC dependent, and we still haven't taken
> > debug-macros.S far enough along to get rid of that.  Then there's also
> > the problem of uncompress.h.  The last piece of the puzzle is the common
> > clock stuff.
> 
> There's also some stuff outside of arch/arm that needs cleanup
> including USB driver
> refactoring and some other bits that I can't recall atm. Right now we
> can build one and
> only one host controller   inteface, even as modules. Not too
> difficult of a problem to
> solve and not critical to get the SOCs booting, but needed to be
> usable on real devices.

That's already a problem today, and has nothing to do with this current
issue - what I'm saying is the problem can't be made to go away through
header file stuff, so this issue is not relevant to this discussion.

That's not to say it doesn't need to be resolved, because it does.  It's
just no reason to argue against what I've said.
