Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0DGVY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:24:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050Ab0DGVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:24:28 -0400
Date: Wed, 7 Apr 2010 14:19:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
 <4BBCAA5B.7080603@redhat.com> <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Linus Torvalds wrote:
> 
> I do wonder if we could possibly simplify this a _lot_ by just requiring 
> that the anon_vma gets allocated at vma creation time (ie mmap), rather 
> than doing it on-demand when we actually do the page fault.
> 
> That would make all of this crap happen under mmap_sem held for writing, 
> and it would simplify the faulting code (which is the much more critical 
> code) a lot.

Here is a patch that boots for me (but has had _zero_ serious testing: 
caveat emptor etc etc).

It basically moves "anon_vma_prepare()" to be called in vma_link and in 
__insert_vm_struct() - which I _think_ should cover all normal vma 
creation events. I did a "WARN_ONCE(!vma->anon_vma)" just to check, I 
haven't triggered one yet.

Now, this clearly will create anon_vma's that may never get used at all, 
ie for things like shared mappings etc that never have anonymous memory 
associated with them. But that structure is pretty small, so I don't find 
it in myself to care too deeply.

And with this, all the anon_vma games shuld all happen with mmap_sem held 
for writing, which should hopefully simplify things a lot. Rik, can you 
use this to make a new version of your fixing patch?

Comments?

		Linus

---
 mm/memory.c |   10 +---------
 mm/mmap.c   |   17 ++++-------------
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 833952d..0abefd8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2223,9 +2223,6 @@ reuse:
 gotten:
 	pte_unmap_unlock(page_table, ptl);
 
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
-
 	if (is_zero_pfn(pte_pfn(orig_pte))) {
 		new_page = alloc_zeroed_user_highpage_movable(vma, address);
 		if (!new_page)
@@ -2766,8 +2763,6 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* Allocate our own private page. */
 	pte_unmap(page_table);
 
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);
 	if (!page)
 		goto oom;
@@ -2863,10 +2858,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!(vma->vm_flags & VM_SHARED)) {
 			anon = 1;
-			if (unlikely(anon_vma_prepare(vma))) {
-				ret = VM_FAULT_OOM;
-				goto out;
-			}
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
 						vma, address);
 			if (!page) {
@@ -3115,6 +3106,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pmd_t *pmd;
 	pte_t *pte;
 
+	WARN_ONCE(!vma->anon_vma, "No anonvma");
 	__set_current_state(TASK_RUNNING);
 
 	count_vm_event(PGFAULT);
diff --git a/mm/mmap.c b/mm/mmap.c
index 75557c6..c14284b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -463,6 +463,8 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	mm->map_count++;
 	validate_mm(mm);
+
+	anon_vma_prepare(vma);
 }
 
 /*
@@ -479,6 +481,8 @@ static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	BUG_ON(__vma && __vma->vm_start < vma->vm_end);
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	mm->map_count++;
+
+	anon_vma_prepare(vma);
 }
 
 static inline void
@@ -1674,12 +1678,6 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	if (!(vma->vm_flags & VM_GROWSUP))
 		return -EFAULT;
 
-	/*
-	 * We must make sure the anon_vma is allocated
-	 * so that the anon_vma locking is not a noop.
-	 */
-	if (unlikely(anon_vma_prepare(vma)))
-		return -ENOMEM;
 	anon_vma_lock(vma);
 
 	/*
@@ -1720,13 +1718,6 @@ static int expand_downwards(struct vm_area_struct *vma,
 {
 	int error;
 
-	/*
-	 * We must make sure the anon_vma is allocated
-	 * so that the anon_vma locking is not a noop.
-	 */
-	if (unlikely(anon_vma_prepare(vma)))
-		return -ENOMEM;
-
 	address &= PAGE_MASK;
 	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
 	if (error)
