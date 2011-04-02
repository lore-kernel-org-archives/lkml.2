Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1DBCYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 22:24:52 -0400
Received: from relais.videotron.ca ([24.201.245.36]:47876 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1DBCYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 22:24:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 01 Apr 2011 22:24:49 -0400 (EDT)
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
In-reply-to: <201104020008.16795.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1104012129320.28032@xanadu.home>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011750.17344.arnd@arndb.de>
 <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
 <201104020008.16795.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011, Arnd Bergmann wrote:

> On Friday 01 April 2011 21:54:47 Nicolas Pitre wrote:
> > I however don't think it is practical to go off in a separate 
> > mach-nocrap space and do things in parallel.  Taking OMAP as an example, 
> > there is already way too big of an infrastructure in place to simply 
> > rewrite it in parallel to new OMAP versions coming up.
> >
> > It would be more useful and scalable to simply sit down, look at the 
> > current mess, and identify common patterns that can be easily factored 
> > out into some shared library code, and all that would be left in the 
> > board or SOC specific files eventually is the data to register with that 
> > library code.  Nothing so complicated as grand plans or planification 
> > that makes it look like a mountain.
> 
> This is exactly the question it comes down to. So far, we have focused
> on cleaning up platforms bit by bit. Given sufficient resources, I'm
> sure this can work. You assume that continuing on this path is the
> fastest way to clean up the whole mess, while my suggestion is based
> on the assumption that we can do better by starting a small fork.

I don't think any fork would gain any traction.  That would only, heh, 
fork the work force into two suboptimal branches for quite a while, and 
given that we're talking about platform code, by the time the new branch 
is usable and useful the hardware will probably be obsolete.  The only 
way this may work is for totally new platforms but we're not talking 
about a fork in that case.

> I think we can both agree that by equally distributing the workforce
> to both approaches, we'd be off worse than doing one of them right ;-)

Absolutely.

> > I think what is needed here is a bunch of people willing to work on such 
> > things, extracting those common patterns, and creating the 
> > infrastructure to cover them.  Once that is in place then we will be in 
> > a position to push back on code submissions that don't use that 
> > infrastructure, and be on the lookout for new patterns to emerge.
> > 
> > Just with the above I think there is sufficient work to keep us busy for 
> > a while.
> 
> That is true, and I think we will need to do this. But as far as I can tell,
> the problems that you talk about addressing are a different class from the
> ones I was thinking of, because they only deal with areas that are already
> isolated drivers with an existing API.

They are areas with the best return on the investment.  This has the 
potential of making quite a bunch of code go away quickly.  And the 
goal is indeed to keep platform code hooking into existing APIs under 
control, so that global maintenance tasks such as the one tglx did are 
less painful.  Obscure board code that no one else care about because no 
other boards share the same hardware model, and which doesn't rely on 
common kernel infrastructure, is not really a problem even if it looks 
like crap because no one will have to touch it.  And eventually the 
board will become unused and we'll just delete that code.

> The things that I see as harder to do are where we need to change the
> way that parts of the platform code interact with each other:
> 
> * platform specific IOMMU interfaces that need to be migrated to common
>   interfaces

This can be done by actually forking the platform specific IOMMU code 
only, just for the time required to migrate drivers to the common 
interface.

> * duplicated but slightly different header files in include/mach/

Oh, actually that's part of the easy problems.  This simply require time 
to progressively do the boring work.

With CONFIG_ARM_PATCH_PHYS_VIRT turned on we can get rid of almost all 
instances of arch/arm/mach-*/include/mach/memory.h already.

Getting rid of all instances of arch/arm/mach-*/include/mach/vmalloc.h 
can be trivially achieved by simply moving the VMALLOC_END values into 
the corresponding struct machine_desc instances.

And so on for many other files.  This is all necessary for the 
single-binary multi-SOC kernel work anyway.

> * static platform device definitions that get migrated to device tree
>   definitions.

That require some kind of compatibility layer to make the transition 
transparent to users.  I think Grant had some good ideas for this.

> Changing these tree-wide feels like open-heart surgery, and we'd spend
> much time trying not to break stuff that could better be used to fix
> other stuff.

Well, depends how you see it.  Sure this might cause some occasional 
breakages, but normally those should be pretty obvious and easy to fix.  
And the more we can do that stuff, the better future code adhering to the 
new model will be.

> The example that I have in mind is the time when we had a powerpc and a
> ppc architecture in parallel, with ppc supporting a lot of hardware
> that powerpc did not, but all new development getting done on powerpc.
> 
> This took years longer than we had expected at first, but I still think
> it was a helpful fork. On ARM, we are in a much better shape in the
> core code than what arch/ppc was, so there would be no point forking
> that, but the problem on the platform code is quite similar.

Nah, I don't think we want to go there at all. The problem on the 
platform code is probably much worse on ARM due to the greater diversity 
of supported hardware.  If on PPC moving stuff across the fork took more 
time on a year scale than expected, I think that on ARM we would simply 
never see the end of it.  And the incentive would not really be there 
either, unlike when the core code is concerned and everyone is affected.


Nicolas
