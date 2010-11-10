Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0KJSIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:08:40 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44940 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab0KJSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:08:38 -0500
Date: Wed, 10 Nov 2010 10:08:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Udo A. Steinberg" <udo@hypervisor.org>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101110180810.GI4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <20101106192812.GI15561@linux.vnet.ibm.com>
 <20101108031136.0766149f@laptop.hypervisor.org>
 <20101108031936.63a13ff2@laptop.hypervisor.org>
 <20101108025400.GA2580@linux.vnet.ibm.com>
 <20101108153214.GC5466@nowhere>
 <20101108193832.GB4032@linux.vnet.ibm.com>
 <20101108204007.GB6777@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108204007.GB6777@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:40:11PM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 08, 2010 at 11:38:32AM -0800, Paul E. McKenney wrote:
> > On Mon, Nov 08, 2010 at 04:32:17PM +0100, Frederic Weisbecker wrote:
> > > So, this looks very scary for performances to add rcu_read_lock() in
> > > preempt_disable() and local_irq_save(), that notwithstanding it won't
> > > handle the "raw" rcu sched implicit path.
> > 
> > Ah -- I would arrange for the rcu_read_lock() to be added only in the
> > dyntick-hpc case.  So no effect on normal builds, overhead is added only
> > in the dyntick-hpc case.
> 
> 
> 
> Yeah sure, but I wonder if the resulting rcu config will have a
> large performance impact because of that.
> 
> In fact, my worry is: if the last resort to have a sane non-timer based
> rcu is to bloat fast path functions like preempt_disable() or local_irq...
> (that notwithstanding we have a bloated rcu_read_unlock() on this rcu config
> because of its main nature), wouldn't it be better to eventually pick the
> syscall/exception tweaked fast path version?
> 
> Perhaps I'll need to measure the impact of both, but I suspect I'll get
> controversial results depending on the workload.

Do you have a workload that you can use to measure this?  If so, I would
be very interested in seeing the result of upping the value of
RCU_JIFFIES_TILL_FORCE_QS to 30, 300, and HZ.

> > > There is also my idea from the other discussion: change rcu_read_lock_sched()
> > > semantics and map it to rcu_read_lock() in this rcu config (would be a nop
> > > in other configs). So every users of rcu_dereference_sched() would now need
> > > to protect their critical section with this.
> > > Would it be too late to change this semantic?
> > 
> > I was expecting that we would fold RCU, RCU bh, and RCU sched into
> > the same set of primitives (as Jim Houston did), but again only in the
> > dyntick-hpc case.
> 
> Yeah, the resulting change must be NULL in others rcu configs.

Indeed!!!

> > However, rcu_read_lock_bh() would still disable BH,
> > and similarly, rcu_read_lock_sched() would still disable preemption.
> 
> Probably yeah, otherwise there will be a kind of sense split against
> the usual rcu_read_lock() and everybody will be confused.
> 
> Perhaps we need a different API for the underlying rcu_read_lock()
> call in the other flavours when preempt is already disabled or
> bh is already disabled:
> 
> 	rcu_enter_read_lock_sched();
> 	__rcu_read_lock_sched();
> 	rcu_start_read_lock_sched();
> 
> 	(same for bh)
> 
> Hmm...

I would really really like to avoid adding to the already-large RCU API.  ;-)

> > > What is scary with this is that it also changes rcu sched semantics, and users
> > > of call_rcu_sched() and synchronize_sched(), who rely on that to do more
> > > tricky things than just waiting for rcu_derefence_sched() pointer grace periods,
> > > like really wanting for preempt_disable and local_irq_save/disable, those
> > > users will be screwed... :-(  ...unless we also add relevant rcu_read_lock_sched()
> > > for them...
> > 
> > So rcu_read_lock() would be the underlying primitive.  The implementation
> > of rcu_read_lock_sched() would disable preemption and then invoke
> > rcu_read_lock().  The implementation of rcu_read_lock_bh() would
> > disable BH and then invoke rcu_read_lock().  This would allow
> > synchronize_rcu_sched() and synchronize_rcu_bh() to simply invoke
> > synchronize_rcu().
> > 
> > Seem reasonable?
> 
> Perfect. That could be further optimized with what I said above but
> other than that, that's what I was thinking about.

OK, sounds good!

							Thanx, Paul
