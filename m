Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0LYSpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 13:45:43 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:46533 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0LYSpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 13:45:39 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: =?gb2312?B?0anMziC53A==?= <guanxuetao@mprc.pku.edu.cn>
Subject: [PATCHv1 03/12] unicore32 core architecture: processor and system headers
Date: Sun, 26 Dec 2010 02:45:31 +0800
Message-ID: <00ca01cba463$e818fb60$b84af220$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcukY8L427zsRILHQAuwiTTuk7QuHw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

This patch includes processor and system headers. System call interface is here.
  We used the similar syscall interface as ARM formerly, so the similar calls.S, unistd.h
   and sys_unicore.c. While we are defining new ABI, it will use the syscall numbers in
   asm-generic/unistd.h.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/byteorder.h  |   24 ++
 arch/unicore32/include/asm/cpu-single.h |   45 +++
 arch/unicore32/include/asm/cputype.h    |   33 +++
 arch/unicore32/include/asm/hwcap.h      |   32 +++
 arch/unicore32/include/asm/processor.h  |   92 +++++++
 arch/unicore32/include/asm/system.h     |  171 ++++++++++++
 arch/unicore32/include/asm/unistd.h     |  450 +++++++++++++++++++++++++++++++
 arch/unicore32/kernel/calls.S           |  390 ++++++++++++++++++++++++++
 arch/unicore32/kernel/sys_unicore.c     |  132 +++++++++
 arch/unicore32/mm/proc-macros.S         |  145 ++++++++++
 arch/unicore32/mm/proc-ucv2.S           |  134 +++++++++
 11 files changed, 1648 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/byteorder.h b/arch/unicore32/include/asm/byteorder.h
new file mode 100644
index 0000000..ebe1b3f
--- /dev/null
+++ b/arch/unicore32/include/asm/byteorder.h
@@ -0,0 +1,24 @@
+/*
+ * linux/arch/unicore32/include/asm/byteorder.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * UniCore ONLY support Little Endian mode, the data bus is connected such
+ * that byte accesses appear as:
+ *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
+ * and word accesses (data or instruction) appear as:
+ *  d0...d31
+ */
+#ifndef __UNICORE_BYTEORDER_H__
+#define __UNICORE_BYTEORDER_H__
+
+#include <linux/byteorder/little_endian.h>
+
+#endif
+
diff --git a/arch/unicore32/include/asm/cpu-single.h b/arch/unicore32/include/asm/cpu-single.h
new file mode 100644
index 0000000..0f55d18
--- /dev/null
+++ b/arch/unicore32/include/asm/cpu-single.h
@@ -0,0 +1,45 @@
+/*
+ * linux/arch/unicore32/include/asm/cpu-single.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_CPU_SINGLE_H__
+#define __UNICORE_CPU_SINGLE_H__
+
+#include <asm/page.h>
+#include <asm/memory.h>
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#define cpu_switch_mm(pgd, mm) cpu_do_switch_mm(virt_to_phys(pgd), mm)
+
+#define cpu_get_pgd()					\
+	({						\
+		unsigned long pg;			\
+		__asm__("movc	%0, p0.c2, #0"		\
+			 : "=r" (pg) : : "cc");		\
+		pg &= ~0x0fff;				\
+		(pgd_t *)phys_to_virt(pg);		\
+	})
+
+struct mm_struct;
+
+/* declare all the functions as extern */
+extern void cpu_proc_fin(void);
+extern int cpu_do_idle(void);
+extern void cpu_dcache_clean_area(void *, int);
+extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+extern void cpu_set_pte(pte_t *ptep, pte_t pte);
+extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* __UNICORE_CPU_SINGLE_H__ */
diff --git a/arch/unicore32/include/asm/cputype.h b/arch/unicore32/include/asm/cputype.h
new file mode 100644
index 0000000..ec1a30f
--- /dev/null
+++ b/arch/unicore32/include/asm/cputype.h
@@ -0,0 +1,33 @@
+/*
+ * linux/arch/unicore32/include/asm/cputype.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_CPUTYPE_H__
+#define __UNICORE_CPUTYPE_H__
+
+#include <linux/stringify.h>
+
+#define CPUID_CPUID	0
+#define CPUID_CACHETYPE	1
+
+#define read_cpuid(reg)							\
+	({								\
+		unsigned int __val;					\
+		asm("movc	%0, p0.c0, #" __stringify(reg)		\
+		    : "=r" (__val)					\
+		    :							\
+		    : "cc");						\
+		__val;							\
+	})
+
+#define uc32_cpuid		read_cpuid(CPUID_CPUID)
+#define uc32_cachetype		read_cpuid(CPUID_CACHETYPE)
+
+#endif
diff --git a/arch/unicore32/include/asm/hwcap.h b/arch/unicore32/include/asm/hwcap.h
new file mode 100644
index 0000000..97bd40f
--- /dev/null
+++ b/arch/unicore32/include/asm/hwcap.h
@@ -0,0 +1,32 @@
+/*
+ * linux/arch/unicore32/include/asm/hwcap.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_HWCAP_H__
+#define __UNICORE_HWCAP_H__
+
+/*
+ * HWCAP flags
+ */
+#define HWCAP_MSP		1
+#define HWCAP_UNICORE16		2
+#define HWCAP_CMOV		4
+#define HWCAP_UNICORE_F64       8
+#define HWCAP_TLS		0x80
+
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+#define ELF_HWCAP		(HWCAP_CMOV | HWCAP_UNICORE_F64)
+#endif
+
+#endif
diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
new file mode 100644
index 0000000..e11cb07
--- /dev/null
+++ b/arch/unicore32/include/asm/processor.h
@@ -0,0 +1,92 @@
+/*
+ * linux/arch/unicore32/include/asm/processor.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_PROCESSOR_H__
+#define __UNICORE_PROCESSOR_H__
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+#ifdef __KERNEL__
+
+#include <asm/ptrace.h>
+#include <asm/types.h>
+
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
+struct debug_entry {
+	u32			address;
+	u32			insn;
+};
+
+struct debug_info {
+	int			nsaved;
+	struct debug_entry	bp[2];
+};
+
+struct thread_struct {
+							/* fault info	  */
+	unsigned long		address;
+	unsigned long		trap_no;
+	unsigned long		error_code;
+							/* debugging	  */
+	struct debug_info	debug;
+};
+
+#define INIT_THREAD  {	}
+
+#define start_thread(regs, pc, sp)					\
+({									\
+	unsigned long *stack = (unsigned long *)sp;			\
+	set_fs(USER_DS);						\
+	memset(regs->uregs, 0, sizeof(regs->uregs));			\
+	regs->UCreg_asr = USER_MODE;					\
+	regs->UCreg_pc = pc & ~1;	/* pc */                        \
+	regs->UCreg_sp = sp;		/* sp */                        \
+	regs->UCreg_02 = stack[2];	/* r2 (envp) */                 \
+	regs->UCreg_01 = stack[1];	/* r1 (argv) */                 \
+	regs->UCreg_00 = stack[0];	/* r0 (argc) */                 \
+})
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+/* Free all resources held by a thread. */
+extern void release_thread(struct task_struct *);
+
+/* Prepare to copy thread state - unlazy all lazy status */
+#define prepare_to_copy(tsk)	do { } while (0)
+
+unsigned long get_wchan(struct task_struct *p);
+
+#define cpu_relax()			barrier()
+
+/*
+ * Create a new kernel thread
+ */
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+#define task_pt_regs(p) \
+	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
+
+#define KSTK_EIP(tsk)	(task_pt_regs(tsk)->UCreg_pc)
+#define KSTK_ESP(tsk)	(task_pt_regs(tsk)->UCreg_sp)
+
+#endif
+
+#endif /* __UNICORE_PROCESSOR_H__ */
diff --git a/arch/unicore32/include/asm/system.h b/arch/unicore32/include/asm/system.h
new file mode 100644
index 0000000..17532c2
--- /dev/null
+++ b/arch/unicore32/include/asm/system.h
@@ -0,0 +1,171 @@
+/*
+ * linux/arch/unicore32/include/asm/system.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_SYSTEM_H__
+#define __UNICORE_SYSTEM_H__
+
+#ifdef __KERNEL__
+
+/*
+ * CR1 bits (CP#0 CR1)
+ */
+#define CR_M	(1 << 0)	/* MMU enable				*/
+#define CR_A	(1 << 1)	/* Alignment abort enable		*/
+#define CR_D	(1 << 2)	/* Dcache enable			*/
+#define CR_I	(1 << 3)	/* Icache enable			*/
+#define CR_B	(1 << 4)	/* Dcache write mechanism: write back	*/
+#define CR_T	(1 << 5)	/* Burst enable				*/
+#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
+
+#ifndef __ASSEMBLY__
+
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+#define __exception	__attribute__((section(".exception.text")))
+
+struct thread_info;
+struct task_struct;
+
+struct pt_regs;
+
+void die(const char *msg, struct pt_regs *regs, int err);
+
+struct siginfo;
+void uc32_notify_die(const char *str, struct pt_regs *regs,
+		struct siginfo *info, unsigned long err, unsigned long trap);
+
+void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+extern asmlinkage void __backtrace(void);
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+
+struct mm_struct;
+extern void show_pte(struct mm_struct *mm, unsigned long addr);
+extern void __show_regs(struct pt_regs *);
+
+extern int cpu_architecture(void);
+extern void cpu_init(void);
+
+#define UDBG_UNDEFINED	(1 << 0)
+#define UDBG_SYSCALL	(1 << 1)
+#define UDBG_BADABORT	(1 << 2)
+#define UDBG_SEGV	(1 << 3)
+#define UDBG_BUS	(1 << 4)
+
+extern unsigned int user_debug;
+
+#define vectors_high()	(cr_alignment & CR_V)
+
+#define isb() __asm__ __volatile__ ("" : : : "memory")
+#define dsb() __asm__ __volatile__ ("" : : : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define read_barrier_depends()		do { } while (0)
+#define smp_read_barrier_depends()	do { } while (0)
+
+#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
+#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
+
+extern unsigned long cr_no_alignment;	/* defined in entry-unicore.S */
+extern unsigned long cr_alignment;	/* defined in entry-unicore.S */
+
+static inline unsigned int get_cr(void)
+{
+	unsigned int val;
+	asm("movc %0, p0.c1, #0" : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_cr(unsigned int val)
+{
+	asm volatile("movc p0.c1, %0, #0	@set CR"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+extern void adjust_cr(unsigned long mask, unsigned long set);
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.  schedule() itself
+ * contains the memory barrier to tell GCC not to cache `current'.
+ */
+extern struct task_struct *__switch_to(struct task_struct *,
+		struct thread_info *, struct thread_info *);
+extern void panic(const char *fmt, ...);
+
+#define switch_to(prev, next, last)					\
+do {									\
+	last = __switch_to(prev,					\
+		task_thread_info(prev), task_thread_info(next));	\
+} while (0)
+
+static inline unsigned long
+__xchg(unsigned long x, volatile void *ptr, int size)
+{
+	unsigned long ret;
+
+	switch (size) {
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"	swapb	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"	swapw	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	default:
+		panic("xchg: bad data size: ptr 0x%p, size %d\n",
+			ptr, size);
+	}
+
+	return ret;
+}
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+		((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),	\
+		(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)					\
+		__cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif /* __ASSEMBLY__ */
+
+#define arch_align_stack(x) (x)
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/arch/unicore32/include/asm/unistd.h b/arch/unicore32/include/asm/unistd.h
new file mode 100644
index 0000000..0f298d6
--- /dev/null
+++ b/arch/unicore32/include/asm/unistd.h
@@ -0,0 +1,450 @@
+/*
+ * linux/arch/unicore32/include/asm/unistd.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_UNISTD_H__
+#define __UNICORE_UNISTD_H__
+
+#define __NR_SYSCALL_BASE	0x900000
+
+/*
+ * This file contains the system call numbers.
+ */
+
+#define __NR_restart_syscall		(__NR_SYSCALL_BASE +  0)
+#define __NR_exit			(__NR_SYSCALL_BASE +  1)
+#define __NR_fork			(__NR_SYSCALL_BASE +  2)
+#define __NR_read			(__NR_SYSCALL_BASE +  3)
+#define __NR_write			(__NR_SYSCALL_BASE +  4)
+#define __NR_open			(__NR_SYSCALL_BASE +  5)
+#define __NR_close			(__NR_SYSCALL_BASE +  6)
+					/* 7 was sys_waitpid */
+#define __NR_creat			(__NR_SYSCALL_BASE +  8)
+#define __NR_link			(__NR_SYSCALL_BASE +  9)
+#define __NR_unlink			(__NR_SYSCALL_BASE + 10)
+#define __NR_execve			(__NR_SYSCALL_BASE + 11)
+#define __NR_chdir			(__NR_SYSCALL_BASE + 12)
+#define __NR_time			(__NR_SYSCALL_BASE + 13)
+#define __NR_mknod			(__NR_SYSCALL_BASE + 14)
+#define __NR_chmod			(__NR_SYSCALL_BASE + 15)
+#define __NR_lchown			(__NR_SYSCALL_BASE + 16)
+					/* 17 was sys_break */
+					/* 18 was sys_stat */
+#define __NR_lseek			(__NR_SYSCALL_BASE + 19)
+#define __NR_getpid			(__NR_SYSCALL_BASE + 20)
+#define __NR_mount			(__NR_SYSCALL_BASE + 21)
+#define __NR_umount			(__NR_SYSCALL_BASE + 22)
+#define __NR_setuid			(__NR_SYSCALL_BASE + 23)
+#define __NR_getuid			(__NR_SYSCALL_BASE + 24)
+#define __NR_stime			(__NR_SYSCALL_BASE + 25)
+#define __NR_ptrace			(__NR_SYSCALL_BASE + 26)
+#define __NR_alarm			(__NR_SYSCALL_BASE + 27)
+					/* 28 was sys_fstat */
+#define __NR_pause			(__NR_SYSCALL_BASE + 29)
+#define __NR_utime			(__NR_SYSCALL_BASE + 30)
+					/* 31 was sys_stty */
+					/* 32 was sys_gtty */
+#define __NR_access			(__NR_SYSCALL_BASE + 33)
+#define __NR_nice			(__NR_SYSCALL_BASE + 34)
+					/* 35 was sys_ftime */
+#define __NR_sync			(__NR_SYSCALL_BASE + 36)
+#define __NR_kill			(__NR_SYSCALL_BASE + 37)
+#define __NR_rename			(__NR_SYSCALL_BASE + 38)
+#define __NR_mkdir			(__NR_SYSCALL_BASE + 39)
+#define __NR_rmdir			(__NR_SYSCALL_BASE + 40)
+#define __NR_dup			(__NR_SYSCALL_BASE + 41)
+#define __NR_pipe			(__NR_SYSCALL_BASE + 42)
+#define __NR_times			(__NR_SYSCALL_BASE + 43)
+					/* 44 was sys_prof */
+#define __NR_brk			(__NR_SYSCALL_BASE + 45)
+#define __NR_setgid			(__NR_SYSCALL_BASE + 46)
+#define __NR_getgid			(__NR_SYSCALL_BASE + 47)
+					/* 48 was sys_signal */
+#define __NR_geteuid			(__NR_SYSCALL_BASE + 49)
+#define __NR_getegid			(__NR_SYSCALL_BASE + 50)
+#define __NR_acct			(__NR_SYSCALL_BASE + 51)
+#define __NR_umount2			(__NR_SYSCALL_BASE + 52)
+					/* 53 was sys_lock */
+#define __NR_ioctl			(__NR_SYSCALL_BASE + 54)
+#define __NR_fcntl			(__NR_SYSCALL_BASE + 55)
+					/* 56 was sys_mpx */
+#define __NR_setpgid			(__NR_SYSCALL_BASE + 57)
+					/* 58 was sys_ulimit */
+					/* 59 was sys_olduname */
+#define __NR_umask			(__NR_SYSCALL_BASE + 60)
+#define __NR_chroot			(__NR_SYSCALL_BASE + 61)
+#define __NR_ustat			(__NR_SYSCALL_BASE + 62)
+#define __NR_dup2			(__NR_SYSCALL_BASE + 63)
+#define __NR_getppid			(__NR_SYSCALL_BASE + 64)
+#define __NR_getpgrp			(__NR_SYSCALL_BASE + 65)
+#define __NR_setsid			(__NR_SYSCALL_BASE + 66)
+#define __NR_sigaction			(__NR_SYSCALL_BASE + 67)
+					/* 68 was sys_sgetmask */
+					/* 69 was sys_ssetmask */
+#define __NR_setreuid			(__NR_SYSCALL_BASE + 70)
+#define __NR_setregid			(__NR_SYSCALL_BASE + 71)
+#define __NR_sigsuspend			(__NR_SYSCALL_BASE + 72)
+#define __NR_sigpending			(__NR_SYSCALL_BASE + 73)
+#define __NR_sethostname		(__NR_SYSCALL_BASE + 74)
+#define __NR_setrlimit			(__NR_SYSCALL_BASE + 75)
+#define __NR_getrlimit			(__NR_SYSCALL_BASE + 76)
+					/* Back compat 2GB limited rlimit */
+#define __NR_getrusage			(__NR_SYSCALL_BASE + 77)
+#define __NR_gettimeofday		(__NR_SYSCALL_BASE + 78)
+#define __NR_settimeofday		(__NR_SYSCALL_BASE + 79)
+#define __NR_getgroups			(__NR_SYSCALL_BASE + 80)
+#define __NR_setgroups			(__NR_SYSCALL_BASE + 81)
+#define __NR_select			(__NR_SYSCALL_BASE + 82)
+#define __NR_symlink			(__NR_SYSCALL_BASE + 83)
+					/* 84 was sys_lstat */
+#define __NR_readlink			(__NR_SYSCALL_BASE + 85)
+#define __NR_uselib			(__NR_SYSCALL_BASE + 86)
+#define __NR_swapon			(__NR_SYSCALL_BASE + 87)
+#define __NR_reboot			(__NR_SYSCALL_BASE + 88)
+#define __NR_readdir			(__NR_SYSCALL_BASE + 89)
+#define __NR_mmap			(__NR_SYSCALL_BASE + 90)
+#define __NR_munmap			(__NR_SYSCALL_BASE + 91)
+#define __NR_truncate			(__NR_SYSCALL_BASE + 92)
+#define __NR_ftruncate			(__NR_SYSCALL_BASE + 93)
+#define __NR_fchmod			(__NR_SYSCALL_BASE + 94)
+#define __NR_fchown			(__NR_SYSCALL_BASE + 95)
+#define __NR_getpriority		(__NR_SYSCALL_BASE + 96)
+#define __NR_setpriority		(__NR_SYSCALL_BASE + 97)
+					/* 98 was sys_profil */
+#define __NR_statfs			(__NR_SYSCALL_BASE + 99)
+#define __NR_fstatfs			(__NR_SYSCALL_BASE+100)
+					/* 101 was sys_ioperm */
+#define __NR_socketcall			(__NR_SYSCALL_BASE+102)
+#define __NR_syslog			(__NR_SYSCALL_BASE+103)
+#define __NR_setitimer			(__NR_SYSCALL_BASE+104)
+#define __NR_getitimer			(__NR_SYSCALL_BASE+105)
+#define __NR_stat			(__NR_SYSCALL_BASE+106)
+#define __NR_lstat			(__NR_SYSCALL_BASE+107)
+#define __NR_fstat			(__NR_SYSCALL_BASE+108)
+					/* 109 was sys_uname */
+					/* 110 was sys_iopl */
+#define __NR_vhangup			(__NR_SYSCALL_BASE+111)
+					/* 112 was sys_idle */
+#define __NR_syscall			(__NR_SYSCALL_BASE+113)
+					/* syscall to call a syscall! */
+#define __NR_wait4			(__NR_SYSCALL_BASE+114)
+#define __NR_swapoff			(__NR_SYSCALL_BASE+115)
+#define __NR_sysinfo			(__NR_SYSCALL_BASE+116)
+#define __NR_ipc			(__NR_SYSCALL_BASE+117)
+#define __NR_fsync			(__NR_SYSCALL_BASE+118)
+#define __NR_sigreturn			(__NR_SYSCALL_BASE+119)
+#define __NR_clone			(__NR_SYSCALL_BASE+120)
+#define __NR_setdomainname		(__NR_SYSCALL_BASE+121)
+#define __NR_uname			(__NR_SYSCALL_BASE+122)
+					/* 123 was sys_modify_ldt */
+#define __NR_adjtimex			(__NR_SYSCALL_BASE+124)
+#define __NR_mprotect			(__NR_SYSCALL_BASE+125)
+#define __NR_sigprocmask		(__NR_SYSCALL_BASE+126)
+					/* 127 was sys_create_module */
+#define __NR_init_module		(__NR_SYSCALL_BASE+128)
+#define __NR_delete_module		(__NR_SYSCALL_BASE+129)
+					/* 130 was sys_get_kernel_syms */
+#define __NR_quotactl			(__NR_SYSCALL_BASE+131)
+#define __NR_getpgid			(__NR_SYSCALL_BASE+132)
+#define __NR_fchdir			(__NR_SYSCALL_BASE+133)
+#define __NR_bdflush			(__NR_SYSCALL_BASE+134)
+#define __NR_sysfs			(__NR_SYSCALL_BASE+135)
+#define __NR_personality		(__NR_SYSCALL_BASE+136)
+					/* 137 was sys_afs_syscall */
+#define __NR_setfsuid			(__NR_SYSCALL_BASE+138)
+#define __NR_setfsgid			(__NR_SYSCALL_BASE+139)
+#define __NR__llseek			(__NR_SYSCALL_BASE+140)
+#define __NR_getdents			(__NR_SYSCALL_BASE+141)
+#define __NR__newselect			(__NR_SYSCALL_BASE+142)
+#define __NR_flock			(__NR_SYSCALL_BASE+143)
+#define __NR_msync			(__NR_SYSCALL_BASE+144)
+#define __NR_readv			(__NR_SYSCALL_BASE+145)
+#define __NR_writev			(__NR_SYSCALL_BASE+146)
+#define __NR_getsid			(__NR_SYSCALL_BASE+147)
+#define __NR_fdatasync			(__NR_SYSCALL_BASE+148)
+#define __NR__sysctl			(__NR_SYSCALL_BASE+149)
+#define __NR_mlock			(__NR_SYSCALL_BASE+150)
+#define __NR_munlock			(__NR_SYSCALL_BASE+151)
+#define __NR_mlockall			(__NR_SYSCALL_BASE+152)
+#define __NR_munlockall			(__NR_SYSCALL_BASE+153)
+#define __NR_sched_setparam		(__NR_SYSCALL_BASE+154)
+#define __NR_sched_getparam		(__NR_SYSCALL_BASE+155)
+#define __NR_sched_setscheduler		(__NR_SYSCALL_BASE+156)
+#define __NR_sched_getscheduler		(__NR_SYSCALL_BASE+157)
+#define __NR_sched_yield		(__NR_SYSCALL_BASE+158)
+#define __NR_sched_get_priority_max	(__NR_SYSCALL_BASE+159)
+#define __NR_sched_get_priority_min	(__NR_SYSCALL_BASE+160)
+#define __NR_sched_rr_get_interval	(__NR_SYSCALL_BASE+161)
+#define __NR_nanosleep			(__NR_SYSCALL_BASE+162)
+#define __NR_mremap			(__NR_SYSCALL_BASE+163)
+#define __NR_setresuid			(__NR_SYSCALL_BASE+164)
+#define __NR_getresuid			(__NR_SYSCALL_BASE+165)
+					/* 166 was sys_vm86 */
+					/* 167 was sys_query_module */
+#define __NR_poll			(__NR_SYSCALL_BASE+168)
+#define __NR_nfsservctl			(__NR_SYSCALL_BASE+169)
+#define __NR_setresgid			(__NR_SYSCALL_BASE+170)
+#define __NR_getresgid			(__NR_SYSCALL_BASE+171)
+#define __NR_prctl			(__NR_SYSCALL_BASE+172)
+#define __NR_rt_sigreturn		(__NR_SYSCALL_BASE+173)
+#define __NR_rt_sigaction		(__NR_SYSCALL_BASE+174)
+#define __NR_rt_sigprocmask		(__NR_SYSCALL_BASE+175)
+#define __NR_rt_sigpending		(__NR_SYSCALL_BASE+176)
+#define __NR_rt_sigtimedwait		(__NR_SYSCALL_BASE+177)
+#define __NR_rt_sigqueueinfo		(__NR_SYSCALL_BASE+178)
+#define __NR_rt_sigsuspend		(__NR_SYSCALL_BASE+179)
+#define __NR_pread64			(__NR_SYSCALL_BASE+180)
+#define __NR_pwrite64			(__NR_SYSCALL_BASE+181)
+#define __NR_chown			(__NR_SYSCALL_BASE+182)
+#define __NR_getcwd			(__NR_SYSCALL_BASE+183)
+#define __NR_capget			(__NR_SYSCALL_BASE+184)
+#define __NR_capset			(__NR_SYSCALL_BASE+185)
+#define __NR_sigaltstack		(__NR_SYSCALL_BASE+186)
+#define __NR_sendfile			(__NR_SYSCALL_BASE+187)
+					/* 188 reserved */
+					/* 189 reserved */
+#define __NR_vfork			(__NR_SYSCALL_BASE+190)
+#define __NR_ugetrlimit			(__NR_SYSCALL_BASE+191)
+					/* SuS compliant getrlimit */
+#define __NR_mmap2			(__NR_SYSCALL_BASE+192)
+#define __NR_truncate64			(__NR_SYSCALL_BASE+193)
+#define __NR_ftruncate64		(__NR_SYSCALL_BASE+194)
+#define __NR_stat64			(__NR_SYSCALL_BASE+195)
+#define __NR_lstat64			(__NR_SYSCALL_BASE+196)
+#define __NR_fstat64			(__NR_SYSCALL_BASE+197)
+#define __NR_lchown32			(__NR_SYSCALL_BASE+198)
+#define __NR_getuid32			(__NR_SYSCALL_BASE+199)
+#define __NR_getgid32			(__NR_SYSCALL_BASE+200)
+#define __NR_geteuid32			(__NR_SYSCALL_BASE+201)
+#define __NR_getegid32			(__NR_SYSCALL_BASE+202)
+#define __NR_setreuid32			(__NR_SYSCALL_BASE+203)
+#define __NR_setregid32			(__NR_SYSCALL_BASE+204)
+#define __NR_getgroups32		(__NR_SYSCALL_BASE+205)
+#define __NR_setgroups32		(__NR_SYSCALL_BASE+206)
+#define __NR_fchown32			(__NR_SYSCALL_BASE+207)
+#define __NR_setresuid32		(__NR_SYSCALL_BASE+208)
+#define __NR_getresuid32		(__NR_SYSCALL_BASE+209)
+#define __NR_setresgid32		(__NR_SYSCALL_BASE+210)
+#define __NR_getresgid32		(__NR_SYSCALL_BASE+211)
+#define __NR_chown32			(__NR_SYSCALL_BASE+212)
+#define __NR_setuid32			(__NR_SYSCALL_BASE+213)
+#define __NR_setgid32			(__NR_SYSCALL_BASE+214)
+#define __NR_setfsuid32			(__NR_SYSCALL_BASE+215)
+#define __NR_setfsgid32			(__NR_SYSCALL_BASE+216)
+#define __NR_getdents64			(__NR_SYSCALL_BASE+217)
+#define __NR_pivot_root			(__NR_SYSCALL_BASE+218)
+#define __NR_mincore			(__NR_SYSCALL_BASE+219)
+#define __NR_madvise			(__NR_SYSCALL_BASE+220)
+#define __NR_fcntl64			(__NR_SYSCALL_BASE+221)
+					/* 222 for tux */
+					/* 223 is unused */
+#define __NR_gettid			(__NR_SYSCALL_BASE+224)
+#define __NR_readahead			(__NR_SYSCALL_BASE+225)
+#define __NR_setxattr			(__NR_SYSCALL_BASE+226)
+#define __NR_lsetxattr			(__NR_SYSCALL_BASE+227)
+#define __NR_fsetxattr			(__NR_SYSCALL_BASE+228)
+#define __NR_getxattr			(__NR_SYSCALL_BASE+229)
+#define __NR_lgetxattr			(__NR_SYSCALL_BASE+230)
+#define __NR_fgetxattr			(__NR_SYSCALL_BASE+231)
+#define __NR_listxattr			(__NR_SYSCALL_BASE+232)
+#define __NR_llistxattr			(__NR_SYSCALL_BASE+233)
+#define __NR_flistxattr			(__NR_SYSCALL_BASE+234)
+#define __NR_removexattr		(__NR_SYSCALL_BASE+235)
+#define __NR_lremovexattr		(__NR_SYSCALL_BASE+236)
+#define __NR_fremovexattr		(__NR_SYSCALL_BASE+237)
+#define __NR_tkill			(__NR_SYSCALL_BASE+238)
+#define __NR_sendfile64			(__NR_SYSCALL_BASE+239)
+#define __NR_futex			(__NR_SYSCALL_BASE+240)
+#define __NR_sched_setaffinity		(__NR_SYSCALL_BASE+241)
+#define __NR_sched_getaffinity		(__NR_SYSCALL_BASE+242)
+#define __NR_io_setup			(__NR_SYSCALL_BASE+243)
+#define __NR_io_destroy			(__NR_SYSCALL_BASE+244)
+#define __NR_io_getevents		(__NR_SYSCALL_BASE+245)
+#define __NR_io_submit			(__NR_SYSCALL_BASE+246)
+#define __NR_io_cancel			(__NR_SYSCALL_BASE+247)
+#define __NR_exit_group			(__NR_SYSCALL_BASE+248)
+#define __NR_lookup_dcookie		(__NR_SYSCALL_BASE+249)
+#define __NR_epoll_create		(__NR_SYSCALL_BASE+250)
+#define __NR_epoll_ctl			(__NR_SYSCALL_BASE+251)
+#define __NR_epoll_wait			(__NR_SYSCALL_BASE+252)
+#define __NR_remap_file_pages		(__NR_SYSCALL_BASE+253)
+					/* 254 for set_thread_area */
+					/* 255 for get_thread_area */
+#define __NR_set_tid_address		(__NR_SYSCALL_BASE+256)
+#define __NR_timer_create		(__NR_SYSCALL_BASE+257)
+#define __NR_timer_settime		(__NR_SYSCALL_BASE+258)
+#define __NR_timer_gettime		(__NR_SYSCALL_BASE+259)
+#define __NR_timer_getoverrun		(__NR_SYSCALL_BASE+260)
+#define __NR_timer_delete		(__NR_SYSCALL_BASE+261)
+#define __NR_clock_settime		(__NR_SYSCALL_BASE+262)
+#define __NR_clock_gettime		(__NR_SYSCALL_BASE+263)
+#define __NR_clock_getres		(__NR_SYSCALL_BASE+264)
+#define __NR_clock_nanosleep		(__NR_SYSCALL_BASE+265)
+#define __NR_statfs64			(__NR_SYSCALL_BASE+266)
+#define __NR_fstatfs64			(__NR_SYSCALL_BASE+267)
+#define __NR_tgkill			(__NR_SYSCALL_BASE+268)
+#define __NR_utimes			(__NR_SYSCALL_BASE+269)
+#define __NR_uc32_fadvise64_64		(__NR_SYSCALL_BASE+270)
+#define __NR_pciconfig_iobase		(__NR_SYSCALL_BASE+271)
+#define __NR_pciconfig_read		(__NR_SYSCALL_BASE+272)
+#define __NR_pciconfig_write		(__NR_SYSCALL_BASE+273)
+#define __NR_mq_open			(__NR_SYSCALL_BASE+274)
+#define __NR_mq_unlink			(__NR_SYSCALL_BASE+275)
+#define __NR_mq_timedsend		(__NR_SYSCALL_BASE+276)
+#define __NR_mq_timedreceive		(__NR_SYSCALL_BASE+277)
+#define __NR_mq_notify			(__NR_SYSCALL_BASE+278)
+#define __NR_mq_getsetattr		(__NR_SYSCALL_BASE+279)
+#define __NR_waitid			(__NR_SYSCALL_BASE+280)
+#define __NR_socket			(__NR_SYSCALL_BASE+281)
+#define __NR_bind			(__NR_SYSCALL_BASE+282)
+#define __NR_connect			(__NR_SYSCALL_BASE+283)
+#define __NR_listen			(__NR_SYSCALL_BASE+284)
+#define __NR_accept			(__NR_SYSCALL_BASE+285)
+#define __NR_getsockname		(__NR_SYSCALL_BASE+286)
+#define __NR_getpeername		(__NR_SYSCALL_BASE+287)
+#define __NR_socketpair			(__NR_SYSCALL_BASE+288)
+#define __NR_send			(__NR_SYSCALL_BASE+289)
+#define __NR_sendto			(__NR_SYSCALL_BASE+290)
+#define __NR_recv			(__NR_SYSCALL_BASE+291)
+#define __NR_recvfrom			(__NR_SYSCALL_BASE+292)
+#define __NR_shutdown			(__NR_SYSCALL_BASE+293)
+#define __NR_setsockopt			(__NR_SYSCALL_BASE+294)
+#define __NR_getsockopt			(__NR_SYSCALL_BASE+295)
+#define __NR_sendmsg			(__NR_SYSCALL_BASE+296)
+#define __NR_recvmsg			(__NR_SYSCALL_BASE+297)
+#define __NR_semop			(__NR_SYSCALL_BASE+298)
+#define __NR_semget			(__NR_SYSCALL_BASE+299)
+#define __NR_semctl			(__NR_SYSCALL_BASE+300)
+#define __NR_msgsnd			(__NR_SYSCALL_BASE+301)
+#define __NR_msgrcv			(__NR_SYSCALL_BASE+302)
+#define __NR_msgget			(__NR_SYSCALL_BASE+303)
+#define __NR_msgctl			(__NR_SYSCALL_BASE+304)
+#define __NR_shmat			(__NR_SYSCALL_BASE+305)
+#define __NR_shmdt			(__NR_SYSCALL_BASE+306)
+#define __NR_shmget			(__NR_SYSCALL_BASE+307)
+#define __NR_shmctl			(__NR_SYSCALL_BASE+308)
+#define __NR_add_key			(__NR_SYSCALL_BASE+309)
+#define __NR_request_key		(__NR_SYSCALL_BASE+310)
+#define __NR_keyctl			(__NR_SYSCALL_BASE+311)
+#define __NR_semtimedop			(__NR_SYSCALL_BASE+312)
+#define __NR_vserver			(__NR_SYSCALL_BASE+313)
+#define __NR_ioprio_set			(__NR_SYSCALL_BASE+314)
+#define __NR_ioprio_get			(__NR_SYSCALL_BASE+315)
+#define __NR_inotify_init		(__NR_SYSCALL_BASE+316)
+#define __NR_inotify_add_watch		(__NR_SYSCALL_BASE+317)
+#define __NR_inotify_rm_watch		(__NR_SYSCALL_BASE+318)
+#define __NR_mbind			(__NR_SYSCALL_BASE+319)
+#define __NR_get_mempolicy		(__NR_SYSCALL_BASE+320)
+#define __NR_set_mempolicy		(__NR_SYSCALL_BASE+321)
+#define __NR_openat			(__NR_SYSCALL_BASE+322)
+#define __NR_mkdirat			(__NR_SYSCALL_BASE+323)
+#define __NR_mknodat			(__NR_SYSCALL_BASE+324)
+#define __NR_fchownat			(__NR_SYSCALL_BASE+325)
+#define __NR_futimesat			(__NR_SYSCALL_BASE+326)
+#define __NR_fstatat64			(__NR_SYSCALL_BASE+327)
+#define __NR_unlinkat			(__NR_SYSCALL_BASE+328)
+#define __NR_renameat			(__NR_SYSCALL_BASE+329)
+#define __NR_linkat			(__NR_SYSCALL_BASE+330)
+#define __NR_symlinkat			(__NR_SYSCALL_BASE+331)
+#define __NR_readlinkat			(__NR_SYSCALL_BASE+332)
+#define __NR_fchmodat			(__NR_SYSCALL_BASE+333)
+#define __NR_faccessat			(__NR_SYSCALL_BASE+334)
+#define __NR_pselect6			(__NR_SYSCALL_BASE+335)
+#define __NR_ppoll			(__NR_SYSCALL_BASE+336)
+#define __NR_unshare			(__NR_SYSCALL_BASE+337)
+#define __NR_set_robust_list		(__NR_SYSCALL_BASE+338)
+#define __NR_get_robust_list		(__NR_SYSCALL_BASE+339)
+#define __NR_splice			(__NR_SYSCALL_BASE+340)
+#define __NR_uc32_sync_file_range	(__NR_SYSCALL_BASE+341)
+#define __NR_sync_file_range2		__NR_uc32_sync_file_range
+#define __NR_tee			(__NR_SYSCALL_BASE+342)
+#define __NR_vmsplice			(__NR_SYSCALL_BASE+343)
+#define __NR_move_pages			(__NR_SYSCALL_BASE+344)
+#define __NR_getcpu			(__NR_SYSCALL_BASE+345)
+#define __NR_epoll_pwait		(__NR_SYSCALL_BASE+346)
+#define __NR_kexec_load			(__NR_SYSCALL_BASE+347)
+#define __NR_utimensat			(__NR_SYSCALL_BASE+348)
+#define __NR_signalfd			(__NR_SYSCALL_BASE+349)
+#define __NR_timerfd_create		(__NR_SYSCALL_BASE+350)
+#define __NR_eventfd			(__NR_SYSCALL_BASE+351)
+#define __NR_fallocate			(__NR_SYSCALL_BASE+352)
+#define __NR_timerfd_settime		(__NR_SYSCALL_BASE+353)
+#define __NR_timerfd_gettime		(__NR_SYSCALL_BASE+354)
+#define __NR_signalfd4			(__NR_SYSCALL_BASE+355)
+#define __NR_eventfd2			(__NR_SYSCALL_BASE+356)
+#define __NR_epoll_create1		(__NR_SYSCALL_BASE+357)
+#define __NR_dup3			(__NR_SYSCALL_BASE+358)
+#define __NR_pipe2			(__NR_SYSCALL_BASE+359)
+#define __NR_inotify_init1		(__NR_SYSCALL_BASE+360)
+#define __NR_preadv			(__NR_SYSCALL_BASE+361)
+#define __NR_pwritev			(__NR_SYSCALL_BASE+362)
+#define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
+#define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
+#define __NR_recvmmsg			(__NR_SYSCALL_BASE+365)
+#define __NR_accept4			(__NR_SYSCALL_BASE+366)
+#define __NR_fanotify_init		(__NR_SYSCALL_BASE+367)
+#define __NR_fanotify_mark		(__NR_SYSCALL_BASE+368)
+#define __NR_prlimit64			(__NR_SYSCALL_BASE+369)
+
+/*
+ * The following SWIs are UNICORE private.
+ */
+#define __UNICORE_NR_BASE		(__NR_SYSCALL_BASE+0x0f0000)
+#define __UNICORE_NR_cacheflush		(__UNICORE_NR_BASE+2)
+
+/*
+ * *NOTE*: This is a ghost syscall private to the kernel.
+ * Don't ever use this from user code.
+ */
+#ifdef __KERNEL__
+#define __UNICORE_NR_cmpxchg		(__UNICORE_NR_BASE+0x00fff0)
+#endif
+
+#ifdef __KERNEL__
+
+#define __ARCH_WANT_IPC_PARSE_VERSION
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_PAUSE
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+#define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_SIGPROCMASK
+#define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_OLD_MMAP
+#define __ARCH_WANT_SYS_OLD_SELECT
+
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_IPC
+#define __ARCH_WANT_SYS_OLDUMOUNT
+#define __ARCH_WANT_SYS_ALARM
+#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_OLD_READDIR
+#define __ARCH_WANT_SYS_SOCKETCALL
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+
+/*
+ * Unimplemented (or alternatively implemented) syscalls
+ */
+#define __IGNORE_fadvise64_64		1
+#define __IGNORE_migrate_pages		1
+
+#endif /* __KERNEL__ */
+#endif /* __UNICORE_UNISTD_H__ */
diff --git a/arch/unicore32/kernel/calls.S b/arch/unicore32/kernel/calls.S
new file mode 100644
index 0000000..2f966f8
--- /dev/null
+++ b/arch/unicore32/kernel/calls.S
@@ -0,0 +1,390 @@
+/*
+ * linux/arch/unicore32/kernel/calls.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  This file is included thrice in entry-common.S
+ */
+/* 0 */		CALL(sys_restart_syscall)
+		CALL(sys_exit)
+		CALL(sys_fork_wrapper)
+		CALL(sys_read)
+		CALL(sys_write)
+/* 5 */		CALL(sys_open)
+		CALL(sys_close)
+		CALL(sys_ni_syscall)		/* was sys_waitpid */
+		CALL(sys_creat)
+		CALL(sys_link)
+/* 10 */	CALL(sys_unlink)
+		CALL(sys_execve_wrapper)
+		CALL(sys_chdir)
+		CALL(sys_time)			/* used by libc4 */
+		CALL(sys_mknod)
+/* 15 */	CALL(sys_chmod)
+		CALL(sys_lchown16)
+		CALL(sys_ni_syscall)		/* was sys_break */
+		CALL(sys_ni_syscall)		/* was sys_stat */
+		CALL(sys_lseek)
+/* 20 */	CALL(sys_getpid)
+		CALL(sys_mount)
+		CALL(sys_oldumount)		/* used by libc4 */
+		CALL(sys_setuid16)
+		CALL(sys_getuid16)
+/* 25 */	CALL(sys_stime)
+		CALL(sys_ptrace)
+		CALL(sys_alarm)			/* used by libc4 */
+		CALL(sys_ni_syscall)		/* was sys_fstat */
+		CALL(sys_pause)
+/* 30 */	CALL(sys_utime)			/* used by libc4 */
+		CALL(sys_ni_syscall)		/* was sys_stty */
+		CALL(sys_ni_syscall)		/* was sys_getty */
+		CALL(sys_access)
+		CALL(sys_nice)
+/* 35 */	CALL(sys_ni_syscall)		/* was sys_ftime */
+		CALL(sys_sync)
+		CALL(sys_kill)
+		CALL(sys_rename)
+		CALL(sys_mkdir)
+/* 40 */	CALL(sys_rmdir)
+		CALL(sys_dup)
+		CALL(sys_pipe)
+		CALL(sys_times)
+		CALL(sys_ni_syscall)		/* was sys_prof */
+/* 45 */	CALL(sys_brk)
+		CALL(sys_setgid16)
+		CALL(sys_getgid16)
+		CALL(sys_ni_syscall)		/* was sys_signal */
+		CALL(sys_geteuid16)
+/* 50 */	CALL(sys_getegid16)
+		CALL(sys_acct)
+		CALL(sys_umount)
+		CALL(sys_ni_syscall)		/* was sys_lock */
+		CALL(sys_ioctl)
+/* 55 */	CALL(sys_fcntl)
+		CALL(sys_ni_syscall)		/* was sys_mpx */
+		CALL(sys_setpgid)
+		CALL(sys_ni_syscall)		/* was sys_ulimit */
+		CALL(sys_ni_syscall)		/* was sys_olduname */
+/* 60 */	CALL(sys_umask)
+		CALL(sys_chroot)
+		CALL(sys_ustat)
+		CALL(sys_dup2)
+		CALL(sys_getppid)
+/* 65 */	CALL(sys_getpgrp)
+		CALL(sys_setsid)
+		CALL(sys_sigaction)
+		CALL(sys_ni_syscall)		/* was sys_sgetmask */
+		CALL(sys_ni_syscall)		/* was sys_ssetmask */
+/* 70 */	CALL(sys_setreuid16)
+		CALL(sys_setregid16)
+		CALL(sys_sigsuspend)
+		CALL(sys_sigpending)
+		CALL(sys_sethostname)
+/* 75 */	CALL(sys_setrlimit)
+		CALL(sys_old_getrlimit)		 /* used by libc4 */
+		CALL(sys_getrusage)
+		CALL(sys_gettimeofday)
+		CALL(sys_settimeofday)
+/* 80 */	CALL(sys_getgroups16)
+		CALL(sys_setgroups16)
+		CALL(sys_old_select)		/* used by libc4 */
+		CALL(sys_symlink)
+		CALL(sys_ni_syscall)		/* was sys_lstat */
+/* 85 */	CALL(sys_readlink)
+		CALL(sys_uselib)
+		CALL(sys_swapon)
+		CALL(sys_reboot)
+		CALL(sys_old_readdir)		/* used by libc4 */
+/* 90 */	CALL(sys_old_mmap)		/* used by libc4 */
+		CALL(sys_munmap)
+		CALL(sys_truncate)
+		CALL(sys_ftruncate)
+		CALL(sys_fchmod)
+/* 95 */	CALL(sys_fchown16)
+		CALL(sys_getpriority)
+		CALL(sys_setpriority)
+		CALL(sys_ni_syscall)		/* was sys_profil */
+		CALL(sys_statfs)
+/* 100 */	CALL(sys_fstatfs)
+		CALL(sys_ni_syscall)		/* sys_ioperm */
+		CALL(sys_socketcall)
+		CALL(sys_syslog)
+		CALL(sys_setitimer)
+/* 105 */	CALL(sys_getitimer)
+		CALL(sys_newstat)
+		CALL(sys_newlstat)
+		CALL(sys_newfstat)
+		CALL(sys_ni_syscall)		/* was sys_uname */
+/* 110 */	CALL(sys_ni_syscall)		/* was sys_iopl */
+		CALL(sys_vhangup)
+		CALL(sys_ni_syscall)
+		CALL(sys_syscall)		/* call a syscall */
+		CALL(sys_wait4)
+/* 115 */	CALL(sys_swapoff)
+		CALL(sys_sysinfo)
+		CALL(sys_ipc)
+		CALL(sys_fsync)
+		CALL(sys_sigreturn_wrapper)
+/* 120 */	CALL(sys_clone_wrapper)
+		CALL(sys_setdomainname)
+		CALL(sys_newuname)
+		CALL(sys_ni_syscall)		/* modify_ldt */
+		CALL(sys_adjtimex)
+/* 125 */	CALL(sys_mprotect)
+		CALL(sys_sigprocmask)
+		CALL(sys_ni_syscall)		/* was sys_create_module */
+		CALL(sys_init_module)
+		CALL(sys_delete_module)
+/* 130 */	CALL(sys_ni_syscall)		/* was sys_get_kernel_syms */
+		CALL(sys_quotactl)
+		CALL(sys_getpgid)
+		CALL(sys_fchdir)
+		CALL(sys_bdflush)
+/* 135 */	CALL(sys_sysfs)
+		CALL(sys_personality)
+		CALL(sys_ni_syscall)		/* reserved for afs_syscall */
+		CALL(sys_setfsuid16)
+		CALL(sys_setfsgid16)
+/* 140 */	CALL(sys_llseek)
+		CALL(sys_getdents)
+		CALL(sys_select)
+		CALL(sys_flock)
+		CALL(sys_msync)
+/* 145 */	CALL(sys_readv)
+		CALL(sys_writev)
+		CALL(sys_getsid)
+		CALL(sys_fdatasync)
+		CALL(sys_sysctl)
+/* 150 */	CALL(sys_mlock)
+		CALL(sys_munlock)
+		CALL(sys_mlockall)
+		CALL(sys_munlockall)
+		CALL(sys_sched_setparam)
+/* 155 */	CALL(sys_sched_getparam)
+		CALL(sys_sched_setscheduler)
+		CALL(sys_sched_getscheduler)
+		CALL(sys_sched_yield)
+		CALL(sys_sched_get_priority_max)
+/* 160 */	CALL(sys_sched_get_priority_min)
+		CALL(sys_sched_rr_get_interval)
+		CALL(sys_nanosleep)
+		CALL(sys_mremap)
+		CALL(sys_setresuid16)
+/* 165 */	CALL(sys_getresuid16)
+		CALL(sys_ni_syscall)		/* vm86 */
+		CALL(sys_ni_syscall)		/* was sys_query_module */
+		CALL(sys_poll)
+		CALL(sys_nfsservctl)
+/* 170 */	CALL(sys_setresgid16)
+		CALL(sys_getresgid16)
+		CALL(sys_prctl)
+		CALL(sys_rt_sigreturn_wrapper)
+		CALL(sys_rt_sigaction)
+/* 175 */	CALL(sys_rt_sigprocmask)
+		CALL(sys_rt_sigpending)
+		CALL(sys_rt_sigtimedwait)
+		CALL(sys_rt_sigqueueinfo)
+		CALL(sys_rt_sigsuspend)
+/* 180 */	CALL(sys_pread64)
+		CALL(sys_pwrite64)
+		CALL(sys_chown16)
+		CALL(sys_getcwd)
+		CALL(sys_capget)
+/* 185 */	CALL(sys_capset)
+		CALL(sys_sigaltstack_wrapper)
+		CALL(sys_sendfile)
+		CALL(sys_ni_syscall)		/* getpmsg */
+		CALL(sys_ni_syscall)		/* putpmsg */
+/* 190 */	CALL(sys_vfork_wrapper)
+		CALL(sys_getrlimit)
+		CALL(sys_mmap_pgoff)
+		CALL(sys_truncate64)
+		CALL(sys_ftruncate64)
+/* 195 */	CALL(sys_stat64)
+		CALL(sys_lstat64)
+		CALL(sys_fstat64)
+		CALL(sys_lchown)
+		CALL(sys_getuid)
+/* 200 */	CALL(sys_getgid)
+		CALL(sys_geteuid)
+		CALL(sys_getegid)
+		CALL(sys_setreuid)
+		CALL(sys_setregid)
+/* 205 */	CALL(sys_getgroups)
+		CALL(sys_setgroups)
+		CALL(sys_fchown)
+		CALL(sys_setresuid)
+		CALL(sys_getresuid)
+/* 210 */	CALL(sys_setresgid)
+		CALL(sys_getresgid)
+		CALL(sys_chown)
+		CALL(sys_setuid)
+		CALL(sys_setgid)
+/* 215 */	CALL(sys_setfsuid)
+		CALL(sys_setfsgid)
+		CALL(sys_getdents64)
+		CALL(sys_pivot_root)
+		CALL(sys_mincore)
+/* 220 */	CALL(sys_madvise)
+		CALL(sys_fcntl64)
+		CALL(sys_ni_syscall) /* TUX */
+		CALL(sys_ni_syscall)
+		CALL(sys_gettid)
+/* 225 */	CALL(sys_readahead)
+		CALL(sys_setxattr)
+		CALL(sys_lsetxattr)
+		CALL(sys_fsetxattr)
+		CALL(sys_getxattr)
+/* 230 */	CALL(sys_lgetxattr)
+		CALL(sys_fgetxattr)
+		CALL(sys_listxattr)
+		CALL(sys_llistxattr)
+		CALL(sys_flistxattr)
+/* 235 */	CALL(sys_removexattr)
+		CALL(sys_lremovexattr)
+		CALL(sys_fremovexattr)
+		CALL(sys_tkill)
+		CALL(sys_sendfile64)
+/* 240 */	CALL(sys_futex)
+		CALL(sys_sched_setaffinity)
+		CALL(sys_sched_getaffinity)
+		CALL(sys_io_setup)
+		CALL(sys_io_destroy)
+/* 245 */	CALL(sys_io_getevents)
+		CALL(sys_io_submit)
+		CALL(sys_io_cancel)
+		CALL(sys_exit_group)
+		CALL(sys_lookup_dcookie)
+/* 250 */	CALL(sys_epoll_create)
+		CALL(sys_epoll_ctl)
+		CALL(sys_epoll_wait)
+		CALL(sys_remap_file_pages)
+		CALL(sys_ni_syscall)	/* sys_set_thread_area */
+/* 255 */	CALL(sys_ni_syscall)	/* sys_get_thread_area */
+		CALL(sys_set_tid_address)
+		CALL(sys_timer_create)
+		CALL(sys_timer_settime)
+		CALL(sys_timer_gettime)
+/* 260 */	CALL(sys_timer_getoverrun)
+		CALL(sys_timer_delete)
+		CALL(sys_clock_settime)
+		CALL(sys_clock_gettime)
+		CALL(sys_clock_getres)
+/* 265 */	CALL(sys_clock_nanosleep)
+		CALL(sys_statfs64_wrapper)
+		CALL(sys_fstatfs64_wrapper)
+		CALL(sys_tgkill)
+		CALL(sys_utimes)
+/* 270 */	CALL(sys_uc32_fadvise64_64)
+		CALL(sys_pciconfig_iobase)
+		CALL(sys_pciconfig_read)
+		CALL(sys_pciconfig_write)
+		CALL(sys_mq_open)
+/* 275 */	CALL(sys_mq_unlink)
+		CALL(sys_mq_timedsend)
+		CALL(sys_mq_timedreceive)
+		CALL(sys_mq_notify)
+		CALL(sys_mq_getsetattr)
+/* 280 */	CALL(sys_waitid)
+		CALL(sys_socket)
+		CALL(sys_bind)
+		CALL(sys_connect)
+		CALL(sys_listen)
+/* 285 */	CALL(sys_accept)
+		CALL(sys_getsockname)
+		CALL(sys_getpeername)
+		CALL(sys_socketpair)
+		CALL(sys_send)
+/* 290 */	CALL(sys_sendto)
+		CALL(sys_recv)
+		CALL(sys_recvfrom)
+		CALL(sys_shutdown)
+		CALL(sys_setsockopt)
+/* 295 */	CALL(sys_getsockopt)
+		CALL(sys_sendmsg)
+		CALL(sys_recvmsg)
+		CALL(sys_semop)
+		CALL(sys_semget)
+/* 300 */	CALL(sys_semctl)
+		CALL(sys_msgsnd)
+		CALL(sys_msgrcv)
+		CALL(sys_msgget)
+		CALL(sys_msgctl)
+/* 305 */	CALL(sys_shmat)
+		CALL(sys_shmdt)
+		CALL(sys_shmget)
+		CALL(sys_shmctl)
+		CALL(sys_add_key)
+/* 310 */	CALL(sys_request_key)
+		CALL(sys_keyctl)
+		CALL(sys_semtimedop)
+/* vserver */	CALL(sys_ni_syscall)
+		CALL(sys_ioprio_set)
+/* 315 */	CALL(sys_ioprio_get)
+		CALL(sys_inotify_init)
+		CALL(sys_inotify_add_watch)
+		CALL(sys_inotify_rm_watch)
+		CALL(sys_mbind)
+/* 320 */	CALL(sys_get_mempolicy)
+		CALL(sys_set_mempolicy)
+		CALL(sys_openat)
+		CALL(sys_mkdirat)
+		CALL(sys_mknodat)
+/* 325 */	CALL(sys_fchownat)
+		CALL(sys_futimesat)
+		CALL(sys_fstatat64)
+		CALL(sys_unlinkat)
+		CALL(sys_renameat)
+/* 330 */	CALL(sys_linkat)
+		CALL(sys_symlinkat)
+		CALL(sys_readlinkat)
+		CALL(sys_fchmodat)
+		CALL(sys_faccessat)
+/* 335 */	CALL(sys_pselect6)
+		CALL(sys_ppoll)
+		CALL(sys_unshare)
+		CALL(sys_set_robust_list)
+		CALL(sys_get_robust_list)
+/* 340 */	CALL(sys_splice)
+		CALL(sys_sync_file_range2)
+		CALL(sys_tee)
+		CALL(sys_vmsplice)
+		CALL(sys_move_pages)
+/* 345 */	CALL(sys_getcpu)
+		CALL(sys_epoll_pwait)
+		CALL(sys_kexec_load)
+		CALL(sys_utimensat)
+		CALL(sys_signalfd)
+/* 350 */	CALL(sys_timerfd_create)
+		CALL(sys_eventfd)
+		CALL(sys_fallocate)
+		CALL(sys_timerfd_settime)
+		CALL(sys_timerfd_gettime)
+/* 355 */	CALL(sys_signalfd4)
+		CALL(sys_eventfd2)
+		CALL(sys_epoll_create1)
+		CALL(sys_dup3)
+		CALL(sys_pipe2)
+/* 360 */	CALL(sys_inotify_init1)
+		CALL(sys_preadv)
+		CALL(sys_pwritev)
+		CALL(sys_rt_tgsigqueueinfo)
+		CALL(sys_perf_event_open)
+/* 365 */	CALL(sys_recvmmsg)
+		CALL(sys_accept4)
+		CALL(sys_fanotify_init)
+		CALL(sys_fanotify_mark)
+		CALL(sys_prlimit64)
+#ifndef syscalls_counted
+.equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
+#define syscalls_counted
+#endif
+.rept syscalls_padding
+		CALL(sys_ni_syscall)
+.endr
diff --git a/arch/unicore32/kernel/sys_unicore.c b/arch/unicore32/kernel/sys_unicore.c
new file mode 100644
index 0000000..7641fab
--- /dev/null
+++ b/arch/unicore32/kernel/sys_unicore.c
@@ -0,0 +1,132 @@
+/*
+ * linux/arch/unicore32/kernel/sys_unicore.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  This file contains various random system calls that
+ *  have a non-standard calling sequence on the Linux/unicore
+ *  platform.
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/sem.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/stat.h>
+#include <linux/syscalls.h>
+#include <linux/mman.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/ipc.h>
+#include <linux/uaccess.h>
+
+/* Fork a new task - this creates a new program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int sys_fork(struct pt_regs *regs)
+{
+	return do_fork(SIGCHLD, regs->UCreg_sp, regs, 0, NULL, NULL);
+}
+
+/* Clone a task - this clones the calling program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
+			 int __user *parent_tidptr, int tls_val,
+			 int __user *child_tidptr, struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->UCreg_sp;
+
+	return do_fork(clone_flags, newsp, regs, 0,
+			parent_tidptr, child_tidptr);
+}
+
+asmlinkage int sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD,
+			regs->UCreg_sp, regs, 0, NULL, NULL);
+}
+
+/* sys_execve() executes a new program.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int sys_execve(const char __user *filenamei,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp,
+			  struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(filenamei);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
+{
+	struct pt_regs regs;
+	int ret;
+
+	memset(&regs, 0, sizeof(struct pt_regs));
+	ret = do_execve(filename,
+			(const char __user *const __user *)argv,
+			(const char __user *const __user *)envp, &regs);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Save argc to the register structure for userspace.
+	 */
+	regs.UCreg_00 = ret;
+
+	/*
+	 * We were successful.  We won't be returning to our caller, but
+	 * instead to user space by manipulating the kernel stack.
+	 */
+	asm("add	r0, %0, %1\n\t"
+		"mov	r1, %2\n\t"
+		"mov	r2, %3\n\t"
+		"mov	r22, #0\n\t"	/* not a syscall */
+		"mov	r23, %0\n\t"	/* thread structure */
+		"b.l	memmove\n\t"	/* copy regs to top of stack */
+		"mov	sp, r0\n\t"	/* reposition stack pointer */
+		"b	ret_to_user"
+		:
+		: "r" (current_thread_info()),
+		  "Ir" (THREAD_START_SP - sizeof(regs)),
+		  "r" (&regs),
+		  "Ir" (sizeof(regs))
+		: "r0", "r1", "r2", "r3", "ip", "lr", "memory");
+
+ out:
+	return ret;
+}
+EXPORT_SYMBOL(kernel_execve);
+
+/*
+ * Since loff_t is a 64 bit type we avoid a lot of ABI hassle
+ * with a different argument ordering.
+ */
+asmlinkage long sys_uc32_fadvise64_64(int fd, int advice,
+				     loff_t offset, loff_t len)
+{
+	return sys_fadvise64_64(fd, offset, len, advice);
+}
diff --git a/arch/unicore32/mm/proc-macros.S b/arch/unicore32/mm/proc-macros.S
new file mode 100644
index 0000000..eb12e3f
--- /dev/null
+++ b/arch/unicore32/mm/proc-macros.S
@@ -0,0 +1,145 @@
+/*
+ * linux/arch/unicore32/mm/proc-macros.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * We need constants.h for:
+ *  VMA_VM_MM
+ *  VMA_VM_FLAGS
+ *  VM_EXEC
+ */
+#include <generated/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+
+/*
+ * the cache line sizes of the I and D cache are the same
+ */
+#define CACHE_LINESIZE	32
+
+/*
+ * This is the maximum size of an area which will be invalidated
+ * using the single invalidate entry instructions.  Anything larger
+ * than this, and we go for the whole cache.
+ *
+ * This value should be chosen such that we choose the cheapest
+ * alternative.
+ */
+#ifdef CONFIG_CPU_UCV2
+#define MAX_AREA_SIZE	0x800		/* 64 cache line */
+#endif
+
+/*
+ * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
+ */
+	.macro	vma_vm_mm, rd, rn
+	ldw	\rd, [\rn+], #VMA_VM_MM
+	.endm
+
+/*
+ * vma_vm_flags - get vma->vm_flags
+ */
+	.macro	vma_vm_flags, rd, rn
+	ldw	\rd, [\rn+], #VMA_VM_FLAGS
+	.endm
+
+	.macro	tsk_mm, rd, rn
+	ldw	\rd, [\rn+], #TI_TASK
+	ldw	\rd, [\rd+], #TSK_ACTIVE_MM
+	.endm
+
+/*
+ * act_mm - get current->active_mm
+ */
+	.macro	act_mm, rd
+	andn	\rd, sp, #8128
+	andn	\rd, \rd, #63
+	ldw	\rd, [\rd+], #TI_TASK
+	ldw	\rd, [\rd+], #TSK_ACTIVE_MM
+	.endm
+
+/*
+ * mmid - get context id from mm pointer (mm->context.id)
+ */
+	.macro	mmid, rd, rn
+	ldw	\rd, [\rn+], #MM_CONTEXT_ID
+	.endm
+
+/*
+ * mask_asid - mask the ASID from the context ID
+ */
+	.macro	asid, rd, rn
+	and	\rd, \rn, #255
+	.endm
+
+	.macro	crval, clear, mmuset, ucset
+	.word	\clear
+	.word	\mmuset
+	.endm
+
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+/*
+ * va2pa va, pa, tbl, msk, off, err
+ *	This macro is used to translate virtual address to its physical address.
+ *
+ *	va: virtual address
+ *	pa: physical address, result is stored in this register
+ *	tbl, msk, off:	temp registers, will be destroyed
+ *	err: jump to error label if the physical address not exist
+ * NOTE: all regs must be different
+ */
+	.macro	va2pa, va, pa, tbl, msk, off, err=990f
+	movc	\pa, p0.c2, #0
+	mov	\off, \va >> #22		@ off <- index of 1st page table
+	adr	\tbl, 910f			@ tbl <- table of 1st page table
+900:						@ ---- handle 1, 2 page table
+	add	\pa, \pa, #PAGE_OFFSET		@ pa <- virt addr of page table
+	ldw	\pa, [\pa+], \off << #2		@ pa <- the content of pt
+	cand.a	\pa, #4				@ test exist bit
+	beq	\err				@ if not exist
+	and	\off, \pa, #3			@ off <- the last 2 bits
+	add	\tbl, \tbl, \off << #3		@ cmove table pointer
+	ldw	\msk, [\tbl+], #0		@ get the mask
+	ldw	pc, [\tbl+], #4
+930:						@ ---- handle 2nd page table
+	and	\pa, \pa, \msk			@ pa <- phys addr of 2nd pt
+	mov	\off, \va << #10
+	cntlo	\tbl, \msk			@ use tbl as temp reg
+	mov	\off, \off >> \tbl
+	mov	\off, \off >> #2		@ off <- index of 2nd pt
+	adr	\tbl, 920f			@ tbl <- table of 2nd pt
+	b	900b
+910:						@ 1st level page table
+	.word	0xfffff000, 930b		@ second level page table
+	.word	0xfffffc00, 930b		@ second level large page table
+	.word	0x00000000, \err		@ invalid
+	.word	0xffc00000, 980f		@ super page
+
+920:						@ 2nd level page table
+	.word	0xfffff000, 980f		@ page
+	.word	0xffffc000, 980f		@ middle page
+	.word	0xffff0000, 980f		@ large page
+	.word	0x00000000, \err		@ invalid
+980:
+	andn	\tbl, \va, \msk
+	and	\pa, \pa, \msk
+	or	\pa, \pa, \tbl
+990:
+	.endm
+#endif
+
+	.macro dcacheline_flush, addr, t1, t2
+	mov	\t1, \addr << #20
+	ldw	\t2, =_text			@ _text must ALIGN(4096)
+	add	\t2, \t2, \t1 >> #20
+	ldw	\t1, [\t2+], #0x0000
+	ldw	\t1, [\t2+], #0x1000
+	ldw	\t1, [\t2+], #0x2000
+	ldw	\t1, [\t2+], #0x3000
+	.endm
diff --git a/arch/unicore32/mm/proc-ucv2.S b/arch/unicore32/mm/proc-ucv2.S
new file mode 100644
index 0000000..9d29609
--- /dev/null
+++ b/arch/unicore32/mm/proc-ucv2.S
@@ -0,0 +1,134 @@
+/*
+ * linux/arch/unicore32/mm/proc-ucv2.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/hwcap.h>
+#include <asm/pgtable-hwdef.h>
+#include <asm/pgtable.h>
+
+#include "proc-macros.S"
+
+ENTRY(cpu_proc_fin)
+	stm.w	(lr), [sp-]
+	mov	ip, #PSR_R_BIT | PSR_I_BIT | PRIV_MODE
+	mov.a	asr, ip
+	b.l	__cpuc_flush_kern_all
+	ldm.w	(pc), [sp]+
+
+/*
+ *	cpu_reset(loc)
+ *
+ *	Perform a soft reset of the system.  Put the CPU into the
+ *	same state as it would be if it had been reset, and branch
+ *	to what would be the reset vector.
+ *
+ *	- loc   - location to jump to for soft reset
+ */
+	.align	5
+ENTRY(cpu_reset)
+	mov	ip, #0
+	movc	p0.c5, ip, #28			@ Cache invalidate all
+	nop8
+
+	movc	p0.c6, ip, #6			@ TLB invalidate all
+	nop8
+
+	movc	ip, p0.c1, #0			@ ctrl register
+	or	ip, ip, #0x2000			@ vector base address
+	andn	ip, ip, #0x000f			@ ............idam
+	movc	p0.c1, ip, #0			@ disable caches and mmu
+	nop
+	mov	pc, r0				@ jump to loc
+	nop8
+
+/*
+ *	cpu_do_idle()
+ *
+ *	Idle the processor (eg, wait for interrupt).
+ *
+ *	IRQs are already disabled.
+ */
+ENTRY(cpu_do_idle)
+	mov	r0, #0				@ PCI address
+	.rept	8
+	ldw	r1, [r0]
+	.endr
+	mov	pc, lr
+
+ENTRY(cpu_dcache_clean_area)
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	csub.a	r1, #MAX_AREA_SIZE
+	bsg	101f
+	mov	r9, #PAGE_SZ
+	sub	r9, r9, #1			@ PAGE_MASK
+1:	va2pa	r0, r10, r11, r12, r13		@ r10 is PA
+	b	3f
+2:	cand.a	r0, r9
+	beq	1b
+3:	movc	p0.c5, r10, #11			@ clean D entry
+	nop8
+	add	r0, r0, #CACHE_LINESIZE
+	add	r10, r10, #CACHE_LINESIZE
+	sub.a	r1, r1, #CACHE_LINESIZE
+	bua	2b
+	mov	pc, lr
+#endif
+101:	mov	ip, #0
+	movc	p0.c5, ip, #10			@ Dcache clean all
+	nop8
+
+	mov	pc, lr
+
+/*
+ *	cpu_do_switch_mm(pgd_phys)
+ *
+ *	Set the translation table base pointer to be pgd_phys
+ *
+ *	- pgd_phys - physical address of new pgd
+ *
+ *	It is assumed that:
+ *	- we are not using split page tables
+ */
+	.align	5
+ENTRY(cpu_do_switch_mm)
+	movc	p0.c2, r0, #0			@ update page table ptr
+	nop8
+
+	movc	p0.c6, ip, #6			@ TLB invalidate all
+	nop8
+
+	mov	pc, lr
+
+/*
+ *	cpu_set_pte(ptep, pte)
+ *
+ *	Set a level 2 translation table entry.
+ *
+ *	- ptep  - pointer to level 2 translation table entry
+ *	- pte   - PTE value to store
+ */
+	.align	5
+ENTRY(cpu_set_pte)
+	stw	r1, [r0]
+#ifndef CONFIG_CPU_DCACHE_LINE_DISABLE
+	sub	r2, r0, #PAGE_OFFSET
+	movc	p0.c5, r2, #11				@ Dcache clean line
+	nop8
+#else
+	mov	ip, #0
+	movc	p0.c5, ip, #10				@ Dcache clean all
+	nop8
+	@dcacheline_flush	r0, r2, ip
+#endif
+	mov	pc, lr
+

