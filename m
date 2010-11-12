Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab0KLSD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:03:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50909 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544Ab0KLSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:04 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 19/20] ARM: LPAE: define printk format for physical addresses and page table entries
Date: Fri, 12 Nov 2010 18:00:39 +0000
Message-Id: <1289584840-18097-20-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:55.0344 (UTC) FILETIME=[8D596300:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

Now that the Kernel supports 2 level and 3 level page tables, physical
addresses (and also page table entries) may be 32 or 64-bits depending
upon the configuration.

This patch adds a conversion specifier (PHYS_ADDR_FMT) which represents
a u32 or u64 depending on the width of a physical address.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/types.h |    6 ++++++
 arch/arm/kernel/setup.c      |    2 +-
 arch/arm/mm/fault.c          |    8 ++++----
 arch/arm/mm/mmu.c            |   18 +++++++++---------
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/types.h b/arch/arm/include/asm/types.h
index dc1bdbb..b740539 100644
--- a/arch/arm/include/asm/types.h
+++ b/arch/arm/include/asm/types.h
@@ -7,6 +7,12 @@
 
 #define BITS_PER_LONG 32
 
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+#define PHYS_ADDR_FMT	"%016llx"
+#else
+#define PHYS_ADDR_FMT	"%08x"
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0128db2..d143241 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -448,7 +448,7 @@ static int __init arm_add_memory(phys_addr_t start, unsigned long size)
 
 	if (meminfo.nr_banks >= NR_BANKS) {
 		printk(KERN_CRIT "NR_BANKS too low, "
-			"ignoring memory at %#lx\n", start);
+			"ignoring memory at " PHYS_ADDR_FMT "\n", start);
 		return -EINVAL;
 	}
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2dde9cd..8112f77 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -81,7 +81,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 	printk(KERN_ALERT "pgd = %p\n", mm->pgd);
 	pgd = pgd_offset(mm, addr);
-	printk(KERN_ALERT "[%08lx] *pgd=%08lx", addr, pgd_val(*pgd));
+	printk(KERN_ALERT "[%08lx] *pgd=" PHYS_ADDR_FMT, addr, pgd_val(*pgd));
 
 	do {
 		pmd_t *pmd;
@@ -97,7 +97,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pmd = pmd_offset(pgd, addr);
 		if (PTRS_PER_PMD != 1)
-			printk(", *pmd=%08lx", pmd_val(*pmd));
+			printk(", *pmd=" PHYS_ADDR_FMT, pmd_val(*pmd));
 
 		if (pmd_none(*pmd))
 			break;
@@ -112,9 +112,9 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 			break;
 
 		pte = pte_offset_map(pmd, addr);
-		printk(", *pte=%08lx", pte_val(*pte));
+		printk(", *pte=" PHYS_ADDR_FMT, pte_val(*pte));
 #ifndef CONFIG_ARM_LPAE
-		printk(", *ppte=%08lx", pte_val(pte[-LINUX_PTE_OFFSET]));
+		printk(", *ppte=" PHYS_ADDR_FMT, pte_val(pte[-LINUX_PTE_OFFSET]));
 #endif
 		pte_unmap(pte);
 	} while(0);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 787a409..f05f8ed 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -619,7 +619,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 
 	if (!(cpu_architecture() >= CPU_ARCH_ARMv6 || cpu_is_xsc3())) {
 		printk(KERN_ERR "MM: CPU does not support supersection "
-		       "mapping for 0x%08llx at 0x%08lx\n",
+		       "mapping for 0x" PHYS_ADDR_FMT " at 0x%08lx\n",
 		       __pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
@@ -632,14 +632,14 @@ static void __init create_36bit_mapping(struct map_desc *md,
 	 */
 	if (type->domain) {
 		printk(KERN_ERR "MM: invalid domain in supersection "
-		       "mapping for 0x%08llx at 0x%08lx\n",
+		       "mapping for 0x" PHYS_ADDR_FMT " at 0x%08lx\n",
 		       __pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
 	if ((addr | length | __pfn_to_phys(md->pfn)) & ~SUPERSECTION_MASK) {
-		printk(KERN_ERR "MM: cannot create mapping for "
-		       "0x%08llx at 0x%08lx invalid alignment\n",
+		printk(KERN_ERR "MM: cannot create mapping for 0x" PHYS_ADDR_FMT
+		       " at 0x%08lx invalid alignment\n",
 		       __pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
@@ -681,16 +681,16 @@ static void __init create_mapping(struct map_desc *md)
 	pgd_t *pgd;
 
 	if (md->virtual != vectors_base() && md->virtual < TASK_SIZE) {
-		printk(KERN_WARNING "BUG: not creating mapping for "
-		       "0x%08llx at 0x%08lx in user region\n",
+		printk(KERN_WARNING "BUG: not creating mapping for 0x"
+		       PHYS_ADDR_FMT " at 0x%08lx in user region\n",
 		       __pfn_to_phys((u64)md->pfn), md->virtual);
 		return;
 	}
 
 	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
 	    md->virtual >= PAGE_OFFSET && md->virtual < VMALLOC_END) {
-		printk(KERN_WARNING "BUG: mapping for 0x%08llx at 0x%08lx "
-		       "overlaps vmalloc space\n",
+		printk(KERN_WARNING "BUG: mapping for 0x" PHYS_ADDR_FMT
+		       " at 0x%08lx overlaps vmalloc space\n",
 		       __pfn_to_phys((u64)md->pfn), md->virtual);
 	}
 
@@ -711,7 +711,7 @@ static void __init create_mapping(struct map_desc *md)
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 
 	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {
-		printk(KERN_WARNING "BUG: map for 0x%08lx at 0x%08lx can not "
+		printk(KERN_WARNING "BUG: map for 0x" PHYS_ADDR_FMT " at 0x%08lx can not "
 		       "be mapped using pages, ignoring.\n",
 		       __pfn_to_phys(md->pfn), addr);
 		return;
