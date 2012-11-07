Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2KGJvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:51:10 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:53876 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2KGJsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:52 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 24/31] ARC: startup #1: low-level, setup_arch(), /proc/cpuinfo, mem init
Date: Wed,  7 Nov 2012 10:47:47 +0100
Message-Id: <1352281674-2186-25-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h   |    5 +
 arch/arc/include/asm/setup.h     |   22 +++++
 arch/arc/kernel/head.S           |   78 ++++++++++++++++
 arch/arc/kernel/reset.c          |   33 +++++++
 arch/arc/kernel/setup.c          |  166 ++++++++++++++++++++++++++++++++++
 arch/arc/mm/init.c               |  185 ++++++++++++++++++++++++++++++++++++++
 arch/arc/plat-arcfpga/platform.c |   29 ++++++
 7 files changed, 518 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/setup.h
 create mode 100644 arch/arc/kernel/head.S
 create mode 100644 arch/arc/kernel/reset.c
 create mode 100644 arch/arc/kernel/setup.c
 create mode 100644 arch/arc/mm/init.c
 create mode 100644 arch/arc/plat-arcfpga/platform.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index aedfbf1..725b94c 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -257,6 +257,11 @@
 	}						\
 }
 
+/* Helpers */
+#define TO_KB(bytes)		((bytes) >> 10)
+#define TO_MB(bytes)		(TO_KB(bytes) >> 10)
+#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
+#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
 
 #ifdef CONFIG_ARC_FPU_SAVE_RESTORE
 /* These DPFP regs need to be saved/restored across ctx-sw */
diff --git a/arch/arc/include/asm/setup.h b/arch/arc/include/asm/setup.h
new file mode 100644
index 0000000..ab427e6
--- /dev/null
+++ b/arch/arc/include/asm/setup.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASMARC_SETUP_H
+#define __ASMARC_SETUP_H
+
+#include <linux/types.h>
+
+#define COMMAND_LINE_SIZE 256
+
+extern int root_mountflags, end_mem;
+extern int running_on_hw;
+
+void __init setup_processor(void);
+void __init setup_arch_memory(void);
+
+#endif /* __ASMARC_SETUP_H */
diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
new file mode 100644
index 0000000..e63f6a4
--- /dev/null
+++ b/arch/arc/kernel/head.S
@@ -0,0 +1,78 @@
+/*
+ * ARC CPU startup Code
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: Dec 2007
+ *  -Check if we are running on Simulator or on real hardware
+ *      to skip certain things during boot on simulator
+ */
+
+#include <asm/asm-offsets.h>
+#include <asm/entry.h>
+#include <linux/linkage.h>
+#include <asm/arcregs.h>
+
+	.cpu A7
+
+	.section .init.text, "ax",@progbits
+	.type stext, @function
+	.globl stext
+stext:
+	;-------------------------------------------------------------------
+	; Don't clobber r0-r4 yet. It might have bootloader provided info
+	;-------------------------------------------------------------------
+
+	; Clear BSS before updating any globals
+	; XXX: use ZOL here
+	mov	r5, __bss_start
+	mov	r6, __bss_stop
+1:
+	st.ab   0, [r5,4]
+	brlt    r5, r6, 1b
+
+#ifdef CONFIG_CMDLINE_UBOOT
+	; support for bootloader provided cmdline
+	;    If cmdline passed by u-boot, then
+	;    r0 = 1  (because ATAGS parsing, now retired, used to use 0)
+	;    r1 = magic number (board identity)
+	;    r2 = addr of cmdline string (somewhere in memory/flash)
+
+	brne	r0, 1, .Lother_bootup_chores	; u-boot didn't pass cmdline
+	breq	r2, 0, .Lother_bootup_chores	; or cmdline is NULL
+
+	mov	r5, @command_line
+1:
+	ldb.ab  r6, [r2, 1]
+	breq    r6, 0, .Lother_bootup_chores
+	b.d     1b
+	stb.ab  r6, [r5, 1]
+#endif
+
+.Lother_bootup_chores:
+
+	; Identify if running on ISS vs Silicon
+	; 	IDENTITY Reg [ 3  2  1  0 ]
+	;	(chip-id)      ^^^^^		==> 0xffff for ISS
+	lr	r0, [identity]
+	lsr	r3, r0, 16
+	cmp	r3, 0xffff
+	mov.z	r4, 0
+	mov.nz	r4, 1
+	st	r4, [@running_on_hw]
+
+	; setup "current" tsk and optionally cache it in dedicated r25
+	mov	r9, @init_task
+	SET_CURR_TASK_ON_CPU  r9, r0	; r9 = tsk, r0 = scratch
+
+	; setup stack (fp, sp)
+	mov	fp, 0
+
+	; tsk->thread_info is really a PAGE, whose bottom hoists stack
+	GET_TSK_STACK_BASE r9, sp	; r9 = tsk, sp = stack base(output)
+
+	j	start_kernel	; "C" entry point
diff --git a/arch/arc/kernel/reset.c b/arch/arc/kernel/reset.c
new file mode 100644
index 0000000..e227a2b
--- /dev/null
+++ b/arch/arc/kernel/reset.c
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/reboot.h>
+#include <linux/pm.h>
+
+void machine_halt(void)
+{
+	/* Halt the processor */
+	__asm__ __volatile__("flag  1\n");
+}
+
+void machine_restart(char *__unused)
+{
+	/* Soft reset : jump to reset vector */
+	pr_info("Put your restart handler here\n");
+	machine_halt();
+}
+
+void machine_power_off(void)
+{
+	/* FIXME ::  power off ??? */
+	machine_halt();
+}
+
+void (*pm_power_off) (void) = NULL;
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
new file mode 100644
index 0000000..82ac206
--- /dev/null
+++ b/arch/arc/kernel/setup.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/root_dev.h>
+#include <linux/console.h>
+#include <linux/module.h>
+#include <linux/cpu.h>
+#include <asm/arcregs.h>
+#include <asm/tlb.h>
+#include <asm/cache.h>
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/irq.h>
+#include <asm/arcregs.h>
+
+#define FIX_PTR(x)  __asm__ __volatile__(";" : "+r"(x))
+
+int running_on_hw = 1;	/* vs. on ISS */
+
+char __initdata command_line[COMMAND_LINE_SIZE];
+
+struct task_struct *_current_task[NR_CPUS];	/* For stack switching */
+
+struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];
+
+void __init read_arc_build_cfg_regs(void)
+{
+	read_decode_mmu_bcr();
+	read_decode_cache_bcr();
+}
+
+/*
+ * Initialize and setup the processor core
+ * This is called by all the CPUs thus should not do special case stuff
+ *    such as only for boot CPU etc
+ */
+
+void __init setup_processor(void)
+{
+	read_arc_build_cfg_regs();
+	arc_init_IRQ();
+	arc_mmu_init();
+	arc_cache_init();
+}
+
+void __init __attribute__((weak)) arc_platform_early_init(void)
+{
+}
+
+void __init setup_arch(char **cmdline_p)
+{
+#ifdef CONFIG_CMDLINE_UBOOT
+	/* Make sure that a whitespace is inserted before */
+	strlcat(command_line, " ", sizeof(command_line));
+#endif
+	/*
+	 * Append .config cmdline to base command line, which might already
+	 * contain u-boot "bootargs" (handled by head.S, if so configured)
+	 */
+	strlcat(command_line, CONFIG_CMDLINE, sizeof(command_line));
+
+	/* Save unparsed command line copy for /proc/cmdline */
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+	/* To force early parsing of things like mem=xxx */
+	parse_early_param();
+
+	/* Platform/board specific: e.g. early console registration */
+	arc_platform_early_init();
+
+	setup_processor();
+
+	setup_arch_memory();
+
+	/* Can be issue if someone passes cmd line arg "ro"
+	 * But that is unlikely so keeping it as it is
+	 */
+	root_mountflags &= ~MS_RDONLY;
+
+	console_verbose();
+
+#if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+
+}
+
+/*
+ *  Get CPU information for use by the procfs.
+ */
+
+#define cpu_to_ptr(c)	((void *)(0xFFFF0000 | (unsigned int)(c)))
+#define ptr_to_cpu(p)	(~0xFFFF0000UL & (unsigned int)(p))
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	char *str;
+	int cpu_id = ptr_to_cpu(v);
+
+	str = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!str)
+		goto done;
+
+	seq_printf(m, "ARC700 #%d\n", cpu_id);
+
+	seq_printf(m, "Bogo MIPS : \t%lu.%02lu\n",
+		   loops_per_jiffy / (500000 / HZ),
+		   (loops_per_jiffy / (5000 / HZ)) % 100);
+
+	free_page((unsigned long)str);
+done:
+	seq_printf(m, "\n\n");
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	/*
+	 * Callback returns cpu-id to iterator for show routine, NULL to stop.
+	 * However since NULL is also a valid cpu-id (0), we use a round-about
+	 * way to pass it w/o having to kmalloc/free a 2 byte string.
+	 * Encode cpu-id as 0xFFcccc, which is decoded by show routine.
+	 */
+	return *pos < num_possible_cpus() ? cpu_to_ptr(*pos) : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_cpuinfo
+};
+
+static DEFINE_PER_CPU(struct cpu, cpu_topology);
+
+static int __init topology_init(void)
+{
+	int cpu;
+
+	for_each_present_cpu(cpu)
+	    register_cpu(&per_cpu(cpu_topology, cpu), cpu);
+
+	return 0;
+}
+
+subsys_initcall(topology_init);
diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
new file mode 100644
index 0000000..2373ebf
--- /dev/null
+++ b/arch/arc/mm/init.c
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#ifdef CONFIG_BLOCK_DEV_RAM
+#include <linux/blk.h>
+#endif
+#include <linux/swap.h>
+#include <linux/module.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+#include <asm/sections.h>
+#include <asm/arcregs.h>
+
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __aligned(PAGE_SIZE);
+char empty_zero_page[PAGE_SIZE] __aligned(PAGE_SIZE);
+EXPORT_SYMBOL(empty_zero_page);
+
+/* Default tot mem from .config */
+static unsigned long end_mem = CONFIG_ARC_PLAT_SDRAM_SIZE +
+				CONFIG_LINUX_LINK_BASE;
+
+/* User can over-ride above with "mem=nnn[KkMm]" in cmdline */
+static int __init setup_mem_sz(char *str)
+{
+	unsigned long sz_bytes;
+
+	sz_bytes = memparse(str, NULL);
+	end_mem = CONFIG_LINUX_LINK_BASE + (sz_bytes & PAGE_MASK);
+
+	/* early console might not be setup yet - it will show up later */
+	pr_info("\"mem=%s\": End mem set to 0x%lx\n", str, end_mem);
+
+	return 0;
+}
+early_param("mem", setup_mem_sz);
+
+/*
+ * First memory setup routine called from setup_arch()
+ * 1. setup swapper's mm @init_mm
+ * 2. Count the pages we have and setup bootmem allocator
+ * 3. zone setup
+ */
+void __init setup_arch_memory(void)
+{
+	int bootmap_sz;
+	unsigned int first_free_pfn;
+	unsigned long kernel_img_end, alloc_start;
+	unsigned long zones_size[MAX_NR_ZONES] = { 0, 0 };
+
+	init_mm.start_code = (unsigned long)_text;
+	init_mm.end_code = (unsigned long)_etext;
+	init_mm.end_data = (unsigned long)_edata;
+	init_mm.brk = (unsigned long)_end;
+
+	/* _end needs to be page aligned */
+	kernel_img_end = (unsigned long)_end;
+	BUG_ON(kernel_img_end & ~PAGE_MASK);
+
+	/* first page of system - kernel .vector starts here */
+	min_low_pfn = PFN_DOWN(CONFIG_LINUX_LINK_BASE);
+
+	/* First free page beyond kernel image */
+	first_free_pfn = PFN_DOWN(kernel_img_end);
+
+	/*
+	 * Last usable page of low mem (no HIGHMEM yet for ARC port)
+	 * -must be BASE + SIZE
+	 */
+	max_low_pfn = max_pfn = PFN_DOWN(end_mem);
+
+	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
+
+	/* setup bootmem allocator */
+	bootmap_sz = init_bootmem_node(NODE_DATA(0),
+				       first_free_pfn,/* bitmap start */
+				       min_low_pfn,   /* First pg to track */
+				       max_low_pfn);  /* Last pg to track */
+
+	/*
+	 * init_bootmem above marks all tracked Page-frames as inuse "allocated"
+	 * This includes pages occupied by kernel's elf segments.
+	 * Beyond that, excluding bootmem bitmap itself, mark the rest of
+	 * free-mem as "allocatable"
+	 */
+	alloc_start = kernel_img_end + bootmap_sz;
+	free_bootmem(alloc_start, end_mem - alloc_start);
+
+	memset(zones_size, 0, sizeof(zones_size));
+	zones_size[ZONE_NORMAL] = num_physpages;
+
+	/*
+	 * Must not use free_area_init() as that uses PAGE_OFFSET, which
+	 * need not be the case when our kernel linked at non-default addr
+	 * i.e. when CONFIG_LINUX_LINK_BASE != PAGE_OFFSET
+	 */
+	free_area_init_node(0,			/* node-id */
+			    zones_size,		/* num pages per zone */
+			    min_low_pfn,	/* first pfn of node */
+			    NULL);		/* NO holes */
+}
+
+/*
+ * mem_init - initializes memory
+ *
+ * Frees up bootmem
+ * Calculates and displays memory available/used
+ */
+void __init mem_init(void)
+{
+	int codesize, datasize, initsize, reserved_pages, free_pages;
+	int tmp;
+
+	high_memory = (void *)end_mem;
+
+	totalram_pages = free_all_bootmem();
+
+	/* count all reserved pages [kernel code/data/mem_map..] */
+	reserved_pages = 0;
+	for (tmp = 0; tmp < max_mapnr; tmp++)
+		if (PageReserved(mem_map + tmp))
+			reserved_pages++;
+
+	/* XXX: nr_free_pages() is equivalent */
+	free_pages = max_mapnr - reserved_pages;
+
+	/*
+	 * For the purpose of display below, split the "reserve mem"
+	 * kernel code/data is already shown explicitly,
+	 * Show any other reservations (mem_map[ ] et al)
+	 */
+	reserved_pages -= (((unsigned int)_end - CONFIG_LINUX_LINK_BASE) >>
+								PAGE_SHIFT);
+
+	codesize = _etext - _text;
+	datasize = _end - _etext;
+	initsize = __init_end - __init_begin;
+
+	pr_info("Memory Available: %dM / %uM (%dK code, %dK data, %dK init, %dK reserv)\n",
+		PAGES_TO_MB(free_pages),
+		TO_MB(CONFIG_ARC_PLAT_SDRAM_SIZE),
+		TO_KB(codesize), TO_KB(datasize), TO_KB(initsize),
+		PAGES_TO_KB(reserved_pages));
+}
+
+static void __init free_init_pages(const char *what, unsigned long begin,
+				   unsigned long end)
+{
+	unsigned long addr;
+
+	pr_info("Freeing %s: %ldk [%lx] to [%lx]\n",
+		what, TO_KB(end - begin), begin, end);
+
+	/* need to check that the page we free is not a partial page */
+	for (addr = begin; addr + PAGE_SIZE <= end; addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		free_page(addr);
+		totalram_pages++;
+	}
+}
+
+/*
+ * free_initmem: Free all the __init memory.
+ */
+void __init_refok free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long)__init_begin,
+			(unsigned long)__init_end);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init free_initrd_mem(unsigned long start, unsigned long end)
+{
+	free_init_pages("initrd memory", start, end);
+}
+#endif
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
new file mode 100644
index 0000000..7b5dcab
--- /dev/null
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -0,0 +1,29 @@
+/*
+ * ARC FPGA Platform support code
+ *
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+/*
+ * Early Platform Initialization called from setup_arch()
+ */
+void __init arc_platform_early_init(void)
+{
+	pr_info("[plat-arcfpga]: registering early dev resources\n");
+}
+
+int __init fpga_plat_init(void)
+{
+	pr_info("[plat-arcfpga]: registering device resources\n");
+
+	return 0;
+}
+arch_initcall(fpga_plat_init);
-- 
1.7.4.1

