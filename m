Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1H3TRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:17:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42431 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab1H3TPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113875254"
Message-Id: <20110830190802.558353483@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:59 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch v2 30/35] Hexagon: Add page-fault support.
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=mem-fault.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/mem-layout.h |  112 +++++++++++++
 arch/hexagon/include/asm/vm_fault.h   |   26 +++
 arch/hexagon/mm/init.c                |  278 ++++++++++++++++++++++++++++++++++
 arch/hexagon/mm/vm_fault.c            |  188 ++++++++++++++++++++++
 4 files changed, 604 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/mem-layout.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/mem-layout.h	2011-08-24 18:45:48.483877411 -0500
@@ -0,0 +1,112 @@
+/*
+ * Memory layout definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_HEXAGON_MEM_LAYOUT_H
+#define _ASM_HEXAGON_MEM_LAYOUT_H
+
+#include <linux/const.h>
+
+/*
+ * Have to do this for ginormous numbers, else they get printed as
+ * negative numbers, which the linker no likey when you try to
+ * assign it to the location counter.
+ */
+
+#define PAGE_OFFSET			_AC(0xc0000000, UL)
+
+/*
+ * LOAD_ADDRESS is the physical/linear address of where in memory
+ * the kernel gets loaded. The 12 least significant bits must be zero (0)
+ * due to limitations on setting the EVB
+ *
+ */
+
+#ifndef LOAD_ADDRESS
+#define LOAD_ADDRESS			0x00000000
+#endif
+
+#define TASK_SIZE			(PAGE_OFFSET)
+
+/*  not sure how these are used yet  */
+#define STACK_TOP			TASK_SIZE
+#define STACK_TOP_MAX			TASK_SIZE
+
+#ifndef __ASSEMBLY__
+enum fixed_addresses {
+	FIX_KMAP_BEGIN,
+	FIX_KMAP_END,  /*  check for per-cpuism  */
+	__end_of_fixed_addresses
+};
+
+#define MIN_KERNEL_SEG 0x300   /* From 0xc0000000 */
+extern int max_kernel_seg;
+
+/*
+ * Start of vmalloc virtual address space for kernel;
+ * supposed to be based on the amount of physical memory available
+ */
+
+#define VMALLOC_START (PAGE_OFFSET + VMALLOC_OFFSET + \
+	(unsigned long)high_memory)
+
+/* Gap between physical ram and vmalloc space for guard purposes. */
+#define VMALLOC_OFFSET PAGE_SIZE
+
+/*
+ * Create the space between VMALLOC_START and FIXADDR_TOP backwards
+ * from the ... "top".
+ *
+ * Permanent IO mappings will live at 0xfexx_xxxx
+ * Hypervisor occupies the last 16MB page at 0xffxxxxxx
+ */
+
+#define FIXADDR_TOP     0xfe000000
+#define FIXADDR_SIZE    (__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START   (FIXADDR_TOP - FIXADDR_SIZE)
+
+/*
+ * "permanent kernel mappings", defined as long-lasting mappings of
+ * high-memory page frames into the kernel address space.
+ */
+
+#define LAST_PKMAP	PTRS_PER_PTE
+#define LAST_PKMAP_MASK	(LAST_PKMAP - 1)
+#define PKMAP_NR(virt)	((virt - PKMAP_BASE) >> PAGE_SHIFT)
+#define PKMAP_ADDR(nr)	(PKMAP_BASE + ((nr) << PAGE_SHIFT))
+
+/*
+ * To the "left" of the fixed map space is the kmap space
+ *
+ * "Permanent Kernel Mappings"; fancy (or less fancy) PTE table
+ * that looks like it's actually walked.
+ * Need to check the alignment/shift usage; some archs use
+ * PMD_MASK on this value
+ */
+#define PKMAP_BASE (FIXADDR_START-PAGE_SIZE*LAST_PKMAP)
+
+/*
+ * 2 pages of guard gap between where vmalloc area ends
+ * and pkmap_base begins.
+ */
+#define VMALLOC_END (PKMAP_BASE-PAGE_SIZE*2)
+#endif /*  !__ASSEMBLY__  */
+
+
+#endif /* _ASM_HEXAGON_MEM_LAYOUT_H */
Index: linux-hexagon-kernel/arch/hexagon/mm/init.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/init.c	2011-08-24 18:45:48.503877429 -0500
@@ -0,0 +1,278 @@
+/*
+ * Memory subsystem initialization for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <asm/atomic.h>
+#include <linux/highmem.h>
+#include <asm/tlb.h>
+#include <asm/sections.h>
+#include <asm/vm_mmu.h>
+
+/*
+ * Define a startpg just past the end of the kernel image and a lastpg
+ * that corresponds to the end of real or simulated platform memory.
+ */
+#define bootmem_startpg (PFN_UP(((unsigned long) _end) - PAGE_OFFSET))
+
+unsigned long bootmem_lastpg;  /*  Should be set by platform code  */
+
+/*  Set as variable to limit PMD copies  */
+int max_kernel_seg = 0x303;
+
+/*  think this should be (page_size-1) the way it's used...*/
+unsigned long zero_page_mask;
+
+/*  indicate pfn's of high memory  */
+unsigned long highstart_pfn, highend_pfn;
+
+/* struct mmu_gather defined in asm-generic.h;  */
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+/* Default cache attribute for newly created page tables */
+unsigned long _dflt_cache_att = CACHEDEF;
+
+/*
+ * The current "generation" of kernel map, which should not roll
+ * over until Hell freezes over.  Actual bound in years needs to be
+ * calculated to confirm.
+ */
+DEFINE_SPINLOCK(kmap_gen_lock);
+
+/*  checkpatch says don't init this to 0.  */
+unsigned long long kmap_generation;
+
+/*
+ * mem_init - initializes memory
+ *
+ * Frees up bootmem
+ * Fixes up more stuff for HIGHMEM
+ * Calculates and displays memory available/used
+ */
+void __init mem_init(void)
+{
+	/*  No idea where this is actually declared.  Seems to evade LXR.  */
+	totalram_pages += free_all_bootmem();
+	num_physpages = bootmem_lastpg;	/*  seriously, what?  */
+
+	printk(KERN_INFO "totalram_pages = %ld\n", totalram_pages);
+
+	/*
+	 *  To-Do:  someone somewhere should wipe out the bootmem map
+	 *  after we're done?
+	 */
+#ifdef CONFIG_HIGHMEM
+	kmap_init();
+#endif
+	/*
+	 * This can be moved to some more virtual-memory-specific
+	 * initialization hook at some point.  Set the init_mm
+	 * descriptors "context" value to point to the initial
+	 * kernel segment table's physical address.
+	 */
+	init_mm.context.ptbase = __pa(init_mm.pgd);
+}
+
+/*
+ * free_initmem - frees memory used by stuff declared with __init
+ *
+ * Todo:  free pages between __init_begin and __init_end; possibly
+ * some devtree related stuff as well.
+ */
+void __init_refok free_initmem(void)
+{
+}
+
+/*
+ * free_initrd_mem - frees...  initrd memory.
+ * @start - start of init memory
+ * @end - end of init memory
+ *
+ * Apparently has to be passed the address of the initrd memory.
+ *
+ * Wrapped by #ifdef CONFIG_BLKDEV_INITRD
+ */
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+}
+
+void sync_icache_dcache(pte_t pte)
+{
+	unsigned long addr;
+	struct page *page;
+
+	page = pte_page(pte);
+	addr = (unsigned long) page_address(page);
+
+	__vmcache_idsync(addr, PAGE_SIZE);
+}
+
+/*
+ * In order to set up page allocator "nodes",
+ * somebody has to call free_area_init() for UMA.
+ *
+ * In this mode, we only have one pg_data_t
+ * structure: contig_mem_data.
+ */
+void __init paging_init(void)
+{
+	unsigned long zones_sizes[MAX_NR_ZONES] = {0, };
+
+	/*
+	 *  This is not particularly well documented anywhere, but
+	 *  give ZONE_NORMAL all the memory, including the big holes
+	 *  left by the kernel+bootmem_map which are already left as reserved
+	 *  in the bootmem_map; free_area_init should see those bits and
+	 *  adjust accordingly.
+	 */
+
+	zones_sizes[ZONE_NORMAL] = max_low_pfn;
+
+	free_area_init(zones_sizes);  /*  sets up the zonelists and mem_map  */
+
+	/*
+	 * Start of high memory area.  Will probably need something more
+	 * fancy if we...  get more fancy.
+	 */
+	high_memory = (void *)((bootmem_lastpg + 1) << PAGE_SHIFT);
+}
+
+#ifndef DMA_RESERVE
+#define DMA_RESERVE		(4)
+#endif
+
+#define DMA_CHUNKSIZE		(1<<22)
+#define DMA_RESERVED_BYTES	(DMA_RESERVE * DMA_CHUNKSIZE)
+
+/*
+ * Pick out the memory size.  We look for mem=size,
+ * where size is "size[KkMm]"
+ */
+static int __init early_mem(char *p)
+{
+	unsigned long size;
+	char *endp;
+
+	size = memparse(p, &endp);
+
+	bootmem_lastpg = PFN_DOWN(size);
+
+	return 0;
+}
+early_param("mem", early_mem);
+
+size_t hexagon_coherent_pool_size = (size_t) (DMA_RESERVE << 22);
+
+void __init setup_arch_memory(void)
+{
+	int bootmap_size;
+	/*  XXX Todo: this probably should be cleaned up  */
+	u32 *segtable = (u32 *) &swapper_pg_dir[0];
+	u32 *segtable_end;
+
+	/*
+	 * Set up boot memory allocator
+	 *
+	 * The Gorman book also talks about these functions.
+	 * This needs to change for highmem setups.
+	 */
+
+	/* Memory size needs to be a multiple of 16M */
+	bootmem_lastpg = PFN_DOWN((bootmem_lastpg << PAGE_SHIFT) &
+		~((BIG_KERNEL_PAGE_SIZE) - 1));
+
+	/*
+	 * Reserve the top DMA_RESERVE bytes of RAM for DMA (uncached)
+	 * memory allocation
+	 */
+	bootmap_size = init_bootmem(bootmem_startpg, bootmem_lastpg -
+				    PFN_DOWN(DMA_RESERVED_BYTES));
+
+	printk(KERN_INFO "bootmem_startpg:  0x%08lx\n", bootmem_startpg);
+	printk(KERN_INFO "bootmem_lastpg:  0x%08lx\n", bootmem_lastpg);
+	printk(KERN_INFO "bootmap_size:  %d\n", bootmap_size);
+	printk(KERN_INFO "max_low_pfn:  0x%08lx\n", max_low_pfn);
+
+	/*
+	 * The default VM page tables (will be) populated with
+	 * VA=PA+PAGE_OFFSET mapping.  We go in and invalidate entries
+	 * higher than what we have memory for.
+	 */
+
+	/*  this is pointer arithmetic; each entry covers 4MB  */
+	segtable = segtable + (PAGE_OFFSET >> 22);
+
+	/*  this actually only goes to the end of the first gig  */
+	segtable_end = segtable + (1<<(30-22));
+
+	/*  Move forward to the start of empty pages  */
+	segtable += bootmem_lastpg >> (22-PAGE_SHIFT);
+
+	{
+	    int i;
+
+	    for (i = 1 ; i <= DMA_RESERVE ; i++)
+		segtable[-i] = ((segtable[-i] & __HVM_PTE_PGMASK_4MB)
+				| __HVM_PTE_R | __HVM_PTE_W | __HVM_PTE_X
+				| __HEXAGON_C_UNC << 6
+				| __HVM_PDE_S_4MB);
+	}
+
+	printk(KERN_INFO "clearing segtable from %p to %p\n", segtable,
+		segtable_end);
+	while (segtable < (segtable_end-8))
+		*(segtable++) = __HVM_PDE_S_INVALID;
+	/* stop the pointer at the device I/O 4MB page  */
+
+	printk(KERN_INFO "segtable = %p (should be equal to _K_io_map)\n",
+		segtable);
+
+#if 0
+	/*  Other half of the early device table from vm_init_segtable. */
+	printk(KERN_INFO "&_K_init_devicetable = 0x%08x\n",
+		(unsigned long) _K_init_devicetable-PAGE_OFFSET);
+	*segtable = ((u32) (unsigned long) _K_init_devicetable-PAGE_OFFSET) |
+		__HVM_PDE_S_4KB;
+	printk(KERN_INFO "*segtable = 0x%08x\n", *segtable);
+#endif
+
+	/*
+	 * Free all the memory that wasn't taken up by the bootmap, the DMA
+	 * reserve, or kernel itself.
+	 */
+	free_bootmem(PFN_PHYS(bootmem_startpg)+bootmap_size,
+		     PFN_PHYS(bootmem_lastpg - bootmem_startpg) - bootmap_size -
+		     DMA_RESERVED_BYTES);
+
+	/*
+	 *  The bootmem allocator seemingly just lives to feed memory
+	 *  to the paging system
+	 */
+	printk(KERN_INFO "PAGE_SIZE=%lu\n", PAGE_SIZE);
+	paging_init();  /*  See Gorman Book, 2.3  */
+
+	/*
+	 *  At this point, the page allocator is kind of initialized, but
+	 *  apparently no pages are available (just like with the bootmem
+	 *  allocator), and need to be freed themselves via mem_init(),
+	 *  which is called by start_kernel() later on in the process
+	 */
+}
Index: linux-hexagon-kernel/arch/hexagon/mm/vm_fault.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/vm_fault.c	2011-08-24 18:45:48.523877447 -0500
@@ -0,0 +1,188 @@
+/*
+ * Memory fault handling for Hexagon
+ *
+ * Copyright (c) 2010-2011 Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ * Page fault handling for the Hexagon Virtual Machine.
+ * Can also be called by a native port emulating the HVM
+ * execptions.
+ */
+
+#include <asm/pgtable.h>
+#include <asm/traps.h>
+#include <asm/uaccess.h>
+#include <linux/mm.h>
+#include <linux/signal.h>
+#include <linux/module.h>
+#include <linux/hardirq.h>
+
+/*
+ * Decode of hardware exception sends us to one of several
+ * entry points.  At each, we generate canonical arguments
+ * for handling by the abstract memory management code.
+ */
+#define FLT_IFETCH     -1
+#define FLT_LOAD        0
+#define FLT_STORE       1
+
+
+/*
+ * Canonical page fault handler
+ */
+void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+	siginfo_t info;
+	int si_code;
+	int fault;
+	const struct exception_table_entry *fixup;
+
+	si_code = SEGV_MAPERR;
+	local_irq_enable();
+
+	/*
+	 * If we're in an interrupt or have no user context,
+	 * then must not take the fault.
+	 */
+	if (unlikely(in_interrupt() || !mm))
+		goto no_context;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, address);
+	if (!vma)
+		goto bad_area;
+
+	if (vma->vm_start <= address)
+		goto good_area;
+
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		goto bad_area;
+
+	if (expand_stack(vma, address))
+		goto bad_area;
+
+good_area:
+	/* Address space is OK.  Now check access rights. */
+	si_code = SEGV_ACCERR;
+
+	switch (cause) {
+	case FLT_IFETCH:
+		if (!(vma->vm_flags & VM_EXEC))
+			goto bad_area;
+		break;
+	case FLT_LOAD:
+		if (!(vma->vm_flags & VM_READ))
+			goto bad_area;
+		break;
+	case FLT_STORE:
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+		break;
+	}
+
+	fault = handle_mm_fault(mm, vma, address, (cause > 0));
+
+	/* The most common case -- we are done. */
+	if (likely(!(fault & VM_FAULT_ERROR))) {
+		if (fault & VM_FAULT_MAJOR)
+			current->maj_flt++;
+		else
+			current->min_flt++;
+
+		up_read(&mm->mmap_sem);
+		return;
+	}
+
+	up_read(&mm->mmap_sem);
+
+	/* Handle copyin/out exception cases */
+	if (!user_mode(regs))
+		goto no_context;
+
+	if (fault & VM_FAULT_OOM) {
+		pagefault_out_of_memory();
+		return;
+	}
+
+	/* User-mode address is in the memory map, but we are
+	 * unable to fix up the page fault.
+	 */
+	if (fault & VM_FAULT_SIGBUS) {
+		info.si_signo = SIGBUS;
+		info.si_code = BUS_ADRERR;
+	}
+	/* Address is not in the memory map */
+	else {
+		info.si_signo = SIGSEGV;
+		info.si_code = SEGV_ACCERR;
+	}
+	info.si_errno = 0;
+	info.si_addr = (void __user *)address;
+	force_sig_info(info.si_code, &info, current);
+	return;
+
+bad_area:
+	up_read(&mm->mmap_sem);
+
+	if (user_mode(regs)) {
+		info.si_signo = SIGSEGV;
+		info.si_errno = 0;
+		info.si_code = si_code;
+		info.si_addr = (void *)address;
+		force_sig_info(SIGSEGV, &info, current);
+		return;
+	}
+	/* Kernel-mode fault falls through */
+
+no_context:
+	fixup = search_exception_tables(pt_elr(regs));
+	if (fixup) {
+		pt_set_elr(regs, fixup->fixup);
+		return;
+	}
+
+	/* Things are looking very, very bad now */
+	bust_spinlocks(1);
+	printk(KERN_EMERG "Unable to handle kernel paging request at "
+		"virtual address 0x%08lx, regs %p\n", address, regs);
+	die("Bad Kernel VA", regs, SIGKILL);
+}
+
+
+void read_protection_fault(struct pt_regs *regs)
+{
+	unsigned long badvadr = pt_badva(regs);
+
+	do_page_fault(badvadr, FLT_LOAD, regs);
+}
+
+void write_protection_fault(struct pt_regs *regs)
+{
+	unsigned long badvadr = pt_badva(regs);
+
+	do_page_fault(badvadr, FLT_STORE, regs);
+}
+
+void execute_protection_fault(struct pt_regs *regs)
+{
+	unsigned long badvadr = pt_badva(regs);
+
+	do_page_fault(badvadr, FLT_IFETCH, regs);
+}
Index: linux-hexagon-kernel/arch/hexagon/include/asm/vm_fault.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/vm_fault.h	2011-08-24 18:45:48.523877447 -0500
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_HEXAGON_VM_FAULT_H
+#define _ASM_HEXAGON_VM_FAULT_H
+
+extern void execute_protection_fault(struct pt_regs *);
+extern void write_protection_fault(struct pt_regs *);
+extern void read_protection_fault(struct pt_regs *);
+
+#endif

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

