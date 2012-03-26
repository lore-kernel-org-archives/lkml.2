Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2CZXuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:50:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50606 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CZXuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:50:18 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] mmap.c: find_vma: remove if(mm) check
Date: Mon, 26 Mar 2012 19:49:27 -0400
Message-Id: <1332805767-2013-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_vma is called from kernel code where it is absolutely
sure that the mm_struct arg being passed to it is non-NULL.

Remove the if(mm) check.
This will also serve the purpose of mandating that the execution
context(user-mode/kernel-mode) be known before find_vma is called.

Also fixed 2 checkpatch.pl errors in the declaration
of the rb_node and vma_tmp local variables.

I have tested this patch on my x86 PC and there are no crashes
due to this in the course of normal desktop execution.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/mmap.c |   54 ++++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index a7bf6a3..2b2fe67 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1587,35 +1587,33 @@ EXPORT_SYMBOL(get_unmapped_area);
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct *vma = NULL;
-
-	if (mm) {
-		/* Check the cache first. */
-		/* (Cache hit rate is typically around 35%.) */
-		vma = mm->mmap_cache;
-		if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
-			struct rb_node * rb_node;
-
-			rb_node = mm->mm_rb.rb_node;
-			vma = NULL;
-
-			while (rb_node) {
-				struct vm_area_struct * vma_tmp;
-
-				vma_tmp = rb_entry(rb_node,
-						struct vm_area_struct, vm_rb);
-
-				if (vma_tmp->vm_end > addr) {
-					vma = vma_tmp;
-					if (vma_tmp->vm_start <= addr)
-						break;
-					rb_node = rb_node->rb_left;
-				} else
-					rb_node = rb_node->rb_right;
-			}
-			if (vma)
-				mm->mmap_cache = vma;
+	struct vm_area_struct *vma;
+
+	/* Check the cache first. */
+	/* (Cache hit rate is typically around 35%.) */
+	vma = mm->mmap_cache;
+	if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
+		struct rb_node *rb_node;
+
+		rb_node = mm->mm_rb.rb_node;
+		vma = NULL;
+
+		while (rb_node) {
+			struct vm_area_struct *vma_tmp;
+
+			vma_tmp = rb_entry(rb_node,
+					   struct vm_area_struct, vm_rb);
+
+			if (vma_tmp->vm_end > addr) {
+				vma = vma_tmp;
+				if (vma_tmp->vm_start <= addr)
+					break;
+				rb_node = rb_node->rb_left;
+			} else
+				rb_node = rb_node->rb_right;
 		}
+		if (vma)
+			mm->mmap_cache = vma;
 	}
 	return vma;
 }
-- 
1.7.5.4

