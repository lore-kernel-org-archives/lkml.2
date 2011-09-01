Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1IARNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:13:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:45554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1IARNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:13:47 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Thu, 01 Sep 2011 19:13:00 +0200
In-Reply-To: <20110901164040.GC2286@linux.vnet.ibm.com>
References: <20110829233521.GK9748@somewhere.redhat.com>
	 <1314703315.2799.5.camel@twins>
	 <20110830143207.GP9748@somewhere.redhat.com>
	 <1314717993.5812.11.camel@twins>
	 <20110830153343.GW9748@somewhere.redhat.com>
	 <1314737918.19586.8.camel@twins>
	 <20110830222432.GD15953@somewhere.redhat.com>
	 <1314782245.23993.9.camel@twins> <20110831133754.GA20598@somewhere>
	 <1314801660.3578.41.camel@twins> <20110901164040.GC2286@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314897180.1485.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 09:40 -0700, Paul E. McKenney wrote:
> On Wed, Aug 31, 2011 at 04:41:00PM +0200, Peter Zijlstra wrote:
> > On Wed, 2011-08-31 at 15:37 +0200, Frederic Weisbecker wrote:
> > > > Why? rcu-sched can use a context-switch counter, rcu-preempt doesn't
> > > > even need that. Remote cpus can notice those just fine.
> > > 
> > > If that's fine to only rely on context switches, which don't happen in
> > > a bounded time in theory, then ok.
> > 
> > But (!PREEMPT) rcu already depends on that, and suffers this lack of
> > time-bounds. What it does to expedite matters is force context switches,
> > but nowhere is it written the GP is bounded by anything sane.
> 
> Ah, but it really is written, among other things, by the OOM killer.  ;-)

Well there is that of course :-) But I think the below argument relies
on what we already have without requiring more.

> > > > But you then also start the tick again..
> > > 
> > > When we enter kernel? (minus interrupts)
> > > No we only call rcu_exit_nohz(). 
> > 
> > So thinking more about all this:
> > 
> > rcu_exit_nohz() will make remote cpus wait for us, this is exactly what
> > is needed because we might have looked at pointers. Lacking a tick we
> > don't progress our own state but that is fine, !PREEMPT RCU wouldn't
> > have been able to progress our state anyway since we haven't scheduled
> > (there's nothing to schedule to except idle, see below).
> 
> Lacking a tick, the CPU also fails to respond to state updates from
> other CPUs.

I'm sure I'll have to go re-read your documents, but does that matter?
If we would have had a tick we still couldn't have progressed since we
wouldn't have scheduled etc.. so we would hold up GP completion any way.

> > Then when we leave the kernel (or go idle) we re-enter rcu_nohz state,
> > and the other cpus will ignore our contribution (since we have entered a
> > QS and can't be holding any pointers) the other CPUs can continue and
> > complete the GP and run the callbacks.
> 
> This is true.

So suppose all other CPUs completed the GP and our CPU is the one
holding things up, now I don't see rcu_enter_nohz() doing anything much
at all, who is responsible for GP completion?

> > I haven't fully considered PREEMPT RCU quite yet, but I'm thinking we
> > can get away with something similar.
> 
> All the ways I know of to make PREEMPT_RCU live without a scheduling
> clock tick while not in some form of dyntick-idle mode require either
> IPIs or read-side memory barriers.  The special case where all CPUs
> are in dyntick-idle mode and something needs to happen also needs to
> be handled correctly.
> 
> Or are you saying that PREEMPT_RCU does not need a CPU to take
> scheduling-clock interrupts while that CPU is in dyntick-idle mode?
> That is true enough.

I'm not saying anything much about PREEMPT_RCU, I voiced an
ill-considered suspicion :-)

So in the nr_running=[0,1] case we're in rcu_nohz state when idle or
when in userspace. The only interesting part is being in kernel space
where we cannot be in rcu_nohz state because we might actually use
pointers and thus have to stop callbacks from destroying state etc..

The only PREEMPT_RCU implementation I can recall is the counting one,
and that one does indeed want a tick, because even in kernel space it
could move things forward if the 'old' index counter reaches 0.

Now we could possibly add magic to rcu_read_unlock_special() to restart
the tick in that case.

Now clearly all that might be non-applicable to the current one, will
have to wrap my head around the current PREEMPT_RCU implementation some
more.

> > So per the above we don't need the tick at all (for the case of
> > nr_running=[0,1]), RCU will sort itself out.
> > 
> > Now I forgot where all you send IPIs from, and I'll go look at these
> > patches once more.
> > 
> > As for call_rcu() for that we can indeed wake the tick (on leaving
> > kernel space or entering idle, no need to IPI since we can't process
> > anything before that anyway) or we could hand off our call list to a
> > 'willing' victim.
> > 
> > But yeah, input from Paul would be nice...
> 
> In the call_rcu() case, I do have some code in preparation that allows
> CPUs to have non-empty callback queues and still be tickless.  There
> are some tricky corner cases, but it does look possible.  (Famous last
> words...)

Hand your callback to someone else is one solution, but I'm not overly
worried about re-starting the tick if we do call_rcu().

> The reason for doing this is that people are enabling
> CONFIG_RCU_FAST_NO_HZ on systems that have no business enabling it.
> Bad choice of names on my part.

hehe :-)
