Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2DAUkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:40:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:54175 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2DAUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 06/11] parisc: fix missing cmpxchg file error from system.h split
Date: Sun,  1 Apr 2012 16:38:42 -0400
Message-Id: <1333312727-11428-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b4816afa3986704d1404fc48e931da5135820472

    "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"

introduced the concept of asm/cmpxchg.h but the parisc arch
never got one.  Fork the cmpxchg content out of the asm/atomic.h
file to create one.

Some minor whitespace fixups were done on the block of code that
created the new file.

Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/parisc/include/asm/atomic.h  |  107 +---------------------------------
 arch/parisc/include/asm/cmpxchg.h |  116 +++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 106 deletions(-)
 create mode 100644 arch/parisc/include/asm/cmpxchg.h

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 3ae5607..6c6defc 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -6,6 +6,7 @@
 #define _ASM_PARISC_ATOMIC_H_
 
 #include <linux/types.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -48,112 +49,6 @@ extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
 #  define _atomic_spin_unlock_irqrestore(l,f) do { local_irq_restore(f); } while (0)
 #endif
 
-/* This should get optimized out since it's never called.
-** Or get a link error if xchg is used "wrong".
-*/
-extern void __xchg_called_with_bad_pointer(void);
-
-
-/* __xchg32/64 defined in arch/parisc/lib/bitops.c */
-extern unsigned long __xchg8(char, char *);
-extern unsigned long __xchg32(int, int *);
-#ifdef CONFIG_64BIT
-extern unsigned long __xchg64(unsigned long, unsigned long *);
-#endif
-
-/* optimizer better get rid of switch since size is a constant */
-static __inline__ unsigned long
-__xchg(unsigned long x, __volatile__ void * ptr, int size)
-{
-	switch(size) {
-#ifdef CONFIG_64BIT
-	case 8: return __xchg64(x,(unsigned long *) ptr);
-#endif
-	case 4: return __xchg32((int) x, (int *) ptr);
-	case 1: return __xchg8((char) x, (char *) ptr);
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-
-/*
-** REVISIT - Abandoned use of LDCW in xchg() for now:
-** o need to test sizeof(*ptr) to avoid clearing adjacent bytes
-** o and while we are at it, could CONFIG_64BIT code use LDCD too?
-**
-**	if (__builtin_constant_p(x) && (x == NULL))
-**		if (((unsigned long)p & 0xf) == 0)
-**			return __ldcw(p);
-*/
-#define xchg(ptr,x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-
-#define __HAVE_ARCH_CMPXCHG	1
-
-/* bug catcher for when unsupported size is used - won't link */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-/* __cmpxchg_u32/u64 defined in arch/parisc/lib/bitops.c */
-extern unsigned long __cmpxchg_u32(volatile unsigned int *m, unsigned int old, unsigned int new_);
-extern unsigned long __cmpxchg_u64(volatile unsigned long *ptr, unsigned long old, unsigned long new_);
-
-/* don't worry...optimizer will get rid of most of this */
-static __inline__ unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new_, int size)
-{
-	switch(size) {
-#ifdef CONFIG_64BIT
-	case 8: return __cmpxchg_u64((unsigned long *)ptr, old, new_);
-#endif
-	case 4: return __cmpxchg_u32((unsigned int *)ptr, (unsigned int) old, (unsigned int) new_);
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr,o,n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new_, int size)
-{
-	switch (size) {
-#ifdef CONFIG_64BIT
-	case 8:	return __cmpxchg_u64((unsigned long *)ptr, old, new_);
-#endif
-	case 4:	return __cmpxchg_u32(ptr, old, new_);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new_, size);
-	}
-}
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-			(unsigned long)(n), sizeof(*(ptr))))
-#ifdef CONFIG_64BIT
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-#else
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-#endif
-
 /*
  * Note that we need not lock read accesses - aligned word writes/reads
  * are atomic, so a reader never sees inconsistent values.
diff --git a/arch/parisc/include/asm/cmpxchg.h b/arch/parisc/include/asm/cmpxchg.h
new file mode 100644
index 0000000..dbd1335
--- /dev/null
+++ b/arch/parisc/include/asm/cmpxchg.h
@@ -0,0 +1,116 @@
+/*
+ * forked from parisc asm/atomic.h which was:
+ *	Copyright (C) 2000 Philipp Rumpf <prumpf@tux.org>
+ *	Copyright (C) 2006 Kyle McMartin <kyle@parisc-linux.org>
+ */
+
+#ifndef _ASM_PARISC_CMPXCHG_H_
+#define _ASM_PARISC_CMPXCHG_H_
+
+/* This should get optimized out since it's never called.
+** Or get a link error if xchg is used "wrong".
+*/
+extern void __xchg_called_with_bad_pointer(void);
+
+/* __xchg32/64 defined in arch/parisc/lib/bitops.c */
+extern unsigned long __xchg8(char, char *);
+extern unsigned long __xchg32(int, int *);
+#ifdef CONFIG_64BIT
+extern unsigned long __xchg64(unsigned long, unsigned long *);
+#endif
+
+/* optimizer better get rid of switch since size is a constant */
+static inline unsigned long
+__xchg(unsigned long x, __volatile__ void *ptr, int size)
+{
+	switch (size) {
+#ifdef CONFIG_64BIT
+	case 8: return __xchg64(x, (unsigned long *) ptr);
+#endif
+	case 4: return __xchg32((int) x, (int *) ptr);
+	case 1: return __xchg8((char) x, (char *) ptr);
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+/*
+** REVISIT - Abandoned use of LDCW in xchg() for now:
+** o need to test sizeof(*ptr) to avoid clearing adjacent bytes
+** o and while we are at it, could CONFIG_64BIT code use LDCD too?
+**
+**	if (__builtin_constant_p(x) && (x == NULL))
+**		if (((unsigned long)p & 0xf) == 0)
+**			return __ldcw(p);
+*/
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+#define __HAVE_ARCH_CMPXCHG	1
+
+/* bug catcher for when unsupported size is used - won't link */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+/* __cmpxchg_u32/u64 defined in arch/parisc/lib/bitops.c */
+extern unsigned long __cmpxchg_u32(volatile unsigned int *m, unsigned int old,
+				   unsigned int new_);
+extern unsigned long __cmpxchg_u64(volatile unsigned long *ptr,
+				   unsigned long old, unsigned long new_);
+
+/* don't worry...optimizer will get rid of most of this */
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new_, int size)
+{
+	switch (size) {
+#ifdef CONFIG_64BIT
+	case 8: return __cmpxchg_u64((unsigned long *)ptr, old, new_);
+#endif
+	case 4: return __cmpxchg_u32((unsigned int *)ptr,
+				     (unsigned int)old, (unsigned int)new_);
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						 \
+({									 \
+	__typeof__(*(ptr)) _o_ = (o);					 \
+	__typeof__(*(ptr)) _n_ = (n);					 \
+	(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+})
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new_, int size)
+{
+	switch (size) {
+#ifdef CONFIG_64BIT
+	case 8:	return __cmpxchg_u64((unsigned long *)ptr, old, new_);
+#endif
+	case 4:	return __cmpxchg_u32(ptr, old, new_);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new_, size);
+	}
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr, o, n)					\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+})
+#else
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
+#endif /* _ASM_PARISC_CMPXCHG_H_ */
-- 
1.7.9.1

