Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1G2HZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:25:04 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16909 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754908Ab1G2HZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:25:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgDAAFgMk55LCkBgWdsb2JhbAA1AQEEATgBJyUFDAkDDgo6FAEqAygCF6dfFQEBFiYliHzAXg6FVF8EoyZJ
Date: Fri, 29 Jul 2011 17:24:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [3.0-rc0 Regression]: legacy vsyscall emulation increases user
 CPU time by 20%
Message-ID: <20110729072426.GF5404@dastard>
References: <20110729013830.GC5404@dastard>
 <CAObL_7GdxD07-9_aYZBDqutQD6cVz2kYHXAcUwDWr6NkqRdByw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7GdxD07-9_aYZBDqutQD6cVz2kYHXAcUwDWr6NkqRdByw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:30:49PM -0400, Andrew Lutomirski wrote:
> On Thu, Jul 28, 2011 at 9:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Hi folks,
> >
> > It-s merge window again, which means I'm doing my usual "where did
> > the XFS performance go" bisects again. The usual workload:
> >
> 
> [...]
> 
> >
> > The completion time over multiple runs is ~8m10s +/-5s, and the user
> > CPU time is roughly 245s +/-5s
> >
> > Enter 5cec93c2 ("x86-64: Emulate legacy vsyscalls") and the result
> > ends up at:
> >
> >     0     48000000            0     108975.2          9507483
> >     0     48800000            0     114676.5          8604471
> >     0     49600000            0      98062.0          8921525
> >     0     50400000            0     103864.7          8218302
> > 287.35user 2933.90system 8:33.11elapsed 627%CPU (0avgtext+0avgdata 82560maxresident)k
> > 0inputs+0outputs (1664major+2603457minor)pagefaults 0swaps
> >
> > Noticable slow wall time with more variance - it's at 8m30s +/-10s,
> > and the user CPU time is at 290s +/-5s. So the benchmark is slower to
> > complete and consumes 20% more CPU in userspace. The following commit
> > c971294 x86-64: ("Improve vsyscall emulation CS and RIP handling")
> > also contributes to the slowdown a bit.
> 
> I'm surprised that the second commit had any effect.

It's probably noise - the overhead numbers dropping out of fsmark
seemed to be slightly higher and the added user time about another
5s on average on top of the 50s the previous patch added. With it
taking 15-20min as bisect step, I didn't run more than one test at
each commit - the bisect took 4.5 hours as it was to find the commit
responsible.

So, probably just noise.

> > FYI, fs_mark does a lot of gettimeofday() calls - one before and
> > after every syscall that does filesystem work so it can calculate
> > the syscall times and the amount of time spent not doing syscalls.
> > I'm assuming this is the problem based on the commit message.
> > Issuing hundreds of thousands of getimeofday calls per second spread
> > across multiple CPUs is not uncommon, especially in benchmark or
> > performance measuring software. If that is the cause, then these
> > commits add -significant- overhead to that process.
> 
> I put some work into speeding up vdso timing in 3.0.  As of Linus' tree now:
> 
> # test_vsyscall bench
> Benchmarking  syscall gettimeofday      ...   7068000 loops in
> 0.50004s =   70.75 nsec / loop
> Benchmarking     vdso gettimeofday      ...  23868000 loops in
> 0.50002s =   20.95 nsec / loop
> Benchmarking vsyscall gettimeofday      ...   2106000 loops in
> 0.50004s =  237.44 nsec / loop

How does that compare to 3.0 before these changes? No point telling
me how it performs without something to compare it to and it doesn't
tell me if gettimeofday actually slowed down or not...

> So clock_gettime(CLOCK_MONOTONIC) is faster, more correct, and more
> precise than gettimeofday.  IMO you should fix your benchmark :)

So you're going to say that to everyone who currently uses
gettimeofday() a lot? ;)

> More seriously, though, I think it's a decent tradeoff to slow down
> some extremely vsyscall-heavy legacy workloads to remove the last bit
> of nonrandomized executable code.  The only way this should show up to
> any significant extent is on modern rdtsc-using systems that make a
> huge number of vsyscalls.  On older machines, even the cost of the
> trap should be smallish compared to the cost of HPET / acpi_pm access.
> 
> >
> > Assuming this is the problem, can this be fixed without requiring
> > the whole world having to wait for the current glibc dev tree to
> > filter down into distro repositories?
> 
> How old is your glibc?  gettimeofday has used the vdso since:

It's 2.11 on the test machine, whatever that translates to. I
haven't really changed the base userspace for about 12 months
because if I do I invalidate all my historical benchmark results
that I use for comparisons.

If I have to upgrade it to something more recent (I note that the
current libc6 is 2.13 in debian unstable) then I will but there's
going to be plenty of people that see this if 2.11 is not recent
enough....

> speeds up the gettimeofday emulated vsyscall from 237 ns to 157 ns.

I've still got nothing to compare that against... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
