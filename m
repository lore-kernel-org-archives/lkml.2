Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1DDBAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 21:00:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1DDBAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 21:00:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Mon, 4 Apr 2011 02:59:26 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, Detlef Vollmann <dv@vollmann.ch>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104031726.37420.arnd@arndb.de> <20110403160324.GA8050@n2100.arm.linux.org.uk>
In-Reply-To: <20110403160324.GA8050@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104040259.26601.arnd@arndb.de>
X-Provags-ID: V02:K0:W35ZT8mklwL6hHqbZtRY6A0GSaSf5H4XTBtngvf3oxJ
 NmyPFRBL2C7HfGGStrZZdFArSlFNnHtz9llkdZJhCCqkvzS/Fa
 5qRjbrJNshHHulxEIMH2wk0h23BkON0/jZbwhuv97cbzhWB4a/
 CXkyX7FAUPKdSz/BZTMN/37CpRcrQIasVbyFllXXas+4z9F5gX
 IqNtH/7I5Q92Jl7SXADLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 April 2011, Russell King - ARM Linux wrote:
> On Sun, Apr 03, 2011 at 05:26:37PM +0200, Arnd Bergmann wrote:
> > There are a few other examples that were done in a similar way:
> > * The drivers/ide code still serves a few hardware platforms that
> >   never had anyone write a new libata code. Libata itself has
> >   been in a good shape for a long time though.
> 
> And there are platforms where libata just doesn't work but the old
> ide driver does.  My firewall with a CF card in is completely unusable
> with libata, but works fine with the old IDE driver.
> 
> That's partly caused by there being no support for the ISA IOCS16 signal
> on that hardware, so the ISA bus needs specific handling depending on
> the behaviour of the ISA device being addressed.  Yes, crap hardware,
> nothing new there.

Yes, I think that also illustrates the approach: There is no fundamental
reason why it could not be made to work with libata, but there is also
no real incentive to do the work because all users can deal with the
IDE driver being essentially in bug-fix-only maintainance.

There is the occasional discussion about removing drivers/ide, but
right now it's more valuable to keep it, and the bug fixes cause
little trouble.

> Having just looked at the clocksource stuff, there's 9 up-counting 32-bit
> clocksources which are relatively easy to port to a single piece of code.
>
> There's a number of down-counting clocksources using various methods to
> convert to an up-counting value - sometimes -readl(), sometimes
> cs->mask - readl() and sometimes ~readl().

All three methods for down-counting can be abstracted as offset-readl(),
right?

> Then there's those which are either 16-bit or 32-bit, and some of those
> 16-bit implementations must use readw() to avoid bus faults.
>
> Combining all those together you end up with something pretty disgusting,
> and an initialization function taking 7 arguments (iomem pointer, name,
> rating, tick rate, size, up/down counter, clocksource flags).

I probably wouldn't use seven arguments, but put all arguments that are
typically constant per board into a data structure. Not sure we'd even
need the name unless there are a lot of cases where we'd register
multiple those clocksources at once. Size and up/down are just
flags I guess.

> Does it lead to more maintainable code?  I'm not convinced - while it
> certainly reduces the amount of code, but the reduced code is rather
> more complex.

Isn't that always the tradeoff of generalizing the code? The big win
is that we don't get new copies of the same code with slightly different
bugs and that any changes to the code that are needed for supporting
new hardware have to get reviewed by people that know it.

The disadvantage is it's more complex code.

> Would an alternative be to introduce separate mmio-32bit-up, mmio-32bit-down,
> mmio-16bit-up and mmio-16bit-down clocksources?  That also doesn't give
> me a good feeling about the result.

Just two booleans doesn't really justify separate drivers, I guess.

> Then there's those which change the cs->read function pointer at runtime,

I found omap, mxs and mxc doing that. In all cases, the differences between
the functions that are set are for parameters that depend on the CPU core
(MMIO address, 16/32 bit read), so that would be covered by the detection
logic.

> and those which share that pointer with their sched_clock() implementation.

Abstracting sched_clock() to be run-time selected is something that
needs to be taken care of. Maybe we could have a generic sched_clock
implementation that is written on top of clocksource instead of jiffies,
and always select that on architectures that have a decent clocksource.
Are there any platforms on ARM where that would be a bad idea? I believe
the main reaons why they are separate is that on x86 you can use the TSC
for sched_clock in many cases where you cannot use it for clocksource.

> And those which need to do special things (like loop until read values are
> stable) in their read functions which probably can't ever be supported by
> common code.

That's probably fine, because it's basically why we have the abstraction
at the clocksource level and not below it.

	Arnd
