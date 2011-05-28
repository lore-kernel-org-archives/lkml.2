Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1E1Qkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:40:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab1E1Qkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:40:43 -0400
Date: Sat, 28 May 2011 18:40:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110528164033.GA10131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
KOSAKI Motohiro (1):
      cpuset: Fix cpuset_cpus_allowed_fallback(), don't update tsk->rt.nr_cpus_allowed

Peter Zijlstra (2):
      sched: Fix ttwu() for __ARCH_WANT_INTERRUPTS_ON_CTXSW
      sched: Fix ->min_vruntime calculation in dequeue_entity()

Xiaotian Feng (1):
      sched: More sched_domain iterations fixes


 include/linux/cpuset.h |    2 +-
 include/linux/sched.h  |    7 ++++++
 kernel/cpuset.c        |    4 +-
 kernel/kthread.c       |    4 +-
 kernel/sched.c         |   56 ++++++++++++++++++++++++++++++++++-------------
 kernel/sched_fair.c    |    5 ++-
 kernel/sched_rt.c      |   10 ++++++-
 kernel/sched_stats.h   |    4 +-
 8 files changed, 65 insertions(+), 27 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index f20eb8f..e9eaec5 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -146,7 +146,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 
 static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	do_set_cpus_allowed(p, cpu_possible_mask);
 	return cpumask_any(cpu_active_mask);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dc88712..8da84b7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1841,9 +1841,16 @@ static inline void rcu_copy_process(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SMP
+extern void do_set_cpus_allowed(struct task_struct *p,
+			       const struct cpumask *new_mask);
+
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
 #else
+static inline void do_set_cpus_allowed(struct task_struct *p,
+				      const struct cpumask *new_mask)
+{
+}
 static inline int set_cpus_allowed_ptr(struct task_struct *p,
 				       const struct cpumask *new_mask)
 {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1ceeb04..9c9b754 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2190,7 +2190,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	rcu_read_lock();
 	cs = task_cs(tsk);
 	if (cs)
-		cpumask_copy(&tsk->cpus_allowed, cs->cpus_allowed);
+		do_set_cpus_allowed(tsk, cs->cpus_allowed);
 	rcu_read_unlock();
 
 	/*
@@ -2217,7 +2217,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 		 * Like above we can temporary set any mask and rely on
 		 * set_cpus_allowed_ptr() as synchronization point.
 		 */
-		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
+		do_set_cpus_allowed(tsk, cpu_possible_mask);
 		cpu = cpumask_any(cpu_active_mask);
 	}
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3b34d27..4ba7ccc 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -202,8 +202,8 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 		return;
 	}
 
-	p->cpus_allowed = cpumask_of_cpu(cpu);
-	p->rt.nr_cpus_allowed = 1;
+	/* It's safe because the task is inactive. */
+	do_set_cpus_allowed(p, cpumask_of(cpu));
 	p->flags |= PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
diff --git a/kernel/sched.c b/kernel/sched.c
index 5e43e9d..cbb3a0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2573,7 +2573,26 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 	if (!next)
 		smp_send_reschedule(cpu);
 }
-#endif
+
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+	int ret = 0;
+
+	rq = __task_rq_lock(p);
+	if (p->on_cpu) {
+		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ret = 1;
+	}
+	__task_rq_unlock(rq);
+
+	return ret;
+
+}
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+#endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
@@ -2631,17 +2650,17 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	while (p->on_cpu) {
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 		/*
-		 * If called from interrupt context we could have landed in the
-		 * middle of schedule(), in this case we should take care not
-		 * to spin on ->on_cpu if p is current, since that would
-		 * deadlock.
+		 * In case the architecture enables interrupts in
+		 * context_switch(), we cannot busy wait, since that
+		 * would lead to deadlocks when an interrupt hits and
+		 * tries to wake up @prev. So bail and do a complete
+		 * remote wakeup.
 		 */
-		if (p == current) {
-			ttwu_queue(p, cpu);
+		if (ttwu_activate_remote(p, wake_flags))
 			goto stat;
-		}
-#endif
+#else
 		cpu_relax();
+#endif
 	}
 	/*
 	 * Pairs with the smp_wmb() in finish_lock_switch().
@@ -5841,7 +5860,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
-	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	do_set_cpus_allowed(idle, cpumask_of(cpu));
 	/*
 	 * We're having a chicken and egg problem, even though we are
 	 * holding rq->lock, the cpu isn't yet set to this cpu so the
@@ -5929,6 +5948,16 @@ static inline void sched_init_granularity(void)
 }
 
 #ifdef CONFIG_SMP
+void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
+{
+	if (p->sched_class && p->sched_class->set_cpus_allowed)
+		p->sched_class->set_cpus_allowed(p, new_mask);
+	else {
+		cpumask_copy(&p->cpus_allowed, new_mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+	}
+}
+
 /*
  * This is how migration works:
  *
@@ -5974,12 +6003,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 	}
 
-	if (p->sched_class->set_cpus_allowed)
-		p->sched_class->set_cpus_allowed(p, new_mask);
-	else {
-		cpumask_copy(&p->cpus_allowed, new_mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
-	}
+	do_set_cpus_allowed(p, new_mask);
 
 	/* Can the task run on the task's current CPU? If so, we're done */
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e32a9b7..433491c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1076,8 +1076,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	se->on_rq = 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1086,6 +1084,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	update_min_vruntime(cfs_rq);
+	update_cfs_shares(cfs_rq);
 }
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 64b2a37..88725c9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1263,6 +1263,7 @@ static int find_lowest_rq(struct task_struct *task)
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
 			int best_cpu;
@@ -1272,15 +1273,20 @@ static int find_lowest_rq(struct task_struct *task)
 			 * remote processor.
 			 */
 			if (this_cpu != -1 &&
-			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd))) {
+				rcu_read_unlock();
 				return this_cpu;
+			}
 
 			best_cpu = cpumask_first_and(lowest_mask,
 						     sched_domain_span(sd));
-			if (best_cpu < nr_cpu_ids)
+			if (best_cpu < nr_cpu_ids) {
+				rcu_read_unlock();
 				return best_cpu;
+			}
 		}
 	}
+	rcu_read_unlock();
 
 	/*
 	 * And finally, if there were no matches within the domains
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 48ddf43..331e01b 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -37,7 +37,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 #ifdef CONFIG_SMP
 		/* domain-specific stats */
-		preempt_disable();
+		rcu_read_lock();
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
@@ -64,7 +64,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
 			    sd->ttwu_move_balance);
 		}
-		preempt_enable();
+		rcu_read_unlock();
 #endif
 	}
 	kfree(mask_str);
