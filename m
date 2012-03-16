Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422938Ab2CPO5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:57:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422829Ab2CPOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:53:24 -0400
Message-Id: <20120316144240.829453337@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:40:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 11/26] mm, mpol: Lazy migrate a process/vma
References: <20120316144028.036474157@chello.nl>
Content-Disposition: inline; filename=numa-foo-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide simple functions to lazy migrate a process (or part thereof).
These will be used to implement memory migration for NUMA process
migration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mempolicy.h |    3 +++
 mm/mempolicy.c            |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -250,6 +250,9 @@ extern int vma_migratable(struct vm_area
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 
+extern void lazy_migrate_vma(struct vm_area_struct *vma, int node);
+extern void lazy_migrate_process(struct mm_struct *mm, int node);
+
 #else
 
 struct mempolicy {};
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1173,6 +1173,46 @@ static long do_mbind(unsigned long start
 	return err;
 }
 
+void lazy_migrate_vma(struct vm_area_struct *vma, int node)
+{
+	nodemask_t nmask = nodemask_of_node(node);
+	LIST_HEAD(pagelist);
+
+	struct mempol_walk_data data = {
+		.nodes = &nmask,
+		.flags = MPOL_MF_MOVE | MPOL_MF_INVERT, /* move all pages not in set */
+		.private = &pagelist,
+		.vma = vma,
+	};
+
+	struct mm_walk walk = {
+		.pte_entry = check_pte_entry,
+		.mm = vma->vm_mm,
+		.private = &data,
+	};
+
+	if (vma->vm_file)
+		return;
+
+	if (!vma_migratable(vma))
+		return;
+
+	if (!walk_page_range(vma->vm_start, vma->vm_end, &walk))
+		migrate_pages_unmap_only(&pagelist);
+
+	putback_lru_pages(&pagelist);
+}
+
+void lazy_migrate_process(struct mm_struct *mm, int node)
+{
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		lazy_migrate_vma(vma, node);
+	up_read(&mm->mmap_sem);
+}
+
 /*
  * User space interface with variable sized bitmaps for nodelists.
  */


