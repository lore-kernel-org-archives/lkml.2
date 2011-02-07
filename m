Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1BGXwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:52:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25139 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1BGXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:52:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/11] x86: Rename e820_table_* to pgt_buf_*
Date: Mon,  7 Feb 2011 15:17:09 -0800
Message-Id: <1297120632-24933-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D508583.0041,ss=1,fgs=0
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

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 36fb1a6..8dbe353 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -11,8 +11,8 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long page_size_mask);
 
 
-extern unsigned long __initdata e820_table_start;
-extern unsigned long __meminitdata e820_table_end;
-extern unsigned long __meminitdata e820_table_top;
+extern unsigned long __initdata pgt_buf_start;
+extern unsigned long __meminitdata pgt_buf_end;
+extern unsigned long __meminitdata pgt_buf_top;
 
 #endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a6b7a14..b5cd0df 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -18,9 +18,9 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-unsigned long __initdata e820_table_start;
-unsigned long __meminitdata e820_table_end;
-unsigned long __meminitdata e820_table_top;
+unsigned long __initdata pgt_buf_start;
+unsigned long __meminitdata pgt_buf_end;
+unsigned long __meminitdata pgt_buf_top;
 
 int after_bootmem;
 
@@ -73,12 +73,12 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
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
@@ -291,9 +291,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 #endif
 	__flush_tlb_all();
 
-	if (!after_bootmem && e820_table_end > e820_table_start)
-		memblock_x86_reserve_range(e820_table_start << PAGE_SHIFT,
-				 e820_table_end << PAGE_SHIFT, "PGTABLE");
+	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
 		early_memtest(start, end);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c821074..56b4e4a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -62,10 +62,10 @@ bool __read_mostly __vmalloc_start_set = false;
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = pgt_buf_end++;
 	void *adr;
 
-	if (pfn >= e820_table_top)
+	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
@@ -163,8 +163,8 @@ static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
 	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
 	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
 	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
-	    && ((__pa(pte) >> PAGE_SHIFT) < e820_table_start
-		|| (__pa(pte) >> PAGE_SHIFT) >= e820_table_end)) {
+	    && ((__pa(pte) >> PAGE_SHIFT) < pgt_buf_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= pgt_buf_end)) {
 		pte_t *newpte;
 		int i;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 194f273..e7b56f9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -314,7 +314,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = pgt_buf_end++;
 	void *adr;
 
 	if (after_bootmem) {
@@ -324,7 +324,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= e820_table_top)
+	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e92b61..13783a1 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1443,7 +1443,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	 * early_ioremap fixmap slot, make sure it is RO.
 	 */
 	if (!is_early_ioremap_ptep(ptep) &&
-	    pfn >= e820_table_start && pfn < e820_table_end)
+	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
 		pte = pte_wrprotect(pte);
 
 	return pte;
-- 
1.7.1

