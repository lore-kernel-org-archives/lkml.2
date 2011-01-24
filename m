Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1AXR4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:56:38 -0500
Received: from service87.mimecast.com ([94.185.240.25]:51315 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754003Ab1AXR4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:30 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of unsigned long for physical addresses
Date: Mon, 24 Jan 2011 17:55:57 +0000
Message-Id: <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:14.0756 (UTC) FILETIME=[FE42CE40:01CBBBEF]
X-MC-Unique: 111012417562801701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OHvKGa031568

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
 arch/arm/include/asm/pgtable.h    |    2 +-
 arch/arm/include/asm/setup.h      |    2 +-
 arch/arm/kernel/setup.c           |    5 +++--
 arch/arm/mm/init.c                |    6 +++---
 arch/arm/mm/mmu.c                 |    7 ++++---
 7 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index d0ee74b..44ea5cd 100644
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
-static inline unsigned long virt_to_phys(const volatile void *x)
+static inline phys_addr_t virt_to_phys(const volatile void *x)
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
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 40b21c1..110f6f4 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -273,7 +273,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define pte_unmap(pte)			__pte_unmap(pte)
 
 #define pte_pfn(pte)		((pte_val(pte) & PHYS_MASK) >> PAGE_SHIFT)
-#define pfn_pte(pfn,prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
+#define pfn_pte(pfn,prot)	__pte(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define pte_page(pte)		pfn_to_page(pte_pfn(pte))
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page), prot)
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
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3d23f0f..fe951e4 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -443,7 +443,7 @@ static struct machine_desc * __init setup_machine(unsigned int nr)
 	return list;
 }
 
-static int __init arm_add_memory(unsigned long start, unsigned long size)
+static int __init arm_add_memory(phys_addr_t start, unsigned long size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
 
@@ -479,7 +479,8 @@ static int __init arm_add_memory(unsigned long start, unsigned long size)
 static int __init early_mem(char *p)
 {
 	static int usermem __initdata = 0;
-	unsigned long size, start;
+	unsigned long size;
+	phys_addr_t start;
 	char *endp;
 
 	/*
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
index 251056a..a1d8a07 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -611,7 +611,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 	pgd_t *pgd;
 
 	addr = md->virtual;
-	phys = (unsigned long)__pfn_to_phys(md->pfn);
+	phys = __pfn_to_phys(md->pfn);
 	length = PAGE_ALIGN(md->length);
 
 	if (!(cpu_architecture() >= CPU_ARCH_ARMv6 || cpu_is_xsc3())) {
@@ -672,7 +672,8 @@ static void __init create_36bit_mapping(struct map_desc *md,
  */
 static void __init create_mapping(struct map_desc *md)
 {
-	unsigned long phys, addr, length, end;
+	unsigned long addr, length, end;
+	phys_addr_t phys;
 	const struct mem_type *type;
 	pgd_t *pgd;
 
@@ -703,7 +704,7 @@ static void __init create_mapping(struct map_desc *md)
 #endif
 
 	addr = md->virtual & PAGE_MASK;
-	phys = (unsigned long)__pfn_to_phys(md->pfn);
+	phys = __pfn_to_phys(md->pfn);
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 
 	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {

