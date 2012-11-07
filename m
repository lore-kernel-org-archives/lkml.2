Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2KGJxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:53:11 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:39264 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2KGJsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:25 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
Date: Wed,  7 Nov 2012 10:47:31 +0100
Message-Id: <1352281674-2186-9-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* L1_CACHE_SHIFT
* PAGE_SIZE, PAGE_OFFSET
* struct pt_regs, struct user_regs_struct
* struct thread_struct, cpu_relax(), task_pt_regs(), start_thread(), ...
* struct thread_info, THREAD_SIZE, INIT_THREAD_INFO(), TIF_*, ...
* BUG()
* ELF_*
* Elf_*

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/bug.h         |   37 +++++++++
 arch/arc/include/asm/cache.h       |   21 +++++
 arch/arc/include/asm/elf.h         |   97 ++++++++++++++++++++++++
 arch/arc/include/asm/exec.h        |   15 ++++
 arch/arc/include/asm/kdebug.h      |   19 +++++
 arch/arc/include/asm/linkage.h     |   30 ++++++++
 arch/arc/include/asm/module.h      |   17 ++++
 arch/arc/include/asm/page.h        |   42 +++++++++++
 arch/arc/include/asm/processor.h   |  143 ++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/ptrace.h      |  120 ++++++++++++++++++++++++++++++
 arch/arc/include/asm/sections.h    |   17 ++++
 arch/arc/include/asm/thread_info.h |  120 ++++++++++++++++++++++++++++++
 12 files changed, 678 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/bug.h
 create mode 100644 arch/arc/include/asm/cache.h
 create mode 100644 arch/arc/include/asm/elf.h
 create mode 100644 arch/arc/include/asm/exec.h
 create mode 100644 arch/arc/include/asm/kdebug.h
 create mode 100644 arch/arc/include/asm/linkage.h
 create mode 100644 arch/arc/include/asm/module.h
 create mode 100644 arch/arc/include/asm/page.h
 create mode 100644 arch/arc/include/asm/processor.h
 create mode 100644 arch/arc/include/asm/ptrace.h
 create mode 100644 arch/arc/include/asm/sections.h
 create mode 100644 arch/arc/include/asm/thread_info.h

diff --git a/arch/arc/include/asm/bug.h b/arch/arc/include/asm/bug.h
new file mode 100644
index 0000000..2ad8f9b
--- /dev/null
+++ b/arch/arc/include/asm/bug.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_BUG_H
+#define _ASM_ARC_BUG_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/ptrace.h>
+
+struct task_struct;
+
+void show_regs(struct pt_regs *regs);
+void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs);
+void show_kernel_fault_diag(const char *str, struct pt_regs *regs,
+			    unsigned long address, unsigned long cause_reg);
+void die(const char *str, struct pt_regs *regs, unsigned long address,
+	 unsigned long cause_reg);
+
+#define BUG()	do {				\
+	dump_stack();					\
+	pr_warn("Kernel BUG in %s: %s: %d!\n",	\
+		__FILE__, __func__,  __LINE__);	\
+} while (0)
+
+#define HAVE_ARCH_BUG
+
+#include <asm-generic/bug.h>
+
+#endif	/* !__ASSEMBLY__ */
+
+#endif
diff --git a/arch/arc/include/asm/cache.h b/arch/arc/include/asm/cache.h
new file mode 100644
index 0000000..30c72a4
--- /dev/null
+++ b/arch/arc/include/asm/cache.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARC_ASM_CACHE_H
+#define __ARC_ASM_CACHE_H
+
+/* In case $$ not config, setup a dummy number for rest of kernel */
+#ifndef CONFIG_ARC_CACHE_LINE_SHIFT
+#define L1_CACHE_SHIFT		6
+#else
+#define L1_CACHE_SHIFT		CONFIG_ARC_CACHE_LINE_SHIFT
+#endif
+
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+#endif /* _ASM_CACHE_H */
diff --git a/arch/arc/include/asm/elf.h b/arch/arc/include/asm/elf.h
new file mode 100644
index 0000000..147284f
--- /dev/null
+++ b/arch/arc/include/asm/elf.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_ELF_H
+#define __ASM_ARC_ELF_H
+
+#include <asm/ptrace.h>
+
+#define EM_ARCOMPACT		93
+
+/* Machine specific ELF Hdr flags */
+#define EF_ARC_OSABI_MSK	0x00000f00
+#define EF_ARC_OSABI_ORIG	0x00000000   /* MUST be zero for back-compat */
+#define EF_ARC_OSABI_V2		0x00000200
+
+/* ARC Relocations (kernel Modules only) */
+#define  R_ARC_32		0x4
+#define  R_ARC_32_ME		0x1B
+#define  R_ARC_S25H_PCREL	0x10
+#define  R_ARC_S25W_PCREL	0x11
+
+typedef unsigned long elf_greg_t;
+typedef unsigned long elf_fpregset_t;
+
+
+/* core dump regs is in the order pt_regs, callee_regs, stop_pc (for gdb) */
+#define ELF_NGREG	((sizeof(struct pt_regs) + sizeof(struct callee_regs) \
+			  + sizeof(unsigned long)) / sizeof(elf_greg_t))
+
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+/*
+ * To ensure that
+ *  -we don't load something for the wrong architecture.
+ *  -The userspace is using the correct syscall ABI
+ */
+struct elf32_hdr;
+extern int elf_check_arch(const struct elf32_hdr *);
+#define elf_check_arch	elf_check_arch
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_ARCH		EM_ARCOMPACT
+#define ELF_CLASS		ELFCLASS32
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define ELF_DATA		ELFDATA2MSB
+#else
+#define ELF_DATA		ELFDATA2LSB
+#endif
+
+#ifdef __KERNEL__
+
+#define CORE_DUMP_USE_REGSET
+
+#define ELF_EXEC_PAGESIZE	PAGE_SIZE
+
+/*
+ * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+ * use of this is to invoke "./ld.so someprog" to test out a new version of
+ * the loader.  We need to make sure that it is out of the way of the program
+ * that it will "exec", and that there is sufficient room for the brk.
+ */
+#define ELF_ET_DYN_BASE		(2 * TASK_SIZE / 3)
+
+/*
+ * When the program starts, a1 contains a pointer to a function to be
+ * registered with atexit, as per the SVR4 ABI.  A value of 0 means we
+ * have no such handler.
+ */
+#define ELF_PLAT_INIT(_r, load_addr)	((_r)->r0 = 0)
+
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+#define ELF_HWCAP	(0)
+
+/*
+ * This yields a string that ld.so will use to load implementation
+ * specific libraries for optimization.  This is more specific in
+ * intent than poking at uname or /proc/cpuinfo.
+ */
+#define ELF_PLATFORM	(NULL)
+
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
+
+#endif  /* __KERNEL__ */
+
+#endif
diff --git a/arch/arc/include/asm/exec.h b/arch/arc/include/asm/exec.h
new file mode 100644
index 0000000..28abc69
--- /dev/null
+++ b/arch/arc/include/asm/exec.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_EXEC_H
+#define __ASM_ARC_EXEC_H
+
+/* Align to 16b */
+#define arch_align_stack(p) ((unsigned long)(p) & ~0xf)
+
+#endif
diff --git a/arch/arc/include/asm/kdebug.h b/arch/arc/include/asm/kdebug.h
new file mode 100644
index 0000000..3fbe6c4
--- /dev/null
+++ b/arch/arc/include/asm/kdebug.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_KDEBUG_H
+#define _ASM_ARC_KDEBUG_H
+
+enum die_val {
+	DIE_UNUSED,
+	DIE_TRAP,
+	DIE_IERR,
+	DIE_OOPS
+};
+
+#endif
diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
new file mode 100644
index 0000000..a45d1bb
--- /dev/null
+++ b/arch/arc/include/asm/linkage.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_LINKAGE_H
+#define __ASM_LINKAGE_H
+
+#ifdef __ASSEMBLY__
+
+/* Can't use the ENTRY macro in linux/linkage.h
+ * gas considers ';' as comment vs. newline
+ */
+.macro ARC_ENTRY name
+	.global \name
+	.align 4
+	\name:
+.endm
+
+.macro ARC_EXIT name
+#define ASM_PREV_SYM_ADDR(name)  .-##name
+	.size \ name, ASM_PREV_SYM_ADDR(\name)
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#endif
diff --git a/arch/arc/include/asm/module.h b/arch/arc/include/asm/module.h
new file mode 100644
index 0000000..165d768
--- /dev/null
+++ b/arch/arc/include/asm/module.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+
+ */
+
+#ifndef _ASM_ARC_MODULE_H
+#define _ASM_ARC_MODULE_H
+
+#include <asm-generic/module.h>
+
+#endif /* _ASM_ARC_MODULE_H */
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
new file mode 100644
index 0000000..7cd1224
--- /dev/null
+++ b/arch/arc/include/asm/page.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_PAGE_H
+#define __ASM_ARC_PAGE_H
+
+/* PAGE_SHIFT determines the page size */
+#if defined(CONFIG_ARC_PAGE_SIZE_16K)
+#define PAGE_SHIFT 14
+#elif defined(CONFIG_ARC_PAGE_SIZE_4K)
+#define PAGE_SHIFT 12
+#else
+/*
+ * Default 8k
+ * done this way (instead of under CONFIG_ARC_PAGE_SIZE_8K) because adhoc
+ * user code (busybox appletlib.h) expects PAGE_SHIFT to be defined w/o
+ * using the correct uClibc header and in their build our autoconf.h is
+ * not available
+ */
+#define PAGE_SHIFT 13
+#endif
+
+#ifdef __ASSEMBLY__
+#define PAGE_SIZE	(1 << PAGE_SHIFT)
+#define PAGE_OFFSET	(0x80000000)
+#else
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)	/* Default 8K */
+#define PAGE_OFFSET	(0x80000000UL)	/* Kernel starts at 2G onwards */
+#endif
+
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
new file mode 100644
index 0000000..e2445bc
--- /dev/null
+++ b/arch/arc/include/asm/processor.h
@@ -0,0 +1,143 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: March 2009
+ *  -Implemented task_pt_regs( )
+ *
+ * Amit Bhor, Sameer Dhavale, Ashwin Chaugule: Codito Technologies 2004
+ */
+
+#ifndef __ASM_ARC_PROCESSOR_H
+#define __ASM_ARC_PROCESSOR_H
+
+#if defined(__KERNEL__)
+
+#if !defined(__ASSEMBLY__)
+
+#include <asm/arcregs.h>	/* for STATUS_E1_MASK et all */
+
+/* Arch specific stuff which needs to be saved per task.
+ * However these items are not so important so as to earn a place in
+ * struct thread_info
+ */
+struct thread_struct {
+	unsigned long ksp;	/* kernel mode stack pointer */
+	unsigned long callee_reg;	/* pointer to callee regs */
+	unsigned long fault_address;	/* dbls as brkpt holder as well */
+	unsigned long cause_code;	/* Exception Cause Code (ECR) */
+};
+
+#define INIT_THREAD  {                          \
+	.ksp = sizeof(init_stack) + (unsigned long) init_stack, \
+}
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+/*
+ * Return saved PC of a blocked thread.
+ */
+unsigned long thread_saved_pc(struct task_struct *t);
+
+#define task_pt_regs(p) \
+	((struct pt_regs *)(THREAD_SIZE - 4 + (void *)task_stack_page(p)) - 1)
+
+/* Free all resources held by a thread. */
+#define release_thread(thread) do { } while (0)
+
+/* Prepare to copy thread state - unlazy all lazy status */
+#define prepare_to_copy(tsk)    do { } while (0)
+
+#define cpu_relax()	do { } while (0)
+
+/*
+ * Create a new kernel thread
+ */
+
+extern int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags);
+
+#define copy_segments(tsk, mm)      do { } while (0)
+#define release_segments(mm)        do { } while (0)
+
+#define KSTK_EIP(tsk)   (task_pt_regs(tsk)->ret)
+
+/*
+ * Where abouts of Task's sp, fp, blink when it was last seen in kernel mode.
+ * These can't be derived from pt_regs as that would give correp user-mode val
+ */
+#define KSTK_ESP(tsk)   (tsk->thread.ksp)
+#define KSTK_BLINK(tsk) (*((unsigned int *)((KSTK_ESP(tsk)) + (13+1+1)*4)))
+#define KSTK_FP(tsk)    (*((unsigned int *)((KSTK_ESP(tsk)) + (13+1)*4)))
+
+/*
+ * Do necessary setup to start up a newly executed thread.
+ *
+ * E1,E2 so that Interrupts are enabled in user mode
+ * L set, so Loop inhibited to begin with
+ * lp_start and lp_end seeded with bogus non-zero values so to easily catch
+ * the ARC700 sr to lp_start hardware bug
+ */
+#define start_thread(_regs, _pc, _usp)				\
+do {								\
+	set_fs(USER_DS); /* reads from user space */		\
+	(_regs)->ret = (_pc);					\
+	/* Interrupts enabled in User Mode */			\
+	(_regs)->status32 = STATUS_U_MASK | STATUS_L_MASK	\
+		| STATUS_E1_MASK | STATUS_E2_MASK;		\
+	(_regs)->sp = (_usp);					\
+	/* bogus seed values for debugging */			\
+	(_regs)->lp_start = 0x10;				\
+	(_regs)->lp_end = 0x80;					\
+} while (0)
+
+extern unsigned int get_wchan(struct task_struct *p);
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ * Should the PC register be read instead ? This macro does not seem to
+ * be used in many places so this wont be all that bad.
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+#endif /* !__ASSEMBLY__ */
+
+/* Kernels Virtual memory area.
+ * Unlike other architectures(MIPS, sh, cris ) ARC 700 does not have a
+ * "kernel translated" region (like KSEG2 in MIPS). So we use a upper part
+ * of the translated bottom 2GB for kernel virtual memory and protect
+ * these pages from user accesses by disabling Ru, Eu and Wu.
+ */
+#define VMALLOC_SIZE	(0x10000000)	/* 256M */
+#define VMALLOC_START	(PAGE_OFFSET - VMALLOC_SIZE)
+#define VMALLOC_END	(PAGE_OFFSET)
+
+/* Most of the architectures seem to be keeping some kind of padding between
+ * userspace TASK_SIZE and PAGE_OFFSET. i.e TASK_SIZE != PAGE_OFFSET.
+ */
+#define USER_KERNEL_GUTTER    0x10000000
+
+/* User address space:
+ * On ARC700, CPU allows the entire lower half of 32 bit address space to be
+ * translated. Thus potentially 2G (0:0x7FFF_FFFF) could be User vaddr space.
+ * However we steal 256M for kernel addr (0x7000_0000:0x7FFF_FFFF) and another
+ * 256M (0x6000_0000:0x6FFF_FFFF) is gutter between user/kernel spaces
+ * Thus total User vaddr space is (0:0x5FFF_FFFF)
+ */
+#define TASK_SIZE	(PAGE_OFFSET - VMALLOC_SIZE - USER_KERNEL_GUTTER)
+
+#define STACK_TOP       TASK_SIZE
+#define STACK_TOP_MAX   STACK_TOP
+
+/* This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE      (TASK_SIZE / 3)
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_ARC_PROCESSOR_H */
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
new file mode 100644
index 0000000..c178357
--- /dev/null
+++ b/arch/arc/include/asm/ptrace.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef __ASM_ARC_PTRACE_H
+#define __ASM_ARC_PTRACE_H
+
+/*
+ * XXX: ABI hack.
+ * The offset calc can be cleanly done in asm-offset.c, however gdb includes
+ * this header directly.
+ */
+#define PT_bta		4
+#define PT_lp_start	8
+#define PT_lp_end	12
+#define PT_lp_count	16
+#define PT_status32	20
+#define PT_ret		24
+#define PT_blink	28
+#define PT_fp		32
+#define PT_r26		36
+#define PT_r12		40
+#define PT_r11		44
+#define PT_r10		48
+#define PT_r9		52
+#define PT_r8		56
+#define PT_r7		60
+#define PT_r6		64
+#define PT_r5		68
+#define PT_r4		72
+#define PT_r3		76
+#define PT_r2		80
+#define PT_r1		84
+#define PT_r0		88
+#define PT_sp		92
+#define PT_orig_r0	96
+#define PT_orig_r8	100
+
+#ifndef __ASSEMBLY__
+
+/* THE pt_regs: Defines how regs are saved during entry into kernel */
+
+struct pt_regs {
+	/*
+	 * 1 word gutter after reg-file has been saved
+	 * Technically not needed, Since SP always points to a "full" location
+	 * (vs. "empty"). But pt_regs is shared with tools....
+	 */
+	long res;
+
+	/* Real registers */
+	long bta;	/* bta_l1, bta_l2, erbta */
+	long lp_start;
+	long lp_end;
+	long lp_count;
+	long status32;	/* status32_l1, status32_l2, erstatus */
+	long ret;	/* ilink1, ilink2 or eret */
+	long blink;
+	long fp;
+	long r26;	/* gp */
+	long r12;
+	long r11;
+	long r10;
+	long r9;
+	long r8;
+	long r7;
+	long r6;
+	long r5;
+	long r4;
+	long r3;
+	long r2;
+	long r1;
+	long r0;
+	long sp;	/* user/kernel sp depending on where we came from  */
+	long orig_r0;
+	long orig_r8;	/*to distinguish bet excp, sys call, int1 or int2 */
+};
+
+/* Callee saved registers - need to be saved only when you are scheduled out */
+
+struct callee_regs {
+	long res;	/* Again this is not needed */
+	long r25;
+	long r24;
+	long r23;
+	long r22;
+	long r21;
+	long r20;
+	long r19;
+	long r18;
+	long r17;
+	long r16;
+	long r15;
+	long r14;
+	long r13;
+};
+
+/* User mode registers, used for core dumps. */
+struct user_regs_struct {
+	struct pt_regs scratch;
+	struct callee_regs callee;
+	long efa;	/* break pt addr, for break points in delay slots */
+	long stop_pc;	/* give dbg stop_pc directly after checking orig_r8 */
+};
+
+#define instruction_pointer(regs)	((regs)->ret)
+#define profile_pc(regs)		instruction_pointer(regs)
+
+/* return 1 if user mode or 0 if kernel mode */
+#define user_mode(regs) (regs->status32 & STATUS_U_MASK)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/include/asm/sections.h b/arch/arc/include/asm/sections.h
new file mode 100644
index 0000000..fc15f2e
--- /dev/null
+++ b/arch/arc/include/asm/sections.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SECTIONS_H
+#define _ASM_ARC_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+extern char _int_vec_base_lds[];
+extern char __arc_dccm_base[];
+
+#endif
diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
new file mode 100644
index 0000000..937a818
--- /dev/null
+++ b/arch/arc/include/asm/thread_info.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: Oct 2009
+ *  No need for ARC specific thread_info allocator (kmalloc/free). This is
+ *  anyways one page allocation, thus slab alloc can be short-circuited and
+ *  the generic version (get_free_page) would be loads better.
+ *
+ * Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#include <asm/page.h>
+
+#ifdef CONFIG_16KSTACKS
+#define THREAD_SIZE_ORDER 1
+#else
+#define THREAD_SIZE_ORDER 0
+#endif
+
+#define THREAD_SIZE     (PAGE_SIZE << THREAD_SIZE_ORDER)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/thread_info.h>
+#include <asm/segment.h>
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants
+ *   must also be changed
+ */
+struct thread_info {
+	unsigned long flags;		/* low level flags */
+	int preempt_count;		/* 0 => preemptable, <0 => BUG */
+	struct task_struct *task;	/* main task structure */
+	mm_segment_t addr_limit;	/* thread address space */
+	struct exec_domain *exec_domain;/* execution domain */
+	__u32 cpu;			/* current CPU */
+	unsigned long thr_ptr;		/* TLS ptr */
+	struct restart_block restart_block;
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task       = &tsk,			\
+	.exec_domain    = &default_exec_domain,	\
+	.flags      = 0,			\
+	.cpu        = 0,			\
+	.preempt_count  = INIT_PREEMPT_COUNT,	\
+	.addr_limit = KERNEL_DS,		\
+	.restart_block  = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info    (init_thread_union.thread_info)
+#define init_stack          (init_thread_union.stack)
+
+static inline __attribute_const__ struct thread_info *current_thread_info(void)
+{
+	register unsigned long sp asm("sp");
+	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#define PREEMPT_ACTIVE      0x10000000
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need to
+ *   access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_RESTORE_SIGMASK	0	/* restore sig mask in do_signal() */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
+#define TIF_SYSCALL_TRACE	15	/* syscall trace active */
+
+/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_MEMDIE		16
+
+#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_MEMDIE		(1<<TIF_MEMDIE)
+
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		(0x0000FFFF & ~_TIF_SYSCALL_TRACE)
+
+/*
+ * _TIF_ALLWORK_MASK includes SYSCALL_TRACE, but we don't need it.
+ * SYSCALL_TRACE is anways seperately/unconditionally tested right after a
+ * syscall, so all that reamins to be tested is _TIF_WORK_MASK
+ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_THREAD_INFO_H */
-- 
1.7.4.1

