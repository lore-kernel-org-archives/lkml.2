Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1CARVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:21:34 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:9838 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab1CARVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:21:33 -0500
X-IronPort-AV: E=Sophos;i="4.62,248,1297036800"; 
   d="scan'208";a="4562549"
Date: Tue, 1 Mar 2011 17:21:21 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: "x86-64, mm: Put early page table high" causes crash on Xen
Message-ID: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu,
while testing tip/x86/mm on Xen I found out that the commit "x86-64, mm:
Put early page table high" reliably crashes Linux at boot.
The reason is well explained by the commit message of
fef5ba797991f9335bcfc295942b684f9bf613a1:

"Xen requires that all pages containing pagetable entries to be mapped
read-only.  If pages used for the initial pagetable are already mapped
then we can change the mapping to RO.  However, if they are initially
unmapped, we need to make sure that when they are later mapped, they
are also mapped RO.

We do this by knowing that the kernel pagetable memory is pre-allocated
in the range e820_table_start - e820_table_end, so any pfn within this
range should be mapped read-only.  However, the pagetable setup code
early_ioremaps the pages to write their entries, so we must make sure
that mappings created in the early_ioremap fixmap area are mapped RW.
(Those mappings are removed before the pages are presented to Xen
as pagetable pages.)"

In other words mask_rw_pte (called by xen_set_pte_init) should mark RO
the already existing pagetable pages (like the ones belonging to the
initial mappings), while it should mark RW the new pages not yet hooked
into the pagetable.  This is what the following lines used to achieve,
but don't anymore:

    /*
	 * If the new pfn is within the range of the newly allocated
	 * kernel pagetable, and it isn't being mapped into an
	 * early_ioremap fixmap slot, make sure it is RO.
	 */
    if (!is_early_ioremap_ptep(ptep) &&
	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
		pte = pte_wrprotect(pte);

Unfortunately now we map the already existing initial pagetable pages a
second time and the new zeroed pages using map_low_page, so we are
unable to distinguish between the two.

Can we go back to the previous way of accessing pagetable pages from
kernel_physical_mapping_init, while keeping the new pagetable allocation
strategy? It seems to me that the introduction of map_low_page is not
actually required, is it? In that case we could just revert that bit...
(appended partial revert example).
Otherwise is there a way we can adapt mask_rw_pte to do the right thing
even in the new scenario?
Suggestions are very welcome.

- Stefano


---


diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 13b6fb1..413e140 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -334,28 +334,12 @@ static __ref void *alloc_low_page(unsigned long *phys)
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
 static __ref void unmap_low_page(void *adr)
 {
 	if (after_bootmem)
 		return;
 
-	early_iounmap((void *)((unsigned long)adr & PAGE_MASK), PAGE_SIZE);
+	early_iounmap(adr, PAGE_SIZE);
 }
 
 static unsigned long __meminit
@@ -403,6 +387,15 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 }
 
 static unsigned long __meminit
+phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end,
+		pgprot_t prot)
+{
+	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
+
+	return phys_pte_init(pte, address, end, prot);
+}
+
+static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	      unsigned long page_size_mask, pgprot_t prot)
 {
@@ -428,10 +421,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
-				pte = map_low_page((pte_t *)pmd_page_vaddr(*pmd));
-				last_map_addr = phys_pte_init(pte, address,
+				last_map_addr = phys_pte_update(pmd, address,
 								end, prot);
-				unmap_low_page(pte);
 				spin_unlock(&init_mm.page_table_lock);
 				continue;
 			}
@@ -478,6 +469,18 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 }
 
 static unsigned long __meminit
+phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
+		unsigned long page_size_mask, pgprot_t prot)
+{
+	pmd_t *pmd = pmd_offset(pud, 0);
+	unsigned long last_map_addr;
+
+	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask, prot);
+	__flush_tlb_all();
+	return last_map_addr;
+}
+
+static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 unsigned long page_size_mask)
 {
@@ -502,11 +505,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud)) {
-				pmd = map_low_page(pmd_offset(pud, 0));
-				last_map_addr = phys_pmd_init(pmd, addr, end,
+				last_map_addr = phys_pmd_update(pud, addr, end,
 							 page_size_mask, prot);
-				unmap_low_page(pmd);
-				__flush_tlb_all();
 				continue;
 			}
 			/*
@@ -554,6 +554,17 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 	return last_map_addr;
 }
 
+static unsigned long __meminit
+phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
+		 unsigned long page_size_mask)
+{
+	pud_t *pud;
+
+	pud = (pud_t *)pgd_page_vaddr(*pgd);
+
+	return phys_pud_init(pud, addr, end, page_size_mask);
+}
+
 unsigned long __meminit
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
@@ -577,10 +588,8 @@ kernel_physical_mapping_init(unsigned long start,
 			next = end;
 
 		if (pgd_val(*pgd)) {
-			pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
-			last_map_addr = phys_pud_init(pud, __pa(start),
+			last_map_addr = phys_pud_update(pgd, __pa(start),
 						 __pa(end), page_size_mask);
-			unmap_low_page(pud);
 			continue;
 		}
 
