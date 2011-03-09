Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1CIAnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:43:07 -0500
Received: from mout.perfora.net ([74.208.4.194]:58589 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab1CIAnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:43:05 -0500
From: Stephen Wilson <wilsons@start.ca>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 1/6] mm: use mm_struct to resolve gate vma's in __get_user_pages
Date: Tue,  8 Mar 2011 19:42:18 -0500
Message-Id: <1299631343-4499-2-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1299631343-4499-1-git-send-email-wilsons@start.ca>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:jTyy74FH7QGU0cnUvhM0ZDafAnv5UcrkYdk6NiAIO9C
 gQmQ+DhJYcadI8PfIqQ8yivFQvSyehgw0AsyEERuVGJ4txGWYm
 ZG9ikc7ZOoOF4nxjCHUJtyybRqVCsVultbHEuNPkNtDZI8KSCr
 kaGdqozK+I9zimDMnwYlobWiqW6v+dNKv9lkobaL2hR7y7YxBf
 ZQD8Ip8ECRITX8MdLwd4f4i8U8AQW14VhBzNj19kBU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now check if a requested user page overlaps a gate vma using the supplied mm
instead of the supplied task.  The given task is now used solely for accounting
purposes and may be NULL.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 mm/memory.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3863e86..36445e3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1437,9 +1437,9 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		struct vm_area_struct *vma;
 
 		vma = find_extend_vma(mm, start);
-		if (!vma && in_gate_area(tsk->mm, start)) {
+		if (!vma && in_gate_area(mm, start)) {
 			unsigned long pg = start & PAGE_MASK;
-			struct vm_area_struct *gate_vma = get_gate_vma(tsk->mm);
+			struct vm_area_struct *gate_vma = get_gate_vma(mm);
 			pgd_t *pgd;
 			pud_t *pud;
 			pmd_t *pmd;
@@ -1533,10 +1533,13 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 						return i ? i : -EFAULT;
 					BUG();
 				}
-				if (ret & VM_FAULT_MAJOR)
-					tsk->maj_flt++;
-				else
-					tsk->min_flt++;
+
+				if (tsk) {
+					if (ret & VM_FAULT_MAJOR)
+						tsk->maj_flt++;
+					else
+						tsk->min_flt++;
+				}
 
 				if (ret & VM_FAULT_RETRY) {
 					*nonblocking = 0;
@@ -1581,7 +1584,8 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 /**
  * get_user_pages() - pin user pages in memory
- * @tsk:	task_struct of target task
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
  * @mm:		mm_struct of target mm
  * @start:	starting user address
  * @nr_pages:	number of pages from start to pin
-- 
1.7.3.5

