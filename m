Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab0DIBaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:30:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49051 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0DIBaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:30:16 -0400
Date: Fri, 9 Apr 2010 03:30:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100409013012.GA8153@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
	hannes@cmpxchg.org
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
 <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
 <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <20100408210035.GA25834@a1.tnic>
 <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
 <20100408234721.GB25834@a1.tnic>
 <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, Apr 08, 2010 at 05:50:21PM -0700

> > Yep, looks good: its mmap_region()...
> 
> Can you double-check your current diffs - maybe something got corrupted.
> 
> mmap_region installs the vma with vma_link(), and the last thing 
> vma_link() does with my patch is that "anon_vma_prepare()".

Right, it looks like it. I'll add some more debugging calls there
tomorrow - it might give us more clues in case someone hasn't caught it
until then.

> Maybe with all the patches flying around, you had a reject or something, 
> and you lost that one anon_vma_prepare()?
> 
> Or maybe I screwed up somewhere and sent you the wrong patch. Here it is 
> again, just in case.

Doesn't look like it - here's the diff between yours and what I have
applied here (yep, only minor fuzz but no code differences) Also, I've
added my version at the end:

--- a.diff      2010-04-09 03:03:35.000000000 +0200
+++ b.diff      2010-04-09 03:03:52.000000000 +0200
@@ -1,8 +1,8 @@
 diff --git a/mm/memory.c b/mm/memory.c
-index 1d2ea39..bd7ea7f 100644
+index 833952d..08d4423 100644
 --- a/mm/memory.c
 +++ b/mm/memory.c
-@@ -2224,9 +2224,6 @@ reuse:
+@@ -2223,9 +2223,6 @@ reuse:
  gotten:
        pte_unmap_unlock(page_table, ptl);
  
@@ -12,7 +12,7 @@ index 1d2ea39..bd7ea7f 100644
        if (is_zero_pfn(pte_pfn(orig_pte))) {
                new_page = alloc_zeroed_user_highpage_movable(vma, address);
                if (!new_page)
-@@ -2767,8 +2764,6 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
+@@ -2766,8 +2763,6 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
        /* Allocate our own private page. */
        pte_unmap(page_table);
  
@@ -21,7 +21,7 @@ index 1d2ea39..bd7ea7f 100644
        page = alloc_zeroed_user_highpage_movable(vma, address);
        if (!page)
                goto oom;
-@@ -2864,10 +2859,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+@@ -2863,10 +2858,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
        if (flags & FAULT_FLAG_WRITE) {
                if (!(vma->vm_flags & VM_SHARED)) {
                        anon = 1;
@@ -32,7 +32,7 @@ index 1d2ea39..bd7ea7f 100644
                        page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
                                                vma, address);
                        if (!page) {
-@@ -3116,6 +3107,9 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+@@ -3115,6 +3106,9 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
        pmd_t *pmd;
        pte_t *pte;
  
@@ -43,7 +43,7 @@ index 1d2ea39..bd7ea7f 100644
  
        count_vm_event(PGFAULT);
 diff --git a/mm/mmap.c b/mm/mmap.c
-index bf0600c..4592a93 100644
+index 75557c6..82392c2 100644
 --- a/mm/mmap.c
 +++ b/mm/mmap.c
 @@ -463,6 +463,8 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,

> [ I have a horrible cold, and can hardly think straight. So who knows, 
>   maybe I'm missing something. But if you have lost one of the 
>   'anon_vma_prepare()' call sites, that would certainly explain why you 
>   get NULL anon_vma's ]

Oh, sorry to hear that. Ok, let's stop for today - it is 3am here and
even if some would say, "well, this is just getting interesting" :), I
think it would be best to "sleep on it." :)

Thanks.

--
commit 2156db98fd84d07e3b86564f429fcc8c6b7d61df
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Apr 8 22:09:53 2010 +0200

    rmap: preallocate anon VMAs
    
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

diff --git a/mm/memory.c b/mm/memory.c
index 1d2ea39..bd7ea7f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2224,9 +2224,6 @@ reuse:
 gotten:
 	pte_unmap_unlock(page_table, ptl);
 
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
-
 	if (is_zero_pfn(pte_pfn(orig_pte))) {
 		new_page = alloc_zeroed_user_highpage_movable(vma, address);
 		if (!new_page)
@@ -2767,8 +2764,6 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* Allocate our own private page. */
 	pte_unmap(page_table);
 
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);
 	if (!page)
 		goto oom;
@@ -2864,10 +2859,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3116,6 +3107,9 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pmd_t *pmd;
 	pte_t *pte;
 
+	if (WARN_ONCE(!vma->anon_vma, "Mapping with no anon_vma"))
+		return VM_FAULT_SIGBUS;
+
 	__set_current_state(TASK_RUNNING);
 
 	count_vm_event(PGFAULT);
diff --git a/mm/mmap.c b/mm/mmap.c
index bf0600c..4592a93 100644
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

-- 
Regards/Gruss,
    Boris.
