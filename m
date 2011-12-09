Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1LIWtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:49:05 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49308 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab1LIWtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:49:01 -0500
From: kosaki.motohiro@gmail.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:15/23=65%),
        Hugh Dickins <hughd@google.com> (commit_signer:7/23=30%),
        Peter Zijlstra <a.p.zijlstra@chello.nl> (commit_signer:4/23=17%),
        Shaohua Li <shaohua.li@intel.com> (commit_signer:3/23=13%)
Subject: [PATCH v3] mm: simplify find_vma_prev
Date: Fri,  9 Dec 2011 17:48:40 -0500
Message-Id: <1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323466526.27746.29.camel@joe2Laptop>
References: <1323466526.27746.29.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 297c5eee37 (mm: make the vma list be doubly linked) added
vm_prev member into vm_area_struct. Therefore we can simplify
find_vma_prev() by using it. Also, this change help to improve
page fault performance because it has strong locality of reference.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mmap.c |   36 ++++++++----------------------------
 1 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index eae90af..b9c0241 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1603,39 +1603,19 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 
 EXPORT_SYMBOL(find_vma);
 
-/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
+/*
+ * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
+ * Note: pprev is set to NULL when return value is NULL.
+ */
 struct vm_area_struct *
 find_vma_prev(struct mm_struct *mm, unsigned long addr,
 			struct vm_area_struct **pprev)
 {
-	struct vm_area_struct *vma = NULL, *prev = NULL;
-	struct rb_node *rb_node;
-	if (!mm)
-		goto out;
-
-	/* Guard against addr being lower than the first VMA */
-	vma = mm->mmap;
-
-	/* Go through the RB tree quickly. */
-	rb_node = mm->mm_rb.rb_node;
-
-	while (rb_node) {
-		struct vm_area_struct *vma_tmp;
-		vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
-
-		if (addr < vma_tmp->vm_end) {
-			rb_node = rb_node->rb_left;
-		} else {
-			prev = vma_tmp;
-			if (!prev->vm_next || (addr < prev->vm_next->vm_end))
-				break;
-			rb_node = rb_node->rb_right;
-		}
-	}
+	struct vm_area_struct *vma;
 
-out:
-	*pprev = prev;
-	return prev ? prev->vm_next : vma;
+	vma = find_vma(mm, addr);
+	*pprev = vma ? vma->vm_prev : NULL;
+	return vma;
 }
 
 /*
-- 
1.7.1

