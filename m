Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2I0GEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:04:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2I0GEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:04:46 -0400
Date: Wed, 26 Sep 2012 23:04:28 -0700
From: tip-bot for Lee Schermerhorn <lee.schermerhorn@hp.com>
Message-ID: <tip-z3mgep4tgrc08o07vl1ahb2m@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        lee.schermerhorn@hp.com, riel@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        lee.schermerhorn@hp.com, riel@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Check for misplaced page
Git-Commit-ID: 4d58c795f691f14ca969b7031a184fe35f7ebeaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:04:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d58c795f691f14ca969b7031a184fe35f7ebeaa
Gitweb:     http://git.kernel.org/tip/4d58c795f691f14ca969b7031a184fe35f7ebeaa
Author:     Lee Schermerhorn <lee.schermerhorn@hp.com>
AuthorDate: Wed, 11 Jan 2012 15:48:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 11:48:34 +0200

mm/mpol: Check for misplaced page

This patch provides a new function to test whether a page resides
on a node that is appropriate for the mempolicy for the vma and
address where the page is supposed to be mapped.  This involves
looking up the node where the page belongs.  So, the function
returns that node so that it may be used to allocated the page
without consulting the policy again.  Because interleaved and
non-interleaved allocations are accounted differently, the function
also returns whether or not the new node came from an interleaved
policy, if the page is misplaced.

A subsequent patch will call this function from the fault path for
stable pages with zero page_mapcount().  Because of this, I don't
want to go ahead and allocate the page, e.g., via alloc_page_vma()
only to have to free it if it has the correct policy.  So, I just
mimic the alloc_page_vma() node computation logic--sort of.

Note:  we could use this function to implement a MPOL_MF_STRICT
behavior when migrating pages to match mbind() mempolicy--e.g.,
to ensure that pages in an interleaved range are reinterleaved
rather than left where they are when they reside on any page in
the interleave nodemask.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
[ Added MPOL_F_LAZY to trigger migrate-on-fault;
  simplified code now that we don't have to bother
  with special crap for interleaved ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-z3mgep4tgrc08o07vl1ahb2m@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    9 +++++
 mm/mempolicy.c            |   79 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 9fe1ab1..17cf9da 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -68,6 +68,7 @@ enum mpol_rebind_step {
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
+#define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 
 #ifdef __KERNEL__
 
@@ -262,6 +263,8 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 	return 1;
 }
 
+extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
+
 extern void lazy_migrate_process(struct mm_struct *mm);
 
 #else /* CONFIG_NUMA */
@@ -389,6 +392,12 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 	return 0;
 }
 
+static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
+				 unsigned long address)
+{
+	return -1; /* no node preference */
+}
+
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0de12e2..9f742b6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1152,6 +1152,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
+	if (flags & MPOL_MF_LAZY)
+		new->flags |= MPOL_F_MOF;
+
 	/*
 	 * If we are using the default policy then operation
 	 * on discontinuous address spaces is okay after all
@@ -2149,6 +2152,82 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 	return pol;
 }
 
+/**
+ * mpol_misplaced - check whether current page node is valid in policy
+ *
+ * @page   - page to be checked
+ * @vma    - vm area where page mapped
+ * @addr   - virtual address where page mapped
+ *
+ * Lookup current policy node id for vma,addr and "compare to" page's
+ * node id.
+ *
+ * Returns:
+ *	-1	- not misplaced, page is in the right node
+ *	node	- node id where the page should be
+ *
+ * Policy determination "mimics" alloc_page_vma().
+ * Called from fault path where we know the vma and faulting address.
+ */
+int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol;
+	struct zone *zone;
+	int curnid = page_to_nid(page);
+	unsigned long pgoff;
+	int polnid = -1;
+	int ret = -1;
+
+	BUG_ON(!vma);
+
+	pol = get_vma_policy(current, vma, addr);
+	if (!(pol->flags & MPOL_F_MOF))
+		goto out;
+
+	switch (pol->mode) {
+	case MPOL_INTERLEAVE:
+		BUG_ON(addr >= vma->vm_end);
+		BUG_ON(addr < vma->vm_start);
+
+		pgoff = vma->vm_pgoff;
+		pgoff += (addr - vma->vm_start) >> PAGE_SHIFT;
+		polnid = offset_il_node(pol, vma, pgoff);
+		break;
+
+	case MPOL_PREFERRED:
+		if (pol->flags & MPOL_F_LOCAL)
+			polnid = numa_node_id();
+		else
+			polnid = pol->v.preferred_node;
+		break;
+
+	case MPOL_BIND:
+		/*
+		 * allows binding to multiple nodes.
+		 * use current page if in policy nodemask,
+		 * else select nearest allowed node, if any.
+		 * If no allowed nodes, use current [!misplaced].
+		 */
+		if (node_isset(curnid, pol->v.nodes))
+			goto out;
+		(void)first_zones_zonelist(
+				node_zonelist(numa_node_id(), GFP_HIGHUSER),
+				gfp_zone(GFP_HIGHUSER),
+				&pol->v.nodes, &zone);
+		polnid = zone->node;
+		break;
+
+	default:
+		BUG();
+	}
+	if (curnid != polnid)
+		ret = polnid;
+out:
+	mpol_cond_put(pol);
+
+	return ret;
+}
+
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
