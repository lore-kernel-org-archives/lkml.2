Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab0KQByS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:54:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52423 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021Ab0KQByR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:54:17 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTimU63uKP1g4OB1wXMLJK85eNA=uTG+ZMbv2_NRv@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
	 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
	 <1289605221.3292.53.camel@localhost.localdomain>
	 <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
	 <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
	 <1289607722.3292.84.camel@localhost.localdomain>
	 <1289609931.3292.87.camel@localhost.localdomain>
	 <AANLkTim27c_pHpawoGw3VyV9qQAF_8twJPTr5kqt6jhW@mail.gmail.com>
	 <1289953570.3860.34.camel@localhost.localdomain>
	 <AANLkTiks_8sjStgGnTGVj-3UemDqP4G8hZuUDhngZhij@mail.gmail.com>
	 <1289956753.3860.57.camel@localhost.localdomain>
	 <AANLkTimU63uKP1g4OB1wXMLJK85eNA=uTG+ZMbv2_NRv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 17:54:10 -0800
Message-ID: <1289958850.3860.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 20:24 -0500, Andrew Lutomirski wrote:
> On Tue, Nov 16, 2010 at 8:19 PM, john stultz <johnstul@us.ibm.com> wrote:
> > On Tue, 2010-11-16 at 19:54 -0500, Andrew Lutomirski wrote:
> >> On Tue, Nov 16, 2010 at 7:26 PM, john stultz <johnstul@us.ibm.com> wrote:
> >> > I'm starting to think we should be pushing the watchdog check into the
> >> > timekeeping accumulation loop (or have it hang off of the accumulation
> >> > loop).
> >> >
> >> > 1) The clocksource cyc2ns conversion code is built with assumptions
> >> > linked to how frequently we accumulate time via update_wall_time().
> >> >
> >> > 2) update_wall_time() happens in timer irq context, so we don't have to
> >> > worry about being delayed. If an irq storm or something does actually
> >> > cause the timer irq to be delayed, we have bigger issues.
> >>
> >> That's why I hit this.  It would be nice if we didn't respond to irq
> >> storms by calling stop_machine.
> >
> > So even if we don't change clocksources, if you have a long enough
> > interrupt storm that delays the hard timer irq, such that the
> > clocksources wrap (or hit the mult overflow), your system time will be
> > lagging behind anyway. So that would be broken regardless of if the
> > watchdog kicked in or not.
> >
> > I suspect that even with such an irq storm, the timer irq will hopefully
> > be high enough priority to be serviced first, avoiding the accumulation
> > loss.
> >
> >
> >> > The only trouble with this, is that if we actually push the max_idle_ns
> >> > out to something like 10 seconds on the TSC, we could end up having the
> >> > watchdog clocksource wrapping while we're in nohz idle.  So that could
> >> > be ugly. Maybe if the current clocksource needs the watchdog
> >> > observations, we should cap the max_idle_ns to the smaller of the
> >> > current clocksource and the watchdog clocksource.
> >> >
> >>
> >> What would you think about implementing non-overflowing
> >> clocksource_cyc2ns on architectures that can do it efficiently?  You'd
> >> have to artificially limit the mask to 2^64 / (rate in GHz), rounded
> >> down to a power of 2, but that shouldn't be a problem for any sensible
> >> clocksource.
> >
> > You would run into accuracy issues. The reason why we use large
> > mult/shift pairs for timekeeping is because we need to make very fine
> > grained adjustments to steer the clock (also just the freq accuracy can
> > be poor if you use too low a shift value in the cyc2ns conversions).
> >
> 
> Why would it be any worse than right now?  We could keep shift as high
> as 32 (or even higher) and use the exact same logic as we use now.

Oh. My apologies, I thought you were suggesting to drop shift down, so
the 64bit mult doesn't overflow, not using a 128 bit mult to just avoid
that issue.

> gcc compiles this code:
> 
> uint64_t mul_64_32_shift(uint64_t a, uint32_t mult, uint32_t shift)
> {
> #if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
>   if (shift >= 32)
>     __builtin_unreachable();
> #endif
>   return (uint64_t)( ((__uint128_t)a * (__uint128_t)mult) >> shift );
> }
> 
> To:
> 
>    0:   89 f0                   mov    %esi,%eax
>    2:   89 d1                   mov    %edx,%ecx
>    4:   48 f7 e7                mul    %rdi
>    7:   48 0f ad d0             shrd   %cl,%rdx,%rax
>    b:   48 d3 ea                shr    %cl,%rdx
>    e:   f6 c1 40                test   $0x40,%cl
>   11:   48 0f 45 c2             cmovne %rdx,%rax
>   15:   c3                      retq
> 
> And if the compiler were a little smarter, it would generate:
> 
> mov    %esi,%eax
> mov    %edx,%ecx
> mul    %rdi
> shrd   %cl,%rdx,%rax
> retq
> 
> So it would be essentially free.

So yes, on 64bit systems it won't be so bad, but again, I'm worried a
bit about overhead on 32bit systems, as clocksource_cyc2ns is in the
gettimeofday hot path for a quite a lot of applications.

But it is an interesting thought.

And something like the following could avoid the overhead most of the
time.
if(unlikely(delta > cs->max_mult64_cycles))
	return cyc2ns128(delta, cs->mult, cs->shift);
return cyc2ns64(delta, cs->mult, cs->shift);

Where we optimize mult/shift pair so for the likely max nohz time
interval, but allow deeper sleeps without problems.

-john


