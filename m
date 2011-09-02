Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab1IBBlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:41:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40829 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab1IBBlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:41:06 -0400
Date: Thu, 1 Sep 2011 18:41:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
Message-ID: <20110902014101.GA2405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110830143207.GP9748@somewhere.redhat.com>
 <1314717993.5812.11.camel@twins>
 <20110830153343.GW9748@somewhere.redhat.com>
 <1314737918.19586.8.camel@twins>
 <20110830222432.GD15953@somewhere.redhat.com>
 <1314782245.23993.9.camel@twins>
 <20110831133754.GA20598@somewhere>
 <1314801660.3578.41.camel@twins>
 <20110901164040.GC2286@linux.vnet.ibm.com>
 <1314897180.1485.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314897180.1485.12.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 07:13:00PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 09:40 -0700, Paul E. McKenney wrote:
> > On Wed, Aug 31, 2011 at 04:41:00PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2011-08-31 at 15:37 +0200, Frederic Weisbecker wrote:
> > > > > Why? rcu-sched can use a context-switch counter, rcu-preempt doesn't
> > > > > even need that. Remote cpus can notice those just fine.
> > > > 
> > > > If that's fine to only rely on context switches, which don't happen in
> > > > a bounded time in theory, then ok.
> > > 
> > > But (!PREEMPT) rcu already depends on that, and suffers this lack of
> > > time-bounds. What it does to expedite matters is force context switches,
> > > but nowhere is it written the GP is bounded by anything sane.
> > 
> > Ah, but it really is written, among other things, by the OOM killer.  ;-)
> 
> Well there is that of course :-) But I think the below argument relies
> on what we already have without requiring more.

Almost.  ;-)

> > > > > But you then also start the tick again..
> > > > 
> > > > When we enter kernel? (minus interrupts)
> > > > No we only call rcu_exit_nohz(). 
> > > 
> > > So thinking more about all this:
> > > 
> > > rcu_exit_nohz() will make remote cpus wait for us, this is exactly what
> > > is needed because we might have looked at pointers. Lacking a tick we
> > > don't progress our own state but that is fine, !PREEMPT RCU wouldn't
> > > have been able to progress our state anyway since we haven't scheduled
> > > (there's nothing to schedule to except idle, see below).
> > 
> > Lacking a tick, the CPU also fails to respond to state updates from
> > other CPUs.
> 
> I'm sure I'll have to go re-read your documents, but does that matter?
> If we would have had a tick we still couldn't have progressed since we
> wouldn't have scheduled etc.. so we would hold up GP completion any way.

There are two phases to quiescent-state detection: (1) actually
detecting the quiescent state and (2) reporting detection to the
RCU core.  If you turn off the tick at an inopportune time, you
can have CPUs that have detected the tick, but not yet reported it.

You asked the follow-up question below, so please see below.

> > > Then when we leave the kernel (or go idle) we re-enter rcu_nohz state,
> > > and the other cpus will ignore our contribution (since we have entered a
> > > QS and can't be holding any pointers) the other CPUs can continue and
> > > complete the GP and run the callbacks.
> > 
> > This is true.
> 
> So suppose all other CPUs completed the GP and our CPU is the one
> holding things up, now I don't see rcu_enter_nohz() doing anything much
> at all, who is responsible for GP completion?

Any CPU that has RCU callbacks queued that are waiting for the current or
some susequent grace period to complete are responsible for pushing the
current grace period forward, hence the checks in the non-RCU_FAST_NO_HZ
variants of rcu_needs_cpu().  This is why CPUs with callbacks that are
not yet done cannot currently disable the tick -- because we need at
least one CPU to detect the fact that dyntick-idle CPUs are in fact in
extended quiescent states.

Again, I believe that I can do better, hence the in-progress rewrite of
RCU_FAST_NO_HZ.  Either that or get most people to stop using it, and
given its name, getting people to stop using it is likely an exercise
in futility.  "But it is FAST, and that is good, and it involve NO_HZ,
which saves energy, which is also good.  Therefore, I will enable it
-everywhere-!!!"

Sigh.  It will be much easier to rewrite it, ugly corner cases
nonwithstanding.  :-(

> > > I haven't fully considered PREEMPT RCU quite yet, but I'm thinking we
> > > can get away with something similar.
> > 
> > All the ways I know of to make PREEMPT_RCU live without a scheduling
> > clock tick while not in some form of dyntick-idle mode require either
> > IPIs or read-side memory barriers.  The special case where all CPUs
> > are in dyntick-idle mode and something needs to happen also needs to
> > be handled correctly.
> > 
> > Or are you saying that PREEMPT_RCU does not need a CPU to take
> > scheduling-clock interrupts while that CPU is in dyntick-idle mode?
> > That is true enough.
> 
> I'm not saying anything much about PREEMPT_RCU, I voiced an
> ill-considered suspicion :-)

;-)

> So in the nr_running=[0,1] case we're in rcu_nohz state when idle or
> when in userspace. The only interesting part is being in kernel space
> where we cannot be in rcu_nohz state because we might actually use
> pointers and thus have to stop callbacks from destroying state etc..

Yep!

> The only PREEMPT_RCU implementation I can recall is the counting one,
> and that one does indeed want a tick, because even in kernel space it
> could move things forward if the 'old' index counter reaches 0.
> 
> Now we could possibly add magic to rcu_read_unlock_special() to restart
> the tick in that case.

Not from NMI handlers we can't.  Unless I am really confused about the
code that restarts the tick.  Which is not impossible, but ...

I don't currently have an opinion about the advisability of restarting
the tick from hardIRQ handlers, but I do feel the need to point out the
the possibility.

> Now clearly all that might be non-applicable to the current one, will
> have to wrap my head around the current PREEMPT_RCU implementation some
> more.

Indeed, the documentation is going much more slowly than I would like...

> > > So per the above we don't need the tick at all (for the case of
> > > nr_running=[0,1]), RCU will sort itself out.
> > > 
> > > Now I forgot where all you send IPIs from, and I'll go look at these
> > > patches once more.
> > > 
> > > As for call_rcu() for that we can indeed wake the tick (on leaving
> > > kernel space or entering idle, no need to IPI since we can't process
> > > anything before that anyway) or we could hand off our call list to a
> > > 'willing' victim.
> > > 
> > > But yeah, input from Paul would be nice...
> > 
> > In the call_rcu() case, I do have some code in preparation that allows
> > CPUs to have non-empty callback queues and still be tickless.  There
> > are some tricky corner cases, but it does look possible.  (Famous last
> > words...)
> 
> Hand your callback to someone else is one solution, but I'm not overly
> worried about re-starting the tick if we do call_rcu().

As long as the handoff doesn't turn into a battery-killing game of
RCU-callback hot potato.  And I am seriously concerned about this
possibility.

I will be updating the Dyntick-Idle doc to cover the new RCU_FAST_NO_HZ
algorithm if and when I get it into human-readable form.

> > The reason for doing this is that people are enabling
> > CONFIG_RCU_FAST_NO_HZ on systems that have no business enabling it.
> > Bad choice of names on my part.
> 
> hehe :-)

Sigh!  Scanning dyntick-idle state on a system with 256 CPUs.  What could
possibly go wrong?  :-/

							Thanx, Paul
