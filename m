Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1AXSAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:00:35 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50900 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753888Ab1AXR4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:19 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v4 03/19] ARM: LPAE: use long long format when printing physical addresses and ptes
Date: Mon, 24 Jan 2011 17:55:45 +0000
Message-Id: <1295891761-18366-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:10.0897 (UTC) FILETIME=[FBF5F810:01CBBBEF]
X-MC-Unique: 111012417561700201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OI0f4Y031642

From: Will Deacon <will.deacon@arm.com>

Now that the Kernel supports 2 level and 3 level page tables, physical
addresses (and also page table entries) may be 32 or 64-bits depending
upon the configuration.

This patch uses the %08llx conversion specifier for physical addresses
and page table entries, ensuring that they are cast to (long long) so
that common code can be used regardless of the datatype widths.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/setup.c |    2 +-
 arch/arm/kernel/traps.c |    6 +++---
 arch/arm/mm/fault.c     |   10 ++++++----
 arch/arm/mm/mmu.c       |   30 +++++++++++++++---------------
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 5ea4fb7..3d23f0f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -449,7 +449,7 @@ static int __init arm_add_memory(unsigned long start, unsigned long size)
 
 	if (meminfo.nr_banks >= NR_BANKS) {
 		printk(KERN_CRIT "NR_BANKS too low, "
-			"ignoring memory at %#lx\n", start);
+			"ignoring memory at %#08llx\n", (long long)start);
 		return -EINVAL;
 	}
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index ee57640..8f3ca04 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -712,17 +712,17 @@ EXPORT_SYMBOL(__readwrite_bug);
 
 void __pte_error(const char *file, int line, pte_t pte)
 {
-	printk("%s:%d: bad pte %08lx.\n", file, line, pte_val(pte));
+	printk("%s:%d: bad pte %08llx.\n", file, line, (long long)pte_val(pte));
 }
 
 void __pmd_error(const char *file, int line, pmd_t pmd)
 {
-	printk("%s:%d: bad pmd %08lx.\n", file, line, pmd_val(pmd));
+	printk("%s:%d: bad pmd %08llx.\n", file, line, (long long)pmd_val(pmd));
 }
 
 void __pgd_error(const char *file, int line, pgd_t pgd)
 {
-	printk("%s:%d: bad pgd %08lx.\n", file, line, pgd_val(pgd));
+	printk("%s:%d: bad pgd %08llx.\n", file, line, (long long)pgd_val(pgd));
 }
 
 asmlinkage void __div0(void)
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index f10f9ba..ef0e24f 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -76,7 +76,8 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 	printk(KERN_ALERT "pgd = %p\n", mm->pgd);
 	pgd = pgd_offset(mm, addr);
-	printk(KERN_ALERT "[%08lx] *pgd=%08lx", addr, pgd_val(*pgd));
+	printk(KERN_ALERT "[%08lx] *pgd=%08llx",
+			addr, (long long)pgd_val(*pgd));
 
 	do {
 		pmd_t *pmd;
@@ -92,7 +93,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pmd = pmd_offset(pgd, addr);
 		if (PTRS_PER_PMD != 1)
-			printk(", *pmd=%08lx", pmd_val(*pmd));
+			printk(", *pmd=%08llx", (long long)pmd_val(*pmd));
 
 		if (pmd_none(*pmd))
 			break;
@@ -107,8 +108,9 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 			break;
 
 		pte = pte_offset_map(pmd, addr);
-		printk(", *pte=%08lx", pte_val(*pte));
-		printk(", *ppte=%08lx", pte_val(pte[PTE_HWTABLE_PTRS]));
+		printk(", *pte=%08llx", (long long)pte_val(*pte));
+		printk(", *ppte=%08llx",
+		       (long long)pte_val(pte[PTE_HWTABLE_PTRS]));
 		pte_unmap(pte);
 	} while(0);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index dcafa5c..cae8d68 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -597,8 +597,8 @@ static void __init create_36bit_mapping(struct map_desc *md,
 
 	if (!(cpu_architecture() >= CPU_ARCH_ARMv6 || cpu_is_xsc3())) {
 		printk(KERN_ERR "MM: CPU does not support supersection "
-		       "mapping for 0x%08llx at 0x%08lx\n",
-		       __pfn_to_phys((u64)md->pfn), addr);
+		       "mapping for %#08llx at %#08lx\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
@@ -610,15 +610,15 @@ static void __init create_36bit_mapping(struct map_desc *md,
 	 */
 	if (type->domain) {
 		printk(KERN_ERR "MM: invalid domain in supersection "
-		       "mapping for 0x%08llx at 0x%08lx\n",
-		       __pfn_to_phys((u64)md->pfn), addr);
+		       "mapping for %#08llx at %#08lx\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
 	if ((addr | length | __pfn_to_phys(md->pfn)) & ~SUPERSECTION_MASK) {
-		printk(KERN_ERR "MM: cannot create mapping for "
-		       "0x%08llx at 0x%08lx invalid alignment\n",
-		       __pfn_to_phys((u64)md->pfn), addr);
+		printk(KERN_ERR "MM: cannot create mapping for %#08llx"
+		       " at %#08lx invalid alignment\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), addr);
 		return;
 	}
 
@@ -657,17 +657,17 @@ static void __init create_mapping(struct map_desc *md)
 	pgd_t *pgd;
 
 	if (md->virtual != vectors_base() && md->virtual < TASK_SIZE) {
-		printk(KERN_WARNING "BUG: not creating mapping for "
-		       "0x%08llx at 0x%08lx in user region\n",
-		       __pfn_to_phys((u64)md->pfn), md->virtual);
+		printk(KERN_WARNING "BUG: not creating mapping for %#08llx"
+		       " at %#08lx in user region\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), md->virtual);
 		return;
 	}
 
 	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
 	    md->virtual >= PAGE_OFFSET && md->virtual < VMALLOC_END) {
-		printk(KERN_WARNING "BUG: mapping for 0x%08llx at 0x%08lx "
-		       "overlaps vmalloc space\n",
-		       __pfn_to_phys((u64)md->pfn), md->virtual);
+		printk(KERN_WARNING "BUG: mapping for %#08llx"
+		       " at %#08lx overlaps vmalloc space\n",
+		       (long long)__pfn_to_phys((u64)md->pfn), md->virtual);
 	}
 
 	type = &mem_types[md->type];
@@ -685,9 +685,9 @@ static void __init create_mapping(struct map_desc *md)
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 
 	if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {
-		printk(KERN_WARNING "BUG: map for 0x%08lx at 0x%08lx can not "
+		printk(KERN_WARNING "BUG: map for %#08llx at %#08lx can not "
 		       "be mapped using pages, ignoring.\n",
-		       __pfn_to_phys(md->pfn), addr);
+		       (long long)__pfn_to_phys(md->pfn), addr);
 		return;
 	}
 

