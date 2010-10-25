Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0JYJAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:00:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46502 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543Ab0JYJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:00:47 -0400
Subject: [RFC PATCH 12/18] ARM: LPAE: use phys_addr_t instead of unsigned
 long for physical addresses
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 10:00:41 +0100
Message-ID: <20101025090041.25275.44858.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 09:00:41.0659 (UTC) FILETIME=[19DA10B0:01CB7423]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

The unsigned long datatype is not sufficient for mapping physical addresses
>= 4GB.

This patch ensures that the phys_addr_t datatype is used to represent
physical addresses which may be beyond the range of an unsigned long.
The virt <-> phys macros are updated accordingly to ensure that virtual
addresses can remain as they are.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/memory.h     |   17 +++++++++--------
 arch/arm/include/asm/outercache.h |   14 ++++++++------
 arch/arm/include/asm/pgalloc.h    |    2 +-
 arch/arm/include/asm/pgtable.h    |    2 +-
 arch/arm/include/asm/setup.h      |    2 +-
 arch/arm/mm/init.c                |    9 +++++----
 arch/arm/mm/mmu.c                 |   12 +++++++-----
 7 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 23c2e8e..756252b 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -15,6 +15,7 @@
 
 #include <linux/compiler.h>
 #include <linux/const.h>
+#include <linux/types.h>
 #include <mach/memory.h>
 #include <asm/sizes.h>
 
@@ -138,15 +139,15 @@
  * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
  */
 #ifndef __virt_to_phys
-#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
-#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
+#define __virt_to_phys(x)	(((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET))
+#define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
 #endif
 
 /*
  * Convert a physical address to a Page Frame Number and back
  */
-#define	__phys_to_pfn(paddr)	((paddr) >> PAGE_SHIFT)
-#define	__pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
+#define	__phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
+#define	__pfn_to_phys(pfn)	((phys_addr_t)(pfn) << PAGE_SHIFT)
 
 /*
  * Convert a page to/from a physical address
@@ -188,21 +189,21 @@
  * translation for translating DMA addresses.  Use the driver
  * DMA support - see dma-mapping.h.
  */
-static inline unsigned long virt_to_phys(void *x)
+static inline phys_addr_t virt_to_phys(void *x)
 {
 	return __virt_to_phys((unsigned long)(x));
 }
 
-static inline void *phys_to_virt(unsigned long x)
+static inline void *phys_to_virt(phys_addr_t x)
 {
-	return (void *)(__phys_to_virt((unsigned long)(x)));
+	return (void *)(__phys_to_virt(x));
 }
 
 /*
  * Drivers should NOT use these either.
  */
 #define __pa(x)			__virt_to_phys((unsigned long)(x))
-#define __va(x)			((void *)__phys_to_virt((unsigned long)(x)))
+#define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
 /*
diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 25f76ba..9dc24e5 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -21,6 +21,8 @@
 #ifndef __ASM_OUTERCACHE_H
 #define __ASM_OUTERCACHE_H
 
+#include <linux/types.h>
+
 struct outer_cache_fns {
 	void (*inv_range)(unsigned long, unsigned long);
 	void (*clean_range)(unsigned long, unsigned long);
@@ -34,17 +36,17 @@ struct outer_cache_fns {
 
 extern struct outer_cache_fns outer_cache;
 
-static inline void outer_inv_range(unsigned long start, unsigned long end)
+static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
 {
 	if (outer_cache.inv_range)
 		outer_cache.inv_range(start, end);
 }
-static inline void outer_clean_range(unsigned long start, unsigned long end)
+static inline void outer_clean_range(phys_addr_t start, phys_addr_t end)
 {
 	if (outer_cache.clean_range)
 		outer_cache.clean_range(start, end);
 }
-static inline void outer_flush_range(unsigned long start, unsigned long end)
+static inline void outer_flush_range(phys_addr_t start, phys_addr_t end)
 {
 	if (outer_cache.flush_range)
 		outer_cache.flush_range(start, end);
@@ -52,11 +54,11 @@ static inline void outer_flush_range(unsigned long start, unsigned long end)
 
 #else
 
-static inline void outer_inv_range(unsigned long start, unsigned long end)
+static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
 { }
-static inline void outer_clean_range(unsigned long start, unsigned long end)
+static inline void outer_clean_range(phys_addr_t start, phys_addr_t end)
 { }
-static inline void outer_flush_range(unsigned long start, unsigned long end)
+static inline void outer_flush_range(phys_addr_t start, phys_addr_t end)
 { }
 
 #endif
diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index 64a303d..33761b8 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -159,7 +159,7 @@ pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 static inline void
 pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 {
-	__pmd_populate(pmdp, page_to_pfn(ptep) << PAGE_SHIFT | _PAGE_USER_TABLE);
+	__pmd_populate(pmdp, page_to_phys(ptep) | _PAGE_USER_TABLE);
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index b9851a1..d597841 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -130,7 +130,7 @@ extern struct page *empty_zero_page;
 #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
 #endif
 
-#define pfn_pte(pfn,prot)	(__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot)))
+#define pfn_pte(pfn,prot)	(__pte(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 
 #define pte_none(pte)		(!pte_val(pte))
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index f1e5a9b..5092118 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -199,7 +199,7 @@ static struct tagtable __tagtable_##fn __tag = { tag, fn }
 #endif
 
 struct membank {
-	unsigned long start;
+	phys_addr_t start;
 	unsigned long size;
 	unsigned int highmem;
 };
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 7185b00..641ffe0 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -174,7 +174,8 @@ static void __init arm_bootmem_init(struct meminfo *mi,
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
 		if (!bank->highmem)
-			free_bootmem(bank_phys_start(bank), bank_phys_size(bank));
+			free_bootmem((unsigned long)bank_phys_start(bank),
+				     bank_phys_size(bank));
 	}
 
 	/*
@@ -330,7 +331,7 @@ void __init bootmem_init(void)
 	 */
 	arm_bootmem_free(mi, min, max_low, max_high);
 
-	high_memory = __va((max_low << PAGE_SHIFT) - 1) + 1;
+	high_memory = __va(((phys_addr_t)max_low << PAGE_SHIFT) - 1) + 1;
 
 	/*
 	 * This doesn't seem to be used by the Linux memory manager any
@@ -378,8 +379,8 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 	 * Convert to physical addresses, and
 	 * round start upwards and end downwards.
 	 */
-	pg = PAGE_ALIGN(__pa(start_pg));
-	pgend = __pa(end_pg) & PAGE_MASK;
+	pg = (unsigned long)PAGE_ALIGN(__pa(start_pg));
+	pgend = (unsigned long)__pa(end_pg) & PAGE_MASK;
 
 	/*
 	 * If there are free pages between these,
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 42929fb..c060d82 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -576,7 +576,7 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 }
 
 static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
-				      unsigned long end, unsigned long phys,
+				      unsigned long end, phys_addr_t phys,
 				      const struct mem_type *type)
 {
 	pmd_t *pmd = pmd_offset(pgd, addr);
@@ -612,11 +612,12 @@ static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
 static void __init create_36bit_mapping(struct map_desc *md,
 					const struct mem_type *type)
 {
-	unsigned long phys, addr, length, end;
+	unsigned long addr, length, end;
+	phys_addr_t phys;
 	pgd_t *pgd;
 
 	addr = md->virtual;
-	phys = (unsigned long)__pfn_to_phys(md->pfn);
+	phys = __pfn_to_phys(md->pfn);
 	length = PAGE_ALIGN(md->length);
 
 	if (!(cpu_architecture() >= CPU_ARCH_ARMv6 || cpu_is_xsc3())) {
@@ -677,7 +678,8 @@ static void __init create_36bit_mapping(struct map_desc *md,
  */
 static void __init create_mapping(struct map_desc *md)
 {
-	unsigned long phys, addr, length, end;
+	unsigned long addr, length, end;
+	phys_addr_t phys;
 	const struct mem_type *type;
 	pgd_t *pgd;
 
@@ -708,7 +710,7 @@ static void __init create_mapping(struct map_desc *md)
 #endif
 
 	addr = md->virtual & PAGE_MASK;
-	phys = (unsigned long)__pfn_to_phys(md->pfn);
+	phys = __pfn_to_phys(md->pfn);
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 
 	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {

