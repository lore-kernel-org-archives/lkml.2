Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0FHMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:04:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47494 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0FHMEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:04:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 10/10] oom: select task from tasklist for mempolicy ooms
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608210254.7698.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 21:04:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

The oom killer presently kills current whenever there is no more memory
free or reclaimable on its mempolicy's nodes.  There is no guarantee
that current is a memory-hogging task or that killing it will free any
substantial amount of memory, however.

In such situations, it is better to scan the tasklist for nodes that are
allowed to allocate on current's set of nodes and kill the task with the
highest badness() score.  This ensures that the most memory-hogging
task, or the one configured by the user with /proc/pid/oom_adj, is always
selected in such scenarios.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mempolicy.h |   13 +++++-
 mm/mempolicy.c            |   44 ++++++++++++++++++++
 mm/oom_kill.c             |   98 +++++++++++++++++++++++++-------------------
 3 files changed, 112 insertions(+), 43 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 7b9ef6b..9c84270 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -210,6 +210,8 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
+extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+					  const nodemask_t *mask);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -338,7 +340,16 @@ static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 	return node_zonelist(0, gfp_flags);
 }
 
-static inline bool init_nodemask_of_mempolicy(nodemask_t *m) { return false; }
+static inline bool init_nodemask_of_mempolicy(nodemask_t *m)
+{
+	return false;
+}
+
+static inline bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+						 const nodemask_t *mask)
+{
+	return false;
+}
 
 static inline int do_migrate_pages(struct mm_struct *mm,
 			const nodemask_t *from_nodes,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 296eef1..4cf5302 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1712,6 +1712,50 @@ bool init_nodemask_of_mempolicy(nodemask_t *mask)
 }
 #endif
 
+/*
+ * mempolicy_nodemask_intersects
+ *
+ * If tsk's mempolicy is "default" [NULL], return 'true' to indicate default
+ * policy.  Otherwise, check for intersection between mask and the policy
+ * nodemask for 'bind' or 'interleave' policy.  For 'perferred' or 'local'
+ * policy, always return true since it may allocate elsewhere on fallback.
+ *
+ * Takes task_lock(tsk) to prevent freeing of its mempolicy.
+ */
+bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+				   const nodemask_t *mask)
+{
+	struct mempolicy *mempolicy;
+	bool ret = true;
+
+	if (!mask)
+		return ret;
+	task_lock(tsk);
+	mempolicy = tsk->mempolicy;
+	if (!mempolicy)
+		goto out;
+
+	switch (mempolicy->mode) {
+	case MPOL_PREFERRED:
+		/*
+		 * MPOL_PREFERRED and MPOL_F_LOCAL are only preferred nodes to
+		 * allocate from, they may fallback to other nodes when oom.
+		 * Thus, it's possible for tsk to have allocated memory from
+		 * nodes in mask.
+		 */
+		break;
+	case MPOL_BIND:
+	case MPOL_INTERLEAVE:
+		ret = nodes_intersects(mempolicy->v.nodes, *mask);
+		break;
+	default:
+		BUG();
+	}
+ out:
+	task_unlock(tsk);
+	return ret;
+}
+
 /* Allocate a page in interleaved policy.
    Own path because it needs to do special accounting. */
 static struct page *alloc_page_interleave(gfp_t gfp, unsigned order,
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f45ac18..1dff3c3 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
+#include <linux/mempolicy.h>
 #include <linux/security.h>
 
 int sysctl_panic_on_oom;
@@ -36,17 +37,35 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 
 /*
  * Do all threads of the target process overlap our allowed nodes?
+ * @p: task struct of which task to consider
+ * @nodemask: nodemask passed to page allocator for mempolicy ooms
  */
-static int has_intersects_mems_allowed(struct task_struct *p)
+static bool has_intersects_mems_allowed(struct task_struct *p,
+				       const nodemask_t *nodemask)
 {
 	struct task_struct *t = p;
 
 	do {
-		if (cpuset_mems_allowed_intersects(current, t))
-			return 1;
+		if (nodemask) {
+			/*
+			 * If this is a mempolicy constrained oom, tsk's
+			 * cpuset is irrelevant.  Only return true if its
+			 * mempolicy intersects current, otherwise it may be
+			 * needlessly killed.
+			 */
+			if (mempolicy_nodemask_intersects(t, nodemask))
+				return true;
+		} else {
+			/*
+			 * This is not a mempolicy constrained oom, so only
+			 * check the mems of tsk's cpuset.
+			 */
+			if (cpuset_mems_allowed_intersects(current, t))
+				return true;
+		}
 	} while_each_thread(p, t);
 
-	return 0;
+	return false;
 }
 
 static struct task_struct *find_lock_task_mm(struct task_struct *p)
@@ -239,7 +258,8 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 }
 #endif
 
-static int oom_unkillable(struct task_struct *p, struct mem_cgroup *mem)
+static int oom_unkillable(struct task_struct *p, struct mem_cgroup *mem,
+			  nodemask_t *nodemask)
 {
 	/* skip the init task and kthreads */
 	if (is_global_init(p) || (p->flags & PF_KTHREAD))
@@ -252,7 +272,7 @@ static int oom_unkillable(struct task_struct *p, struct mem_cgroup *mem)
 		return 1;
 
 	/* If p's nodes don't overlap ours, it may not help to kill p. */
-	if (!has_intersects_mems_allowed(p))
+	if (!has_intersects_mems_allowed(p, nodemask))
 		return 1;
 
 	return 0;
@@ -265,7 +285,8 @@ static int oom_unkillable(struct task_struct *p, struct mem_cgroup *mem)
  * (not docbooked, we don't want this one cluttering up the manual)
  */
 static struct task_struct *select_bad_process(unsigned long *ppoints,
-						struct mem_cgroup *mem)
+					      struct mem_cgroup *mem,
+					      nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *chosen = NULL;
@@ -276,7 +297,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 	for_each_process(p) {
 		unsigned long points;
 
-		if (oom_unkillable(p, mem))
+		if (oom_unkillable(p, mem, nodemask))
 			continue;
 
 		/*
@@ -314,7 +335,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
  *
  * Call with tasklist_lock read-locked.
  */
-static void dump_tasks(const struct mem_cgroup *mem)
+static void dump_tasks(const struct mem_cgroup *mem, nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *task;
@@ -332,7 +353,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
-		if (!has_intersects_mems_allowed(p))
+		if (!has_intersects_mems_allowed(p, nodemask))
 			continue;
 
 		task = find_lock_task_mm(p);
@@ -353,7 +374,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
-							struct mem_cgroup *mem)
+			struct mem_cgroup *mem, nodemask_t *nodemask)
 {
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
 		"oom_adj=%d\n",
@@ -365,7 +386,7 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
 	if (sysctl_oom_dump_tasks)
-		dump_tasks(mem);
+		dump_tasks(mem, nodemask);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -404,7 +425,7 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem)
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			    unsigned long points, struct mem_cgroup *mem,
-			    const char *message)
+			    nodemask_t *nodemask, const char *message)
 {
 	struct task_struct *c;
 	struct task_struct *t = p;
@@ -413,7 +434,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	struct timespec uptime;
 
 	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, mem);
+		dump_header(p, gfp_mask, order, mem, nodemask);
 
 	pr_err("%s: Kill process %d (%s) with score %lu or sacrifice child\n",
 	       message, task_pid_nr(p), p->comm, points);
@@ -426,7 +447,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (c->mm == p->mm)
 				continue;
-			if (oom_unkillable(c, mem))
+			if (oom_unkillable(c, mem, nodemask))
 				continue;
 
 			/* oom_badness() returns 0 if the thread is unkillable */
@@ -451,11 +472,11 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 		panic("out of memory(memcg). panic_on_oom is selected.\n");
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, mem);
+	p = select_bad_process(&points, mem, NULL);
 	if (!p || PTR_ERR(p) == -1UL)
 		goto out;
 
-	if (oom_kill_process(p, gfp_mask, 0, points, mem,
+	if (oom_kill_process(p, gfp_mask, 0, points, mem, NULL,
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
@@ -567,33 +588,33 @@ static void clear_system_oom(void)
 /*
  * Must be called with tasklist_lock held for read.
  */
-static void __out_of_memory(gfp_t gfp_mask, int order)
+static void __out_of_memory(gfp_t gfp_mask, int order, nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	unsigned long points;
 
 	if (sysctl_oom_kill_allocating_task)
-		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"Out of memory (oom_kill_allocating_task)"))
+		if (!oom_kill_process(current, gfp_mask, order, 0, NULL, nodemask,
+				      "Out of memory (oom_kill_allocating_task)"))
 			return;
 retry:
 	/*
 	 * Rambo mode: Shoot down a process and hope it solves whatever
 	 * issues we may have.
 	 */
-	p = select_bad_process(&points, NULL);
+	p = select_bad_process(&points, NULL, nodemask);
 
 	if (PTR_ERR(p) == -1UL)
 		return;
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		dump_header(NULL, gfp_mask, order, NULL);
+		dump_header(NULL, gfp_mask, order, NULL, nodemask);
 		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 
-	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+	if (oom_kill_process(p, gfp_mask, order, points, NULL, nodemask,
 			     "Out of memory"))
 		goto retry;
 }
@@ -603,6 +624,7 @@ retry:
  * @zonelist: zonelist pointer
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
+ * @nodemask: nodemask passed to page allocator
  *
  * If we run out of memory, we have the choice between either
  * killing a random task (bad), letting the system crash (worse)
@@ -622,7 +644,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 
 	if (sysctl_panic_on_oom == 2) {
 		read_lock(&tasklist_lock);
-		dump_header(NULL, gfp_mask, order, NULL);
+		dump_header(NULL, gfp_mask, order, NULL, nodemask);
 		read_unlock(&tasklist_lock);
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 	}
@@ -633,26 +655,17 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	 */
 	if (zonelist)
 		constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
-	read_lock(&tasklist_lock);
-
-	switch (constraint) {
-	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"No available memory (MPOL_BIND)");
-		break;
-
-	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom) {
-			dump_header(NULL, gfp_mask, order, NULL);
-			read_unlock(&tasklist_lock);
-			panic("out of memory. panic_on_oom is selected\n");
-		}
-		/* Fall-through */
-	case CONSTRAINT_CPUSET:
-		__out_of_memory(gfp_mask, order);
-		break;
+	if (constraint != CONSTRAINT_MEMORY_POLICY)
+		nodemask = NULL;
+	if ((constraint == CONSTRAINT_NONE) && sysctl_panic_on_oom) {
+		read_lock(&tasklist_lock);
+		dump_header(NULL, gfp_mask, order, NULL, nodemask);
+		read_unlock(&tasklist_lock);
+		panic("out of memory. panic_on_oom is selected\n");
 	}
 
+	read_lock(&tasklist_lock);
+	__out_of_memory(gfp_mask, order, nodemask);
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -672,6 +685,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 void pagefault_out_of_memory(void)
 {
 	if (try_set_system_oom()) {
+		/* unknown gfp_mask and order */
 		out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
 	}
-- 
1.6.5.2



