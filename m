Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0EOWqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 18:46:44 -0400
Received: from www.tglx.de ([62.245.132.106]:47707 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0EOWqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 18:46:42 -0400
Date: Sun, 16 May 2010 00:45:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
Message-ID: <alpine.LFD.2.00.1005152323070.3199@localhost.localdomain>
References: <1273887635-27610-1-git-send-email-venki@google.com 87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Sat, 15 May 2010, Dan Magenheimer wrote:

> > From: Andi Kleen [mailto:andi@firstfloor.org]
> >
> > > Kernel information about calibrated value of tsc_khz and
> > > tsc_stability (result of tsc warp test) are useful bits of
> > information
> > > for any app that wants to use TSC directly. Export this read_only
> > > information in sysfs.
> > 
> > Is this really a good idea?  It will encourage the applications
> > to use RDTSC directly, but there are all kinds of constraints on
> 
> Indeed, that is what it is intended to do.

And you better do not. 

Short story: TSC sucks in all aspects. Never ever let an application
rely on it how tempting it may be.
 
> > that. Even the kernel has a hard time with them, how likely
> > is it that applications will get all that right?
> 
> That's the point of exposing the tsc_reliable kernel data.

The tsc_reliable bit is useless outside of the kernel.

> If the processor has Invariant TSC and the system has
> successfully passed Ingo's warp test and, as a result
> the kernel is using TSC as a clocksource, why not enable
> userland apps that need to obtain timestamp data
> tens or hundreds of thousands of times per second to
> also use the TSC directly?

Simply because at the time of this writing there is no single reliable
TSC instance available.

Yeah, the CPU has that "P and C state invariant feature bit", but it's
_not_ worth a penny.

Lemme explain some of the reasons in random order:

1) SMI:

   We have proof that SMIs fiddle with the TSC to hide the fact that
   they happened. Yes, that's stupid, but a matter of fact. We have no
   reliable way to detect that shit in the kernel yet, but we are
   working on it. Some of those "intelligent" BIOS fkcups can be
   detected already and all we can do is disable TSC. 

   That's going to be easier once the TSC is not longer writeable and
   instead we get an writeable per cpu offset register. That way we
   can observe the SMI tricks way easier, but even then we cannot
   reliably undo them before some TSC user which is out of the kernels
   control can access it.

2) Boot offset / hotplug

   Even if the TSC is completely in sync frequency wise there is no
   way to prevent per core/HT offsets. I'm writing this from a box
   where a perfectly in sync TSC (with the nice "I'm stable and
   reliable" bit set) is hosed by some BIOS magic which manages to
   offset the non boot cpu TSCs by > 300k cycles.

3) Multi socket

   The "reliable" TSCs of a package are driven by the same clock, but
   on multi socket systems this is not the case. Each socket derives
   its TSC clock via a PLL from a global distributed clock at least in
   theory. But there is no guarantee that a board manufacturer really
   distributes that global base clock and instead uses a separate
   "global" clock on each socket.

   Aside of that even if all the PLLs are driven by the same global
   clock there is no guarantee that the resulting PLL'ed clocks are in
   sync. They are not, and they never ever will be. The PLL accuracy
   differs in the ppm range and is also prone to temperature
   variations. The result over time is that the TSCs of different
   sockets diverge via drift in an observable way. We have bug reports
   about resulting user space observable time going backwards problems
   already.

> > It would be better to fix them to use the vsyscalls instead.
> > Or if they can't use the vsyscalls for some reason today fix them.
> 
> The problem is from an app point-of-view there is no vsyscall.
> There are two syscalls: gettimeofday and clock_gettime.  Sometimes,
> if it gets lucky, they turn out to be very fast and sometimes
> it doesn't get lucky and they are VERY slow (resulting in a performance
> hit of 10% or more), depending on a number of factors completely
> out of the control of the app and even undetectable to the app.

And they get slow for a reason: simply because the stupid hardware is
not reliable whether it has some "I claim to be reliable tag" on it or
not.

> Note also that even vsyscall with TSC as the clocksource will
> still be significantly slower than rdtsc, especially in the
> common case where a timestamp is directly stored and the
> delta between two timestamps is later evaluated; in the
> vsyscall case, each timestamp is a function call and a convert
> to nsec but in the TSC case, each timestamp is a single
> instruction.

That is all understandable, but as long as we do not have some really
reliable hardware I'm going to NACK any exposure of the gory details
to user space simply because I have to deal with the fallout of this.

What we can talk about is a vget_tsc_raw() interface along with a
vconvert_tsc_delta() interface, where vget_tsc_raw() returns you an
nasty error code for everything which is not usable.

> > This way if anything changes again in TSC the kernel could
> > shield the applications.
> 
> If tsc_reliable is 1, the system and the kernel are guaranteeing

Wrong. The kernel is not guaranteeing anything. See above.

> to the app that nothing will change in the TSC.  In an Invariant
> TSC system that has passed Ingo's warp test (to eliminate the
> possibility of a fixed interprocessor TSC gap due to a broken BIOS
> in a multi-node NUMA system), if anything changes in the clock
> signal that drives the TSC, the system is badly broken and far
> worse things -- like inter-processor cache incoherency -- may happen.
> 
> Is it finally possible to get past the horrible SMP TSC problems
> of the past and allow apps, under the right conditions, to be able
> to use rdtsc again? This patch argues "yes".

Dream on while working with the 2 machines at your desk which
represent about 90% of the sane subset in the x86 universe!

We are working on solutions to get the TSC reliably usable in the case
of "P/C state invariant" feature bit set, but that will be restricted
to a vsyscall and you won't be able to use it realiably in the way you
envision until either

  - chip manufacturers finally grasp that reliable and fast access to
    timestamps is something important

  - BIOS tinkeres finally grasp that fiddling with time is a NONO - or
    chip manufactures prevent them from doing so

or until we get something which myself an others proposed > 10years
ago: 

   A simple master clock driven 1MHZ == resolution 1us counter which
   can be synced / preset by simple mechanisms and which was btw.
   developed in 1990es cluster computing environments.


Thanks,
	
	tglx
