Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1LUM1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:27:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1LUM1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:27:09 -0500
Message-ID: <1324470416.10752.1.camel@twins>
Subject: [PATCH] futex: Fix uninterruptble loop due to gate_area
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Wed, 21 Dec 2011 13:26:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: futex: Fix uninterruptble loop due to gate_area
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Dec 02 14:12:06 CET 2011

It was found (by Sasha) that if you use a futex located in the gate
area we get stuck in an uninterruptible infinite loop, much like the
ZERO_PAGE issue.

While looking at this problem, I realized you'll get into similar
trouble when hitting any install_special_pages() mapping. The solution
chosen was not to modify special_mapping_fault() to install a non-zero
page->mapping because that might lead to issues when freeing these
pages. Instead do a find_vma() when we find we're again in the
!mapping branch.

Cc: stable@kernel.org
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm.h |    1 +
 kernel/futex.c     |   40 +++++++++++++++++++++++++++++++++++-----
 mm/mmap.c          |    5 +++++
 3 files changed, 41 insertions(+), 5 deletions(-)
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1394,6 +1394,7 @@ extern int may_expand_vm(struct mm_struc
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
+extern bool is_special_mapping(struct vm_area_struct *vma);
 
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -59,6 +59,7 @@
 #include <linux/magic.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
+#include <linux/mm.h>
 
 #include <asm/futex.h>
 
@@ -236,7 +237,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err, ro = 0;
+	int err, ro = 0, no_mapping_tries = 0;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -317,13 +318,42 @@ get_futex_key(u32 __user *uaddr, int fsh
 	if (!page_head->mapping) {
 		unlock_page(page_head);
 		put_page(page_head);
+
 		/*
-		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
-		* trying to find one. RW mapping would have COW'd (and thus
-		* have a mapping) so this page is RO and won't ever change.
-		*/
+		 * ZERO_PAGE pages don't have a mapping. Avoid a busy loop
+		 * trying to find one. RW mapping would have COW'd (and thus
+		 * have a mapping) so this page is RO and won't ever change.
+		 */
 		if ((page_head == ZERO_PAGE(address)))
 			return -EFAULT;
+
+		/*
+		 * Similar problem for the gate area.
+		 */
+		if (in_gate_area(mm, address))
+			return -EFAULT;
+
+		/*
+		 * There is a special class of pages that will have no mapping
+		 * and yet is perfectly valid and not going anywhere. These
+		 * are the pages from install_special_mapping(). Since looking
+		 * up the vma is expensive, don't do so on the first go round.
+		 */
+		if (no_mapping_tries) {
+			struct vm_area_struct *vma;
+
+			err = 0;
+			down_read(&mm->mmap_sem);
+			vma = find_vma(mm, address);
+			if (vma && is_special_mapping(vma))
+				err = -EFAULT;
+			up_read(&mm->mmap_sem);
+
+			if (err)
+				return err;
+		}
+
+		++no_mapping_tries;
 		goto again;
 	}
 
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -2479,6 +2479,11 @@ int install_special_mapping(struct mm_st
 	return ret;
 }
 
+bool is_special_mapping(struct vm_area_struct *vma)
+{
+	return vma->vm_ops == &special_mapping_vmops;
+}
+
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)

