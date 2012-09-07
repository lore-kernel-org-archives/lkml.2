Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2IGQcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:32:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34552 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2IGQ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:57 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 20/31] arm64: User access library functions
Date: Fri,  7 Sep 2012 17:26:55 +0100
Message-Id: <1347035226-18649-21-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:55.0097 (UTC) FILETIME=[BBF70490:01CD8D15]
X-MC-Unique: 112090717275503701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GWqGk008411

This patch add support for various user access functions. These
functions use the standard LDR/STR instructions and not the LDRT/STRT
variants in order to allow kernel addresses (after set_fs(KERNEL_DS)).

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/uaccess.h   |  297 ++++++++++++++++++++++++++++++++++++
 arch/arm64/lib/clear_user.S        |   58 +++++++
 arch/arm64/lib/copy_from_user.S    |   66 ++++++++
 arch/arm64/lib/copy_in_user.S      |   63 ++++++++
 arch/arm64/lib/copy_to_user.S      |   61 ++++++++
 arch/arm64/lib/strncpy_from_user.S |   50 ++++++
 arch/arm64/lib/strnlen_user.S      |   47 ++++++
 7 files changed, 642 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/uaccess.h
 create mode 100644 arch/arm64/lib/clear_user.S
 create mode 100644 arch/arm64/lib/copy_from_user.S
 create mode 100644 arch/arm64/lib/copy_in_user.S
 create mode 100644 arch/arm64/lib/copy_to_user.S
 create mode 100644 arch/arm64/lib/strncpy_from_user.S
 create mode 100644 arch/arm64/lib/strnlen_user.S

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
new file mode 100644
index 0000000..008f848
--- /dev/null
+++ b/arch/arm64/include/asm/uaccess.h
@@ -0,0 +1,297 @@
+/*
+ * Based on arch/arm/include/asm/uaccess.h
+ *
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_UACCESS_H
+#define __ASM_UACCESS_H
+
+/*
+ * User space memory access functions
+ */
+#include <linux/string.h>
+#include <linux/thread_info.h>
+
+#include <asm/ptrace.h>
+#include <asm/errno.h>
+#include <asm/memory.h>
+#include <asm/compiler.h>
+
+#define VERIFY_READ 0
+#define VERIFY_WRITE 1
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry
+{
+	unsigned long insn, fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+#define KERNEL_DS	(-1UL)
+#define get_ds()	(KERNEL_DS)
+
+#define USER_DS		TASK_SIZE_64
+#define get_fs()	(current_thread_info()->addr_limit)
+
+static inline void set_fs(mm_segment_t fs)
+{
+	current_thread_info()->addr_limit = fs;
+}
+
+#define segment_eq(a,b)	((a) == (b))
+
+/*
+ * Return 1 if addr < current->addr_limit, 0 otherwise.
+ */
+#define __addr_ok(addr)							\
+({									\
+	unsigned long flag;						\
+	asm("cmp %1, %0; cset %0, lo"					\
+		: "=&r" (flag)						\
+		: "r" (addr), "0" (current_thread_info()->addr_limit)	\
+		: "cc");						\
+	flag;								\
+})
+
+/*
+ * Test whether a block of memory is a valid user space address.
+ * Returns 1 if the range is valid, 0 otherwise.
+ *
+ * This is equivalent to the following test:
+ * (u65)addr + (u65)size < (u65)current->addr_limit
+ *
+ * This needs 65-bit arithmetic.
+ */
+#define __range_ok(addr, size)						\
+({									\
+	unsigned long flag, roksum;					\
+	__chk_user_ptr(addr);						\
+	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, cc"		\
+		: "=&r" (flag), "=&r" (roksum)				\
+		: "1" (addr), "Ir" (size),				\
+		  "r" (current_thread_info()->addr_limit)		\
+		: "cc");						\
+	flag;								\
+})
+
+#define access_ok(type, addr, size)	__range_ok(addr, size)
+
+/*
+ * The "__xxx" versions of the user access functions do not verify the address
+ * space - it must have been done previously with a separate "access_ok()"
+ * call.
+ *
+ * The "__xxx_error" versions set the third argument to -EFAULT if an error
+ * occurs, and leave it unchanged on success.
+ */
+#define __get_user_asm(instr, reg, x, addr, err)			\
+	asm volatile(							\
+	"1:	" instr "	" reg "1, [%2]\n"			\
+	"2:\n"								\
+	"	.section .fixup, \"ax\"\n"				\
+	"	.align	2\n"						\
+	"3:	mov	%w0, %3\n"					\
+	"	mov	%1, #0\n"					\
+	"	b	2b\n"						\
+	"	.previous\n"						\
+	"	.section __ex_table,\"a\"\n"				\
+	"	.align	3\n"						\
+	"	.quad	1b, 3b\n"					\
+	"	.previous"						\
+	: "+r" (err), "=&r" (x)						\
+	: "r" (addr), "i" (-EFAULT))
+
+#define __get_user_err(x, ptr, err)					\
+do {									\
+	unsigned long __gu_val;						\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__get_user_asm("ldrb", "%w", __gu_val, (ptr), (err));	\
+		break;							\
+	case 2:								\
+		__get_user_asm("ldrh", "%w", __gu_val, (ptr), (err));	\
+		break;							\
+	case 4:								\
+		__get_user_asm("ldr", "%w", __gu_val, (ptr), (err));	\
+		break;							\
+	case 8:								\
+		__get_user_asm("ldr", "%",  __gu_val, (ptr), (err));	\
+		break;							\
+	default:							\
+		BUILD_BUG();						\
+	}								\
+	(x) = (__typeof__(*(ptr)))__gu_val;				\
+} while (0)
+
+#define __get_user(x, ptr)						\
+({									\
+	int __gu_err = 0;						\
+	__get_user_err((x), (ptr), __gu_err);				\
+	__gu_err;							\
+})
+
+#define __get_user_error(x, ptr, err)					\
+({									\
+	__get_user_err((x), (ptr), (err));				\
+	(void)0;							\
+})
+
+#define __get_user_unaligned __get_user
+
+#define get_user(x, ptr)						\
+({									\
+	might_sleep();							\
+	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr))) ?			\
+		__get_user((x), (ptr)) :				\
+		((x) = 0, -EFAULT);					\
+})
+
+#define __put_user_asm(instr, reg, x, addr, err)			\
+	asm volatile(							\
+	"1:	" instr "	" reg "1, [%2]\n"			\
+	"2:\n"								\
+	"	.section .fixup,\"ax\"\n"				\
+	"	.align	2\n"						\
+	"3:	mov	%w0, %3\n"					\
+	"	b	2b\n"						\
+	"	.previous\n"						\
+	"	.section __ex_table,\"a\"\n"				\
+	"	.align	3\n"						\
+	"	.quad	1b, 3b\n"					\
+	"	.previous"						\
+	: "+r" (err)							\
+	: "r" (x), "r" (addr), "i" (-EFAULT))
+
+#define __put_user_err(x, ptr, err)					\
+do {									\
+	__typeof__(*(ptr)) __pu_val = (x);				\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__put_user_asm("strb", "%w", __pu_val, (ptr), (err));	\
+		break;							\
+	case 2:								\
+		__put_user_asm("strh", "%w", __pu_val, (ptr), (err));	\
+		break;							\
+	case 4:								\
+		__put_user_asm("str",  "%w", __pu_val, (ptr), (err));	\
+		break;							\
+	case 8:								\
+		__put_user_asm("str",  "%", __pu_val, (ptr), (err));	\
+		break;							\
+	default:							\
+		BUILD_BUG();						\
+	}								\
+} while (0)
+
+#define __put_user(x, ptr)						\
+({									\
+	int __pu_err = 0;						\
+	__put_user_err((x), (ptr), __pu_err);				\
+	__pu_err;							\
+})
+
+#define __put_user_error(x, ptr, err)					\
+({									\
+	__put_user_err((x), (ptr), (err));				\
+	(void)0;							\
+})
+
+#define __put_user_unaligned __put_user
+
+#define put_user(x, ptr)						\
+({									\
+	might_sleep();							\
+	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr))) ?		\
+		__put_user((x), (ptr)) :				\
+		-EFAULT;						\
+})
+
+extern unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n);
+extern unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n);
+extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
+extern unsigned long __must_check __clear_user(void __user *addr, unsigned long n);
+
+extern unsigned long __must_check __strncpy_from_user(char *to, const char __user *from, unsigned long count);
+extern unsigned long __must_check __strnlen_user(const char __user *s, long n);
+
+static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		n = __copy_from_user(to, from, n);
+	else /* security hole - plug it */
+		memset(to, 0, n);
+	return n;
+}
+
+static inline unsigned long __must_check copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __copy_to_user(to, from, n);
+	return n;
+}
+
+static inline unsigned long __must_check copy_in_user(void __user *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n) && access_ok(VERIFY_WRITE, to, n))
+		n = __copy_in_user(to, from, n);
+	return n;
+}
+
+#define __copy_to_user_inatomic __copy_to_user
+#define __copy_from_user_inatomic __copy_from_user
+
+static inline unsigned long __must_check clear_user(void __user *to, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __clear_user(to, n);
+	return n;
+}
+
+static inline long __must_check strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		res = __strncpy_from_user(dst, src, count);
+	return res;
+}
+
+#define strlen_user(s)	strnlen_user(s, ~0UL >> 1)
+
+static inline long __must_check strnlen_user(const char __user *s, long n)
+{
+	unsigned long res = 0;
+
+	if (__addr_ok(s))
+		res = __strnlen_user(s, n);
+
+	return res;
+}
+
+#endif /* __ASM_UACCESS_H */
diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
new file mode 100644
index 0000000..6e0ed93
--- /dev/null
+++ b/arch/arm64/lib/clear_user.S
@@ -0,0 +1,58 @@
+/*
+ * Based on arch/arm/lib/clear_user.S
+ *
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	.text
+
+/* Prototype: int __clear_user(void *addr, size_t sz)
+ * Purpose  : clear some user memory
+ * Params   : addr - user memory address to clear
+ *          : sz   - number of bytes to clear
+ * Returns  : number of bytes NOT cleared
+ *
+ * Alignment fixed up by hardware.
+ */
+ENTRY(__clear_user)
+	mov	x2, x1			// save the size for fixup return
+	subs	x1, x1, #8
+	b.mi	2f
+1:
+USER(9f, str	xzr, [x0], #8	)
+	subs	x1, x1, #8
+	b.pl	1b
+2:	adds	x1, x1, #4
+	b.mi	3f
+USER(9f, str	wzr, [x0], #4	)
+	sub	x1, x1, #4
+3:	adds	x1, x1, #2
+	b.mi	4f
+USER(9f, strh	wzr, [x0], #2	)
+	sub	x1, x1, #2
+4:	adds	x1, x1, #1
+	b.mi	5f
+	strb	wzr, [x0]
+5:	mov	x0, #0
+	ret
+ENDPROC(__clear_user)
+
+	.section .fixup,"ax"
+	.align	2
+9:	mov	x0, x2			// return the original size
+	ret
+	.previous
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
new file mode 100644
index 0000000..5e27add
--- /dev/null
+++ b/arch/arm64/lib/copy_from_user.S
@@ -0,0 +1,66 @@
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Copy from user space to a kernel buffer (alignment handled by the hardware)
+ *
+ * Parameters:
+ *	x0 - to
+ *	x1 - from
+ *	x2 - n
+ * Returns:
+ *	x0 - bytes not copied
+ */
+ENTRY(__copy_from_user)
+	add	x4, x1, x2			// upper user buffer boundary
+	subs	x2, x2, #8
+	b.mi	2f
+1:
+USER(9f, ldr	x3, [x1], #8	)
+	subs	x2, x2, #8
+	str	x3, [x0], #8
+	b.pl	1b
+2:	adds	x2, x2, #4
+	b.mi	3f
+USER(9f, ldr	w3, [x1], #4	)
+	sub	x2, x2, #4
+	str	w3, [x0], #4
+3:	adds	x2, x2, #2
+	b.mi	4f
+USER(9f, ldrh	w3, [x1], #2	)
+	sub	x2, x2, #2
+	strh	w3, [x0], #2
+4:	adds	x2, x2, #1
+	b.mi	5f
+USER(9f, ldrb	w3, [x1]	)
+	strb	w3, [x0]
+5:	mov	x0, #0
+	ret
+ENDPROC(__copy_from_user)
+
+	.section .fixup,"ax"
+	.align	2
+9:	sub	x2, x4, x1
+	mov	x3, x2
+10:	strb	wzr, [x0], #1			// zero remaining buffer space
+	subs	x3, x3, #1
+	b.ne	10b
+	mov	x0, x2				// bytes not copied
+	ret
+	.previous
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
new file mode 100644
index 0000000..84b6c9b
--- /dev/null
+++ b/arch/arm64/lib/copy_in_user.S
@@ -0,0 +1,63 @@
+/*
+ * Copy from user space to user space
+ *
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Copy from user space to user space (alignment handled by the hardware)
+ *
+ * Parameters:
+ *	x0 - to
+ *	x1 - from
+ *	x2 - n
+ * Returns:
+ *	x0 - bytes not copied
+ */
+ENTRY(__copy_in_user)
+	add	x4, x0, x2			// upper user buffer boundary
+	subs	x2, x2, #8
+	b.mi	2f
+1:
+USER(9f, ldr	x3, [x1], #8	)
+	subs	x2, x2, #8
+USER(9f, str	x3, [x0], #8	)
+	b.pl	1b
+2:	adds	x2, x2, #4
+	b.mi	3f
+USER(9f, ldr	w3, [x1], #4	)
+	sub	x2, x2, #4
+USER(9f, str	w3, [x0], #4	)
+3:	adds	x2, x2, #2
+	b.mi	4f
+USER(9f, ldrh	w3, [x1], #2	)
+	sub	x2, x2, #2
+USER(9f, strh	w3, [x0], #2	)
+4:	adds	x2, x2, #1
+	b.mi	5f
+USER(9f, ldrb	w3, [x1]	)
+USER(9f, strb	w3, [x0]	)
+5:	mov	x0, #0
+	ret
+ENDPROC(__copy_in_user)
+
+	.section .fixup,"ax"
+	.align	2
+9:	sub	x0, x4, x0			// bytes not copied
+	ret
+	.previous
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
new file mode 100644
index 0000000..a0aeeb9
--- /dev/null
+++ b/arch/arm64/lib/copy_to_user.S
@@ -0,0 +1,61 @@
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Copy to user space from a kernel buffer (alignment handled by the hardware)
+ *
+ * Parameters:
+ *	x0 - to
+ *	x1 - from
+ *	x2 - n
+ * Returns:
+ *	x0 - bytes not copied
+ */
+ENTRY(__copy_to_user)
+	add	x4, x0, x2			// upper user buffer boundary
+	subs	x2, x2, #8
+	b.mi	2f
+1:
+	ldr	x3, [x1], #8
+	subs	x2, x2, #8
+USER(9f, str	x3, [x0], #8	)
+	b.pl	1b
+2:	adds	x2, x2, #4
+	b.mi	3f
+	ldr	w3, [x1], #4
+	sub	x2, x2, #4
+USER(9f, str	w3, [x0], #4	)
+3:	adds	x2, x2, #2
+	b.mi	4f
+	ldrh	w3, [x1], #2
+	sub	x2, x2, #2
+USER(9f, strh	w3, [x0], #2	)
+4:	adds	x2, x2, #1
+	b.mi	5f
+	ldrb	w3, [x1]
+USER(9f, strb	w3, [x0]	)
+5:	mov	x0, #0
+	ret
+ENDPROC(__copy_to_user)
+
+	.section .fixup,"ax"
+	.align	2
+9:	sub	x0, x4, x0			// bytes not copied
+	ret
+	.previous
diff --git a/arch/arm64/lib/strncpy_from_user.S b/arch/arm64/lib/strncpy_from_user.S
new file mode 100644
index 0000000..56e448a
--- /dev/null
+++ b/arch/arm64/lib/strncpy_from_user.S
@@ -0,0 +1,50 @@
+/*
+ * Based on arch/arm/lib/strncpy_from_user.S
+ *
+ * Copyright (C) 1995-2000 Russell King
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/errno.h>
+
+	.text
+	.align	5
+
+/*
+ * Copy a string from user space to kernel space.
+ *  x0 = dst, x1 = src, x2 = byte length
+ * returns the number of characters copied (strlen of copied string),
+ *  -EFAULT on exception, or "len" if we fill the whole buffer
+ */
+ENTRY(__strncpy_from_user)
+	mov	x4, x1
+1:	subs	x2, x2, #1
+	bmi	2f
+USER(9f, ldrb	w3, [x1], #1	)
+	strb	w3, [x0], #1
+	cbnz	w3, 1b
+	sub	x1, x1, #1	// take NUL character out of count
+2:	sub	x0, x1, x4
+	ret
+ENDPROC(__strncpy_from_user)
+
+	.section .fixup,"ax"
+	.align	0
+9:	strb	wzr, [x0]	// null terminate
+	mov	x0, #-EFAULT
+	ret
+	.previous
diff --git a/arch/arm64/lib/strnlen_user.S b/arch/arm64/lib/strnlen_user.S
new file mode 100644
index 0000000..7f7b176
--- /dev/null
+++ b/arch/arm64/lib/strnlen_user.S
@@ -0,0 +1,47 @@
+/*
+ * Based on arch/arm/lib/strnlen_user.S
+ *
+ * Copyright (C) 1995-2000 Russell King
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/errno.h>
+
+	.text
+	.align	5
+
+/* Prototype: unsigned long __strnlen_user(const char *str, long n)
+ * Purpose  : get length of a string in user memory
+ * Params   : str - address of string in user memory
+ * Returns  : length of string *including terminator*
+ *	      or zero on exception, or n if too long
+ */
+ENTRY(__strnlen_user)
+	mov	x2, x0
+1:	subs	x1, x1, #1
+	b.mi	2f
+USER(9f, ldrb	w3, [x0], #1	)
+	cbnz	w3, 1b
+2:	sub	x0, x0, x2
+	ret
+ENDPROC(__strnlen_user)
+
+	.section .fixup,"ax"
+	.align	0
+9:	mov	x0, #0
+	ret
+	.previous

