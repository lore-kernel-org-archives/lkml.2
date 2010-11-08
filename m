Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0KHTir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:38:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58717 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab0KHTiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:38:46 -0500
Date: Mon, 8 Nov 2010 11:38:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Udo A. Steinberg" <udo@hypervisor.org>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108193832.GB4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <20101106192812.GI15561@linux.vnet.ibm.com>
 <20101108031136.0766149f@laptop.hypervisor.org>
 <20101108031936.63a13ff2@laptop.hypervisor.org>
 <20101108025400.GA2580@linux.vnet.ibm.com>
 <20101108153214.GC5466@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108153214.GC5466@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 04:32:17PM +0100, Frederic Weisbecker wrote:
> On Sun, Nov 07, 2010 at 06:54:00PM -0800, Paul E. McKenney wrote:
> > On Mon, Nov 08, 2010 at 03:19:36AM +0100, Udo A. Steinberg wrote:
> > > On Mon, 8 Nov 2010 03:11:36 +0100 Udo A. Steinberg (UAS) wrote:
> > > 
> > > UAS> On Sat, 6 Nov 2010 12:28:12 -0700 Paul E. McKenney (PEM) wrote:
> > > UAS> 
> > > UAS> PEM> > + * rcu_quiescent() is called from rcu_read_unlock() when a
> > > UAS> PEM> > + * RCU batch was started while the rcu_read_lock/rcu_read_unlock
> > > UAS> PEM> > + * critical section was executing.
> > > UAS> PEM> > + */
> > > UAS> PEM> > +
> > > UAS> PEM> > +void rcu_quiescent(int cpu)
> > > UAS> PEM> > +{
> > > UAS> PEM> 
> > > UAS> PEM> What prevents two different CPUs from calling this concurrently?
> > > UAS> PEM> Ah, apparently nothing -- the idea being that
> > > UAS> PEM> rcu_grace_period_complete() sorts it out.  Though if the second
> > > UAS> PEM> CPU was delayed, it seems like it might incorrectly end a
> > > UAS> PEM> subsequent grace period as follows:
> > > UAS> PEM> 
> > > UAS> PEM> o	CPU 0 clears the second-to-last bit.
> > > UAS> PEM> 
> > > UAS> PEM> o	CPU 1 clears the last bit.
> > > UAS> PEM> 
> > > UAS> PEM> o	CPU 1 sees that the mask is empty, so invokes
> > > UAS> PEM> 	rcu_grace_period_complete(), but is delayed in the function
> > > UAS> PEM> 	preamble.
> > > UAS> PEM> 
> > > UAS> PEM> o	CPU 0 sees that the mask is empty, so invokes
> > > UAS> PEM> 	rcu_grace_period_complete(), ending the grace period.
> > > UAS> PEM> 	Because the RCU_NEXT_PENDING is set, it also starts
> > > UAS> PEM> 	a new grace period.
> > > UAS> PEM> 
> > > UAS> PEM> o	CPU 1 continues in rcu_grace_period_complete(),
> > > UAS> PEM> incorrectly ending the new grace period.
> > > UAS> PEM> 
> > > UAS> PEM> Or am I missing something here?
> > > UAS> 
> > > UAS> The scenario you describe seems possible. However, it should be easily
> > > UAS> fixed by passing the perceived batch number as another parameter to
> > > UAS> rcu_set_state() and making it part of the cmpxchg. So if the caller
> > > UAS> tries to set state bits on a stale batch number (e.g., batch !=
> > > UAS> rcu_batch), it can be detected.
> > > UAS> 
> > > UAS> There is a similar, although harmless, issue in call_rcu(): Two CPUs can
> > > UAS> concurrently add callbacks to their respective nxt list and compute the
> > > UAS> same value for nxtbatch. One CPU succeeds in setting the PENDING bit
> > > UAS> while observing COMPLETE to be clear, so it starts a new batch.
> > > 
> > > Correction: while observing COMPLETE to be set!
> > > 
> > > UAS> Afterwards, the other CPU also sets the PENDING bit, but this time for
> > > UAS> the next batch. So it ends up requesting nxtbatch+1, although there is
> > > UAS> no need to. This also would be fixed by making the batch number part of
> > > UAS> the cmpxchg.
> > 
> > Another approach is to map the underlying algorithm onto the TREE_RCU
> > data structures.  And make preempt_disable(), local_irq_save(), and
> > friends invoke rcu_read_lock() -- irq and nmi handlers already have
> > the dyntick calls into RCU, so should be easy to handle as well.
> > Famous last words.  ;-)
> 
> 
> So, this looks very scary for performances to add rcu_read_lock() in
> preempt_disable() and local_irq_save(), that notwithstanding it won't
> handle the "raw" rcu sched implicit path.

Ah -- I would arrange for the rcu_read_lock() to be added only in the
dyntick-hpc case.  So no effect on normal builds, overhead is added only
in the dyntick-hpc case.

>                                           We should check all rcu_dereference_sched
> users to ensure there are not in such raw path.

Indeed!  ;-)

> There is also my idea from the other discussion: change rcu_read_lock_sched()
> semantics and map it to rcu_read_lock() in this rcu config (would be a nop
> in other configs). So every users of rcu_dereference_sched() would now need
> to protect their critical section with this.
> Would it be too late to change this semantic?

I was expecting that we would fold RCU, RCU bh, and RCU sched into
the same set of primitives (as Jim Houston did), but again only in the
dyntick-hpc case.  However, rcu_read_lock_bh() would still disable BH,
and similarly, rcu_read_lock_sched() would still disable preemption.

> What is scary with this is that it also changes rcu sched semantics, and users
> of call_rcu_sched() and synchronize_sched(), who rely on that to do more
> tricky things than just waiting for rcu_derefence_sched() pointer grace periods,
> like really wanting for preempt_disable and local_irq_save/disable, those
> users will be screwed... :-(  ...unless we also add relevant rcu_read_lock_sched()
> for them...

So rcu_read_lock() would be the underlying primitive.  The implementation
of rcu_read_lock_sched() would disable preemption and then invoke
rcu_read_lock().  The implementation of rcu_read_lock_bh() would
disable BH and then invoke rcu_read_lock().  This would allow
synchronize_rcu_sched() and synchronize_rcu_bh() to simply invoke
synchronize_rcu().

Seem reasonable?

							Thanx, Paul
