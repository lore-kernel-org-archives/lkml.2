Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab1DAWJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 18:09:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab1DAWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 18:09:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Sat, 2 Apr 2011 00:08:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Detlef Vollmann <dv@vollmann.ch>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011750.17344.arnd@arndb.de> <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1104011441150.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104020008.16795.arnd@arndb.de>
X-Provags-ID: V02:K0:GEE+zhCVT5UbBujFLSMHdSEUsy2SLwDobyAOsU1vO1u
 49pud1A1gYT5wipULv9WITynLSDeDJWunLanai6bxauyGLTk5y
 j5imf7SnkOsbUvK3vNf2VfbEeTa2pQCzGUPkjYBgDz5SKWC6ND
 fhAI/DFJCOuFBv1p4hmpj1E/T2jYkH39f953E5PJMedNzdyKoX
 BkTRZfNJPxLH69Eg6Jbbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011 21:54:47 Nicolas Pitre wrote:
> On Fri, 1 Apr 2011, Arnd Bergmann wrote:
> > 
> > I thought new ones were generally Cortex-M3 based. Either way, even
> > if there are exceptions, focusing on ARMv7 at first should give
> > a good representation of the new development.
> 
> The actual CPU core doesn't matter at all.  Whether it is ARM926EJ-S, 
> XScale, PJ4 or Cortex-A8/A9, _that_ is the part that is extremely well 
> maintained and abstracted already.  The focus should instead be put on 
> those platforms that are the most used irrespective of their cores.  And 
> by selecting the most used platforms, we have a greater chance to create 
> community momentum, and good examples will be spread more quickly.

Agreed.

> I however don't think it is practical to go off in a separate 
> mach-nocrap space and do things in parallel.  Taking OMAP as an example, 
> there is already way too big of an infrastructure in place to simply 
> rewrite it in parallel to new OMAP versions coming up.
>
> It would be more useful and scalable to simply sit down, look at the 
> current mess, and identify common patterns that can be easily factored 
> out into some shared library code, and all that would be left in the 
> board or SOC specific files eventually is the data to register with that 
> library code.  Nothing so complicated as grand plans or planification 
> that makes it look like a mountain.

This is exactly the question it comes down to. So far, we have focused
on cleaning up platforms bit by bit. Given sufficient resources, I'm
sure this can work. You assume that continuing on this path is the
fastest way to clean up the whole mess, while my suggestion is based
on the assumption that we can do better by starting a small fork.

I think we can both agree that by equally distributing the workforce
to both approaches, we'd be off worse than doing one of them right ;-)

> Two patterns were identified so far, and they are:
> 
> 1) GPIO drivers
> 
>    As Linus observed, in the majority of the cases GPIOs are accessed 
>    through simple memory-mapped registers.  Some have absolute state 
>    registers, the others have separate clear/set registers.  Suffice to 
>    create two generic GPIO drivers each covering those two common cases, 
>    and those generic drivers would simply register with the higher level 
>    gpiolib code, and all the board code would have to do is to provide 
>    the data for those GPIOs (register offsets, number of GPIOs, etc.).  
>    Whether this data eventually comes from DT is an orthogonal issue.

Yes, this sounds like a great idea, but it's also unrelated to whether
we'd do a new platform, or introduce this into the existing platforms.

> 2) IRQ chip drivers
> 
>    Again, as Thomas observed, the same issue exists with the majority of 
>    the IRQ chip drivers.  Most of them follow a common simple pattern 
>    that can be abstracted in some generic library code due to their very 
>    similar mode of operation.  Writing a common driver would leave the 
>    board specific code with only a data table describing hardware 
>    registers.

Also sounds really good.

> I think what is needed here is a bunch of people willing to work on such 
> things, extracting those common patterns, and creating the 
> infrastructure to cover them.  Once that is in place then we will be in 
> a position to push back on code submissions that don't use that 
> infrastructure, and be on the lookout for new patterns to emerge.
> 
> Just with the above I think there is sufficient work to keep us busy for 
> a while.

That is true, and I think we will need to do this. But as far as I can tell,
the problems that you talk about addressing are a different class from the
ones I was thinking of, because they only deal with areas that are already
isolated drivers with an existing API.

The things that I see as harder to do are where we need to change the
way that parts of the platform code interact with each other:

* platform specific IOMMU interfaces that need to be migrated to common
  interfaces
* duplicated but slightly different header files in include/mach/
* static platform device definitions that get migrated to device tree
  definitions.

Changing these tree-wide feels like open-heart surgery, and we'd spend
much time trying not to break stuff that could better be used to fix
other stuff.

The example that I have in mind is the time when we had a powerpc and a
ppc architecture in parallel, with ppc supporting a lot of hardware
that powerpc did not, but all new development getting done on powerpc.

This took years longer than we had expected at first, but I still think
it was a helpful fork. On ARM, we are in a much better shape in the
core code than what arch/ppc was, so there would be no point forking
that, but the problem on the platform code is quite similar.

	Arnd
