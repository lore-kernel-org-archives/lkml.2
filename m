Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2KVUuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:50:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914Ab2KVS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:40 -0500
Date: Wed, 21 Nov 2012 18:01:21 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-868bf4d6b94c980d3ad87f892a5e528b8ee2c320@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1353123563-3103-24-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-24-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Remove parameter in alloc_low_page for 64bit
Git-Commit-ID: 868bf4d6b94c980d3ad87f892a5e528b8ee2c320
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:01:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  868bf4d6b94c980d3ad87f892a5e528b8ee2c320
Gitweb:     http://git.kernel.org/tip/868bf4d6b94c980d3ad87f892a5e528b8ee2c320
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:00 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:22 -0800

x86, mm: Remove parameter in alloc_low_page for 64bit

Now all page table buf are pre-mapped, and could use virtual address directly.
So don't need to remember physical address anymore.

Remove that phys pointer in alloc_low_page(), and that will allow us to merge
alloc_low_page between 64bit and 32bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-24-git-send-email-yinghai@kernel.org
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_64.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5ee9242..1960820 100644
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
 
@@ -401,7 +399,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address = next) {
-		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
 		pgprot_t new_prot = prot;
@@ -456,11 +453,11 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
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
@@ -476,7 +473,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 	int i = pud_index(addr);
 
 	for (; i < PTRS_PER_PUD; i++, addr = next) {
-		unsigned long pmd_phys;
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
 		pgprot_t prot = PAGE_KERNEL;
@@ -530,12 +526,12 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
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
@@ -560,7 +556,6 @@ kernel_physical_mapping_init(unsigned long start,
 
 	for (; start < end; start = next) {
 		pgd_t *pgd = pgd_offset_k(start);
-		unsigned long pud_phys;
 		pud_t *pud;
 
 		next = (start + PGDIR_SIZE) & PGDIR_MASK;
@@ -574,12 +569,12 @@ kernel_physical_mapping_init(unsigned long start,
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
