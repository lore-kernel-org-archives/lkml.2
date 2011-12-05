Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1LESvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:51:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50479 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1LESvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:51:22 -0500
Date: Mon, 5 Dec 2011 19:49:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20111205184943.GA20795@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00,DIET_1 autolearn=no SpamAssassin version=3.3.1
	0.0 DIET_1                 BODY: Lose Weight Spam
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Carsten Emde (1):
      sched: Set the command name of the idle tasks in SMP kernels

Hui Kang (1):
      sched_fair: Fix a typo in the comment describing update_sd_lb_stats

J. Bruce Fields (1):
      sched: Document wait_for_completion_*() return values

Paul Turner (1):
      sched: Fix buglet in return_cfs_rq_runtime()

Peter Zijlstra (3):
      sched: Add a comment to effective_load() since it's a pain
      sched, rt: Provide means of disabling cross-cpu bandwidth sharing
      sched: Avoid SMT siblings in select_idle_sibling() if possible

Salman Qazi (1):
      sched, x86: Avoid unnecessary overflow in sched_clock


 arch/x86/include/asm/timer.h |   23 ++++++-
 include/linux/init_task.h    |    4 +-
 kernel/sched.c               |   17 +++++
 kernel/sched_fair.c          |  159 +++++++++++++++++++++++++++++++++---------
 kernel/sched_features.h      |    1 +
 kernel/sched_rt.c            |    3 +
 6 files changed, 171 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index fa7b917..431793e 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -32,6 +32,22 @@ extern int no_timer_check;
  *  (mathieu.desnoyers@polymtl.ca)
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ *
+ * In:
+ *
+ * ns = cycles * cyc2ns_scale / SC
+ *
+ * Although we may still have enough bits to store the value of ns,
+ * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
+ * leading to an incorrect result.
+ *
+ * To avoid this, we can decompose 'cycles' into quotient and remainder
+ * of division by SC.  Then,
+ *
+ * ns = (quot * SC + rem) * cyc2ns_scale / SC
+ *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
+ *
+ *			- sqazi@google.com
  */
 
 DECLARE_PER_CPU(unsigned long, cyc2ns);
@@ -41,9 +57,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
+	unsigned long long quot;
+	unsigned long long rem;
 	int cpu = smp_processor_id();
 	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
+	quot = (cyc >> CYC2NS_SCALE_FACTOR);
+	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
+	ns += quot * per_cpu(cyc2ns, cpu) +
+		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
 	return ns;
 }
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 08ffab0..b6e5b8b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -126,6 +126,8 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#define INIT_TASK_COMM "swapper"
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -162,7 +164,7 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
-	.comm		= "swapper",					\
+	.comm		= INIT_TASK_COMM,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..d6b149c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/init_task.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -4810,6 +4811,9 @@ EXPORT_SYMBOL(wait_for_completion);
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. The timeout is in jiffies. It is not
  * interruptible.
+ *
+ * The return value is 0 if timed out, and positive (at least 1, or number of
+ * jiffies left till timeout) if completed.
  */
 unsigned long __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
@@ -4824,6 +4828,8 @@ EXPORT_SYMBOL(wait_for_completion_timeout);
  *
  * This waits for completion of a specific task to be signaled. It is
  * interruptible.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_interruptible(struct completion *x)
 {
@@ -4841,6 +4847,9 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
  *
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. It is interruptible. The timeout is in jiffies.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
+ * positive (at least 1, or number of jiffies left till timeout) if completed.
  */
 long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
@@ -4856,6 +4865,8 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
  *
  * This waits to be signaled for completion of a specific task. It can be
  * interrupted by a kill signal.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_killable(struct completion *x)
 {
@@ -4874,6 +4885,9 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  * This waits for either a completion of a specific task to be
  * signaled or for a specified timeout to expire. It can be
  * interrupted by a kill signal. The timeout is in jiffies.
+ *
+ * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
+ * positive (at least 1, or number of jiffies left till timeout) if completed.
  */
 long __sched
 wait_for_completion_killable_timeout(struct completion *x,
@@ -6099,6 +6113,9 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
+#if defined(CONFIG_SMP)
+	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+#endif
 }
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..a78ed27 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -772,19 +772,32 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 		list_del_leaf_cfs_rq(cfs_rq);
 }
 
+static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
+{
+	long tg_weight;
+
+	/*
+	 * Use this CPU's actual weight instead of the last load_contribution
+	 * to gain a more accurate current total weight. See
+	 * update_cfs_rq_load_contribution().
+	 */
+	tg_weight = atomic_read(&tg->load_weight);
+	tg_weight -= cfs_rq->load_contribution;
+	tg_weight += cfs_rq->load.weight;
+
+	return tg_weight;
+}
+
 static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
-	long load_weight, load, shares;
+	long tg_weight, load, shares;
 
+	tg_weight = calc_tg_weight(tg, cfs_rq);
 	load = cfs_rq->load.weight;
 
-	load_weight = atomic_read(&tg->load_weight);
-	load_weight += load;
-	load_weight -= cfs_rq->load_contribution;
-
 	shares = (tg->shares * load);
-	if (load_weight)
-		shares /= load_weight;
+	if (tg_weight)
+		shares /= tg_weight;
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
@@ -1743,7 +1756,7 @@ static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
+	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
 		return;
 
 	__return_cfs_rq_runtime(cfs_rq);
@@ -2036,36 +2049,100 @@ static void task_waking_fair(struct task_struct *p)
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
  * can calculate the shift in shares.
+ *
+ * Calculate the effective load difference if @wl is added (subtracted) to @tg
+ * on this @cpu and results in a total addition (subtraction) of @wg to the
+ * total group weight.
+ *
+ * Given a runqueue weight distribution (rw_i) we can compute a shares
+ * distribution (s_i) using:
+ *
+ *   s_i = rw_i / \Sum rw_j						(1)
+ *
+ * Suppose we have 4 CPUs and our @tg is a direct child of the root group and
+ * has 7 equal weight tasks, distributed as below (rw_i), with the resulting
+ * shares distribution (s_i):
+ *
+ *   rw_i = {   2,   4,   1,   0 }
+ *   s_i  = { 2/7, 4/7, 1/7,   0 }
+ *
+ * As per wake_affine() we're interested in the load of two CPUs (the CPU the
+ * task used to run on and the CPU the waker is running on), we need to
+ * compute the effect of waking a task on either CPU and, in case of a sync
+ * wakeup, compute the effect of the current task going to sleep.
+ *
+ * So for a change of @wl to the local @cpu with an overall group weight change
+ * of @wl we can compute the new shares distribution (s'_i) using:
+ *
+ *   s'_i = (rw_i + @wl) / (@wg + \Sum rw_j)				(2)
+ *
+ * Suppose we're interested in CPUs 0 and 1, and want to compute the load
+ * differences in waking a task to CPU 0. The additional task changes the
+ * weight and shares distributions like:
+ *
+ *   rw'_i = {   3,   4,   1,   0 }
+ *   s'_i  = { 3/8, 4/8, 1/8,   0 }
+ *
+ * We can then compute the difference in effective weight by using:
+ *
+ *   dw_i = S * (s'_i - s_i)						(3)
+ *
+ * Where 'S' is the group weight as seen by its parent.
+ *
+ * Therefore the effective change in loads on CPU 0 would be 5/56 (3/8 - 2/7)
+ * times the weight of the group. The effect on CPU 1 would be -4/56 (4/8 -
+ * 4/7) times the weight of the group.
  */
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
-	if (!tg->parent)
+	if (!tg->parent)	/* the trivial, non-cgroup case */
 		return wl;
 
 	for_each_sched_entity(se) {
-		long lw, w;
+		long w, W;
 
 		tg = se->my_q->tg;
-		w = se->my_q->load.weight;
 
-		/* use this cpu's instantaneous contribution */
-		lw = atomic_read(&tg->load_weight);
-		lw -= se->my_q->load_contribution;
-		lw += w + wg;
+		/*
+		 * W = @wg + \Sum rw_j
+		 */
+		W = wg + calc_tg_weight(tg, se->my_q);
 
-		wl += w;
+		/*
+		 * w = rw_i + @wl
+		 */
+		w = se->my_q->load.weight + wl;
 
-		if (lw > 0 && wl < lw)
-			wl = (wl * tg->shares) / lw;
+		/*
+		 * wl = S * s'_i; see (2)
+		 */
+		if (W > 0 && w < W)
+			wl = (w * tg->shares) / W;
 		else
 			wl = tg->shares;
 
-		/* zero point is MIN_SHARES */
+		/*
+		 * Per the above, wl is the new se->load.weight value; since
+		 * those are clipped to [MIN_SHARES, ...) do so now. See
+		 * calc_cfs_shares().
+		 */
 		if (wl < MIN_SHARES)
 			wl = MIN_SHARES;
+
+		/*
+		 * wl = dw_i = S * (s'_i - s_i); see (3)
+		 */
 		wl -= se->load.weight;
+
+		/*
+		 * Recursively apply this logic to all parent groups to compute
+		 * the final effective load change on the root group. Since
+		 * only the @tg group gets extra weight, all parent groups can
+		 * only redistribute existing shares. @wl is the shift in shares
+		 * resulting from this level per the above.
+		 */
 		wg = 0;
 	}
 
@@ -2249,7 +2326,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
-	int i;
+	struct sched_group *sg;
+	int i, smt = 0;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2269,25 +2347,38 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	rcu_read_lock();
+again:
 	for_each_domain(target, sd) {
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
-			break;
+		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
+			continue;
 
-		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
-			if (idle_cpu(i)) {
-				target = i;
-				break;
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
+			if (!smt) {
+				smt = 1;
+				goto again;
 			}
+			break;
 		}
 
-		/*
-		 * Lets stop looking for an idle sibling when we reached
-		 * the domain that spans the current cpu and prev_cpu.
-		 */
-		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
-			break;
+		sg = sd->groups;
+		do {
+			if (!cpumask_intersects(sched_group_cpus(sg),
+						tsk_cpus_allowed(p)))
+				goto next;
+
+			for_each_cpu(i, sched_group_cpus(sg)) {
+				if (!idle_cpu(i))
+					goto next;
+			}
+
+			target = cpumask_first_and(sched_group_cpus(sg),
+					tsk_cpus_allowed(p));
+			goto done;
+next:
+			sg = sg->next;
+		} while (sg != sd->groups);
 	}
+done:
 	rcu_read_unlock();
 
 	return target;
@@ -3511,7 +3602,7 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
 }
 
 /**
- * update_sd_lb_stats - Update sched_group's statistics for load balancing.
+ * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index efa0a7b..8480224 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -67,3 +67,4 @@ SCHED_FEAT(NONTASK_POWER, 1)
 SCHED_FEAT(TTWU_QUEUE, 1)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, 0)
+SCHED_FEAT(RT_RUNTIME_SHARE, 1)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 056cbd2..583a136 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -560,6 +560,9 @@ static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
 
+	if (!sched_feat(RT_RUNTIME_SHARE))
+		return more;
+
 	if (rt_rq->rt_time > rt_rq->rt_runtime) {
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		more = do_balance_runtime(rt_rq);
