Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2GFVG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:06:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32788 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350Ab2GFVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:41 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 11/36] AArch64: MMU initialisation
Date: Fri,  6 Jul 2012 22:05:52 +0100
Message-Id: <1341608777-12982-12-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:32.0593 (UTC) FILETIME=[5C1B7E10:01CD5BBB]
X-MC-Unique: 112070622063906901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LAOTj005387

This patch contains the initialisation of the memory blocks, MMU
attributes and the memory map. Only five memory types are defined:
Device nGnRnE (equivalent to Strongly Ordered), Device nGnRE (classic
Device memory), Device GRE, Normal Non-cacheable and Normal Cacheable.
Cache policies are supported via the memory attributes register
(MAIR_EL1) and only affect the Normal Cacheable mappings.

This patch also adds the SPARSEMEM_VMEMMAP initialisation.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/memblock.h |   24 ++
 arch/aarch64/mm/init.c              |  575 +++++++++++++++++++++++++++++++++++
 arch/aarch64/mm/mmu.c               |  464 ++++++++++++++++++++++++++++
 3 files changed, 1063 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/memblock.h
 create mode 100644 arch/aarch64/mm/init.c
 create mode 100644 arch/aarch64/mm/mmu.c

diff --git a/arch/aarch64/include/asm/memblock.h b/arch/aarch64/include/asm/memblock.h
new file mode 100644
index 0000000..33176ba
--- /dev/null
+++ b/arch/aarch64/include/asm/memblock.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_MEMBLOCK_H
+#define __ASM_MEMBLOCK_H
+
+struct meminfo;
+
+extern void aarch64_memblock_init(struct meminfo *);
+
+#endif
diff --git a/arch/aarch64/mm/init.c b/arch/aarch64/mm/init.c
new file mode 100644
index 0000000..21674c1
--- /dev/null
+++ b/arch/aarch64/mm/init.c
@@ -0,0 +1,575 @@
+/*
+ * Based on arch/arm/mm/init.c
+ *
+ * Copyright (C) 1995-2005 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/errno.h>
+#include <linux/swap.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/mman.h>
+#include <linux/nodemask.h>
+#include <linux/initrd.h>
+#include <linux/gfp.h>
+#include <linux/memblock.h>
+#include <linux/sort.h>
+#include <linux/of_fdt.h>
+
+#include <asm/prom.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/sizes.h>
+#include <asm/tlb.h>
+
+#include "mm.h"
+
+static unsigned long phys_initrd_start __initdata = 0;
+static unsigned long phys_initrd_size __initdata = 0;
+
+phys_addr_t memstart_addr __read_mostly = 0;
+
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end)
+{
+	phys_initrd_start = start;
+	phys_initrd_size = end - start;
+}
+
+static int __init early_initrd(char *p)
+{
+	unsigned long start, size;
+	char *endp;
+
+	start = memparse(p, &endp);
+	if (*endp == ',') {
+		size = memparse(endp + 1, NULL);
+
+		phys_initrd_start = start;
+		phys_initrd_size = size;
+	}
+	return 0;
+}
+early_param("initrd", early_initrd);
+
+/*
+ * This keeps memory configuration data used by a couple memory initialization
+ * functions, as well as show_mem() for the skipping of holes in the memory
+ * map.  It is populated by arm_add_memory().
+ */
+struct meminfo meminfo;
+
+void show_mem(unsigned int filter)
+{
+	int free = 0, total = 0, reserved = 0;
+	int shared = 0, cached = 0, slab = 0, i;
+	struct meminfo * mi = &meminfo;
+
+	printk("Mem-info:\n");
+	show_free_areas(filter);
+
+	for_each_bank (i, mi) {
+		struct membank *bank = &mi->bank[i];
+		unsigned int pfn1, pfn2;
+		struct page *page, *end;
+
+		pfn1 = bank_pfn_start(bank);
+		pfn2 = bank_pfn_end(bank);
+
+		page = pfn_to_page(pfn1);
+		end  = pfn_to_page(pfn2 - 1) + 1;
+
+		do {
+			total++;
+			if (PageReserved(page))
+				reserved++;
+			else if (PageSwapCache(page))
+				cached++;
+			else if (PageSlab(page))
+				slab++;
+			else if (!page_count(page))
+				free++;
+			else
+				shared += page_count(page) - 1;
+			page++;
+		} while (page < end);
+	}
+
+	printk("%d pages of RAM\n", total);
+	printk("%d free pages\n", free);
+	printk("%d reserved pages\n", reserved);
+	printk("%d slab pages\n", slab);
+	printk("%d pages shared\n", shared);
+	printk("%d pages swap cached\n", cached);
+}
+
+static void __init find_limits(unsigned long *min, unsigned long *max)
+{
+	struct meminfo *mi = &meminfo;
+	int i;
+
+	*min = -1UL;
+	*max = 0;
+
+	for_each_bank (i, mi) {
+		struct membank *bank = &mi->bank[i];
+		unsigned long start, end;
+
+		start = bank_pfn_start(bank);
+		end = bank_pfn_end(bank);
+
+		if (*min > start)
+			*min = start;
+		if (*max < end)
+			*max = end;
+	}
+}
+
+static void __init aarch64_bootmem_init(unsigned long start_pfn,
+					unsigned long end_pfn)
+{
+	struct memblock_region *reg;
+	unsigned int boot_pages;
+	phys_addr_t bitmap;
+	pg_data_t *pgdat;
+
+	/*
+	 * Allocate the bootmem bitmap page.  This must be in a region of
+	 * memory which has already been mapped.
+	 */
+	boot_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
+	bitmap = memblock_alloc_base(boot_pages << PAGE_SHIFT, L1_CACHE_BYTES,
+				__pfn_to_phys(end_pfn));
+
+	/*
+	 * Initialise the bootmem allocator, handing the memory banks over to
+	 * bootmem.
+	 */
+	node_set_online(0);
+	pgdat = NODE_DATA(0);
+	init_bootmem_node(pgdat, __phys_to_pfn(bitmap), start_pfn, end_pfn);
+
+	/* Free the memory regions from memblock into bootmem */
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);
+
+		if (end >= end_pfn)
+			end = end_pfn;
+		if (start >= end)
+			break;
+
+		free_bootmem(__pfn_to_phys(start), (end - start) << PAGE_SHIFT);
+	}
+
+	/* Reserve the memblock reserved regions in bootmem */
+	for_each_memblock(reserved, reg) {
+		unsigned long start = memblock_region_reserved_base_pfn(reg);
+		unsigned long end = memblock_region_reserved_end_pfn(reg);
+
+		if (end >= end_pfn)
+			end = end_pfn;
+		if (start >= end)
+			break;
+
+		reserve_bootmem(__pfn_to_phys(start),
+			        (end - start) << PAGE_SHIFT, BOOTMEM_DEFAULT);
+	}
+}
+
+static void __init aarch64_bootmem_free(unsigned long min, unsigned long max)
+{
+	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
+	struct memblock_region *reg;
+
+	/*
+	 * Initialise the zones.
+	 */
+	memset(zone_size, 0, sizeof(zone_size));
+
+	/*
+	 * The memory size has already been determined.  If we need to do
+	 * anything fancy with the allocation of this memory to the zones, now
+	 * is the time to do it.
+	 */
+	zone_size[0] = max - min;
+
+	/*
+	 * Calculate the size of the holes.
+	 *  holes = node_size - sum(bank_sizes)
+	 */
+	memcpy(zhole_size, zone_size, sizeof(zhole_size));
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);
+
+		if (start < max) {
+			unsigned long low_end = min(end, max);
+			zhole_size[0] -= low_end - start;
+		}
+	}
+
+	free_area_init_node(0, zone_size, min, zhole_size);
+}
+
+#ifdef CONFIG_HAVE_ARCH_PFN_VALID
+int pfn_valid(unsigned long pfn)
+{
+	return memblock_is_memory(pfn << PAGE_SHIFT);
+}
+EXPORT_SYMBOL(pfn_valid);
+#endif
+
+#ifndef CONFIG_SPARSEMEM
+static void aarch64_memory_present(void)
+{
+}
+#else
+static void aarch64_memory_present(void)
+{
+	struct memblock_region *reg;
+
+	for_each_memblock(memory, reg)
+		memory_present(0, memblock_region_memory_base_pfn(reg),
+			       memblock_region_memory_end_pfn(reg));
+}
+#endif
+
+static int __init meminfo_cmp(const void *_a, const void *_b)
+{
+	const struct membank *a = _a, *b = _b;
+	long cmp = bank_pfn_start(a) - bank_pfn_start(b);
+	return cmp < 0 ? -1 : cmp > 0 ? 1 : 0;
+}
+
+void __init aarch64_memblock_init(struct meminfo *mi)
+{
+	int i;
+
+	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]),
+	     meminfo_cmp, NULL);
+
+	for (i = 0; i < mi->nr_banks; i++)
+		memblock_add(mi->bank[i].start, mi->bank[i].size);
+
+	/* Register the kernel text, kernel data and initrd with memblock */
+	memblock_reserve(__pa(_stext), _end - _stext);
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (phys_initrd_size) {
+		memblock_reserve(phys_initrd_start, phys_initrd_size);
+
+		/* Now convert initrd to virtual addresses */
+		initrd_start = __phys_to_virt(phys_initrd_start);
+		initrd_end = initrd_start + phys_initrd_size;
+	}
+#endif
+
+	aarch64_mm_memblock_reserve();
+	dt_memblock_reserve();
+
+	memblock_allow_resize();
+	memblock_dump_all();
+}
+
+void __init bootmem_init(void)
+{
+	unsigned long min, max;
+
+	find_limits(&min, &max);
+
+	aarch64_bootmem_init(min, max);
+
+	/*
+	 * Sparsemem tries to allocate bootmem in memory_present(), so must be
+	 * done after the fixed reservations.
+	 */
+	aarch64_memory_present();
+
+	/*
+	 * sparse_init() needs the bootmem allocator up and running.
+	 */
+	sparse_init();
+
+	/*
+	 * Now free the memory - free_area_init_node needs the sparse mem_map
+	 * arrays initialized by sparse_init() for memmap_init_zone(),
+	 * otherwise all PFNs are invalid.
+	 */
+	aarch64_bootmem_free(min, max);
+
+	high_memory = __va((max << PAGE_SHIFT) - 1) + 1;
+
+	/*
+	 * This doesn't seem to be used by the Linux memory manager any more,
+	 * but is used by ll_rw_block.  If we can get rid of it, we also get
+	 * rid of some of the stuff above as well.
+	 *
+	 * Note: max_low_pfn and max_pfn reflect the number of _pages_ in the
+	 * system, not the maximum PFN.
+	 */
+	max_pfn = max_low_pfn = max - PHYS_PFN_OFFSET;
+}
+
+static inline int free_area(unsigned long pfn, unsigned long end, char *s)
+{
+	unsigned int pages = 0, size = (end - pfn) << (PAGE_SHIFT - 10);
+
+	for (; pfn < end; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+		ClearPageReserved(page);
+		init_page_count(page);
+		__free_page(page);
+		pages++;
+	}
+
+	if (size && s)
+		pr_info("Freeing %s memory: %dK\n", s, size);
+
+	return pages;
+}
+
+/*
+ * Poison init memory with an undefined instruction (0x0).
+ */
+static inline void poison_init_mem(void *s, size_t count)
+{
+	memset(s, 0, count);
+}
+
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
+static inline void free_memmap(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct page *start_pg, *end_pg;
+	unsigned long pg, pgend;
+
+	/*
+	 * Convert start_pfn/end_pfn to a struct page pointer.
+	 */
+	start_pg = pfn_to_page(start_pfn - 1) + 1;
+	end_pg = pfn_to_page(end_pfn - 1) + 1;
+
+	/*
+	 * Convert to physical addresses, and round start upwards and end
+	 * downwards.
+	 */
+	pg = (unsigned long)PAGE_ALIGN(__pa(start_pg));
+	pgend = (unsigned long)__pa(end_pg) & PAGE_MASK;
+
+	/*
+	 * If there are free pages between these, free the section of the
+	 * memmap array.
+	 */
+	if (pg < pgend)
+		free_bootmem(pg, pgend - pg);
+}
+
+/*
+ * The mem_map array can get very big. Free the unused area of the memory map.
+ */
+static void __init free_unused_memmap(struct meminfo *mi)
+{
+	unsigned long bank_start, prev_bank_end = 0;
+	unsigned int i;
+
+	/*
+	 * This relies on each bank being in address order.  The banks are
+	 * sorted previously in bootmem_init().
+	 */
+	for_each_bank(i, mi) {
+		struct membank *bank = &mi->bank[i];
+
+		bank_start = bank_pfn_start(bank);
+
+#ifdef CONFIG_SPARSEMEM
+		/*
+		 * Take care not to free memmap entries that don't exist due
+		 * to SPARSEMEM sections which aren't present.
+		 */
+		bank_start = min(bank_start,
+				 ALIGN(prev_bank_end, PAGES_PER_SECTION));
+#endif
+		/*
+		 * If we had a previous bank, and there is a space between the
+		 * current bank and the previous, free it.
+		 */
+		if (prev_bank_end && prev_bank_end < bank_start)
+			free_memmap(prev_bank_end, bank_start);
+
+		/*
+		 * Align up here since the VM subsystem insists that the
+		 * memmap entries are valid from the bank end aligned to
+		 * MAX_ORDER_NR_PAGES.
+		 */
+		prev_bank_end = ALIGN(bank_pfn_end(bank), MAX_ORDER_NR_PAGES);
+	}
+
+#ifdef CONFIG_SPARSEMEM
+	if (!IS_ALIGNED(prev_bank_end, PAGES_PER_SECTION))
+		free_memmap(prev_bank_end,
+			    ALIGN(prev_bank_end, PAGES_PER_SECTION));
+#endif
+}
+#endif	/* !CONFIG_SPARSEMEM_VMEMMAP */
+
+/*
+ * mem_init() marks the free areas in the mem_map and tells us how much memory
+ * is free.  This is done after various parts of the system have claimed their
+ * memory after the kernel image.
+ */
+void __init mem_init(void)
+{
+	unsigned long reserved_pages, free_pages;
+	struct memblock_region *reg;
+	int i;
+
+#if CONFIG_SWIOTLB
+	extern void __init aarch64_swiotlb_init(size_t max_size);
+	aarch64_swiotlb_init(max_pfn << (PAGE_SHIFT - 1));
+#endif
+
+	max_mapnr   = pfn_to_page(max_pfn + PHYS_PFN_OFFSET) - mem_map;
+
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
+	/* this will put all unused low memory onto the freelists */
+	free_unused_memmap(&meminfo);
+#endif
+
+	totalram_pages += free_all_bootmem();
+
+	reserved_pages = free_pages = 0;
+
+	for_each_bank(i, &meminfo) {
+		struct membank *bank = &meminfo.bank[i];
+		unsigned int pfn1, pfn2;
+		struct page *page, *end;
+
+		pfn1 = bank_pfn_start(bank);
+		pfn2 = bank_pfn_end(bank);
+
+		page = pfn_to_page(pfn1);
+		end  = pfn_to_page(pfn2 - 1) + 1;
+
+		do {
+			if (PageReserved(page))
+				reserved_pages++;
+			else if (!page_count(page))
+				free_pages++;
+			page++;
+		} while (page < end);
+	}
+
+	/*
+	 * Since our memory may not be contiguous, calculate the real number
+	 * of pages we have in this system.
+	 */
+	pr_info("Memory:");
+	num_physpages = 0;
+	for_each_memblock(memory, reg) {
+		unsigned long pages = memblock_region_memory_end_pfn(reg) -
+			memblock_region_memory_base_pfn(reg);
+		num_physpages += pages;
+		printk(" %ldMB", pages >> (20 - PAGE_SHIFT));
+	}
+	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
+
+	pr_notice("Memory: %luk/%luk available, %luk reserved\n",
+		  nr_free_pages() << (PAGE_SHIFT-10),
+		  free_pages << (PAGE_SHIFT-10),
+		  reserved_pages << (PAGE_SHIFT-10));
+
+#define MLK(b, t) b, t, ((t) - (b)) >> 10
+#define MLM(b, t) b, t, ((t) - (b)) >> 20
+#define MLK_ROUNDUP(b, t) b, t, DIV_ROUND_UP(((t) - (b)), SZ_1K)
+
+	pr_notice("Virtual kernel memory layout:\n"
+		  "    vmalloc : 0x%16lx - 0x%16lx   (%6ld MB)\n"
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+		  "    vmemmap : 0x%16lx - 0x%16lx   (%6ld MB)\n"
+#endif
+		  "    modules : 0x%16lx - 0x%16lx   (%6ld MB)\n"
+		  "    memory  : 0x%16lx - 0x%16lx   (%6ld MB)\n"
+		  "      .init : 0x%p" " - 0x%p" "   (%6ld kB)\n"
+		  "      .text : 0x%p" " - 0x%p" "   (%6ld kB)\n"
+		  "      .data : 0x%p" " - 0x%p" "   (%6ld kB)\n",
+		  MLM(VMALLOC_START, VMALLOC_END),
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+		  MLM((unsigned long)virt_to_page(PAGE_OFFSET),
+		      (unsigned long)virt_to_page(high_memory)),
+#endif
+		  MLM(MODULES_VADDR, MODULES_END),
+		  MLM(PAGE_OFFSET, (unsigned long)high_memory),
+
+		  MLK_ROUNDUP(__init_begin, __init_end),
+		  MLK_ROUNDUP(_text, _etext),
+		  MLK_ROUNDUP(_sdata, _edata));
+
+#undef MLK
+#undef MLM
+#undef MLK_ROUNDUP
+
+	/*
+	 * Check boundaries twice: Some fundamental inconsistencies can be
+	 * detected at build time already.
+	 */
+#ifdef CONFIG_AARCH32_EMULATION
+	BUILD_BUG_ON(TASK_SIZE_32			> TASK_SIZE_64);
+#endif
+	BUILD_BUG_ON(TASK_SIZE_64			> MODULES_VADDR);
+	BUG_ON(TASK_SIZE_64				> MODULES_VADDR);
+
+	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
+		extern int sysctl_overcommit_memory;
+		/*
+		 * On a machine this small we won't get anywhere without
+		 * overcommit, so turn it on by default.
+		 */
+		sysctl_overcommit_memory = OVERCOMMIT_ALWAYS;
+	}
+}
+
+void free_initmem(void)
+{
+	poison_init_mem(__init_begin, __init_end - __init_begin);
+	totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
+				    __phys_to_pfn(__pa(__init_end)),
+				    "init");
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+
+static int keep_initrd;
+
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	if (!keep_initrd) {
+		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
+		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
+					    __phys_to_pfn(__pa(end)),
+					    "initrd");
+	}
+}
+
+static int __init keepinitrd_setup(char *__unused)
+{
+	keep_initrd = 1;
+	return 1;
+}
+
+__setup("keepinitrd", keepinitrd_setup);
+#endif
diff --git a/arch/aarch64/mm/mmu.c b/arch/aarch64/mm/mmu.c
new file mode 100644
index 0000000..518bf9f
--- /dev/null
+++ b/arch/aarch64/mm/mmu.c
@@ -0,0 +1,464 @@
+/*
+ * Based on arch/arm/mm/mmu.c
+ *
+ * Copyright (C) 1995-2005 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/mman.h>
+#include <linux/nodemask.h>
+#include <linux/memblock.h>
+#include <linux/fs.h>
+
+#include <asm/cputype.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/sizes.h>
+#include <asm/tlb.h>
+#include <asm/mmu_context.h>
+
+#include "mm.h"
+
+/*
+ * Empty_zero_page is a special page that is used for zero-initialized data
+ * and COW.
+ */
+struct page *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
+
+pgprot_t pgprot_default;
+EXPORT_SYMBOL(pgprot_default);
+
+struct map_desc {
+	unsigned long virtual;
+	unsigned long pfn;
+	unsigned long length;
+	unsigned int type;
+};
+
+struct cachepolicy {
+	const char	policy[16];
+	u64		mair;
+	u64		tcr;
+};
+
+static struct cachepolicy cache_policies[] __initdata = {
+	{
+		.policy		= "uncached",
+		.mair		= 0x44,			/* inner, outer non-cacheable */
+		.tcr		= TCR_IRGN_NC | TCR_ORGN_NC,
+	}, {
+		.policy		= "writethrough",
+		.mair		= 0xaa,			/* inner, outer write-through, read-allocate */
+		.tcr		= TCR_IRGN_WT | TCR_ORGN_WT,
+	}, {
+		.policy		= "writeback",
+		.mair		= 0xee,			/* inner, outer write-back, read-allocate */
+		.tcr		= TCR_IRGN_WBnWA | TCR_ORGN_WBnWA,
+	}
+};
+
+/*
+ * These are useful for identifying cache coherency problems by allowing the
+ * cache or the cache and writebuffer to be turned off. It changes the Normal
+ * memory caching attributes in the MAIR_EL1 register.
+ */
+static int __init early_cachepolicy(char *p)
+{
+	int i;
+	u64 tmp;
+
+	for (i = 0; i < ARRAY_SIZE(cache_policies); i++) {
+		int len = strlen(cache_policies[i].policy);
+
+		if (memcmp(p, cache_policies[i].policy, len) == 0)
+			break;
+	}
+	if (i == ARRAY_SIZE(cache_policies)) {
+		pr_err("ERROR: unknown or unsupported cache policy: %s\n", p);
+		return 0;
+	}
+
+	flush_cache_all();
+
+	/*
+	 * Modify MT_NORMAL attributes in MAIR_EL1.
+	 */
+	asm volatile(
+	"	mrs	%0, mair_el1\n"
+	"	bfi	%0, %1, #%2, #8\n"
+	"	msr	mair_el1, %0\n"
+	"	isb\n"
+	: "=&r" (tmp)
+	: "r" (cache_policies[i].mair), "i" (MT_NORMAL * 8));
+
+	/*
+	 * Modify TCR PTW cacheability attributes.
+	 */
+	asm volatile(
+	"	mrs	%0, tcr_el1\n"
+	"	bic	%0, %0, %2\n"
+	"	orr	%0, %0, %1\n"
+	"	msr	tcr_el1, %0\n"
+	"	isb\n"
+	: "=&r" (tmp)
+	: "r" (cache_policies[i].tcr), "r" (TCR_IRGN_MASK | TCR_ORGN_MASK));
+
+	flush_cache_all();
+
+	return 0;
+}
+early_param("cachepolicy", early_cachepolicy);
+
+#define PROT_PTE_DEVICE		PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY | PTE_XN
+#define PROT_SECT_DEVICE	PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_XN
+
+#define PROT_PTE_NORMAL		PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY
+#define PROT_SECT_NORMAL	PMD_TYPE_SECT | PMD_SECT_AF
+
+static struct mem_type mem_types[] = {
+	[MT_DEVICE_nGnRnE] = {
+		.prot_pte	= PROT_PTE_DEVICE | PTE_ATTRINDX(MT_DEVICE_nGnRnE),
+		.prot_sect	= PROT_SECT_DEVICE | PMD_ATTRINDX(MT_DEVICE_nGnRnE),
+	},
+	[MT_DEVICE_nGnRE] = {
+		.prot_pte	= PROT_PTE_DEVICE | PTE_ATTRINDX(MT_DEVICE_nGnRE),
+		.prot_sect	= PROT_SECT_DEVICE | PMD_ATTRINDX(MT_DEVICE_nGnRE),
+	},
+	[MT_DEVICE_GRE] = {
+		.prot_pte	= PROT_PTE_DEVICE | PTE_ATTRINDX(MT_DEVICE_GRE),
+		.prot_sect	= PROT_SECT_DEVICE | PMD_ATTRINDX(MT_DEVICE_GRE),
+	},
+	[MT_NORMAL_NC] = {
+		.prot_pte	= PROT_PTE_NORMAL | PTE_ATTRINDX(MT_NORMAL_NC),
+		.prot_sect	= PROT_SECT_NORMAL | PMD_ATTRINDX(MT_NORMAL_NC),
+	},
+	[MT_NORMAL] = {
+		.prot_pte	= PROT_PTE_NORMAL | PTE_ATTRINDX(MT_NORMAL),
+		.prot_sect	= PROT_SECT_NORMAL | PMD_ATTRINDX(MT_NORMAL),
+	},
+};
+
+const struct mem_type *get_mem_type(unsigned int type)
+{
+	return type < ARRAY_SIZE(mem_types) ? &mem_types[type] : NULL;
+}
+
+/*
+ * Adjust the PMD section entries according to the CPU in use.
+ */
+static void __init build_mem_type_table(void)
+{
+	pteval_t default_pgprot;
+	int i;
+
+	default_pgprot = PTE_ATTRINDX(MT_NORMAL);
+
+#ifdef CONFIG_SMP
+	/*
+	 * Mark memory with the "shared" attribute for SMP systems
+	 */
+	default_pgprot |= PTE_SHARED;
+	mem_types[MT_NORMAL].prot_pte |= PTE_SHARED;
+	mem_types[MT_NORMAL].prot_sect |= PMD_SECT_S;
+	mem_types[MT_NORMAL_NC].prot_pte |= PTE_SHARED;
+	mem_types[MT_NORMAL_NC].prot_sect |= PMD_SECT_S;
+#endif
+
+	for (i = 0; i < 16; i++) {
+		unsigned long v = pgprot_val(protection_map[i]);
+		protection_map[i] = __pgprot(v | default_pgprot);
+	}
+
+	pgprot_default = __pgprot(PTE_TYPE_PAGE | PTE_AF | default_pgprot);
+}
+
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+			      unsigned long size, pgprot_t vma_prot)
+{
+	if (!pfn_valid(pfn))
+		return pgprot_noncached(vma_prot);
+	else if (file->f_flags & O_SYNC)
+		return pgprot_writecombine(vma_prot);
+	return vma_prot;
+}
+EXPORT_SYMBOL(phys_mem_access_prot);
+
+static void __init *early_alloc(unsigned long sz)
+{
+	void *ptr = __va(memblock_alloc(sz, sz));
+	memset(ptr, 0, sz);
+	return ptr;
+}
+
+static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
+				  unsigned long end, unsigned long pfn,
+				  const struct mem_type *type)
+{
+	pte_t *pte;
+
+	if (pmd_none(*pmd)) {
+		pte = early_alloc(PTRS_PER_PTE * sizeof(pte_t));
+		__pmd_populate(pmd, __pa(pte), PMD_TYPE_TABLE);
+	}
+	BUG_ON(pmd_bad(*pmd));
+
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		set_pte(pte, pfn_pte(pfn, __pgprot(type->prot_pte)));
+		pfn++;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+}
+
+static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
+				  unsigned long end, phys_addr_t phys,
+				  const struct mem_type *type)
+{
+	pmd_t *pmd;
+	unsigned long next;
+
+	/*
+	 * Check for initial section mappings in the pgd/pud and remove them.
+	 */
+	if (pud_none(*pud) || pud_bad(*pud)) {
+		pmd = early_alloc(PTRS_PER_PMD * sizeof(pmd_t));
+		pud_populate(&init_mm, pud, pmd);
+	}
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		/* try section mapping first */
+		if (((addr | next | phys) & ~SECTION_MASK) == 0)
+			set_pmd(pmd, __pmd(phys | type->prot_sect));
+		else
+			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
+				       type);
+		phys += next - addr;
+	} while (pmd++, addr = next, addr != end);
+}
+
+static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
+				  unsigned long end, unsigned long phys,
+				  const struct mem_type *type)
+{
+	pud_t *pud = pud_offset(pgd, addr);
+	unsigned long next;
+
+	do {
+		next = pud_addr_end(addr, end);
+		alloc_init_pmd(pud, addr, next, phys, type);
+		phys += next - addr;
+	} while (pud++, addr = next, addr != end);
+}
+
+/*
+ * Create the page directory entries and any necessary page tables for the
+ * mapping specified by 'md'.
+ */
+static void __init create_mapping(struct map_desc *md)
+{
+	unsigned long addr, length, end, next;
+	phys_addr_t phys;
+	const struct mem_type *type;
+	pgd_t *pgd;
+
+	if (md->virtual < VMALLOC_START) {
+		pr_warning("BUG: not creating mapping for 0x%016llx at 0x%016lx - outside kernel range\n",
+			   __pfn_to_phys(md->pfn), md->virtual);
+		return;
+	}
+
+	type = &mem_types[md->type];
+
+	addr = md->virtual & PAGE_MASK;
+	phys = __pfn_to_phys(md->pfn);
+	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
+
+	pgd = pgd_offset_k(addr);
+	end = addr + length;
+	do {
+		next = pgd_addr_end(addr, end);
+		alloc_init_pud(pgd, addr, next, phys, type);
+		phys += next - addr;
+	} while (pgd++, addr = next, addr != end);
+}
+
+/*
+ * Reserve the special regions of memory.
+ */
+void __init aarch64_mm_memblock_reserve(void)
+{
+	/*
+	 * Reserve the page tables.  These are already in use,
+	 * and can only be in node 0.
+	 */
+	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_DIR_SIZE);
+	memblock_reserve(__pa(idmap_pg_dir), IDMAP_DIR_SIZE);
+}
+
+static void __init map_mem(void)
+{
+	struct memblock_region *reg;
+
+	/* map all the memory banks */
+	for_each_memblock(memory, reg) {
+		phys_addr_t start = reg->base;
+		phys_addr_t end = start + reg->size;
+		struct map_desc map;
+
+		if (start >= end)
+			break;
+
+		map.pfn = __phys_to_pfn(start);
+		map.virtual = __phys_to_virt(start);
+		map.length = end - start;
+		map.type = MT_NORMAL;
+
+		create_mapping(&map);
+	}
+}
+
+/*
+ * paging_init() sets up the page tables, initialises the zone memory
+ * maps and sets up the zero page.
+ */
+void __init paging_init(void)
+{
+	void *zero_page;
+
+	/*
+	 * Maximum PGDIR_SIZE addressable via the initial direct kernel
+	 * mapping in swapper_pg_dir.
+	 */
+	memblock_set_current_limit((PHYS_OFFSET & PGDIR_MASK) + PGDIR_SIZE);
+
+	build_mem_type_table();
+	map_mem();
+
+	/*
+	 * Finally flush the caches and tlb to ensure that we're in a
+	 * consistent state.
+	 */
+	flush_cache_all();
+	flush_tlb_all();
+
+	/* allocate the zero page. */
+	zero_page = early_alloc(PAGE_SIZE);
+
+	bootmem_init();
+
+	empty_zero_page = virt_to_page(zero_page);
+	__flush_dcache_page(NULL, empty_zero_page);
+
+	/*
+	 * TTBR0 is only used for the identity mapping at this stage. Make it
+	 * point to zero page to avoid speculatively fetching new entries.
+	 */
+	cpu_set_reserved_ttbr0();
+	flush_tlb_all();
+}
+
+/*
+ * Enable the identity mapping to allow the MMU disabling.
+ */
+void setup_mm_for_reboot(void)
+{
+	cpu_switch_mm(idmap_pg_dir, &init_mm);
+	flush_tlb_all();
+}
+
+/*
+ * Check whether a kernel address is valid (derived from arch/x86/).
+ */
+int kern_addr_valid(unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if ((((long)addr) >> VA_BITS) != -1UL)
+		return 0;
+
+	pgd = pgd_offset_k(addr);
+	if (pgd_none(*pgd))
+		return 0;
+
+	pud = pud_offset(pgd, addr);
+	if (pud_none(*pud))
+		return 0;
+
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return 0;
+
+	pte = pte_offset_kernel(pmd, addr);
+	if (pte_none(*pte))
+		return 0;
+
+	return pfn_valid(pte_pfn(*pte));
+}
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#ifdef CONFIG_AARCH64_64K_PAGES
+int __meminit vmemmap_populate(struct page *start_page,
+			       unsigned long size, int node)
+{
+	return vmemmap_populate_basepages(start_page, size, node);
+}
+#else	/* !CONFIG_AARCH64_64K_PAGES */
+int __meminit vmemmap_populate(struct page *start_page,
+			       unsigned long size, int node)
+{
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	do {
+		next = pmd_addr_end(addr, end);
+
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+
+		pud = vmemmap_pud_populate(pgd, addr, node);
+		if (!pud)
+			return -ENOMEM;
+
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			void *p = NULL;
+
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			set_pmd(pmd, __pmd(__pa(p) | mem_types[MT_NORMAL].prot_sect));
+		} else
+			vmemmap_verify((pte_t *)pmd, node, addr, next);
+	} while (addr = next, addr != end);
+
+	return 0;
+}
+#endif	/* CONFIG_AARCH64_64K_PAGES */
+#endif	/* CONFIG_SPARSEMEM_VMEMMAP */

