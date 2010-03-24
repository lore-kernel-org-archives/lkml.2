Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0CXRix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:38:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0CXRiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:38:51 -0400
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100315090958.GA9116@redhat.com>
References: <20100315090958.GA9116@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 18:38:16 +0100
Message-ID: <1269452296.5109.508.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 10:09 +0100, Oleg Nesterov wrote:
> Ingo, Peter.
> 
> Unless I missed something, with or without these patches the TASK_WAKING
> logic in do_fork() is very broken.
> 
> 	- do_fork() clears PF_STARTING and then calls wake_up_new_task()
> 	  which finally does s/WAKING/RUNNING.
> 
> 	  But. Nobody can take rq->lock in between. This means a signal
> 	  from irq (quite possible with CLONE_THREAD) or another rt
> 	  thread which preempts us can lockup.

Hmm, the signal case might indeed be a problem, however I cannot see how
the RT thread can be a problem because until we do wake_up_new_task()
the child will not be runnable and can thus not be preempted.

We could frob it by taking rq->lock over clearing PF_STARTING but that's
beyond ugly...

> 	- the comment in wake_up_new_task says:
> 	
> 		We still have TASK_WAKING but PF_STARTING is gone now, meaning
> 		->cpus_allowed is stable
> 
> 	  this is not true. Yes, nobody can take rq->lock _after_ we cleared
> 	  PF_STARTING, but it is possible that another thread took this lock
> 	  before and still holds it doing, say, sched_setaffinity().
> 
> No?
> 
> If yes. I can make a patch, but the question is: what is the point to use
> TASK_WAKING in fork pathes? Can't sched_fork() set TASK_RUNNING instead?
> Afaics, TASK_RUNNING can equally protect from premature wakeups but doesn't
> these PF_STARTING complications.

Argh, yes.. that's because PF_STARTING is cleared after we expose the
PID, and we needed the PF_STARTING exemption because of that
ns_cgroup_clone() trainwreck.

The reason we have that TASK_WAKING stuff for fork is because
wake_up_new_task() needs p->cpus_allowed to be stable, and we cannot do
select_task_rq() with rq->lock held because of the cgroup-sched crap.

/me goes read the code after applying your patches and frobs the
following patch on top..


So the below patch makes select_task_rq_fair unlock the rq when needed,
and then puts all ->select_task_rq() calls under rq->lock. This should
allow us to remove the TASK_WAKING thing from fork which in turn allows
us to remove the PF_STARTING check in task_is_waking.

How does that look?

(totally untested, will try and boot after dinner)


---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1051,7 +1051,8 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
+			       int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -916,14 +916,10 @@ static inline void finish_lock_switch(st
 /*
  * Check whether the task is waking, we use this to synchronize against
  * ttwu() so that task_cpu() reports a stable number.
- *
- * We need to make an exception for PF_STARTING tasks because the fork
- * path might require task_rq_lock() to work, eg. it can call
- * set_cpus_allowed_ptr() from the cpuset clone_ns code.
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+	return unlikely(p->state == TASK_WAKING);
 }
 
 /*
@@ -2319,9 +2315,9 @@ static int select_fallback_rq(int cpu, s
  * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2392,9 +2388,7 @@ static int try_to_wake_up(struct task_st
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(rq, p);
 
-	__task_rq_unlock(rq);
-
-	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu) {
 		/*
 		 * Since we migrate the task without holding any rq->lock,
@@ -2403,6 +2397,7 @@ static int try_to_wake_up(struct task_st
 		 */
 		set_task_cpu(p, cpu);
 	}
+	__task_rq_unlock(rq);
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
@@ -2533,7 +2528,7 @@ void sched_fork(struct task_struct *p, i
 	 * nobody will actually run it, and a signal or other external
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
-	p->state = TASK_WAKING;
+	p->state = TASK_RUNNING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2600,28 +2595,25 @@ void wake_up_new_task(struct task_struct
 	int cpu __maybe_unused = get_cpu();
 
 #ifdef CONFIG_SMP
+	rq = task_rq_lock(p, &flags);
+	p->state = TASK_WAKING;
+
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
 	 *
-	 * We still have TASK_WAKING but PF_STARTING is gone now, meaning
-	 * ->cpus_allowed is stable, we have preemption disabled, meaning
-	 * cpu_online_mask is stable.
+	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
+	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
-#endif
 
-	/*
-	 * Since the task is not on the rq and we still have TASK_WAKING set
-	 * nobody else will migrate this task.
-	 */
-	rq = cpu_rq(cpu);
-	raw_spin_lock_irqsave(&rq->lock, flags);
-
-	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
+	task_rq_unlock(rq, &flags);
+#endif
+
+	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
@@ -3067,19 +3059,15 @@ void sched_exec(void)
 {
 	struct task_struct *p = current;
 	struct migration_req req;
-	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
-
-	this_cpu = get_cpu();
-	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
-	if (dest_cpu == this_cpu) {
-		put_cpu();
-		return;
-	}
+	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	put_cpu();
+	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	if (dest_cpu == smp_processor_id())
+		goto unlock;
+
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
@@ -3097,6 +3085,7 @@ void sched_exec(void)
 
 		return;
 	}
+unlock:
 	task_rq_unlock(rq, &flags);
 }
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1414,7 +1414,8 @@ select_idle_sibling(struct task_struct *
  *
  * preempt must be disabled.
  */
-static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
+static int
+select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
@@ -1512,8 +1513,11 @@ static int select_task_rq_fair(struct ta
 				  cpumask_weight(sched_domain_span(sd))))
 			tmp = affine_sd;
 
-		if (tmp)
+		if (tmp) {
+			raw_spin_unlock(&rq->lock);
 			update_shares(tmp);
+			raw_spin_lock(&rq->lock);
+		}
 	}
 #endif
 
Index: linux-2.6/kernel/sched_idletask.c
===================================================================
--- linux-2.6.orig/kernel/sched_idletask.c
+++ linux-2.6/kernel/sched_idletask.c
@@ -6,7 +6,8 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
+static int
+select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -948,10 +948,9 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
+static int
+select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 {
-	struct rq *rq = task_rq(p);
-
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 

