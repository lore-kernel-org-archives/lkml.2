Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1BXOAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:00:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab1BXOAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mze+hk2wsngW6JR8Skhr6iBaitjJWUAsQYAwmGyvFhBlLJPz8m3bVAzBBaNlxqPwKu
         TS98IqmDAQzAEqwx2WRraJQpJZNqlmZOgCg1mjzC6VfAX8b68TXOaEFNPGc7LrKZ36N/
         /XWHzdd1Yx2dMU3+9+Coex78k5eGrTAsj6Anw=
Date: Thu, 24 Feb 2011 14:59:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] x86: Rename e820_table_* to pgt_buf_*
Message-ID: <20110224135955.GK7840@htj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <4D5C501E.50805@kernel.org>
 <20110216224416.GC29600@atj.dyndns.org>
 <20110217130526.GB27911@elte.hu>
 <20110217132435.GV19830@htj.dyndns.org>
 <20110217135628.GB7018@elte.hu>
 <4D5D48DA.6020908@kernel.org>
 <20110217161649.GD14168@elte.hu>
 <4D660701.3030805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D660701.3030805@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d1b19426b04787e48f2689923e28d37b488969b0 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 24 Feb 2011 14:46:24 +0100

e820_table_{start|end|top}, which are used to buffer page table
allocation during early boot, are now derived from memblock and don't
have much to do with e820.  Change the names so that they reflect what
they're used for.

This patch doesn't introduce any behavior change.

-v2: Ingo found that earlier patch "x86: Use early pre-allocated page
     table buffer top-down" caused crash on 32bit and needed to be
     dropped.  This patch was updated to reflect the change.

-tj: Updated commit description.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Committed to misc:x86-numa with description updated.  Thanks.

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
index b8054e0..286d289 100644
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
@@ -272,9 +272,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
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
index 5d43fa5..73ad7eb 100644
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
index 4f1f461..470cc47 100644
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

