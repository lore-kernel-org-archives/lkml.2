Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1AEQ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:57:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46823 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751129Ab1AEQ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:57:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YYm8Z/pwYMtZrgP/mNlL2NS8pd9ncW/Kq3JpKOq
	MTCfqQsgl/OKpE
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1294164289.2016.186.camel@laptop>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <1294164289.2016.186.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 17:57:27 +0100
Message-ID: <1294246647.8369.52.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's Rik's patch to do with whatever he wants (I donated suggestion;),
but I took the liberty of cleaning it up a bit, see below.  It's
essentially the same, but fixes a bug where the caller may have targeted
a task in it's thread group etc, but when preemption decision time came,
may have preempted a forbidden task.

On Tue, 2011-01-04 at 19:04 +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-03 at 16:29 -0500, Rik van Riel wrote:
> >  
> > +out:
> > +	double_rq_unlock(rq, p_rq);
> > +	local_irq_restore(flags);
> > +
> > +	if (yield) {
> > +		set_current_state(TASK_RUNNING);
> > +		schedule();
> > +	}
> > +}
> > +EXPORT_SYMBOL(yield_to);
> 
> This definitely wants to be EXPORT_SYMBOL_GPL() and if it were possible
> I'd make it so only kvm.o could use it. It really sucks that kvm is a
> module.

Did that.

> > +#ifdef CONFIG_FAIR_GROUP_SCHED
> > +	if (cfs_rq->tg != p_cfs_rq->tg)
> > +		return 0;
> > +
> > +	/* Preemption only allowed within the same task group. */
> > +	if (preempt && cfs_rq->tg != cfs_rq_of(curr)->tg)
> > +		preempt = 0;
> > +#endif
> 
> I'd simply bail if its not the same cgroup, who cares about that case
> anyway, all KVM vcpu threads should be in the same cgroup I think.

See below.

> > +	/* Preemption only allowed within the same thread group. */
> > +	if (preempt && !same_thread_group(current, task_of(p_cfs_rq->curr)))
> > +		preempt = 0;
> 
> The calling site already checks for same_thread_group(), we never even
> get here if that's not the case.

Yeah, task group check was over there already as well.  Hasty hack.

> > +#ifdef CONFIG_SMP
> > +	/*
> > +	 * If this yield is important enough to want to preempt instead
> > +	 * of only dropping a ->next hint, we're alone, and the target
> > +	 * is not alone, pull the target to this cpu.
> > +	 */
> > +	if (want_preempt && !yield && cfs_rq->nr_running == 1 &&
> > +			cpumask_test_cpu(smp_processor_id(), &p->cpus_allowed)) {
> > +		pull_task(task_rq(p), p, this_rq(), smp_processor_id());
> 
> This only works by the grace that the caller checked p->se.on_rq. A
> comment might be in order.

I moved all of the entity decisions to the class method, and tried to
make it a bit less ugly.


sched: Add yield_to(task, preempt) functionality.

Currently only implemented for fair class tasks.

Add a yield_to_task method() to the fair scheduling class. allowing the
caller of yield_to() to accelerate another thread in it's thread group,
task group, and sched class toward either it's cpu, or potentially the
caller's own cpu if the 'preempt' argument is also passed.

Implemented via a scheduler hint, using cfs_rq->next to encourage the
target being selected.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 include/linux/sched.h |    1 
 kernel/sched.c        |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1056,6 +1056,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
+	int (*yield_to_task) (struct task_struct *p, int preempt);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5327,6 +5327,62 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+/**
+ * yield_to - yield the current processor to another thread in
+ * your thread group, or accelerate that thread toward the
+ * processor it's on.
+ *
+ * It's the caller's job to ensure that the target task struct
+ * can't go away on us before we can do any checks.
+ */
+void __sched yield_to(struct task_struct *p, int preempt)
+{
+	struct task_struct *curr = current;
+	struct rq *rq, *p_rq;
+	unsigned long flags;
+	int yield = 0;
+
+	local_irq_save(flags);
+	rq = this_rq();
+
+again:
+	p_rq = task_rq(p);
+	double_rq_lock(rq, p_rq);
+	while (task_rq(p) != p_rq) {
+		double_rq_unlock(rq, p_rq);
+		goto again;
+	}
+
+	if (!curr->sched_class->yield_to_task)
+		goto out;
+
+	if (curr->sched_class != p->sched_class)
+		goto out;
+
+	if (task_running(p_rq, p) || p->state)
+		goto out;
+
+	if (!same_thread_group(p, curr))
+		goto out;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (task_group(p) != task_group(curr))
+		goto out;
+#endif
+
+	yield = curr->sched_class->yield_to_task(p, preempt);
+
+out:
+	double_rq_unlock(rq, p_rq);
+	local_irq_restore(flags);
+
+	if (yield) {
+		set_current_state(TASK_RUNNING);
+		schedule();
+	}
+}
+EXPORT_SYMBOL_GPL(yield_to);
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1337,6 +1337,57 @@ static void yield_task_fair(struct rq *r
 }
 
 #ifdef CONFIG_SMP
+static void pull_task(struct rq *src_rq, struct task_struct *p,
+		      struct rq *this_rq, int this_cpu);
+#endif
+
+static int yield_to_task_fair(struct task_struct *p, int preempt)
+{
+	struct sched_entity *se = &current->se;
+	struct sched_entity *pse = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	struct cfs_rq *p_cfs_rq = cfs_rq_of(pse);
+	int local = cfs_rq == p_cfs_rq;
+	int this_cpu = smp_processor_id();
+
+	if (!pse->on_rq)
+		return 0;
+
+#ifdef CONFIG_SMP
+	/*
+	 * If this yield is important enough to want to preempt instead
+	 * of only dropping a ->next hint, we're alone, and the target
+	 * is not alone, pull the target to this cpu.
+	 *
+	 * NOTE: the target may be alone in it's cfs_rq if another class
+	 * task or another task group is currently executing on it's cpu.
+	 * In this case, we still pull, to accelerate it toward the cpu.
+	 */
+	if (!local && preempt && cfs_rq->nr_running == 1 &&
+			cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
+		pull_task(task_rq(p), p, this_rq(), this_cpu);
+		p_cfs_rq = cfs_rq_of(pse);
+		local = 1;
+	}
+#endif
+
+	/* Tell the scheduler that we'd really like pse to run next. */
+	p_cfs_rq->next = pse;
+
+	/* We know whether we want to preempt or not, but are we allowed? */
+	preempt &= same_thread_group(p, task_of(p_cfs_rq->curr));
+
+	if (local)
+		clear_buddies(cfs_rq, se);
+	else if (preempt) {
+		clear_buddies(p_cfs_rq, p_cfs_rq->curr);
+		resched_task(task_of(p_cfs_rq->curr));
+	}
+
+	return local;
+}
+
+#ifdef CONFIG_SMP
 
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
 {
@@ -4143,6 +4194,7 @@ static const struct sched_class fair_sch
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
+	.yield_to_task		= yield_to_task_fair,
 
 	.check_preempt_curr	= check_preempt_wakeup,
 


