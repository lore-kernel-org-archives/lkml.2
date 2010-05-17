Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0EQKWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:22:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43746 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0EQKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:22:22 -0400
Date: Mon, 17 May 2010 12:22:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100517102214.GA20761@basil.fritz.box>
References: <87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dan,

On Sat, May 15, 2010 at 06:29:25AM -0700, Dan Magenheimer wrote:
> The problem is from an app point-of-view there is no vsyscall.
> There are two syscalls: gettimeofday and clock_gettime.  Sometimes,
> if it gets lucky, they turn out to be very fast and sometimes
> it doesn't get lucky and they are VERY slow (resulting in a performance
> hit of 10% or more), depending on a number of factors completely
> out of the control of the app and even undetectable to the app.

What would the application do in the 10% case? 

(Assuming modern kernels, I know older kernels had trouble sometimes):

That's the case when the TSC doesn't work reliably, so if it 
uses it anyways it won't get good time.

It seems to me you're bordering on violating Steinberg's rule
of system programming here :-)

> 
> Note also that even vsyscall with TSC as the clocksource will
> still be significantly slower than rdtsc, especially in the
> common case where a timestamp is directly stored and the
> delta between two timestamps is later evaluated; in the
> vsyscall case, each timestamp is a function call and a convert
> to nsec but in the TSC case, each timestamp is a single
> instruction.

First the single instruction is typically quite slow. Then
to really get monotonous time you need a barrier anyways.

When I originally wrote vsyscalls that overhead wasn't that big
with all that compared to open coding. The only thing that could
be stripped might be the unit conversion. In principle
a new vsyscall could be added for that (what units do you need?) 

I remember when they were converted to clocksources they got
somewhat slower, but I suspect with some tuning work that
could be also fixed again. 

I think glibc also still does a unnecessary indirect jump
(might hurt you if your CPU cannot predict that), but that could
be fixed too. I think I have an old patch for that in fact,
if you're still willing to use the old style vsyscalls.

> 
> > This way if anything changes again in TSC the kernel could
> > shield the applications.
> 
> If tsc_reliable is 1, the system and the kernel are guaranteeing
> to the app that nothing will change in the TSC.  In an Invariant
> TSC system that has passed Ingo's warp test (to eliminate the
> possibility of a fixed interprocessor TSC gap due to a broken BIOS
> in a multi-node NUMA system), if anything changes in the clock

That only handles cases visible at boot. If the TSC breaks
longer term the kernel catches it with its watchdog, but your
user application won't.

> signal that drives the TSC, the system is badly broken and far
> worse things -- like inter-processor cache incoherency -- may happen.

I don't think that's true. There are various large systems with 
non synchronized TSC and I haven't heard of any unique cache coherency
problems on that.

Also often the TSC is actually synchronized, but unfortunately
runs with a offset.

> 
> Is it finally possible to get past the horrible SMP TSC problems
> of the past and allow apps, under the right conditions, to be able
> to use rdtsc again? This patch argues "yes".

Yes but why not let them use vsyscalls? 

I know vsyscalls still have some issues today, but these
would be better fixed than worked around like this.

e.g.

If the idea is to use the TSC on not fully synchronized systems?

I haven't fully kept track, but at some point there was an attempt
to have more POSIX clocks with loser semantics (like per thread 
monotonous). If you use that you'll get fast time (well not day time,
but perhaps useful time) which might be good enough without
hacks like this? 

If the semantics are not exactly right I think more POSIX clocks
could be added too.

Or if the time conversion is a problem we could add a posix_gettime_otherunit()
or so (e.g. with a second vsyscall that converts units so you don't
need to do it in the fast path) 

A long time ago there was also the idea to export the information
if gettimeofday()/clock_gettime() was fast or not. If this helps this could 
be probably revisited. But I'm not sure what the application
should really do in this case.

32bit doesn't have a fast ring 3 gtod() today but that could be also fixed.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
