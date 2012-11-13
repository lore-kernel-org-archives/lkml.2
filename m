Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2KMPA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:00:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47900 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2KMPA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:00:58 -0500
From: Rob Clark <rob.clark@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Rob Clark <rob@ti.com>
Subject: [PATCH] ARM: add get_user() support for 8 byte types
Date: Tue, 13 Nov 2012 09:00:54 -0600
Message-Id: <1352818854-10958-1-git-send-email-rob.clark@linaro.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <rob@ti.com>

A new atomic modeset/pageflip ioctl being developed in DRM requires
get_user() to work for 64bit types (in addition to just put_user()).

v1: original
v2: pass correct size to check_uaccess, and better handling of narrowing
    double word read with __get_user_xb() (Russell King's suggestion)

Signed-off-by: Rob Clark <rob@ti.com>
---
 arch/arm/include/asm/uaccess.h | 18 +++++++++++++++++-
 arch/arm/lib/getuser.S         | 17 ++++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 7e1f760..e2236ad 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -100,6 +100,7 @@ static inline void set_fs(mm_segment_t fs)
 extern int __get_user_1(void *);
 extern int __get_user_2(void *);
 extern int __get_user_4(void *);
+extern int __get_user_8(void *);
 
 #define __GUP_CLOBBER_1	"lr", "cc"
 #ifdef CONFIG_CPU_USE_DOMAINS
@@ -108,6 +109,7 @@ extern int __get_user_4(void *);
 #define __GUP_CLOBBER_2 "lr", "cc"
 #endif
 #define __GUP_CLOBBER_4	"lr", "cc"
+#define __GUP_CLOBBER_8	"lr", "cc"
 
 #define __get_user_x(__r2,__p,__e,__l,__s)				\
 	   __asm__ __volatile__ (					\
@@ -118,11 +120,19 @@ extern int __get_user_4(void *);
 		: "0" (__p), "r" (__l)					\
 		: __GUP_CLOBBER_##__s)
 
+/* narrowing a double-word get into a single 32bit word register: */
+#ifdef BIG_ENDIAN
+#define __get_user_xb(__r2,__p,__e,__l,__s)				\
+	__get_user_x(__r2,(uintptr_t)__p + 4,__e,__l,__s)
+#else
+#define __get_user_xb __get_user_x
+#endif
+
 #define __get_user_check(x,p)							\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
-		register unsigned long __r2 asm("r2");			\
+		register typeof(x) __r2 asm("r2");			\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
@@ -135,6 +145,12 @@ extern int __get_user_4(void *);
 		case 4:							\
 			__get_user_x(__r2, __p, __e, __l, 4);		\
 			break;						\
+		case 8:							\
+			if (sizeof((x)) < 8)				\
+				__get_user_xb(__r2, __p, __e, __l, 4);	\
+			else						\
+				__get_user_x(__r2, __p, __e, __l, 8);	\
+			break;						\
 		default: __e = __get_user_bad(); break;			\
 		}							\
 		x = (typeof(*(p))) __r2;				\
diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index 9b06bb4..ed98707 100644
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -18,7 +18,7 @@
  * Inputs:	r0 contains the address
  *		r1 contains the address limit, which must be preserved
  * Outputs:	r0 is the error code
- *		r2 contains the zero-extended value
+ *		r2, r3 contains the zero-extended value
  *		lr corrupted
  *
  * No other registers must be altered.  (see <asm/uaccess.h>
@@ -66,6 +66,19 @@ ENTRY(__get_user_4)
 	mov	pc, lr
 ENDPROC(__get_user_4)
 
+ENTRY(__get_user_8)
+	check_uaccess r0, 8, r1, r2, __get_user_bad
+#ifdef CONFIG_THUMB2_KERNEL
+5: TUSER(ldr)	r2, [r0]
+6: TUSER(ldr)	r3, [r0, #4]
+#else
+5: TUSER(ldr)	r2, [r0], #4
+6: TUSER(ldr)	r3, [r0]
+#endif
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__get_user_8)
+
 __get_user_bad:
 	mov	r2, #0
 	mov	r0, #-EFAULT
@@ -77,4 +90,6 @@ ENDPROC(__get_user_bad)
 	.long	2b, __get_user_bad
 	.long	3b, __get_user_bad
 	.long	4b, __get_user_bad
+	.long	5b, __get_user_bad
+	.long	6b, __get_user_bad
 .popsection
-- 
1.8.0

