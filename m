Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2GaTqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:46:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:58938 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2GaToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:44 -0400
Message-Id: <20120731192808.707407024@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/19] mm/mpol: Add MPOL_MF_LAZY ...
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=mm_mpol-Add_MPOL_MF_LAZY____.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch adds another mbind() flag to request "lazy migration".
The flag, MPOL_MF_LAZY, modifies MPOL_MF_MOVE* such that the selected
pages are simply unmapped from the calling task's page table ['_MOVE]
or from all referencing page tables [_MOVE_ALL].  Anon pages will first
be added to the swap [or migration?] cache, if necessary.  The pages
will be migrated in the fault path on "first touch", if the policy
dictates at that time.

"Lazy Migration" will allow testing of migrate-on-fault via mbind().
Also allows applications to specify that only subsequently touched
pages be migrated to obey new policy, instead of all pages in range.
This can be useful for multi-threaded applications working on a
large shared data area that is initialized by an initial thread
resulting in all pages on one [or a few, if overflowed] nodes.
After unmap, the pages in regions assigned to the worker threads
will be automatically migrated local to the threads on 1st touch.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
[ nearly complete rewrite.. ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mempolicy.h |   13 ++++++++++---
 include/linux/migrate.h   |    1 +
 mm/mempolicy.c            |   46 +++++++++++++++++++++++++++++-----------------
 3 files changed, 40 insertions(+), 20 deletions(-)
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -48,9 +48,16 @@ enum mpol_rebind_step {
 
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform to mapping */
-#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
-#define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
+#define MPOL_MF_MOVE	 (1<<1)	/* Move pages owned by this process to conform
+				   to policy */
+#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to policy */
+#define MPOL_MF_LAZY	 (1<<3)	/* Modifies '_MOVE:  lazy migrate on fault */
+#define MPOL_MF_INTERNAL (1<<4)	/* Internal flags start here */
+
+#define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
+			 MPOL_MF_MOVE     | 	\
+			 MPOL_MF_MOVE_ALL |	\
+			 MPOL_MF_LAZY)
 
 /*
  * Internal flags that share the struct mempolicy flags word with
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -589,22 +589,32 @@ check_range(struct mm_struct *mm, unsign
 		return ERR_PTR(-EFAULT);
 	prev = NULL;
 	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
+		unsigned long endvma = vma->vm_end;
+
+		if (endvma > end)
+			endvma = end;
+		if (vma->vm_start > start)
+			start = vma->vm_start;
+
 		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
 			if (!vma->vm_next && vma->vm_end < end)
 				return ERR_PTR(-EFAULT);
 			if (prev && prev->vm_end < vma->vm_start)
 				return ERR_PTR(-EFAULT);
 		}
-		if (!is_vm_hugetlb_page(vma) &&
-		    ((flags & MPOL_MF_STRICT) ||
+
+		if (is_vm_hugetlb_page(vma))
+			goto next;
+
+		if (flags & MPOL_MF_LAZY) {
+			change_prot_none(vma, start, endvma);
+			goto next;
+		}
+
+		if ((flags & MPOL_MF_STRICT) ||
 		     ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
-				vma_migratable(vma)))) {
-			unsigned long endvma = vma->vm_end;
+		      vma_migratable(vma))) {
 
-			if (endvma > end)
-				endvma = end;
-			if (vma->vm_start > start)
-				start = vma->vm_start;
 			err = check_pgd_range(vma, start, endvma, nodes,
 						flags, private);
 			if (err) {
@@ -612,6 +622,7 @@ check_range(struct mm_struct *mm, unsign
 				break;
 			}
 		}
+next:
 		prev = vma;
 	}
 	return first;
@@ -1118,8 +1129,7 @@ static long do_mbind(unsigned long start
 	int err;
 	LIST_HEAD(pagelist);
 
-	if (flags & ~(unsigned long)(MPOL_MF_STRICT |
-				     MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+  	if (flags & ~(unsigned long)MPOL_MF_VALID)
 		return -EINVAL;
 	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
 		return -EPERM;
@@ -1178,21 +1188,23 @@ static long do_mbind(unsigned long start
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
-	err = PTR_ERR(vma);
-	if (!IS_ERR(vma)) {
-		int nr_failed = 0;
-
+	err = PTR_ERR(vma);	/* maybe ... */
+	if (!IS_ERR(vma))
 		err = mbind_range(mm, start, end, new);
 
+	if (!err) {
+		int nr_failed = 0;
+
 		if (!list_empty(&pagelist)) {
+			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
-						false, MIGRATE_SYNC);
+						  (unsigned long)vma,
+						  false, MIGRATE_SYNC);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
 
-		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
+		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
 		putback_lru_pages(&pagelist);


