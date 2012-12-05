Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2LEQWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:22:05 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56729 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab2LEQJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:21 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 10/44] metag: Boot
Date: Wed, 5 Dec 2012 16:08:28 +0000
Message-ID: <1354723742-6195-11-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add boot code for metag. Due to the multi-threaded nature of Meta it is
not uncommon for an RTOS or bare metal application to be started on
other hardware threads by the bootloader. Since there is a single MMU
switch which affects all threads, the MMU is traditionally configured by
the bootloader prior to starting Linux. The bootloader passes a
structure to Linux which among other things contains information about
memory regions which have been mapped. Linux then assumes control of the
local heap memory region.

A kernel arguments string pointer or a flattened device tree pointer can
be provided in the third argument.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/boot/.gitignore         |    4 +
 arch/metag/include/asm/mach/arch.h |   77 +++++
 arch/metag/include/asm/setup.h     |    8 +
 arch/metag/kernel/head.S           |   45 +++
 arch/metag/kernel/machines.c       |   21 ++
 arch/metag/kernel/setup.c          |  570 ++++++++++++++++++++++++++++++++++++
 6 files changed, 725 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/boot/.gitignore
 create mode 100644 arch/metag/include/asm/mach/arch.h
 create mode 100644 arch/metag/include/asm/setup.h
 create mode 100644 arch/metag/kernel/head.S
 create mode 100644 arch/metag/kernel/machines.c
 create mode 100644 arch/metag/kernel/setup.c

diff --git a/arch/metag/boot/.gitignore b/arch/metag/boot/.gitignore
new file mode 100644
index 0000000..a021da2
--- /dev/null
+++ b/arch/metag/boot/.gitignore
@@ -0,0 +1,4 @@
+vmlinux*
+uImage*
+ramdisk.*
+*.dtb
diff --git a/arch/metag/include/asm/mach/arch.h b/arch/metag/include/asm/mach/arch.h
new file mode 100644
index 0000000..8429c76
--- /dev/null
+++ b/arch/metag/include/asm/mach/arch.h
@@ -0,0 +1,77 @@
+/*
+ * arch/metag/include/asm/mach/arch.h
+ *
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * based on the ARM version:
+ *  Copyright (C) 2000 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _METAG_MACH_ARCH_H_
+#define _METAG_MACH_ARCH_H_
+
+#include <linux/stddef.h>
+
+/**
+ * struct machine_desc - Describes a board controlled by a Meta.
+ * @name:		Board/SoC name.
+ * @dt_compat:		Array of device tree 'compatible' strings.
+ *
+ * @init_early:		Early init callback.
+ * @init_irq:		IRQ init callback for setting up IRQ controllers.
+ * @init_machine:	Arch init callback for setting up devices.
+ * @init_late:		Late init callback.
+ *
+ * This structure is provided by each board which can be controlled by a Meta.
+ * It is chosen by matching the compatible strings in the device tree provided
+ * by the bootloader with the strings in @dt_compat, and sets up any aspects of
+ * the machine that aren't configured with device tree (yet).
+ */
+struct machine_desc {
+	const char		*name;
+	const char		**dt_compat;
+
+	void			(*init_early)(void);
+	void			(*init_irq)(void);
+	void			(*init_machine)(void);
+	void			(*init_late)(void);
+};
+
+/*
+ * Current machine - only accessible during boot.
+ */
+extern struct machine_desc *machine_desc;
+
+/*
+ * Machine type table - also only accessible during boot
+ */
+extern struct machine_desc __arch_info_begin[], __arch_info_end[];
+#define for_each_machine_desc(p)			\
+	for (p = __arch_info_begin; p < __arch_info_end; p++)
+
+static inline struct machine_desc *default_machine_desc(void)
+{
+	/* the default machine is the last one linked in */
+	if (__arch_info_end - 1 < __arch_info_begin)
+		return NULL;
+	return __arch_info_end - 1;
+}
+
+/*
+ * Set of macros to define architecture features.  This is built into
+ * a table by the linker.
+ */
+#define MACHINE_START(_type, _name)			\
+static const struct machine_desc __mach_desc_##_type	\
+__used							\
+__attribute__((__section__(".arch.info.init"))) = {	\
+	.name		= _name,
+
+#define MACHINE_END				\
+};
+
+#endif /* _METAG_MACH_ARCH_H_ */
diff --git a/arch/metag/include/asm/setup.h b/arch/metag/include/asm/setup.h
new file mode 100644
index 0000000..e13083b
--- /dev/null
+++ b/arch/metag/include/asm/setup.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_METAG_SETUP_H
+#define _ASM_METAG_SETUP_H
+
+#include <uapi/asm/setup.h>
+
+void per_cpu_trap_init(unsigned long);
+extern void __init dump_machine_table(void);
+#endif /* _ASM_METAG_SETUP_H */
diff --git a/arch/metag/kernel/head.S b/arch/metag/kernel/head.S
new file mode 100644
index 0000000..8b13886
--- /dev/null
+++ b/arch/metag/kernel/head.S
@@ -0,0 +1,45 @@
+	! Copyright 2005,2006,2007,2009 Imagination Technologies
+
+#include <linux/init.h>
+#include <generated/asm-offsets.h>
+#undef __exit
+
+	__HEAD
+	! Setup the stack and get going into _metag_start_kernel
+	.global	__start
+	.type   __start,function
+__start:
+	! D1Ar1 contains pTBI (ISTAT)
+	! D0Ar2 contains pTBI
+	! D1Ar3 contains __pTBISegs
+	! D0Ar4 contains kernel arglist pointer
+
+	MOVT    D0Re0,#HI(___pTBIs)
+	ADD     D0Re0,D0Re0,#LO(___pTBIs)
+	SETL    [D0Re0],D0Ar2,D1Ar1
+	MOVT    D0Re0,#HI(___pTBISegs)
+	ADD     D0Re0,D0Re0,#LO(___pTBISegs)
+	SETD    [D0Re0],D1Ar3
+	MOV	A0FrP,#0
+	MOV	D0Re0,#0
+	MOV	D1Re0,#0
+	MOV	D1Ar3,#0
+	MOV	D1Ar1,D0Ar4			!Store kernel boot params
+	MOV	D1Ar5,#0
+	MOV	D0Ar6,#0
+#ifdef CONFIG_METAG_DSP
+	MOV	D0.8,#0
+#endif
+	MOVT    A0StP,#HI(_init_thread_union)
+	ADD	A0StP,A0StP,#LO(_init_thread_union)
+	ADD     A0StP,A0StP,#THREAD_INFO_SIZE
+	MOVT	D1RtP,#HI(_metag_start_kernel)
+	CALL	D1RtP,#LO(_metag_start_kernel)
+	.size	__start,.-__start
+
+	!! Needed by TBX
+	.global	__exit
+	.type   __exit,function
+__exit:
+	XOR     TXENABLE,D0Re0,D0Re0
+	.size	__exit,.-__exit
diff --git a/arch/metag/kernel/machines.c b/arch/metag/kernel/machines.c
new file mode 100644
index 0000000..2a48f55
--- /dev/null
+++ b/arch/metag/kernel/machines.c
@@ -0,0 +1,21 @@
+/*
+ *  arch/metag/kernel/machines.c
+ *
+ *  Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ *  Generic Meta Boards.
+ */
+
+#include <linux/init.h>
+#include <asm/irq.h>
+#include <asm/mach/arch.h>
+
+static const char *meta_boards_compat[] __initdata = {
+	"img,meta",
+	NULL,
+};
+
+MACHINE_START(META, "Generic Meta")
+	.dt_compat	= meta_boards_compat,
+	.init_irq	= init_soc_IRQ,
+MACHINE_END
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
new file mode 100644
index 0000000..5d7d8a1
--- /dev/null
+++ b/arch/metag/kernel/setup.c
@@ -0,0 +1,570 @@
+/*
+ * Copyright (C) 2005-2012 Imagination Technologies Ltd.
+ *
+ * This file contains the architecture-dependant parts of system setup.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/console.h>
+#include <linux/genhd.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/root_dev.h>
+#include <linux/initrd.h>
+#include <linux/seq_file.h>
+#include <linux/pfn.h>
+#include <linux/start_kernel.h>
+#include <linux/cpu.h>
+#include <linux/memblock.h>
+#include <linux/of_fdt.h>
+
+#include <asm/cachepart.h>
+#include <asm/clock.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/traps.h>
+#include <asm/mmu.h>
+#include <asm/cpu.h>
+#include <asm/hwthread.h>
+#include <asm/mmzone.h>
+#include <asm/l2cache.h>
+#include <asm/prom.h>
+#include <asm/mach/arch.h>
+#include <asm/core_reg.h>
+#include <asm/highmem.h>
+
+/* PRIV protect as many registers as possible. */
+#define DEFAULT_PRIV	0xff0f7f00
+
+/* Enable unaligned access checking. */
+#define UNALIGNED_PRIV	0x00000010
+
+#ifdef CONFIG_METAG_UNALIGNED
+#define PRIV_BITS (DEFAULT_PRIV | UNALIGNED_PRIV)
+#else
+#define PRIV_BITS DEFAULT_PRIV
+#endif
+
+extern char _heap_start[];
+
+#ifdef CONFIG_METAG_BUILTIN_DTB
+extern u32 __dtb_start[];
+#endif
+
+struct machine_desc *machine_desc __initdata;
+
+/*
+ * Map a Linux CPU number to a hardware thread ID
+ * In SMP this will be setup with the correct mapping at startup; in UP this
+ * will map to the HW thread on which we are running.
+ */
+u8 cpu_2_hwthread_id[NR_CPUS] __read_mostly = {
+	[0 ... NR_CPUS-1] = BAD_HWTHREAD_ID
+};
+
+/*
+ * Map a hardware thread ID to a Linux CPU number
+ * In SMP this will be fleshed out with the correct CPU ID for a particular
+ * hardware thread. In UP this will be initialised with the boot CPU ID.
+ */
+u8 hwthread_id_2_cpu[4] __read_mostly = {
+	[0 ... 3] = BAD_CPU_ID
+};
+
+/* The relative offset of the MMU mapped memory (from ldlk or bootloader)
+ * to the real physical memory.  This is needed as we have to use the
+ * physical addresses in the MMU tables (pte entries), and not the virtual
+ * addresses.
+ * This variable is used in the __pa() and __va() macros, and should
+ * probably only be used via them.
+ */
+unsigned int meta_memoffset;
+
+static char __initdata *original_cmd_line;
+#ifdef CONFIG_METAG_CMDLINE_BOOL
+static char __initdata builtin_cmdline[COMMAND_LINE_SIZE] =
+					CONFIG_METAG_CMDLINE;
+#endif
+
+DEFINE_PER_CPU(PTBI, pTBI);
+
+/*
+ * Mapping are specified as "CPU_ID:HWTHREAD_ID", e.g.
+ *
+ *	"hwthread_map=0:1,1:2,2:3,3:0"
+ *
+ *	Linux CPU ID	HWTHREAD_ID
+ *	---------------------------
+ *	    0		      1
+ *	    1		      2
+ *	    2		      3
+ *	    3		      0
+ */
+static int __init parse_hwthread_map(char *p)
+{
+	int cpu;
+
+	while (*p) {
+		cpu = (*p++) - '0';
+		if (cpu < 0 || cpu > 9)
+			goto err_cpu;
+
+		p++;		/* skip semi-colon */
+		cpu_2_hwthread_id[cpu] = (*p++) - '0';
+		if (cpu_2_hwthread_id[cpu] >= 4)
+			goto err_thread;
+		hwthread_id_2_cpu[cpu_2_hwthread_id[cpu]] = cpu;
+
+		if (*p == ',')
+			p++;		/* skip comma */
+	}
+
+	return 0;
+err_cpu:
+	pr_err("%s: hwthread_map cpu argument out of range\n", __func__);
+	return -EINVAL;
+err_thread:
+	pr_err("%s: hwthread_map thread argument out of range\n", __func__);
+	return -EINVAL;
+}
+early_param("hwthread_map", parse_hwthread_map);
+
+void __init dump_machine_table(void)
+{
+	struct machine_desc *p;
+	const char **compat;
+
+	pr_info("Available machine support:\n\tNAME\t\tCOMPATIBLE LIST\n");
+	for_each_machine_desc(p) {
+		pr_info("\t%s\t[", p->name);
+		for (compat = p->dt_compat; compat && *compat; ++compat)
+			printk(" '%s'", *compat);
+		printk(" ]\n");
+	}
+
+	pr_info("\nPlease check your kernel config and/or bootloader.\n");
+
+	hard_processor_halt(HALT_PANIC);
+}
+
+#ifdef CONFIG_METAG_HALT_ON_PANIC
+static int metag_panic_event(struct notifier_block *this, unsigned long event,
+			     void *ptr)
+{
+	hard_processor_halt(HALT_PANIC);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block metag_panic_block = {
+	metag_panic_event,
+	NULL,
+	0
+};
+#endif
+
+void __init setup_arch(char **cmdline_p)
+{
+	unsigned long start_pfn;
+	unsigned long text_start = (unsigned long)(&_stext);
+	unsigned long cpu = smp_processor_id();
+	unsigned long heap_start, heap_end;
+	unsigned long start_pte;
+	PTBI _pTBI;
+	PTBISEG p_heap;
+	int heap_id, i;
+
+	/* try interpreting the argument as a device tree */
+	machine_desc = setup_machine_fdt(original_cmd_line);
+	/* if it doesn't look like a device tree it must be a command line */
+	if (!machine_desc) {
+#ifdef CONFIG_METAG_BUILTIN_DTB
+		/* try the embedded device tree */
+		machine_desc = setup_machine_fdt(__dtb_start);
+		if (!machine_desc)
+			panic("Invalid embedded device tree.");
+#else
+		/* use the default machine description */
+		machine_desc = default_machine_desc();
+#endif
+		/* append the bootloader cmdline to any builtin fdt cmdline */
+		if (boot_command_line[0] && original_cmd_line[0])
+			strlcat(boot_command_line, " ", COMMAND_LINE_SIZE);
+		strlcat(boot_command_line, original_cmd_line,
+			COMMAND_LINE_SIZE);
+	}
+	setup_meta_clocks(machine_desc->clocks);
+
+#ifdef CONFIG_METAG_CMDLINE_BOOL
+#ifdef CONFIG_METAG_CMDLINE_OVERRIDE
+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+#else
+	if (builtin_cmdline[0] && boot_command_line[0]) {
+		/* prepend builtin cmdline */
+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	}
+#endif
+#endif
+
+	*cmdline_p = boot_command_line;
+	parse_early_param();
+
+	/*
+	 * Make sure we don't alias in dcache or icache
+	 */
+	check_for_cache_aliasing(cpu);
+
+
+#ifdef CONFIG_METAG_HALT_ON_PANIC
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &metag_panic_block);
+#endif
+
+#ifdef CONFIG_DUMMY_CONSOLE
+	conswitchp = &dummy_con;
+#endif
+
+	if (!(TBI_GETREG(TXSTATUS) & 0x20000))
+		panic("Privilege must be enabled for this thread.");
+
+	_pTBI = __TBI(TBID_ISTAT_BIT);
+
+	per_cpu(pTBI, cpu) = _pTBI;
+
+	if (!per_cpu(pTBI, cpu))
+		panic("No TBI found!");
+
+	/*
+	 * Initialize all interrupt vectors to our copy of __TBIUnExpXXX,
+	 * rather than the version from the bootloader. This makes call
+	 * stacks easier to understand and may allow us to unmap the
+	 * bootloader at some point.
+	 *
+	 * We need to keep the LWK handler that TBI installed in order to
+	 * be able to do inter-thread comms.
+	 */
+	for (i = 0; i <= TBID_SIGNUM_MAX; i++)
+		if (i != TBID_SIGNUM_LWK)
+			_pTBI->fnSigs[i] = __TBIUnExpXXX;
+
+	/* A Meta requirement is that the kernel is loaded (virtually)
+	 * at the PAGE_OFFSET.
+	 */
+	if (PAGE_OFFSET != text_start)
+		panic("Kernel not loaded at PAGE_OFFSET (%#x) but at %#lx.",
+		      PAGE_OFFSET, text_start);
+
+	start_pte = mmu_read_second_level_page(text_start);
+
+	/*
+	 * Kernel pages should have the PRIV bit set by the bootloader.
+	 */
+	if (!(start_pte & _PAGE_KERNEL))
+		panic("kernel pte does not have PRIV set");
+
+	/*
+	 * See __pa and __va in include/asm/page.h.
+	 * This value is negative when running in local space but the
+	 * calculations work anyway.
+	 */
+	meta_memoffset = text_start - (start_pte & PAGE_MASK);
+
+	/* Now lets look at the heap space */
+	heap_id = (__TBIThreadId() & TBID_THREAD_BITS)
+		+ TBID_SEG(0, TBID_SEGSCOPE_LOCAL, TBID_SEGTYPE_HEAP);
+
+	p_heap = __TBIFindSeg(NULL, heap_id);
+
+	if (!p_heap)
+		panic("Could not find heap from TBI!");
+
+	/* The heap begins at the first full page after the kernel data. */
+	heap_start = (unsigned long) &_heap_start;
+
+	/* The heap ends at the end of the heap segment specified with
+	 * ldlk.
+	 */
+	if (is_global_space(text_start)) {
+		pr_debug("WARNING: running in global space!\n");
+		heap_end = (unsigned long)p_heap->pGAddr + p_heap->Bytes;
+	} else {
+		heap_end = (unsigned long)p_heap->pLAddr + p_heap->Bytes;
+	}
+
+	ROOT_DEV = Root_RAM0;
+
+	/* init_mm is the mm struct used for the first task.  It is then
+	 * cloned for all other tasks spawned from that task.
+	 *
+	 * Note - we are using the virtual addresses here.
+	 */
+	init_mm.start_code = (unsigned long)(&_stext);
+	init_mm.end_code = (unsigned long)(&_etext);
+	init_mm.end_data = (unsigned long)(&_edata);
+	init_mm.brk = (unsigned long)heap_start;
+
+	min_low_pfn = PFN_UP(__pa(text_start));
+	max_low_pfn = PFN_DOWN(__pa(heap_end));
+
+	pfn_base = min_low_pfn;
+
+	/* Round max_pfn up to a 4Mb boundary. The free_bootmem_node()
+	 * call later makes sure to keep the rounded up pages marked reserved.
+	 */
+	max_pfn = max_low_pfn + ((1 << MAX_ORDER) - 1);
+	max_pfn &= ~((1 << MAX_ORDER) - 1);
+
+	start_pfn = PFN_UP(__pa(heap_start));
+
+	if (min_low_pfn & ((1 << MAX_ORDER) - 1)) {
+		/* Theoretically, we could expand the space that the
+		 * bootmem allocator covers - much as we do for the
+		 * 'high' address, and then tell the bootmem system
+		 * that the lowest chunk is 'not available'.  Right
+		 * now it is just much easier to constrain the
+		 * user to always MAX_ORDER align their kernel space.
+		 */
+
+		panic("Kernel must be %d byte aligned, currently at %#lx.",
+		      1 << (MAX_ORDER + PAGE_SHIFT),
+		      min_low_pfn << PAGE_SHIFT);
+	}
+
+#ifdef CONFIG_HIGHMEM
+	highstart_pfn = highend_pfn = max_pfn;
+	high_memory = (void *) __va(PFN_PHYS(highstart_pfn));
+#else
+	high_memory = (void *)__va(PFN_PHYS(max_pfn));
+#endif
+
+	paging_init(heap_end);
+
+	setup_txprivext();
+
+	/* Setup the boot cpu's mapping. The rest will be setup below. */
+	cpu_2_hwthread_id[smp_processor_id()] = hard_processor_id();
+	hwthread_id_2_cpu[hard_processor_id()] = smp_processor_id();
+
+	unflatten_device_tree();
+
+#ifdef CONFIG_SMP
+	smp_init_cpus();
+#endif
+
+	if (machine_desc->init_early)
+		machine_desc->init_early();
+}
+
+static int __init customize_machine(void)
+{
+	/* customizes platform devices, or adds new ones */
+	if (machine_desc->init_machine)
+		machine_desc->init_machine();
+	return 0;
+}
+arch_initcall(customize_machine);
+
+static int __init init_machine_late(void)
+{
+	if (machine_desc->init_late)
+		machine_desc->init_late();
+	return 0;
+}
+late_initcall(init_machine_late);
+
+static const char *get_cpu_capabilities(unsigned int txenable)
+{
+#ifdef CONFIG_METAG_META21
+	/* See CORE_ID in META HTP.GP TRM - Architecture Overview 2.1.238 */
+	int coreid = metag_in32(METAC_CORE_ID);
+	unsigned int dsp_type = (coreid >> 3) & 7;
+	unsigned int fpu_type = (coreid >> 7) & 3;
+
+	switch (dsp_type | fpu_type << 3) {
+	case (0x00): return "EDSP";
+	case (0x01): return "DSP";
+	case (0x08): return "EDSP+LFPU";
+	case (0x09): return "DSP+LFPU";
+	case (0x10): return "EDSP+FPU";
+	case (0x11): return "DSP+FPU";
+	}
+	return "UNKNOWN";
+
+#else
+	if (!(txenable & TXENABLE_CLASS_BITS))
+		return "DSP";
+	else
+		return "";
+#endif
+}
+
+/*
+ *	Get CPU information for use by the procfs.
+ */
+#ifdef CONFIG_PROC_FS
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	const char *cpu;
+	unsigned int txenable, thread_id, major, minor;
+	unsigned long clockfreq = get_coreclock();
+#ifdef CONFIG_SMP
+	int i;
+	unsigned long lpj;
+#endif
+
+	cpu = "META";
+
+	asm __volatile__("MOV %0,TXENABLE\n" : "=r" (txenable));
+	major = (txenable & TXENABLE_MAJOR_REV_BITS) >> TXENABLE_MAJOR_REV_S;
+	minor = (txenable & TXENABLE_MINOR_REV_BITS) >> TXENABLE_MINOR_REV_S;
+	thread_id = (txenable >> 8) & 0x3;
+
+
+#ifdef CONFIG_SMP
+	for_each_online_cpu(i) {
+		lpj = per_cpu(cpu_data, i).loops_per_jiffy;
+		txenable = core_reg_read(TXUCT_ID, TXENABLE_REGNUM,
+							cpu_2_hwthread_id[i]);
+
+		seq_printf(m, "CPU:\t\t%s %d.%d (thread %d)\n"
+			      "Clocking:\t%lu.%1luMHz\n"
+			      "BogoMips:\t%lu.%02lu\n"
+			      "Calibration:\t%lu loops\n"
+			      "Capabilities:\t%s\n\n",
+			      cpu, major, minor, i,
+			      clockfreq / 1000000, (clockfreq / 100000) % 10,
+			      lpj / (500000 / HZ), (lpj / (5000 / HZ)) % 100,
+			      lpj,
+			      get_cpu_capabilities(txenable));
+	}
+#else
+	seq_printf(m, "CPU:\t\t%s %d.%d (thread %d)\n"
+		   "Clocking:\t%lu.%1luMHz\n"
+		   "BogoMips:\t%lu.%02lu\n"
+		   "Calibration:\t%lu loops\n"
+		   "Capabilities:\t%s\n",
+		   cpu, major, minor, thread_id,
+		   clockfreq / 1000000, (clockfreq / 100000) % 10,
+		   loops_per_jiffy / (500000 / HZ),
+		   (loops_per_jiffy / (5000 / HZ)) % 100,
+		   loops_per_jiffy,
+		   get_cpu_capabilities(txenable));
+#endif /* CONFIG_SMP */
+
+#ifdef CONFIG_METAG_L2C
+	if (meta_l2c_is_present()) {
+		seq_printf(m, "L2 cache:\t%s\n"
+			      "L2 cache size:\t%d KB\n",
+			      meta_l2c_is_enabled() ? "enabled" : "disabled",
+			      meta_l2c_size() >> 10);
+	}
+#endif
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return (void *)(*pos == 0);
+}
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return NULL;
+}
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+const struct seq_operations cpuinfo_op = {
+	.start = c_start,
+	.next  = c_next,
+	.stop  = c_stop,
+	.show  = show_cpuinfo,
+};
+#endif /* CONFIG_PROC_FS */
+
+void __init metag_start_kernel(char *args)
+{
+	/* Zero the timer register so timestamps are from the point at
+	 * which the kernel started running.
+	 */
+	TBI_SETREG(TXTIMER, 0);
+
+	/* Clear the bss. */
+	memset(__bss_start, 0,
+	       (unsigned long)__bss_stop - (unsigned long)__bss_start);
+
+	/* Remember where these are for use in setup_arch */
+	original_cmd_line = args;
+
+	current_thread_info()->cpu = hard_processor_id();
+
+	start_kernel();
+}
+
+/*
+ * Setup TXPRIVEXT register to be prevent userland from touching our
+ * precious registers.
+ */
+void setup_txprivext(void)
+{
+	TBI_SETREG(TXPRIVEXT, PRIV_BITS);
+}
+
+PTBI pTBI_get(unsigned int cpu)
+{
+	return per_cpu(pTBI, cpu);
+}
+
+#if defined(CONFIG_METAG_DSP) && defined(CONFIG_METAG_FPU)
+char capabilites[] = "dsp fpu";
+#elif defined(CONFIG_METAG_DSP)
+char capabilites[] = "dsp";
+#elif defined(CONFIG_METAG_FPU)
+char capabilites[] = "fpu";
+#else
+char capabilites[] = "";
+#endif
+
+static struct ctl_table caps_kern_table[] = {
+	{
+		.procname	= "capabilities",
+		.data		= capabilites,
+		.maxlen		= sizeof(capabilites),
+		.mode		= 0444,
+		.proc_handler	= proc_dostring,
+	},
+	{}
+};
+
+static struct ctl_table caps_root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= caps_kern_table,
+	},
+	{}
+};
+
+static int __init capabilities_register_sysctl(void)
+{
+	struct ctl_table_header *caps_table_header;
+
+	caps_table_header = register_sysctl_table(caps_root_table);
+	if (!caps_table_header) {
+		pr_err("Unable to register CAPABILITIES sysctl\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+core_initcall(capabilities_register_sysctl);
-- 
1.7.7.6


