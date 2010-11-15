Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab0KORkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:40:51 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49279 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933139Ab0KORkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:40:49 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 03/20] ARM: LPAE: use long long format when printing physical addresses and ptes
Date: Mon, 15 Nov 2010 17:40:12 +0000
Message-Id: <1289842829-3027-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 15 Nov 2010 17:40:34.0144 (UTC) FILETIME=[34B24E00:01CB84EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

Now that the Kernel supports 2 level and 3 level page tables, physical
addresses (and also page table entries) may be 32 or 64-bits depending
upon the configuration.

This patch uses the %08llx conversion specifier for physical addresses
and page table entries, ensuring that they are cast to (long long) so
that common code can be used regardless of the datatype widths.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgtable.h |    6 +++---
 arch/arm/kernel/setup.c        |    2 +-
 arch/arm/kernel/traps.c        |   12 ++++++------
 arch/arm/mm/fault.c            |   10 ++++++----
 arch/arm/mm/mmu.c              |   30 +++++++++++++++---------------
 5 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 17e7ba6..e716147 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -45,9 +45,9 @@
 #define LIBRARY_TEXT_START	0x0c000000
 
 #ifndef __ASSEMBLY__
-extern void __pte_error(const char *file, int line, unsigned long val);
-extern void __pmd_error(const char *file, int line, unsigned long val);
-extern void __pgd_error(const char *file, int line, unsigned long val);
+extern void __pte_error(const char *file, int line, pteval_t val);
+extern void __pmd_error(const char *file, int line, pteval_t val);
+extern void __pgd_error(const char *file, int line, pteval_t val);
 
 #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
 #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3cadb46..81ab007 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -448,7 +448,7 @@ static int __init arm_add_memory(unsigned long start, unsigned long size)
 
 	if (meminfo.nr_banks >= NR_BANKS) {
 		printk(KERN_CRIT "NR_BANKS too low, "
-			"ignoring memory at %#lx\n", start);
+			"ignoring memory at %#08llx\n", (long long)start);
 		return -EINVAL;
 	}
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 87abca0..cdf3d86 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -713,19 +713,19 @@ void __readwrite_bug(const char *fn)
 }
 EXPORT_SYMBOL(__readwrite_bug);
 
-void __pte_error(const char *file, int line, unsigned long val)
+void __pte_error(const char *file, int line, pteval_t val)
 {
-	printk("%s:%d: bad pte %08lx.\n", file, line, val);
+	printk("%s:%d: bad pte %08llx.\n", file, line, (long long)val);
 }
 
-void __pmd_error(const char *file, int line, unsigned long val)
+void __pmd_error(const char *file, int line, pteval_t val)
 {
-	printk("%s:%d: bad pmd %08lx.\n", file, line, val);
+	printk("%s:%d: bad pmd %08llx.\n", file, line, (long long)val);
 }
 
-void __pgd_error(const char *file, int line, unsigned long val)
+void __pgd_error(const char *file, int line, pteval_t val)
 {
-	printk("%s:%d: bad pgd %08lx.\n", file, line, val);
+	printk("%s:%d: bad pgd %08llx.\n", file, line, (long long)val);
 }
 
 asmlinkage void __div0(void)
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 1e21e12..a6eb56b 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -76,7 +76,8 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 	printk(KERN_ALERT "pgd = %p\n", mm->pgd);
 	pgd = pgd_offset(mm, addr);
-	printk(KERN_ALERT "[%08lx] *pgd=%08lx", addr, pgd_val(*pgd));
+	printk(KERN_ALERT "[%08lx] *pgd=%08llx",
+			addr, (long long)pgd_val(*pgd));
 
 	do {
 		pmd_t *pmd;
@@ -92,7 +93,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pmd = pmd_offset(pgd, addr);
 		if (PTRS_PER_PMD != 1)
-			printk(", *pmd=%08lx", pmd_val(*pmd));
+			printk(", *pmd=%08llx", (long long)pmd_val(*pmd));
 
 		if (pmd_none(*pmd))
 			break;
@@ -107,8 +108,9 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 			break;
 
 		pte = pte_offset_map(pmd, addr);
-		printk(", *pte=%08lx", pte_val(*pte));
-		printk(", *ppte=%08lx", pte_val(pte[-PTRS_PER_PTE]));
+		printk(", *pte=%08llx", (long long)pte_val(*pte));
+		printk(", *ppte=%08llx",
+			(long long)pte_val(pte[-PTRS_PER_PTE]));
 		pte_unmap(pte);
 	} while(0);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 5e3adca..c2e74b5 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -598,8 +598,8 @@ static void __init create_36bit_mapping(struct map_desc *md,
 
 	if (!(cpu_architecture() >= CPU_ARCH_ARMv6 || cpu_is_xsc3())) {
 		printk(KERN_ERR "MM: CPU does not support supersection "
-		       "mapping for 0x%08llx at 0x%08lx\n",
-		       __pfn_to_phys((u64)md->pfn), addr);
+		       "mapping for %#08llx at %#08lx\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
@@ -611,15 +611,15 @@ static void __init create_36bit_mapping(struct map_desc *md,
 	 */
 	if (type->domain) {
 		printk(KERN_ERR "MM: invalid domain in supersection "
-		       "mapping for 0x%08llx at 0x%08lx\n",
-		       __pfn_to_phys((u64)md->pfn), addr);
+		       "mapping for %#08llx at %#08lx\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
 	if ((addr | length | __pfn_to_phys(md->pfn)) & ~SUPERSECTION_MASK) {
-		printk(KERN_ERR "MM: cannot create mapping for "
-		       "0x%08llx at 0x%08lx invalid alignment\n",
-		       __pfn_to_phys((u64)md->pfn), addr);
+		printk(KERN_ERR "MM: cannot create mapping for %#08llx"
+		       " at %#08lx invalid alignment\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
@@ -658,17 +658,17 @@ static void __init create_mapping(struct map_desc *md)
 	pgd_t *pgd;
 
 	if (md->virtual != vectors_base() && md->virtual < TASK_SIZE) {
-		printk(KERN_WARNING "BUG: not creating mapping for "
-		       "0x%08llx at 0x%08lx in user region\n",
-		       __pfn_to_phys((u64)md->pfn), md->virtual);
+		printk(KERN_WARNING "BUG: not creating mapping for %#08llx"
+		       " at %#08lx in user region\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), md->virtual);
 		return;
 	}
 
 	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
 	    md->virtual >= PAGE_OFFSET && md->virtual < VMALLOC_END) {
-		printk(KERN_WARNING "BUG: mapping for 0x%08llx at 0x%08lx "
-		       "overlaps vmalloc space\n",
-		       __pfn_to_phys((u64)md->pfn), md->virtual);
+		printk(KERN_WARNING "BUG: mapping for %#08llx"
+		       " at %#08lx overlaps vmalloc space\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), md->virtual);
 	}
 
 	type = &mem_types[md->type];
@@ -686,9 +686,9 @@ static void __init create_mapping(struct map_desc *md)
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 
 	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {
-		printk(KERN_WARNING "BUG: map for 0x%08lx at 0x%08lx can not "
+		printk(KERN_WARNING "BUG: map for %#08llx at %#08lx can not "
 		       "be mapped using pages, ignoring.\n",
-		       __pfn_to_phys(md->pfn), addr);
+		       (long long)__pfn_to_phys(md->pfn), addr);
 		return;
 	}
 
