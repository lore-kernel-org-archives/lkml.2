Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0LHWsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:48:07 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53518 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab0LHWsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:48:03 -0500
Subject: Re: [RFC][PATCH] timekeeping: Keep xtime_nsec remainder separate
 from ntp_error
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1291839317.5015.1139.camel@gandalf.stny.rr.com>
References: <1291833054.5015.1133.camel@gandalf.stny.rr.com>
	 <1291838382.2909.17.camel@work-vm>
	 <1291839317.5015.1139.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 14:47:57 -0800
Message-ID: <1291848477.2909.152.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 15:15 -0500, Steven Rostedt wrote:
> On Wed, 2010-12-08 at 11:59 -0800, john stultz wrote:
> 
> > Hey Steven!
> > 
> > Thanks for the great analysis and tooling to help find these unexpected
> > behaviors! 
> > 
> > Sadly, I believe your proposed change can still cause minor nsec
> > inconsistencies from gettimeofday/vgettimeofday. In fact, the previous
> > implementation where the nsec inconsistency error was observed preserved
> > the sub-nanosecond remainder in xtime_nsec.
> 
> What inconsistencies exactly? Not to say they aren't any, but I really
> want to know exactly what is happening. Even the change log that Roman
> showed in that commit does not explain well what the issue was.

So, it has to do with the fact that X cycles doesn't exactly match Y ns,
and the way we do our accumulation with high precision.

There are two components to the gettimeofday calculation: the
accumulated base, stored in nanoseconds (this is xtime) and the current
cycle delta, converted to nanoseconds.

gtod: xtime + cyc2ns(delta)


During the tick, when we do our accumulation into xtime, we do it with
very high precision (clocksource shifted nanoseconds). For this
accumulation, there are three components: xtime, the cycle delta, and
the sub-ns remainder. The sub-ns remainder may take various forms. In
earlier code it was stored in xtime_nsec, with the current code we round
xtime up to the next nsec, and store -(1ns - remainder) into the
ntp_error, in your patch it is the new remainder value.

Now, when we accumulate the cycle delta, we do so in fixed chunks with
higher precision then we use for gettimeofday (again using shifted
nanoseconds). This may leave some unaccumulated cycles in delta.

accumulation:  (xtime + remainder) += high precision chunk of delta

The key here is that a gtod called right before and right after the
accumulation, if given the same cycle value should get the same number
(ie: imagine no time changed).

Now looking at Roman's commit message:

>     timekeeping: fix rounding problem during clock update
>     
>     Due to a rounding problem during a clock update it's possible for readers
>     to observe the clock jumping back by 1nsec.  The following simplified
>     example demonstrates the problem:
>     
>     cycle       xtime
>     0   0
>     1000        999999.6
>     2000        1999999.2
>     3000        2999998.8

The above shows the standard accumulation chunks. 
1000 cycles = 999999.6 ns

>     ...
>     
>     1500 =      1499999.4
>     =   0.0 + 1499999.4
>     =   999999.6 + 499999.8

This is an illustration of if the accumulation triggers @1500 cycles.

It initially seems a little contrived, because the accumulation chunks
should match the accumulation period (aka: the tick period). But the
tick interrupt may not be exactly matched, due to the timer hardware
freq not being able to match HZ exactly, or some other slight difference
in the hardware speed. So for instance, the tick may always land just a
little early, so 999, then 1998, etc.. In that case the first tick we
won't accumulate anything, then the second we will accumulate 1000,
leaving 998 for the next time. Anyway, the net of it is, that the code
can't assume that the tick will land at a specific time. 

So again, assume the accumulation is late or whatever, and triggers at
1500 cycles.

In this case, we accumulate a single chunk of 1000 cycles, leaving 500
cycles for the next tick/accumulation period.

Pre-accumulation: 
	xtime = 0, rem = 0, delta = 1500
	gtod:	0 + cyc2ns(1500)
		0 + 1499999 (note cyc2ns truncated the 0.4 remainder)
		1499999

Accumulation occurs.

Post-accumulation:
	xtime = 999999, rem=0.6, delta = 500

	gtod: 	999999 + cyc2ns(500)
		999999 + 499999 (cyc2ns truncates the .8 remainder)
		1499998

And there is the 1ns inconsistency!


With the current code, in accumulation we round xtime up and add the
remainder into the ntp_error.

Post accumulation:
	xtime = 1000000, ntp_error=-0.4, delta = 500

	gtod:	1000000 + cyc2ns(500)
		1000000 + 499999 (cyc2ns truncates the .8 remainder)
		1499999

Then in the adjustment step, we take the ntp_error into account and we
will slow the clocksource freq down a bit to make sure the long-term
accuracy is still correct (so we don't gain ~1ns per tick).


Now, as I said, we could modify gtod, so it takes into account the
remainder value, as well as a modified cyc2ns that doesn't truncate the
sub-ns portion until after we've added everything together. But that
requires touching a lot more code (all the vsyscall gtods).

In that case, post accumulation would look like:
	xtime = 999999, rem=0.6, delta = 500
	gtod:	999999.6 + cyc2shiftedns(500)
		999999.6 + 499999.8
		1499999.4
		1499999 (finally truncing the value before returning)


Alternatively, we could modify the adjustment code to expect larger
errors each iteration due to the rounding up.

> > I suspect we may need to still round up and store the error, but tweak
> > the adjustment code to handle the larger error per-iteration then it was
> > originally designed for (note: the current code is still functioning
> > properly, its just not often hitting the expected trivial case).
> 
> I'm afraid that may also do damage. This code needs real documentation
> explaining in detail what the frick it's doing. Having someone that
> shows up once ever 10 years that understands it is not something I feel
> confident about.

Oh yea. I agree the adjustment code is very opaque. And there is risk in
modifying the code that has been "functioning" but just not in the ideal
environment. This stuff is terribly subtle. And there is a real
possibility that in fixing the issue you've found, we may cause bugs
that effect users in a much more negative way then the incorrect
likely() overhead.


> > The only alternative would be to integrate the sub-ns remainder into the
> > gettime caclculation (including reworking all the vsyscall
> > implementations to utilize it as well).
> > 
> 
> First lets talk about all the issues, and perhaps even start documenting
> what it currently does. The comments in the code are not enough for a
> reviewer to understand the logic. I've spent today reading some RFC's to
> understand more about NTP but, it still does not explain the magic
> constants that are used in the code.

Also, NTP RFCs probably won't help you much with the kernel's
timekeeping.c code and adjustments. Most of the NTP specific code that
maps to the RFC is actually in ntp.c. The timekeeping code consumes the
steering done there via the tick_length value and the error accounting. 

But as to your point about better documentation, yes I think that's a
great idea. I do worry that Roman (who has been out of contact for
awhile) is the only person who really gets the adjustment code. I've
always let it be somewhat of a black box, understanding what it does in
concept, but some of the details still escape my grasp. It has
functioned well over the last few years, and in my long discussions with
him he tends to be correct about his approach, but it takes quite a bit
of time and frustration (at least for slow minded folks like me) to
understand why its right.

So more eyes connected to large brains could definitely help here. :)

thanks
-john

