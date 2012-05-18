Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967986Ab2ERKeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:34:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab2ERKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:34:04 -0400
Date: Fri, 18 May 2012 03:33:08 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-pdhg3wh71m4eu8xerantpvln@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Lazy migrate a process/vma
Git-Commit-ID: e9941dae870861da410835560b603d17c43dabee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:33:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9941dae870861da410835560b603d17c43dabee
Gitweb:     http://git.kernel.org/tip/e9941dae870861da410835560b603d17c43dabee
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 17:06:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:21 +0200

mm/mpol: Lazy migrate a process/vma

Provide simple functions to lazy migrate a process (or part thereof).
These will be used to implement memory migration for NUMA process
migration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-pdhg3wh71m4eu8xerantpvln@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    3 ++
 mm/mempolicy.c            |   84 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 578fcd0..af2983b 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -262,6 +262,9 @@ extern int vma_migratable(struct vm_area_struct *);
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 
+extern void lazy_migrate_vma(struct vm_area_struct *vma, int node);
+extern void lazy_migrate_process(struct mm_struct *mm, int node);
+
 #else
 
 struct mempolicy {};
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 57fbc4c..df29149 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1193,6 +1193,90 @@ static long do_mbind(unsigned long start, unsigned long len,
 	return err;
 }
 
+static nodemask_t mpol_node_mask(struct mempolicy *pol, int node)
+{
+	if (pol->mode == MPOL_PREFERRED) {
+		if (pol->flags & MPOL_F_LOCAL)
+			return nodemask_of_node(node);
+
+		return nodemask_of_node(pol->v.preferred_node);
+	}
+
+	return pol->v.nodes;
+}
+
+void lazy_migrate_vma(struct vm_area_struct *vma, int node)
+{
+	struct mempolicy *pol = NULL;
+	struct mempol_walk_data data;
+	struct mm_walk walk;
+	LIST_HEAD(pagelist);
+	nodemask_t nmask;
+
+	if (vma->vm_file)
+		return;
+
+	if (!vma_migratable(vma))
+		return;
+
+	/*
+	 * Obtain a more-or-less correct nodemask to find which pages we need
+	 * to unmap so that MoF can put them right again.
+	 *
+	 * Not quite correct for INTERLEAVE, that would need us doing
+	 * offset_il_node() from check_pte_entry().
+	 *
+	 * Also not quite correct for task policies since we don't have a task,
+	 * approximate by having @node function as local / task-home-node.
+	 */
+
+	if (vma->vm_ops && vma->vm_ops->get_policy)
+	        pol = vma->vm_ops->get_policy(vma, vma->vm_start);
+	else if (vma->vm_policy)
+		pol = vma->vm_policy;
+
+	if (pol) {
+		nmask = mpol_node_mask(pol, node);
+		mpol_cond_put(pol);
+
+		/*
+		 * If there's an explicit policy that doesn't support MoF, skip
+		 * this vma, there's nothing we can do about that.
+		 */
+		if (!(pol->flags & MPOL_F_MOF))
+			return;
+	} else
+		nmask = nodemask_of_node(node);
+
+	data = (struct mempol_walk_data){
+		.nodes = &nmask,
+		.flags = MPOL_MF_MOVE | MPOL_MF_INVERT, /* move all pages not in set */
+		.private = &pagelist,
+		.vma = vma,
+	};
+
+	walk = (struct mm_walk){
+		.pte_entry = check_pte_entry,
+		.mm = vma->vm_mm,
+		.private = &data,
+	};
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
