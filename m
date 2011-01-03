Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1ACLxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:53:23 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:48694 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1ACLxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:53:20 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 6/8] unicore32 additional architecture files: low-level lib: uaccess
Date: Mon, 3 Jan 2011 19:53:19 +0800
Message-ID: <012f01cbab3c$d0962780$71c27680$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurPMCqLRtHG5S+Q/aP8rtHqiexLQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 6 implements low-level uaccess libraries. And using asm-generic version uaccess.h
is in my hot TODO list.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/uaccess.h   |  429 ++++++++++++++++++++++++++++++++
 arch/unicore32/lib/clear_user.S        |   59 +++++
 arch/unicore32/lib/copy_from_user.S    |  107 ++++++++
 arch/unicore32/lib/copy_page.S         |   39 +++
 arch/unicore32/lib/copy_template.S     |  214 ++++++++++++++++
 arch/unicore32/lib/copy_to_user.S      |   97 +++++++
 arch/unicore32/lib/getuser.S           |   65 +++++
 arch/unicore32/lib/putuser.S           |   73 ++++++
 arch/unicore32/lib/strncpy_from_user.S |   45 ++++
 arch/unicore32/lib/strnlen_user.S      |   42 +++
 10 files changed, 1170 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/uaccess.h b/arch/unicore32/include/asm/uaccess.h
new file mode 100644
index 0000000..9f03b7d
--- /dev/null
+++ b/arch/unicore32/include/asm/uaccess.h
@@ -0,0 +1,429 @@
+/*
+ * linux/arch/unicore32/include/asm/uaccess.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_UACCESS_H__
+#define __UNICORE_UACCESS_H__
+
+/*
+ * User space memory access functions
+ */
+#include <linux/string.h>
+#include <linux/thread_info.h>
+#include <linux/errno.h>
+
+#include <asm/memory.h>
+#include <asm/system.h>
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
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+/*
+ * These two are intentionally not defined anywhere - if the kernel
+ * code generates any references to them, that's a bug.
+ */
+extern int __get_user_bad(void);
+extern int __put_user_bad(void);
+
+/*
+ * Note that this is actually 0x1,0000,0000
+ */
+#define KERNEL_DS	0x00000000
+#define get_ds()	(KERNEL_DS)
+
+#define USER_DS		TASK_SIZE
+#define get_fs()	(current_thread_info()->addr_limit)
+
+static inline void set_fs(mm_segment_t fs)
+{
+	current_thread_info()->addr_limit = fs;
+}
+
+#define segment_eq(a, b)	((a) == (b))
+
+#define __addr_ok(addr) ({ \
+	unsigned long flag; \
+	__asm__("cmpsub.a %2, %0; cmovub %0, #0" \
+		: "=&r" (flag) \
+		: "0" (current_thread_info()->addr_limit), "r" (addr) \
+		: "cc"); \
+	(flag == 0); })
+
+/* We use 33-bit arithmetic here... */
+#define __range_ok(addr, size) ({		\
+	unsigned long flag, roksum;		\
+	__chk_user_ptr(addr);			\
+	__asm__("add.a %1, %2, %3;\n"		\
+		"bea 1f;\n"			\
+		"subc.a %1, %1, %0;\n"		\
+		"1: cmovub %0, #0"		\
+		: "=&r" (flag), "=&r" (roksum)	\
+		: "r" (addr), "Ir" (size),	\
+		  "0" (current_thread_info()->addr_limit) \
+		: "cc"); \
+	flag; })
+
+/*
+ * Single-value transfer routines.  They automatically use the right
+ * size if we just have the right pointer type.  Note that the functions
+ * which read from user space (*get_*) need to take care not to leak
+ * kernel data even if the calling code is buggy and fails to check
+ * the return value.  This means zeroing out the destination variable
+ * or buffer on error.  Normally this is done out of line by the
+ * fixup code, but there are a few places where it intrudes on the
+ * main code path.  When we only write to user space, there is no
+ * problem.
+ */
+extern int __get_user_1(void *);
+extern int __get_user_2(void *);
+extern int __get_user_4(void *);
+
+#define __get_user_x(__r2, __p, __e, __s, __i...)			\
+	   __asm__ __volatile__ (					\
+		"b.l	__get_user_" #__s				\
+		: "=&r" (__e), "=r" (__r2)				\
+		: "0" (__p)						\
+		: __i, "cc")
+
+#define get_user(x, p)							\
+	({								\
+		register const typeof(*(p)) __user *__p asm("r0") = (p);\
+		register unsigned long __r2 asm("r2");			\
+		register int __e asm("r0");				\
+		switch (sizeof(*(__p))) {				\
+		case 1:							\
+			__get_user_x(__r2, __p, __e, 1, "lr");		\
+			break;						\
+		case 2:							\
+			__get_user_x(__r2, __p, __e, 2, "r3", "lr");	\
+			break;						\
+		case 4:							\
+			__get_user_x(__r2, __p, __e, 4, "lr");		\
+			break;						\
+		default:						\
+			__e = __get_user_bad();				\
+			break;						\
+		}							\
+		x = (typeof(*(p))) __r2;				\
+		__e;							\
+	})
+
+extern int __put_user_1(void *, unsigned int);
+extern int __put_user_2(void *, unsigned int);
+extern int __put_user_4(void *, unsigned int);
+extern int __put_user_8(void *, unsigned long long);
+
+#define __put_user_x(__r2, __p, __e, __s)				\
+	   __asm__ __volatile__ (					\
+		"b.l	__put_user_" #__s				\
+		: "=&r" (__e)						\
+		: "0" (__p), "r" (__r2)					\
+		: "ip", "lr", "cc")
+
+#define put_user(x, p)							\
+	({								\
+		register const typeof(*(p)) __r2 asm("r2") = (x);	\
+		register const typeof(*(p)) __user *__p asm("r0") = (p);\
+		register int __e asm("r0");				\
+		switch (sizeof(*(__p))) {				\
+		case 1:							\
+			__put_user_x(__r2, __p, __e, 1);		\
+			break;						\
+		case 2:							\
+			__put_user_x(__r2, __p, __e, 2);		\
+			break;						\
+		case 4:							\
+			__put_user_x(__r2, __p, __e, 4);		\
+			break;						\
+		case 8:							\
+			__put_user_x(__r2, __p, __e, 8);		\
+			break;						\
+		default:						\
+			__e = __put_user_bad();				\
+			break;						\
+		}							\
+		__e;							\
+	})
+
+#define access_ok(type, addr, size)	(__range_ok(addr, size) == 0)
+
+/*
+ * The "__xxx" versions of the user access functions do not verify the
+ * address space - it must have been done previously with a separate
+ * "access_ok()" call.
+ *
+ * The "xxx_error" versions set the third argument to EFAULT if an
+ * error occurs, and leave it unchanged on success.  Note that these
+ * versions are void (ie, don't return a value as such).
+ */
+#define __get_user(x, ptr)						\
+({									\
+	long __gu_err = 0;						\
+	__get_user_err((x), (ptr), __gu_err);				\
+	__gu_err;							\
+})
+
+#define __get_user_error(x, ptr, err)					\
+({									\
+	__get_user_err((x), (ptr), err);				\
+	(void) 0;							\
+})
+
+#define __get_user_err(x, ptr, err)					\
+do {									\
+	unsigned long __gu_addr = (unsigned long)(ptr);			\
+	unsigned long __gu_val;						\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__get_user_asm_byte(__gu_val, __gu_addr, err);		\
+		break;							\
+	case 2:								\
+		__get_user_asm_half(__gu_val, __gu_addr, err);		\
+		break;							\
+	case 4:								\
+		__get_user_asm_word(__gu_val, __gu_addr, err);		\
+		break;							\
+	default:							\
+		(__gu_val) = __get_user_bad();				\
+	}								\
+	(x) = (__typeof__(*(ptr)))__gu_val;				\
+} while (0)
+
+#define __get_user_asm_byte(x, addr, err)				\
+	__asm__ __volatile__(						\
+	"1:	ldb.u	%1,[%2]\n"					\
+	"2:\n"								\
+	"	.pushsection .fixup,\"ax\"\n"				\
+	"	.align	2\n"						\
+	"3:	mov	%0, %3\n"					\
+	"	mov	%1, #0\n"					\
+	"	b	2b\n"						\
+	"	.popsection\n"						\
+	"	.pushsection __ex_table,\"a\"\n"			\
+	"	.align	3\n"						\
+	"	.long	1b, 3b\n"					\
+	"	.popsection"						\
+	: "+r" (err), "=&r" (x)						\
+	: "r" (addr), "i" (-EFAULT)					\
+	: "cc")
+
+#define __get_user_asm_half(x, __gu_addr, err)				\
+({									\
+	unsigned long __b1, __b2;					\
+	__get_user_asm_byte(__b1, __gu_addr, err);			\
+	__get_user_asm_byte(__b2, __gu_addr + 1, err);			\
+	(x) = __b1 | (__b2 << 8);					\
+})
+
+#define __get_user_asm_word(x, addr, err)				\
+	__asm__ __volatile__(						\
+	"1:	ldw.u	%1,[%2]\n"					\
+	"2:\n"								\
+	"	.pushsection .fixup,\"ax\"\n"				\
+	"	.align	2\n"						\
+	"3:	mov	%0, %3\n"					\
+	"	mov	%1, #0\n"					\
+	"	b	2b\n"						\
+	"	.popsection\n"						\
+	"	.pushsection __ex_table,\"a\"\n"			\
+	"	.align	3\n"						\
+	"	.long	1b, 3b\n"					\
+	"	.popsection"						\
+	: "+r" (err), "=&r" (x)						\
+	: "r" (addr), "i" (-EFAULT)					\
+	: "cc")
+
+#define __put_user(x, ptr)						\
+({									\
+	long __pu_err = 0;						\
+	__put_user_err((x), (ptr), __pu_err);				\
+	__pu_err;							\
+})
+
+#define __put_user_error(x, ptr, err)					\
+({									\
+	__put_user_err((x), (ptr), err);				\
+	(void) 0;							\
+})
+
+#define __put_user_err(x, ptr, err)					\
+do {									\
+	unsigned long __pu_addr = (unsigned long)(ptr);			\
+	__typeof__(*(ptr)) __pu_val = (x);				\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__put_user_asm_byte(__pu_val, __pu_addr, err);		\
+		break;							\
+	case 2:								\
+		__put_user_asm_half(__pu_val, __pu_addr, err);		\
+		break;							\
+	case 4:								\
+		__put_user_asm_word(__pu_val, __pu_addr, err);		\
+		break;							\
+	case 8:								\
+		__put_user_asm_dword(__pu_val, __pu_addr, err);		\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
+#define __put_user_asm_byte(x, __pu_addr, err)			\
+	__asm__ __volatile__(					\
+	"1:	stb.u	%1,[%2]\n"				\
+	"2:\n"							\
+	"	.pushsection .fixup,\"ax\"\n"			\
+	"	.align	2\n"					\
+	"3:	mov	%0, %3\n"				\
+	"	b	2b\n"					\
+	"	.popsection\n"					\
+	"	.pushsection __ex_table,\"a\"\n"			\
+	"	.align	3\n"					\
+	"	.long	1b, 3b\n"				\
+	"	.popsection"					\
+	: "+r" (err)						\
+	: "r" (x), "r" (__pu_addr), "i" (-EFAULT)		\
+	: "cc")
+
+#define __put_user_asm_half(x, __pu_addr, err)			\
+({								\
+	unsigned long __temp = (unsigned long)(x);		\
+	__put_user_asm_byte(__temp, __pu_addr, err);		\
+	__put_user_asm_byte(__temp >> 8, __pu_addr + 1, err);	\
+})
+
+#define __put_user_asm_word(x, __pu_addr, err)			\
+	__asm__ __volatile__(					\
+	"1:	stw.u	%1,[%2]\n"				\
+	"2:\n"							\
+	"	.pushsection .fixup,\"ax\"\n"			\
+	"	.align	2\n"					\
+	"3:	mov	%0, %3\n"				\
+	"	b	2b\n"					\
+	"	.popsection\n"					\
+	"	.pushsection __ex_table,\"a\"\n"			\
+	"	.align	3\n"					\
+	"	.long	1b, 3b\n"				\
+	"	.popsection"					\
+	: "+r" (err)						\
+	: "r" (x), "r" (__pu_addr), "i" (-EFAULT)		\
+	: "cc")
+
+#define	__reg_oper0	"%R2"
+#define	__reg_oper1	"%Q2"
+
+#define __put_user_asm_dword(x, __pu_addr, err)			\
+	__asm__ __volatile__(					\
+	"1:	stw.u	" __reg_oper1 ", [%1], #4\n"		\
+	"2:	stw.u	" __reg_oper0 ", [%1]\n"		\
+	"3:\n"							\
+	"	.pushsection .fixup,\"ax\"\n"			\
+	"	.align	2\n"					\
+	"4:	mov	%0, %3\n"				\
+	"	b	3b\n"					\
+	"	.popsection\n"					\
+	"	.pushsection __ex_table,\"a\"\n"			\
+	"	.align	3\n"					\
+	"	.long	1b, 4b\n"				\
+	"	.long	2b, 4b\n"				\
+	"	.popsection"					\
+	: "+r" (err), "+r" (__pu_addr)				\
+	: "r" (x), "i" (-EFAULT)				\
+	: "cc")
+
+
+extern unsigned long __must_check
+__copy_from_user(void *to, const void __user *from, unsigned long n);
+extern unsigned long __must_check
+__copy_to_user(void __user *to, const void *from, unsigned long n);
+extern unsigned long __must_check
+__copy_to_user_std(void __user *to, const void *from, unsigned long n);
+extern unsigned long __must_check
+__clear_user(void __user *addr, unsigned long n);
+extern unsigned long __must_check
+__clear_user_std(void __user *addr, unsigned long n);
+extern unsigned long __must_check
+__strncpy_from_user(char *to, const char __user *from, unsigned long count);
+extern unsigned long __must_check
+__strnlen_user(const char __user *s, long n);
+
+static inline unsigned long __must_check
+copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		n = __copy_from_user(to, from, n);
+	else /* security hole - plug it */
+		memset(to, 0, n);
+	return n;
+}
+
+static inline unsigned long __must_check
+copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __copy_to_user(to, from, n);
+	return n;
+}
+
+#define __copy_to_user_inatomic __copy_to_user
+#define __copy_from_user_inatomic __copy_from_user
+
+static inline unsigned long __must_check
+clear_user(void __user *to, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __clear_user(to, n);
+	return n;
+}
+
+static inline long __must_check
+strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		res = __strncpy_from_user(dst, src, count);
+	return res;
+}
+
+#define strlen_user(s)	strnlen_user(s, ~0UL >> 1)
+
+static inline long __must_check
+strnlen_user(const char __user *s, long n)
+{
+	unsigned long res = 0;
+
+	if (__addr_ok(s))
+		res = __strnlen_user(s, n);
+
+	return res;
+}
+
+#endif /* __UNICORE_UACCESS_H__ */
diff --git a/arch/unicore32/lib/clear_user.S b/arch/unicore32/lib/clear_user.S
new file mode 100644
index 0000000..a47137d
--- /dev/null
+++ b/arch/unicore32/lib/clear_user.S
@@ -0,0 +1,59 @@
+/*
+ * linux/arch/unicore32/lib/clear_user.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+		.text
+
+/* Prototype: int __clear_user(void *addr, size_t sz)
+ * Purpose  : clear some user memory
+ * Params   : addr - user memory address to clear
+ *          : sz   - number of bytes to clear
+ * Returns  : number of bytes NOT cleared
+ */
+ENTRY(__clear_user_std)
+WEAK(__clear_user)
+		stm.w	(lr), [sp-]
+		stm.w	(r1), [sp-]
+		mov	r2, #0
+		csub.a	r1, #4
+		bsl	2f
+		and.a	ip, r0, #3
+		beq	1f
+		csub.a	ip, #2
+		strusr	r2, r0, 1
+		strusr	r2, r0, 1, el
+		strusr	r2, r0, 1, sl
+		rsub	ip, ip, #4
+		sub	r1, r1, ip		@  7  6  5  4  3  2  1
+1:		sub.a	r1, r1, #8		@ -1 -2 -3 -4 -5 -6 -7
+		strusr	r2, r0, 4, ns, rept=2
+		bns	1b
+		add.a	r1, r1, #4		@  3  2  1  0 -1 -2 -3
+		strusr	r2, r0, 4, ns
+2:		cand.a	r1, #2			@ 1x 1x 0x 0x 1x 1x 0x
+		strusr	r2, r0, 1, ne, rept=2
+		cand.a	r1, #1			@ x1 x0 x1 x0 x1 x0 x1
+		beq	3f
+USER(		stb.u	r2, [r0])
+3:		mov	r0, #0
+		ldm.w	(r1), [sp]+
+		ldm.w	(pc), [sp]+
+ENDPROC(__clear_user)
+ENDPROC(__clear_user_std)
+
+		.pushsection .fixup,"ax"
+		.align	0
+9001:		ldm.w	(r0), [sp]+
+		ldm.w	(pc), [sp]+
+		.popsection
+
diff --git a/arch/unicore32/lib/copy_from_user.S b/arch/unicore32/lib/copy_from_user.S
new file mode 100644
index 0000000..37a8842
--- /dev/null
+++ b/arch/unicore32/lib/copy_from_user.S
@@ -0,0 +1,107 @@
+/*
+ * linux/arch/unicore32/lib/copy_from_user.S
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
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Prototype:
+ *
+ *	size_t __copy_from_user(void *to, const void *from, size_t n)
+ *
+ * Purpose:
+ *
+ *	copy a block to kernel memory from user memory
+ *
+ * Params:
+ *
+ *	to = kernel memory
+ *	from = user memory
+ *	n = number of bytes to copy
+ *
+ * Return value:
+ *
+ *	Number of bytes NOT copied.
+ */
+
+	.macro ldr1w ptr reg abort
+	ldrusr	\reg, \ptr, 4, abort=\abort
+	.endm
+
+	.macro ldr4w ptr reg1 reg2 reg3 reg4 abort
+100:	ldm.w	(\reg1, \reg2, \reg3, \reg4), [\ptr]+
+	.pushsection __ex_table, "a"
+	.align	3
+	.long 100b, \abort
+	.popsection
+	.endm
+
+	.macro ldr8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+100:	ldm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+	.pushsection __ex_table, "a"
+	.align	3
+	.long 100b, \abort
+	.popsection
+	.endm
+
+	.macro ldr1b ptr reg cond=al abort
+	ldrusr	\reg, \ptr, 1, \cond, abort=\abort
+	.endm
+
+	.macro str1w ptr reg abort
+	stw.w \reg, [\ptr]+, #4
+	.endm
+
+	.macro str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+	stm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+	.endm
+
+	.macro str1b ptr reg cond=al abort
+	.ifnc	\cond, al
+	b\cond	201f
+	b	202f
+	.endif
+201:	stb.w \reg, [\ptr]+, #1
+202:
+	.endm
+
+	.macro enter
+	mov	r3, #0
+	stm.w	(r0, r2, r3), [sp-]
+	.endm
+
+	.macro exit
+	add	sp, sp, #8
+	ldm.w	(r0), [sp]+
+	mov	pc, lr
+	.endm
+
+	.text
+
+ENTRY(__copy_from_user)
+
+#include "copy_template.S"
+
+ENDPROC(__copy_from_user)
+
+	.pushsection .fixup,"ax"
+	.align 0
+	copy_abort_preamble
+	ldm.w	(r1, r2), [sp]+
+	sub	r3, r0, r1
+	rsub	r1, r3, r2
+	stw	r1, [sp]
+	b.l	bzero
+	ldw.w	r0, [sp]+, #4
+	copy_abort_end
+	.popsection
+
diff --git a/arch/unicore32/lib/copy_page.S b/arch/unicore32/lib/copy_page.S
new file mode 100644
index 0000000..3a448d7
--- /dev/null
+++ b/arch/unicore32/lib/copy_page.S
@@ -0,0 +1,39 @@
+/*
+ * linux/arch/unicore32/lib/copy_page.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  ASM optimised string functions
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <generated/asm-offsets.h>
+#include <asm/cache.h>
+
+#define COPY_COUNT (PAGE_SZ/256)
+
+		.text
+		.align	5
+/*
+ * UniCore optimised copy_page routine
+ */
+ENTRY(copy_page)
+		stm.w	(r17 - r19, lr), [sp-]
+		mov	r17, r0
+		mov	r18, r1
+		mov	r19, #COPY_COUNT
+1:
+	.rept	4
+		ldm.w	(r0 - r15), [r18]+
+		stm.w	(r0 - r15), [r17]+
+	.endr
+		sub.a	r19, r19, #1
+		bne	1b
+		ldm.w	(r17 - r19, pc), [sp]+
+ENDPROC(copy_page)
diff --git a/arch/unicore32/lib/copy_template.S b/arch/unicore32/lib/copy_template.S
new file mode 100644
index 0000000..524287f
--- /dev/null
+++ b/arch/unicore32/lib/copy_template.S
@@ -0,0 +1,214 @@
+/*
+ * linux/arch/unicore32/lib/copy_template.S
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
+/*
+ * Theory of operation
+ * -------------------
+ *
+ * This file provides the core code for a forward memory copy used in
+ * the implementation of memcopy(), copy_to_user() and copy_from_user().
+ *
+ * The including file must define the following accessor macros
+ * according to the need of the given function:
+ *
+ * ldr1w ptr reg abort
+ *
+ *	This loads one word from 'ptr', stores it in 'reg' and increments
+ *	'ptr' to the next word. The 'abort' argument is used for fixup tables.
+ *
+ * ldr4w ptr reg1 reg2 reg3 reg4 abort
+ * ldr8w ptr, reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+ *
+ *	This loads four or eight words starting from 'ptr', stores them
+ *	in provided registers and increments 'ptr' past those words.
+ *	The'abort' argument is used for fixup tables.
+ *
+ * ldr1b ptr reg cond abort
+ *
+ *	Similar to ldr1w, but it loads a byte and increments 'ptr' one byte.
+ *	It also must apply the condition code if provided, otherwise the
+ *	"al" condition is assumed by default.
+ *
+ * str1w ptr reg abort
+ * str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+ * str1b ptr reg cond abort
+ *
+ *	Same as their ldr* counterparts, but data is stored to 'ptr' location
+ *	rather than being loaded.
+ *
+ * enter
+ *
+ *	Preserve the provided registers on the stack plus any additional
+ *	data as needed by the implementation including this code. Called
+ *	upon code entry.
+ *
+ * exit
+ *
+ *	Restore registers with the values previously saved with the
+ *	'preserv' macro. Called upon code termination.
+ */
+
+
+		enter
+
+		sub.a	r2, r2, #4
+		bsl	8f
+		and.a	ip, r0, #3
+		bne	9f
+		and.a	ip, r1, #3
+		bne	10f
+
+1:		sub.a	r2, r2, #(28)
+		stm.w	(r5 - r8), [sp-]
+		bsl	5f
+
+3:
+4:		ldr8w	r1, r3, r4, r5, r6, r7, r8, r10, r11, abort=20f
+		sub.a	r2, r2, #32
+		str8w	r0, r3, r4, r5, r6, r7, r8, r10, r11, abort=20f
+		beg	3b
+
+5:		and.a	ip, r2, #28
+		rsub	ip, ip, #32
+		beq	7f
+		add	pc, pc, ip		@ C is always clear here
+		nop
+
+		ldr1w	r1, r3, abort=20f
+		ldr1w	r1, r4, abort=20f
+		ldr1w	r1, r5, abort=20f
+		ldr1w	r1, r6, abort=20f
+		ldr1w	r1, r7, abort=20f
+		ldr1w	r1, r8, abort=20f
+		ldr1w	r1, r11, abort=20f
+
+		add	pc, pc, ip
+		nop
+
+		str1w	r0, r3, abort=20f
+		str1w	r0, r4, abort=20f
+		str1w	r0, r5, abort=20f
+		str1w	r0, r6, abort=20f
+		str1w	r0, r7, abort=20f
+		str1w	r0, r8, abort=20f
+		str1w	r0, r11, abort=20f
+
+7:		ldm.w	(r5 - r8), [sp]+
+
+8:		mov.a	r2, r2 << #31
+		ldr1b	r1, r3, ne, abort=21f
+		ldr1b	r1, r4, ea, abort=21f
+		ldr1b	r1, r10, ea, abort=21f
+		str1b	r0, r3, ne, abort=21f
+		str1b	r0, r4, ea, abort=21f
+		str1b	r0, r10, ea, abort=21f
+
+		exit
+
+9:		rsub	ip, ip, #4
+		csub.a	ip, #2
+		ldr1b	r1, r3, sg, abort=21f
+		ldr1b	r1, r4, eg, abort=21f
+		ldr1b	r1, r11, abort=21f
+		str1b	r0, r3, sg, abort=21f
+		str1b	r0, r4, eg, abort=21f
+		sub.a	r2, r2, ip
+		str1b	r0, r11, abort=21f
+		bsl	8b
+		and.a	ip, r1, #3
+		beq	1b
+
+10:		andn	r1, r1, #3
+		csub.a	ip, #2
+		ldr1w	r1, r11, abort=21f
+		beq	17f
+		bsg	18f
+
+
+		.macro	forward_copy_shift a b
+
+		sub.a	r2, r2, #28
+		bsl	14f
+
+11:		stm.w	(r5 - r9), [sp-]
+
+12:
+		ldr4w	r1, r4, r5, r6, r7, abort=19f
+		mov	r3, r11 pull #\a
+		sub.a	r2, r2, #32
+		ldr4w	r1, r8, r9, r10, r11, abort=19f
+		or	r3, r3, r4 push #\b
+		mov	r4, r4 pull #\a
+		or	r4, r4, r5 push #\b
+		mov	r5, r5 pull #\a
+		or	r5, r5, r6 push #\b
+		mov	r6, r6 pull #\a
+		or	r6, r6, r7 push #\b
+		mov	r7, r7 pull #\a
+		or	r7, r7, r8 push #\b
+		mov	r8, r8 pull #\a
+		or	r8, r8, r9 push #\b
+		mov	r9, r9 pull #\a
+		or	r9, r9, r10 push #\b
+		mov	r10, r10 pull #\a
+		or	r10, r10, r11 push #\b
+		str8w	r0, r3, r4, r5, r6, r7, r8, r9, r10, , abort=19f
+		beg	12b
+
+		ldm.w	(r5 - r9), [sp]+
+
+14:		and.a	ip, r2, #28
+		beq	16f
+
+15:		mov	r3, r11 pull #\a
+		ldr1w	r1, r11, abort=21f
+		sub.a	ip, ip, #4
+		or	r3, r3, r11 push #\b
+		str1w	r0, r3, abort=21f
+		bsg	15b
+
+16:		sub	r1, r1, #(\b / 8)
+		b	8b
+
+		.endm
+
+
+		forward_copy_shift	a=8	b=24
+
+17:		forward_copy_shift	a=16	b=16
+
+18:		forward_copy_shift	a=24	b=8
+
+
+/*
+ * Abort preamble and completion macros.
+ * If a fixup handler is required then those macros must surround it.
+ * It is assumed that the fixup code will handle the private part of
+ * the exit macro.
+ */
+
+	.macro	copy_abort_preamble
+19:	ldm.w	(r5 - r9), [sp]+
+	b	21f
+299:	.word	0			@ store lr
+					@ to avoid function call in fixup
+20:	ldm.w	(r5 - r8), [sp]+
+21:
+	adr	r1, 299b
+	stw	lr, [r1]
+	.endm
+
+	.macro	copy_abort_end
+	adr	lr, 299b
+	ldw	pc, [lr]
+	.endm
+
diff --git a/arch/unicore32/lib/copy_to_user.S b/arch/unicore32/lib/copy_to_user.S
new file mode 100644
index 0000000..d353791
--- /dev/null
+++ b/arch/unicore32/lib/copy_to_user.S
@@ -0,0 +1,97 @@
+/*
+ * linux/arch/unicore32/lib/copy_to_user.S
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
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+/*
+ * Prototype:
+ *
+ *	size_t __copy_to_user(void *to, const void *from, size_t n)
+ *
+ * Purpose:
+ *
+ *	copy a block to user memory from kernel memory
+ *
+ * Params:
+ *
+ *	to = user memory
+ *	from = kernel memory
+ *	n = number of bytes to copy
+ *
+ * Return value:
+ *
+ *	Number of bytes NOT copied.
+ */
+
+	.macro ldr1w ptr reg abort
+	ldw.w \reg, [\ptr]+, #4
+	.endm
+
+	.macro ldr4w ptr reg1 reg2 reg3 reg4 abort
+	ldm.w	(\reg1, \reg2, \reg3, \reg4), [\ptr]+
+	.endm
+
+	.macro ldr8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+	ldm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+	.endm
+
+	.macro ldr1b ptr reg cond=al abort
+	notcond	\cond, .+8
+	ldb.w \reg, [\ptr]+, #1
+	.endm
+
+	.macro str1w ptr reg abort
+	strusr	\reg, \ptr, 4, abort=\abort
+	.endm
+
+	.macro str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
+100:	stm.w (\reg1, \reg2, \reg3, \reg4, \reg5, \reg6, \reg7, \reg8), [\ptr]+
+
+	.pushsection __ex_table, "a"
+	.long 100b, \abort
+	.popsection
+	.endm
+
+	.macro str1b ptr reg cond=al abort
+	strusr	\reg, \ptr, 1, \cond, abort=\abort
+	.endm
+
+	.macro enter
+	mov	r3, #0
+	stm.w	(r0, r2, r3), [sp-]
+	.endm
+
+	.macro exit
+	add	sp, sp, #8
+	ldm.w	(r0), [sp]+
+	mov	pc, lr
+	.endm
+
+	.text
+
+ENTRY(__copy_to_user_std)
+WEAK(__copy_to_user)
+
+#include "copy_template.S"
+
+ENDPROC(__copy_to_user)
+
+	.pushsection .fixup,"ax"
+	.align 0
+	copy_abort_preamble
+	ldm.w	(r1, r2, r3), [sp]+
+	sub	r0, r0, r1
+	rsub	r0, r0, r2
+	copy_abort_end
+	.popsection
+
diff --git a/arch/unicore32/lib/getuser.S b/arch/unicore32/lib/getuser.S
new file mode 100644
index 0000000..c463198
--- /dev/null
+++ b/arch/unicore32/lib/getuser.S
@@ -0,0 +1,65 @@
+/*
+ * linux/arch/unicore32/lib/getuser.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Idea from x86 version, (C) Copyright 1998 Linus Torvalds
+ *
+ * These functions have a non-standard call interface to make them more
+ * efficient, especially as they return an error value in addition to
+ * the "real" return value.
+ *
+ * __get_user_X
+ *
+ * Inputs:	r0 contains the address
+ * Outputs:	r0 is the error code
+ *		r2, r3 contains the zero-extended value
+ *		lr corrupted
+ *
+ * No other registers must be altered.  (see <asm/uaccess.h>
+ * for specific UniCore register usage).
+ *
+ * Note that ADDR_LIMIT is either 0 or 0xc0000000.
+ * Note also that it is intended that __get_user_bad is not global.
+ */
+#include <linux/linkage.h>
+#include <asm/errno.h>
+
+ENTRY(__get_user_1)
+1:	ldb.u	r2, [r0]
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__get_user_1)
+
+ENTRY(__get_user_2)
+2:	ldb.u	r2, [r0]+, #1
+3:	ldb.u	r3, [r0]
+	or	r2, r2, r3 << #8
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__get_user_2)
+
+ENTRY(__get_user_4)
+4:	ldw.u	r2, [r0]
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__get_user_4)
+
+__get_user_bad:
+	mov	r2, #0
+	mov	r0, #-EFAULT
+	mov	pc, lr
+ENDPROC(__get_user_bad)
+
+.pushsection __ex_table, "a"
+	.long	1b, __get_user_bad
+	.long	2b, __get_user_bad
+	.long	3b, __get_user_bad
+	.long	4b, __get_user_bad
+.popsection
diff --git a/arch/unicore32/lib/putuser.S b/arch/unicore32/lib/putuser.S
new file mode 100644
index 0000000..42fe8a4
--- /dev/null
+++ b/arch/unicore32/lib/putuser.S
@@ -0,0 +1,73 @@
+/*
+ * linux/arch/unicore32/lib/putuser.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Idea from x86 version, (C) Copyright 1998 Linus Torvalds
+ *
+ * These functions have a non-standard call interface to make
+ * them more efficient, especially as they return an error
+ * value in addition to the "real" return value.
+ *
+ * __put_user_X
+ *
+ * Inputs:	r0 contains the address
+ *		r2, r3 contains the value
+ * Outputs:	r0 is the error code
+ *		lr corrupted
+ *
+ * No other registers must be altered.  (see <asm/uaccess.h>
+ * for specific ASM register usage).
+ *
+ * Note that ADDR_LIMIT is either 0 or 0xc0000000
+ * Note also that it is intended that __put_user_bad is not global.
+ */
+#include <linux/linkage.h>
+#include <asm/errno.h>
+
+ENTRY(__put_user_1)
+1:	stb.u	r2, [r0]
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__put_user_1)
+
+ENTRY(__put_user_2)
+	mov	ip, r2 >> #8
+2:	stb.u	r2, [r0]+, #1
+3:	stb.u	ip, [r0]
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__put_user_2)
+
+ENTRY(__put_user_4)
+4:	stw.u	r2, [r0]
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__put_user_4)
+
+ENTRY(__put_user_8)
+5:	stw.u	r2, [r0]+, #4
+6:	stw.u	r3, [r0]
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__put_user_8)
+
+__put_user_bad:
+	mov	r0, #-EFAULT
+	mov	pc, lr
+ENDPROC(__put_user_bad)
+
+.pushsection __ex_table, "a"
+	.long	1b, __put_user_bad
+	.long	2b, __put_user_bad
+	.long	3b, __put_user_bad
+	.long	4b, __put_user_bad
+	.long	5b, __put_user_bad
+	.long	6b, __put_user_bad
+.popsection
diff --git a/arch/unicore32/lib/strncpy_from_user.S b/arch/unicore32/lib/strncpy_from_user.S
new file mode 100644
index 0000000..ff6c304
--- /dev/null
+++ b/arch/unicore32/lib/strncpy_from_user.S
@@ -0,0 +1,45 @@
+/*
+ * linux/arch/unicore32/lib/strncpy_from_user.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/errno.h>
+
+	.text
+	.align	5
+
+/*
+ * Copy a string from user space to kernel space.
+ *  r0 = dst, r1 = src, r2 = byte length
+ * returns the number of characters copied (strlen of copied string),
+ *  -EFAULT on exception, or "len" if we fill the whole buffer
+ */
+ENTRY(__strncpy_from_user)
+	mov	ip, r1
+1:	sub.a	r2, r2, #1
+	ldrusr	r3, r1, 1, ns
+	bfs	2f
+	stb.w	r3, [r0]+, #1
+	cxor.a	r3, #0
+	bne	1b
+	sub	r1, r1, #1	@ take NUL character out of count
+2:	sub	r0, r1, ip
+	mov	pc, lr
+ENDPROC(__strncpy_from_user)
+
+	.pushsection .fixup,"ax"
+	.align	0
+9001:	mov	r3, #0
+	stb	r3, [r0+], #0	@ null terminate
+	mov	r0, #-EFAULT
+	mov	pc, lr
+	.popsection
+
diff --git a/arch/unicore32/lib/strnlen_user.S b/arch/unicore32/lib/strnlen_user.S
new file mode 100644
index 0000000..7586303
--- /dev/null
+++ b/arch/unicore32/lib/strnlen_user.S
@@ -0,0 +1,42 @@
+/*
+ * linux/arch/unicore32/lib/strnlen_user.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
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
+ *	      or zero on exception, or n + 1 if too long
+ */
+ENTRY(__strnlen_user)
+	mov	r2, r0
+1:
+	ldrusr	r3, r0, 1
+	cxor.a	r3, #0
+	beq	2f
+	sub.a	r1, r1, #1
+	bne	1b
+	add	r0, r0, #1
+2:	sub	r0, r0, r2
+	mov	pc, lr
+ENDPROC(__strnlen_user)
+
+	.pushsection .fixup,"ax"
+	.align	0
+9001:	mov	r0, #0
+	mov	pc, lr
+	.popsection

