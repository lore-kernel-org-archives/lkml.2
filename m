Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2JUPUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:20:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2JUPUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:20:34 -0400
Date: Sun, 21 Oct 2012 08:20:13 -0700
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-2458840fddea542391d343dac734d149607db709@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
References: <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, mm:
  Rename the PROT_NONE fault handling functions to *_numa()
Git-Commit-ID: 2458840fddea542391d343dac734d149607db709
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 08:20:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2458840fddea542391d343dac734d149607db709
Gitweb:     http://git.kernel.org/tip/2458840fddea542391d343dac734d149607db709
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 18 Oct 2012 17:20:21 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Oct 2012 15:41:26 +0200

numa, mm: Rename the PROT_NONE fault handling functions to *_numa()

Having the function name indicate what the function is used
for makes the code a little easier to read.  Furthermore,
the fault handling code largely consists of do_...._page
functions.

Rename the NUMA working set sampling fault handling functions
to _numa() names, to indicate what they are used for.

This separates the naming from the regular PROT_NONE namings.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: aarcange@redhat.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/20121018172021.0b1f6e3d@cuia.bos.redhat.com
[ Converted two more usage sites ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/huge_mm.h |    8 ++++----
 mm/huge_memory.c        |    4 ++--
 mm/memory.c             |   22 ++++++++++++----------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bcbe467..4f0f948 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -160,9 +160,9 @@ static inline struct page *compound_trans_head(struct page *page)
 	return page;
 }
 
-extern bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd);
+extern bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd);
 
-extern void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+extern void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmd,
 				  unsigned int flags, pmd_t orig_pmd);
 
@@ -203,12 +203,12 @@ static inline int pmd_trans_huge_lock(pmd_t *pmd,
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
index c58a5f0..a8f6531 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -727,7 +727,7 @@ out:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
-bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
+bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd)
 {
 	/*
 	 * See pte_prot_none().
@@ -738,7 +738,7 @@ bool pmd_prot_none(struct vm_area_struct *vma, pmd_t pmd)
 	return pmd_same(pmd, pmd_modify(pmd, vma_prot_none(vma)));
 }
 
-void do_huge_pmd_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			   unsigned long address, pmd_t *pmd,
 			   unsigned int flags, pmd_t entry)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 2cc8a29..23d4bd4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1471,11 +1471,13 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
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
@@ -1543,7 +1545,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
 		goto out;
 	}
-	if ((flags & FOLL_NUMA) && pmd_prot_none(vma, *pmd))
+	if ((flags & FOLL_NUMA) && pmd_numa(vma, *pmd))
 		goto no_page_table;
 	if (pmd_trans_huge(*pmd)) {
 		if (flags & FOLL_SPLIT) {
@@ -1574,7 +1576,7 @@ split_fallthrough:
 	pte = *ptep;
 	if (!pte_present(pte))
 		goto no_page;
-	if ((flags & FOLL_NUMA) && pte_prot_none(vma, pte))
+	if ((flags & FOLL_NUMA) && pte_numa(vma, pte))
 		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
@@ -3476,7 +3478,7 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-static int do_prot_none(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pmd_t *pmd,
 			unsigned int flags, pte_t entry)
 {
@@ -3601,8 +3603,8 @@ int handle_pte_fault(struct mm_struct *mm,
 					pte, pmd, flags, entry);
 	}
 
-	if (pte_prot_none(vma, entry))
-		return do_prot_none(mm, vma, address, pte, pmd, flags, entry);
+	if (pte_numa(vma, entry))
+		return do_numa_page(mm, vma, address, pte, pmd, flags, entry);
 
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -3672,8 +3674,8 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
-			if (pmd_prot_none(vma, orig_pmd)) {
-				do_huge_pmd_prot_none(mm, vma, address, pmd,
+			if (pmd_numa(vma, orig_pmd)) {
+				do_huge_pmd_numa_page(mm, vma, address, pmd,
 						      flags, orig_pmd);
 			}
 
