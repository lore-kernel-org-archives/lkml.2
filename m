Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2KLLzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:55:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2KLLvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:48 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/3] mm: ensure safe rb_subtree_gap update when removing VMA
Date: Mon, 12 Nov 2012 03:51:30 -0800
Message-Id: <1352721091-27022-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352721091-27022-1-git-send-email-walken@google.com>
References: <1352721091-27022-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the trinity fuzzer, Sasha Levin uncovered a case where
rb_subtree_gap wasn't correctly updated.

Digging into this, the root cause was that vma insertions and removals
require both an rbtree insert or erase operation (which may trigger
tree rotations), and an update of the next vma's gap (which does not
change the tree topology, but may require iterating on the node's
ancestors to propagate the update). The rbtree rotations caused the
rb_subtree_gap values to be updated in some of the internal nodes, but
without upstream propagation. Then the subsequent update on the next
vma didn't iterate as high up the tree as it should have, as it
stopped as soon as it hit one of the internal nodes that had been
updated as part of a tree rotation.

The fix is to impose that all rb_subtree_gap values must be up to date
before any rbtree insertion or erase, with the possible exception that
the node being erased doesn't need to have an up to date rb_subtree_gap.

This change: during VMA removal, remove VMA from the rbtree before we
remove it from the linked list. The implication is the next vma's
rb_subtree_gap value becomes stale when next->vm_prev is updated,
and we want to make sure vma_rb_erase() runs before there are any
such stale rb_subtree_gap values in the rbtree.

(I don't know of a reproduceable test case for this particular issue)

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 mm/mmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 14859b999a9f..c60ac9fe2d7e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -578,12 +578,12 @@ static inline void
 __vma_unlink(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct vm_area_struct *prev)
 {
-	struct vm_area_struct *next = vma->vm_next;
+	struct vm_area_struct *next;
 
-	prev->vm_next = next;
+	vma_rb_erase(vma, &mm->mm_rb);
+	prev->vm_next = next = vma->vm_next;
 	if (next)
 		next->vm_prev = prev;
-	vma_rb_erase(vma, &mm->mm_rb);
 	if (mm->mmap_cache == vma)
 		mm->mmap_cache = prev;
 }
-- 
1.7.7.3
