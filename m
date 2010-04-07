Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0DGXmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:42:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab0DGXmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:42:31 -0400
Date: Wed, 7 Apr 2010 16:37:15 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
 <4BBCAA5B.7080603@redhat.com> <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org> <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org> <4BBCFE8A.1030602@redhat.com> <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Linus Torvalds wrote:
> 
> Yes. The failure point is too late to do anything really interesting with, 
> and the old code also just causes a SIGBUS. My intention was to change the 
> 
> 	WARN_ONCE(!vma->anon_vma);
> 
> into returning that SIGBUS - which is not wonderful, but is no different 
> from old failures.

Not SIGBUS, but VM_FAULT_OOM, of course.

IOW, something like this should be no worse than what we have now, and has 
the much nicer locking semantics.

Having done some more digging, I can point to a downside: we do end up 
having about twice as many anon_vma entries. It seems about half of the 
vma's never need an anon_vma entry, probably because they end up being 
read-only file mappings, and thus never trigger the anonvma case.

That said:

 - I don't really think you can fix the locking problem you have in a 
   saner way

 - the anon_vma entry is much smaller than the vm_area_struct, so we're 
   still using much less memory for them than for vma's.

 - We _could_ avoid allocating anonvma entries for shared mappings or for 
   mappings that are read-only. That might force us to allocate some of 
   them at mprotect time, and/or when doing a forced COW event with 
   ptrace, but we have the mmap_sem for writing for the one case, and we 
   could decide to get it for the other.

   So it's not a _fundamental_ problem if we decide we want to recover 
   most of the memory lost by doing unconditional allocations.

There are alternative models. For example, the VM layer _could_ decide to 
just release the mmap_sem, and re-do it and take it for writing if the vma 
doesn't have an anon_vma. 

I dunno. I like how this patch makes things so much less subtle, though.  
For example: with this in place, we could further simplify 
anon_vma_prepare(), since it would now never have the re-entrancy issue 
and wouldn't need to worry about taking that page_table_lock and 
re-testing vma->anon_vma for races.

		Linus

---
 mm/memory.c |   12 +++---------
 mm/mmap.c   |   17 ++++-------------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 833952d..b5efe76 100644
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
@@ -3115,6 +3106,9 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pmd_t *pmd;
 	pte_t *pte;
 
+	if (!vma->anon_vma)
+		return VM_FAULT_OOM;
+
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
