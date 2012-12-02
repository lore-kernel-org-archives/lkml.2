Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2LBSxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:53:25 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45147 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2LBSog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:44:36 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 18/52] mm/numa: Migrate on reference policy
Date: Sun,  2 Dec 2012 19:43:10 +0100
Message-Id: <1354473824-19229-19-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

This is the simplest possible policy that still does something
of note. When a pte_numa is faulted, it is moved immediately.
Any replacement policy must at least do better than this and in
all likelihood this policy regresses normal workloads.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Alex Shi <lkml.alex@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/mempolicy.h |  1 +
 mm/mempolicy.c                 | 38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 16fb4e6..0d11c3d 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -67,6 +67,7 @@ enum mpol_rebind_step {
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
+#define MPOL_F_MORON	(1 << 4) /* Migrate On pte_numa Reference On Node */
 
 
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 516491f..4c1c8d8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -118,6 +118,26 @@ static struct mempolicy default_policy = {
 	.flags = MPOL_F_LOCAL,
 };
 
+static struct mempolicy preferred_node_policy[MAX_NUMNODES];
+
+static struct mempolicy *get_task_policy(struct task_struct *p)
+{
+	struct mempolicy *pol = p->mempolicy;
+	int node;
+
+	if (!pol) {
+		node = numa_node_id();
+		if (node != -1)
+			pol = &preferred_node_policy[node];
+
+		/* preferred_node_policy is not initialised early in boot */
+		if (!pol->mode)
+			pol = NULL;
+	}
+
+	return pol;
+}
+
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
 	/*
@@ -1598,7 +1618,7 @@ asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = task->mempolicy;
+	struct mempolicy *pol = get_task_policy(task);
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -2021,7 +2041,7 @@ retry_cpuset:
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = current->mempolicy;
+	struct mempolicy *pol = get_task_policy(current);
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
@@ -2295,6 +2315,11 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 	default:
 		BUG();
 	}
+
+	/* Migrate the page towards the node whose CPU is referencing it */
+	if (pol->flags & MPOL_F_MORON)
+		polnid = numa_node_id();
+
 	if (curnid != polnid)
 		ret = polnid;
 out:
@@ -2483,6 +2508,15 @@ void __init numa_policy_init(void)
 				     sizeof(struct sp_node),
 				     0, SLAB_PANIC, NULL);
 
+	for_each_node(nid) {
+		preferred_node_policy[nid] = (struct mempolicy) {
+			.refcnt = ATOMIC_INIT(1),
+			.mode = MPOL_PREFERRED,
+			.flags = MPOL_F_MOF | MPOL_F_MORON,
+			.v = { .preferred_node = nid, },
+		};
+	}
+
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
 	 * enabled across suitably sized nodes (default is >= 16MB), or
-- 
1.7.11.7

