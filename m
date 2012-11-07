Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2KGJv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:51:56 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:53864 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2KGJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:35 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 14/31] ARC: syscall support
Date: Wed,  7 Nov 2012 10:47:37 +0100
Message-Id: <1352281674-2186-15-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/ptrace.h   |    5 ++
 arch/arc/include/asm/syscall.h  |   72 +++++++++++++++++++++++
 arch/arc/include/asm/syscalls.h |   30 ++++++++++
 arch/arc/include/asm/unistd.h   |   44 ++++++++++++++
 arch/arc/kernel/entry.S         |   49 ++++++++++++++++
 arch/arc/kernel/process.c       |  119 +++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/sys.c           |   19 ++++++
 arch/arc/mm/mmap.c              |   21 +++++++
 8 files changed, 359 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/syscall.h
 create mode 100644 arch/arc/include/asm/syscalls.h
 create mode 100644 arch/arc/include/asm/unistd.h
 create mode 100644 arch/arc/kernel/process.c
 create mode 100644 arch/arc/kernel/sys.c
 create mode 100644 arch/arc/mm/mmap.c

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index c178357..ee31d8a 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -115,6 +115,11 @@ struct user_regs_struct {
 /* return 1 if user mode or 0 if kernel mode */
 #define user_mode(regs) (regs->status32 & STATUS_U_MASK)
 
+
+/* return 1 if in syscall, 0 if Intr or Exception */
+#define in_syscall(regs) (((regs->orig_r8) >= 0 && \
+			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/include/asm/syscall.h b/arch/arc/include/asm/syscall.h
new file mode 100644
index 0000000..33ab304
--- /dev/null
+++ b/arch/arc/include/asm/syscall.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SYSCALL_H
+#define _ASM_ARC_SYSCALL_H  1
+
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <asm/unistd.h>
+#include <asm/ptrace.h>		/* in_syscall() */
+
+static inline long
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (user_mode(regs) && in_syscall(regs))
+		return regs->orig_r8;
+	else
+		return -1;
+}
+
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+{
+	/* XXX: I can't fathom how pt_regs->r8 will be clobbered ? */
+	regs->r8 = regs->orig_r8;
+}
+
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+{
+	/* 0 if syscall succeeded, otherwise -Errorcode */
+	return IS_ERR_VALUE(regs->r0) ? regs->r0 : 0;
+}
+
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->r0;
+}
+
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+			 int error, long val)
+{
+	regs->r0 = (long) error ?: val;
+}
+
+/*
+ * @i:      argument index [0,5]
+ * @n:      number of arguments; n+i must be [1,6].
+ */
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned int i, unsigned int n, unsigned long *args)
+{
+	unsigned long *inside_ptregs = &(regs->r0);
+	inside_ptregs -= i;
+
+	BUG_ON((i + n) > 6);
+
+	while (n--) {
+		args[i++] = (*inside_ptregs);
+		inside_ptregs--;
+	}
+}
+
+#endif
diff --git a/arch/arc/include/asm/syscalls.h b/arch/arc/include/asm/syscalls.h
new file mode 100644
index 0000000..cf5d2f5
--- /dev/null
+++ b/arch/arc/include/asm/syscalls.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SYSCALLS_H
+#define _ASM_ARC_SYSCALLS_H  1
+
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+int sys_execve_wrapper(int, int, int);
+int sys_clone_wrapper(int, int, int, int, int);
+int sys_fork_wrapper(void);
+int sys_vfork_wrapper(void);
+int sys_cacheflush(uint32_t, uint32_t uint32_t);
+int sys_arc_settls(void *);
+int sys_arc_gettls(void);
+
+#include <asm-generic/syscalls.h>
+
+#endif	/* __KERNEL__ */
+
+#endif
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
new file mode 100644
index 0000000..754d588
--- /dev/null
+++ b/arch/arc/include/asm/unistd.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Being uClibc based we need some of the deprecated syscalls:
+ * -Not emulated by uClibc at all
+ *	unlink, mkdir,... (needed by Busybox, LTP etc)
+ *	times (needed by LTP pan test harness)
+ * -Not emulated efficiently
+ *	select: emulated using pselect (but extra code to chk usec > 1sec)
+ *
+ * some (send/recv) correctly emulated using (recfrom/sendto) and
+ * some arch specific ones (fork/vfork)can easily be emulated using clone but
+ * thats the price of using common-denominator....
+ */
+#define __ARCH_WANT_SYSCALL_NO_AT
+#define __ARCH_WANT_SYSCALL_NO_FLAGS
+#define __ARCH_WANT_SYSCALL_OFF_T
+#define __ARCH_WANT_SYSCALL_DEPRECATED
+
+#define sys_mmap2 sys_mmap_pgoff
+
+#include <asm-generic/unistd.h>
+
+#define NR_syscalls	__NR_syscalls
+
+/* ARC specific syscall */
+#define __NR_cacheflush		(__NR_arch_specific_syscall + 0)
+#define __NR_arc_settls		(__NR_arch_specific_syscall + 1)
+#define __NR_arc_gettls		(__NR_arch_specific_syscall + 2)
+
+__SYSCALL(__NR_cacheflush, sys_cacheflush)
+__SYSCALL(__NR_arc_settls, sys_arc_settls)
+__SYSCALL(__NR_arc_gettls, sys_arc_gettls)
+
+
+/* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
+#define __NR_sysfs		(__NR_arch_specific_syscall + 3)
+__SYSCALL(__NR_sysfs, sys_sysfs)
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index b829052..fe9a17c 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -7,6 +7,10 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
+ * TBD:
+ *  -remove the low level wrappers for execve/fork/vfork
+ *   needed before task_pt_regs was invented. This saves a branch per call
+ *
  * vineetg: Nov 2010:
  *  -Vector table jumps (@8 bytes) converted into branches (@4 bytes)
  *  -To maintain the slot size of 8 bytes/vector, added nop, which is
@@ -575,3 +579,48 @@ ARC_ENTRY ret_from_fork
 	bl  @schedule_tail
 	b @ret_from_exception
 ARC_EXIT ret_from_fork
+
+;################### Special Sys Call Wrappers ##########################
+
+ARC_ENTRY sys_execve_wrapper
+	; copy pointer to pt_regs as a parameter
+	mov  r3, sp
+	bl  @sys_execve
+
+	b ret_from_system_call
+ARC_EXIT sys_execve_wrapper
+
+; TBD: call do_fork directly from here
+ARC_ENTRY sys_fork_wrapper
+	; copy pointer to pt_regs as a parameter
+	mov  r0, sp
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_fork
+	DISCARD_CALLEE_SAVED_USER
+
+	b ret_from_system_call
+ARC_EXIT sys_fork_wrapper
+
+ARC_ENTRY sys_vfork_wrapper
+	; copy pointer to pt_regs as a parameter
+	mov  r0, sp
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_vfork
+	DISCARD_CALLEE_SAVED_USER
+
+	b ret_from_system_call
+ARC_EXIT sys_vfork_wrapper
+
+ARC_ENTRY sys_clone_wrapper
+	; clone sys-call takes 2 mandatary args: @flags and @child-stack
+	; and it can take 3 var-args, depending on flags
+	; To keep sys_clone( ) signature constant, we assume all 5 args
+	; and set the helper @prtegs in next free reg
+	; this is cheap since our args are in regs, not on stack
+	mov r5, sp  ; pt_regs
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_clone
+	DISCARD_CALLEE_SAVED_USER
+
+	b ret_from_system_call
+ARC_EXIT sys_clone_wrapper
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
new file mode 100644
index 0000000..21d1889
--- /dev/null
+++ b/arch/arc/kernel/process.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Kanika Nema: Codito Technologies 2004
+ */
+
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/elf.h>
+#include <linux/tick.h>
+
+asmlinkage int sys_fork(struct pt_regs *regs)
+{
+	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0,
+		       NULL, NULL);
+}
+
+/* Per man, C-lib clone( ) is as follows
+ *
+ * int clone(int (*fn)(void *), void *child_stack,
+ *           int flags, void *arg, ...
+ *           pid_t *ptid, struct user_desc *tls, pid_t *ctid);
+ *
+ * @fn and @arg are of userland thread-hnalder and thus of no use
+ * in sys-call, hence excluded in sys_clone arg list.
+ * The only addition is ptregs, needed by fork core, although now-a-days
+ * task_pt_regs() can be called anywhere to get that.
+ */
+asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
+			 int __user *parent_tidptr, void *tls,
+			 int __user *child_tidptr, struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->sp;
+
+	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr,
+		       child_tidptr);
+}
+
+int sys_execve(const char __user *filenamei, const char __user *__user *argv,
+	       const char __user *__user *envp, struct pt_regs *regs)
+{
+	long error;
+	struct filename *filename;
+
+	filename = getname(filenamei);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+
+	error = do_execve(filename->name, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+int kernel_execve(const char *filename, const char *const argv[],
+		  const char *const envp[])
+{
+	/*
+	 * Although the arguments (order, number) to this function are
+	 * same as sys call, we don't need to setup args in regs again.
+	 * However in case mainline kernel changes the order of args to
+	 * kernel_execve, that assumtion will break.
+	 * So to be safe, let gcc know the args for sys call.
+	 * If they match no extra code will be generated
+	 */
+	register int arg2 asm("r1") = (int)argv;
+	register int arg3 asm("r2") = (int)envp;
+
+	register int filenm_n_ret asm("r0") = (int)filename;
+
+	__asm__ __volatile__(
+		"mov   r8, %1	\n\t"
+		"trap0		\n\t"
+		: "+r"(filenm_n_ret)
+		: "i"(__NR_execve), "r"(arg2), "r"(arg3)
+		: "r8", "memory");
+
+	return filenm_n_ret;
+}
+EXPORT_SYMBOL(kernel_execve);
+
+SYSCALL_DEFINE1(arc_settls, void *, user_tls_data_ptr)
+{
+	task_thread_info(current)->thr_ptr = (unsigned int)user_tls_data_ptr;
+	return 0;
+}
+
+/*
+ * We return the user space TLS data ptr as sys-call return code
+ * Ideally it should be copy to user.
+ * However we can cheat by the fact that some sys-calls do return
+ * absurdly high values
+ * Since the tls dat aptr is not going to be in range of 0xFFFF_xxxx
+ * it won't be considered a sys-call error
+ * and it will be loads better than copy-to-user, which is a definite
+ * D-TLB Miss
+ */
+SYSCALL_DEFINE0(arc_gettls)
+{
+	return task_thread_info(current)->thr_ptr;
+}
diff --git a/arch/arc/kernel/sys.c b/arch/arc/kernel/sys.c
new file mode 100644
index 0000000..4c30345
--- /dev/null
+++ b/arch/arc/kernel/sys.c
@@ -0,0 +1,19 @@
+
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#define sys_execve	sys_execve_wrapper
+#define sys_clone	sys_clone_wrapper
+#define sys_fork	sys_fork_wrapper
+#define sys_vfork	sys_vfork_wrapper
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[NR_syscalls] = {
+	[0 ... NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff --git a/arch/arc/mm/mmap.c b/arch/arc/mm/mmap.c
new file mode 100644
index 0000000..e1a9d61
--- /dev/null
+++ b/arch/arc/mm/mmap.c
@@ -0,0 +1,21 @@
+/* mmap for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/syscalls.h>
+
+/* Gets dragged in due to __ARCH_WANT_SYSCALL_OFF_T */
+SYSCALL_DEFINE6(mmap, unsigned long, addr_hint, unsigned long, len,
+		unsigned long, prot, unsigned long, flags, unsigned long, fd,
+		unsigned long, off)
+{
+	pr_err("old mmap not supported\n");
+	return -EINVAL;
+}
-- 
1.7.4.1

