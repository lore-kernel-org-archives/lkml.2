Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2JRVVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998Ab2JRVVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:21:11 -0400
Date: Thu, 18 Oct 2012 17:20:21 -0400
From: Rik van Riel <riel@redhat.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, a.p.zijlstra@chello.nl
Subject: [PATCH 2/2] rename NUMA fault handling functions
Message-ID: <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
In-Reply-To: <20121018171821.7f1b1683@cuia.bos.redhat.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having the function name indicate what the function is used
for makes the code a little easier to read.  Furthermore,
the fault handling code largely consists of do_...._page
functions.

Rename the NUMA fault handling functions to indicate what
they are used for.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
Against tip.git numa/core

 include/linux/huge_mm.h |  8 ++++----
 mm/huge_memory.c        |  4 ++--
 mm/memory.c             | 18 ++++++++++--------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ed60d79..9580e22 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -161,9 +161,9 @@ static inline struct page *compound_trans_head(struct page *page)
 	return page;
 }
 
-extern bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd);
+extern bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd);
 
-extern void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+extern void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmd,
 				  unsigned int flags, pmd_t orig_pmd);
 
@@ -204,12 +204,12 @@ static inline int pmd_trans_huge_lock(pmd_t *pmd,
 	return 0;
 }
 
-static inline bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+static inline bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd)
 {
 	return false;
 }
 
-static inline void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+static inline void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmd,
 				  unsigned int flags, pmd_t orig_pmd)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5afd0d7..c25fd37 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -751,7 +751,7 @@ out:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
-bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd)
 {
 	/*
 	 * See pte_prot_none().
@@ -762,7 +762,7 @@ bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
 	return pmd_same(pmd, pmd_modify(pmd, vma_prot_none(vma)));
 }
 
-void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			   unsigned long address, pmd_t *pmd,
 			   unsigned int flags, pmd_t entry)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 9e56a44..c752379 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3425,11 +3425,13 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
+static bool pte_numa(struct vm_area_struct *vma, pte_t pte)
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
@@ -3444,7 +3446,7 @@ static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
 	return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
 }
 
-static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pmd_t *pmd,
 			unsigned int flags, pte_t entry)
 {
@@ -3541,8 +3543,8 @@ int handle_pte_fault(struct mm_struct *mm,
 					pte, pmd, flags, entry);
 	}
 
-	if (pte_prot_none(vma, entry))
-		return do_prot_none(mm, vma, address, pte, pmd, flags, entry);
+	if (pte_numa(vma, entry))
+		return do_numa_page(mm, vma, address, pte, pmd, flags, entry);
 
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -3612,8 +3614,8 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
-			if (pmd_prot_none(vma, orig_pmd)) {
-				do_huge_pmd_prot_none(mm, vma, address, pmd,
+			if (pmd_numa(vma, orig_pmd)) {
+				do_huge_pmd_numa_page(mm, vma, address, pmd,
 						      flags, orig_pmd);
 			}
 

