Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab1KAAZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:25:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1KAARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:17:24 -0400
Message-Id: <093448$3uejr9@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599657"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:35:16 -0500
Subject: [PATCH v5 05/36] Hexagon: Add syscalls
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/syscall.h |   54 +++++++++++++++++++++
 arch/hexagon/include/asm/unistd.h  |   36 ++++++++++++++
 arch/hexagon/kernel/syscall.c      |   90 ++++++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/syscalltab.c   |   32 +++++++++++++
 4 files changed, 212 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/syscall.h
 create mode 100644 arch/hexagon/include/asm/unistd.h
 create mode 100644 arch/hexagon/kernel/syscall.c
 create mode 100644 arch/hexagon/kernel/syscalltab.c

diff --git a/arch/hexagon/include/asm/syscall.h b/arch/hexagon/include/asm/syscall.h
new file mode 100644
index 0000000..3e7d61d
--- /dev/null
+++ b/arch/hexagon/include/asm/syscall.h
@@ -0,0 +1,54 @@
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
+#define sys_execve	sys_execve
+#define sys_clone	sys_clone
+
+#include <asm-generic/syscalls.h>
+
+extern void *sys_call_table[];
+
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	return regs->r06;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+	memcpy(args, &(&regs->r00)[i], n * sizeof(args[0]));
+}
+#endif
diff --git a/arch/hexagon/include/asm/unistd.h b/arch/hexagon/include/asm/unistd.h
new file mode 100644
index 0000000..4d0ecde
--- /dev/null
+++ b/arch/hexagon/include/asm/unistd.h
@@ -0,0 +1,36 @@
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
+#define sys_mmap2 sys_mmap_pgoff
+
+#include <asm-generic/unistd.h>
+
+#endif
diff --git a/arch/hexagon/kernel/syscall.c b/arch/hexagon/kernel/syscall.c
new file mode 100644
index 0000000..620dd18
--- /dev/null
+++ b/arch/hexagon/kernel/syscall.c
@@ -0,0 +1,90 @@
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
diff --git a/arch/hexagon/kernel/syscalltab.c b/arch/hexagon/kernel/syscalltab.c
new file mode 100644
index 0000000..c550f41
--- /dev/null
+++ b/arch/hexagon/kernel/syscalltab.c
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
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
