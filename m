Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0HGPHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:07:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39728 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0HGPH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:07:29 -0400
Date: Sat, 7 Aug 2010 08:07:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100807150724.GC19600@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100805230304.GQ2447@linux.vnet.ibm.com>
 <20100807001431.GA3252@opensource.wolfsonmicro.com>
 <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
 <201008071101.25384.rjw@sisk.pl>
 <alpine.DEB.2.00.1008070247590.30564@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008070247590.30564@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 03:00:48AM -0700, david@lang.hm wrote:
> On Sat, 7 Aug 2010, Rafael J. Wysocki wrote:
> 
> >On Saturday, August 07, 2010, david@lang.hm wrote:
> >>On Sat, 7 Aug 2010, Mark Brown wrote:
> >>
> >>>On Fri, Aug 06, 2010 at 04:35:59PM -0700, david@lang.hm wrote:
> >>>>On Fri, 6 Aug 2010, Paul E. McKenney wrote:
> >...
> >>What we want to have happen in an ideal world is
> >>
> >>when the storage isn't needed (between reads) the storage should shutdown
> >>to as low a power state as possible.
> >>
> >>when the CPU isn't needed (between decoding bursts) the CPU and as much of
> >>the system as possible (potentially including some banks of RAM) should
> >>shutdown to as low a power state as possible.
> >
> >Unfortunately, the criteria for "not being needed" are not really
> >straightforward and one of the wakelocks' roles is to work around this issue.
> 
> if you can ignore the activity caused by the other "unimportant"
> processes in the system, why is this much different then just the
> one process running, in which case standard power management sleeps
> work pretty well.

But isn't the whole point of wakelocks to permit developers to easily
and efficiently identify which processes are "unimportant" at a given
point in time, thereby allowing them to be ignored?

I understand your position -- you believe that PM-driving applications
should be written to remain idle any time that they aren't doing something
"important".  This is a reasonable position to take, but it is also
reasonable to justify your position.  Exactly -why- is this better?
Here is my evaluation:

o	You might not need suspend blockers.  This is not totally clear,
	and won't be until you actually build a system based
	on your design.

o	You will be requiring that developers of PM-driving applications
	deal with more code that must be very carefully coded and
	validated.  This requirement forces the expenditure of lots
	of people time to save a very small amount of very inexpensive
	memory (that occupied by the suspend-blocker code).

Keep in mind that there was a similar decision in the -rt kernel.
One choice was similar to your proposal: all code paths must call
schedule() sufficiently frequently.  The other choice was to allow
almost all code paths to be preempted, which resembles suspend blockers
(preempt_disable() being analogous to acquiring a suspend blocker,
and preempt_enable() being analogous to releasing a suspend blocker).

Then as now, there was much debate.  The choice then was preemption.
One big reason was that the choice of preemption reduced the amount of
real-time-aware code from the entire kernel to only that part of the
kernel that disabled preemption, which turned out to greatly simplify
the job of meeting aggressive scheduling-latency goals.  This experience
does add some serious precedent against your position.  So, what do you
believe is different in the energy-efficiency case?

> >>today there are two ways of this happening, via the idle approach (on
> >>everything except Android), or via suspend (on Android)
> >>
> >>Given that many platforms cannot go to into suspend while still playing
> >>audio, the idle approach is not going to be able to be eliminated (and in
> >>fact will be the most common approach to be used/deugged in terms of the
> >>types of platforms), it seems to me that there may be a significant amount
> >>of value in seeing if there is a way to change Android to use this
> >>approach as well instead of having two different systems competing to do
> >>the same job.
> >
> >There is a fundamental obstacle to that, though.  Namely, the Android
> >developers say that the idle-based approach doesn't lead to sufficient energy
> >savings due to periodic timers and "polling applications".
> 
> polling applications can be solved by deciding that they aren't
> going to be allowed to affect the power management decision (don't
> consider their CPU useage when deciding to go to sleep, don't
> consider their timers when deciding when to wake back up)

Agreed, and the focus is on how one decides which applications need
to be considered.  After all, the activity of a highly optimized
audio-playback application looks exactly like that of a stupid polling
application -- they both periodically consume some CPU.  But this is
something that you and the Android guys are actually agreeing about.
You are only arguing about exactly what mechanism should be used to
make this determination.  The Android guys want suspend blockers, and
you want to extend cgroups.

So I believe that the next step for you is to implement your approach
so that it can be compared in terms of energy efficiency, code size,
intrusiveness, performance, and compatibility with existing code.

> >Technically that
> >boils down to the interrupt sources that remain active in the idle-based case
> >and that are shut down during suspend.  If you found a way to deactivate all of
> >them from the idle context in a non-racy fashion, that would probably satisfy
> >the Android's needs too.
> 
> well, we already have similar capibility for other peripherals (I
> keep pointing to drive spin down as an example), the key to avoiding
> the races seems to be in the drivers supporting this.

The difference is that the CPU stays active in the drive spin down
case -- if the drive turns out to be needed, the CPU can spin it up.
The added complication in the suspend case is that the CPU goes away,
so that you must more carefully plan for all of the power-up cases.

> the fact that Android is making it possible for suspend to
> selectivly avoid disabling them makes me think that a lot of the
> work needed to make this happen has probably been done. look at what
> would happen in a suspend if it decided to leave everything else on
> and just disable the one thing, that should e the same thing that
> happens if you are just disabling that one thing for idle sleep.

We already covered the differences between suspend and idle, now
didn't we?  ;-)

							Thanx, Paul
