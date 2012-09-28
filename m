Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031348Ab2I1T7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:59:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2I1S4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 048/262] ARM: 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_DOMAINS
Date: Fri, 28 Sep 2012 11:49:37 -0700
Message-Id: <20120928183003.602250745@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 8404663f81d212918ff85f493649a7991209fa04 upstream.

The {get,put}_user macros don't perform range checking on the provided
__user address when !CPU_HAS_DOMAINS.

This patch reworks the out-of-line assembly accessors to check the user
address against a specified limit, returning -EFAULT if is is out of
range.

[will: changed get_user register allocation to match put_user]
[rmk: fixed building on older ARM architectures]

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/assembler.h |    8 +++++++
 arch/arm/include/asm/uaccess.h   |   40 ++++++++++++++++++++++++++-------------
 arch/arm/lib/getuser.S           |   23 ++++++++++++++--------
 arch/arm/lib/putuser.S           |    6 +++++
 4 files changed, 56 insertions(+), 21 deletions(-)

--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -320,4 +320,12 @@
 	.size \name , . - \name
 	.endm
 
+	.macro check_uaccess, addr:req, size:req, limit:req, tmp:req, bad:req
+#ifndef CONFIG_CPU_USE_DOMAINS
+	adds	\tmp, \addr, #\size - 1
+	sbcccs	\tmp, \tmp, \limit
+	bcs	\bad
+#endif
+	.endm
+
 #endif /* __ASM_ASSEMBLER_H__ */
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -101,28 +101,39 @@ extern int __get_user_1(void *);
 extern int __get_user_2(void *);
 extern int __get_user_4(void *);
 
-#define __get_user_x(__r2,__p,__e,__s,__i...)				\
+#define __GUP_CLOBBER_1	"lr", "cc"
+#ifdef CONFIG_CPU_USE_DOMAINS
+#define __GUP_CLOBBER_2	"ip", "lr", "cc"
+#else
+#define __GUP_CLOBBER_2 "lr", "cc"
+#endif
+#define __GUP_CLOBBER_4	"lr", "cc"
+
+#define __get_user_x(__r2,__p,__e,__l,__s)				\
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%1", "r2")			\
+		__asmeq("%3", "r1")					\
 		"bl	__get_user_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
-		: "0" (__p)						\
-		: __i, "cc")
+		: "0" (__p), "r" (__l)					\
+		: __GUP_CLOBBER_##__s)
 
 #define get_user(x,p)							\
 	({								\
+		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
 		register unsigned long __r2 asm("r2");			\
+		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
 		case 1:							\
-			__get_user_x(__r2, __p, __e, 1, "lr");		\
-	       		break;						\
+			__get_user_x(__r2, __p, __e, __l, 1);		\
+			break;						\
 		case 2:							\
-			__get_user_x(__r2, __p, __e, 2, "r3", "lr");	\
+			__get_user_x(__r2, __p, __e, __l, 2);		\
 			break;						\
 		case 4:							\
-	       		__get_user_x(__r2, __p, __e, 4, "lr");		\
+			__get_user_x(__r2, __p, __e, __l, 4);		\
 			break;						\
 		default: __e = __get_user_bad(); break;			\
 		}							\
@@ -135,31 +146,34 @@ extern int __put_user_2(void *, unsigned
 extern int __put_user_4(void *, unsigned int);
 extern int __put_user_8(void *, unsigned long long);
 
-#define __put_user_x(__r2,__p,__e,__s)					\
+#define __put_user_x(__r2,__p,__e,__l,__s)				\
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%2", "r2")			\
+		__asmeq("%3", "r1")					\
 		"bl	__put_user_" #__s				\
 		: "=&r" (__e)						\
-		: "0" (__p), "r" (__r2)					\
+		: "0" (__p), "r" (__r2), "r" (__l)			\
 		: "ip", "lr", "cc")
 
 #define put_user(x,p)							\
 	({								\
+		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __r2 asm("r2") = (x);	\
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
+		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
 		case 1:							\
-			__put_user_x(__r2, __p, __e, 1);		\
+			__put_user_x(__r2, __p, __e, __l, 1);		\
 			break;						\
 		case 2:							\
-			__put_user_x(__r2, __p, __e, 2);		\
+			__put_user_x(__r2, __p, __e, __l, 2);		\
 			break;						\
 		case 4:							\
-			__put_user_x(__r2, __p, __e, 4);		\
+			__put_user_x(__r2, __p, __e, __l, 4);		\
 			break;						\
 		case 8:							\
-			__put_user_x(__r2, __p, __e, 8);		\
+			__put_user_x(__r2, __p, __e, __l, 8);		\
 			break;						\
 		default: __e = __put_user_bad(); break;			\
 		}							\
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -16,8 +16,9 @@
  * __get_user_X
  *
  * Inputs:	r0 contains the address
+ *		r1 contains the address limit, which must be preserved
  * Outputs:	r0 is the error code
- *		r2, r3 contains the zero-extended value
+ *		r2 contains the zero-extended value
  *		lr corrupted
  *
  * No other registers must be altered.  (see <asm/uaccess.h>
@@ -27,33 +28,39 @@
  * Note also that it is intended that __get_user_bad is not global.
  */
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 #include <asm/errno.h>
 #include <asm/domain.h>
 
 ENTRY(__get_user_1)
+	check_uaccess r0, 1, r1, r2, __get_user_bad
 1: TUSER(ldrb)	r2, [r0]
 	mov	r0, #0
 	mov	pc, lr
 ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
-#ifdef CONFIG_THUMB2_KERNEL
-2: TUSER(ldrb)	r2, [r0]
-3: TUSER(ldrb)	r3, [r0, #1]
+	check_uaccess r0, 2, r1, r2, __get_user_bad
+#ifdef CONFIG_CPU_USE_DOMAINS
+rb	.req	ip
+2:	ldrbt	r2, [r0], #1
+3:	ldrbt	rb, [r0], #0
 #else
-2: TUSER(ldrb)	r2, [r0], #1
-3: TUSER(ldrb)	r3, [r0]
+rb	.req	r0
+2:	ldrb	r2, [r0]
+3:	ldrb	rb, [r0, #1]
 #endif
 #ifndef __ARMEB__
-	orr	r2, r2, r3, lsl #8
+	orr	r2, r2, rb, lsl #8
 #else
-	orr	r2, r3, r2, lsl #8
+	orr	r2, rb, r2, lsl #8
 #endif
 	mov	r0, #0
 	mov	pc, lr
 ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
+	check_uaccess r0, 4, r1, r2, __get_user_bad
 4: TUSER(ldr)	r2, [r0]
 	mov	r0, #0
 	mov	pc, lr
--- a/arch/arm/lib/putuser.S
+++ b/arch/arm/lib/putuser.S
@@ -16,6 +16,7 @@
  * __put_user_X
  *
  * Inputs:	r0 contains the address
+ *		r1 contains the address limit, which must be preserved
  *		r2, r3 contains the value
  * Outputs:	r0 is the error code
  *		lr corrupted
@@ -27,16 +28,19 @@
  * Note also that it is intended that __put_user_bad is not global.
  */
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 #include <asm/errno.h>
 #include <asm/domain.h>
 
 ENTRY(__put_user_1)
+	check_uaccess r0, 1, r1, ip, __put_user_bad
 1: TUSER(strb)	r2, [r0]
 	mov	r0, #0
 	mov	pc, lr
 ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
+	check_uaccess r0, 2, r1, ip, __put_user_bad
 	mov	ip, r2, lsr #8
 #ifdef CONFIG_THUMB2_KERNEL
 #ifndef __ARMEB__
@@ -60,12 +64,14 @@ ENTRY(__put_user_2)
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
+	check_uaccess r0, 4, r1, ip, __put_user_bad
 4: TUSER(str)	r2, [r0]
 	mov	r0, #0
 	mov	pc, lr
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
+	check_uaccess r0, 8, r1, ip, __put_user_bad
 #ifdef CONFIG_THUMB2_KERNEL
 5: TUSER(str)	r2, [r0]
 6: TUSER(str)	r3, [r0, #4]


