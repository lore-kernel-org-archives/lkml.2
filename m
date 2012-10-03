Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2JCM7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:59:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41541 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932145Ab2JCM7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:59:43 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg@redhat.com>, Jan Beulich <jbeulich@suse.com>,
        x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 1/3] x86, mm: Include the entire kernel memory map in trampoline_pgd
Date: Wed,  3 Oct 2012 13:59:15 +0100
Message-Id: <1349269157-25956-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There are various pieces of code in arch/x86 that require a page table
with an identity mapping. Make trampoline_pgd a proper kernel page
table, it currently only includes the kernel text and module space
mapping.

One new feature of trampoline_pgd is that it now has mappings for the
physical I/O device addresses, which are inserted at ioremap()
time. Some broken implementations of EFI firmware require these
mappings to always be around.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/mm/init_64.c    |  9 ++++-
 arch/x86/mm/ioremap.c    | 99 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/realmode/init.c | 17 ++++++++-
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..fd4404f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -108,13 +108,13 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 	for (address = start; address <= end; address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
 		struct page *page;
+		pgd_t *pgd;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
 		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
-			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
@@ -130,6 +130,13 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 
 			spin_unlock(pgt_lock);
 		}
+
+		pgd = __va(real_mode_header->trampoline_pgd);
+		pgd += pgd_index(address);
+
+		if (pgd_none(*pgd))
+			set_pgd(pgd, *pgd_ref);
+
 		spin_unlock(&pgd_lock);
 	}
 }
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 78fe3f1..fd3129a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -50,6 +50,101 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 	return err;
 }
 
+static void ident_pte_range(unsigned long paddr, unsigned long vaddr,
+			    pmd_t *ppmd, pmd_t *vpmd, unsigned long end)
+{
+	pte_t *ppte = pte_offset_kernel(ppmd, paddr);
+	pte_t *vpte = pte_offset_kernel(vpmd, vaddr);
+
+	do {
+		set_pte(ppte, *vpte);
+	} while (ppte++, vpte++, vaddr += PAGE_SIZE, vaddr != end);
+}
+
+static int ident_pmd_range(unsigned long paddr, unsigned long vaddr,
+			    pud_t *ppud, pud_t *vpud, unsigned long end)
+{
+	pmd_t *ppmd = pmd_offset(ppud, paddr);
+	pmd_t *vpmd = pmd_offset(vpud, vaddr);
+	unsigned long next;
+
+	do {
+		next = pmd_addr_end(vaddr, end);
+
+		if (!pmd_present(*ppmd)) {
+			pte_t *ppte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+			if (!ppte)
+				return 1;
+
+			set_pmd(ppmd, __pmd(_KERNPG_TABLE | __pa(ppte)));
+		}
+
+		ident_pte_range(paddr, vaddr, ppmd, vpmd, next);
+	} while (ppmd++, vpmd++, vaddr = next, vaddr != end);
+
+	return 0;
+}
+
+static int ident_pud_range(unsigned long paddr, unsigned long vaddr,
+			    pgd_t *ppgd, pgd_t *vpgd, unsigned long end)
+{
+	pud_t *ppud = pud_offset(ppgd, paddr);
+	pud_t *vpud = pud_offset(vpgd, vaddr);
+	unsigned long next;
+
+	do {
+		next = pud_addr_end(vaddr, end);
+
+		if (!pud_present(*ppud)) {
+			pmd_t *ppmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+			if (!ppmd)
+				return 1;
+
+			set_pud(ppud, __pud(_KERNPG_TABLE | __pa(ppmd)));
+		}
+
+		if (ident_pmd_range(paddr, vaddr, ppud, vpud, next))
+			return 1;
+	} while (ppud++, vpud++, vaddr = next, vaddr != end);
+
+	return 0;
+}
+
+static int insert_identity_mapping(resource_size_t paddr, unsigned long vaddr,
+				    unsigned long size)
+{
+	unsigned long end = vaddr + size;
+	unsigned long next;
+	pgd_t *vpgd, *ppgd;
+
+#ifdef CONFIG_X86_32
+	ppgd = initial_page_table + pgd_index(paddr);
+
+	if (paddr >= PAGE_OFFSET || paddr + size > PAGE_OFFSET)
+		return 1;
+#else
+	ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);
+#endif
+
+	vpgd = pgd_offset_k(vaddr);
+	do {
+		next = pgd_addr_end(vaddr, end);
+
+		if (!pgd_present(*ppgd)) {
+			pud_t *ppud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+			if (!ppud)
+				return 1;
+
+			set_pgd(ppgd, __pgd(_KERNPG_TABLE | __pa(ppud)));
+		}
+
+		if (ident_pud_range(paddr, vaddr, ppgd, vpgd, next))
+			return 1;
+	} while (ppgd++, vpgd++, vaddr = next, vaddr != end);
+
+	return 0;
+}
+
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
@@ -163,6 +258,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	ret_addr = (void __iomem *) (vaddr + offset);
 	mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 
+	if (insert_identity_mapping(phys_addr, vaddr, size))
+		printk(KERN_WARNING "ioremap: unable to map 0x%llx in identity pagetable\n",
+					(unsigned long long)phys_addr);
+
 	/*
 	 * Check if the request spans more than any BAR in the iomem resource
 	 * tree.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index cbca565..8e6ab61 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -78,8 +78,21 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
-	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
+
+	/*
+	 * Create an identity mapping for all of physical memory.
+	 */
+	for (i = 0; i <= pgd_index(max_pfn << PAGE_SHIFT); i++) {
+		int index = pgd_index(PAGE_OFFSET) + i;
+
+		trampoline_pgd[i] = (u64)pgd_val(swapper_pg_dir[index]);
+	}
+
+	/*
+	 * Copy the upper-half of the kernel pages tables.
+	 */
+	for (i = pgd_index(PAGE_OFFSET); i < PTRS_PER_PGD; i++)
+		trampoline_pgd[i] = (u64)pgd_val(swapper_pg_dir[i]);
 #endif
 }
 
-- 
1.7.11.4

