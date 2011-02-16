Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab1BPItk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:49:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:58026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1BPIth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:49:37 -0500
Date: Wed, 16 Feb 2011 08:49:19 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4D0C0734.7060900@kernel.org>
References: <4D0C0734.7060900@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, mm: Put early page table high
Message-ID: <tip-4b239f458c229de044d6905c2b0f9fe16ed9e01e@git.kernel.org>
Git-Commit-ID: 4b239f458c229de044d6905c2b0f9fe16ed9e01e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 08:49:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b239f458c229de044d6905c2b0f9fe16ed9e01e
Gitweb:     http://git.kernel.org/tip/4b239f458c229de044d6905c2b0f9fe16ed9e01e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 17 Dec 2010 16:58:28 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Dec 2010 14:46:54 -0800

x86-64, mm: Put early page table high

While dubug kdump, found current kernel will have problem with crashkernel=512M.

It turns out that initial mapping is to 512M, and later initial mapping to 4G
(acutally is 2040M in my platform), will put page table near 512M.
then initial mapping to 128g will be near 2g.

before this patch:
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @ [0x1fffc000-0x1fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x1fffc000-0x1fffdfff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000207fffffff]
[    0.000000]  0100000000 - 2080000000 page 2M
[    0.000000] kernel direct mapping tables up to 2080000000 @ [0x7bc01000-0x7bc83fff]
[    0.000000]     memblock_x86_reserve_range: [0x7bc01000-0x7bc7efff]          PGTABLE
[    0.000000] RAMDISK: 7bc84000 - 7f745000
[    0.000000] crashkernel reservation failed - No suitable area found.

after patch:
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @ [0x7f74c000-0x7f74ffff]
[    0.000000]     memblock_x86_reserve_range: [0x7f74c000-0x7f74dfff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000207fffffff]
[    0.000000]  0100000000 - 2080000000 page 2M
[    0.000000] kernel direct mapping tables up to 2080000000 @ [0x207ff7d000-0x207fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x207ff7d000-0x207fffafff]          PGTABLE
[    0.000000] RAMDISK: 7bc84000 - 7f745000
[    0.000000]     memblock_x86_reserve_range: [0x17000000-0x36ffffff]     CRASH KERNEL
[    0.000000] Reserving 512MB of memory at 368MB for crashkernel (System RAM: 133120MB)

It means with the patch, page table for [0, 2g) will need 2g, instead of under 512M,
page table for [4g, 128g) will be near 128g, instead of under 2g.

That would good, if we have lots of memory above 4g, like 1024g, or 2048g or 16T, will not put
related page table under 2g. that would be have chance to fill the under 2g if 1G or 2M page is
not used.

the code change will use add map_low_page() and update unmap_low_page() for 64bit, and use them
to get access the corresponding high memory for page table setting.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D0C0734.7060900@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c    |    9 ++----
 arch/x86/mm/init_64.c |   63 +++++++++++++++++++++----------------------------
 2 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c0e28a1..5863950 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -33,7 +33,7 @@ int direct_gbpages
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
-	unsigned long puds, pmds, ptes, tables, start;
+	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
@@ -73,12 +73,9 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	 * need roughly 0.5KB per GB.
 	 */
 #ifdef CONFIG_X86_32
-	start = 0x7000;
-#else
-	start = 0x8000;
+	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
-	base = memblock_find_in_range(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
+	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..024847d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -333,12 +333,28 @@ static __ref void *alloc_low_page(unsigned long *phys)
 	return adr;
 }
 
+static __ref void *map_low_page(void *virt)
+{
+	void *adr;
+	unsigned long phys, left;
+
+	if (after_bootmem)
+		return virt;
+
+	phys = __pa(virt);
+	left = phys & (PAGE_SIZE - 1);
+	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
+	adr = (void *)(((unsigned long)adr) | left);
+
+	return adr;
+}
+
 static __ref void unmap_low_page(void *adr)
 {
 	if (after_bootmem)
 		return;
 
-	early_iounmap(adr, PAGE_SIZE);
+	early_iounmap((void *)((unsigned long)adr & PAGE_MASK), PAGE_SIZE);
 }
 
 static unsigned long __meminit
@@ -386,15 +402,6 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 }
 
 static unsigned long __meminit
-phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end,
-		pgprot_t prot)
-{
-	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
-
-	return phys_pte_init(pte, address, end, prot);
-}
-
-static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	      unsigned long page_size_mask, pgprot_t prot)
 {
@@ -420,8 +427,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
-				last_map_addr = phys_pte_update(pmd, address,
+				pte = map_low_page((pte_t *)pmd_page_vaddr(*pmd));
+				last_map_addr = phys_pte_init(pte, address,
 								end, prot);
+				unmap_low_page(pte);
 				spin_unlock(&init_mm.page_table_lock);
 				continue;
 			}
@@ -468,18 +477,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 }
 
 static unsigned long __meminit
-phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
-		unsigned long page_size_mask, pgprot_t prot)
-{
-	pmd_t *pmd = pmd_offset(pud, 0);
-	unsigned long last_map_addr;
-
-	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask, prot);
-	__flush_tlb_all();
-	return last_map_addr;
-}
-
-static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 unsigned long page_size_mask)
 {
@@ -504,8 +501,11 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud)) {
-				last_map_addr = phys_pmd_update(pud, addr, end,
+				pmd = map_low_page(pmd_offset(pud, 0));
+				last_map_addr = phys_pmd_init(pmd, addr, end,
 							 page_size_mask, prot);
+				unmap_low_page(pmd);
+				__flush_tlb_all();
 				continue;
 			}
 			/*
@@ -553,17 +553,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 	return last_map_addr;
 }
 
-static unsigned long __meminit
-phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
-		 unsigned long page_size_mask)
-{
-	pud_t *pud;
-
-	pud = (pud_t *)pgd_page_vaddr(*pgd);
-
-	return phys_pud_init(pud, addr, end, page_size_mask);
-}
-
 unsigned long __meminit
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
@@ -587,8 +576,10 @@ kernel_physical_mapping_init(unsigned long start,
 			next = end;
 
 		if (pgd_val(*pgd)) {
-			last_map_addr = phys_pud_update(pgd, __pa(start),
+			pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
+			last_map_addr = phys_pud_init(pud, __pa(start),
 						 __pa(end), page_size_mask);
+			unmap_low_page(pud);
 			continue;
 		}
 
