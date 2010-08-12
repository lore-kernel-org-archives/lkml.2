Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab0HLQTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:19:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58165 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0HLQTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:19:51 -0400
Date: Thu, 12 Aug 2010 09:19:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812161935.GC2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com>
 <20100809201822.441905f7@lxorguk.ukuu.org.uk>
 <20100810044541.GA2817@linux.vnet.ibm.com>
 <20100810093849.138e2318@lxorguk.ukuu.org.uk>
 <20100811004223.GH2379@linux.vnet.ibm.com>
 <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
 <20100811221258.GI2516@linux.vnet.ibm.com>
 <AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 03:17:29AM +0300, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 1:12 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Aug 11, 2010 at 11:00:42PM +0300, Felipe Contreras wrote:
> >> On Wed, Aug 11, 2010 at 3:42 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
> >> >> You may also wish to review the earlier parts of the discussion where it
> >> >> was explicitly stated by several developers that they were using
> >> >> "suspend" type modes as power states already and not using suspend
> >> >> blockers. So it's being done, today on ARM and your statement is directly
> >> >> contradicting the code. Modern ARM processors and x86 MID devices can
> >> >> suspend and resume extremely fast (fast enough that the fact Linux x86
> >> >> rewriting all the SMP alternatives on suspend/resume is a measurable
> >> >> problem). If this same property doesn't end up on big PC boxes in time
> >> >> then I'd be very surprised. At that point the openoffice with suspend
> >> >> blockers or oracle with suspend blockers question becomes rather relevant.
> >> >
> >> > Here is the list of properties distinguishing idle from suspend:
> >> >
> >> > 1.      Idle states are entered by a given CPU only there are no runnable
> >> >        tasks for that CPU.  In contrast, opportunistic suspend can
> >> >        halt the entire system even when there are tasks that are ready,
> >> >        willing, and able to run.  (But please note that this might not
> >> >        apply to real-time tasks.)
> >>
> >> But if there are no runnable tasks (which is the target), they behave the same.
> >
> > And if there are runnable tasks, then then don't behave the same.
> 
> Unless they have blocked suspend.

You are quite correct.  I should have said something like "But if there
are runnable tasks, none of which is holding a suspend blocker, then
they don't behave the same."

> Anyway, Alan was picturing a hypothetical point in time when x86 can
> suspend/resume as fast as ARM, and thus the question of whether or not
> to enable suspend-blockers in a system that runs openoffice becomes
> relevant. If applications have been fixed by that time to not wake the
> system unnecessarily, as many of them have already been tanks to tools
> like powertop, then suspend-blockers would not make that much of a
> difference, therefore the effort required to implement
> suspend-blockers properly on all applications in the system, including
> openoffice might not be worth the gain.

One more time, this time with feeling.  ;-)

	Only PM-driving applications need concern themselves with suspend
	blockers, and experience thus far indicates that PM-driving
	applications are a very small fraction of the total.

> > Apparently different people in this debate have different targets.
> 
> I remember clearly Android people explaining that dynamic PM is
> orthogonal to suspend-blockers; if a suspend is blocked, you still
> want dynamic PM to reach the lower power state. Therefore the target
> of not having unneeded runnable tasks is shared by Android folks.

And I have not seen anyone argue that suspend blockers are a replacement
for dynamic power management.  Many people instead seem to be advocating
using them both -- dynamic power management for when at least one
PM-driving application or kernel driver is keeping the system awake, and
suspend blockers for when only power-oblivious applications are running.

In contrast, you are advocating dynamic power management to the exclusion
of other mechanisms.

> >> > 2.      There can be a set of input events that do not bring the system
> >> >        out of suspend, but which would bring the system out of idle.
> >> >        Exactly which events are in this set depends both on hardware
> >> >        capabilities and on the platform/application policy.  For example,
> >> >        on one of the Android-based smartphones, touchscreen input is
> >> >        ignored when the system is suspended, but is handled when idle.
> >>
> >> And in N900 touching the screen doesn't bring the device out of idle,
> >> I guess because it's off.
> >
> > As long as touching the N900 screen doesn't bring the device out of
> > suspend, its behavior is not a counterexample to #2 above.
> 
> You said "there can be a set of input events that do not bring the
> system out of suspend, but which would bring the system out of idle".
> There's no suspend (in the Android sense) in N900, only idle, and the
> events that bring N900 out of idle can be mapped to the set of events
> that bring Android out of suspend.

We do seem to be in violent agreement.

> IOW. Alan wasn't talking about idle vs suspend on the same device, he
> was talking about opportunistic suspend vs dynamic PM.

The most convincing comparisons will be of suspend vs. idle on the
same device.  If multiple devices are involved, then the most convincing
experiments would compare suspend vs. idle separately on each device.

So, are you sure that you are correctly interpreting Alan's words?

> >> > 3.      The system comes out of idle when a timer expires.  In contrast,
> >> >        timers might or might not bring the system out of suspend,
> >> >        depending on both hardware capabilities and platform/application
> >> >        policy.
> >>
> >> Isn't this solved by range timers?
> >
> > Ahem.  This is a list of differences between idle and suspend, not
> > a list of problems to be solved.  But to answer your question, if a
> > timer does not bring a given device out of suspend, then a range timer
> > is not likely to, either.  Don't get me wrong, I do believe that range
> > timers have an important part to play in the energy-efficiency arena,
> > but I have not been convinced that they are any kind of silver bullet.
> 
> Certainly, but the context is the set of differences that would aid in
> the decision of whether or not to go for suspend-blockers in a general
> purpose system where openoffice would run.

Again, I am in no way arguing for suspend blockers to the exclusion of
other approaches.  Heck, I am mostly just trying to get a clear statement
of the problem.  In contrast, you do seem to be advocating for dynamic
power management to the exclusion of other approaches.

> >> > 4.      Suspend generally forces devices to go into their low-power
> >> >        states immediately.  In contrast, idle generally leaves unused
> >> >        devices at full power, relying on timers to shut down these
> >> >        devices.  Idle thus has shorter average wakeup latencies, but
> >> >        worse energy efficiency.
> >>
> >> Only if you make these assumptions
> >>  1) All the applications use suspend-blockers only when they absolutely must
> >>  2) The user has given the right applications the right access
> >
> > You believe that these assumptions are unreasonable?  Compared to the
> > assumption that all applications are carefully written to conserve power?
> > If so, on what grounds?
> 
> No, I think both (for opportunistic suspend and dynamic PM) are
> completely reasonable. But think again; if you have the assumptions
> met on both, then both work fine, if you don't meet them, then both
> don't work correctly.

That is true of any artifact, software or otherwise: if you don't meet the
assumptions inherent in its design and construction, the artifact might
fail.  Of course, you argument also applies to dynamic power management:
and in fact it takes just one power-oblivious application to drain your
battery -- especially if that application goes into an infinite loop.
And if that application goes into an infinite loop only under some
unusual set of conditions, it might have passed your test suite with
flying colors, so that you might even have given it a power-management
gold star, right?

And yes, you can get the same effect with an infinite loop in a
PM-driving application that happens to be holding suspend blockers
at the time.  However, in the suspend-blocker case, one need only
inspect that code that holds suspend blockers.  In the dynamic
power management case, one must inspect -all- the code.  There is
a very real difference between those two tasks.

So are you sure that dynamic power management will turn out to be
the right tool for every job out there?  If so, on what grounds?

> My point is that suspend-blockers don't magically reduce power usage,
> just like dynamic PM, it depends on what user-space actually does. You
> made it look as it *always* reached better energy efficiency.

I do?  Really???  Exactly what did I say to give you that impression?

I am not saying that suspend blockers are the right tool for every
power management job, instead, I am asking whether there are some power
management jobs for which it is the best tool.

> > It seems to me that the same social-engineering approaches work in
> > both cases.
> 
> Yes, but if dynamic PM works as advertised, you don't need
> opportunistic suspend.

For dynamic power management to totally eliminate the need for something
like suspend blockers, you are having to make some brave assumptions.
Yes, dynamic power management is quite useful, but there is a big
difference between something being useful and something doing everything
for everyone.  You have not yet convinced me that dynamic power management
will make it to the "doing everything for everyone" stage.

> >> If not, you'll see much worst energy efficiency. So in theory maybe,
> >> but in practice you can't say that.
> >
> > Really?  What makes you say that?
> 
> For starters an application might be holding the wakelock more than it
> should, also, an application might miss a timer due to not having PM
> permissions to hold the lock, and thus might need an expensive
> initialization when it runs again.

Just as an application might run continuously without blocking, which
would defeat the dynamic power management scheme that have thus far been
put forward.  And just as an application might miss a timer due to
dynamic power management having decided that it didn't need that timer
to fire at the desired time.

							Thanx, Paul
