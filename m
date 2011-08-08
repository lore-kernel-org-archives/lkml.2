Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1HHJBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:01:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:35590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1HHJBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:01:36 -0400
Subject: [PATCH] mm: Fix fixup_user_fault() for MMU=n
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 11:01:15 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312794075.10488.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm: Fix fixup_user_fault() for MMU=n
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 27 Jul 2011 12:17:11 +0200

In commit 2efaca927 ("mm/futex: fix futex writes on archs with SW
tracking of dirty & young") we forgot about MMU=n. This patch fixes
that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/1311761831.24752.413.camel@twins
---
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -962,6 +962,8 @@ int invalidate_inode_page(struct page *p
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
+extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long address, unsigned int fault_flags);
 #else
 static inline int handle_mm_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
@@ -971,6 +973,14 @@ static inline int handle_mm_fault(struct
 	BUG();
 	return VM_FAULT_SIGBUS;
 }
+static inline int fixup_user_fault(struct task_struct *tsk, 
+		struct mm_struct *mm, unsigned long address,
+		unsigned int fault_flags)
+{
+	/* should never happen if there's no MMU */
+	BUG();
+	return -EFAULT;
+}
 #endif
 
 extern int make_pages_present(unsigned long addr, unsigned long end);
@@ -988,8 +998,6 @@ int get_user_pages(struct task_struct *t
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct page *get_dump_page(unsigned long addr);
-extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
-			    unsigned long address, unsigned int fault_flags);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);


