Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0JYI7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:59:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46302 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977Ab0JYI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:59:44 -0400
Subject: [RFC PATCH 01/18] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of
 PGDIR_*
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 09:59:39 +0100
Message-ID: <20101025085939.25275.19510.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 08:59:39.0724 (UTC) FILETIME=[F4EF88C0:01CB7422]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PGDIR_SHIFT and PMD_SHIFT for the classic 2-level page table format have
the same value (21). This patch converts the PGDIR_* uses in the kernel
to the PMD_* equivalent.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/module.c  |    2 +-
 arch/arm/kernel/smp.c     |    2 +-
 arch/arm/mm/dma-mapping.c |    6 +++---
 arch/arm/mm/mmu.c         |   16 ++++++++--------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 6b46058..edeba88 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -32,7 +32,7 @@
  * recompiling the whole kernel when CONFIG_XIP_KERNEL is turned on/off.
  */
 #undef MODULES_VADDR
-#define MODULES_VADDR	(((unsigned long)_etext + ~PGDIR_MASK) & PGDIR_MASK)
+#define MODULES_VADDR	(((unsigned long)_etext + ~PMD_MASK) & PMD_MASK)
 #endif
 
 #ifdef CONFIG_MMU
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 40dc74f..fde5497 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -102,7 +102,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	 */
 	pgd = pgd_alloc(&init_mm);
 	pmd = pmd_offset(pgd + pgd_index(PHYS_OFFSET), PHYS_OFFSET);
-	*pmd = __pmd((PHYS_OFFSET & PGDIR_MASK) |
+	*pmd = __pmd((PHYS_OFFSET & PMD_MASK) |
 		     PMD_TYPE_SECT | PMD_SECT_AP_WRITE);
 	flush_pmd_entry(pmd);
 	outer_clean_range(__pa(pmd), __pa(pmd + 1));
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e4dd064..2aab1b4 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -120,8 +120,8 @@ static void __dma_free_buffer(struct page *page, size_t size)
 #endif
 
 #define CONSISTENT_OFFSET(x)	(((unsigned long)(x) - CONSISTENT_BASE) >> PAGE_SHIFT)
-#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - CONSISTENT_BASE) >> PGDIR_SHIFT)
-#define NUM_CONSISTENT_PTES (CONSISTENT_DMA_SIZE >> PGDIR_SHIFT)
+#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - CONSISTENT_BASE) >> PMD_SHIFT)
+#define NUM_CONSISTENT_PTES (CONSISTENT_DMA_SIZE >> PMD_SHIFT)
 
 /*
  * These are the page tables (2MB each) covering uncached, DMA consistent allocations
@@ -171,7 +171,7 @@ static int __init consistent_init(void)
 		}
 
 		consistent_pte[i++] = pte;
-		base += (1 << PGDIR_SHIFT);
+		base += (1 << PMD_SHIFT);
 	} while (base < CONSISTENT_END);
 
 	return ret;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 846d293..56df812 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -861,14 +861,14 @@ static inline void prepare_page_table(void)
 	/*
 	 * Clear out all the mappings below the kernel image.
 	 */
-	for (addr = 0; addr < MODULES_VADDR; addr += PGDIR_SIZE)
+	for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 #ifdef CONFIG_XIP_KERNEL
 	/* The XIP kernel is mapped in the module area -- skip over it */
-	addr = ((unsigned long)_etext + PGDIR_SIZE - 1) & PGDIR_MASK;
+	addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
 #endif
-	for ( ; addr < PAGE_OFFSET; addr += PGDIR_SIZE)
+	for ( ; addr < PAGE_OFFSET; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
@@ -876,7 +876,7 @@ static inline void prepare_page_table(void)
 	 * memory bank, up to the end of the vmalloc region.
 	 */
 	for (addr = __phys_to_virt(bank_phys_end(&meminfo.bank[0]));
-	     addr < VMALLOC_END; addr += PGDIR_SIZE)
+	     addr < VMALLOC_END; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 }
 
@@ -917,7 +917,7 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 	 */
 	vectors_page = early_alloc(PAGE_SIZE);
 
-	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
+	for (addr = VMALLOC_END; addr; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
@@ -1075,12 +1075,12 @@ void setup_mm_for_reboot(char mode)
 		base_pmdval |= PMD_BIT4;
 
 	for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
-		unsigned long pmdval = (i << PGDIR_SHIFT) | base_pmdval;
+		unsigned long pmdval = (i << PMD_SHIFT) | base_pmdval;
 		pmd_t *pmd;
 
-		pmd = pmd_off(pgd, i << PGDIR_SHIFT);
+		pmd = pmd_off(pgd, i << PMD_SHIFT);
 		pmd[0] = __pmd(pmdval);
-		pmd[1] = __pmd(pmdval + (1 << (PGDIR_SHIFT - 1)));
+		pmd[1] = __pmd(pmdval + (1 << (PMD_SHIFT - 1)));
 		flush_pmd_entry(pmd);
 	}
 

