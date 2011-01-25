Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1AYR5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:57:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1AYR5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:57:21 -0500
Date: Tue, 25 Jan 2011 18:57:06 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, ryomov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: (not so much) Fun with THP
Message-ID: <20110125175706.GE926@random.random>
References: <0d30dc$krvjbc@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$krvjbc@orsmga001.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:58:30PM +0000, Chris Wilson wrote:
> On the one F15 box I've dared enable THP with, it hasn't succeeded in
> booting (with or without KMS).  First it OOMed during lvm:

Sorry, for x86_32 there was some issue, below is all you need, thanks!

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 2071a8b..ebbc4d8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -558,13 +558,12 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-#if PAGETABLE_LEVELS >= 3
 	if (sizeof(pmdval_t) > sizeof(long))
 		/* 5 arg words */
 		pv_mmu_ops.set_pmd_at(mm, addr, pmdp, pmd);
 	else
-		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp, pmd.pmd);
-#endif
+		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp,
+			    native_pmd_val(pmd));
 }
 #endif
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 3ad483b..e9c0c61 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -179,7 +179,7 @@ config SPLIT_PTLOCK_CPUS
 config COMPACTION
 	bool "Allow for memory compaction"
 	select MIGRATION
-	depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
+	depends on MMU
 	help
 	  Allows the compaction of memory for the allocation of huge pages.
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 004c9c2..c4f634b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1837,9 +1837,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 	spin_lock(ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
 	spin_unlock(ptl);
-	pte_unmap(pte);
 
 	if (unlikely(!isolated)) {
+		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
 		set_pmd_at(mm, address, pmd, _pmd);
@@ -1856,6 +1856,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	anon_vma_unlock(vma->anon_vma);
 
 	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
+	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 	VM_BUG_ON(page_count(pgtable) != 1);
