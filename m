Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0EFVip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:38:45 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:11210 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0EFVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:38:44 -0400
X-Spam-Processed: digidescorp.com, Thu, 06 May 2010 16:38:43 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=17422c4580=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: fix get_user/put_user side-effects
Date: Thu,  6 May 2010 16:38:33 -0500
Message-Id: <1273181913-888-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microblaze implementations of get_user() and (MMU) put_user() evaluate 
the address argument more than once. This causes unexpected side-effects for
invocations that include increment operators, i.e. get_user(foo, bar++).

This patch also removes the distinction between MMU and noMMU put_user().

Without the patch:
  $ echo 1234567890 > /proc/sys/kernel/core_pattern
  $ cat /proc/sys/kernel/core_pattern
  12345

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
--- a/arch/microblaze/include/asm/uaccess.h	2010-04-27 10:14:33.000000000 -0500
+++ b/arch/microblaze/include/asm/uaccess.h	2010-05-06 16:21:02.000000000 -0500
@@ -182,6 +182,39 @@ extern long __user_bad(void);
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
+#define get_user(x, ptr)						\
+	__get_user_check((x), (ptr), sizeof(*(ptr)))
+
+#define __get_user_check(x, ptr, size)					\
+({									\
+	unsigned long __gu_val = 0;					\
+	const typeof(*(ptr)) __user *__gu_addr = (ptr);			\
+	int __gu_err = 0;						\
+									\
+	if (access_ok(VERIFY_READ, __gu_addr, size)) {			\
+		switch (size) {						\
+		case 1:							\
+			__get_user_asm("lbu", __gu_addr, __gu_val,	\
+				       __gu_err);			\
+			break;						\
+		case 2:							\
+			__get_user_asm("lhu", __gu_addr, __gu_val,	\
+				       __gu_err);			\
+			break;						\
+		case 4:							\
+			__get_user_asm("lw", __gu_addr, __gu_val,	\
+				       __gu_err);			\
+			break;						\
+		default:						\
+			__gu_err = __user_bad();			\
+			break;						\
+		}							\
+	} else {							\
+		__gu_err = -EFAULT;					\
+	}								\
+	x = (typeof(*(ptr)))__gu_val;					\
+	__gu_err;							\
+})
 
 #define __get_user(x, ptr)						\
 ({									\
@@ -206,12 +239,6 @@ extern long __user_bad(void);
 })
 
 
-#define get_user(x, ptr)						\
-({									\
-	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr)))			\
-		? __get_user((x), (ptr)) : -EFAULT;			\
-})
-
 #define __put_user_asm(insn, __gu_ptr, __gu_val, __gu_err)	\
 ({								\
 	__asm__ __volatile__ (					\
@@ -266,6 +293,42 @@ extern long __user_bad(void);
  *
  * Returns zero on success, or -EFAULT on error.
  */
+#define put_user(x, ptr)						\
+	__put_user_check((x), (ptr), sizeof(*(ptr)))
+
+#define __put_user_check(x, ptr, size)					\
+({									\
+	typeof(*(ptr)) __pu_val;					\
+	typeof(*(ptr)) __user *__pu_addr = (ptr);			\
+	int __pu_err = 0;						\
+									\
+	__pu_val = (x);							\
+	if (access_ok(VERIFY_WRITE, __pu_addr, size)) {			\
+		switch (size) {						\
+		case 1:							\
+			__put_user_asm("sb", __pu_addr, __pu_val,	\
+				       __pu_err);			\
+			break;						\
+		case 2:							\
+			__put_user_asm("sh", __pu_addr, __pu_val,	\
+				       __pu_err);			\
+			break;						\
+		case 4:							\
+			__put_user_asm("sw", __pu_addr, __pu_val,	\
+				       __pu_err);			\
+			break;						\
+		case 8:							\
+			__put_user_asm_8(__pu_addr, __pu_val, __pu_err);\
+			break;						\
+		default:						\
+			__pu_err = __user_bad();			\
+			break;						\
+		}							\
+	} else {							\
+		__pu_err = -EFAULT;					\
+	}								\
+	__pu_err;							\
+})
 
 #define __put_user(x, ptr)						\
 ({									\
@@ -290,18 +353,6 @@ extern long __user_bad(void);
 	__gu_err;							\
 })
 
-#ifndef CONFIG_MMU
-
-#define put_user(x, ptr)	__put_user((x), (ptr))
-
-#else /* CONFIG_MMU */
-
-#define put_user(x, ptr)						\
-({									\
-	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr)))			\
-		? __put_user((x), (ptr)) : -EFAULT;			\
-})
-#endif /* CONFIG_MMU */
 
 /* copy_to_from_user */
 #define __copy_from_user(to, from, n)	\

