Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1DSU3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:29:32 -0400
Received: from kroah.org ([198.145.64.141]:47612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1DSUQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:44 2011
Message-Id: <20110419201044.771028281@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [15/70] vm: fix mlock() on stack guard page
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 95042f9eb78a8d9a17455e2ef263f2f310ecef15 upstream.

Commit 53a7706d5ed8 ("mlock: do not hold mmap_sem for extended periods
of time") changed mlock() to care about the exact number of pages that
__get_user_pages() had brought it.  Before, it would only care about
errors.

And that doesn't work, because we also handled one page specially in
__mlock_vma_pages_range(), namely the stack guard page.  So when that
case was handled, the number of pages that the function returned was off
by one.  In particular, it could be zero, and then the caller would end
up not making any progress at all.

Rather than try to fix up that off-by-one error for the mlock case
specially, this just moves the logic to handle the stack guard page
into__get_user_pages() itself, thus making all the counts come out
right automatically.

Reported-by: Robert Święcki <robert@swiecki.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 mm/memory.c |   26 ++++++++++++++++++--------
 mm/mlock.c  |   13 -------------
 2 files changed, 18 insertions(+), 21 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1410,6 +1410,13 @@ no_page_table:
 	return page;
 }
 
+static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
+{
+	return (vma->vm_flags & VM_GROWSDOWN) &&
+		(vma->vm_start == addr) &&
+		!vma_stack_continue(vma->vm_prev, addr);
+}
+
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int nr_pages, unsigned int gup_flags,
 		     struct page **pages, struct vm_area_struct **vmas,
@@ -1439,7 +1446,6 @@ int __get_user_pages(struct task_struct
 		vma = find_extend_vma(mm, start);
 		if (!vma && in_gate_area(tsk, start)) {
 			unsigned long pg = start & PAGE_MASK;
-			struct vm_area_struct *gate_vma = get_gate_vma(tsk);
 			pgd_t *pgd;
 			pud_t *pud;
 			pmd_t *pmd;
@@ -1464,10 +1470,11 @@ int __get_user_pages(struct task_struct
 				pte_unmap(pte);
 				return i ? : -EFAULT;
 			}
+			vma = get_gate_vma(tsk);
 			if (pages) {
 				struct page *page;
 
-				page = vm_normal_page(gate_vma, start, *pte);
+				page = vm_normal_page(vma, start, *pte);
 				if (!page) {
 					if (!(gup_flags & FOLL_DUMP) &&
 					     is_zero_pfn(pte_pfn(*pte)))
@@ -1481,12 +1488,7 @@ int __get_user_pages(struct task_struct
 				get_page(page);
 			}
 			pte_unmap(pte);
-			if (vmas)
-				vmas[i] = gate_vma;
-			i++;
-			start += PAGE_SIZE;
-			nr_pages--;
-			continue;
+			goto next_page;
 		}
 
 		if (!vma ||
@@ -1500,6 +1502,13 @@ int __get_user_pages(struct task_struct
 			continue;
 		}
 
+		/*
+		 * If we don't actually want the page itself,
+		 * and it's the stack guard page, just skip it.
+		 */
+		if (!pages && stack_guard_page(vma, start))
+			goto next_page;
+
 		do {
 			struct page *page;
 			unsigned int foll_flags = gup_flags;
@@ -1569,6 +1578,7 @@ int __get_user_pages(struct task_struct
 				flush_anon_page(vma, page, start);
 				flush_dcache_page(page);
 			}
+next_page:
 			if (vmas)
 				vmas[i] = vma;
 			i++;
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -135,13 +135,6 @@ void munlock_vma_page(struct page *page)
 	}
 }
 
-static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
-{
-	return (vma->vm_flags & VM_GROWSDOWN) &&
-		(vma->vm_start == addr) &&
-		!vma_stack_continue(vma->vm_prev, addr);
-}
-
 /**
  * __mlock_vma_pages_range() -  mlock a range of pages in the vma.
  * @vma:   target vma
@@ -188,12 +181,6 @@ static long __mlock_vma_pages_range(stru
 	if (vma->vm_flags & VM_LOCKED)
 		gup_flags |= FOLL_MLOCK;
 
-	/* We don't try to access the guard page of a stack vma */
-	if (stack_guard_page(vma, start)) {
-		addr += PAGE_SIZE;
-		nr_pages--;
-	}
-
 	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
 				NULL, NULL, nonblocking);
 }


