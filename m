Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab0KLSBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50931 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932493Ab0KLSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:16 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 14/20] ARM: LPAE: use phys_addr_t instead of unsigned long for physical addresses
Date: Fri, 12 Nov 2010 18:00:34 +0000
Message-Id: <1289584840-18097-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:52.0750 (UTC) FILETIME=[8BCD92E0:01CB8293]
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
 arch/arm/mm/init.c                |    6 +++---
 arch/arm/mm/mmu.c                 |   12 +++++++-----
 7 files changed, 30 insertions(+), 25 deletions(-)

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
index fc19009..88ad892 100644
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
@@ -37,17 +39,17 @@ struct outer_cache_fns {
 
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
@@ -73,11 +75,11 @@ static inline void outer_disable(void)
 
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
 static inline void outer_flush_all(void) { }
 static inline void outer_inv_all(void) { }
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
index 41236f0..bfbfcbd 100644
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
index 5164069..14a00a1 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -344,7 +344,7 @@ void __init bootmem_init(void)
 	 */
 	arm_bootmem_free(min, max_low, max_high);
 
-	high_memory = __va((max_low << PAGE_SHIFT) - 1) + 1;
+	high_memory = __va(((phys_addr_t)max_low << PAGE_SHIFT) - 1) + 1;
 
 	/*
 	 * This doesn't seem to be used by the Linux memory manager any
@@ -392,8 +392,8 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
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
index 3784acc..b03e431 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -573,7 +573,7 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 }
 
 static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
-				      unsigned long end, unsigned long phys,
+				      unsigned long end, phys_addr_t phys,
 				      const struct mem_type *type)
 {
 	pmd_t *pmd = pmd_offset(pgd, addr);
@@ -609,11 +609,12 @@ static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
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
@@ -674,7 +675,8 @@ static void __init create_36bit_mapping(struct map_desc *md,
  */
 static void __init create_mapping(struct map_desc *md)
 {
-	unsigned long phys, addr, length, end;
+	unsigned long addr, length, end;
+	phys_addr_t phys;
 	const struct mem_type *type;
 	pgd_t *pgd;
 
@@ -705,7 +707,7 @@ static void __init create_mapping(struct map_desc *md)
 #endif
 
 	addr = md->virtual & PAGE_MASK;
-	phys = (unsigned long)__pfn_to_phys(md->pfn);
+	phys = __pfn_to_phys(md->pfn);
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 
 	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {
