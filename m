Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1ATUVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:21:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab1ATUVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:21:41 -0500
Date: Thu, 20 Jan 2011 21:21:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110120202127.GA2637@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Bharata B Rao (2):
      sched: Reinstate group names in /proc/sched_debug
      sched: Display autogroup names in /proc/sched_debug

Mike Galbraith (2):
      sched, autogroup: Fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure
      sched: Fix signed unsigned comparison in check_preempt_tick()

Paul Turner (1):
      sched: Update effective_load() to use global share weights

Peter Zijlstra (1):
      sched, cgroup: Use exit hook to avoid use-after-free crash

Yong Zhang (1):
      sched: Replace rq->bkl_count with rq->rq_sched_info.bkl_count


 kernel/sched.c           |   26 +++++++++++++++++++++-----
 kernel/sched_autogroup.c |   32 ++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h |    4 ++++
 kernel/sched_debug.c     |   42 +++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_fair.c      |   35 +++++++++++++++++++----------------
 5 files changed, 117 insertions(+), 22 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a0eb094..fa5272a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -553,9 +553,6 @@ struct rq {
 	/* try_to_wake_up() stats */
 	unsigned int ttwu_count;
 	unsigned int ttwu_local;
-
-	/* BKL stats */
-	unsigned int bkl_count;
 #endif
 };
 
@@ -609,6 +606,9 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
+	if (p->flags & PF_EXITING)
+		return &root_task_group;
+
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
@@ -3887,7 +3887,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	schedstat_inc(this_rq(), sched_count);
 #ifdef CONFIG_SCHEDSTATS
 	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), bkl_count);
+		schedstat_inc(this_rq(), rq_sched_info.bkl_count);
 		schedstat_inc(prev, sched_info.bkl_count);
 	}
 #endif
@@ -4871,7 +4871,8 @@ recheck:
 		 * assigned.
 		 */
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
+				!task_group_is_autogroup(task_group(p))) {
 			__task_rq_unlock(rq);
 			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 			return -EPERM;
@@ -8882,6 +8883,20 @@ cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	}
 }
 
+static void
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+{
+	/*
+	 * cgroup_exit() is called in the copy_process() failure path.
+	 * Ignore this case since the task hasn't ran yet, this avoids
+	 * trying to poke a half freed task state from generic code.
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
+	sched_move_task(task);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
@@ -8954,6 +8969,7 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.destroy	= cpu_cgroup_destroy,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+	.exit		= cpu_cgroup_exit,
 	.populate	= cpu_cgroup_populate,
 	.subsys_id	= cpu_cgroup_subsys_id,
 	.early_init	= 1,
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 32a723b..9fb6562 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -27,6 +27,11 @@ static inline void autogroup_destroy(struct kref *kref)
 {
 	struct autogroup *ag = container_of(kref, struct autogroup, kref);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* We've redirected RT tasks to the root task group... */
+	ag->tg->rt_se = NULL;
+	ag->tg->rt_rq = NULL;
+#endif
 	sched_destroy_group(ag->tg);
 }
 
@@ -55,6 +60,10 @@ static inline struct autogroup *autogroup_task_get(struct task_struct *p)
 	return ag;
 }
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static void free_rt_sched_group(struct task_group *tg);
+#endif
+
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -72,6 +81,19 @@ static inline struct autogroup *autogroup_create(void)
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
 	ag->tg = tg;
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Autogroup RT tasks are redirected to the root task group
+	 * so we don't have to move tasks around upon policy change,
+	 * or flail around trying to allocate bandwidth on the fly.
+	 * A bandwidth exception in __sched_setscheduler() allows
+	 * the policy change to proceed.  Thereafter, task_group()
+	 * returns &root_task_group, so zero bandwidth is required.
+	 */
+	free_rt_sched_group(tg);
+	tg->rt_se = root_task_group.rt_se;
+	tg->rt_rq = root_task_group.rt_rq;
+#endif
 	tg->autogroup = ag;
 
 	return ag;
@@ -106,6 +128,11 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 	return true;
 }
 
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return tg != &root_task_group && tg->autogroup;
+}
+
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
 {
@@ -231,6 +258,11 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (!enabled || !tg->autogroup)
+		return 0;
+
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
 }
 #endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 5358e24..7b859ff 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -15,6 +15,10 @@ autogroup_task_group(struct task_struct *p, struct task_group *tg);
 
 static inline void autogroup_init(struct task_struct *init_task) {  }
 static inline void autogroup_free(struct task_group *tg) { }
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return 0;
+}
 
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1dfae3d..eb6cb8e 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -16,6 +16,8 @@
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
 
+static DEFINE_SPINLOCK(sched_debug_lock);
+
 /*
  * This allows printing both to /proc/sched_debug and
  * to the console
@@ -86,6 +88,26 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 }
 #endif
 
+#ifdef CONFIG_CGROUP_SCHED
+static char group_path[PATH_MAX];
+
+static char *task_group_path(struct task_group *tg)
+{
+	if (autogroup_path(tg, group_path, PATH_MAX))
+		return group_path;
+
+	/*
+	 * May be NULL if the underlying cgroup isn't fully-created yet
+	 */
+	if (!tg->css.cgroup) {
+		group_path[0] = '\0';
+		return group_path;
+	}
+	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
+	return group_path;
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -108,6 +130,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_CGROUP_SCHED
+	SEQ_printf(m, " %s", task_group_path(task_group(p)));
+#endif
 
 	SEQ_printf(m, "\n");
 }
@@ -144,7 +169,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	struct sched_entity *last;
 	unsigned long flags;
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, task_group_path(cfs_rq->tg));
+#else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
+#endif
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
@@ -191,7 +220,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
+#ifdef CONFIG_RT_GROUP_SCHED
+	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, task_group_path(rt_rq->tg));
+#else
 	SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
+#endif
 
 #define P(x) \
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
@@ -212,6 +245,7 @@ extern __read_mostly int sched_clock_running;
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
 
 #ifdef CONFIG_X86
 	{
@@ -262,14 +296,20 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(ttwu_count);
 	P(ttwu_local);
 
-	P(bkl_count);
+	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
+				rq->rq_sched_info.bkl_count);
 
 #undef P
+#undef P64
 #endif
+	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
+	rcu_read_lock();
 	print_rq(m, rq, cpu);
+	rcu_read_unlock();
+	spin_unlock_irqrestore(&sched_debug_lock, flags);
 }
 
 static const char *sched_tunable_scaling_names[] = {
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..77e9166 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1062,6 +1062,9 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
+		if (delta < 0)
+			return;
+
 		if (delta > ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
@@ -1362,27 +1365,27 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		return wl;
 
 	for_each_sched_entity(se) {
-		long S, rw, s, a, b;
+		long lw, w;
 
-		S = se->my_q->tg->shares;
-		s = se->load.weight;
-		rw = se->my_q->load.weight;
+		tg = se->my_q->tg;
+		w = se->my_q->load.weight;
 
-		a = S*(rw + wl);
-		b = S*rw + s*wg;
+		/* use this cpu's instantaneous contribution */
+		lw = atomic_read(&tg->load_weight);
+		lw -= se->my_q->load_contribution;
+		lw += w + wg;
 
-		wl = s*(a-b);
+		wl += w;
 
-		if (likely(b))
-			wl /= b;
+		if (lw > 0 && wl < lw)
+			wl = (wl * tg->shares) / lw;
+		else
+			wl = tg->shares;
 
-		/*
-		 * Assume the group is already running and will
-		 * thus already be accounted for in the weight.
-		 *
-		 * That is, moving shares between CPUs, does not
-		 * alter the group weight.
-		 */
+		/* zero point is MIN_SHARES */
+		if (wl < MIN_SHARES)
+			wl = MIN_SHARES;
+		wl -= se->load.weight;
 		wg = 0;
 	}
 
