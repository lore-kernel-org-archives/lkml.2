Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab1CaRSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:18:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758667Ab1CaRSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110331164539.GB19452@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <20110331164539.GB19452@n2100.arm.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 10:17:25 -0700
Message-ID: <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: david@lang.hm, Ingo Molnar <mingo@elte.hu>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 9:45 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> I think you're not entirely correct - have a look at Linus' message where
> there's a comparison of the size of arch/arm with other architectures, and
> you'll find that it is partly about size of source code.

It definitely is partly about code size, although I tend to use it as
an easy illustration of the issues rather than anything deeper than
that.

The code size is a symptom of the problem. The deeper problem is the
crazy arm hardware infrastructure. We can't do much about that, but it
does mean that I _do_ think we need to take approaches that aren't
necessary when that deeper problem doesn't exist.

For example, I don't think it's problematic that we have various
drivers that do their own gpio thing. Why? Because those things are
generally part of a bigger chip/driver that is discoverable, and they
don't tend to proliferate in various crazy random amounts - nor do
they tend to impact anything else. Nor does it look like that is going
to explode in the future any more than any normal driver work is
exploding.

Or look at the irq controllers we have on most other architectures.
x86 has several of them too, and it's annoying. But it's "several",
not "hundreds", and again, it's not exploding or looking like it will
be a major pain to support. I doubt Thomas enjoyed having to work with
the legacy controllers, but I also doubt he had huge problems on the
x86 side.

What does that mean? _I_ think it means that ARM platform managers
need to worry about things that other platform managers don't
necessarily need to worry about as much. Things that works for others
will _not_ work for ARM, because the platforms don't have the same
kind of sticking power. Other architectures just don't have the same
kinds of issues, so they don't need to worry about them.

An right now just from the kinds of pulls I do, I see all these ARM
platform maintainers doing their own thing, and adding new platforms
all the time (with a _very_ occasional removal of some old platform
support just because it was a prototype that never went anywhere at
all).

What I'm _not_ seeing is a lot of cross-platform maintenance or sense
of people trying to reign things in and look for solutions to the
proliferation of random stupid and mindless platform code.

Even _within_ platforms, I see conflicts like the crazy clock files -
and between platforms I don't see any conflicts for the simple reason
that people are just duplicating crap and adding more and more of
these mindless things. "A new platform? Let's just create a new
directory, fill it with all the same template crud, and then tweak the
code to match".

It's simple, but it's not maintainable.

So it's not the size PER SE. But the size is a damn easy first-order
"we have a problem" sign. ARM is clearly an important architecture,
but that doesn't excuse the crazy bloating.

x86 had this too - the whole mindless duplication of x86-64. It got
merged. It required cleanups, it required effort, it required time.
And it required some abstractions. x86 never had much of a _platform_
duplication, and the different platforms that did exist were so
clearly secondary that they never rated any first-class code: they
always knew that they were a second-class citizen and had to work
within the framework of trying to hook into the main PC platform code.

Power did a lot of platform unification, despite having much less of a
problem than ARM to begin with. The "less of a problem" made it easier
to do, but also less critical.

And I don't think it's realistic to convert all ARM platforms in one
go, and nobody should even plan anything like that.

But I _do_ think that some of the major platforms (like omap) should
seriously just say "we can't continue doing this", and look at
converting at least everything they do to something like devicetree
(NOT some omap-specific infrastructure!) rather than lots of explicit
code. Done right, that hopefully then shows other platforms how to do
the same, and get the ball rolling.

                                     Linus
