Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1EHS4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:56:01 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:59558 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1EHSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:55:57 -0400
Date: Sun, 8 May 2011 20:55:56 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] Don't mlock guardpage if the stack is growing up
Message-ID: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't mlock guardpage if the stack is growing up

Linux kernel excludes guard page when performing mlock on a VMA with 
down-growing stack. However, some architectures have up-growing stack and 
locking the guard page should be excluded in this case too.

This patch fixes lvm2 on PA-RISC (and possibly other architectures with 
up-growing stack). lvm2 calculates the number of used pages when locking 
and when unlocking and reports an internal error if the numbers mismatch. 
On PA-RISC, the kernel would incorrectly attempt to mlock the stack guard 
page, this causes allocation of one more page and internal error in lvm2.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 include/linux/mm.h |    6 ++++++
 mm/memory.c        |   21 ++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

Index: linux-2.6.39-rc6-fast/include/linux/mm.h
===================================================================
--- linux-2.6.39-rc6-fast.orig/include/linux/mm.h	2011-05-07 05:59:51.000000000 +0200
+++ linux-2.6.39-rc6-fast/include/linux/mm.h	2011-05-07 05:59:52.000000000 +0200
@@ -1016,6 +1016,12 @@ static inline int vma_stack_continue(str
 	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
 }
 
+/* Is the vma a continuation of the stack vma below it? */
+static inline int vma_stack_growsup_continue(struct vm_area_struct *vma, unsigned long addr)
+{
+	return vma && (vma->vm_start == addr) && (vma->vm_flags & VM_GROWSUP);
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len);
Index: linux-2.6.39-rc6-fast/mm/memory.c
===================================================================
--- linux-2.6.39-rc6-fast.orig/mm/memory.c	2011-05-07 05:59:51.000000000 +0200
+++ linux-2.6.39-rc6-fast/mm/memory.c	2011-05-07 05:59:52.000000000 +0200
@@ -1412,9 +1412,12 @@ no_page_table:
 
 static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
 {
-	return (vma->vm_flags & VM_GROWSDOWN) &&
+	return ((vma->vm_flags & VM_GROWSDOWN) &&
 		(vma->vm_start == addr) &&
-		!vma_stack_continue(vma->vm_prev, addr);
+		!vma_stack_continue(vma->vm_prev, addr)) ||
+	       ((vma->vm_flags & VM_GROWSUP) &&
+		(vma->vm_end == addr + PAGE_SIZE) &&
+		!vma_stack_growsup_continue(vma->vm_next, addr + PAGE_SIZE));
 }
 
 /**
@@ -1551,18 +1554,18 @@ int __get_user_pages(struct task_struct 
 			continue;
 		}
 
-		/*
-		 * If we don't actually want the page itself,
-		 * and it's the stack guard page, just skip it.
-		 */
-		if (!pages && stack_guard_page(vma, start))
-			goto next_page;
-
 		do {
 			struct page *page;
 			unsigned int foll_flags = gup_flags;
 
 			/*
+			 * If we don't actually want the page itself,
+			 * and it's the stack guard page, just skip it.
+			 */
+			if (!pages && stack_guard_page(vma, start))
+				goto next_page;
+
+			/*
 			 * If we have a pending SIGKILL, don't keep faulting
 			 * pages and potentially allocating memory.
 			 */
