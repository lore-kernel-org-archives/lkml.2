Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0IAOjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 10:39:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40194 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab0IAOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 10:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wn0jzR5jwwW2sHKfj//XwbjmzAnLTN8OfkC7UnvSd3YHd5NNYC6KFTY+VdABlYD9KN
         r0QvBrsqxZGRcqbT8z/mi9gaYmyLweuhi4wu5BIv2nJxcx/RhiDtUuUHxBcs6n3oUCUC
         LoDUfjToIZWALy1xMTAvkst3u9VNYKuXTlMOA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86: merge strncpy_from_user() between 32 and 64 bits
Date: Wed,  1 Sep 2010 23:32:29 +0900
Message-Id: <1283351549-17126-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge __strncpy_from_user() and strncpy_from_user() in usercopy_32.c
and usercopy_64.c

The register operand constraint for the local variable res is changed
from "=&d" to "=&r" on 32-bit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/asm.h |    1 +
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/usercopy.c    |   89 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/usercopy_32.c |   87 -------------------------------------------
 arch/x86/lib/usercopy_64.c |   49 ------------------------
 5 files changed, 91 insertions(+), 137 deletions(-)
 create mode 100644 arch/x86/lib/usercopy.c

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index b3ed1e1..c07d510 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -27,6 +27,7 @@
 #define _ASM_ADD	__ASM_SIZE(add)
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
+#define _ASM_TEST	__ASM_SIZE(test)
 
 #define _ASM_AX		__ASM_REG(ax)
 #define _ASM_BX		__ASM_REG(bx)
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index e10cf07..b40b473 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser.o putuser.o
+lib-y += usercopy.o usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
new file mode 100644
index 0000000..a8ae726
--- /dev/null
+++ b/arch/x86/lib/usercopy.c
@@ -0,0 +1,89 @@
+/*
+ * User address space access functions.
+ *
+ * Copyright 1997 Andi Kleen <ak@muc.de>
+ * Copyright 1997 Linus Torvalds
+ * Copyright 2002 Andi Kleen <ak@suse.de>
+ */
+#include <linux/module.h>
+#include <asm/uaccess.h>
+
+/**
+ * __strncpy_from_user: - Copy a NUL terminated string from userspace, with less checking.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.
+ * Caller must check the specified block with access_ok() before calling
+ * this function.
+ *
+ * On success, returns the length of the string (not including the trailing
+ * NUL).
+ *
+ * If access to userspace fails, returns -EFAULT (some data may have been
+ * copied).
+ *
+ * If @count is smaller than the length of the string, copies @count bytes
+ * and returns @count.
+ */
+long
+__strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res;
+	long __d0, __d1, __d2;
+
+	might_fault();
+	__asm__ __volatile__(
+		"	" _ASM_TEST " %1,%1\n"
+		"	jz 2f\n"
+		"0:	lodsb\n"
+		"	stosb\n"
+		"	testb %%al,%%al\n"
+		"	jz 1f\n"
+		"	" _ASM_DEC " %1\n"
+		"	jnz 0b\n"
+		"1:	" _ASM_SUB " %1,%0\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	" _ASM_MOV " %5,%0\n"
+		"	jmp 2b\n"
+		".previous\n"
+		_ASM_EXTABLE(0b, 3b)
+		: "=&r"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),
+		  "=&D" (__d2)
+		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst)
+		: "memory");
+
+	return res;
+}
+EXPORT_SYMBOL(__strncpy_from_user);
+
+/**
+ * strncpy_from_user: - Copy a NUL terminated string from userspace.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.
+ *
+ * On success, returns the length of the string (not including the trailing
+ * NUL).
+ *
+ * If access to userspace fails, returns -EFAULT (some data may have been
+ * copied).
+ *
+ * If @count is smaller than the length of the string, copies @count bytes
+ * and returns @count.
+ */
+long
+strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		return __strncpy_from_user(dst, src, count);
+	return res;
+}
+EXPORT_SYMBOL(strncpy_from_user);
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e218d5d..3c989c4 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -33,93 +33,6 @@ static inline int __movsl_is_ok(unsigned long a1, unsigned long a2, unsigned lon
 	__movsl_is_ok((unsigned long)(a1), (unsigned long)(a2), (n))
 
 /*
- * Copy a null terminated string from userspace.
- */
-
-#define __do_strncpy_from_user(dst, src, count, res)			   \
-do {									   \
-	int __d0, __d1, __d2;						   \
-	might_fault();							   \
-	__asm__ __volatile__(						   \
-		"	testl %1,%1\n"					   \
-		"	jz 2f\n"					   \
-		"0:	lodsb\n"					   \
-		"	stosb\n"					   \
-		"	testb %%al,%%al\n"				   \
-		"	jz 1f\n"					   \
-		"	decl %1\n"					   \
-		"	jnz 0b\n"					   \
-		"1:	subl %1,%0\n"					   \
-		"2:\n"							   \
-		".section .fixup,\"ax\"\n"				   \
-		"3:	movl %5,%0\n"					   \
-		"	jmp 2b\n"					   \
-		".previous\n"						   \
-		_ASM_EXTABLE(0b,3b)					   \
-		: "=&d"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
-		  "=&D" (__d2)						   \
-		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
-		: "memory");						   \
-} while (0)
-
-/**
- * __strncpy_from_user: - Copy a NUL terminated string from userspace, with less checking.
- * @dst:   Destination address, in kernel space.  This buffer must be at
- *         least @count bytes long.
- * @src:   Source address, in user space.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
- *
- * Copies a NUL-terminated string from userspace to kernel space.
- * Caller must check the specified block with access_ok() before calling
- * this function.
- *
- * On success, returns the length of the string (not including the trailing
- * NUL).
- *
- * If access to userspace fails, returns -EFAULT (some data may have been
- * copied).
- *
- * If @count is smaller than the length of the string, copies @count bytes
- * and returns @count.
- */
-long
-__strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	long res;
-	__do_strncpy_from_user(dst, src, count, res);
-	return res;
-}
-EXPORT_SYMBOL(__strncpy_from_user);
-
-/**
- * strncpy_from_user: - Copy a NUL terminated string from userspace.
- * @dst:   Destination address, in kernel space.  This buffer must be at
- *         least @count bytes long.
- * @src:   Source address, in user space.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
- *
- * Copies a NUL-terminated string from userspace to kernel space.
- *
- * On success, returns the length of the string (not including the trailing
- * NUL).
- *
- * If access to userspace fails, returns -EFAULT (some data may have been
- * copied).
- *
- * If @count is smaller than the length of the string, copies @count bytes
- * and returns @count.
- */
-long
-strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	long res = -EFAULT;
-	if (access_ok(VERIFY_READ, src, 1))
-		__do_strncpy_from_user(dst, src, count, res);
-	return res;
-}
-EXPORT_SYMBOL(strncpy_from_user);
-
-/*
  * Zero Userspace
  */
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index b7c2849..0d0326f 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -9,55 +9,6 @@
 #include <asm/uaccess.h>
 
 /*
- * Copy a null terminated string from userspace.
- */
-
-#define __do_strncpy_from_user(dst,src,count,res)			   \
-do {									   \
-	long __d0, __d1, __d2;						   \
-	might_fault();							   \
-	__asm__ __volatile__(						   \
-		"	testq %1,%1\n"					   \
-		"	jz 2f\n"					   \
-		"0:	lodsb\n"					   \
-		"	stosb\n"					   \
-		"	testb %%al,%%al\n"				   \
-		"	jz 1f\n"					   \
-		"	decq %1\n"					   \
-		"	jnz 0b\n"					   \
-		"1:	subq %1,%0\n"					   \
-		"2:\n"							   \
-		".section .fixup,\"ax\"\n"				   \
-		"3:	movq %5,%0\n"					   \
-		"	jmp 2b\n"					   \
-		".previous\n"						   \
-		_ASM_EXTABLE(0b,3b)					   \
-		: "=&r"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
-		  "=&D" (__d2)						   \
-		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
-		: "memory");						   \
-} while (0)
-
-long
-__strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	long res;
-	__do_strncpy_from_user(dst, src, count, res);
-	return res;
-}
-EXPORT_SYMBOL(__strncpy_from_user);
-
-long
-strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	long res = -EFAULT;
-	if (access_ok(VERIFY_READ, src, 1))
-		return __strncpy_from_user(dst, src, count);
-	return res;
-}
-EXPORT_SYMBOL(strncpy_from_user);
-
-/*
  * Zero Userspace
  */
 
-- 
1.6.0.6

