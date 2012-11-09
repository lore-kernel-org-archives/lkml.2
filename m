Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2KIVSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:18:33 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64535 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2KIVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:18:32 -0500
From: Rob Clark <rob.clark@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Rob Clark <rob@ti.com>
Subject: [PATCH] ARM: add get_user() support for 8 byte types
Date: Fri,  9 Nov 2012 15:17:33 -0600
Message-Id: <1352495853-9790-1-git-send-email-rob.clark@linaro.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <rob@ti.com>

A new atomic modeset/pageflip ioctl being developed in DRM requires
get_user() to work for 64bit types (in addition to just put_user()).

Signed-off-by: Rob Clark <rob@ti.com>
---
 arch/arm/include/asm/uaccess.h | 25 ++++++++++++++++++++-----
 arch/arm/lib/getuser.S         | 17 ++++++++++++++++-
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 7e1f760..2e3fdb2 100644
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
@@ -122,22 +124,35 @@ extern int __get_user_4(void *);
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
-		register unsigned long __r2 asm("r2");			\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
-		case 1:							\
+		case 1: {						\
+			register unsigned long __r2 asm("r2");		\
 			__get_user_x(__r2, __p, __e, __l, 1);		\
+			x = (typeof(*(p))) __r2;			\
 			break;						\
-		case 2:							\
+		}							\
+		case 2: {						\
+			register unsigned long __r2 asm("r2");		\
 			__get_user_x(__r2, __p, __e, __l, 2);		\
+			x = (typeof(*(p))) __r2;			\
 			break;						\
-		case 4:							\
+		}							\
+		case 4: {						\
+			register unsigned long __r2 asm("r2");		\
 			__get_user_x(__r2, __p, __e, __l, 4);		\
+			x = (typeof(*(p))) __r2;			\
+			break;						\
+		}							\
+		case 8: {						\
+			register unsigned long long __r2 asm("r2");	\
+			__get_user_x(__r2, __p, __e, __l, 8);		\
+			x = (typeof(*(p))) __r2;			\
 			break;						\
+		}							\
 		default: __e = __get_user_bad(); break;			\
 		}							\
-		x = (typeof(*(p))) __r2;				\
 		__e;							\
 	})
 
diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index 9b06bb4..d05285c 100644
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
+	check_uaccess r0, 4, r1, r2, __get_user_bad
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

