Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1C3XcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:32:03 -0400
Received: from relais.videotron.ca ([24.201.245.36]:19974 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1C3XcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:32:00 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Tk7ql5dkesEECgG9U/f7XQ)"
Date: Wed, 30 Mar 2011 19:31:59 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_Tk7ql5dkesEECgG9U/f7XQ)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Wed, 30 Mar 2011, Linus Torvalds wrote:

> On Wed, Mar 30, 2011 at 1:41 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >
> > If in your mind "competitors" == "morons" then you might be right.
> 
> There's a difference between "competition" and "do things differently
> just to be difficult".

Absolutely.  We've seen that from some proprietary software companies.

> > Trying to rely on bootloaders doing things right is like saying that x86
> > should always rely on the BIOS doing things right.
> 
> No. Not at all.
> 
> The problem with firmware/BIOS is that it's set in stone and closed-source.
> 
> I'm suggesting splitting out the crazy part into a separate project
> that does this. Open-source. Like a mini-kernel. Because the thing is,
> the main kernel doesn't care, and _shouldn't_ care. Those board files
> are just noise.

Sure, but important noise nevertheless.  As long as the noise is 
confined to a limited set of .c files I'm happy.  OTOH I have very 
little hope for a separate project that would only deal with that noise.  
That will simply never fly, even less so as an Open Source project.  
The insentive for people to work on such thing simply aren't there as 
that is totally uninteresting and without any rewards.

Furthermore, this does create pain.  you have to make things in sync 
between the kernel and the mini-kernel (let's call it bootloader).  In 
practice the bootloader is always maintained separately from the kernel, 
on its own pace and with its own release schedule.  Trying to 
synchronize independent projects is really painful as you know already, 
otherwise the user space for perf would still be maintained separately 
from the kernel, right?

Now, when there is a bug in one of the clock settings, or one clock 
is missing for that new kernel driver to work properly, the 
bootloader would have to be fixed, revalidated, and the fix deployed 
separately but still in addition to the kernel.  This process still adds 
to the pain such that what people do in those cases is simply to hack 
the driver code in the kernel.  Instead, the OMAP folks created a table 
to abstract them into something more manageable.

And here's the final catch.  Most of those clocks are often derived from 
each other in a tree structure inside the SOC.  And for power saving 
reasons, some crazy people want to dynamically change the config for 
those clocks at run time according to the required frequency for given 
loads, turn them off when possible, and of course turn the parent clock 
off as well if all the children clocks are themselves turned off.  So 
the kernel has NO CHOICE but to be fully aware of them.

Then comes power domains with the cascade of regulators and so forth, 
again all software controlled.  Add to the mix the different sleep 
states that can be derived from that, which is far more sophisticated 
than ACPI states on Intel.  And in some cases, the hardware capabilities 
are there but people still didn't find the optimal way to drive them, so 
research is still on-going software wise.  And obviously those SOC 
vendors do compete on that front since power consumption is the killing 
weapon these days.  No wonder why they are so different from each other 
with all that "board crap".

> The long-term situation should be that you should be able to have ONE
> binary kernel "just work". That's where we are on x86. Really.

But X86 is peanuts.  Really.  There was one machine called the IBM PC at 
some point that everybody cloned, and the rest was totally irrelevant.  
Then came that thing called Windows that reinforced this hardware 
monoculture as it was used for the ultimate conformance testing.  This 
is damn easy in that case to produce a kernel that works virtually 
everywhere.

On ARM there is simply not such thing as a single machine design to 
clone, and a closed source test bench to design for.

And this is orthogonal to this discussion anyway, as having in-kernel 
clock tables is not incompatible with a single kernel binary.  Dropping 
at runtime those clock tables that are irrelevant to the currently 
running hardware is not rocket science.

> Without that kind of long-term view, where do you think ARM is going
> to be in five years?

ARM is going to still be relevant simply because they now have Linux 
that they can modify to suit their latest changes.  That's one thing 
with Open Source which can be good or bad: full hardware compatibility 
is no longer an issue since the software can be adapted at will.

Still... there are on-going efforts to consolidate things amongst all 
the ARM vendors.  The ARM architecture is standardizing more and more 
stuff in the whole stack in every revision.  But they won't standardize 
everything otherwise they'll kill that competing ecosystem.

> >> almost *SIXTY* percent of all arch updates were to ARM code.
> >
> > Absolutely not!  You have 14% going to OMAP code which happens to be
> > under arch/arm/ but there is nothing ARM specific in there.  If OMAP was
> > using a PPC or a MIPS core then you'd have the same result except under
> > arch/powerpc or arch/mips.  There is very little in terms of ARM
> > specific peculiarities under arch/arm/mach-omap2/ in fact.
> 
> But that's my point - the problem is all the crazy board crap.
> 
> I've never claimed that this is about the ARM cpu (which has it's own
> issues, but that's a separate rant entirely). It's about the broken
> infrastructure.

Let's see how we can fix it then.  Trying to shovel the problem away 
won't help the situation.  Those ARM vendors are crazy for sure.  But 
it's not a relatively few merge conflicts compared to the volume of 
changes that will make us flinch, right?

> Now, some of it is quite understandable - ie real drivers for real
> hardware. But a _lot_ of it seems to be just descriptor tables, and
> I'm getting the very strong feeling that ARM people aren't even
> _trying_ to make it sane, and trying to standardize things, or trying
> to aim for the whole notion of "one kernel image, with much more hw
> description done elsewhere".

That work is happening.  It is not ready.  I'm not against it but I 
remain sceptical.  I still think that a self contained kernel is more 
maintainable.

Still, because ARM is just a CPU architecture, those SOC vendors will 
always have something new to differenciate themselves from the other SOC 
vendors.  And that cannot be described in a table alone. The power 
management hardware from TI will still require separate _executable_ 
code from the Freescale one, or the Samsung one, or the Nvidia one, or 
the Qualcomm one, or the Marvell one, yada yada.  And I really don't 
want to see that code turned into some vendor provided buggy ACPI 
bytecode or similar.

> arch/arm is already about 3x the size of arch/x86. And it's pretty
> much all the crazy infrastructure afaik. timer chips, irq chips, gpio
> differences - crap like that.

Indeed.  And I expect it to grow even bigger.  Be warned.

> And the fact that you don't even seem to UNDERSTAND the problem, and
> think that it's ok, and that continued future explosion of this is all
> fine makes me even more nervous.

I do understand the problem.  And so far, the way we scaled is to have 
TI people care about the OMAP code, Freescale people care about the iMX 
code, and so on.  If one of them produces crap code then so it is, and 
the other vendor is totally unaffected, which is why I'm not too 
nervous.  Blaming a merge conflict on the entire ARM ecosystem just 
because one team was large enough to have separate people doing 
different things that intersected into the clock table is blowing things 
totally out of proportion.

And if those hardware vendors are still in business in the future, and 
apparently new ones are joining in, then the arch/arm/ directory will 
continue to gain weight.  And on ARM, Linux is very very successful 
that's all.


Nicolas

--Boundary_(ID_Tk7ql5dkesEECgG9U/f7XQ)--
