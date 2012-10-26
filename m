Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab2JZOwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:52:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43581 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:52:06 -0400
Date: Fri, 26 Oct 2012 16:52:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20121026145200.GA14287@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 8b724e2a12d553cad8ad412846511c783a92d25e Merge tag 'efi-for-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/urgent

This fixes a couple of nasty page table initialization bugs 
which were causing kdump regressions. A clean rearchitecturing 
of the code is in the works - meanwhile these are reverts that 
restore the best-known-working state of the kernel.

There's also EFI fixes and other small fixes.

out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
MAINTAINERS                        # 78bef24: MAINTAINERS: Add EFI git reposito
include/linux/memblock.h           # 6ede1fd: x86, mm: Trim memory in memblock 
mm/memblock.c                      # 6ede1fd: x86, mm: Trim memory in memblock 

 Thanks,

	Ingo

------------------>
Dave Young (1):
      Revert "x86/mm: Fix the size calculation of mapping tables"

Dimitri Sivanich (1):
      x86/irq/ioapic: Check for valid irq_cfg pointer in smp_irq_move_cleanup_interrupt

Jacob Shin (1):
      x86, mm: Find_early_table_space based on ranges that are actually being mapped

Jan Beulich (1):
      x86-64: Fix page table accounting

Matt Fleming (2):
      MAINTAINERS: Add EFI git repository location
      x86/efi: Fix oops caused by incorrect set_memory_uc() usage

Olof Johansson (1):
      x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Yinghai Lu (3):
      x86, mm: Trim memory in memblock to be page aligned
      x86, mm: Use memblock memory loop instead of e820_RAM
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c


 MAINTAINERS                    |  1 +
 arch/x86/include/asm/efi.h     |  6 +++--
 arch/x86/kernel/apic/io_apic.c |  3 +++
 arch/x86/kernel/e820.c         |  3 +++
 arch/x86/kernel/setup.c        | 27 +++++++++++++++-----
 arch/x86/mm/init.c             | 58 ++++++++++++++++++++++--------------------
 arch/x86/mm/init_64.c          |  7 ++++-
 arch/x86/platform/efi/efi.c    | 47 ++++++++++++++++++++--------------
 arch/x86/platform/efi/efi_64.c |  7 +++--
 include/linux/memblock.h       |  1 +
 mm/memblock.c                  | 24 +++++++++++++++++
 11 files changed, 126 insertions(+), 58 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 027ec2b..f39a82d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2802,6 +2802,7 @@ F:	sound/usb/misc/ua101.c
 EXTENSIBLE FIRMWARE INTERFACE (EFI)
 M:	Matt Fleming <matt.fleming@intel.com>
 L:	linux-efi@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
 S:	Maintained
 F:	Documentation/x86/efi-stub.txt
 F:	arch/ia64/kernel/efi.c
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index c9dcc18..6e8fdf5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -35,7 +35,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -89,7 +89,7 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
+				 u32 type, u64 attribute);
 
 #endif /* CONFIG_X86_32 */
 
@@ -98,6 +98,8 @@ extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
+extern void efi_unmap_memmap(void);
+extern void efi_memory_uc(u64 addr, unsigned long size);
 
 #ifndef CONFIG_EFI
 /*
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..1817fa9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2257,6 +2257,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			continue;
 
 		cfg = irq_cfg(irq);
+		if (!cfg)
+			continue;
+
 		raw_spin_lock(&desc->lock);
 
 		/*
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index ed858e9..df06ade 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1077,6 +1077,9 @@ void __init memblock_x86_fill(void)
 		memblock_add(ei->addr, ei->size);
 	}
 
+	/* throw away partial pages */
+	memblock_trim_memory(PAGE_SIZE);
+
 	memblock_dump_all();
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 468e98d..ca45696 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -921,18 +921,19 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
 		int i;
-		for (i = 0; i < e820.nr_map; i++) {
-			struct e820entry *ei = &e820.map[i];
+		unsigned long start, end;
+		unsigned long start_pfn, end_pfn;
 
-			if (ei->addr + ei->size <= 1UL << 32)
-				continue;
+		for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn,
+							 NULL) {
 
-			if (ei->type == E820_RESERVED)
+			end = PFN_PHYS(end_pfn);
+			if (end <= (1UL<<32))
 				continue;
 
+			start = PFN_PHYS(start_pfn);
 			max_pfn_mapped = init_memory_mapping(
-				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
-				ei->addr + ei->size);
+						max((1UL<<32), start), end);
 		}
 
 		/* can we preseve max_low_pfn ?*/
@@ -1048,6 +1049,18 @@ void __init setup_arch(char **cmdline_p)
 	arch_init_ideal_nops();
 
 	register_refined_jiffies(CLOCK_TICK_RATE);
+
+#ifdef CONFIG_EFI
+	/* Once setup is done above, disable efi_enabled on mismatched
+	 * firmware/kernel archtectures since there is no support for
+	 * runtime services.
+	 */
+	if (efi_enabled && IS_ENABLED(CONFIG_X86_64) != efi_64bit) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_unmap_memmap();
+		efi_enabled = 0;
+	}
+#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ab1f6a9..d7aea41 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,40 +35,44 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
-static void __init find_early_table_space(struct map_range *mr, unsigned long end,
-					  int use_pse, int use_gbpages)
+/*
+ * First calculate space needed for kernel direct mapping page tables to cover
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int nr_range)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
 	phys_addr_t base;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-
-	if (use_gbpages) {
-		unsigned long extra;
-
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
 
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
-	if (use_pse) {
-		unsigned long extra;
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
 
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
+			extra += PMD_SIZE;
 #endif
-		/* The first 2/4M doesn't use large pages. */
-		if (mr->start < PMD_SIZE)
-			extra += mr->end - mr->start;
-
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}
 
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
@@ -86,7 +90,7 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		end - 1, pgt_buf_start << PAGE_SHIFT,
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
@@ -267,7 +271,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
+		find_early_table_space(mr, nr_range);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..3baff25 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -386,7 +386,8 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		 * these mappings are more intelligent.
 		 */
 		if (pte_val(*pte)) {
-			pages++;
+			if (!after_bootmem)
+				pages++;
 			continue;
 		}
 
@@ -451,6 +452,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_2M)) {
+				if (!after_bootmem)
+					pages++;
 				last_map_addr = next;
 				continue;
 			}
@@ -526,6 +529,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_1G)) {
+				if (!after_bootmem)
+					pages++;
 				last_map_addr = next;
 				continue;
 			}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index aded2a9..ad44391 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -70,11 +70,15 @@ EXPORT_SYMBOL(efi);
 struct efi_memory_map memmap;
 
 bool efi_64bit;
-static bool efi_native;
 
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static inline bool efi_is_native(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) == efi_64bit;
+}
+
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
@@ -420,7 +424,7 @@ void __init efi_reserve_boot_services(void)
 	}
 }
 
-static void __init efi_unmap_memmap(void)
+void __init efi_unmap_memmap(void)
 {
 	if (memmap.map) {
 		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
@@ -432,7 +436,7 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_native)
+	if (!efi_is_native())
 		return;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -684,12 +688,10 @@ void __init efi_init(void)
 		return;
 	}
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-	efi_native = !efi_64bit;
 #else
 	efi_phys.systab = (efi_system_table_t *)
 			  (boot_params.efi_info.efi_systab |
 			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
-	efi_native = efi_64bit;
 #endif
 
 	if (efi_systab_init(efi_phys.systab)) {
@@ -723,7 +725,7 @@ void __init efi_init(void)
 	 * that doesn't match the kernel 32/64-bit mode.
 	 */
 
-	if (!efi_native)
+	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else if (efi_runtime_init()) {
 		efi_enabled = 0;
@@ -735,7 +737,7 @@ void __init efi_init(void)
 		return;
 	}
 #ifdef CONFIG_X86_32
-	if (efi_native) {
+	if (efi_is_native()) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
@@ -810,6 +812,16 @@ void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 	return NULL;
 }
 
+void efi_memory_uc(u64 addr, unsigned long size)
+{
+	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
+	u64 npages;
+
+	npages = round_up(size, page_shift) / page_shift;
+	memrange_efi_to_native(&addr, &npages);
+	set_memory_uc(addr, npages);
+}
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -823,7 +835,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
+	u64 end, systab, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -834,7 +846,7 @@ void __init efi_enter_virtual_mode(void)
 	 * non-native EFI
 	 */
 
-	if (!efi_native) {
+	if (!efi_is_native()) {
 		efi_unmap_memmap();
 		return;
 	}
@@ -879,10 +891,14 @@ void __init efi_enter_virtual_mode(void)
 		end_pfn = PFN_UP(end);
 		if (end_pfn <= max_low_pfn_mapped
 		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped))
+			&& end_pfn <= max_pfn_mapped)) {
 			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size, md->type);
+
+			if (!(md->attribute & EFI_MEMORY_WB))
+				efi_memory_uc((u64)(unsigned long)va, size);
+		} else
+			va = efi_ioremap(md->phys_addr, size,
+					 md->type, md->attribute);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -892,13 +908,6 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
-		if (!(md->attribute & EFI_MEMORY_WB)) {
-			addr = md->virt_addr;
-			npages = md->num_pages;
-			memrange_efi_to_native(&addr, &npages);
-			set_memory_uc(addr, npages);
-		}
-
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..95fd505 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -82,7 +82,7 @@ void __init efi_call_phys_epilog(void)
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
+				 u32 type, u64 attribute)
 {
 	unsigned long last_map_pfn;
 
@@ -92,8 +92,11 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
-		efi_ioremap(top, size - (top - phys_addr), type);
+		efi_ioremap(top, size - (top - phys_addr), type, attribute);
 	}
 
+	if (!(attribute & EFI_MEMORY_WB))
+		efi_memory_uc((u64)(unsigned long)__va(phys_addr), size);
+
 	return (void __iomem *)__va(phys_addr);
 }
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 569d67d..d452ee1 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -57,6 +57,7 @@ int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 931eef1..6259055 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -930,6 +930,30 @@ int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t si
 	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
+void __init_memblock memblock_trim_memory(phys_addr_t align)
+{
+	int i;
+	phys_addr_t start, end, orig_start, orig_end;
+	struct memblock_type *mem = &memblock.memory;
+
+	for (i = 0; i < mem->cnt; i++) {
+		orig_start = mem->regions[i].base;
+		orig_end = mem->regions[i].base + mem->regions[i].size;
+		start = round_up(orig_start, align);
+		end = round_down(orig_end, align);
+
+		if (start == orig_start && end == orig_end)
+			continue;
+
+		if (start < end) {
+			mem->regions[i].base = start;
+			mem->regions[i].size = end - start;
+		} else {
+			memblock_remove_region(mem, i);
+			i--;
+		}
+	}
+}
 
 void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {
