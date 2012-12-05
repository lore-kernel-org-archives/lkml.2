Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2LEQRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:17:17 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55554 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2LEQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:37 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 25/44] metag: System Calls
Date: Wed, 5 Dec 2012 16:08:43 +0000
Message-ID: <1354723742-6195-26-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add metag system call and gateway page interfaces. The metag
architecture port uses the generic system call numbers from
asm-generic/unistd.h, as well as a user gateway page mapped at
0x6ffff000 which contains fast atomic primitives (depending on SMP) and
a fast method of accessing TLS data.

System calls use the SWITCH instruction with the immediate 0x440001 to
signal a system call.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/mman.h         |   11 ++
 arch/metag/include/asm/syscall.h      |  104 +++++++++++++++++
 arch/metag/include/asm/syscalls.h     |   62 ++++++++++
 arch/metag/include/asm/unistd.h       |   12 ++
 arch/metag/include/asm/user_gateway.h |   44 +++++++
 arch/metag/include/uapi/asm/unistd.h  |   21 ++++
 arch/metag/kernel/sys_metag.c         |  198 +++++++++++++++++++++++++++++++++
 arch/metag/kernel/user_gateway.S      |   97 ++++++++++++++++
 8 files changed, 549 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/mman.h
 create mode 100644 arch/metag/include/asm/syscall.h
 create mode 100644 arch/metag/include/asm/syscalls.h
 create mode 100644 arch/metag/include/asm/unistd.h
 create mode 100644 arch/metag/include/asm/user_gateway.h
 create mode 100644 arch/metag/include/uapi/asm/unistd.h
 create mode 100644 arch/metag/kernel/sys_metag.c
 create mode 100644 arch/metag/kernel/user_gateway.S

diff --git a/arch/metag/include/asm/mman.h b/arch/metag/include/asm/mman.h
new file mode 100644
index 0000000..17999db
--- /dev/null
+++ b/arch/metag/include/asm/mman.h
@@ -0,0 +1,11 @@
+#ifndef __METAG_MMAN_H__
+#define __METAG_MMAN_H__
+
+#include <uapi/asm/mman.h>
+
+#ifndef __ASSEMBLY__
+#define arch_mmap_check metag_mmap_check
+int metag_mmap_check(unsigned long addr, unsigned long len,
+		     unsigned long flags);
+#endif
+#endif /* __METAG_MMAN_H__ */
diff --git a/arch/metag/include/asm/syscall.h b/arch/metag/include/asm/syscall.h
new file mode 100644
index 0000000..24fc979
--- /dev/null
+++ b/arch/metag/include/asm/syscall.h
@@ -0,0 +1,104 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * Copyright (C) 2008 Imagination Technologies Ltd.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * See asm-generic/syscall.h for descriptions of what we must do here.
+ */
+
+#ifndef _ASM_METAG_SYSCALL_H
+#define _ASM_METAG_SYSCALL_H
+
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/uaccess.h>
+
+#include <asm/switch.h>
+
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	unsigned long insn;
+
+	/*
+	 * FIXME there's no way to find out how we got here other than to
+	 * examine the memory at the PC to see if it is a syscall
+	 * SWITCH instruction.
+	 */
+	if (get_user(insn, (unsigned long *)(regs->ctx.CurrPC - 4)))
+		return -1;
+
+	if (insn == __METAG_SW_ENCODING(SYS))
+		return regs->ctx.DX[0].U1;
+	else
+		return -1L;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	/* do nothing */
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	unsigned long error = regs->ctx.DX[0].U0;
+	return IS_ERR_VALUE(error) ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ctx.DX[0].U0;
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->ctx.DX[0].U0 = (long) error ?: val;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	unsigned int reg, j;
+	BUG_ON(i + n > 6);
+
+	for (j = i, reg = 6 - i; j < (i + n); j++, reg--) {
+		if (reg % 2)
+			args[j] = regs->ctx.DX[(reg + 1) / 2].U0;
+		else
+			args[j] = regs->ctx.DX[reg / 2].U1;
+	}
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	unsigned int reg;
+	BUG_ON(i + n > 6);
+
+	for (reg = 6 - i; i < (i + n); i++, reg--) {
+		if (reg % 2)
+			regs->ctx.DX[(reg + 1) / 2].U0 = args[i];
+		else
+			regs->ctx.DX[reg / 2].U1 = args[i];
+	}
+}
+
+#define NR_syscalls __NR_syscalls
+
+/* generic syscall table */
+extern const void *sys_call_table[];
+
+#endif	/* _ASM_METAG_SYSCALL_H */
diff --git a/arch/metag/include/asm/syscalls.h b/arch/metag/include/asm/syscalls.h
new file mode 100644
index 0000000..452c2a3
--- /dev/null
+++ b/arch/metag/include/asm/syscalls.h
@@ -0,0 +1,62 @@
+#ifndef _ASM_METAG_SYSCALLS_H
+#define _ASM_METAG_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+
+/* kernel/process.c */
+#define sys_fork sys_fork
+asmlinkage int sys_fork(unsigned long, unsigned long,
+			unsigned long, unsigned long,
+			unsigned long, unsigned long,
+			struct pt_regs *);
+
+#define sys_clone sys_clone
+asmlinkage int sys_clone(unsigned long, unsigned long,
+			 unsigned long, unsigned long,
+			 unsigned long, unsigned long,
+			 struct pt_regs *);
+
+/* kernel/signal.c */
+#define sys_sigaltstack sys_sigaltstack
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long,
+			       unsigned long, unsigned long,
+			       struct pt_regs *);
+
+#define sys_rt_sigreturn sys_rt_sigreturn
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long,
+				unsigned long, unsigned long,
+				unsigned long, unsigned long,
+				struct pt_regs *);
+
+#include <asm-generic/syscalls.h>
+
+/* kernel/sys_metag.c */
+asmlinkage int sys_metag_setglobalbit(char __user *, int);
+asmlinkage void sys_metag_set_fpu_flags(unsigned int);
+asmlinkage int sys_metag_set_tls(void __user *);
+asmlinkage void *sys_metag_get_tls(void);
+
+asmlinkage long sys_truncate64_metag(const char __user *, unsigned long,
+				     unsigned long);
+asmlinkage long sys_ftruncate64_metag(unsigned int, unsigned long,
+				      unsigned long);
+asmlinkage long sys_fadvise64_64_metag(int, unsigned long, unsigned long,
+				       unsigned long, unsigned long, int);
+asmlinkage long sys_readahead_metag(int, unsigned long, unsigned long, size_t);
+asmlinkage ssize_t sys_pread64_metag(unsigned long, char __user *, size_t,
+				     unsigned long, unsigned long);
+asmlinkage ssize_t sys_pwrite64_metag(unsigned long, char __user *, size_t,
+				      unsigned long, unsigned long);
+asmlinkage long sys_sync_file_range_metag(int, unsigned long, unsigned long,
+					  unsigned long, unsigned long,
+					  unsigned int);
+
+extern void do_notify_resume(struct pt_regs *regs, int from_syscall,
+			     unsigned int orig_syscall,
+			     unsigned long thread_info_flags);
+
+#endif /* _ASM_METAG_SYSCALLS_H */
diff --git a/arch/metag/include/asm/unistd.h b/arch/metag/include/asm/unistd.h
new file mode 100644
index 0000000..8852894
--- /dev/null
+++ b/arch/metag/include/asm/unistd.h
@@ -0,0 +1,12 @@
+/*
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <uapi/asm/unistd.h>
+
+#define __ARCH_WANT_SYS_EXECVE
diff --git a/arch/metag/include/asm/user_gateway.h b/arch/metag/include/asm/user_gateway.h
new file mode 100644
index 0000000..e404c09
--- /dev/null
+++ b/arch/metag/include/asm/user_gateway.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2010 Imagination Technologies
+ */
+
+#ifndef __ASM_METAG_USER_GATEWAY_H
+#define __ASM_METAG_USER_GATEWAY_H
+
+#include <asm/page.h>
+
+/* Page of kernel code accessible to userspace. */
+#define USER_GATEWAY_PAGE	0x6ffff000
+/* Offset of TLS pointer array in gateway page. */
+#define USER_GATEWAY_TLS	0x100
+
+#ifndef __ASSEMBLY__
+
+extern char __user_gateway_start;
+extern char __user_gateway_end;
+
+/* Kernel mapping of the gateway page. */
+extern void *gateway_page;
+
+static inline void set_gateway_tls(void __user *tls_ptr)
+{
+	void **gateway_tls = (void **)(gateway_page + USER_GATEWAY_TLS +
+				       hard_processor_id() * 4);
+
+	*gateway_tls = (__force void *)tls_ptr;
+#ifdef CONFIG_METAG_META12
+	/* Avoid cache aliases on virtually tagged cache. */
+	__builtin_dcache_flush((void *)USER_GATEWAY_PAGE + USER_GATEWAY_TLS +
+				       hard_processor_id() * sizeof(void *));
+#endif
+}
+
+extern int __kuser_get_tls(void);
+extern char *__kuser_get_tls_end[];
+
+extern int __kuser_cmpxchg(int, int, unsigned long *);
+extern char *__kuser_cmpxchg_end[];
+
+#endif
+
+#endif
diff --git a/arch/metag/include/uapi/asm/unistd.h b/arch/metag/include/uapi/asm/unistd.h
new file mode 100644
index 0000000..b80b8e8
--- /dev/null
+++ b/arch/metag/include/uapi/asm/unistd.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Use the standard ABI for syscalls. */
+#include <asm-generic/unistd.h>
+
+/* metag-specific syscalls. */
+#define __NR_metag_setglobalbit		(__NR_arch_specific_syscall + 1)
+__SYSCALL(__NR_metag_setglobalbit, sys_metag_setglobalbit)
+#define __NR_metag_set_fpu_flags	(__NR_arch_specific_syscall + 2)
+__SYSCALL(__NR_metag_set_fpu_flags, sys_metag_set_fpu_flags)
+#define __NR_metag_set_tls		(__NR_arch_specific_syscall + 3)
+__SYSCALL(__NR_metag_set_tls, sys_metag_set_tls)
+#define __NR_metag_get_tls		(__NR_arch_specific_syscall + 4)
+__SYSCALL(__NR_metag_get_tls, sys_metag_get_tls)
diff --git a/arch/metag/kernel/sys_metag.c b/arch/metag/kernel/sys_metag.c
new file mode 100644
index 0000000..7d8f389
--- /dev/null
+++ b/arch/metag/kernel/sys_metag.c
@@ -0,0 +1,198 @@
+/*
+ * This file contains various random system calls that
+ * have a non-standard calling sequence on the Linux/Meta
+ * platform.
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/syscalls.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+#include <asm/switch.h>
+#include <asm/syscall.h>
+#include <asm/syscalls.h>
+#include <asm/user_gateway.h>
+
+#define merge_64(hi, lo) ((((unsigned long long)(hi)) << 32) + \
+			  ((lo) & 0xffffffffUL))
+
+int metag_mmap_check(unsigned long addr, unsigned long len,
+		     unsigned long flags)
+{
+	/* We can't have people trying to write to the bottom of the
+	 * memory map, there are mysterious unspecified things there that
+	 * we don't want people trampling on.
+	 */
+	if ((flags & MAP_FIXED) && (addr < TASK_UNMAPPED_BASE))
+		return -EINVAL;
+
+	return 0;
+}
+
+asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
+			  unsigned long prot, unsigned long flags,
+			  unsigned long fd, unsigned long pgoff)
+{
+	/* The shift for mmap2 is constant, regardless of PAGE_SIZE setting. */
+	if (pgoff & ((1 << (PAGE_SHIFT - 12)) - 1))
+		return -EINVAL;
+
+	pgoff >>= PAGE_SHIFT - 12;
+
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
+}
+
+asmlinkage int sys_metag_setglobalbit(char __user *addr, int mask)
+{
+	char tmp;
+	int ret = 0;
+	unsigned int flags;
+
+	if (!((__force unsigned int)addr >= LINCORE_BASE))
+		return -EFAULT;
+
+	TBI_LOCK(flags);
+
+	__TBIDataCacheFlush((__force void *)addr, sizeof(mask));
+
+	ret = __get_user(tmp, addr);
+	if (ret)
+		goto out;
+	tmp |= mask;
+	ret = __put_user(tmp, addr);
+
+	__TBIDataCacheFlush((__force void *)addr, sizeof(mask));
+
+out:
+	TBI_UNLOCK(flags);
+
+	return ret;
+}
+
+/*
+ * Do a system call from kernel instead of calling sys_execve so we
+ * end up with proper pt_regs.
+ */
+int kernel_execve(const char *filename, const char *const argv[],
+		  const char *const envp[])
+{
+	register long __call __asm__("D1Re0") = __NR_execve;
+	register long __res __asm__("D0Re0");
+	register long __a __asm__("D1Ar1") = (long)(filename);
+	register long __b __asm__("D0Ar2") = (long)(argv);
+	register long __c __asm__("D1Ar3") = (long)(envp);
+	__asm__ __volatile__("SWITCH	#%c1"
+			     : "=d" (__res)
+			     : "i" (__METAG_SW_SYS), "d" (__call),
+			       "d" (__a), "d" (__b), "d" (__c)
+			     : "memory");
+	return __res;
+}
+
+#define TXDEFR_FPU_MASK ((0x1f << 16) | 0x1f)
+
+asmlinkage void sys_metag_set_fpu_flags(unsigned int flags)
+{
+	unsigned int temp;
+
+	flags &= TXDEFR_FPU_MASK;
+
+	__asm__ __volatile__("MOV %0,TXDEFR\n" : "=r" (temp));
+
+	temp &= ~TXDEFR_FPU_MASK;
+	temp |= flags;
+
+	__asm__ __volatile__("MOV TXDEFR,%0\n" : : "r" (temp));
+}
+
+asmlinkage int sys_metag_set_tls(void __user *ptr)
+{
+	current->thread.tls_ptr = ptr;
+	set_gateway_tls(ptr);
+
+	return 0;
+}
+
+asmlinkage void *sys_metag_get_tls(void)
+{
+	return (__force void *)current->thread.tls_ptr;
+}
+
+asmlinkage long sys_truncate64_metag(const char __user *path, unsigned long lo,
+				     unsigned long hi)
+{
+	return sys_truncate64(path, merge_64(hi, lo));
+}
+
+asmlinkage long sys_ftruncate64_metag(unsigned int fd, unsigned long lo,
+				      unsigned long hi)
+{
+	return sys_ftruncate64(fd, merge_64(hi, lo));
+}
+
+asmlinkage long sys_fadvise64_64_metag(int fd, unsigned long offs_lo,
+				       unsigned long offs_hi, unsigned long len_lo,
+				       unsigned long len_hi, int advice)
+{
+	return sys_fadvise64_64(fd, merge_64(offs_hi, offs_lo),
+				merge_64(len_hi, len_lo), advice);
+}
+
+asmlinkage long sys_readahead_metag(int fd, unsigned long lo, unsigned long hi,
+				    size_t count)
+{
+	return sys_readahead(fd, merge_64(hi, lo), count);
+}
+
+asmlinkage ssize_t sys_pread64_metag(unsigned long fd, char __user *buf,
+				     size_t count, unsigned long lo,
+				     unsigned long hi)
+{
+	return sys_pread64(fd, buf, count, merge_64(hi, lo));
+}
+
+asmlinkage ssize_t sys_pwrite64_metag(unsigned long fd, char __user *buf,
+				      size_t count, unsigned long lo,
+				      unsigned long hi)
+{
+	return sys_pwrite64(fd, buf, count, merge_64(hi, lo));
+}
+
+asmlinkage long sys_sync_file_range_metag(int fd, unsigned long offs_lo,
+					  unsigned long offs_hi,
+					  unsigned long len_lo,
+					  unsigned long len_hi,
+					  unsigned int flags)
+{
+	return sys_sync_file_range(fd, merge_64(offs_hi, offs_lo),
+				   merge_64(len_hi, len_lo), flags);
+}
+
+/* Provide the actual syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+/*
+ * We need wrappers for anything with unaligned 64bit arguments
+ */
+#define sys_truncate64		sys_truncate64_metag
+#define sys_ftruncate64		sys_ftruncate64_metag
+#define sys_fadvise64_64	sys_fadvise64_64_metag
+#define sys_readahead		sys_readahead_metag
+#define sys_pread64		sys_pread64_metag
+#define sys_pwrite64		sys_pwrite64_metag
+#define sys_sync_file_range	sys_sync_file_range_metag
+
+/*
+ * Note that we can't include <linux/unistd.h> here since the header
+ * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
+ */
+const void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff --git a/arch/metag/kernel/user_gateway.S b/arch/metag/kernel/user_gateway.S
new file mode 100644
index 0000000..7167f3e
--- /dev/null
+++ b/arch/metag/kernel/user_gateway.S
@@ -0,0 +1,97 @@
+/*
+ * Copyright (C) 2010 Imagination Technologies Ltd.
+ *
+ * This file contains code that can be accessed from userspace and can
+ * access certain kernel data structures without the overhead of a system
+ * call.
+ */
+
+#include <asm/metag_regs.h>
+#include <asm/user_gateway.h>
+
+/*
+ * User helpers.
+ *
+ * These are segment of kernel provided user code reachable from user space
+ * at a fixed address in kernel memory.  This is used to provide user space
+ * with some operations which require kernel help because of unimplemented
+ * native feature and/or instructions in some Meta CPUs. The idea is for
+ * this code to be executed directly in user mode for best efficiency but
+ * which is too intimate with the kernel counter part to be left to user
+ * libraries.  The kernel reserves the right to change this code as needed
+ * without warning. Only the entry points and their results are guaranteed
+ * to be stable.
+ *
+ * Each segment is 64-byte aligned.  This mechanism should be used only for
+ * for things that are really small and justified, and not be abused freely.
+ */
+	.text
+	.global	___user_gateway_start
+___user_gateway_start:
+
+	/* get_tls
+	 * Offset:	 0
+	 * Description:	 Get the TLS pointer for this process.
+	 */
+	.global	___kuser_get_tls
+	.type	___kuser_get_tls,function
+___kuser_get_tls:
+	MOVT	D1Ar1,#HI(USER_GATEWAY_PAGE + USER_GATEWAY_TLS)
+	ADD	D1Ar1,D1Ar1,#LO(USER_GATEWAY_PAGE + USER_GATEWAY_TLS)
+	MOV	D1Ar3,TXENABLE
+	AND	D1Ar3,D1Ar3,#(TXENABLE_THREAD_BITS)
+	LSR	D1Ar3,D1Ar3,#(TXENABLE_THREAD_S - 2)
+	GETD	D0Re0,[D1Ar1+D1Ar3]
+___kuser_get_tls_end:		/* Beyond this point the read will complete */
+	MOV	PC,D1RtP
+	.size	___kuser_get_tls,.-___kuser_get_tls
+	.global	___kuser_get_tls_end
+
+	/* cmpxchg
+	 * Offset:	 64
+	 * Description:  Replace the value at 'ptr' with 'newval' if the current
+	 *		 value is 'oldval'. Return zero if we succeeded,
+	 *		 non-zero otherwise.
+	 *
+	 * Reference prototype:
+	 *
+	 *	int __kuser_cmpxchg(int oldval, int newval, unsigned long *ptr)
+	 *
+	 */
+	.balign 64
+	.global ___kuser_cmpxchg
+	.type   ___kuser_cmpxchg,function
+___kuser_cmpxchg:
+#ifdef CONFIG_SMP
+	/*
+	 * We must use LNKGET/LNKSET with an SMP kernel because the other method
+	 * does not provide atomicity across multiple CPUs.
+	 */
+0:	LNKGETD	D0Re0,[D1Ar3]
+	CMP	D0Re0,D1Ar1
+	LNKSETDZ [D1Ar3],D0Ar2
+	BNZ	1f
+	DEFR	D0Re0,TXSTAT
+	ANDT	D0Re0,D0Re0,#HI(0x3f000000)
+	CMPT	D0Re0,#HI(0x02000000)
+	BNE	0b
+#ifdef CONFIG_METAG_LNKGET_AROUND_CACHE
+	DCACHE  [D1Ar3], D0Re0
+#endif
+1:	MOV	D0Re0,#1
+	XORZ	D0Re0,D0Re0,D0Re0
+	MOV	PC,D1RtP
+#else
+	GETD	D0Re0,[D1Ar3]
+	CMP	D0Re0,D1Ar1
+	SETDZ	[D1Ar3],D0Ar2
+___kuser_cmpxchg_end:		/* Beyond this point the write will complete */
+	MOV	D0Re0,#1
+	XORZ	D0Re0,D0Re0,D0Re0
+	MOV	PC,D1RtP
+#endif /* CONFIG_SMP */
+	.size	___kuser_cmpxchg,.-___kuser_cmpxchg
+	.global	___kuser_cmpxchg_end
+
+	.global	___user_gateway_end
+___user_gateway_end:
-- 
1.7.7.6


