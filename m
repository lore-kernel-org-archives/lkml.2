Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab2GFVK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:10:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33040 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382Ab2GFVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:44 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 23/36] AArch64: System calls handling
Date: Fri,  6 Jul 2012 22:06:04 +0100
Message-Id: <1341608777-12982-24-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:36.0903 (UTC) FILETIME=[5EAD2570:01CD5BBB]
X-MC-Unique: 112070622064207001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LBPca005404

This patch adds support for system calls coming from 64-bit
applications. It uses the asm-generic/unistd.h definitions with the
canonical set of system calls. The private system calls are only used
for 32-bit (compat) applications as 64-bit ones can set the TLS and
flush the caches entirely from user space.

The sys_call_table is just an array defined in a C file and it contains
pointers to the syscall functions. The array is 4KB aligned to allow the
use of the ADRP instruction (longer range ADR) in entry.S.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/stat.h     |   64 ++++++++++++++++
 arch/aarch64/include/asm/statfs.h   |   24 ++++++
 arch/aarch64/include/asm/syscalls.h |   41 ++++++++++
 arch/aarch64/include/asm/unistd.h   |   28 +++++++
 arch/aarch64/kernel/sys.c           |  139 +++++++++++++++++++++++++++++++++++
 5 files changed, 296 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/stat.h
 create mode 100644 arch/aarch64/include/asm/statfs.h
 create mode 100644 arch/aarch64/include/asm/syscalls.h
 create mode 100644 arch/aarch64/include/asm/unistd.h
 create mode 100644 arch/aarch64/kernel/sys.c

diff --git a/arch/aarch64/include/asm/stat.h b/arch/aarch64/include/asm/stat.h
new file mode 100644
index 0000000..22571ac
--- /dev/null
+++ b/arch/aarch64/include/asm/stat.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_STAT_H
+#define __ASM_STAT_H
+
+#include <asm-generic/stat.h>
+
+#if defined(__KERNEL__) && defined(CONFIG_AARCH32_EMULATION)
+
+#include <asm/compat.h>
+
+/* This matches struct stat64 in glibc2.1, hence the absolutely
+ * insane amounts of padding around dev_t's.
+ * Note: The kernel zero's the padded region because glibc might read them
+ * in the hope that the kernel has stretched to using larger sizes.
+ */
+struct stat64 {
+	compat_u64	st_dev;
+	unsigned char   __pad0[4];
+
+#define STAT64_HAS_BROKEN_ST_INO	1
+	compat_ulong_t	__st_ino;
+	compat_uint_t	st_mode;
+	compat_uint_t	st_nlink;
+
+	compat_ulong_t	st_uid;
+	compat_ulong_t	st_gid;
+
+	compat_u64	st_rdev;
+	unsigned char   __pad3[4];
+
+	compat_s64	st_size;
+	compat_ulong_t	st_blksize;
+	compat_u64	st_blocks;	/* Number 512-byte blocks allocated. */
+
+	compat_ulong_t	st_atime;
+	compat_ulong_t	st_atime_nsec;
+
+	compat_ulong_t	st_mtime;
+	compat_ulong_t	st_mtime_nsec;
+
+	compat_ulong_t	st_ctime;
+	compat_ulong_t	st_ctime_nsec;
+
+	compat_u64	st_ino;
+};
+
+#endif
+
+#endif
diff --git a/arch/aarch64/include/asm/statfs.h b/arch/aarch64/include/asm/statfs.h
new file mode 100644
index 0000000..2f75b53
--- /dev/null
+++ b/arch/aarch64/include/asm/statfs.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_STATFS_H
+#define __ASM_STATFS_H
+
+#define ARCH_PACK_COMPAT_STATFS64 __attribute__((packed,aligned(4)))
+
+#include <asm-generic/statfs.h>
+
+#endif
diff --git a/arch/aarch64/include/asm/syscalls.h b/arch/aarch64/include/asm/syscalls.h
new file mode 100644
index 0000000..c58969e
--- /dev/null
+++ b/arch/aarch64/include/asm/syscalls.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_SYSCALLS_H
+#define __ASM_SYSCALLS_H
+
+#include <linux/linkage.h>
+#include <linux/compiler.h>
+#include <linux/signal.h>
+
+/*
+ * System call wrappers implemented in kernel/entry.S.
+ */
+asmlinkage long sys_execve_wrapper(const char __user *filename,
+				   const char __user *const __user *argv,
+				   const char __user *const __user *envp);
+asmlinkage long sys_clone_wrapper(unsigned long clone_flags,
+				  unsigned long newsp,
+				  void __user *parent_tid,
+				  unsigned long tls_val,
+				  void __user *child_tid);
+asmlinkage long sys_rt_sigreturn_wrapper(void);
+asmlinkage long sys_sigaltstack_wrapper(const stack_t __user *uss,
+					stack_t __user *uoss);
+
+#include <asm-generic/syscalls.h>
+
+#endif	/* __ASM_SYSCALLS_H */
diff --git a/arch/aarch64/include/asm/unistd.h b/arch/aarch64/include/asm/unistd.h
new file mode 100644
index 0000000..66399a3
--- /dev/null
+++ b/arch/aarch64/include/asm/unistd.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#if !defined(__ASM_UNISTD_H) || defined(__SYSCALL)
+#define __ASM_UNISTD_H
+
+#ifndef __SYSCALL_COMPAT
+#include <asm-generic/unistd.h>
+#endif
+
+#if defined(__KERNEL__) && defined(CONFIG_AARCH32_EMULATION)
+#include <asm/unistd32.h>
+#endif
+
+#endif /* __ASM_UNISTD_H */
diff --git a/arch/aarch64/kernel/sys.c b/arch/aarch64/kernel/sys.c
new file mode 100644
index 0000000..c1af95d
--- /dev/null
+++ b/arch/aarch64/kernel/sys.c
@@ -0,0 +1,139 @@
+/*
+ * AArch64-specific system calls implementation
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+/*
+ * Clone a task - this clones the calling program thread.
+ */
+asmlinkage long sys_clone(unsigned long clone_flags, unsigned long newsp,
+			  int __user *parent_tidptr, unsigned long tls_val,
+			  int __user *child_tidptr, struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->sp;
+	/* 16-byte aligned stack mandatory on AArch64 */
+	if (newsp & 15)
+		return -EINVAL;
+	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
+}
+
+/*
+ * sys_execve() executes a new program.
+ */
+asmlinkage long sys_execve(const char __user *filenamei,
+			   const char __user *const __user *argv,
+			   const char __user *const __user *envp,
+			   struct pt_regs *regs)
+{
+	long error;
+	char * filename;
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
+	regs.regs[0] = ret;
+
+	/*
+	 * We were successful.  We won't be returning to our caller, but
+	 * instead to user space by manipulating the kernel stack.
+	 */
+	asm(	"add	x0, %0, %1\n\t"
+		"mov	x1, %2\n\t"
+		"mov	x2, %3\n\t"
+		"bl	memmove\n\t"	/* copy regs to top of stack */
+		"mov	x27, #0\n\t"	/* not a syscall */
+		"mov	x28, %0\n\t"	/* thread structure */
+		"mov	sp, x0\n\t"	/* reposition stack pointer */
+		"b	ret_to_user"
+		:
+		: "r" (current_thread_info()),
+		  "Ir" (THREAD_START_SP - sizeof(regs)),
+		  "r" (&regs),
+		  "Ir" (sizeof(regs))
+		: "x0", "x1", "x2", "x27", "x28", "x30", "memory");
+
+ out:
+	return ret;
+}
+EXPORT_SYMBOL(kernel_execve);
+
+asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
+			 unsigned long prot, unsigned long flags,
+			 unsigned long fd, off_t off)
+{
+	if (offset_in_page(off) != 0)
+		return -EINVAL;
+
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
+}
+
+/*
+ * Wrappers to pass the pt_regs argument.
+ */
+#define sys_execve		sys_execve_wrapper
+#define sys_clone		sys_clone_wrapper
+#define sys_rt_sigreturn	sys_rt_sigreturn_wrapper
+#define sys_sigaltstack		sys_sigaltstack_wrapper
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, sym)	[nr] = sym,
+
+/*
+ * The sys_call_table array must be 4K aligned to be accessible from
+ * kernel/entry.S.
+ */
+void *sys_call_table[__NR_syscalls] __aligned(4096) = {
+	[0 ... __NR_syscalls - 1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};

