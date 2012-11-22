Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2KVUti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:49:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919Ab2KVS6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:41 -0500
Date: Wed, 21 Nov 2012 18:00:18 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-973dc4f3fad5890bc7b694148ad4c825b9af6dc1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1353123563-3103-23-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-23-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Remove early_memremap workaround for page table accessing on 64bit
Git-Commit-ID: 973dc4f3fad5890bc7b694148ad4c825b9af6dc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:00:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  973dc4f3fad5890bc7b694148ad4c825b9af6dc1
Gitweb:     http://git.kernel.org/tip/973dc4f3fad5890bc7b694148ad4c825b9af6dc1
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:59 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:20 -0800

x86, mm: Remove early_memremap workaround for page table accessing on 64bit

We try to put page table high to make room for kdump, and at that time
those ranges are not mapped yet, and have to use ioremap to access it.

Now after patch that pre-map page table top down.
	x86, mm: setup page table in top-down
We do not need that workaround anymore.

Just use __va to return directly mapping address.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-23-git-send-email-yinghai@kernel.org
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_64.c | 38 ++++----------------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index eefaea6..5ee9242 100644
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
@@ -442,10 +418,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
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
@@ -483,7 +458,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 
 		pte = alloc_low_page(&pte_phys);
 		last_map_addr = phys_pte_init(pte, address, end, new_prot);
-		unmap_low_page(pte);
 
 		spin_lock(&init_mm.page_table_lock);
 		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
@@ -518,10 +492,9 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
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
@@ -560,7 +533,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		pmd = alloc_low_page(&pmd_phys);
 		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
 					      prot);
-		unmap_low_page(pmd);
 
 		spin_lock(&init_mm.page_table_lock);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
@@ -596,17 +568,15 @@ kernel_physical_mapping_init(unsigned long start,
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
