Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0KQA0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:26:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39995 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab0KQA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:26:18 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTim27c_pHpawoGw3VyV9qQAF_8twJPTr5kqt6jhW@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
	 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
	 <1289605221.3292.53.camel@localhost.localdomain>
	 <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
	 <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
	 <1289607722.3292.84.camel@localhost.localdomain>
	 <1289609931.3292.87.camel@localhost.localdomain>
	 <AANLkTim27c_pHpawoGw3VyV9qQAF_8twJPTr5kqt6jhW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 16:26:10 -0800
Message-ID: <1289953570.3860.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 19:05 -0500, Andrew Lutomirski wrote:
> On Fri, Nov 12, 2010 at 7:58 PM, john stultz <johnstul@us.ibm.com> wrote:
> > On Sat, 2010-11-13 at 00:22 +0000, john stultz wrote:
> >> On Fri, 2010-11-12 at 18:51 -0500, Andrew Lutomirski wrote:
> >> > Also wrong if cs_elapsed is just slightly less than wd_wrapping_time
> >> > but the wd clocksource runs enough faster that it wrapped.
> >>
> >> Ok. Good point, that's a problem. Hrmmmm. Too much math for Friday. :)
> >
> > I have a hard time leaving things alone. :)
> >
> > So this still has the issue of the u64%u64 won't work on 32bit systems,
> > but I think once I rework the modulo bit the following should be what
> > you were describing.
> >
> > It is ugly, so let me know if you have a cleaner way.
> >
> 
> I'm playing with this stuff now, and it looks like my (invariant,
> constant, single-package i7) TSC has a max_idle_ns of just over 3
> seconds.  I'm confused.

Yea. I hit this wall the other day as well. So my patch is invalid
because its assuming the TSC deltas will be large, but for any
unreasonable delay, we'll actually end up with multiply overflows,
causing the tsc ns interval to be invalid as well.

I'm starting to think we should be pushing the watchdog check into the
timekeeping accumulation loop (or have it hang off of the accumulation
loop).

1) The clocksource cyc2ns conversion code is built with assumptions
linked to how frequently we accumulate time via update_wall_time().

2) update_wall_time() happens in timer irq context, so we don't have to
worry about being delayed. If an irq storm or something does actually
cause the timer irq to be delayed, we have bigger issues. 

The only trouble with this, is that if we actually push the max_idle_ns
out to something like 10 seconds on the TSC, we could end up having the
watchdog clocksource wrapping while we're in nohz idle.  So that could
be ugly. Maybe if the current clocksource needs the watchdog
observations, we should cap the max_idle_ns to the smaller of the
current clocksource and the watchdog clocksource.

Oof. Its just ugly. If I can get some time this week I'll try to take a
rough swing at refactoring that code.

thanks
-john




