Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3ACE3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 23:29:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61076 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3ACE2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 23:28:12 -0500
X-AuditID: 9c930197-b7c5bae000000e31-bf-50e508d9e89b
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFC 2/8] Don't allow volatile attribute on THP and KSM
Date: Thu,  3 Jan 2013 13:28:00 +0900
Message-Id: <1357187286-18759-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357187286-18759-1-git-send-email-minchan@kernel.org>
References: <1357187286-18759-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VOLATILE imply the the pages in the range isn't working set any more
so it's pointless that make them to THP/KSM.

Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/huge_memory.c |    9 +++++++--
 mm/ksm.c         |    3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40f17c3..5ddd00e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1477,7 +1477,8 @@ out:
 	return ret;
 }
 
-#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
+#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|\
+			VM_SHARED|VM_MAYSHARE|VM_VOLATILE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
@@ -1641,6 +1642,8 @@ int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
 		 * page fault if needed.
 		 */
 		return 0;
+	if (vma->vm_flags & VM_VOLATILE)
+		return 0;
 	if (vma->vm_ops)
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
@@ -1969,6 +1972,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 		goto out;
 	if (is_vma_temporary_stack(vma))
 		goto out;
+	if (vma->vm_flags & VM_VOLATILE)
+		goto out;
 	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 
 	pgd = pgd_offset(mm, address);
@@ -2196,7 +2201,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 
 		if ((!(vma->vm_flags & VM_HUGEPAGE) &&
 		     !khugepaged_always()) ||
-		    (vma->vm_flags & VM_NOHUGEPAGE)) {
+		     (vma->vm_flags & (VM_NOHUGEPAGE|VM_VOLATILE))) {
 		skip:
 			progress++;
 			continue;
diff --git a/mm/ksm.c b/mm/ksm.c
index ae539f0..2775f59 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1486,7 +1486,8 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		 */
 		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
 				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
-				 VM_HUGETLB | VM_NONLINEAR | VM_MIXEDMAP))
+				 VM_HUGETLB | VM_NONLINEAR | VM_MIXEDMAP   |
+				 VM_VOLATILE))
 			return 0;		/* just ignore the advice */
 
 #ifdef VM_SAO
-- 
1.7.9.5

