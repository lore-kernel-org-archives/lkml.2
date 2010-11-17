Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab0KQBTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:19:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35504 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0KQBTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:19:20 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTiks_8sjStgGnTGVj-3UemDqP4G8hZuUDhngZhij@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 17:19:13 -0800
Message-ID: <1289956753.3860.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 19:54 -0500, Andrew Lutomirski wrote:
> On Tue, Nov 16, 2010 at 7:26 PM, john stultz <johnstul@us.ibm.com> wrote:
> > I'm starting to think we should be pushing the watchdog check into the
> > timekeeping accumulation loop (or have it hang off of the accumulation
> > loop).
> >
> > 1) The clocksource cyc2ns conversion code is built with assumptions
> > linked to how frequently we accumulate time via update_wall_time().
> >
> > 2) update_wall_time() happens in timer irq context, so we don't have to
> > worry about being delayed. If an irq storm or something does actually
> > cause the timer irq to be delayed, we have bigger issues.
> 
> That's why I hit this.  It would be nice if we didn't respond to irq
> storms by calling stop_machine.

So even if we don't change clocksources, if you have a long enough
interrupt storm that delays the hard timer irq, such that the
clocksources wrap (or hit the mult overflow), your system time will be
lagging behind anyway. So that would be broken regardless of if the
watchdog kicked in or not.

I suspect that even with such an irq storm, the timer irq will hopefully
be high enough priority to be serviced first, avoiding the accumulation
loss.


> > The only trouble with this, is that if we actually push the max_idle_ns
> > out to something like 10 seconds on the TSC, we could end up having the
> > watchdog clocksource wrapping while we're in nohz idle.  So that could
> > be ugly. Maybe if the current clocksource needs the watchdog
> > observations, we should cap the max_idle_ns to the smaller of the
> > current clocksource and the watchdog clocksource.
> >
> 
> What would you think about implementing non-overflowing
> clocksource_cyc2ns on architectures that can do it efficiently?  You'd
> have to artificially limit the mask to 2^64 / (rate in GHz), rounded
> down to a power of 2, but that shouldn't be a problem for any sensible
> clocksource.

You would run into accuracy issues. The reason why we use large
mult/shift pairs for timekeeping is because we need to make very fine
grained adjustments to steer the clock (also just the freq accuracy can
be poor if you use too low a shift value in the cyc2ns conversions).


> The benefit would be that sensible clocksources (TSC and 64-bit HPET)
> would essentially never overflow and multicore systems could keep most
> cores asleep for as long as they liked.
> 
> (There's yet another approach: keep the current clocksource_cyc2ns,
> but add an exact version and only use it when waking up from a long
> sleep.)

We're actually running into this very issue in the sched_clock threads
that have been discussed. Namely that the clocksource/timekeeping code
is very intertwined around the assumptions and limits of the freq that
update_wall_time is called. I'm currently working to consolidate those
assumptions into manageable tunables via clocksource_register_khz/hz
patches so we don't end up with odd cases where some idle limit gets
pushed out and stuff breaks on half of the clocksources out there, but
not the other half.

So yea, there are a couple of approaches here:

It may just be that we should drop the watchdog infrastructure and
either embed that functionality into the TSC code itself (since it is
the only user), allowing more flexible and rough conversion factors with
other watchdog hardware similar to what you suggest, instead of using
the clocksource conversion functions.

Or we can embed the watchdog timer into a function of the timekeeping
accumulation code, the constraints of of which the clocksource are
written to.

Neither is really a pretty solution. I suspect second would end up being
a little cleaner, and would allow other troublesome clocksources to make
use of it in the future. But the first does isolate the issue close to
the problematic hardware.

thanks
-john




