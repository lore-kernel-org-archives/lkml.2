Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2JLL3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:29:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2JLL26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:28:58 -0400
Date: Fri, 12 Oct 2012 04:28:43 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-enkx0maspx8z7mk8cx1m15jr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Remove small mode
Git-Commit-ID: 962498153e02c320b99694e4a7f3e79d46ed8d20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:28:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  962498153e02c320b99694e4a7f3e79d46ed8d20
Gitweb:     http://git.kernel.org/tip/962498153e02c320b99694e4a7f3e79d46ed8d20
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 9 Oct 2012 13:19:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:18 +0200

sched/numa: Remove small mode

Now that the 'big' mode is more or less working, remove the small
mode. There's still the periodic scan cost I don't like, but Rik's
suggestion of adapting the scan period (growing it for stable tasks)
should take care of most of that (not implemented yet).

For now, start by removing 'small' mode to clear out/simplify things.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-enkx0maspx8z7mk8cx1m15jr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/init_task.h |    3 +-
 include/linux/mempolicy.h |    5 +-
 include/linux/mm_types.h  |   26 --------
 include/linux/sched.h     |    3 -
 kernel/sched/core.c       |   12 +---
 kernel/sched/fair.c       |  142 ++++-----------------------------------------
 kernel/sched/features.h   |    1 -
 mm/huge_memory.c          |    2 +-
 mm/memory.c               |   14 +---
 mm/mempolicy.c            |    4 +-
 10 files changed, 23 insertions(+), 189 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 36aca4e..18906c1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -145,8 +145,7 @@ extern struct task_group root_task_group;
 
 #ifdef CONFIG_SCHED_NUMA
 # define INIT_TASK_NUMA(tsk)						\
-	.node = -1,							\
-	.node_last = -1,
+	.node = -1,
 #else
 # define INIT_TASK_NUMA(tsk)
 #endif
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 7f303d1..67c9734 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -264,8 +264,7 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 	return 1;
 }
 
-extern int mpol_misplaced(struct page *, struct vm_area_struct *,
-			  unsigned long, int);
+extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 
 extern void lazy_migrate_process(struct mm_struct *mm);
 
@@ -395,7 +394,7 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 }
 
 static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
-				 unsigned long address, int multi)
+				 unsigned long address)
 {
 	return -1; /* no node preference */
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ffb3b2d..d6dc76c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -410,37 +410,11 @@ struct mm_struct {
 	struct cpumask cpumask_allocation;
 #endif
 #ifdef CONFIG_SCHED_NUMA
-	unsigned int  numa_big;
 	unsigned long numa_next_scan;
-	unsigned int  numa_migrate_success;
-	unsigned int  numa_migrate_failed;
 #endif
 	struct uprobes_state uprobes_state;
 };
 
-#ifdef CONFIG_SCHED_NUMA
-static __always_inline void mm_inc_numa_migrate(struct mm_struct *mm, bool success)
-{
-	if (success)
-		mm->numa_migrate_success++;
-	else
-		mm->numa_migrate_failed++;
-}
-#else
-static inline void mm_inc_numa_migrate(struct mm_struct *mm, bool success)
-{
-}
-#endif /* CONFNIG_SCHED_NUMA */
-
-static inline bool mm_numa_big(struct mm_struct *mm)
-{
-#ifdef CONFIG_SCHED_NUMA
-	return mm->numa_big;
-#else
-	return false;
-#endif
-}
-
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 #ifdef CONFIG_CPUMASK_OFFSTACK
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0273b83..b0a2c73 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1523,10 +1523,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_SCHED_NUMA
 	int node;			/* task home node   */
-	int node_curr, node_last;	/* home node filter */
 	u64 node_stamp;			/* migration stamp  */
-	u64 numa_runtime_stamp;
-	u64 numa_walltime_stamp;
 	unsigned long numa_contrib;
 #endif /* CONFIG_SCHED_NUMA */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 878e33f..5c1be07 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1535,19 +1535,11 @@ static void __sched_fork(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SCHED_NUMA
-	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
-		p->mm->numa_big = 0;
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1)
 		p->mm->numa_next_scan = jiffies;
-		p->mm->numa_migrate_success = 0;
-		p->mm->numa_migrate_failed = 0;
-	}
 
 	p->node = -1;
-	p->node_curr = -1;
-	p->node_last = -1;
 	p->node_stamp = 0ULL;
-	p->numa_runtime_stamp = 0;
-	p->numa_walltime_stamp = local_clock();
 #endif /* CONFIG_SCHED_NUMA */
 }
 
@@ -6011,7 +6003,7 @@ void sched_setnode(struct task_struct *p, int node)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->node = p->node_curr = p->node_last = node;
+	p->node = node;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 092287e..fab4e0e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -787,15 +787,11 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * they act !NUMA until we've established the task is busy enough to bother
  * with placement.
  *
- * Once we start doing NUMA placement there's two modes, 'small' process-wide
- * and 'big' per-task. For the small mode we have a process-wide home node
- * and lazily mirgrate all memory only when this home-node changes.
- *
- * For big mode we keep a home-node per task and use periodic fault scans
- * to try and estalish a task<->page relation. This assumes the task<->page
- * relation is a compute<->data relation, this is false for things like virt.
- * and n:m threading solutions but its the best we can do given the
- * information we have.
+ * We keep a home-node per task and use periodic fault scans to try and
+ * estalish a task<->page relation. This assumes the task<->page relation is a
+ * compute<->data relation, this is false for things like virt. and n:m
+ * threading solutions but its the best we can do given the information we
+ * have.
  */
 
 static unsigned long task_h_load(struct task_struct *p);
@@ -820,74 +816,6 @@ static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 unsigned int sysctl_sched_numa_task_period = 2500;
 
 /*
- * Determine if a process is 'big'.
- *
- * Currently only looks at CPU-time used, maybe we should also add an RSS
- * heuristic.
- */
-static bool task_numa_big(struct task_struct *p)
-{
-	struct sched_domain *sd;
-	struct task_struct *t;
-	u64 walltime = local_clock();
-	u64 runtime = 0;
-	int weight = 0;
-
-	if (sched_feat(NUMA_FORCE_BIG))
-		return true;
-
-	rcu_read_lock();
-	t = p;
-	do {
-		if (t->sched_class == &fair_sched_class)
-			runtime += t->se.sum_exec_runtime;
-	} while ((t = next_thread(t)) != p);
-
-	sd = rcu_dereference(__raw_get_cpu_var(sd_node));
-	if (sd)
-		weight = sd->span_weight;
-	rcu_read_unlock();
-
-	runtime -= p->numa_runtime_stamp;
-	walltime -= p->numa_walltime_stamp;
-
-	p->numa_runtime_stamp += runtime;
-	p->numa_walltime_stamp += walltime;
-
-	/*
-	 * We're 'big' when we burn more than half a node's worth
-	 * of cputime.
-	 */
-	return runtime > walltime * max(1, weight / 2);
-}
-
-static bool had_many_migrate_failures(struct task_struct *p)
-{
-	/* More than 1/4 of the attempted NUMA page migrations failed. */
-	return p->mm->numa_migrate_failed * 3 > p->mm->numa_migrate_success;
-}
-
-static inline bool need_numa_migration(struct task_struct *p)
-{
-	/*
-	 * We need to change our home-node, its been different for 2 samples.
-	 * See the whole P(n)^2 story in task_tick_numa().
-	 */
-	return p->node_curr == p->node_last && p->node != p->node_curr;
-}
-
-static void sched_setnode_process(struct task_struct *p, int node)
-{
-	struct task_struct *t = p;
-
-	rcu_read_lock();
-	do {
-		sched_setnode(t, node);
-	} while ((t = next_thread(t)) != p);
-	rcu_read_unlock();
-}
-
-/*
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
  */
@@ -895,8 +823,7 @@ void task_numa_work(struct callback_head *work)
 {
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
-	bool need_migration;
-	int big;
+	struct mm_struct *mm = p->mm;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
 
@@ -911,52 +838,22 @@ void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
-	big = p->mm->numa_big;
-	need_migration = need_numa_migration(p);
-
-	/*
-	 * Change per-task state before the process wide freq. throttle,
-	 * otherwise it might be a long while ere this task wins the
-	 * lottery and gets its home-node set.
-	 */
-	if (big && need_migration)
-		sched_setnode(p, p->node_curr);
-
 	/*
 	 * Enforce maximal scan/migration frequency..
 	 */
-	migrate = p->mm->numa_next_scan;
+	migrate = mm->numa_next_scan;
 	if (time_before(now, migrate))
 		return;
 
 	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_task_period);
-	if (cmpxchg(&p->mm->numa_next_scan, migrate, next_scan) != migrate)
+	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-	if (!big) {
-		/* Age the numa migrate statistics. */
-		p->mm->numa_migrate_failed /= 2;
-		p->mm->numa_migrate_success /= 2;
-
-		big = p->mm->numa_big = task_numa_big(p);
-	}
-
-	if (need_migration) {
-		if (big)
-			sched_setnode(p, p->node_curr);
-		else
-			sched_setnode_process(p, p->node_curr);
-	}
-
-	if (big || need_migration || had_many_migrate_failures(p))
-		lazy_migrate_process(p->mm);
+	lazy_migrate_process(mm);
 }
 
 /*
- * Sample task location from hardirq context (tick), this has minimal bias with
- * obvious exceptions of frequency interference and tick avoidance techniques.
- * If this were to become a problem we could move this sampling into the
- * sleep/wakeup path -- but we'd prefer to avoid that for obvious reasons.
+ * Drive the periodic memory faults..
  */
 void task_tick_numa(struct rq *rq, struct task_struct *curr)
 {
@@ -969,15 +866,6 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 		return;
 
 	/*
-	 * Sample our node location every @sysctl_sched_numa_task_period
-	 * runtime ms. We use a two stage selection in order to filter
-	 * unlikely locations.
-	 *
-	 * If P(n) is the probability we're on node 'n', then the probability
-	 * we sample the same node twice is P(n)^2. This quadric squishes small
-	 * values and makes it more likely we end up on nodes where we have
-	 * significant presence.
-	 *
 	 * Using runtime rather than walltime has the dual advantage that
 	 * we (mostly) drive the selection from busy threads and that the
 	 * task needs to have done some actual work before we bother with
@@ -989,15 +877,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	if (now - curr->node_stamp > period) {
 		curr->node_stamp = now;
 
-		curr->node_last = curr->node_curr;
-		curr->node_curr = numa_node_id();
-
-		/*
-		 * We need to do expensive work to either migrate or
-		 * drive priodic state update or scanning for 'big' processes.
-		 */
-		if (need_numa_migration(curr) ||
-		    !time_before(jiffies, curr->mm->numa_next_scan)) {
+		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
 			/*
 			 * We can re-use curr->rcu because we checked curr->mm
 			 * != NULL so release_task()->call_rcu() was not called
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 3293af4..64ead49 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -64,7 +64,6 @@ SCHED_FEAT(LB_MIN, false)
 
 #ifdef CONFIG_SCHED_NUMA
 SCHED_FEAT(NUMA,           true)
-SCHED_FEAT(NUMA_FORCE_BIG, false)
 SCHED_FEAT(NUMA_HOT,       true)
 SCHED_FEAT(NUMA_TTWU_BIAS, false)
 SCHED_FEAT(NUMA_TTWU_TO,   false)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5b9ab25..d14c8b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -790,7 +790,7 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * XXX should we serialize against split_huge_page ?
 	 */
 
-	if (mpol_misplaced(page, vma, haddr, mm->numa_big) == -1)
+	if (mpol_misplaced(page, vma, haddr) == -1)
 		goto do_fixup;
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index ab5c170..1ee7d7c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3446,21 +3446,15 @@ static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
 static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
 			      unsigned long address, struct page *page)
 {
-	int node, ret;
+	int node;
 
 	/*
 	 * For NUMA systems we use the special PROT_NONE maps to drive
 	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
-	node = mpol_misplaced(page, vma, address, mm_numa_big(mm));
-	if (node != -1) {
-		ret = migrate_misplaced_page(mm, page, node);
-		if (!ret)
-			mm_inc_numa_migrate(mm, true);
-		else if (ret == -ENOMEM || ret == -EBUSY)
-			mm_inc_numa_migrate(mm, false);
-	} else
-		mm_inc_numa_migrate(mm, true);
+	node = mpol_misplaced(page, vma, address);
+	if (node != -1)
+		migrate_misplaced_page(mm, page, node);
 }
 #else
 static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3360a8d..9034202 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2187,7 +2187,7 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
  * Called from fault path where we know the vma and faulting address.
  */
 int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
-		   unsigned long addr, int multi)
+		   unsigned long addr)
 {
 	struct mempolicy *pol;
 	struct zone *zone;
@@ -2264,7 +2264,7 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
 	 * long-term node of this task, further reducing noise. Also see
 	 * task_tick_numa().
 	 */
-	if (multi && (pol->flags & MPOL_F_HOME)) {
+	if (pol->flags & MPOL_F_HOME) {
 		int last_nid = page_xchg_last_nid(page, polnid);
 		if (last_nid != polnid)
 			goto out;
