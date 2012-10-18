Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2JRUvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42637 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/19] x86, mm: Remove parameter in alloc_low_page for 64bit
Date: Thu, 18 Oct 2012 13:50:19 -0700
Message-Id: <1350593430-24470-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all page table buf are pre-mapped, and could use virtual address directly.
So don't need to remember physics address anymore.

Remove that phys pointer in alloc_low_page(), and that will allow us to merge
alloc_low_page between 64bit and 32bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4e6873f..cbf8dbe 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -314,14 +314,13 @@ void __init cleanup_highmap(void)
 	}
 }
 
-static __ref void *alloc_low_page(unsigned long *phys)
+static __ref void *alloc_low_page(void)
 {
 	unsigned long pfn;
 	void *adr;
 
 	if (after_bootmem) {
 		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
-		*phys = __pa(adr);
 
 		return adr;
 	}
@@ -342,7 +341,6 @@ static __ref void *alloc_low_page(unsigned long *phys)
 
 	adr = __va(pfn * PAGE_SIZE);
 	clear_page(adr);
-	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }
 
@@ -400,7 +398,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address = next) {
-		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
 		pgprot_t new_prot = prot;
@@ -453,11 +450,11 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			continue;
 		}
 
-		pte = alloc_low_page(&pte_phys);
+		pte = alloc_low_page();
 		last_map_addr = phys_pte_init(pte, address, end, new_prot);
 
 		spin_lock(&init_mm.page_table_lock);
-		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
+		pmd_populate_kernel(&init_mm, pmd, pte);
 		spin_unlock(&init_mm.page_table_lock);
 	}
 	update_page_count(PG_LEVEL_2M, pages);
@@ -473,7 +470,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 	int i = pud_index(addr);
 
 	for (; i < PTRS_PER_PUD; i++, addr = next) {
-		unsigned long pmd_phys;
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
 		pgprot_t prot = PAGE_KERNEL;
@@ -525,12 +521,12 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			continue;
 		}
 
-		pmd = alloc_low_page(&pmd_phys);
+		pmd = alloc_low_page();
 		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
 					      prot);
 
 		spin_lock(&init_mm.page_table_lock);
-		pud_populate(&init_mm, pud, __va(pmd_phys));
+		pud_populate(&init_mm, pud, pmd);
 		spin_unlock(&init_mm.page_table_lock);
 	}
 	__flush_tlb_all();
@@ -555,7 +551,6 @@ kernel_physical_mapping_init(unsigned long start,
 
 	for (; start < end; start = next) {
 		pgd_t *pgd = pgd_offset_k(start);
-		unsigned long pud_phys;
 		pud_t *pud;
 
 		next = (start + PGDIR_SIZE) & PGDIR_MASK;
@@ -569,12 +564,12 @@ kernel_physical_mapping_init(unsigned long start,
 			continue;
 		}
 
-		pud = alloc_low_page(&pud_phys);
+		pud = alloc_low_page();
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
 						 page_size_mask);
 
 		spin_lock(&init_mm.page_table_lock);
-		pgd_populate(&init_mm, pgd, __va(pud_phys));
+		pgd_populate(&init_mm, pgd, pud);
 		spin_unlock(&init_mm.page_table_lock);
 		pgd_changed = true;
 	}
-- 
1.7.7

