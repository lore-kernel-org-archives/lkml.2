Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab0DHOQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:16:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756367Ab0DHOQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:16:28 -0400
Date: Thu, 8 Apr 2010 07:11:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100408054707.GA9299@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org> <20100408101925.FB9F.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Borislav Petkov wrote:
> 
> There are still issues: vma_adjust() grabs mapping->i_mmap_lock for file
> mappings while we might sleep in anon_vma_prepare():

Ahh. Good catch. So I can't actually do that anon_vma_prepare() thing in 
__insert_vm_struct.

It should be simple enough to just move it into the caller, just after it 
releases that lock. There's only one user of that __insert_vm_struct() 
anyway. You can do it yourself, or you can replace my previous patch with 
this..

[ The patch below also makes it warn once and return SIGBUS for the case 
  where there is no anon_vma.  I decided I still want to hear about it if 
  there might be some path that tries to insert a vma on its own ]

		Linus

---
 mm/memory.c |   12 +++---------
 mm/mmap.c   |   17 ++++-------------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 833952d..08d4423 100644
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
 
+	if (WARN_ONCE(!vma->anon_vma, "Mapping with no anon_vma"))
+		return VM_FAULT_SIGBUS;
+
 	__set_current_state(TASK_RUNNING);
 
 	count_vm_event(PGFAULT);
diff --git a/mm/mmap.c b/mm/mmap.c
index 75557c6..82392c2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -463,6 +463,8 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	mm->map_count++;
 	validate_mm(mm);
+
+	anon_vma_prepare(vma);
 }
 
 /*
@@ -628,6 +630,8 @@ again:			remove_next = 1 + (end > next->vm_end);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
+	anon_vma_prepare(vma);
+
 	if (remove_next) {
 		if (file) {
 			fput(file);
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
