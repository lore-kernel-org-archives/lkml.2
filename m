Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683Ab2ERK0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:26:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2ERK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:26:28 -0400
Date: Fri, 18 May 2012 03:25:36 -0700
From: tip-bot for Lee Schermerhorn <lee.schermerhorn@hp.com>
Message-ID: <tip-31iqaa5htj9hzgsakmtpu3vw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, bharata.rao@gmail.com, aarcange@redhat.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org, aarcange@redhat.com,
        danms@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Check for misplaced page
Git-Commit-ID: 147c5c460202df93a9df981cf9f3a84bcb33f998
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:25:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  147c5c460202df93a9df981cf9f3a84bcb33f998
Gitweb:     http://git.kernel.org/tip/147c5c460202df93a9df981cf9f3a84bcb33f998
Author:     Lee Schermerhorn <lee.schermerhorn@hp.com>
AuthorDate: Wed, 11 Jan 2012 15:48:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:17 +0200

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
[ Added MPOL_F_LAZY to trigger migrate-on-fault;
  simplified code now that we don't have to bother
  with special crap for interleaved ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-31iqaa5htj9hzgsakmtpu3vw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    3 ++
 mm/mempolicy.c            |   79 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index b484ae2..f005c00 100644
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
 #else
 
 struct mempolicy {};
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e972ba0..651b7a3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1071,6 +1071,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
+	if (flags & MPOL_MF_LAZY)
+		new->flags |= MPOL_F_MOF;
+
 	/*
 	 * If we are using the default policy then operation
 	 * on discontinuous address spaces is okay after all
@@ -2047,6 +2050,82 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
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
+ * 	-1	- not misplaced, page is in the right node
+ * 	node	- node id where the page should be
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
