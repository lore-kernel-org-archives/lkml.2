Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0L3Vzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 16:55:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:29232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0L3Vzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 16:55:38 -0500
Message-ID: <4D1CFF9A.9050002@kernel.org>
Date: Thu, 30 Dec 2010 13:54:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 6/6] x86: Rename e820_table_* to pgt_buf_*
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933E5.9000300@kernel.org>
In-Reply-To: <4D1933E5.9000300@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now it is found from memblock way.

Change the name to purpose related.

-v2: Ingo found "4/6 x86: Use early pre-allocated page table buffer top-down"
     cause 32bit crash.
     and need to drop it, So update this one accordingly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/init.h |    6 +++---
 arch/x86/mm/init.c          |   20 ++++++++++----------
 arch/x86/mm/init_32.c       |    8 ++++----
 arch/x86/mm/init_64.c       |    4 ++--
 arch/x86/xen/mmu.c          |    2 +-
 5 files changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/x86/include/asm/init.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/init.h
+++ linux-2.6/arch/x86/include/asm/init.h
@@ -11,8 +11,8 @@ kernel_physical_mapping_init(unsigned lo
 			     unsigned long page_size_mask);
 
 
-extern unsigned long __initdata e820_table_start;
-extern unsigned long __meminitdata e820_table_end;
-extern unsigned long __meminitdata e820_table_top;
+extern unsigned long __initdata pgt_buf_start;
+extern unsigned long __meminitdata pgt_buf_end;
+extern unsigned long __meminitdata pgt_buf_top;
 
 #endif /* _ASM_X86_INIT_32_H */
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -18,9 +18,9 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-unsigned long __initdata e820_table_start;
-unsigned long __meminitdata e820_table_end;
-unsigned long __meminitdata e820_table_top;
+unsigned long __initdata pgt_buf_start;
+unsigned long __meminitdata pgt_buf_end;
+unsigned long __meminitdata pgt_buf_top;
 
 int after_bootmem;
 
@@ -73,12 +73,12 @@ static void __init find_early_table_spac
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
-	e820_table_start = base >> PAGE_SHIFT;
-	e820_table_end = e820_table_start;
-	e820_table_top = e820_table_start + (tables >> PAGE_SHIFT);
+	pgt_buf_start = base >> PAGE_SHIFT;
+	pgt_buf_end = pgt_buf_start;
+	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, e820_table_start << PAGE_SHIFT, e820_table_top << PAGE_SHIFT);
+		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
 struct map_range {
@@ -272,9 +272,9 @@ unsigned long __init_refok init_memory_m
 
 	__flush_tlb_all();
 
-	if (!after_bootmem && e820_table_end > e820_table_start)
-		memblock_x86_reserve_range(e820_table_start << PAGE_SHIFT,
-				 e820_table_end << PAGE_SHIFT, "PGTABLE");
+	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
 		early_memtest(start, end);
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -61,10 +61,10 @@ bool __read_mostly __vmalloc_start_set =
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = pgt_buf_end++;
 	void *adr;
 
-	if (pfn >= e820_table_top)
+	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
@@ -162,8 +162,8 @@ static pte_t *__init page_table_kmap_che
 	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
 	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
 	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
-	    && ((__pa(pte) >> PAGE_SHIFT) < e820_table_start
-		|| (__pa(pte) >> PAGE_SHIFT) >= e820_table_end)) {
+	    && ((__pa(pte) >> PAGE_SHIFT) < pgt_buf_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= pgt_buf_end)) {
 		pte_t *newpte;
 		int i;
 
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -314,7 +314,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = pgt_buf_end++;
 	void *adr;
 
 	if (after_bootmem) {
@@ -324,7 +324,7 @@ static __ref void *alloc_low_page(unsign
 		return adr;
 	}
 
-	if (pfn >= e820_table_top)
+	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c
+++ linux-2.6/arch/x86/xen/mmu.c
@@ -1807,7 +1807,7 @@ static __init pte_t mask_rw_pte(pte_t *p
 	 * early_ioremap fixmap slot, make sure it is RO.
 	 */
 	if (!is_early_ioremap_ptep(ptep) &&
-	    pfn >= e820_table_start && pfn < e820_table_end)
+	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
 		pte = pte_wrprotect(pte);
 
 	return pte;
