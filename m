Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2DBVVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:21:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:42902 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DBVVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:21:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>
Subject: [PATCH] alpha: fix build failures from system.h dismemberment
Date: Mon,  2 Apr 2012 17:21:14 -0400
Message-Id: <1333401674-26007-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ec2212088c42ff7d1362629ec26dda4f3e8bdad3

    "Disintegrate asm/system.h for Alpha"

combined with commit b4816afa3986704d1404fc48e931da5135820472

    "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"

introduced the concept of asm/cmpxchg.h but the alpha arch
never got one.  Fork the cmpxchg content out of the asm/atomic.h
file to create one.

Some minor whitespace fixups were done on the block of code that
created the new file.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index f62251e..3bb7ffe 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <asm/barrier.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -168,73 +169,6 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
 	return result;
 }
 
-/*
- * Atomic exchange routines.
- */
-
-#define __ASM__MB
-#define ____xchg(type, args...)		__xchg ## type ## _local(args)
-#define ____cmpxchg(type, args...)	__cmpxchg ## type ## _local(args)
-#include <asm/xchg.h>
-
-#define xchg_local(ptr,x)						\
-  ({									\
-     __typeof__(*(ptr)) _x_ = (x);					\
-     (__typeof__(*(ptr))) __xchg_local((ptr), (unsigned long)_x_,	\
-				       sizeof(*(ptr)));			\
-  })
-
-#define cmpxchg_local(ptr, o, n)					\
-  ({									\
-     __typeof__(*(ptr)) _o_ = (o);					\
-     __typeof__(*(ptr)) _n_ = (n);					\
-     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	\
-					  (unsigned long)_n_,		\
-					  sizeof(*(ptr)));		\
-  })
-
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-
-#ifdef CONFIG_SMP
-#undef __ASM__MB
-#define __ASM__MB	"\tmb\n"
-#endif
-#undef ____xchg
-#undef ____cmpxchg
-#define ____xchg(type, args...)		__xchg ##type(args)
-#define ____cmpxchg(type, args...)	__cmpxchg ##type(args)
-#include <asm/xchg.h>
-
-#define xchg(ptr,x)							\
-  ({									\
-     __typeof__(*(ptr)) _x_ = (x);					\
-     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_,		\
-				 sizeof(*(ptr)));			\
-  })
-
-#define cmpxchg(ptr, o, n)						\
-  ({									\
-     __typeof__(*(ptr)) _o_ = (o);					\
-     __typeof__(*(ptr)) _n_ = (n);					\
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		\
-				    (unsigned long)_n_,	sizeof(*(ptr)));\
-  })
-
-#define cmpxchg64(ptr, o, n)						\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg((ptr), (o), (n));					\
-  })
-
-#undef __ASM__MB
-#undef ____cmpxchg
-
-#define __HAVE_ARCH_CMPXCHG 1
-
 #define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
diff --git a/arch/alpha/include/asm/cmpxchg.h b/arch/alpha/include/asm/cmpxchg.h
new file mode 100644
index 0000000..429e8cd
--- /dev/null
+++ b/arch/alpha/include/asm/cmpxchg.h
@@ -0,0 +1,71 @@
+#ifndef _ALPHA_CMPXCHG_H
+#define _ALPHA_CMPXCHG_H
+
+/*
+ * Atomic exchange routines.
+ */
+
+#define __ASM__MB
+#define ____xchg(type, args...)		__xchg ## type ## _local(args)
+#define ____cmpxchg(type, args...)	__cmpxchg ## type ## _local(args)
+#include <asm/xchg.h>
+
+#define xchg_local(ptr, x)						\
+({									\
+	__typeof__(*(ptr)) _x_ = (x);					\
+	(__typeof__(*(ptr))) __xchg_local((ptr), (unsigned long)_x_,	\
+				       sizeof(*(ptr)));			\
+})
+
+#define cmpxchg_local(ptr, o, n)					\
+({									\
+	__typeof__(*(ptr)) _o_ = (o);					\
+	__typeof__(*(ptr)) _n_ = (n);					\
+	(__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	\
+					  (unsigned long)_n_,		\
+					  sizeof(*(ptr)));		\
+})
+
+#define cmpxchg64_local(ptr, o, n)					\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+})
+
+#ifdef CONFIG_SMP
+#undef __ASM__MB
+#define __ASM__MB	"\tmb\n"
+#endif
+#undef ____xchg
+#undef ____cmpxchg
+#define ____xchg(type, args...)		__xchg ##type(args)
+#define ____cmpxchg(type, args...)	__cmpxchg ##type(args)
+#include <asm/xchg.h>
+
+#define xchg(ptr, x)							\
+({									\
+	__typeof__(*(ptr)) _x_ = (x);					\
+	(__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_,		\
+				 sizeof(*(ptr)));			\
+})
+
+#define cmpxchg(ptr, o, n)						\
+({									\
+	__typeof__(*(ptr)) _o_ = (o);					\
+	__typeof__(*(ptr)) _n_ = (n);					\
+	(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	\
+				    (unsigned long)_n_,	sizeof(*(ptr)));\
+})
+
+#define cmpxchg64(ptr, o, n)						\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+})
+
+#undef __ASM__MB
+#undef ____cmpxchg
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+#endif /* _ALPHA_CMPXCHG_H */
diff --git a/arch/alpha/include/asm/xchg.h b/arch/alpha/include/asm/xchg.h
index 1d1b436..0ca9724 100644
--- a/arch/alpha/include/asm/xchg.h
+++ b/arch/alpha/include/asm/xchg.h
@@ -1,10 +1,10 @@
-#ifndef _ALPHA_ATOMIC_H
+#ifndef _ALPHA_CMPXCHG_H
 #error Do not include xchg.h directly!
 #else
 /*
  * xchg/xchg_local and cmpxchg/cmpxchg_local share the same code
  * except that local version do not have the expensive memory barrier.
- * So this file is included twice from asm/system.h.
+ * So this file is included twice from asm/cmpxchg.h.
  */
 
 /*
-- 
1.7.9.1

