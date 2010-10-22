Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0JVVAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:00:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698Ab0JVVAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:00:47 -0400
Date: Fri, 22 Oct 2010 14:00:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Message-Id: <20101022140044.d5b0e9ce.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=MRU3Qi6NQfqnCwX34sHL2Rx8AyaqRwrxNVQoM@mail.gmail.com>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
	<20101021150250.f6499506.akpm@linux-foundation.org>
	<201010211823.38287.vapier@gentoo.org>
	<20101021155528.b3d6d027.akpm@linux-foundation.org>
	<AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
	<20101021162410.5c0d6720.akpm@linux-foundation.org>
	<AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
	<20101022133138.6d82f79a.akpm@linux-foundation.org>
	<AANLkTi=MRU3Qi6NQfqnCwX34sHL2Rx8AyaqRwrxNVQoM@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 16:47:36 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> On Fri, Oct 22, 2010 at 16:31, Andrew Morton wrote:
> > On Fri, 22 Oct 2010 16:14:49 -0400 Mike Frysinger wrote:
> >> On Thu, Oct 21, 2010 at 19:24, Andrew Morton wrote:
> >> > On Thu, 21 Oct 2010 19:04:36 -0400 Mike Frysinger wrote:
> >> >> you can say "lazy" all you like. __i dont see the point in going that route.
> >> >
> >> > Try
> >> >
> >> > __ __ __ __grep HAVE arch/x86/Kconfig
> >> >
> >> > If all of those were instead to use some random #define which the
> >> > particular feature happened to define in some header file then we would
> >> > have a mess on our hands.
> >>
> >> fun times. __new tact.
> >>
> >> Luca: your new atomic64_t test build fails on all arches that lack
> >> atomic64_t. __please fix.
> >
> > That's only part of the problem. __The following won't build also:
> >
> > net/rds
> 
> not true.  that code base is already using my suggestion:
> net/rds/rds.h:
> #ifdef ATOMIC64_INIT
> #define KERNEL_HAS_ATOMIC64
> #endif

IOW, your suggestion led to a nasty local hack.  One which would be
unneeded had we implemented this properly via Kconfig.

> but this isnt a matter of "use atomic64_t or atomic_t" ... this code
> manually takes care of doing a spinlock around a u64 member.  i
> imagine if you'd notice this before it was merged you'd have made them
> fix this cleanly.

I'd have suggested that they use Kconfig.

I'd also have suggested that they implement a generic spinlocked
atomic64 library rather than open-coding stuff down in net/rds/.

People do tend to prefer to do localised expedient things rather than
sticking their necks out and implementing proper, generic kernel-wide
functions.  If I see it happen, I'll tell them.  Usually I don't see
it until months after it's merged :(

> > kernel/perf_event.c
> 
> also not true -- this requires arches to opt in to HAVE_PERF_EVENTS
> and only arches which have validated it works (i.e. they have
> atomic64) have done that

kernel/perf_event.c has a dependency on the missing CONFIG_HAVE_ATOMIC64.

> > drivers/staging/octeon
> 
> not an issue -- this depends on CPU_CAVIUM_OCTEON which is only
> provided by mips which provides atomic64
> 
> > drivers/infiniband/hw
> 
> the only code usage of atomic64 is in code that already depends on the
> Kconfig symbol 64BIT

Again, that's just wrong and it's a fluke.  Will break if a 64-bit arch
doesn't implement atomic64.

> as for why it depends on this, i dont know ... maybe it's because of atomic64_t
> 
> > Or, much better, we implement atomic64 on the offending architectures.
> 
> i dont want to give people the impression that 64 atomics are free to
> use if in reality they're pretty expensive.  on a Blackfin system, i'd
> need to implement every access with basically a spinlock.

spin_lock_irqsave(), really.  Becomes local_irq_save() on UP.

But what's the alternative?  Either entire features become unavailable
on those architectures or we grow local hacks like rds_ib_get_ack()
which, yup, uses spin_lock_irqsave().

> > with more to come.  These things should be made dependent upon
> > CONFIG_HAVE_ATOMIC64 in Kconfig.  (Can't use #ifdef ATOMIC64_INIT for this!)
> 
> these are actually compelling arguments unlike the original one.  even
> if all these examples ended up not really being true (only the new
> atomic64_t test code is available to build on arches that lack
> atomic64).

Really, the atomic64_t implementation was imcomplete.  It should have
provided the generic arch-neutral fallback code.

