Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2I1IDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:03:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2I1IDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:03:34 -0400
Date: Fri, 28 Sep 2012 01:03:16 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-zeubc7ldf9w2d416e9fxnf0j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Implement per task memory placement for 'big' processes
Git-Commit-ID: fa74ef9e42df04b671b77baf516012987da2034e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 01:03:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa74ef9e42df04b671b77baf516012987da2034e
Gitweb:     http://git.kernel.org/tip/fa74ef9e42df04b671b77baf516012987da2034e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Jul 2012 22:06:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 19:17:09 +0200

sched/numa: Implement per task memory placement for 'big' processes

Implement a per-task memory placement scheme for 'big' tasks (as per
the last patch). It relies on a regular PROT_NONE 'migration' fault to
scan the memory space of the procress and uses a two stage migration
scheme to reduce the invluence of unlikely usage relations.

It relies on the assumption that the compute part is tied to a
paticular task and builds a task<->page relation set to model the
compute<->data relation.

Probability says that the task faulting on a page after we protect it,
is most likely to be the task that uses that page most.

To decrease the likelyhood of acting on a false relation, we only
migrate a page when two consecutive samples are from the same task.

I'm still not entirely convinced this scheme is sound, esp. for things
like virtualization and n:m threading solutions in general the
compute<->task relation is fundamentally untrue.

NOTES:

 - we don't actually sample the task, but the task's home-node as a
   migration target, so we're effectively building home-node<->page
   relations not task<->page relations.

 - we migrate to the task's home-node, not the node the task is
   currently running on, since the home-node is the long term target
   for the task to run on, irrespective of whatever node it might
   temporarily run on.

Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-zeubc7ldf9w2d416e9fxnf0j@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    6 +++-
 include/linux/mm_types.h  |   15 +++++++++++++
 kernel/sched/fair.c       |   51 ++++++++++++++++++++++++++++++++++----------
 kernel/sched/features.h   |    1 +
 mm/huge_memory.c          |    3 +-
 mm/memory.c               |    2 +-
 mm/mempolicy.c            |   39 ++++++++++++++++++++++++++++++++-
 7 files changed, 99 insertions(+), 18 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 17cf9da..7f303d1 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -69,6 +69,7 @@ enum mpol_rebind_step {
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
+#define MPOL_F_HOME	(1 << 4) /* this is the home-node policy */
 
 #ifdef __KERNEL__
 
@@ -263,7 +264,8 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 	return 1;
 }
 
-extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
+extern int mpol_misplaced(struct page *, struct vm_area_struct *,
+			  unsigned long, int);
 
 extern void lazy_migrate_process(struct mm_struct *mm);
 
@@ -393,7 +395,7 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 }
 
 static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
-				 unsigned long address)
+				 unsigned long address, int multi)
 {
 	return -1; /* no node preference */
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 930c006..f306cbb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -176,6 +176,12 @@ struct page {
 	 */
 	void *shadow;
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	/*
+	 * XXX fold this into flags for 64bit.. see next patch.
+	 */
+	int nid_last;
+#endif
 }
 /*
  * The struct page can be forced to be double word aligned so that atomic ops
@@ -411,6 +417,15 @@ struct mm_struct {
 	struct uprobes_state uprobes_state;
 };
 
+static inline bool mm_numa_big(struct mm_struct *mm)
+{
+#ifdef CONFIG_SCHED_NUMA
+	return mm->numa_big;
+#else
+	return false;
+#endif
+}
+
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 #ifdef CONFIG_CPUMASK_OFFSTACK
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7ea50ac..76a0920 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -786,6 +786,16 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * Tasks start out with their home-node unset (-1) this effectively means
  * they act !NUMA until we've established the task is busy enough to bother
  * with placement.
+ *
+ * Once we start doing NUMA placement there's two modes, 'small' process-wide
+ * and 'big' per-task. For the small mode we have a process-wide home node
+ * and lazily mirgrate all memory only when this home-node changes.
+ *
+ * For big mode we keep a home-node per task and use periodic fault scans
+ * to try and estalish a task<->page relation. This assumes the task<->page
+ * relation is a compute<->data relation, this is false for things like virt.
+ * and n:m threading solutions but its the best we can do given the
+ * information we have.
  */
 
 static unsigned long task_h_load(struct task_struct *p);
@@ -797,6 +807,7 @@ static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
 	rq->offnode_weight += p->numa_contrib;
 	rq->offnode_running++;
 }
+
 static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 {
 	rq->offnode_weight -= p->numa_contrib;
@@ -822,6 +833,9 @@ static bool task_numa_big(struct task_struct *p)
 	u64 runtime = 0;
 	int weight = 0;
 
+	if (sched_feat(NUMA_FORCE_BIG))
+		return true;
+
 	rcu_read_lock();
 	t = p;
 	do {
@@ -875,6 +889,7 @@ void task_numa_work(struct callback_head *work)
 {
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
+	bool need_migration;
 	int big;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
@@ -890,8 +905,19 @@ void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
+	big = p->mm->numa_big;
+	need_migration = need_numa_migration(p);
+
 	/*
-	 * Enforce maximal migration frequency..
+	 * Change per-task state before the process wide freq. throttle,
+	 * otherwise it might be a long while ere this task wins the
+	 * lottery and gets its home-node set.
+	 */
+	if (big && need_migration)
+		sched_setnode(p, p->node_curr);
+
+	/*
+	 * Enforce maximal scan/migration frequency..
 	 */
 	migrate = p->mm->numa_next_scan;
 	if (time_before(now, migrate))
@@ -901,19 +927,17 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&p->mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-	/*
-	 * If this task is too big, we bail on NUMA placement for the process.
-	 */
 	big = p->mm->numa_big = task_numa_big(p);
-	if (big || need_numa_migration(p)) {
-		int node = p->node_curr;
 
+	if (need_migration) {
 		if (big)
-			node = -1;
-		sched_setnode_process(p, node);
-		if (node != -1)
-			lazy_migrate_process(p->mm);
+			sched_setnode(p, p->node_curr);
+		else
+			sched_setnode_process(p, p->node_curr);
 	}
+
+	if (big || need_migration)
+		lazy_migrate_process(p->mm);
 }
 
 /*
@@ -928,9 +952,8 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
-	 * We also bail on placement if we're too big.
 	 */
-	if (!curr->mm || curr->mm->numa_big)
+	if (!curr->mm)
 		return;
 
 	/*
@@ -957,6 +980,10 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 		curr->node_last = curr->node_curr;
 		curr->node_curr = numa_node_id();
 
+		/*
+		 * We need to do expensive work to either migrate or
+		 * drive priodic state update or scanning for 'big' processes.
+		 */
 		if (need_numa_migration(curr) ||
 		    !time_before(jiffies, curr->mm->numa_next_scan)) {
 			/*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index fa6a0ac..845b838 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -64,6 +64,7 @@ SCHED_FEAT(LB_MIN, false)
 
 #ifdef CONFIG_SCHED_NUMA
 SCHED_FEAT(NUMA,           true)
+SCHED_FEAT(NUMA_FORCE_BIG, false)
 SCHED_FEAT(NUMA_HOT,       true)
 SCHED_FEAT(NUMA_BIAS,      true)
 SCHED_FEAT(NUMA_PULL,      true)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a147d29..45b11f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -791,7 +791,7 @@ void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * XXX should we serialize against split_huge_page ?
 	 */
 
-	node = mpol_misplaced(page, vma, haddr);
+	node = mpol_misplaced(page, vma, haddr, mm->numa_big);
 	if (node == -1)
 		goto do_fixup;
 
@@ -1377,6 +1377,7 @@ static void __split_huge_page_refcount(struct page *page)
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
+		page_tail->nid_last = page->nid_last;
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff --git a/mm/memory.c b/mm/memory.c
index 965eeef..7dbdd85 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3448,7 +3448,7 @@ static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * For NUMA systems we use the special PROT_NONE maps to drive
 	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
-	node = mpol_misplaced(page, vma, address);
+	node = mpol_misplaced(page, vma, address, mm_numa_big(mm));
 	if (node != -1)
 		migrate_misplaced_page(mm, page, node);
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6c6490b..861190f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2174,6 +2174,7 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
  * @page   - page to be checked
  * @vma    - vm area where page mapped
  * @addr   - virtual address where page mapped
+ * @multi  - use multi-stage node binding
  *
  * Lookup current policy node id for vma,addr and "compare to" page's
  * node id.
@@ -2185,7 +2186,8 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
  * Policy determination "mimics" alloc_page_vma().
  * Called from fault path where we know the vma and faulting address.
  */
-int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long addr)
+int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
+		   unsigned long addr, int multi)
 {
 	struct mempolicy *pol;
 	struct zone *zone;
@@ -2236,6 +2238,39 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 	default:
 		BUG();
 	}
+
+	/*
+	 * Multi-stage node selection is used in conjunction with a periodic
+	 * migration fault to build a temporal task<->page relation. By
+	 * using a two-stage filter we remove short/unlikely relations.
+	 *
+	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can
+	 * equate a task's usage of a particular page (n_p) per total usage
+	 * of this page (n_t) (in a given time-span) to a probability.
+	 *
+	 * Our periodic faults will then sample this probability and getting
+	 * the same result twice in a row, given these samples are fully
+	 * independent, is then given by P(n)^2, provided our sample period
+	 * is sufficiently short compared to the usage pattern.
+	 *
+	 * This quadric squishes small probabilities, making it less likely
+	 * we act on an unlikely task<->page relation.
+	 *
+	 * NOTE: effectively we're using task-home-node<->page-node relations
+	 * since those are the only thing we can affect.
+	 *
+	 * NOTE: we're using task-home-node as opposed to the current node
+	 * the task might be running on, since the task-home-node is the
+	 * long-term node of this task, further reducing noise. Also see
+	 * task_tick_numa().
+	 */
+	if (multi && (pol->flags & MPOL_F_HOME)) {
+		if (page->nid_last != polnid) {
+			page->nid_last = polnid;
+			goto out;
+		}
+	}
+
 	if (curnid != polnid)
 		ret = polnid;
 out:
@@ -2427,7 +2462,7 @@ void __init numa_policy_init(void)
 		preferred_node_policy[nid] = (struct mempolicy) {
 			.refcnt = ATOMIC_INIT(1),
 			.mode = MPOL_PREFERRED,
-			.flags = MPOL_F_MOF,
+			.flags = MPOL_F_MOF | MPOL_F_HOME,
 			.v = { .preferred_node = nid, },
 		};
 	}
