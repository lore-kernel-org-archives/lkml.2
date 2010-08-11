Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0HKWNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:13:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55635 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab0HKWNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:13:14 -0400
Date: Wed, 11 Aug 2010 15:12:58 -0700
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
Message-ID: <20100811221258.GI2516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100808155719.GB3635@thunk.org>
 <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
 <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com>
 <20100809201822.441905f7@lxorguk.ukuu.org.uk>
 <20100810044541.GA2817@linux.vnet.ibm.com>
 <20100810093849.138e2318@lxorguk.ukuu.org.uk>
 <20100811004223.GH2379@linux.vnet.ibm.com>
 <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 11:00:42PM +0300, Felipe Contreras wrote:
> On Wed, Aug 11, 2010 at 3:42 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
> >> You may also wish to review the earlier parts of the discussion where it
> >> was explicitly stated by several developers that they were using
> >> "suspend" type modes as power states already and not using suspend
> >> blockers. So it's being done, today on ARM and your statement is directly
> >> contradicting the code. Modern ARM processors and x86 MID devices can
> >> suspend and resume extremely fast (fast enough that the fact Linux x86
> >> rewriting all the SMP alternatives on suspend/resume is a measurable
> >> problem). If this same property doesn't end up on big PC boxes in time
> >> then I'd be very surprised. At that point the openoffice with suspend
> >> blockers or oracle with suspend blockers question becomes rather relevant.
> >
> > Here is the list of properties distinguishing idle from suspend:
> >
> > 1.      Idle states are entered by a given CPU only there are no runnable
> >        tasks for that CPU.  In contrast, opportunistic suspend can
> >        halt the entire system even when there are tasks that are ready,
> >        willing, and able to run.  (But please note that this might not
> >        apply to real-time tasks.)
> 
> But if there are no runnable tasks (which is the target), they behave the same.

And if there are runnable tasks, then then don't behave the same.
Apparently different people in this debate have different targets.

> > 2.      There can be a set of input events that do not bring the system
> >        out of suspend, but which would bring the system out of idle.
> >        Exactly which events are in this set depends both on hardware
> >        capabilities and on the platform/application policy.  For example,
> >        on one of the Android-based smartphones, touchscreen input is
> >        ignored when the system is suspended, but is handled when idle.
> 
> And in N900 touching the screen doesn't bring the device out of idle,
> I guess because it's off.

As long as touching the N900 screen doesn't bring the device out of
suspend, its behavior is not a counterexample to #2 above.

> What devices do what on which circumstances on what platform is
> completely irrelevant.

Do you -really- want me to start listing counterexamples to that
brave statement?  ;-)

> > 3.      The system comes out of idle when a timer expires.  In contrast,
> >        timers might or might not bring the system out of suspend,
> >        depending on both hardware capabilities and platform/application
> >        policy.
> 
> Isn't this solved by range timers?

Ahem.  This is a list of differences between idle and suspend, not
a list of problems to be solved.  But to answer your question, if a
timer does not bring a given device out of suspend, then a range timer
is not likely to, either.  Don't get me wrong, I do believe that range
timers have an important part to play in the energy-efficiency arena,
but I have not been convinced that they are any kind of silver bullet.

> > 4.      Suspend generally forces devices to go into their low-power
> >        states immediately.  In contrast, idle generally leaves unused
> >        devices at full power, relying on timers to shut down these
> >        devices.  Idle thus has shorter average wakeup latencies, but
> >        worse energy efficiency.
> 
> Only if you make these assumptions
>  1) All the applications use suspend-blockers only when they absolutely must
>  2) The user has given the right applications the right access

You believe that these assumptions are unreasonable?  Compared to the
assumption that all applications are carefully written to conserve power?
If so, on what grounds?

It seems to me that the same social-engineering approaches work in
both cases.

> If not, you'll see much worst energy efficiency. So in theory maybe,
> but in practice you can't say that.

Really?  What makes you say that?

							Thanx, Paul
