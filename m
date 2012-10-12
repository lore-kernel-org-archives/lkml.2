Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2JLL35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:29:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2JLL34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:29:56 -0400
Date: Fri, 12 Oct 2012 04:29:40 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-gzh3q3dzud3lvu6zmf7do0wu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Add fault driven placement policy
Git-Commit-ID: 8bf1f58fcfbd1b60bb9e687244f7804d2c503537
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:29:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bf1f58fcfbd1b60bb9e687244f7804d2c503537
Gitweb:     http://git.kernel.org/tip/8bf1f58fcfbd1b60bb9e687244f7804d2c503537
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 9 Oct 2012 13:46:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:18 +0200

sched/numa: Add fault driven placement policy

As per the problem/design document Documentation/scheduler/numa-problem.txt
implement 3ac & 4.

A pure 3a was found too unstable, I did briefly try 3bc
but found no significant improvement. We could add a NUMA_FREQ knob
if people want to play further -- but for now implement the simplest
form.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-gzh3q3dzud3lvu6zmf7do0wu@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h |    1 +
 include/linux/sched.h    |   30 ++++++++++++++++++++++++++-
 kernel/sched/core.c      |    7 +++++-
 kernel/sched/fair.c      |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h     |   10 ++++++++-
 mm/memory.c              |   12 ++++++++--
 mm/mempolicy.c           |   17 +++++++--------
 7 files changed, 110 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d6dc76c..cd38809 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -411,6 +411,7 @@ struct mm_struct {
 #endif
 #ifdef CONFIG_SCHED_NUMA
 	unsigned long numa_next_scan;
+	int numa_scan_seq;
 #endif
 	struct uprobes_state uprobes_state;
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0a2c73..d6818d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1523,8 +1523,10 @@ struct task_struct {
 #endif
 #ifdef CONFIG_SCHED_NUMA
 	int node;			/* task home node   */
+	int numa_scan_seq;
 	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
+	unsigned long *numa_faults;
 #endif /* CONFIG_SCHED_NUMA */
 
 	struct rcu_head rcu;
@@ -1598,15 +1600,38 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+#ifdef CONFIG_SCHED_NUMA
 static inline int tsk_home_node(struct task_struct *p)
 {
-#ifdef CONFIG_SCHED_NUMA
 	return p->node;
+}
+
+extern void task_numa_placement(void);
+extern void __task_numa_fault(int node);
+static inline void task_numa_fault(int node)
+{
+	struct task_struct *p = current;
+
+	if (likely(p->numa_faults))
+		p->numa_faults[node]++;
+	else
+		__task_numa_fault(node);
+}
 #else
+static inline int tsk_home_node(struct task_struct *p)
+{
 	return -1;
-#endif
 }
 
+static inline void task_numa_placement(void)
+{
+}
+
+static inline void task_numa_fault(int node)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
@@ -2126,6 +2151,7 @@ extern int sched_setscheduler(struct task_struct *, int,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern void sched_setnode(struct task_struct *p, int node);
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5c1be07..b149cad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1535,11 +1535,15 @@ static void __sched_fork(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SCHED_NUMA
-	if (p->mm && atomic_read(&p->mm->mm_users) == 1)
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
 		p->mm->numa_next_scan = jiffies;
+		p->mm->numa_scan_seq = 0;
+	}
 
 	p->node = -1;
 	p->node_stamp = 0ULL;
+	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
+	p->numa_faults = NULL;
 #endif /* CONFIG_SCHED_NUMA */
 }
 
@@ -1782,6 +1786,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		task_numa_free(prev);
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fab4e0e..f8eb98e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -816,6 +816,54 @@ static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 unsigned int sysctl_sched_numa_task_period = 2500;
 
 /*
+ * Got a PROT_NONE fault for a page on @node.
+ */
+void __task_numa_fault(int node)
+{
+	struct task_struct *p = current;
+
+	if (!p->numa_faults) {
+		p->numa_faults = kzalloc(sizeof(unsigned long) * nr_node_ids,
+					 GFP_KERNEL);
+	}
+
+	if (!p->numa_faults)
+		return;
+
+	p->numa_faults[node]++;
+}
+
+void task_numa_placement(void)
+{
+	unsigned long faults, max_faults = 0;
+	struct task_struct *p = current;
+	int node, max_node = -1;
+	int seq = ACCESS_ONCE(p->mm->numa_scan_seq);
+
+	if (p->numa_scan_seq == seq)
+		return;
+
+	p->numa_scan_seq = seq;
+
+	if (unlikely(!p->numa_faults))
+		return;
+
+	for (node = 0; node < nr_node_ids; node++) {
+		faults = p->numa_faults[node];
+
+		if (faults > max_faults) {
+			max_faults = faults;
+			max_node = node;
+		}
+
+		p->numa_faults[node] /= 2;
+	}
+
+	if (max_node != -1 && p->node != max_node)
+		sched_setnode(p, max_node);
+}
+
+/*
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
  */
@@ -849,6 +897,7 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
+	ACCESS_ONCE(mm->numa_scan_seq)++;
 	lazy_migrate_process(mm);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bc5fc3e..3060136 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3,6 +3,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/slab.h>
 
 #include "cpupri.h"
 
@@ -503,7 +504,10 @@ static inline struct list_head *offnode_tasks(struct rq *rq)
 	return &rq->offnode_tasks;
 }
 
-void sched_setnode(struct task_struct *p, int node);
+static inline void task_numa_free(struct task_struct *p)
+{
+	kfree(p->numa_faults);
+}
 #else /* CONFIG_SCHED_NUMA */
 static inline bool offnode_task(struct task_struct *t)
 {
@@ -514,6 +518,10 @@ static inline struct list_head *offnode_tasks(struct rq *rq)
 {
 	return NULL;
 }
+
+static inline void task_numa_free(struct task_struct *p)
+{
+}
 #endif /* CONFIG_SCHED_NUMA */
 
 #ifdef CONFIG_SMP
diff --git a/mm/memory.c b/mm/memory.c
index 1ee7d7c..9ada7ed 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3443,18 +3443,24 @@ static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
 }
 
 #ifdef CONFIG_NUMA
+
+
 static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
 			      unsigned long address, struct page *page)
 {
-	int node;
+	int node, page_nid = page_to_nid(page);
+
+	task_numa_placement();
 
 	/*
 	 * For NUMA systems we use the special PROT_NONE maps to drive
 	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
 	node = mpol_misplaced(page, vma, address);
-	if (node != -1)
-		migrate_misplaced_page(mm, page, node);
+	if (node != -1 && !migrate_misplaced_page(mm, page, node))
+		page_nid = node;
+
+	task_numa_fault(page_nid);
 }
 #else
 static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9034202..47793ce 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2255,17 +2255,16 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
 	 *
 	 * This quadric squishes small probabilities, making it less likely
 	 * we act on an unlikely task<->page relation.
-	 *
-	 * NOTE: effectively we're using task-home-node<->page-node relations
-	 * since those are the only thing we can affect.
-	 *
-	 * NOTE: we're using task-home-node as opposed to the current node
-	 * the task might be running on, since the task-home-node is the
-	 * long-term node of this task, further reducing noise. Also see
-	 * task_tick_numa().
 	 */
 	if (pol->flags & MPOL_F_HOME) {
-		int last_nid = page_xchg_last_nid(page, polnid);
+		int last_nid;
+
+		/*
+		 * Migrate towards the current node, depends on
+		 * task_numa_placement() details.
+		 */
+		polnid = numa_node_id();
+		last_nid = page_xchg_last_nid(page, polnid);
 		if (last_nid != polnid)
 			goto out;
 	}
