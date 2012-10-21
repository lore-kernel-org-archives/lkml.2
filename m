Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2JUMuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:50:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47598 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2JUMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:50:12 -0400
Date: Sun, 21 Oct 2012 14:50:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 4/2] numa, mm: Rename the PROT_NONE fault handling functions
Message-ID: <20121021125007.GB19535@gmail.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
 <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
 <1350646863.30157.13.camel@twins>
 <50815EA5.5080502@redhat.com>
 <20121019205407.GA9132@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019205407.GA9132@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > > I don't much care either way, but I was thinking walken 
> > > might want to use something similar to do WSS estimation, 
> > > in which case the NUMA name is just as wrong.
> > 
> > That's a good point. I had not considered other uses of the 
> > same code.
> 
> Renaming the functions for more clarity still makes sense IMO: 
> we could give it a _wss or _working_set prefix/postfix?

So, to not drop your patch on the floor I've modified it as per 
the patch below.

The _wss() names signal that these handlers are used for a 
specific purpose, they are not related to the regular PROT_NONE 
handling code.

Agreed?

Thanks,

	Ingo

--------------->
>From 7e426e0f6ffe228118e57a70ae402e21792a0456 Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@redhat.com>
Date: Thu, 18 Oct 2012 17:20:21 -0400
Subject: [PATCH] numa, mm: Rename the PROT_NONE fault handling functions

Having the function name indicate what the function is used
for makes the code a little easier to read.  Furthermore,
the fault handling code largely consists of do_...._page
functions.

Rename the Working-Set Sampling (WSS) fault handling functions
to indicate what they are used for.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: aarcange@redhat.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/20121018172021.0b1f6e3d@cuia.bos.redhat.com
[ Changed the naming pattern to 'working-set sampling (WSS)' wss_() ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/huge_mm.h |  8 ++++----
 mm/huge_memory.c        |  4 ++--
 mm/memory.c             | 18 ++++++++++--------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bcbe467..93c6ab5 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -160,9 +160,9 @@ static inline struct page *compound_trans_head(struct page *page)
 	return page;
 }
 
-extern bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd);
+extern bool pmd_wss(struct vm_area_struct *vma, pmd_t pmd);
 
-extern void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+extern void do_huge_pmd_wss_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmd,
 				  unsigned int flags, pmd_t orig_pmd);
 
@@ -203,12 +203,12 @@ static inline int pmd_trans_huge_lock(pmd_t *pmd,
 	return 0;
 }
 
-static inline bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+static inline bool pmd_wss(struct vm_area_struct *vma, pmd_t pmd)
 {
 	return false;
 }
 
-static inline void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+static inline void do_huge_pmd_wss_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmd,
 				  unsigned int flags, pmd_t orig_pmd)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c58a5f0..982f678 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -727,7 +727,7 @@ out:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
-bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+bool pmd_wss(struct vm_area_struct *vma, pmd_t pmd)
 {
 	/*
 	 * See pte_prot_none().
@@ -738,7 +738,7 @@ bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
 	return pmd_same(pmd, pmd_modify(pmd, vma_prot_none(vma)));
 }
 
-void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+void do_huge_pmd_wss_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			   unsigned long address, pmd_t *pmd,
 			   unsigned int flags, pmd_t entry)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 2cc8a29..a3693e6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1471,11 +1471,13 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
-static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
+static bool pte_wss(struct vm_area_struct *vma, pte_t pte)
 {
 	/*
-	 * If we have the normal vma->vm_page_prot protections we're not a
-	 * 'special' PROT_NONE page.
+	 * For NUMA page faults, we use PROT_NONE ptes in VMAs with
+	 * "normal" vma->vm_page_prot protections.  Genuine PROT_NONE
+	 * VMAs should never get here, because the fault handling code
+	 * will notice that the VMA has no read or write permissions.
 	 *
 	 * This means we cannot get 'special' PROT_NONE faults from genuine
 	 * PROT_NONE maps, nor from PROT_WRITE file maps that do dirty
@@ -3476,7 +3478,7 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_wss_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pmd_t *pmd,
 			unsigned int flags, pte_t entry)
 {
@@ -3601,8 +3603,8 @@ int handle_pte_fault(struct mm_struct *mm,
 					pte, pmd, flags, entry);
 	}
 
-	if (pte_prot_none(vma, entry))
-		return do_prot_none(mm, vma, address, pte, pmd, flags, entry);
+	if (pte_wss(vma, entry))
+		return do_wss_page(mm, vma, address, pte, pmd, flags, entry);
 
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -3672,8 +3674,8 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
-			if (pmd_prot_none(vma, orig_pmd)) {
-				do_huge_pmd_prot_none(mm, vma, address, pmd,
+			if (pmd_wss(vma, orig_pmd)) {
+				do_huge_pmd_wss_page(mm, vma, address, pmd,
 						      flags, orig_pmd);
 			}
 
