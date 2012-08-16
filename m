Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2HPTRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:17:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46433 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2HPTRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:17:44 -0400
Date: Thu, 16 Aug 2012 12:17:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH RFC] sched: Make migration_call() safe for
 stop_machine()-free hotplug
Message-ID: <20120816191710.GF2445@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120725215126.GA7350@linux.vnet.ibm.com>
 <1345110832.29668.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345110832.29668.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081619-1780-0000-0000-0000086CA0FB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000292; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00165880; UDB=6.00037562; UTC=2012-08-16
 19:17:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:53:52AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-25 at 14:51 -0700, Paul E. McKenney wrote:
> > The CPU_DYING branch of migration_call() relies on the fact that
> > CPU-hotplug offline operations use stop_machine().  This commit therefore
> > attempts to remedy this situation by acquiring the relevant runqueue
> > locks.  Note that sched_ttwu_pending() remains outside of the scope of
> > these new runqueue-lock critical sections because (1) sched_ttwu_pending()
> > does its own runqueue-lock acquisition and (2) sched_ttwu_pending() handles
> > pending wakeups, and no further wakeups can select this CPU because it
> > is already marked as offline.
> > 
> > It is quite possible that migrate_nr_uninterruptible() 
> 
> The rules for nr_uninterruptible are that only the local cpu modifies
> its own count -- with the exception for the offline case where someone
> else picks up the remnant, which we assume is stable for the recently
> dead cpu.

OK, then my patch modifying this on some other CPU is bogus.  And this
code was relying on stop_machine() keeping the other CPUs from doing
anything.

Hmmm...  Can we just leave the ->nr_uninterruptible count sit on the
offlined CPU, given that nr_uninterruptible() scans all possible
CPUs rather than just the online ones?  The reason I avoided this
approach is that calc_load_fold_active() looks at just the specified
CPU's ->nr_uninterruptible count, and is called indirectly from the
scheduler-clock interrupt and from idle-entry code.

Alternatively, I could move the migrate_nr_uninterruptible() to the
CPU_DEAD notifier, at which point (as you say) manipulating the dead
CPU's ->nr_uninterruptible should be OK.  The main difference is that in
CPU_DYING the outgoing CPU is running a non-idle tasks, while in CPU_DEAD
the outgoing CPU would have most recently been seen running an idle task.

> Only the direct sum over all cpus of nr_uninterruptible is meaningful,
> see nr_uninterruptible() and the somewhat big comment titled "Global
> load-average calculations".

OK, so calc_load_fold_active()'s access to a single CPU's
->nr_uninterruptible is a heuristic, then.

> > and
> > calc_global_load_remove() somehow don't need runqueue-lock protection,
> > but I was not able to prove this to myself.
> 
> It shouldn't need it, the offlined cpu's value should be stable and the
> modification is to a global atomic with the proper atomic operation.

Very good, that does simplify things.

> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Gotta love this new schizophrenic you.. :-) I'm quite content with one
> functional email addr from you there.

Yeah, I should have left off "-a" when doing "git commit".  :-/

But of course I am of two minds about that.

> > ---
> > 
> >  core.c |   21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index eaead2d..2e7797a 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5175,10 +5175,8 @@ void idle_task_exit(void)
> >   * their home CPUs. So we just add the counter to another CPU's counter,
> >   * to keep the global sum constant after CPU-down:
> >   */
> > -static void migrate_nr_uninterruptible(struct rq *rq_src)
> > +static void migrate_nr_uninterruptible(struct rq *rq_src, struct rq *rq_dest)
> >  {
> > -	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
> > -
> >  	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
> >  	rq_src->nr_uninterruptible = 0;
> >  }
> > @@ -5200,7 +5198,7 @@ static void calc_global_load_remove(struct rq *rq)
> >   * there's no concurrency possible, we hold the required locks anyway
> >   * because of lock validation efforts.
> >   */
> > -static void migrate_tasks(unsigned int dead_cpu)
> > +static void migrate_tasks(unsigned int dead_cpu, struct rq *rq_dest)
> >  {
> >  	struct rq *rq = cpu_rq(dead_cpu);
> >  	struct task_struct *next, *stop = rq->stop;
> > @@ -5234,11 +5232,11 @@ static void migrate_tasks(unsigned int dead_cpu)
> >  
> >  		/* Find suitable destination for @next, with force if needed. */
> >  		dest_cpu = select_fallback_rq(dead_cpu, next);
> > -		raw_spin_unlock(&rq->lock);
> > +		double_rq_unlock(rq, rq_dest);
> >  
> >  		__migrate_task(next, dead_cpu, dest_cpu);
> >  
> > -		raw_spin_lock(&rq->lock);
> > +		double_rq_lock(rq, rq_dest);
> 
> I would almost propose adding ___migrate_task() to avoid the
> unlock-lock-unlock-lock dance there, possibly there's a better name
> though :-)

Hmmm...  Can I get away with splitting the critical section so that
set_rq_offline() is in one rq-lock critical section and migrate_tasks() is
in another?  But I cannot see how the first task needing to be migrated
would be special, so I am assuming that I can for the moment, but I am
sure that you will set me straight otherwise.

> >  	}
> >  
> >  	rq->stop = stop;
> > @@ -5452,6 +5450,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  	int cpu = (long)hcpu;
> >  	unsigned long flags;
> >  	struct rq *rq = cpu_rq(cpu);
> > +	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
> 
> I realize you took this from migrate_nr_uninterruptible(), but I think
> its actually wrong now, given the rules for nr_uninterruptible. But in
> general it seems to make more sense to pull stuff towards the operating
> cpu than to a random other cpu, no?

In the CPU_DYING notifier, the operating CPU is the CPU that is going
offline, so I do have to pick some other CPU.  I could confine the
definition of rq_dest to the CPU_DYING leg of the switch statement,
if that would help -- that is currently the only place it is used.

Another attempted patch below.

							Thanx, Paul

> >  	switch (action & ~CPU_TASKS_FROZEN) {
> >  
> > @@ -5474,17 +5473,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  	case CPU_DYING:
> >  		sched_ttwu_pending();
> >  		/* Update our root-domain */
> > -		raw_spin_lock_irqsave(&rq->lock, flags);
> > +		local_irq_save(flags);
> > +		double_rq_lock(rq, rq_dest);
> >  		if (rq->rd) {
> >  			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
> >  			set_rq_offline(rq);
> >  		}
> > -		migrate_tasks(cpu);
> > +		migrate_tasks(cpu, rq_dest);
> >  		BUG_ON(rq->nr_running != 1); /* the migration thread */
> > -		raw_spin_unlock_irqrestore(&rq->lock, flags);
> >  
> > -		migrate_nr_uninterruptible(rq);
> > +		migrate_nr_uninterruptible(rq, rq_dest);
> >  		calc_global_load_remove(rq);
> > +		double_rq_unlock(rq, rq_dest);
> > +		local_irq_restore(flags);
> >  		break;
> >  #endif
> >  	}

------------------------------------------------------------------------

sched: Make migration_call() safe for stop_machine()-free hotplug

The CPU_DYING branch of migration_call() relies on the fact that
CPU-hotplug offline operations use stop_machine().  This commit therefore
attempts to remedy this situation by moving work to the CPU_DEAD
notifier when the outgoing CPU is quiescent.  This requires a small
change to migrate_nr_uninterruptible() to move counts to the current
running CPU instead of a randomly selected CPU.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d325c4b..d09c4e0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5303,12 +5303,12 @@ void idle_task_exit(void)
  * While a dead CPU has no uninterruptible tasks queued at this point,
  * it might still have a nonzero ->nr_uninterruptible counter, because
  * for performance reasons the counter is not stricly tracking tasks to
- * their home CPUs. So we just add the counter to another CPU's counter,
+ * their home CPUs. So we just add the counter to the running CPU's counter,
  * to keep the global sum constant after CPU-down:
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
+	struct rq *rq_dest = cpu_rq(smp_processor_id());
 
 	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
 	rq_src->nr_uninterruptible = 0;
@@ -5613,9 +5613,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
-		migrate_nr_uninterruptible(rq);
-		calc_global_load_remove(rq);
+	case CPU_DEAD:
+		{
+			struct rq *dest_rq = cpu_rq(smp_processor_id());
+
+			local_irq_save(flags);
+			raw_spin_lock(&dest_rq->lock);
+			migrate_nr_uninterruptible(rq);
+			calc_global_load_remove(rq);
+			raw_spin_unlock(&dest_rq->lock);
+			local_irq_restore(flags);
+		}
 		break;
 #endif
 	}

