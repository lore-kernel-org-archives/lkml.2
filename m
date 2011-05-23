Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab1EWTYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:24:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409Ab1EWTYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:24:37 -0400
Date: Mon, 23 May 2011 21:24:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] higher scheduler load resolution
Message-ID: <20110523192421.GA3383@elte.hu>
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

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

This is something that came a bit late so i kept separate and under observation 
- but i think it's good and ready for v2.6.40. This change allows better 
balancing for larger amounts of cgroups (on 64-bit systems) - we were running 
out of resolution.

 Thanks,

	Ingo

------------------>
Nikhil Rao (3):
      sched: Cleanup set_load_weight()
      sched: Introduce SCHED_POWER_SCALE to scale cpu_power calculations
      sched: Increase SCHED_LOAD_SCALE resolution


 include/linux/sched.h |   34 ++++++++++++++++++++++++++-----
 kernel/sched.c        |   39 +++++++++++++++++++++++++-----------
 kernel/sched_fair.c   |   52 +++++++++++++++++++++++++-----------------------
 3 files changed, 82 insertions(+), 43 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 12211e1..c34a718 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -788,17 +788,39 @@ enum cpu_idle_type {
 };
 
 /*
- * sched-domains (multiprocessor balancing) declarations:
+ * Increase resolution of nice-level calculations for 64-bit architectures.
+ * The extra resolution improves shares distribution and load balancing of
+ * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
+ * hierarchies, especially on larger systems. This is not a user-visible change
+ * and does not change the user-interface for setting shares/weights.
+ *
+ * We increase resolution only if we have enough bits to allow this increased
+ * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
+ * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
+ * increased costs.
  */
+#if BITS_PER_LONG > 32
+# define SCHED_LOAD_RESOLUTION	10
+# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
+# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
+#else
+# define SCHED_LOAD_RESOLUTION	0
+# define scale_load(w)		(w)
+# define scale_load_down(w)	(w)
+#endif
 
-/*
- * Increase resolution of nice-level calculations:
- */
-#define SCHED_LOAD_SHIFT	10
+#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
-#define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
+/*
+ * Increase resolution of cpu_power calculations
+ */
+#define SCHED_POWER_SHIFT	10
+#define SCHED_POWER_SCALE	(1L << SCHED_POWER_SHIFT)
 
+/*
+ * sched-domains (multiprocessor balancing) declarations:
+ */
 #ifdef CONFIG_SMP
 #define SD_LOAD_BALANCE		0x0001	/* Do load balancing on this domain. */
 #define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
diff --git a/kernel/sched.c b/kernel/sched.c
index c62acf4..bb504e1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(1UL << 18)
+#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -1330,13 +1330,25 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
-	tmp = (u64)delta_exec * weight;
+	/*
+	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
+	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
+	 * 2^SCHED_LOAD_RESOLUTION.
+	 */
+	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
+		tmp = (u64)delta_exec * scale_load_down(weight);
+	else
+		tmp = (u64)delta_exec;
 
 	if (!lw->inv_weight) {
-		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
+		unsigned long w = scale_load_down(lw->weight);
+
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
 			lw->inv_weight = 1;
+		else if (unlikely(!w))
+			lw->inv_weight = WMULT_CONST;
 		else
-			lw->inv_weight = WMULT_CONST / lw->weight;
+			lw->inv_weight = WMULT_CONST / w;
 	}
 
 	/*
@@ -1778,17 +1790,20 @@ static void dec_nr_running(struct rq *rq)
 
 static void set_load_weight(struct task_struct *p)
 {
+	int prio = p->static_prio - MAX_RT_PRIO;
+	struct load_weight *load = &p->se.load;
+
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy == SCHED_IDLE) {
-		p->se.load.weight = WEIGHT_IDLEPRIO;
-		p->se.load.inv_weight = WMULT_IDLEPRIO;
+		load->weight = scale_load(WEIGHT_IDLEPRIO);
+		load->inv_weight = WMULT_IDLEPRIO;
 		return;
 	}
 
-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
-	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	load->weight = scale_load(prio_to_weight[prio]);
+	load->inv_weight = prio_to_wmult[prio];
 }
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -6527,7 +6542,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->cpu_power != SCHED_LOAD_SCALE) {
+		if (group->cpu_power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
 				group->cpu_power);
 		}
@@ -7902,7 +7917,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_power = SCHED_LOAD_SCALE;
+		rq->cpu_power = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
@@ -8806,14 +8821,14 @@ cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
-	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
+	return sched_group_set_shares(cgroup_tg(cgrp), scale_load(shareval));
 }
 
 static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
 
-	return (u64) tg->shares;
+	return (u64) scale_load_down(tg->shares);
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37f2262..e32a9b7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1584,7 +1584,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+		avg_load = (avg_load * SCHED_POWER_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -1722,7 +1722,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 				nr_running += cpu_rq(i)->cfs.nr_running;
 			}
 
-			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
 
 			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
 				nr_running /= 2;
@@ -2570,7 +2570,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
-	return SCHED_LOAD_SCALE;
+	return SCHED_POWER_SCALE;
 }
 
 unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
@@ -2607,10 +2607,10 @@ unsigned long scale_rt_power(int cpu)
 		available = total - rq->rt_avg;
 	}
 
-	if (unlikely((s64)total < SCHED_LOAD_SCALE))
-		total = SCHED_LOAD_SCALE;
+	if (unlikely((s64)total < SCHED_POWER_SCALE))
+		total = SCHED_POWER_SCALE;
 
-	total >>= SCHED_LOAD_SHIFT;
+	total >>= SCHED_POWER_SHIFT;
 
 	return div_u64(available, total);
 }
@@ -2618,7 +2618,7 @@ unsigned long scale_rt_power(int cpu)
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
-	unsigned long power = SCHED_LOAD_SCALE;
+	unsigned long power = SCHED_POWER_SCALE;
 	struct sched_group *sdg = sd->groups;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
@@ -2627,7 +2627,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		else
 			power *= default_scale_smt_power(sd, cpu);
 
-		power >>= SCHED_LOAD_SHIFT;
+		power >>= SCHED_POWER_SHIFT;
 	}
 
 	sdg->cpu_power_orig = power;
@@ -2637,10 +2637,10 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	else
 		power *= default_scale_freq_power(sd, cpu);
 
-	power >>= SCHED_LOAD_SHIFT;
+	power >>= SCHED_POWER_SHIFT;
 
 	power *= scale_rt_power(cpu);
-	power >>= SCHED_LOAD_SHIFT;
+	power >>= SCHED_POWER_SHIFT;
 
 	if (!power)
 		power = 1;
@@ -2682,7 +2682,7 @@ static inline int
 fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 {
 	/*
-	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
+	 * Only siblings can have significantly less than SCHED_POWER_SCALE
 	 */
 	if (!(sd->flags & SD_SHARE_CPUPOWER))
 		return 0;
@@ -2770,7 +2770,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->cpu_power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2787,7 +2787,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power,
+						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
 	sgs->group_weight = group->group_weight;
@@ -2961,7 +2962,7 @@ static int check_asym_packing(struct sched_domain *sd,
 		return 0;
 
 	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
-				       SCHED_LOAD_SCALE);
+				       SCHED_POWER_SCALE);
 	return 1;
 }
 
@@ -2990,7 +2991,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 			cpu_avg_load_per_task(this_cpu);
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
-						 * SCHED_LOAD_SCALE;
+					 * SCHED_POWER_SCALE;
 	scaled_busy_load_per_task /= sds->busiest->cpu_power;
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
@@ -3009,10 +3010,10 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 			min(sds->busiest_load_per_task, sds->max_load);
 	pwr_now += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load);
-	pwr_now /= SCHED_LOAD_SCALE;
+	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
 		sds->busiest->cpu_power;
 	if (sds->max_load > tmp)
 		pwr_move += sds->busiest->cpu_power *
@@ -3020,15 +3021,15 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	/* Amount of load we'd add */
 	if (sds->max_load * sds->busiest->cpu_power <
-		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
+		sds->busiest_load_per_task * SCHED_POWER_SCALE)
 		tmp = (sds->max_load * sds->busiest->cpu_power) /
 			sds->this->cpu_power;
 	else
-		tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
 			sds->this->cpu_power;
 	pwr_move += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
-	pwr_move /= SCHED_LOAD_SCALE;
+	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
@@ -3070,7 +3071,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		load_above_capacity = (sds->busiest_nr_running -
 						sds->busiest_group_capacity);
 
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
+		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
 		load_above_capacity /= sds->busiest->cpu_power;
 	}
@@ -3090,7 +3091,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	/* How much load to actually move to equalise the imbalance */
 	*imbalance = min(max_pull * sds->busiest->cpu_power,
 		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
-			/ SCHED_LOAD_SCALE;
+			/ SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -3159,7 +3160,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
@@ -3238,7 +3239,8 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power,
+							   SCHED_POWER_SCALE);
 		unsigned long wl;
 
 		if (!capacity)
@@ -3263,7 +3265,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_LOAD_SCALE) / power;
+		wl = (wl * SCHED_POWER_SCALE) / power;
 
 		if (wl > max_load) {
 			max_load = wl;
