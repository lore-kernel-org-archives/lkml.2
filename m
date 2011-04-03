Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1DCQEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:04:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50846 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1DCQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:04:07 -0400
Date: Sun, 3 Apr 2011 17:03:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, Detlef Vollmann <dv@vollmann.ch>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110403160324.GA8050@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104020008.16795.arnd@arndb.de> <alpine.LFD.2.00.1104012129320.28032@xanadu.home> <201104031726.37420.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104031726.37420.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 05:26:37PM +0200, Arnd Bergmann wrote:
> There are a few other examples that were done in a similar way:
> * The drivers/ide code still serves a few hardware platforms that
>   never had anyone write a new libata code. Libata itself has
>   been in a good shape for a long time though.

And there are platforms where libata just doesn't work but the old
ide driver does.  My firewall with a CF card in is completely unusable
with libata, but works fine with the old IDE driver.

That's partly caused by there being no support for the ISA IOCS16 signal
on that hardware, so the ISA bus needs specific handling depending on
the behaviour of the ISA device being addressed.  Yes, crap hardware,
nothing new there.

> We generally try to do gradual cleanups to any kernel code that is
> worth keeping, because as you say the duplication itself causes a
> lot of friction. For particularly hard cases, doing a replacement
> implementation is an exceptional way out. What we need to find a
> consensus on is how bad the problem in arch/arm/mach-*/ is:
> 
> 1. No fundamental problem, just needs some care to clean up (your
>    position, I guess), so we do do what we always do and keep doing
>    gradual improvements, including treewide API changes.
> 2. Bad enough that starting a new competing implementation is easier
>    because it lets us try different things more easily and reduce
>    the number of treewide changes to all existing platforms.
>    (this is where I think we are) Like IDE and OSS, the old code
>    can still get improved and bug fixed, but concentrating on new
>    code gives us better freedom to make progress more quickly.
> 3. In need of a complete replacement, like arch/ppc and a lot of
>    drivers/staging. I'm not arguing that it's that bad.

Having just looked at the clocksource stuff, there's 9 up-counting 32-bit
clocksources which are relatively easy to port to a single piece of code.

There's a number of down-counting clocksources using various methods to
convert to an up-counting value - sometimes -readl(), sometimes
cs->mask - readl() and sometimes ~readl().

Then there's those which are either 16-bit or 32-bit, and some of those
16-bit implementations must use readw() to avoid bus faults.

Combining all those together you end up with something pretty disgusting,
and an initialization function taking 7 arguments (iomem pointer, name,
rating, tick rate, size, up/down counter, clocksource flags).

Does it lead to more maintainable code?  I'm not convinced - while it
certainly reduces the amount of code, but the reduced code is rather
more complex.

Would an alternative be to introduce separate mmio-32bit-up, mmio-32bit-down,
mmio-16bit-up and mmio-16bit-down clocksources?  That also doesn't give
me a good feeling about the result.

Then there's those which change the cs->read function pointer at runtime,
and those which share that pointer with their sched_clock() implementation.

And those which need to do special things (like loop until read values are
stable) in their read functions which probably can't ever be supported by
common code.
