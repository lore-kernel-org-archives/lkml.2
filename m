Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1BMGce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:32:34 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:43154 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab1BMGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:32:27 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 03/11] unicore32 core architecture: processor and system headers
Date: Sun, 13 Feb 2011 14:32:18 +0800
Message-ID: <02e701cbcb47$c31b1680$49514380$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLR7aInlHe9IL0Rl2sQJlhGUnNZA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes processor and system headers. System call interface is here.
We used the syscall interface the same as asm-generic version.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/byteorder.h  |   24 +++++
 arch/unicore32/include/asm/cpu-single.h |   45 +++++++++
 arch/unicore32/include/asm/cputype.h    |   33 +++++++
 arch/unicore32/include/asm/hwcap.h      |   32 ++++++
 arch/unicore32/include/asm/processor.h  |   92 ++++++++++++++++++
 arch/unicore32/include/asm/system.h     |  161 +++++++++++++++++++++++++++++++
 arch/unicore32/include/asm/unistd.h     |   18 ++++
 arch/unicore32/kernel/sys.c             |  126 ++++++++++++++++++++++++
 arch/unicore32/mm/proc-macros.S         |  145 ++++++++++++++++++++++++++++
 arch/unicore32/mm/proc-ucv2.S           |  134 +++++++++++++++++++++++++
 10 files changed, 810 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/byteorder.h
 create mode 100644 arch/unicore32/include/asm/cpu-single.h
 create mode 100644 arch/unicore32/include/asm/cputype.h
 create mode 100644 arch/unicore32/include/asm/hwcap.h
 create mode 100644 arch/unicore32/include/asm/processor.h
 create mode 100644 arch/unicore32/include/asm/system.h
 create mode 100644 arch/unicore32/include/asm/unistd.h
 create mode 100644 arch/unicore32/kernel/sys.c
 create mode 100644 arch/unicore32/mm/proc-macros.S
 create mode 100644 arch/unicore32/mm/proc-ucv2.S

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
index 0000000..246b71c
--- /dev/null
+++ b/arch/unicore32/include/asm/system.h
@@ -0,0 +1,161 @@
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
index 0000000..9b24280
--- /dev/null
+++ b/arch/unicore32/include/asm/unistd.h
@@ -0,0 +1,18 @@
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
+#if !defined(__UNICORE_UNISTD_H__) || defined(__SYSCALL)
+#define __UNICORE_UNISTD_H__
+
+/* Use the standard ABI for syscalls. */
+#include <asm-generic/unistd.h>
+
+#endif /* __UNICORE_UNISTD_H__ */
diff --git a/arch/unicore32/kernel/sys.c b/arch/unicore32/kernel/sys.c
new file mode 100644
index 0000000..3afe60a
--- /dev/null
+++ b/arch/unicore32/kernel/sys.c
@@ -0,0 +1,126 @@
+/*
+ * linux/arch/unicore32/kernel/sys.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#include <asm/syscalls.h>
+#include <asm/cacheflush.h>
+
+/* Clone a task - this clones the calling program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage long __sys_clone(unsigned long clone_flags, unsigned long newsp,
+			 void __user *parent_tid, void __user *child_tid,
+			 struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->UCreg_sp;
+
+	return do_fork(clone_flags, newsp, regs, 0,
+			parent_tid, child_tid);
+}
+
+/* sys_execve() executes a new program.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage long __sys_execve(const char __user *filename,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp,
+			  struct pt_regs *regs)
+{
+	int error;
+	char *fn;
+
+	fn = getname(filename);
+	error = PTR_ERR(fn);
+	if (IS_ERR(fn))
+		goto out;
+	error = do_execve(fn, argv, envp, regs);
+	putname(fn);
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
+/* Note: used by the compat code even in 64-bit Linux. */
+SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, off_4k)
+{
+	return sys_mmap_pgoff(addr, len, prot, flags, fd,
+			      off_4k);
+}
+
+/* Provide the actual syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call)	[nr] = (call),
+
+/* Note that we don't include <linux/unistd.h> but <asm/unistd.h> */
+void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff --git a/arch/unicore32/mm/proc-macros.S b/arch/unicore32/mm/proc-macros.S
new file mode 100644
index 0000000..51560d6
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
+	ldw	\t2, =_stext			@ _stext must ALIGN(4096)
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
-- 
1.7.0.4


