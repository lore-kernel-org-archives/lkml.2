Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2HFM43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:56:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61882 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2HFM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:56:28 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 20:56:27 +0800
Message-ID: <CAJd=RBB2Hsqnn58idvs5azMonRhk0A6EOKZ=tTskRngGk=XCOw@mail.gmail.com>
Subject: [RFC patch] mmap: permute find_vma with find_vma_prev
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both find_vma and find_vma_prev have code for walking rb tree, and we can
walk less.

To cut the walk in find_vma_prev off, find_vma is changed to take care of
vm_prev while walking rb tree, and we end up wrapping find_vma_prev with
find_vma.

btw, what happened to LKML?

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/mmap.c	Fri Aug  3 07:38:10 2012
+++ b/mm/mmap.c	Mon Aug  6 20:10:18 2012
@@ -1602,11 +1602,18 @@ get_unmapped_area(struct file *file, uns

 EXPORT_SYMBOL(get_unmapped_area);

-/* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
-struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
+/*
+ * Look up the first VMA which satisfies  addr < vm_end,  NULL if none.
+ * Also return a pointer to the previous VMA.
+ */
+struct vm_area_struct *
+find_vma_prev(struct mm_struct *mm, unsigned long addr,
+			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma = NULL;

+	*pprev = NULL; /* Should be removed with WARN_ON_ONCE(!mm) */
+
 	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
 		return NULL;

@@ -1630,39 +1637,29 @@ struct vm_area_struct *find_vma(struct m
 				if (vma_tmp->vm_start <= addr)
 					break;
 				rb_node = rb_node->rb_left;
-			} else
+			} else {
 				rb_node = rb_node->rb_right;
+				*pprev = vma_tmp;
+			}
 		}
-		if (vma)
+		if (vma) {
 			mm->mmap_cache = vma;
+			/* remove false positive produced while walking rb tree */
+			*pprev = vma->vm_prev;
+		}
+	} else {
+		*pprev = vma->vm_prev;
 	}
 	return vma;
 }

-EXPORT_SYMBOL(find_vma);
-
-/*
- * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
- */
-struct vm_area_struct *
-find_vma_prev(struct mm_struct *mm, unsigned long addr,
-			struct vm_area_struct **pprev)
+struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct *vma;
+	struct vm_area_struct *prev;

-	vma = find_vma(mm, addr);
-	if (vma) {
-		*pprev = vma->vm_prev;
-	} else {
-		struct rb_node *rb_node = mm->mm_rb.rb_node;
-		*pprev = NULL;
-		while (rb_node) {
-			*pprev = rb_entry(rb_node, struct vm_area_struct, vm_rb);
-			rb_node = rb_node->rb_right;
-		}
-	}
-	return vma;
+	return find_vma_prev(mm, addr, &prev);
 }
+EXPORT_SYMBOL(find_vma);

 /*
  * Verify that the stack growth is acceptable and
--
