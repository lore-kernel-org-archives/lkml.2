Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1FSLrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:47:45 -0400
Received: from mail.southpole.se ([193.12.106.18]:37747 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1FSLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:20 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 10/19] OpenRISC: System calls
Date: Sun, 19 Jun 2011 13:43:36 +0200
Message-Id: <1308483825-6023-11-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The OpenRISC Linux kernel conforms to the "generic" syscall interface which
contains only the reduced set of syscalls deemed necessary for new
architectures.  Unfortunately, the uClibc port for OpenRISC does not fully
support this reduced set; as such, an additional patch available out-of-tree
needs to be applied to the kernel in order to use the current uClibc.  This
is just a temporary measure until the libc port can be straightened out; it
is likely that OpenRISC will make the transition to glibc shortly where the
generic syscall interface is better supported.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/syscall.h   |   78 +++++++++++++++++++++++++++++++
 arch/openrisc/include/asm/syscalls.h  |   27 +++++++++++
 arch/openrisc/include/asm/unistd.h    |   29 +++++++++++
 arch/openrisc/kernel/sys_call_table.c |   28 +++++++++++
 arch/openrisc/kernel/sys_or32.c       |   83 +++++++++++++++++++++++++++++++++
 5 files changed, 245 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/syscall.h
 create mode 100644 arch/openrisc/include/asm/syscalls.h
 create mode 100644 arch/openrisc/include/asm/unistd.h
 create mode 100644 arch/openrisc/kernel/sys_call_table.c
 create mode 100644 arch/openrisc/kernel/sys_or32.c

diff --git a/arch/openrisc/include/asm/syscall.h b/arch/openrisc/include/asm/syscall.h
new file mode 100644
index 0000000..c62859a
--- /dev/null
+++ b/arch/openrisc/include/asm/syscall.h
@@ -0,0 +1,78 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SYSCALL_H__
+#define __ASM_OPENRISC_SYSCALL_H__
+
+#include <linux/err.h>
+#include <linux/sched.h>
+
+static inline int
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return (regs->syscallno ? regs->syscallno : -1);
+}
+
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->gpr[11] = regs->orig_gpr11;
+}
+
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+{
+	return IS_ERR_VALUE(regs->gpr[11]) ? regs->gpr[11] : 0;
+}
+
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->gpr[11];
+}
+
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+                         int error, long val)
+{
+	if (error) {
+		regs->gpr[11] = -error;
+	} else {
+		regs->gpr[11] = val;
+	}
+}
+
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+                      unsigned int i, unsigned int n, unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+
+	memcpy(args, &regs->gpr[3 + i], n * sizeof(args[0]));
+}
+
+static inline void
+syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
+                      unsigned int i, unsigned int n, const unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+
+	memcpy(&regs->gpr[3 + i], args, n * sizeof(args[0]));
+}
+
+#endif
diff --git a/arch/openrisc/include/asm/syscalls.h b/arch/openrisc/include/asm/syscalls.h
new file mode 100644
index 0000000..cf11a9e
--- /dev/null
+++ b/arch/openrisc/include/asm/syscalls.h
@@ -0,0 +1,27 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SYSCALLS_H
+#define __ASM_OPENRISC_SYSCALLS_H
+
+asmlinkage long sys_or1k_atomic(unsigned long type, unsigned long* v1,
+				unsigned long* v2);
+
+#include <asm-generic/syscalls.h>
+
+#endif /* __ASM_OPENRISC_SYSCALLS_H */
diff --git a/arch/openrisc/include/asm/unistd.h b/arch/openrisc/include/asm/unistd.h
new file mode 100644
index 0000000..4a3d6ad
--- /dev/null
+++ b/arch/openrisc/include/asm/unistd.h
@@ -0,0 +1,29 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#if !defined(__ASM_OPENRISC_UNISTD_H) || defined(__SYSCALL)
+#define __ASM_OPENRISC_UNISTD_H
+
+#define __ARCH_HAVE_MMU
+
+#include <asm-generic/unistd.h>
+
+#define __NR_or1k_atomic __NR_arch_specific_syscall
+__SYSCALL(__NR_or1k_atomic, sys_or1k_atomic)
+
+#endif /* __ASM_OPENRISC_UNISTD_H */
diff --git a/arch/openrisc/kernel/sys_call_table.c b/arch/openrisc/kernel/sys_call_table.c
new file mode 100644
index 0000000..e1f8ce8
--- /dev/null
+++ b/arch/openrisc/kernel/sys_call_table.c
@@ -0,0 +1,28 @@
+/*
+ * OpenRISC sys_call_table.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[__NR_syscalls] = {
+#include <asm/unistd.h>
+};
diff --git a/arch/openrisc/kernel/sys_or32.c b/arch/openrisc/kernel/sys_or32.c
new file mode 100644
index 0000000..c930470
--- /dev/null
+++ b/arch/openrisc/kernel/sys_or32.c
@@ -0,0 +1,83 @@
+/*
+ * OpenRISC sys_or32.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * This file contains various random system calls that
+ * have a non-standard calling sequence on some platforms.
+ * Since we don't have to do any backwards compatibility, our
+ * versions are done in the most "normal" way possible.
+ */
+
+#include <linux/errno.h>
+#include <linux/syscalls.h>
+#include <linux/mm.h>
+
+#include <asm/syscalls.h>
+
+asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
+        unsigned long prot, unsigned long flags,
+        unsigned long fd, unsigned long pgoff)
+{
+        return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
+}
+
+asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
+                        unsigned long prot, unsigned long flags,
+                        unsigned long fd, off_t pgoff)
+{
+        if (pgoff & ~PAGE_MASK)
+                return -EINVAL;
+
+        return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
+}
+
+/* These are secondary entry points as the primary entry points are defined in
+ * entry.S where we add the 'regs' parameter value
+ */
+
+asmlinkage long _sys_clone(unsigned long clone_flags, unsigned long newsp,
+                        int __user *parent_tid, int __user *child_tid,
+                        struct pt_regs *regs)
+{
+	long ret;
+
+	/* FIXME: Is alignment necessary? */
+	/* newsp = ALIGN(newsp, 4); */
+
+	if (!newsp)
+		newsp = regs->sp;
+
+	ret = do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+
+	return ret;
+}
+
+asmlinkage int _sys_fork(struct pt_regs *regs)
+{
+#ifdef CONFIG_MMU
+        return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+#else
+	return -EINVAL;
+#endif
+}
+
+asmlinkage int _sys_vfork(struct pt_regs *regs)
+{
+	/* This doesn't seem to work */
+//        return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+
+	/* This works */
+        return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+}
-- 
1.7.4.1

