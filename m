Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1I0Uc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1I0Ua1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:27 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 13/24] C6X: syscalls
Date: Tue, 27 Sep 2011 16:29:54 -0400
Message-Id: <1317155405-26235-14-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/syscalls.h |   55 +++++++++++++++++++++++++++++
 arch/c6x/include/asm/unistd.h   |   26 ++++++++++++++
 arch/c6x/kernel/sys_c6x.c       |   73 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/syscalls.h
 create mode 100644 arch/c6x/include/asm/unistd.h
 create mode 100644 arch/c6x/kernel/sys_c6x.c

diff --git a/arch/c6x/include/asm/syscalls.h b/arch/c6x/include/asm/syscalls.h
new file mode 100644
index 0000000..aed53da
--- /dev/null
+++ b/arch/c6x/include/asm/syscalls.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __ASM_C6X_SYSCALLS_H
+#define __ASM_C6X_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+/* The array of function pointers for syscalls. */
+extern void *sys_call_table[];
+
+/* The following are trampolines in entry.S to handle 64-bit arguments */
+extern long sys_pread_c6x(unsigned int fd, char __user *buf,
+			  size_t count, off_t pos_low, off_t pos_high);
+extern long sys_pwrite_c6x(unsigned int fd, const char __user *buf,
+			   size_t count, off_t pos_low, off_t pos_high);
+extern long sys_truncate64_c6x(const char __user *path,
+			       off_t length_low, off_t length_high);
+extern long sys_ftruncate64_c6x(unsigned int fd,
+			       off_t length_low, off_t length_high);
+extern long sys_fadvise64_c6x(int fd, u32 offset_lo, u32 offset_hi,
+			      u32 len, int advice);
+extern long sys_fadvise64_64_c6x(int fd, u32 offset_lo, u32 offset_hi,
+				u32 len_lo, u32 len_hi, int advice);
+extern long sys_fallocate_c6x(int fd, int mode,
+			      u32 offset_lo, u32 offset_hi,
+			      u32 len_lo, u32 len_hi);
+extern int sys_cache_sync(unsigned long s, unsigned long e);
+
+struct pt_regs;
+
+extern asmlinkage long sys_c6x_clone(struct pt_regs *regs);
+extern asmlinkage long sys_c6x_execve(const char __user *name,
+				      const char __user *const __user *argv,
+				      const char __user *const __user *envp,
+				      struct pt_regs *regs);
+
+
+#include <asm-generic/syscalls.h>
+
+#endif /* __ASM_C6X_SYSCALLS_H */
diff --git a/arch/c6x/include/asm/unistd.h b/arch/c6x/include/asm/unistd.h
new file mode 100644
index 0000000..6d54ea4
--- /dev/null
+++ b/arch/c6x/include/asm/unistd.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Based on arch/tile version.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.	See the GNU General Public License for
+ *   more details.
+ */
+#if !defined(_ASM_C6X_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_C6X_UNISTD_H
+
+/* Use the standard ABI for syscalls. */
+#include <asm-generic/unistd.h>
+
+/* C6X-specific syscalls. */
+#define __NR_cache_sync	(__NR_arch_specific_syscall + 0)
+__SYSCALL(__NR_cache_sync, sys_cache_sync)
+
+#endif /* _ASM_C6X_UNISTD_H */
diff --git a/arch/c6x/kernel/sys_c6x.c b/arch/c6x/kernel/sys_c6x.c
new file mode 100644
index 0000000..f597d26
--- /dev/null
+++ b/arch/c6x/kernel/sys_c6x.c
@@ -0,0 +1,73 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+#include <asm/syscalls.h>
+
+#ifdef CONFIG_ACCESS_CHECK
+int _access_ok(unsigned long addr, unsigned long size)
+{
+	if (!size)
+		return 1;
+
+	if (!addr || addr > (0xffffffffUL - (size - 1)))
+		goto _bad_access;
+
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return 1;
+
+	if (memory_start <= addr && (addr + size - 1) < memory_end)
+		return 1;
+
+_bad_access:
+	pr_debug("Bad access attempt: pid[%d] addr[%08lx] size[0x%lx]\n",
+		 current->pid, addr, size);
+	return 0;
+}
+EXPORT_SYMBOL(_access_ok);
+#endif
+
+/* sys_cache_sync -- sync caches over given range */
+asmlinkage int sys_cache_sync(unsigned long s, unsigned long e)
+{
+	L1D_cache_block_writeback_invalidate(s, e);
+	L1P_cache_block_invalidate(s, e);
+
+	return 0;
+}
+
+/* Provide the actual syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+/*
+ * Use trampolines
+ */
+#define sys_pread64		sys_pread_c6x
+#define sys_pwrite64		sys_pwrite_c6x
+#define sys_truncate64		sys_truncate64_c6x
+#define sys_ftruncate64		sys_ftruncate64_c6x
+#define sys_fadvise64		sys_fadvise64_c6x
+#define sys_fadvise64_64	sys_fadvise64_64_c6x
+#define sys_fallocate		sys_fallocate_c6x
+
+/* Use sys_mmap_pgoff directly */
+#define sys_mmap2 sys_mmap_pgoff
+
+/*
+ * Note that we can't include <linux/unistd.h> here since the header
+ * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
+ */
+void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
-- 
1.7.6.2

