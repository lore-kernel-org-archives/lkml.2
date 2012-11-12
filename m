Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2KLVTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:19:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24696 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2KLVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 39/46] x86, mm: Unifying after_bootmem for 32bit and 64bit
Date: Mon, 12 Nov 2012 13:18:35 -0800
Message-Id: <1352755122-25660-40-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after_bootmem has different meaning in 32bit and 64bit.
        32bit: after bootmem is ready
        64bit: after bootmem is distroyed
Let's merget them make 32bit the same as 64bit.

for 32bit, it is mixing alloc_bootmem_pages, and alloc_low_page under
after_bootmem is set or not set.

alloc_bootmem is just wrapper for memblock for x86.

Now we have alloc_low_page() with memblock too. We can drop bootmem path
now, and only alloc_low_page only.

At the same time, we make alloc_low_page could handle real after_bootmem
for 32bit, because alloc_bootmem_pages could fallback to use slab too.

At last move after_bootmem set position for 32bit the same as 64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c    |    2 --
 arch/x86/mm/init_32.c |   21 ++++-----------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a0f579a..028a129 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,7 +35,6 @@ __ref void *alloc_low_pages(unsigned int num)
 	unsigned long pfn;
 	int i;
 
-#ifdef CONFIG_X86_64
 	if (after_bootmem) {
 		unsigned int order;
 
@@ -43,7 +42,6 @@ __ref void *alloc_low_pages(unsigned int num)
 		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_NOTRACK |
 						__GFP_ZERO, order);
 	}
-#endif
 
 	if ((pgt_buf_end + num) >= pgt_buf_top) {
 		unsigned long ret;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 19ef9f0..f4fc4a2 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -73,10 +73,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
-		if (after_bootmem)
-			pmd_table = (pmd_t *)alloc_bootmem_pages(PAGE_SIZE);
-		else
-			pmd_table = (pmd_t *)alloc_low_page();
+		pmd_table = (pmd_t *)alloc_low_page();
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
@@ -98,17 +95,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 static pte_t * __init one_page_table_init(pmd_t *pmd)
 {
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
-		pte_t *page_table = NULL;
-
-		if (after_bootmem) {
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
-#endif
-			if (!page_table)
-				page_table =
-				(pte_t *)alloc_bootmem_pages(PAGE_SIZE);
-		} else
-			page_table = (pte_t *)alloc_low_page();
+		pte_t *page_table = (pte_t *)alloc_low_page();
 
 		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
@@ -708,8 +695,6 @@ void __init setup_bootmem_allocator(void)
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
-
-	after_bootmem = 1;
 }
 
 /*
@@ -795,6 +780,8 @@ void __init mem_init(void)
 		if (page_is_ram(tmp) && PageReserved(pfn_to_page(tmp)))
 			reservedpages++;
 
+	after_bootmem = 1;
+
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-- 
1.7.7

