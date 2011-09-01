Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1IAQks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:40:48 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45201 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab1IAQkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:40:47 -0400
Date: Thu, 1 Sep 2011 09:40:40 -0700
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
Message-ID: <20110901164040.GC2286@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110829233521.GK9748@somewhere.redhat.com>
 <1314703315.2799.5.camel@twins>
 <20110830143207.GP9748@somewhere.redhat.com>
 <1314717993.5812.11.camel@twins>
 <20110830153343.GW9748@somewhere.redhat.com>
 <1314737918.19586.8.camel@twins>
 <20110830222432.GD15953@somewhere.redhat.com>
 <1314782245.23993.9.camel@twins>
 <20110831133754.GA20598@somewhere>
 <1314801660.3578.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314801660.3578.41.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 04:41:00PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-31 at 15:37 +0200, Frederic Weisbecker wrote:
> > > Why? rcu-sched can use a context-switch counter, rcu-preempt doesn't
> > > even need that. Remote cpus can notice those just fine.
> > 
> > If that's fine to only rely on context switches, which don't happen in
> > a bounded time in theory, then ok.
> 
> But (!PREEMPT) rcu already depends on that, and suffers this lack of
> time-bounds. What it does to expedite matters is force context switches,
> but nowhere is it written the GP is bounded by anything sane.

Ah, but it really is written, among other things, by the OOM killer.  ;-)

> > > But you then also start the tick again..
> > 
> > When we enter kernel? (minus interrupts)
> > No we only call rcu_exit_nohz(). 
> 
> So thinking more about all this:
> 
> rcu_exit_nohz() will make remote cpus wait for us, this is exactly what
> is needed because we might have looked at pointers. Lacking a tick we
> don't progress our own state but that is fine, !PREEMPT RCU wouldn't
> have been able to progress our state anyway since we haven't scheduled
> (there's nothing to schedule to except idle, see below).

Lacking a tick, the CPU also fails to respond to state updates from
other CPUs.

> Then when we leave the kernel (or go idle) we re-enter rcu_nohz state,
> and the other cpus will ignore our contribution (since we have entered a
> QS and can't be holding any pointers) the other CPUs can continue and
> complete the GP and run the callbacks.

This is true.

> I haven't fully considered PREEMPT RCU quite yet, but I'm thinking we
> can get away with something similar.

All the ways I know of to make PREEMPT_RCU live without a scheduling
clock tick while not in some form of dyntick-idle mode require either
IPIs or read-side memory barriers.  The special case where all CPUs
are in dyntick-idle mode and something needs to happen also needs to
be handled correctly.

Or are you saying that PREEMPT_RCU does not need a CPU to take
scheduling-clock interrupts while that CPU is in dyntick-idle mode?
That is true enough.

> So per the above we don't need the tick at all (for the case of
> nr_running=[0,1]), RCU will sort itself out.
> 
> Now I forgot where all you send IPIs from, and I'll go look at these
> patches once more.
> 
> As for call_rcu() for that we can indeed wake the tick (on leaving
> kernel space or entering idle, no need to IPI since we can't process
> anything before that anyway) or we could hand off our call list to a
> 'willing' victim.
> 
> But yeah, input from Paul would be nice...

In the call_rcu() case, I do have some code in preparation that allows
CPUs to have non-empty callback queues and still be tickless.  There
are some tricky corner cases, but it does look possible.  (Famous last
words...)

The reason for doing this is that people are enabling
CONFIG_RCU_FAST_NO_HZ on systems that have no business enabling it.
Bad choice of names on my part.

							Thanx, Paul
