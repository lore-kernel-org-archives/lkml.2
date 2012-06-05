Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287Ab2FEJWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:22:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33699 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2FEJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:22:05 -0400
Date: Tue, 5 Jun 2012 11:21:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120605092019.GA18994@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 6a4c96eef42f835734a82c6b512abf9881b7c55d sched: Remove NULL assignment of dattr_cur

 Thanks,

	Ingo

------------------>
Colin Cross (1):
      sched/rt: Fix SCHED_RR across cgroups

Hiroshi Shimamoto (2):
      sched: Make sched_feat_names const
      sched: Remove the last NULL entry from sched_feat_names

Kamalesh Babulal (1):
      sched: Remove NULL assignment of dattr_cur

Peter Zijlstra (6):
      sched/x86: Use cpu_llc_shared_mask(cpu) for coregroup_mask
      sched/nohz: Fix rq->cpu_load calculations some more
      sched: Don't try allocating memory from offline nodes
      sched: Fix SD_OVERLAP
      sched: Make sure to not re-read variables after validation
      sched: Move nr_cpus_allowed out of 'struct sched_rt_entity'


 arch/blackfin/kernel/process.c |  2 +-
 arch/x86/kernel/smpboot.c      | 10 +------
 include/linux/init_task.h      |  2 +-
 include/linux/sched.h          |  3 +-
 kernel/sched/core.c            | 68 +++++++++++++++++++++++++++++++-----------
 kernel/sched/fair.c            | 42 +++++++++++++++++++-------
 kernel/sched/rt.c              | 51 ++++++++++++++++++-------------
 kernel/time/tick-sched.c       |  1 +
 8 files changed, 120 insertions(+), 59 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 2e3994b..62bcea7 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -173,7 +173,7 @@ asmlinkage int bfin_clone(struct pt_regs *regs)
 	unsigned long newsp;
 
 #ifdef __ARCH_SYNC_CORE_DCACHE
-	if (current->rt.nr_cpus_allowed == num_possible_cpus())
+	if (current->nr_cpus_allowed == num_possible_cpus())
 		set_cpus_allowed_ptr(current, cpumask_of(smp_processor_id()));
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f56f96d..fd019d7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -410,15 +410,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 /* maps the cpu to the sched domain representing multi-core */
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	/*
-	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
-	 */
-	if (!(cpu_has(c, X86_FEATURE_AMD_DCM)))
-		return cpu_core_mask(cpu);
-	else
-		return cpu_llc_shared_mask(cpu);
+	return cpu_llc_shared_mask(cpu);
 }
 
 static void impress_friends(void)
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e4baff5..9e65eff 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,6 +149,7 @@ extern struct cred init_cred;
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
+	.nr_cpus_allowed= NR_CPUS,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.se		= {						\
@@ -157,7 +158,6 @@ extern struct cred init_cred;
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
 		.time_slice	= RR_TIMESLICE,				\
-		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	INIT_PUSHABLE_TASKS(tsk)					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f45c0b2..0f50e78 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,6 +145,7 @@ extern unsigned long this_cpu_load(void);
 
 
 extern void calc_global_load(unsigned long ticks);
+extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
@@ -1187,7 +1188,6 @@ struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
 	unsigned int time_slice;
-	int nr_cpus_allowed;
 
 	struct sched_rt_entity *back;
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -1252,6 +1252,7 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
+	int nr_cpus_allowed;
 	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 39eb601..c46958e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -142,9 +142,8 @@ const_debug unsigned int sysctl_sched_features =
 #define SCHED_FEAT(name, enabled)	\
 	#name ,
 
-static __read_mostly char *sched_feat_names[] = {
+static const char * const sched_feat_names[] = {
 #include "features.h"
-	NULL
 };
 
 #undef SCHED_FEAT
@@ -2517,25 +2516,32 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	sched_avg_update(this_rq);
 }
 
+#ifdef CONFIG_NO_HZ
+/*
+ * There is no sane way to deal with nohz on smp when using jiffies because the
+ * cpu doing the jiffies update might drift wrt the cpu doing the jiffy reading
+ * causing off-by-one errors in observed deltas; {0,2} instead of {1,1}.
+ *
+ * Therefore we cannot use the delta approach from the regular tick since that
+ * would seriously skew the load calculation. However we'll make do for those
+ * updates happening while idle (nohz_idle_balance) or coming out of idle
+ * (tick_nohz_idle_exit).
+ *
+ * This means we might still be one tick off for nohz periods.
+ */
+
 /*
  * Called from nohz_idle_balance() to update the load ratings before doing the
  * idle balance.
  */
 void update_idle_cpu_load(struct rq *this_rq)
 {
-	unsigned long curr_jiffies = jiffies;
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
 	unsigned long load = this_rq->load.weight;
 	unsigned long pending_updates;
 
 	/*
-	 * Bloody broken means of dealing with nohz, but better than nothing..
-	 * jiffies is updated by one cpu, another cpu can drift wrt the jiffy
-	 * update and see 0 difference the one time and 2 the next, even though
-	 * we ticked at roughtly the same rate.
-	 *
-	 * Hence we only use this from nohz_idle_balance() and skip this
-	 * nonsense when called from the scheduler_tick() since that's
-	 * guaranteed a stable rate.
+	 * bail if there's load or we're actually up-to-date.
 	 */
 	if (load || curr_jiffies == this_rq->last_load_update_tick)
 		return;
@@ -2547,12 +2553,38 @@ void update_idle_cpu_load(struct rq *this_rq)
 }
 
 /*
+ * Called from tick_nohz_idle_exit() -- try and fix up the ticks we missed.
+ */
+void update_cpu_load_nohz(void)
+{
+	struct rq *this_rq = this_rq();
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long pending_updates;
+
+	if (curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	raw_spin_lock(&this_rq->lock);
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	if (pending_updates) {
+		this_rq->last_load_update_tick = curr_jiffies;
+		/*
+		 * We were idle, this means load 0, the current load might be
+		 * !0 due to remote wakeups and the sort.
+		 */
+		__update_cpu_load(this_rq, 0, pending_updates);
+	}
+	raw_spin_unlock(&this_rq->lock);
+}
+#endif /* CONFIG_NO_HZ */
+
+/*
  * Called from scheduler_tick()
  */
 static void update_cpu_load_active(struct rq *this_rq)
 {
 	/*
-	 * See the mess in update_idle_cpu_load().
+	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
 	__update_cpu_load(this_rq, this_rq->load.weight, 1);
@@ -4982,7 +5014,7 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
-	p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+	p->nr_cpus_allowed = cpumask_weight(new_mask);
 }
 
 /*
@@ -5997,11 +6029,14 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 
 		cpumask_or(covered, covered, sg_span);
 
-		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
+		sg->sgp = *per_cpu_ptr(sdd->sgp, i);
 		atomic_inc(&sg->sgp->ref);
 
-		if (cpumask_test_cpu(cpu, sg_span))
+		if ((!groups && cpumask_test_cpu(cpu, sg_span)) ||
+			       cpumask_first(sg_span) == cpu) {
+			WARN_ON_ONCE(!cpumask_test_cpu(cpu, sg_span));
 			groups = sg;
+		}
 
 		if (!first)
 			first = sg;
@@ -6403,7 +6438,7 @@ static void sched_init_numa(void)
 			return;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
 			if (!mask)
 				return;
 
@@ -6691,7 +6726,6 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
-	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 940e6d1..b2a2d23 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2703,7 +2703,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
-	if (p->rt.nr_cpus_allowed == 1)
+	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
@@ -3503,15 +3503,22 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	u64 total, available;
+	u64 total, available, age_stamp, avg;
 
-	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	/*
+	 * Since we're reading these variables without serialization make sure
+	 * we read them once before doing sanity checks on them.
+	 */
+	age_stamp = ACCESS_ONCE(rq->age_stamp);
+	avg = ACCESS_ONCE(rq->rt_avg);
+
+	total = sched_avg_period() + (rq->clock - age_stamp);
 
-	if (unlikely(total < rq->rt_avg)) {
+	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
 		available = 0;
 	} else {
-		available = total - rq->rt_avg;
+		available = total - avg;
 	}
 
 	if (unlikely((s64)total < SCHED_POWER_SCALE))
@@ -3574,11 +3581,26 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 	power = 0;
 
-	group = child->groups;
-	do {
-		power += group->sgp->power;
-		group = group->next;
-	} while (group != child->groups);
+	if (child->flags & SD_OVERLAP) {
+		/*
+		 * SD_OVERLAP domains cannot assume that child groups
+		 * span the current group.
+		 */
+
+		for_each_cpu(cpu, sched_group_cpus(sdg))
+			power += power_of(cpu);
+	} else  {
+		/*
+		 * !SD_OVERLAP domains can assume that child groups
+		 * span the current group.
+		 */ 
+
+		group = child->groups;
+		do {
+			power += group->sgp->power;
+			group = group->next;
+		} while (group != child->groups);
+	}
 
 	sdg->sgp->power = power;
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c5565c3..2a4e8df 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -274,13 +274,16 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	struct task_struct *p;
+
 	if (!rt_entity_is_task(rt_se))
 		return;
 
+	p = rt_task_of(rt_se);
 	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
 
 	rt_rq->rt_nr_total++;
-	if (rt_se->nr_cpus_allowed > 1)
+	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
 	update_rt_migration(rt_rq);
@@ -288,13 +291,16 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	struct task_struct *p;
+
 	if (!rt_entity_is_task(rt_se))
 		return;
 
+	p = rt_task_of(rt_se);
 	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
 
 	rt_rq->rt_nr_total--;
-	if (rt_se->nr_cpus_allowed > 1)
+	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 
 	update_rt_migration(rt_rq);
@@ -1161,7 +1167,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 
-	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
+	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 
 	inc_nr_running(rq);
@@ -1225,7 +1231,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 
 	cpu = task_cpu(p);
 
-	if (p->rt.nr_cpus_allowed == 1)
+	if (p->nr_cpus_allowed == 1)
 		goto out;
 
 	/* For anything but wake ups, just return the task_cpu */
@@ -1260,9 +1266,9 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 * will have to sort it out.
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
-	    (curr->rt.nr_cpus_allowed < 2 ||
+	    (curr->nr_cpus_allowed < 2 ||
 	     curr->prio <= p->prio) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
+	    (p->nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
@@ -1276,10 +1282,10 @@ out:
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->rt.nr_cpus_allowed == 1)
+	if (rq->curr->nr_cpus_allowed == 1)
 		return;
 
-	if (p->rt.nr_cpus_allowed != 1
+	if (p->nr_cpus_allowed != 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
@@ -1395,7 +1401,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1408,7 +1414,7 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
 	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->rt.nr_cpus_allowed > 1))
+	    (p->nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -1464,7 +1470,7 @@ static int find_lowest_rq(struct task_struct *task)
 	if (unlikely(!lowest_mask))
 		return -1;
 
-	if (task->rt.nr_cpus_allowed == 1)
+	if (task->nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
@@ -1586,7 +1592,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 
 	BUG_ON(rq->cpu != task_cpu(p));
 	BUG_ON(task_current(rq, p));
-	BUG_ON(p->rt.nr_cpus_allowed <= 1);
+	BUG_ON(p->nr_cpus_allowed <= 1);
 
 	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
@@ -1793,9 +1799,9 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
-	    p->rt.nr_cpus_allowed > 1 &&
+	    p->nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	    (rq->curr->nr_cpus_allowed < 2 ||
 	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
@@ -1817,7 +1823,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 	 * Only update if the process changes its state from whether it
 	 * can migrate or not.
 	 */
-	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
+	if ((p->nr_cpus_allowed > 1) == (weight > 1))
 		return;
 
 	rq = task_rq(p);
@@ -1979,6 +1985,8 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	struct sched_rt_entity *rt_se = &p->rt;
+
 	update_curr_rt(rq);
 
 	watchdog(rq, p);
@@ -1996,12 +2004,15 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	p->rt.time_slice = RR_TIMESLICE;
 
 	/*
-	 * Requeue to the end of queue if we are not the only element
-	 * on the queue:
+	 * Requeue to the end of queue if we (and all of our ancestors) are the
+	 * only element on the queue
 	 */
-	if (p->rt.run_list.prev != p->rt.run_list.next) {
-		requeue_task_rt(rq, p, 0);
-		set_tsk_need_resched(p);
+	for_each_sched_rt_entity(rt_se) {
+		if (rt_se->run_list.prev != rt_se->run_list.next) {
+			requeue_task_rt(rq, p, 0);
+			set_tsk_need_resched(p);
+			return;
+		}
 	}
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6a3a5b9..0c927cd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -576,6 +576,7 @@ void tick_nohz_idle_exit(void)
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
+	update_cpu_load_nohz();
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	/*
