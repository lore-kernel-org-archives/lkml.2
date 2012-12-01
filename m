Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab2LAG4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 01:56:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44256 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2LAG4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 01:56:49 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm: protect against concurrent vma expansion
Date: Fri, 30 Nov 2012 22:56:27 -0800
Message-Id: <1354344987-28203-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

expand_stack() runs with a shared mmap_sem lock. Because of this, there
could be multiple concurrent stack expansions in the same mm, which may
cause problems in the vma gap update code.

I propose to solve this by taking the mm->page_table_lock around such vma
expansions, in order to avoid the concurrency issue. We only have to worry
about concurrent expand_stack() calls here, since we hold a shared mmap_sem
lock and all vma modificaitons other than expand_stack() are done under
an exclusive mmap_sem lock.

I previously tried to achieve the same effect by making sure all
growable vmas in a given mm would share the same anon_vma, which we
already lock here. However this turned out to be difficult - all of the
schemes I tried for refcounting the growable anon_vma and clearing
turned out ugly. So, I'm now proposing only the minimal fix.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 mm/mmap.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9ed3a06242a0..e44fe876a7e3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2069,6 +2069,11 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
+				/*
+				 * page_table_lock to protect against
+				 * concurrent vma expansions
+				 */
+				spin_lock(&vma->vm_mm->page_table_lock);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				anon_vma_interval_tree_post_update_vma(vma);
@@ -2076,6 +2081,8 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 					vma_gap_update(vma->vm_next);
 				else
 					vma->vm_mm->highest_vm_end = address;
+				spin_unlock(&vma->vm_mm->page_table_lock);
+
 				perf_event_mmap(vma);
 			}
 		}
@@ -2126,11 +2133,18 @@ int expand_downwards(struct vm_area_struct *vma,
 		if (grow <= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
+				/*
+				 * page_table_lock to protect against
+				 * concurrent vma expansions
+				 */
+				spin_lock(&vma->vm_mm->page_table_lock);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				anon_vma_interval_tree_post_update_vma(vma);
 				vma_gap_update(vma);
+				spin_unlock(&vma->vm_mm->page_table_lock);
+
 				perf_event_mmap(vma);
 			}
 		}
-- 
1.7.7.3
