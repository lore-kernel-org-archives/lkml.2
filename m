Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab2JRUvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24801 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/19] x86, mm: Remove early_memremap workaround for page table accessing on 64bit
Date: Thu, 18 Oct 2012 13:50:18 -0700
Message-Id: <1350593430-24470-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need that workaround anymore after patches that pre-map page
table buf and do not clear initial page table wrongly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |   38 ++++----------------------------------
 1 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7dfa69b..4e6873f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -340,36 +340,12 @@ static __ref void *alloc_low_page(unsigned long *phys)
 	} else
 		pfn = pgt_buf_end++;
 
-	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
+	adr = __va(pfn * PAGE_SIZE);
 	clear_page(adr);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }
 
-static __ref void *map_low_page(void *virt)
-{
-	void *adr;
-	unsigned long phys, left;
-
-	if (after_bootmem)
-		return virt;
-
-	phys = __pa(virt);
-	left = phys & (PAGE_SIZE - 1);
-	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
-	adr = (void *)(((unsigned long)adr) | left);
-
-	return adr;
-}
-
-static __ref void unmap_low_page(void *adr)
-{
-	if (after_bootmem)
-		return;
-
-	early_iounmap((void *)((unsigned long)adr & PAGE_MASK), PAGE_SIZE);
-}
-
 static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 	      pgprot_t prot)
@@ -441,10 +417,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
-				pte = map_low_page((pte_t *)pmd_page_vaddr(*pmd));
+				pte = (pte_t *)pmd_page_vaddr(*pmd);
 				last_map_addr = phys_pte_init(pte, address,
 								end, prot);
-				unmap_low_page(pte);
 				spin_unlock(&init_mm.page_table_lock);
 				continue;
 			}
@@ -480,7 +455,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 
 		pte = alloc_low_page(&pte_phys);
 		last_map_addr = phys_pte_init(pte, address, end, new_prot);
-		unmap_low_page(pte);
 
 		spin_lock(&init_mm.page_table_lock);
 		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
@@ -515,10 +489,9 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud)) {
-				pmd = map_low_page(pmd_offset(pud, 0));
+				pmd = pmd_offset(pud, 0);
 				last_map_addr = phys_pmd_init(pmd, addr, end,
 							 page_size_mask, prot);
-				unmap_low_page(pmd);
 				__flush_tlb_all();
 				continue;
 			}
@@ -555,7 +528,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		pmd = alloc_low_page(&pmd_phys);
 		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
 					      prot);
-		unmap_low_page(pmd);
 
 		spin_lock(&init_mm.page_table_lock);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
@@ -591,17 +563,15 @@ kernel_physical_mapping_init(unsigned long start,
 			next = end;
 
 		if (pgd_val(*pgd)) {
-			pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
+			pud = (pud_t *)pgd_page_vaddr(*pgd);
 			last_map_addr = phys_pud_init(pud, __pa(start),
 						 __pa(end), page_size_mask);
-			unmap_low_page(pud);
 			continue;
 		}
 
 		pud = alloc_low_page(&pud_phys);
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
 						 page_size_mask);
-		unmap_low_page(pud);
 
 		spin_lock(&init_mm.page_table_lock);
 		pgd_populate(&init_mm, pgd, __va(pud_phys));
-- 
1.7.7

