Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0F1KLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:11:24 -0400
Received: from www.tglx.de ([62.245.132.106]:43257 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0F1KLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:11:23 -0400
Date: Mon, 28 Jun 2010 12:11:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] scheduler fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1006281210300.2530@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	tglx

------------------>
Alex,Shi (1):
      sched: Fix over-scheduling bug

Peter Zijlstra (1):
      sched: Fix PROVE_RCU vs cpu_cgroup

Will Deacon (1):
      sched: Prevent compiler from optimising the sched_avg_update() loop


 include/linux/cgroup.h |   20 +++++--
 kernel/sched.c         |  124 +++++++++++++++++++++++++-----------------------
 2 files changed, 79 insertions(+), 65 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0c62160..e3d00fd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -525,13 +525,21 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 	return cgrp->subsys[subsys_id];
 }
 
-static inline struct cgroup_subsys_state *task_subsys_state(
-	struct task_struct *task, int subsys_id)
+/*
+ * function to get the cgroup_subsys_state which allows for extra
+ * rcu_dereference_check() conditions, such as locks used during the
+ * cgroup_subsys::attach() methods.
+ */
+#define task_subsys_state_check(task, subsys_id, __c)			\
+	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
+			      rcu_read_lock_held() ||			\
+			      lockdep_is_held(&task->alloc_lock) ||	\
+			      cgroup_lock_is_held() || (__c))
+
+static inline struct cgroup_subsys_state *
+task_subsys_state(struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
-				     rcu_read_lock_held() ||
-				     lockdep_is_held(&task->alloc_lock) ||
-				     cgroup_lock_is_held());
+	return task_subsys_state_check(task, subsys_id, false);
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,
diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..a24d6d5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -306,52 +306,6 @@ static int init_task_group_load = INIT_TASK_GROUP_LOAD;
  */
 struct task_group init_task_group;
 
-/* return group to which a task belongs */
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	struct task_group *tg;
-
-#ifdef CONFIG_CGROUP_SCHED
-	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
-				struct task_group, css);
-#else
-	tg = &init_task_group;
-#endif
-	return tg;
-}
-
-/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
-{
-	/*
-	 * Strictly speaking this rcu_read_lock() is not needed since the
-	 * task_group is tied to the cgroup, which in turn can never go away
-	 * as long as there are tasks attached to it.
-	 *
-	 * However since task_group() uses task_subsys_state() which is an
-	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
-	 */
-	rcu_read_lock();
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
-#endif
-	rcu_read_unlock();
-}
-
-#else
-
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	return NULL;
-}
-
 #endif	/* CONFIG_CGROUP_SCHED */
 
 /* CFS-related fields in a runqueue */
@@ -644,6 +598,49 @@ static inline int cpu_of(struct rq *rq)
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+#ifdef CONFIG_CGROUP_SCHED
+
+/*
+ * Return the group to which this tasks belongs.
+ *
+ * We use task_subsys_state_check() and extend the RCU verification
+ * with lockdep_is_held(&task_rq(p)->lock) because cpu_cgroup_attach()
+ * holds that lock for each task it moves into the cgroup. Therefore
+ * by holding that lock, we pin the task to the current cgroup.
+ */
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	struct cgroup_subsys_state *css;
+
+	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
+			lockdep_is_held(&task_rq(p)->lock));
+	return container_of(css, struct task_group, css);
+}
+
+/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
+{
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
+	p->se.parent = task_group(p)->se[cpu];
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
+	p->rt.parent = task_group(p)->rt_se[cpu];
+#endif
+}
+
+#else /* CONFIG_CGROUP_SCHED */
+
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CGROUP_SCHED */
+
 inline void update_rq_clock(struct rq *rq)
 {
 	if (!rq->skip_clock_update)
@@ -1257,6 +1254,12 @@ static void sched_avg_update(struct rq *rq)
 	s64 period = sched_avg_period();
 
 	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		/*
+		 * Inline assembly required to prevent the compiler
+		 * optimising this loop into a divmod call.
+		 * See __iter_div_u64_rem() for another example of this.
+		 */
+		asm("" : "+rm" (rq->age_stamp));
 		rq->age_stamp += period;
 		rq->rt_avg /= 2;
 	}
@@ -1660,9 +1663,6 @@ static void update_shares(struct sched_domain *sd)
 
 static void update_h_load(long cpu)
 {
-	if (root_task_group_empty())
-		return;
-
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
@@ -4465,16 +4465,6 @@ recheck:
 	}
 
 	if (user) {
-#ifdef CONFIG_RT_GROUP_SCHED
-		/*
-		 * Do not allow realtime tasks into groups that have no runtime
-		 * assigned.
-		 */
-		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
-			return -EPERM;
-#endif
-
 		retval = security_task_setscheduler(p, policy, param);
 		if (retval)
 			return retval;
@@ -4490,6 +4480,22 @@ recheck:
 	 * runqueue lock must be held.
 	 */
 	rq = __task_rq_lock(p);
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (user) {
+		/*
+		 * Do not allow realtime tasks into groups that have no runtime
+		 * assigned.
+		 */
+		if (rt_bandwidth_enabled() && rt_policy(policy) &&
+				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+			__task_rq_unlock(rq);
+			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+			return -EPERM;
+		}
+	}
+#endif
+
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
