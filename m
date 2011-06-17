Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab1FQT5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:57:52 -0400
Received: from outappmail004.snc4.facebook.com ([66.220.144.158]:47285 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932962Ab1FQT5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:57:44 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@osdl.org>, Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 2/4] atomic: move atomic_add_unless to generic code
Date: Fri, 17 Jun 2011 12:57:08 -0700
Message-Id: <1308340630-16008-2-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1308340630-16008-1-git-send-email-asharma@fb.com>
References: <1308340630-16008-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for more generic atomic
primitives based on __atomic_add_unless.

Signed-off-by: Arun Sharma <asharma@fb.com>
Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
LKML-Reference: <20110531105019.GF24172@elte.hu>
---
 arch/alpha/include/asm/atomic.h    |   10 +++---
 arch/arm/include/asm/atomic.h      |    4 +-
 arch/avr32/include/asm/atomic.h    |   57 ++++++++++++++++--------------------
 arch/blackfin/include/asm/atomic.h |    4 +-
 arch/cris/include/asm/atomic.h     |    4 +-
 arch/frv/include/asm/atomic.h      |    4 +-
 arch/h8300/include/asm/atomic.h    |    4 +-
 arch/ia64/include/asm/atomic.h     |    4 +-
 arch/m32r/include/asm/atomic.h     |    8 ++--
 arch/m68k/include/asm/atomic.h     |    4 +-
 arch/mips/include/asm/atomic.h     |   10 +++---
 arch/mn10300/include/asm/atomic.h  |    4 +-
 arch/parisc/include/asm/atomic.h   |   10 +++---
 arch/powerpc/include/asm/atomic.h  |   14 ++++----
 arch/s390/include/asm/atomic.h     |    4 +-
 arch/sh/include/asm/atomic.h       |    8 ++--
 arch/sparc/include/asm/atomic_32.h |    2 +-
 arch/sparc/include/asm/atomic_64.h |    4 +-
 arch/tile/include/asm/atomic_32.h  |   10 +++---
 arch/tile/include/asm/atomic_64.h  |    4 +-
 arch/x86/include/asm/atomic.h      |    8 ++--
 arch/x86/include/asm/atomic64_32.h |    2 +-
 arch/x86/include/asm/atomic64_64.h |    2 +-
 arch/xtensa/include/asm/atomic.h   |    8 ++--
 include/asm-generic/atomic.h       |    4 +-
 include/linux/atomic.h             |   14 +++++++++
 26 files changed, 109 insertions(+), 102 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 88b7491..3d67049 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -176,15 +176,15 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -196,7 +196,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
@@ -207,7 +207,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 4d501f1..3757e91 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -208,14 +208,14 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 
 	c = atomic_read(v);
 	while (c != u && (old = atomic_cmpxchg((v), c, c + a)) != c)
 		c = old;
-	return c != u;
+	return c;
 }
 
 #define atomic_inc(v)		atomic_add(1, v)
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index f229c38..dc6c3a4 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -78,70 +78,63 @@ static inline int atomic_add_return(int i, atomic_t *v)
 /*
  * atomic_sub_unless - sub unless the number is a given value
  * @v: pointer of type atomic_t
- * @a: the amount to add to v...
+ * @a: the amount to subtract from v...
  * @u: ...unless v is equal to u.
  *
- * If the atomic value v is not equal to u, this function subtracts a
- * from v, and returns non zero. If v is equal to u then it returns
- * zero. This is done as an atomic operation.
+ * Atomically subtract @a from @v, so long as it was not @u.
+ * Returns the old value of @v.
 */
-static inline int atomic_sub_unless(atomic_t *v, int a, int u)
+static inline void atomic_sub_unless(atomic_t *v, int a, int u)
 {
-	int tmp, result = 0;
+	int tmp;
 
 	asm volatile(
 		"/* atomic_sub_unless */\n"
 		"1:	ssrf	5\n"
-		"	ld.w	%0, %3\n"
-		"	cp.w	%0, %5\n"
+		"	ld.w	%0, %2\n"
+		"	cp.w	%0, %4\n"
 		"	breq	1f\n"
-		"	sub	%0, %4\n"
-		"	stcond	%2, %0\n"
+		"	sub	%0, %3\n"
+		"	stcond	%1, %0\n"
 		"	brne	1b\n"
-		"	mov	%1, 1\n"
 		"1:"
-		: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u), "1"(result)
+		: "=&r"(tmp), "=o"(v->counter)
+		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
 		: "cc", "memory");
-
-	return result;
 }
 
 /*
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
- * If the atomic value v is not equal to u, this function adds a to v,
- * and returns non zero. If v is equal to u then it returns zero. This
- * is done as an atomic operation.
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns the old value of @v.
 */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-	int tmp, result;
+	int tmp, old = atomic_read(v);
 
 	if (__builtin_constant_p(a) && (a >= -1048575) && (a <= 1048576))
-		result = atomic_sub_unless(v, -a, u);
+		atomic_sub_unless(v, -a, u);
 	else {
-		result = 0;
 		asm volatile(
-			"/* atomic_add_unless */\n"
+			"/* __atomic_add_unless */\n"
 			"1:	ssrf	5\n"
-			"	ld.w	%0, %3\n"
-			"	cp.w	%0, %5\n"
+			"	ld.w	%0, %2\n"
+			"	cp.w	%0, %4\n"
 			"	breq	1f\n"
-			"	add	%0, %4\n"
-			"	stcond	%2, %0\n"
+			"	add	%0, %3\n"
+			"	stcond	%1, %0\n"
 			"	brne	1b\n"
-			"	mov	%1, 1\n"
 			"1:"
-			: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(a), "ir"(u), "1"(result)
+			: "=&r"(tmp), "=o"(v->counter)
+			: "m"(v->counter), "r"(a), "ir"(u)
 			: "cc", "memory");
 	}
 
-	return result;
+	return old;
 }
 
 /*
diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 1fcc2a8..2cfce26 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -94,13 +94,13 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
+#define __atomic_add_unless(v, a, u)				\
 ({								\
 	int c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
-	c != (u);						\
+	c;							\
 })
 
 /*
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index ce9f67e..7e90532 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -138,7 +138,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
 	unsigned long flags;
@@ -148,7 +148,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	if (ret != u)
 		v->counter += a;
 	cris_atomic_restore(v, flags);
-	return ret != u;
+	return ret;
 }
 
 /* Atomic operations are already serializing */
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index b07b75f..a51dcdf 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -241,7 +241,7 @@ extern uint32_t __xchg_32(uint32_t i, volatile void *v);
 #define atomic64_cmpxchg(v, old, new)	(__cmpxchg_64(old, new, &(v)->counter))
 #define atomic64_xchg(v, new)		(__xchg_64(new, &(v)->counter))
 
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -253,7 +253,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index b641714..e6d1663 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -104,7 +104,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
 	unsigned long flags;
@@ -114,7 +114,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 	if (ret != u)
 		v->counter += a;
 	local_irq_restore(flags);
-	return ret != u;
+	return ret;
 }
 
 static __inline__ void atomic_clear_mask(unsigned long mask, unsigned long *v)
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index fdb8870..22aca21 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -90,7 +90,7 @@ ia64_atomic64_sub (__s64 i, atomic64_t *v)
 	(cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -102,7 +102,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index d64d894..c839426 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -239,15 +239,15 @@ static __inline__ int atomic_dec_return(atomic_t *v)
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -259,7 +259,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 7dc8873..017a15e 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -183,7 +183,7 @@ static inline void atomic_set_mask(unsigned long mask, unsigned long *v)
 	__asm__ __volatile__("orl %1,%0" : "+m" (*v) : "id" (mask));
 }
 
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -195,7 +195,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 833a402..31cb23d 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -303,15 +303,15 @@ static __inline__ int atomic_sub_if_positive(int i, atomic_t * v)
 #define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -323,7 +323,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 #define atomic_dec_return(v) atomic_sub_return(1, (v))
@@ -679,7 +679,7 @@ static __inline__ long atomic64_sub_if_positive(long i, atomic64_t * v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index 041b9d6..a2e6759 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -260,13 +260,13 @@ static inline void atomic_dec(atomic_t *v)
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
 #define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
 
-#define atomic_add_unless(v, a, u)				\
+#define __atomic_add_unless(v, a, u)				\
 ({								\
 	int c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
-	c != (u);						\
+	c;							\
 })
 
 
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 1924889..1914f17 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -197,15 +197,15 @@ static __inline__ int atomic_read(const atomic_t *v)
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -217,7 +217,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
@@ -316,7 +316,7 @@ atomic64_read(const atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index b2bcbee..952e161 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -181,21 +181,21 @@ static __inline__ int atomic_dec_return(atomic_t *v)
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int t;
 
 	__asm__ __volatile__ (
 	PPC_RELEASE_BARRIER
-"1:	lwarx	%0,0,%1		# atomic_add_unless\n\
+"1:	lwarx	%0,0,%1		# __atomic_add_unless\n\
 	cmpw	0,%0,%3 \n\
 	beq-	2f \n\
 	add	%0,%2,%0 \n"
@@ -209,7 +209,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 	: "r" (&v->counter), "r" (a), "r" (u)
 	: "cc", "memory");
 
-	return t != u;
+	return t;
 }
 
 
@@ -443,7 +443,7 @@ static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
@@ -451,7 +451,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 	__asm__ __volatile__ (
 	PPC_RELEASE_BARRIER
-"1:	ldarx	%0,0,%1		# atomic_add_unless\n\
+"1:	ldarx	%0,0,%1		# __atomic_add_unless\n\
 	cmpd	0,%0,%3 \n\
 	beq-	2f \n\
 	add	%0,%2,%0 \n"
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 29d7563..7b0b0a7 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -93,7 +93,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return old;
 }
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -105,7 +105,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != u;
+	return c;
 }
 
 
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index 8ddb263..2177596 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -38,15 +38,15 @@
 #define atomic_cmpxchg(v, o, n)		(cmpxchg(&((v)->counter), (o), (n)))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -59,7 +59,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 		c = old;
 	}
 
-	return c != (u);
+	return c;
 }
 
 #define smp_mb__before_atomic_dec()	smp_mb()
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 7646f2c..bdce95e 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -22,7 +22,7 @@
 extern int __atomic_add_return(int, atomic_t *);
 extern int atomic_cmpxchg(atomic_t *, int, int);
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-extern int atomic_add_unless(atomic_t *, int, int);
+extern int __atomic_add_unless(atomic_t *, int, int);
 extern void atomic_set(atomic_t *, int);
 
 #define atomic_read(v)          (*(volatile int *)&(v)->counter)
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 337139e..1fc3d0a 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -70,7 +70,7 @@ extern long atomic64_sub_ret(long, atomic64_t *);
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -82,7 +82,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 246feed..c03349e 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -81,18 +81,18 @@ static inline int atomic_add_return(int i, atomic_t *v)
 }
 
 /**
- * atomic_add_unless - add unless the number is already a given value
+ * __atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	smp_mb();  /* barrier for proper semantics */
-	return _atomic_xchg_add_unless(v, a, u) != u;
+	return _atomic_xchg_add_unless(v, a, u);
 }
 
 /**
@@ -199,7 +199,7 @@ static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
 {
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index a48dda3..27fe667 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -64,7 +64,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	return val;
 }
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int guess, oldval = v->counter;
 	do {
@@ -73,7 +73,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 		guess = oldval;
 		oldval = atomic_cmpxchg(v, guess, guess + a);
 	} while (guess != oldval);
-	return oldval != u;
+	return oldval;
 }
 
 /* Now the true 64-bit operations. */
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 897969b..5fe9cb3 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -221,15 +221,15 @@ static inline int atomic_xchg(atomic_t *v, int new)
 }
 
 /**
- * atomic_add_unless - add unless the number is already a given value
+ * __atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -241,7 +241,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 2a934aa..24098aa 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -263,7 +263,7 @@ static inline int atomic64_add_negative(long long i, atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 49fd1ea..017594d 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -202,7 +202,7 @@ static inline long atomic64_xchg(atomic64_t *v, long new)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index 7cca2fb..e464212 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -225,15 +225,15 @@ static inline int atomic_sub_return(int i, atomic_t * v)
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -245,7 +245,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 7f84414..bd18bfd 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -129,13 +129,13 @@ static inline void atomic_dec(atomic_t *v)
 
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
   int c, old;
   c = atomic_read(v);
   while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
     c = old;
-  return c != u;
+  return c;
 }
 
 static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index ed0eb23..fc31190 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -3,6 +3,20 @@
 #include <asm/atomic.h>
 
 /**
+ * atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	return __atomic_add_unless(v, a, u) != u;
+}
+
+/**
  * atomic_inc_not_zero - increment unless the number is zero
  * @v: pointer of type atomic_t
  *
-- 
1.7.4

