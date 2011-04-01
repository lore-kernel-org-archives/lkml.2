Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1DATyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:54:50 -0400
Received: from relais.videotron.ca ([24.201.245.36]:37041 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1DATyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:54:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 01 Apr 2011 15:54:47 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: Detlef Vollmann <dv@vollmann.ch>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <201104011750.17344.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011659.40443.arnd@arndb.de> <4D95EF8E.9080902@vollmann.ch>
 <201104011750.17344.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Arnd Bergmann wrote:

> On Friday 01 April 2011, Detlef Vollmann wrote:
> > On 04/01/11 16:59, Arnd Bergmann wrote:
> > > On Friday 01 April 2011, Detlef Vollmann wrote:
> > >> On 04/01/11 15:54, Arnd Bergmann wrote:
> > >
> > >>> 9. All interesting work is going into a handful of platforms, all of which
> > >>>      are ARMv7 based.
> > >> Define interesting.
> > >
> > > The ones that are causing the churn that we're talking about.
> > > Platforms that have been working forever and only need to get
> > > the occasional bug fix are boring, i.e. not the problem.
> > In the ARM tree I only know mach-at91.
> > Atmel still introduces new SOCs based on ARM926EJ-S, and that makes
> > perfect sense for lots of applications.
> 
> I thought new ones were generally Cortex-M3 based. Either way, even
> if there are exceptions, focusing on ARMv7 at first should give
> a good representation of the new development.

The actual CPU core doesn't matter at all.  Whether it is ARM926EJ-S, 
XScale, PJ4 or Cortex-A8/A9, _that_ is the part that is extremely well 
maintained and abstracted already.  The focus should instead be put on 
those platforms that are the most used irrespective of their cores.  And 
by selecting the most used platforms, we have a greater chance to create 
community momentum, and good examples will be spread more quickly.

> > >>> 12. Supporting many different boards with a single kernel binary is a
> > >>>       useful goal.
> > >> Generally not for embedded systems (for me, a mobile PDA/phone is just a
> > >> small computer with a crappy keyboard, but not an embedded system).
> > >
> > > True. For embedded, this would not be an important thing to do, but
> > > also not hurt.
> > It costs you flash space.
> 
> Well, the idea was not to force everyone to enable all options. When this
> is done right, the kernel would not be any bigger.

With many SOCs each with their own peculiarities, the kernel would 
obviously grow bigger.  But the major advantage of being _able_ to do 
that is not ultimately to have only one kernel with multi-board support 
even if in some context this has great value, but rather to enforce good 
code reuse and abstraction.

Russell suggested that we enable CONFIG_ARM_PATCH_PHYS_VIRT by 
default.  This is already one way to remove one of the most 
fundamental board specific piece of information that can be deduced at 
run time instead of having compile time constants per SOC.

I however don't think it is practical to go off in a separate 
mach-nocrap space and do things in parallel.  Taking OMAP as an example, 
there is already way too big of an infrastructure in place to simply 
rewrite it in parallel to new OMAP versions coming up.

It would be more useful and scalable to simply sit down, look at the 
current mess, and identify common patterns that can be easily factored 
out into some shared library code, and all that would be left in the 
board or SOC specific files eventually is the data to register with that 
library code.  Nothing so complicated as grand plans or planification 
that makes it look like a mountain.

Two patterns were identified so far, and they are:

1) GPIO drivers

   As Linus observed, in the majority of the cases GPIOs are accessed 
   through simple memory-mapped registers.  Some have absolute state 
   registers, the others have separate clear/set registers.  Suffice to 
   create two generic GPIO drivers each covering those two common cases, 
   and those generic drivers would simply register with the higher level 
   gpiolib code, and all the board code would have to do is to provide 
   the data for those GPIOs (register offsets, number of GPIOs, etc.).  
   Whether this data eventually comes from DT is an orthogonal issue.

2) IRQ chip drivers

   Again, as Thomas observed, the same issue exists with the majority of 
   the IRQ chip drivers.  Most of them follow a common simple pattern 
   that can be abstracted in some generic library code due to their very 
   similar mode of operation.  Writing a common driver would leave the 
   board specific code with only a data table describing hardware 
   registers.

A good example of such rationalization that already happened is the 
leds-gpio driver (./drivers/leds/leds-gpio.c), or similarly the 
gpio-keys driver (drivers/input/keyboard/gpio_keys.c).  I remember when 
those board files were implementing their own simple drivers hooking 
directly to the input API or the LED API.

After that let's take another identified common pattern and factorize it 
out from board code.  That might be timers (see RMK's recent 
sched_clock() rationalization).  That might be clocks (patches from 
Jeremy Kerr exist and need merged). Etc.

Eventually we won't be able to find any more identifiable patterns which 
are factorisable, and what will be left in board files is only genuine 
SOC differences.  And if all that is left is actually only data tables, 
then maybe such board files could go entirely and that data be passed 
via device tree, but that is still a long way off.

I think what is needed here is a bunch of people willing to work on such 
things, extracting those common patterns, and creating the 
infrastructure to cover them.  Once that is in place then we will be in 
a position to push back on code submissions that don't use that 
infrastructure, and be on the lookout for new patterns to emerge.

Just with the above I think there is sufficient work to keep us busy for 
a while.


Nicolas
