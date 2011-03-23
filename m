Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab1CWOrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:47:37 -0400
Received: from mout.perfora.net ([74.208.4.194]:55428 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab1CWOrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:47:33 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH v2 resend 06/12] mm: use mm_struct to resolve gate vma's in __get_user_pages
Date: Wed, 23 Mar 2011 10:43:55 -0400
Message-Id: <1300891441-16280-7-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300891441-16280-1-git-send-email-wilsons@start.ca>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:eKLsRMewRnUiM0ZgE8KH1ig/GNo0dGA5e/WpSO1r1wi
 Qxa4IkAVOgywFDohJd/n/fqjOzBDdqR7w4pxvUS3uzQ/5JHNkF
 SQdYn2YxHxHTsIUlQvxqZ2T0kQG2k9fF/AZWBtYJqAezFx6Kvg
 4oBv4F2qfJ961Rr+BWjzyulf68Hju+ycH6PcGQeIlDGSE6k3p1
 2XijtJpqvRsdlp9zZHInBJNS+PMjUmjQNRVus92fr8=
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

