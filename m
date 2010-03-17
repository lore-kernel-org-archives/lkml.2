Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0CQDld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:41:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34747 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0CQDl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:41:29 -0400
Subject: Re: [PATCH] Timekeeping: Fix dead lock in update_wall_time by
 correct shift convertion.
From: john stultz <johnstul@us.ibm.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4e5ebad51003161958n6db293f0y6da99483bf96ada0@mail.gmail.com>
References: <1268735629.5075.8.camel@eight.analog.com>
	 <1268763512.1676.7.camel@work-vm>
	 <4e5ebad51003161958n6db293f0y6da99483bf96ada0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 20:41:25 -0700
Message-ID: <1268797285.3130.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 10:58 +0800, Sonic Zhang wrote:
> On Wed, Mar 17, 2010 at 2:18 AM, john stultz <johnstul@us.ibm.com> wrote:
> > On Tue, 2010-03-16 at 18:33 +0800, sonic zhang wrote:
> >> update_wall_time() runs into dead lock after kernel traps into kgdb and exits
> >> per user's request some seconds layer. This is root caused to be wrong
> >> calculation of maxshift in update_wall_time().
> >>
> >> The shift in update_wall_time() and logarithmic_accumulation() is
> >> clock shift. In order to generate ntp_error and maxshift correctly,
> >> shift convertion between clock and ntp should be done properly.
> >
> > Hmmm. I don't believe this patch is correct, as it redefines the units
> > that ntp_error accumulates (which will cause problems in ntp correction)
> >
> 
> What units does the ntp_error accumulates? NTP tick or clock source
> tick? shift varable here is clock source shift.

Sorry for the confusion. Its a bit complex.

ntp_error and tick_length are kept in NTP_SCALE_SHIFT shifted
nanoseconds.

xtime_interval and xtime_nsec are in clocksource shifted nanoseconds.

ntp_error_shift is the difference between NTP_SCALE_SHIFT and the
clocksource's shift value.


We mostly work with clocksource shifted units, but when we are
calculating the ntp_error we have to shift things up further to
NTP_SCALE_SHIFT. 


Then, to further complicate things, the logarithmic accumulation uses
its own shift value which is used to accumulate larger chunks of time
into both xtime_nsec and ntp_error_shift.


> > Could you provide some more details on how you triggered the issue (what
> > hardware, and what clocksource was being used at the time), as well as
> > the analysis you did that suggested this solution?
> >
> If you enabled KGDB over ethernet debugging in kernel hacking, you
> will see the dead lock after you connect your gdb to kernel and set a
> breakpoint, wait for 30 seconds and continue kernel. The direct cause
> is the clock shift calculated after kernel resumes is bigger than the
> maxshift calculated based on NTP tick_length. So, the loop "while
> (offset >= timekeeper.cycle_interval)" never exists, because offset is
> too big to be reduced properly before shift(limited to maxshift)
> becomes negative value. The offset value in my test is 1553274374.
> 
> The hardware is blackfin and any hardware clock source, gptimer or core counter.
> 
> > It may be that we are hitting an overflow in the ntp_error value, which
> > could possibly cause some strange clock steering. Not sure about a
> > deadlock though.
> >
> > Can you trigger this issue when you replace:
> >
> >        offset = logarithmic_accumulation(offset, shift);
> > with
> >        offset = logarithmic_accumulation(offset, 0);
> >
> > ?
> 
> Yes, this workaround never dead loop because the shift is never
> decreased to negative value and need about 3883 loops to finish when
> offset is 1553274374.

Ah. Ok. So what's happening is that we've actually hit the maxshift
value, which limits shift. This means we need more then shift loops to
accumulate the entire offset, and so that triggers the negative shift
value. 

Duh... I actually had some protection from this in my first
implementation of the logrithmic accumulation code, but then i figured
it was redundant in the "pure" case where we fully accumulate everything
so I dropped it. Of course, the maxshift limit breaks that pure-case.

So the easy fix (see below) is to just limit shift so we never push it
negative. It hits zero and then finish the accumulation with the base
interval unit.

However, if we hit the max, that means we will likely be spinning quite
a bit at the low end when shift bottoms out. So we really should try to
loop multiple times with the larger shift value so we're as fast as
possible here. I suspect it would be something like:

	if (offset <= timekeeper.cycle_interval<<shift)
		shift--

But I probably need to think it through some more. (I was just about to
leave work when I got your mail, so I'll try to mull it over tonight and
refine it tomorrow.)

In the mean time, could you test the more trivial fix below to make sure
it resolves the issue? And if you have time, it would be great if you
could see if the idea in the code snippit above improves things.

Thanks again for catching this issue and reporting it!

thanks
-john



If we actually hit the maxshift limiter, offset is bigger then we will
consume in shift loops. So make sure shift doesn't go negative.

This is likely an non-optimal fix, as we can probably minimize the loop
by only reducing shift when we've consumed all we can at that shift
level.


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1673637..32fec2c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -818,7 +818,8 @@ void update_wall_time(void)
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
-		shift--;
+		if (shift > 0)
+			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */



