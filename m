Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab2EWImY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:42:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37949 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab2EWImR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:42:17 -0400
Date: Wed, 23 May 2012 10:42:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.5
Message-ID: <20120523084209.GA18663@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   HEAD: 20167d3421a089a1bf1bd680b150dc69c9506810 x86-64: Fix accounting in kernel_physical_mapping_init()

This tree includes a micro-optimization that avoids cr3 switches 
during idling; it fixes corner cases and there's also small 
cleanups.

 Thanks,

	Ingo

------------------>
Alex Shi (1):
      x86/tlb: Clean up and unify TLB_FLUSH_ALL definition

Jan Beulich (1):
      x86-64: Fix accounting in kernel_physical_mapping_init()

Sam Ravnborg (1):
      x86: Drop obsolete ARCH_BOOTMEM support

Suresh Siddha (1):
      x86, tlb: Switch cr3 in leave_mm() only when needed

WANG Cong (1):
      x86/mm: Fix the size calculation of mapping tables


 arch/x86/Kconfig                 |  4 ----
 arch/x86/include/asm/mmzone_32.h |  6 ------
 arch/x86/include/asm/tlbflush.h  |  6 +-----
 arch/x86/mm/init.c               | 21 ++++++++++++---------
 arch/x86/mm/init_64.c            | 23 +++++++++++++----------
 arch/x86/mm/tlb.c                |  8 +++++---
 6 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..a105ee7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1255,10 +1255,6 @@ config NODES_SHIFT
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
 
-config HAVE_ARCH_BOOTMEM
-	def_bool y
-	depends on X86_32 && NUMA
-
 config HAVE_ARCH_ALLOC_REMAP
 	def_bool y
 	depends on X86_32 && NUMA
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 55728e1..eb05fb3 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -61,10 +61,4 @@ static inline int pfn_valid(int pfn)
 
 #endif /* CONFIG_DISCONTIGMEM */
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-/* always use node 0 for bootmem on this numa platform */
-#define bootmem_arch_preferred_node(__bdata, size, align, goal, limit)	\
-	(NODE_DATA(0)->bdata)
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
-
 #endif /* _ASM_X86_MMZONE_32_H */
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 169be89..63af909 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,11 +62,7 @@ static inline void __flush_tlb_one(unsigned long addr)
 		__flush_tlb();
 }
 
-#ifdef CONFIG_X86_32
-# define TLB_FLUSH_ALL	0xffffffff
-#else
-# define TLB_FLUSH_ALL	-1ULL
-#endif
+#define TLB_FLUSH_ALL	-1UL
 
 /*
  * TLB flushing:
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6cabf65..2e92fdc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -30,8 +30,14 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+static void __init find_early_table_space(struct map_range *mr, unsigned long end,
+					  int use_pse, int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -56,6 +62,9 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
 #endif
+		/* The first 2/4M doesn't use large pages. */
+		extra += mr->end - mr->start;
+
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -85,12 +94,6 @@ void __init native_pagetable_reserve(u64 start, u64 end)
 	memblock_reserve(start, end - start);
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -262,7 +265,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 436a030..f9476a0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -408,12 +408,12 @@ static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	      unsigned long page_size_mask, pgprot_t prot)
 {
-	unsigned long pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 
 	int i = pmd_index(address);
 
-	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
+	for (; i < PTRS_PER_PMD; i++, address = next) {
 		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
@@ -427,6 +427,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			break;
 		}
 
+		next = (address & PMD_MASK) + PMD_SIZE;
+
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
@@ -450,7 +452,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_2M)) {
-				pages++;
+				last_map_addr = next;
 				continue;
 			}
 			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
@@ -463,7 +465,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 				pfn_pte(address >> PAGE_SHIFT,
 					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
 			spin_unlock(&init_mm.page_table_lock);
-			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
+			last_map_addr = next;
 			continue;
 		}
 
@@ -483,11 +485,11 @@ static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 unsigned long page_size_mask)
 {
-	unsigned long pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 	int i = pud_index(addr);
 
-	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE) {
+	for (; i < PTRS_PER_PUD; i++, addr = next) {
 		unsigned long pmd_phys;
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
@@ -496,8 +498,9 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		if (addr >= end)
 			break;
 
-		if (!after_bootmem &&
-				!e820_any_mapped(addr, addr+PUD_SIZE, 0)) {
+		next = (addr & PUD_MASK) + PUD_SIZE;
+
+		if (!after_bootmem && !e820_any_mapped(addr, next, 0)) {
 			set_pud(pud, __pud(0));
 			continue;
 		}
@@ -524,7 +527,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_1G)) {
-				pages++;
+				last_map_addr = next;
 				continue;
 			}
 			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
@@ -536,7 +539,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			spin_unlock(&init_mm.page_table_lock);
-			last_map_addr = (addr & PUD_MASK) + PUD_SIZE;
+			last_map_addr = next;
 			continue;
 		}
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..125bcad 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -61,11 +61,13 @@ static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
  */
 void leave_mm(int cpu)
 {
+	struct mm_struct *active_mm = percpu_read(cpu_tlbstate.active_mm);
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
-	cpumask_clear_cpu(cpu,
-			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
-	load_cr3(swapper_pg_dir);
+	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
+		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
+		load_cr3(swapper_pg_dir);
+	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
 
