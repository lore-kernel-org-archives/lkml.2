Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab2GFVHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:07:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34079 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab2GFVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:07:33 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 31/36] AArch64: Miscellaneous library functions
Date: Fri,  6 Jul 2012 22:06:12 +0100
Message-Id: <1341608777-12982-32-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:40.0152 (UTC) FILETIME=[609CE780:01CD5BBB]
X-MC-Unique: 112070622064501401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L8kYp005360

From: Marc Zyngier <marc.zyngier@arm.com>

This patch adds udelay, memory and bit operations together with the
ksyms exports.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/bitops.h  |   75 ++++++++++++++++++++++++++
 arch/aarch64/include/asm/syscall.h |  102 ++++++++++++++++++++++++++++++++++++
 arch/aarch64/kernel/aarch64ksyms.c |   56 ++++++++++++++++++++
 arch/aarch64/lib/Makefile          |    5 ++
 arch/aarch64/lib/bitops.c          |   27 ++++++++++
 arch/aarch64/lib/clear_page.S      |   40 ++++++++++++++
 arch/aarch64/lib/copy_page.S       |   47 ++++++++++++++++
 arch/aarch64/lib/delay.c           |   56 ++++++++++++++++++++
 8 files changed, 408 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/bitops.h
 create mode 100644 arch/aarch64/include/asm/syscall.h
 create mode 100644 arch/aarch64/kernel/aarch64ksyms.c
 create mode 100644 arch/aarch64/lib/Makefile
 create mode 100644 arch/aarch64/lib/bitops.c
 create mode 100644 arch/aarch64/lib/clear_page.S
 create mode 100644 arch/aarch64/lib/copy_page.S
 create mode 100644 arch/aarch64/lib/delay.c

diff --git a/arch/aarch64/include/asm/bitops.h b/arch/aarch64/include/asm/bitops.h
new file mode 100644
index 0000000..e91e23b
--- /dev/null
+++ b/arch/aarch64/include/asm/bitops.h
@@ -0,0 +1,75 @@
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
+#ifndef __ASM_BITOPS_H
+#define __ASM_BITOPS_H
+
+#include <linux/compiler.h>
+
+#include <asm/barrier.h>
+
+/*
+ * clear_bit may not imply a memory barrier
+ */
+#ifndef smp_mb__before_clear_bit
+#define smp_mb__before_clear_bit()	smp_mb()
+#define smp_mb__after_clear_bit()	smp_mb()
+#endif
+
+/*
+ * Use compiler builtins for simple inline operations.
+ */
+static inline unsigned long __ffs(unsigned long word)
+{
+	return __builtin_ffsl(word) - 1;
+}
+
+static inline int ffs(int x)
+{
+	return __builtin_ffs(x);
+}
+
+static inline unsigned long __fls(unsigned long word)
+{
+	return BITS_PER_LONG - 1 - __builtin_clzl(word);
+}
+
+static inline int fls(int x)
+{
+	return x ? sizeof(x) * BITS_PER_BYTE - __builtin_clz(x) : 0;
+}
+
+/*
+ * Mainly use the generic routines for now.
+ */
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <asm-generic/bitops/ffz.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/find.h>
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+#include <asm-generic/bitops/atomic.h>
+#include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* __ASM_BITOPS_H */
diff --git a/arch/aarch64/include/asm/syscall.h b/arch/aarch64/include/asm/syscall.h
new file mode 100644
index 0000000..0f4bfcc
--- /dev/null
+++ b/arch/aarch64/include/asm/syscall.h
@@ -0,0 +1,102 @@
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
+#ifndef __ASM_SYSCALL_H
+#define __ASM_SYSCALL_H
+
+#include <linux/err.h>
+
+
+static inline int syscall_get_nr(struct task_struct *task,
+				 struct pt_regs *regs)
+{
+	return regs->syscallno;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->regs[0] = regs->orig_x0;
+}
+
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	unsigned long error = regs->regs[0];
+	return IS_ERR_VALUE(error) ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->regs[0];
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->regs[0] = (long) error ? error : val;
+}
+
+#define SYSCALL_MAX_ARGS 6
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	if (i + n > SYSCALL_MAX_ARGS) {
+		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
+		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
+		pr_warning("%s called with max args %d, handling only %d\n",
+			   __func__, i + n, SYSCALL_MAX_ARGS);
+		memset(args_bad, 0, n_bad * sizeof(args[0]));
+	}
+
+	if (i == 0) {
+		args[0] = regs->orig_x0;
+		args++;
+		i++;
+		n--;
+	}
+
+	memcpy(args, &regs->regs[i], n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	if (i + n > SYSCALL_MAX_ARGS) {
+		pr_warning("%s called with max args %d, handling only %d\n",
+			   __func__, i + n, SYSCALL_MAX_ARGS);
+		n = SYSCALL_MAX_ARGS - i;
+	}
+
+	if (i == 0) {
+		regs->orig_x0 = args[0];
+		args++;
+		i++;
+		n--;
+	}
+
+	memcpy(&regs->regs[i], args, n * sizeof(args[0]));
+}
+
+#endif	/* __ASM_SYSCALL_H */
diff --git a/arch/aarch64/kernel/aarch64ksyms.c b/arch/aarch64/kernel/aarch64ksyms.c
new file mode 100644
index 0000000..52191ec
--- /dev/null
+++ b/arch/aarch64/kernel/aarch64ksyms.c
@@ -0,0 +1,56 @@
+/*
+ * Based on arch/arm/kernel/armksyms.c
+ *
+ * Copyright (C) 2000 Russell King
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
+
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/cryptohash.h>
+#include <linux/delay.h>
+#include <linux/in6.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <asm/checksum.h>
+
+	/* user mem (segment) */
+EXPORT_SYMBOL(__strnlen_user);
+EXPORT_SYMBOL(__strncpy_from_user);
+
+EXPORT_SYMBOL(copy_page);
+
+EXPORT_SYMBOL(__copy_from_user);
+EXPORT_SYMBOL(__copy_to_user);
+EXPORT_SYMBOL(__clear_user);
+
+EXPORT_SYMBOL(__get_user_1);
+EXPORT_SYMBOL(__get_user_2);
+EXPORT_SYMBOL(__get_user_4);
+
+EXPORT_SYMBOL(__put_user_1);
+EXPORT_SYMBOL(__put_user_2);
+EXPORT_SYMBOL(__put_user_4);
+EXPORT_SYMBOL(__put_user_8);
+
+	/* bitops */
+EXPORT_SYMBOL(__atomic_hash);
+
+	/* physical memory */
+EXPORT_SYMBOL(memstart_addr);
diff --git a/arch/aarch64/lib/Makefile b/arch/aarch64/lib/Makefile
new file mode 100644
index 0000000..ae71bae
--- /dev/null
+++ b/arch/aarch64/lib/Makefile
@@ -0,0 +1,5 @@
+lib-y		:= bitops.o delay.o					\
+		   strncpy_from_user.o strnlen_user.o			\
+		   clear_user.o getuser.o putuser.o			\
+		   copy_from_user.o copy_to_user.o copy_in_user.o	\
+		   copy_page.o clear_page.o
diff --git a/arch/aarch64/lib/bitops.c b/arch/aarch64/lib/bitops.c
new file mode 100644
index 0000000..27a2e17
--- /dev/null
+++ b/arch/aarch64/lib/bitops.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2012 ARM Limited
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
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
+
+#ifdef CONFIG_SMP
+arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
+       [0 ... (ATOMIC_HASH_SIZE-1)]  = __ARCH_SPIN_LOCK_UNLOCKED
+};
+#endif
diff --git a/arch/aarch64/lib/clear_page.S b/arch/aarch64/lib/clear_page.S
new file mode 100644
index 0000000..4965db2
--- /dev/null
+++ b/arch/aarch64/lib/clear_page.S
@@ -0,0 +1,40 @@
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
+
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/assembler.h>
+#include <asm/page.h>
+
+/*
+ * Clear page @dest
+ *
+ * Parameters:
+ *	x0 - dest
+ */
+ENTRY(clear_page)
+	mrs	x1, dczid_el0
+	and	w1, w1, #0xf
+	mov	x2, #4
+	lsl	x1, x2, x1
+
+1:	dc	zva, x0
+	add	x0, x0, x1
+	tst	x0, #(PAGE_SIZE - 1)
+	b.ne	1b
+	ret
+ENDPROC(clear_page)
diff --git a/arch/aarch64/lib/copy_page.S b/arch/aarch64/lib/copy_page.S
new file mode 100644
index 0000000..7269290
--- /dev/null
+++ b/arch/aarch64/lib/copy_page.S
@@ -0,0 +1,47 @@
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
+
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/assembler.h>
+#include <asm/page.h>
+
+/*
+ * Copy a page from src to dest (both are page aligned)
+ *
+ * Parameters:
+ *	x0 - dest
+ *	x1 - src
+ */
+ENTRY(copy_page)
+	/* Assume cache line size is 64 bytes. */
+	prfm	pldl1strm, [x1, #64]
+1:	ldp	x2, x3, [x1]
+	ldp	x4, x5, [x1, #16]
+	ldp	x6, x7, [x1, #32]
+	ldp	x8, x9, [x1, #48]
+	add	x1, x1, #64
+	prfm	pldl1strm, [x1, #64]
+	stnp	x2, x3, [x0]
+	stnp	x4, x5, [x0, #16]
+	stnp	x6, x7, [x0, #32]
+	stnp	x8, x9, [x0, #48]
+	add	x0, x0, #64
+	tst	x1, #(PAGE_SIZE - 1)
+	b.ne	1b
+	ret
+ENDPROC(copy_page)
diff --git a/arch/aarch64/lib/delay.c b/arch/aarch64/lib/delay.c
new file mode 100644
index 0000000..dabe81e
--- /dev/null
+++ b/arch/aarch64/lib/delay.c
@@ -0,0 +1,56 @@
+/*
+ * Delay loops based on the OpenRISC implementation.
+ *
+ * Copyright (C) 2012 ARM Limited
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
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timex.h>
+
+void __delay(unsigned long cycles)
+{
+	cycles_t start = get_cycles();
+
+	while ((get_cycles() - start) < cycles)
+		cpu_relax();
+}
+EXPORT_SYMBOL(__delay);
+
+inline void __const_udelay(unsigned long xloops)
+{
+	unsigned long loops;
+
+	loops = xloops * loops_per_jiffy * HZ;
+	__delay(loops >> 32);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x10C7UL); /* 2**32 / 1000000 (rounded up) */
+}
+EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);

