Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1HQRFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:05:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61506 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1HQRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:05:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110806978"
Message-Id: <20110817163520.334269161@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:02 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 05/36] Hexagon: Add syscalls
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=syscalls.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/syscall.h |   45 ++++++++++
 arch/hexagon/include/asm/unistd.h  |   49 +++++++++++
 arch/hexagon/kernel/syscall.c      |  164 +++++++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/syscalltab.c   |   32 +++++++
 4 files changed, 290 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/syscall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/syscall.h	2011-07-20 15:19:36.655153568 -0500
@@ -0,0 +1,45 @@
+/*
+ * Syscall support for the Hexagon architecture
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
+#ifndef _ASM_HEXAGON_SYSCALL_H
+#define _ASM_HEXAGON_SYSCALL_H
+
+typedef long (*syscall_fn)(unsigned long, unsigned long,
+	unsigned long, unsigned long,
+	unsigned long, unsigned long);
+
+asmlinkage int sys_execve(char __user *ufilename, char __user * __user *argv,
+			  char __user * __user *envp);
+asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
+			 unsigned long parent_tidp, unsigned long child_tidp);
+
+asmlinkage int sys_fork(void);
+asmlinkage int sys_vfork(void);
+
+#define sys_execve	sys_execve
+#define sys_clone	sys_clone
+#define sys_fork	sys_fork
+#define sys_vfork	sys_vfork
+
+#include <asm-generic/syscalls.h>
+
+extern void *sys_call_table[];
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/unistd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/unistd.h	2011-07-20 15:19:36.655153568 -0500
@@ -0,0 +1,49 @@
+/*
+ * Syscall support for Hexagon
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
+#if !defined(_ASM_HEXAGON_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_HEXAGON_UNISTD_H
+
+/*
+ *  The kernel pulls this unistd.h in three different ways:
+ *  1.  the "normal" way which gets all the __NR defines
+ *  2.  with __SYSCALL defined to produce function declarations
+ *  3.  with __SYSCALL defined to produce syscall table initialization
+ *  See also:  syscalltab.c
+ */
+
+#define __ARCH_WANT_SYSCALL_DEPRECATED
+
+#ifndef __GLIBC__
+/* It seems these are all needed for uClibc...
+ * However, if glibc is compiled w/ these turned on, then it will
+ * will fail (typically with 32/64-bit compat problems). */
+#define __ARCH_WANT_SYSCALL_OFF_T
+#define __ARCH_WANT_SYSCALL_NO_AT
+#define __ARCH_WANT_SYSCALL_NO_FLAGS
+#endif
+
+/*  And the kernel itself wants these...  */
+#define __ARCH_WANT_SYS_NICE
+#define __ARCH_WANT_SYS_SIGPENDING
+
+#include <asm-generic/unistd.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/syscall.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/syscall.c	2011-07-20 15:19:36.655153568 -0500
@@ -0,0 +1,164 @@
+/*
+ * Hexagon system calls
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/linkage.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/unistd.h>
+#include <asm/mman.h>
+#include <asm/registers.h>
+
+/*
+ * System calls with architecture-specific wrappers.
+ * See signal.c for signal-related system call wrappers.
+ */
+
+asmlinkage int sys_fork(void)
+{
+	struct pt_regs *pregs = current_thread_info()->regs;
+
+	return do_fork(SIGCHLD, pregs->SP, pregs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_vfork(void)
+{
+	struct pt_regs *pregs = current_thread_info()->regs;
+
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD,
+		       pregs->SP, pregs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_execve(char __user *ufilename,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp)
+{
+	struct pt_regs *pregs = current_thread_info()->regs;
+	char *filename;
+	int retval;
+
+	filename = getname(ufilename);
+	retval = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		return retval;
+
+	retval = do_execve(filename, argv, envp, pregs);
+	putname(filename);
+
+	return retval;
+}
+
+asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
+			 unsigned long parent_tidp, unsigned long child_tidp)
+{
+	struct pt_regs *pregs = current_thread_info()->regs;
+
+	if (!newsp)
+		newsp = pregs->SP;
+	return do_fork(clone_flags, newsp, pregs, 0, (int __user *)parent_tidp,
+		       (int __user *)child_tidp);
+}
+
+/*
+ * Many archictures support both sys_mmap and sys_mmap2, which use
+ * a common do_mmap2 function to do the work.  So long as we support
+ * only mmap2, we do it all in-line here.
+ */
+asmlinkage int sys_mmap2(unsigned long addr, size_t len, unsigned long prot,
+			 unsigned long flags, unsigned long fd,
+			 unsigned long pgoff)
+{
+	struct file *file = NULL;
+	int retval = -EBADF;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			return retval;
+	}
+
+	down_write(&current->mm->mmap_sem);
+	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+	if (file)
+		fput(file);
+
+	return retval;
+}
+
+/*  apparently this should only map on page boundaries  */
+asmlinkage int sys_mmap(unsigned long addr, size_t len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, off_t off)
+{
+	struct file *file = NULL;
+	int retval = -EINVAL;
+	unsigned long pgoff;
+
+	if (off & ((1 << PAGE_SHIFT) - 1))
+		return retval;
+	pgoff = off >> PAGE_SHIFT;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		retval = -EBADF;
+		if (!file)
+			return retval;
+	}
+
+	down_write(&current->mm->mmap_sem);
+	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+	if (file)
+		fput(file);
+
+	return retval;
+}
+
+
+/*
+ * Do a system call from the kernel, so as to have a proper pt_regs
+ * and recycle the sys_execvpe infrustructure.
+ */
+int kernel_execve(const char *filename,
+		  const char *const argv[], const char *const envp[])
+{
+	register unsigned long __a0 asm("r0") = (unsigned long) filename;
+	register unsigned long __a1 asm("r1") = (unsigned long) argv;
+	register unsigned long __a2 asm("r2") = (unsigned long) envp;
+	int retval;
+
+	__asm__ volatile(
+		"	R6 = #%4;\n"
+		"	trap0(#1);\n"
+		"	%0 = R0;\n"
+		: "=r" (retval)
+		: "r" (__a0), "r" (__a1), "r" (__a2), "i" (__NR_execve)
+	);
+
+	return retval;
+}
+EXPORT_SYMBOL(kernel_execve);
Index: linux-hexagon-kernel/arch/hexagon/kernel/syscalltab.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/syscalltab.c	2011-07-20 15:19:36.655153568 -0500
@@ -0,0 +1,32 @@
+/*
+ * System call table for Hexagon
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
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscall.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[__NR_syscalls] = {
+#include <asm/unistd.h>
+};

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

