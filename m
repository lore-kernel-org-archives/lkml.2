Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0EQWpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:45:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab0EQWpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:45:45 -0400
Date: Tue, 18 May 2010 00:45:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/atomic changes for v2.6.35
Message-ID: <20100517224531.GA27400@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4778]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-atomic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-atomic-for-linus


out-of-topic modifications in x86-atomic-for-linus:
---------------------------------------------------
lib/Makefile                       # 86a8938: lib: Add self-test for atomic64_t
lib/atomic64.c                     # 9757789: lib: Fix atomic64_add_unless retu
lib/atomic64_test.c                # a5c9161: x86, atomic64: In selftest, disti
                                   # 25a304f: lib: Fix atomic64_inc_not_zero te
                                   # 9efbcd5: lib: Fix atomic64_add_unless test
                                   # d7f6de1: x86: Implement atomic[64]_dec_if_
                                   # 8f4f202: lib: Only test atomic64_dec_if_po
                                   # 86a8938: lib: Add self-test for atomic64_t

( Note, the shortlog and diffstat is relative to the
  previous x86/asm tree. )

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, atomic64: In selftest, distinguish x86-64 from 586+
      x86: Fix LOCK_PREFIX_HERE for uniprocessor build

Luca Barbieri (11):
      x86: Add support for lock prefix in alternatives
      x86-32: Allow UP/SMP lock replacement in cmpxchg64
      lib: Add self-test for atomic64_t
      x86-32: Rewrite 32-bit atomic64 functions in assembly
      lib: Only test atomic64_dec_if_positive on archs having it
      x86: Implement atomic[64]_dec_if_positive()
      lib: Fix atomic64_add_unless test
      x86-32: Fix atomic64_add_unless return value convention
      lib: Fix atomic64_add_unless return value convention
      lib: Fix atomic64_inc_not_zero test
      x86-32: Fix atomic64_inc_not_zero return value convention


 arch/x86/include/asm/alternative.h |    9 +-
 arch/x86/include/asm/atomic.h      |   23 +++
 arch/x86/include/asm/atomic64_32.h |  278 +++++++++++++++++++++++++++---------
 arch/x86/include/asm/atomic64_64.h |   23 +++
 arch/x86/include/asm/cmpxchg_32.h  |    3 +-
 arch/x86/kernel/alternative.c      |    6 +-
 arch/x86/lib/Makefile              |    3 +-
 arch/x86/lib/atomic64_32.c         |  273 +++++++----------------------------
 arch/x86/lib/atomic64_386_32.S     |  174 ++++++++++++++++++++++
 arch/x86/lib/atomic64_cx8_32.S     |  224 +++++++++++++++++++++++++++++
 lib/Kconfig.debug                  |    7 +
 lib/Makefile                       |    2 +
 lib/atomic64.c                     |    4 +-
 lib/atomic64_test.c                |  164 +++++++++++++++++++++
 14 files changed, 895 insertions(+), 298 deletions(-)
 create mode 100644 arch/x86/lib/atomic64_386_32.S
 create mode 100644 arch/x86/lib/atomic64_cx8_32.S
 create mode 100644 lib/atomic64_test.c

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 714bf24..92a9033 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -28,14 +28,17 @@
  */
 
 #ifdef CONFIG_SMP
-#define LOCK_PREFIX \
+#define LOCK_PREFIX_HERE \
 		".section .smp_locks,\"a\"\n"	\
 		".balign 4\n"			\
-		".long 661f - .\n" /* offset */	\
+		".long 671f - .\n" /* offset */	\
 		".previous\n"			\
-		"661:\n\tlock; "
+		"671:"
+
+#define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
 
 #else /* ! CONFIG_SMP */
+#define LOCK_PREFIX_HERE ""
 #define LOCK_PREFIX ""
 #endif
 
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 8f8217b..706c694 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -246,6 +246,29 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
+/*
+ * atomic_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+static inline int atomic_dec_if_positive(atomic_t *v)
+{
+	int c, old, dec;
+	c = atomic_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
 /**
  * atomic_inc_short - increment of a short integer
  * @v: pointer to type int
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 03027bf..2a934aa 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -14,109 +14,193 @@ typedef struct {
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
-extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
+#ifdef CONFIG_X86_CMPXCHG64
+#define ATOMIC64_ALTERNATIVE_(f, g) "call atomic64_" #g "_cx8"
+#else
+#define ATOMIC64_ALTERNATIVE_(f, g) ALTERNATIVE("call atomic64_" #f "_386", "call atomic64_" #g "_cx8", X86_FEATURE_CX8)
+#endif
+
+#define ATOMIC64_ALTERNATIVE(f) ATOMIC64_ALTERNATIVE_(f, f)
+
+/**
+ * atomic64_cmpxchg - cmpxchg atomic64 variable
+ * @p: pointer to type atomic64_t
+ * @o: expected value
+ * @n: new value
+ *
+ * Atomically sets @v to @n if it was equal to @o and returns
+ * the old value.
+ */
+
+static inline long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
+{
+	return cmpxchg64(&v->counter, o, n);
+}
 
 /**
  * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
+ * @v: pointer to type atomic64_t
+ * @n: value to assign
  *
- * Atomically xchgs the value of @ptr to @new_val and returns
+ * Atomically xchgs the value of @v to @n and returns
  * the old value.
  */
-extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
+static inline long long atomic64_xchg(atomic64_t *v, long long n)
+{
+	long long o;
+	unsigned high = (unsigned)(n >> 32);
+	unsigned low = (unsigned)n;
+	asm volatile(ATOMIC64_ALTERNATIVE(xchg)
+		     : "=A" (o), "+b" (low), "+c" (high)
+		     : "S" (v)
+		     : "memory"
+		     );
+	return o;
+}
 
 /**
  * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
+ * @v: pointer to type atomic64_t
+ * @n: value to assign
  *
- * Atomically sets the value of @ptr to @new_val.
+ * Atomically sets the value of @v to @n.
  */
-extern void atomic64_set(atomic64_t *ptr, u64 new_val);
+static inline void atomic64_set(atomic64_t *v, long long i)
+{
+	unsigned high = (unsigned)(i >> 32);
+	unsigned low = (unsigned)i;
+	asm volatile(ATOMIC64_ALTERNATIVE(set)
+		     : "+b" (low), "+c" (high)
+		     : "S" (v)
+		     : "eax", "edx", "memory"
+		     );
+}
 
 /**
  * atomic64_read - read atomic64 variable
- * @ptr:      pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically reads the value of @ptr and returns it.
+ * Atomically reads the value of @v and returns it.
  */
-static inline u64 atomic64_read(atomic64_t *ptr)
+static inline long long atomic64_read(atomic64_t *v)
 {
-	u64 res;
-
-	/*
-	 * Note, we inline this atomic64_t primitive because
-	 * it only clobbers EAX/EDX and leaves the others
-	 * untouched. We also (somewhat subtly) rely on the
-	 * fact that cmpxchg8b returns the current 64-bit value
-	 * of the memory location we are touching:
-	 */
-	asm volatile(
-		"mov %%ebx, %%eax\n\t"
-		"mov %%ecx, %%edx\n\t"
-		LOCK_PREFIX "cmpxchg8b %1\n"
-			: "=&A" (res)
-			: "m" (*ptr)
-		);
-
-	return res;
-}
-
-extern u64 atomic64_read(atomic64_t *ptr);
+	long long r;
+	asm volatile(ATOMIC64_ALTERNATIVE(read)
+		     : "=A" (r), "+c" (v)
+		     : : "memory"
+		     );
+	return r;
+ }
 
 /**
  * atomic64_add_return - add and return
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
  *
- * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ * Atomically adds @i to @v and returns @i + *@v
  */
-extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_add_return(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE(add_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
 
 /*
  * Other variants with different arithmetic operators:
  */
-extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
-extern u64 atomic64_inc_return(atomic64_t *ptr);
-extern u64 atomic64_dec_return(atomic64_t *ptr);
+static inline long long atomic64_sub_return(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE(sub_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
+
+static inline long long atomic64_inc_return(atomic64_t *v)
+{
+	long long a;
+	asm volatile(ATOMIC64_ALTERNATIVE(inc_return)
+		     : "=A" (a)
+		     : "S" (v)
+		     : "memory", "ecx"
+		     );
+	return a;
+}
+
+static inline long long atomic64_dec_return(atomic64_t *v)
+{
+	long long a;
+	asm volatile(ATOMIC64_ALTERNATIVE(dec_return)
+		     : "=A" (a)
+		     : "S" (v)
+		     : "memory", "ecx"
+		     );
+	return a;
+}
 
 /**
  * atomic64_add - add integer to atomic64 variable
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
  *
- * Atomically adds @delta to @ptr.
+ * Atomically adds @i to @v.
  */
-extern void atomic64_add(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_add(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(add, add_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
 
 /**
  * atomic64_sub - subtract the atomic64 variable
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
  *
- * Atomically subtracts @delta from @ptr.
+ * Atomically subtracts @i from @v.
  */
-extern void atomic64_sub(u64 delta, atomic64_t *ptr);
+static inline long long atomic64_sub(long long i, atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(sub, sub_return)
+		     : "+A" (i), "+c" (v)
+		     : : "memory"
+		     );
+	return i;
+}
 
 /**
  * atomic64_sub_and_test - subtract value from variable and test result
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr and returns
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
+  *
+ * Atomically subtracts @i from @v and returns
  * true if the result is zero, or false for all
  * other cases.
  */
-extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
+static inline int atomic64_sub_and_test(long long i, atomic64_t *v)
+{
+	return atomic64_sub_return(i, v) == 0;
+}
 
 /**
  * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically increments @ptr by 1.
+ * Atomically increments @v by 1.
  */
-extern void atomic64_inc(atomic64_t *ptr);
+static inline void atomic64_inc(atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(inc, inc_return)
+		     : : "S" (v)
+		     : "memory", "eax", "ecx", "edx"
+		     );
+}
 
 /**
  * atomic64_dec - decrement atomic64 variable
@@ -124,37 +208,97 @@ extern void atomic64_inc(atomic64_t *ptr);
  *
  * Atomically decrements @ptr by 1.
  */
-extern void atomic64_dec(atomic64_t *ptr);
+static inline void atomic64_dec(atomic64_t *v)
+{
+	asm volatile(ATOMIC64_ALTERNATIVE_(dec, dec_return)
+		     : : "S" (v)
+		     : "memory", "eax", "ecx", "edx"
+		     );
+}
 
 /**
  * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically decrements @ptr by 1 and
+ * Atomically decrements @v by 1 and
  * returns true if the result is 0, or false for all other
  * cases.
  */
-extern int atomic64_dec_and_test(atomic64_t *ptr);
+static inline int atomic64_dec_and_test(atomic64_t *v)
+{
+	return atomic64_dec_return(v) == 0;
+}
 
 /**
  * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
+ * @v: pointer to type atomic64_t
  *
- * Atomically increments @ptr by 1
+ * Atomically increments @v by 1
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-extern int atomic64_inc_and_test(atomic64_t *ptr);
+static inline int atomic64_inc_and_test(atomic64_t *v)
+{
+	return atomic64_inc_return(v) == 0;
+}
 
 /**
  * atomic64_add_negative - add and test if negative
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
  *
- * Atomically adds @delta to @ptr and returns true
+ * Atomically adds @i to @v and returns true
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
+static inline int atomic64_add_negative(long long i, atomic64_t *v)
+{
+	return atomic64_add_return(i, v) < 0;
+}
+
+/**
+ * atomic64_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
+{
+	unsigned low = (unsigned)u;
+	unsigned high = (unsigned)(u >> 32);
+	asm volatile(ATOMIC64_ALTERNATIVE(add_unless) "\n\t"
+		     : "+A" (a), "+c" (v), "+S" (low), "+D" (high)
+		     : : "memory");
+	return (int)a;
+}
+
+
+static inline int atomic64_inc_not_zero(atomic64_t *v)
+{
+	int r;
+	asm volatile(ATOMIC64_ALTERNATIVE(inc_not_zero)
+		     : "=a" (r)
+		     : "S" (v)
+		     : "ecx", "edx", "memory"
+		     );
+	return r;
+}
+
+static inline long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long long r;
+	asm volatile(ATOMIC64_ALTERNATIVE(dec_if_positive)
+		     : "=A" (r)
+		     : "S" (v)
+		     : "ecx", "memory"
+		     );
+	return r;
+}
+
+#undef ATOMIC64_ALTERNATIVE
+#undef ATOMIC64_ALTERNATIVE_
 
 #endif /* _ASM_X86_ATOMIC64_32_H */
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 51c5b40..4d6e2cd 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -221,4 +221,27 @@ static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
+/*
+ * atomic64_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+static inline long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long c, old, dec;
+	c = atomic64_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic64_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
 #endif /* _ASM_X86_ATOMIC64_64_H */
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index ffb9bb6..8859e12 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -271,7 +271,8 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 	__typeof__(*(ptr)) __ret;				\
 	__typeof__(*(ptr)) __old = (o);				\
 	__typeof__(*(ptr)) __new = (n);				\
-	alternative_io("call cmpxchg8b_emu",			\
+	alternative_io(LOCK_PREFIX_HERE				\
+			"call cmpxchg8b_emu",			\
 			"lock; cmpxchg8b (%%esi)" ,		\
 		       X86_FEATURE_CX8,				\
 		       "=A" (__ret),				\
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 9367384..7023773 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -247,7 +247,8 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		text_poke(ptr, ((unsigned char []){0xf0}), 1);
+		if (*ptr == 0x3e)
+			text_poke(ptr, ((unsigned char []){0xf0}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
@@ -267,7 +268,8 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn lock prefix into DS segment override prefix */
-		text_poke(ptr, ((unsigned char []){0x3E}), 1);
+		if (*ptr == 0xf0)
+			text_poke(ptr, ((unsigned char []){0x3E}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 419386c..3ac4a8a 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -26,11 +26,12 @@ obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
+        lib-y += atomic64_cx8_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
-        lib-y += cmpxchg8b_emu.o
+        lib-y += cmpxchg8b_emu.o atomic64_386_32.o
 endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 824fa0b..540179e 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -6,225 +6,54 @@
 #include <asm/cmpxchg.h>
 #include <asm/atomic.h>
 
-static noinline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
-{
-	u32 low = new;
-	u32 high = new >> 32;
-
-	asm volatile(
-		LOCK_PREFIX "cmpxchg8b %1\n"
-		     : "+A" (old), "+m" (*ptr)
-		     :  "b" (low),  "c" (high)
-		     );
-	return old;
-}
-
-u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val)
-{
-	return cmpxchg8b(&ptr->counter, old_val, new_val);
-}
-EXPORT_SYMBOL(atomic64_cmpxchg);
-
-/**
- * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically xchgs the value of @ptr to @new_val and returns
- * the old value.
- */
-u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
-{
-	/*
-	 * Try first with a (possibly incorrect) assumption about
-	 * what we have there. We'll do two loops most likely,
-	 * but we'll get an ownership MESI transaction straight away
-	 * instead of a read transaction followed by a
-	 * flush-for-ownership transaction:
-	 */
-	u64 old_val, real_val = 0;
-
-	do {
-		old_val = real_val;
-
-		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
-
-	} while (real_val != old_val);
-
-	return old_val;
-}
-EXPORT_SYMBOL(atomic64_xchg);
-
-/**
- * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically sets the value of @ptr to @new_val.
- */
-void atomic64_set(atomic64_t *ptr, u64 new_val)
-{
-	atomic64_xchg(ptr, new_val);
-}
-EXPORT_SYMBOL(atomic64_set);
-
-/**
-EXPORT_SYMBOL(atomic64_read);
- * atomic64_add_return - add and return
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns @delta + *@ptr
- */
-noinline u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
-{
-	/*
-	 * Try first with a (possibly incorrect) assumption about
-	 * what we have there. We'll do two loops most likely,
-	 * but we'll get an ownership MESI transaction straight away
-	 * instead of a read transaction followed by a
-	 * flush-for-ownership transaction:
-	 */
-	u64 old_val, new_val, real_val = 0;
-
-	do {
-		old_val = real_val;
-		new_val = old_val + delta;
-
-		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
-
-	} while (real_val != old_val);
-
-	return new_val;
-}
-EXPORT_SYMBOL(atomic64_add_return);
-
-u64 atomic64_sub_return(u64 delta, atomic64_t *ptr)
-{
-	return atomic64_add_return(-delta, ptr);
-}
-EXPORT_SYMBOL(atomic64_sub_return);
-
-u64 atomic64_inc_return(atomic64_t *ptr)
-{
-	return atomic64_add_return(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_inc_return);
-
-u64 atomic64_dec_return(atomic64_t *ptr)
-{
-	return atomic64_sub_return(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_dec_return);
-
-/**
- * atomic64_add - add integer to atomic64 variable
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr.
- */
-void atomic64_add(u64 delta, atomic64_t *ptr)
-{
-	atomic64_add_return(delta, ptr);
-}
-EXPORT_SYMBOL(atomic64_add);
-
-/**
- * atomic64_sub - subtract the atomic64 variable
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr.
- */
-void atomic64_sub(u64 delta, atomic64_t *ptr)
-{
-	atomic64_add(-delta, ptr);
-}
-EXPORT_SYMBOL(atomic64_sub);
-
-/**
- * atomic64_sub_and_test - subtract value from variable and test result
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-int atomic64_sub_and_test(u64 delta, atomic64_t *ptr)
-{
-	u64 new_val = atomic64_sub_return(delta, ptr);
-
-	return new_val == 0;
-}
-EXPORT_SYMBOL(atomic64_sub_and_test);
-
-/**
- * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1.
- */
-void atomic64_inc(atomic64_t *ptr)
-{
-	atomic64_add(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_inc);
-
-/**
- * atomic64_dec - decrement atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1.
- */
-void atomic64_dec(atomic64_t *ptr)
-{
-	atomic64_sub(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_dec);
-
-/**
- * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-int atomic64_dec_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(1, ptr);
-}
-EXPORT_SYMBOL(atomic64_dec_and_test);
-
-/**
- * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-int atomic64_inc_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(-1, ptr);
-}
-EXPORT_SYMBOL(atomic64_inc_and_test);
-
-/**
- * atomic64_add_negative - add and test if negative
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-int atomic64_add_negative(u64 delta, atomic64_t *ptr)
-{
-	s64 new_val = atomic64_add_return(delta, ptr);
-
-	return new_val < 0;
-}
-EXPORT_SYMBOL(atomic64_add_negative);
+long long atomic64_read_cx8(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_read_cx8);
+long long atomic64_set_cx8(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_set_cx8);
+long long atomic64_xchg_cx8(long long, unsigned high);
+EXPORT_SYMBOL(atomic64_xchg_cx8);
+long long atomic64_add_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_add_return_cx8);
+long long atomic64_sub_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_sub_return_cx8);
+long long atomic64_inc_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_return_cx8);
+long long atomic64_dec_return_cx8(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_return_cx8);
+long long atomic64_dec_if_positive_cx8(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_if_positive_cx8);
+int atomic64_inc_not_zero_cx8(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_not_zero_cx8);
+int atomic64_add_unless_cx8(atomic64_t *v, long long a, long long u);
+EXPORT_SYMBOL(atomic64_add_unless_cx8);
+
+#ifndef CONFIG_X86_CMPXCHG64
+long long atomic64_read_386(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_read_386);
+long long atomic64_set_386(long long, const atomic64_t *v);
+EXPORT_SYMBOL(atomic64_set_386);
+long long atomic64_xchg_386(long long, unsigned high);
+EXPORT_SYMBOL(atomic64_xchg_386);
+long long atomic64_add_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_add_return_386);
+long long atomic64_sub_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_sub_return_386);
+long long atomic64_inc_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_return_386);
+long long atomic64_dec_return_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_return_386);
+long long atomic64_add_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_add_386);
+long long atomic64_sub_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_sub_386);
+long long atomic64_inc_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_386);
+long long atomic64_dec_386(long long a, atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_386);
+long long atomic64_dec_if_positive_386(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_dec_if_positive_386);
+int atomic64_inc_not_zero_386(atomic64_t *v);
+EXPORT_SYMBOL(atomic64_inc_not_zero_386);
+int atomic64_add_unless_386(atomic64_t *v, long long a, long long u);
+EXPORT_SYMBOL(atomic64_add_unless_386);
+#endif
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
new file mode 100644
index 0000000..4a5979a
--- /dev/null
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -0,0 +1,174 @@
+/*
+ * atomic64_t for 386/486
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+/* if you want SMP support, implement these with real spinlocks */
+.macro LOCK reg
+	pushfl
+	CFI_ADJUST_CFA_OFFSET 4
+	cli
+.endm
+
+.macro UNLOCK reg
+	popfl
+	CFI_ADJUST_CFA_OFFSET -4
+.endm
+
+.macro BEGIN func reg
+$v = \reg
+
+ENTRY(atomic64_\func\()_386)
+	CFI_STARTPROC
+	LOCK $v
+
+.macro RETURN
+	UNLOCK $v
+	ret
+.endm
+
+.macro END_
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_386)
+.purgem RETURN
+.purgem END_
+.purgem END
+.endm
+
+.macro END
+RETURN
+END_
+.endm
+.endm
+
+BEGIN read %ecx
+	movl  ($v), %eax
+	movl 4($v), %edx
+END
+
+BEGIN set %esi
+	movl %ebx,  ($v)
+	movl %ecx, 4($v)
+END
+
+BEGIN xchg %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	movl %ebx,  ($v)
+	movl %ecx, 4($v)
+END
+
+BEGIN add %ecx
+	addl %eax,  ($v)
+	adcl %edx, 4($v)
+END
+
+BEGIN add_return %ecx
+	addl  ($v), %eax
+	adcl 4($v), %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN sub %ecx
+	subl %eax,  ($v)
+	sbbl %edx, 4($v)
+END
+
+BEGIN sub_return %ecx
+	negl %edx
+	negl %eax
+	sbbl $0, %edx
+	addl  ($v), %eax
+	adcl 4($v), %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN inc %esi
+	addl $1,  ($v)
+	adcl $0, 4($v)
+END
+
+BEGIN inc_return %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	addl $1, %eax
+	adcl $0, %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN dec %esi
+	subl $1,  ($v)
+	sbbl $0, 4($v)
+END
+
+BEGIN dec_return %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	subl $1, %eax
+	sbbl $0, %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+END
+
+BEGIN add_unless %ecx
+	addl %eax, %esi
+	adcl %edx, %edi
+	addl  ($v), %eax
+	adcl 4($v), %edx
+	cmpl %eax, %esi
+	je 3f
+1:
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+	movl $1, %eax
+2:
+RETURN
+3:
+	cmpl %edx, %edi
+	jne 1b
+	xorl %eax, %eax
+	jmp 2b
+END_
+
+BEGIN inc_not_zero %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	testl %eax, %eax
+	je 3f
+1:
+	addl $1, %eax
+	adcl $0, %edx
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+	movl $1, %eax
+2:
+RETURN
+3:
+	testl %edx, %edx
+	jne 1b
+	jmp 2b
+END_
+
+BEGIN dec_if_positive %esi
+	movl  ($v), %eax
+	movl 4($v), %edx
+	subl $1, %eax
+	sbbl $0, %edx
+	js 1f
+	movl %eax,  ($v)
+	movl %edx, 4($v)
+1:
+END
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
new file mode 100644
index 0000000..71e080d
--- /dev/null
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -0,0 +1,224 @@
+/*
+ * atomic64_t for 586+
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+.macro SAVE reg
+	pushl %\reg
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET \reg, 0
+.endm
+
+.macro RESTORE reg
+	popl %\reg
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE \reg
+.endm
+
+.macro read64 reg
+	movl %ebx, %eax
+	movl %ecx, %edx
+/* we need LOCK_PREFIX since otherwise cmpxchg8b always does the write */
+	LOCK_PREFIX
+	cmpxchg8b (\reg)
+.endm
+
+ENTRY(atomic64_read_cx8)
+	CFI_STARTPROC
+
+	read64 %ecx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_read_cx8)
+
+ENTRY(atomic64_set_cx8)
+	CFI_STARTPROC
+
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes
+ * are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_set_cx8)
+
+ENTRY(atomic64_xchg_cx8)
+	CFI_STARTPROC
+
+	movl %ebx, %eax
+	movl %ecx, %edx
+1:
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_xchg_cx8)
+
+.macro addsub_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+	SAVE esi
+	SAVE edi
+
+	movl %eax, %esi
+	movl %edx, %edi
+	movl %ecx, %ebp
+
+	read64 %ebp
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l %esi, %ebx
+	\insc\()l %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE edi
+	RESTORE esi
+	RESTORE ebx
+	RESTORE ebp
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+addsub_return add add adc
+addsub_return sub sub sbb
+
+.macro incdec_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l $1, %ebx
+	\insc\()l $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+incdec_return inc add adc
+incdec_return dec sub sbb
+
+ENTRY(atomic64_dec_if_positive_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	subl $1, %ebx
+	sbb $0, %ecx
+	js 2f
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+2:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_dec_if_positive_cx8)
+
+ENTRY(atomic64_add_unless_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+/* these just push these two parameters on the stack */
+	SAVE edi
+	SAVE esi
+
+	movl %ecx, %ebp
+	movl %eax, %esi
+	movl %edx, %edi
+
+	read64 %ebp
+1:
+	cmpl %eax, 0(%esp)
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl %esi, %ebx
+	adcl %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+	movl $1, %eax
+3:
+	addl $8, %esp
+	CFI_ADJUST_CFA_OFFSET -8
+	RESTORE ebx
+	RESTORE ebp
+	ret
+4:
+	cmpl %edx, 4(%esp)
+	jne 2b
+	xorl %eax, %eax
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_add_unless_cx8)
+
+ENTRY(atomic64_inc_not_zero_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	testl %eax, %eax
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl $1, %ebx
+	adcl $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	movl $1, %eax
+3:
+	RESTORE ebx
+	ret
+4:
+	testl %edx, %edx
+	jne 2b
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_inc_not_zero_cx8)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..2313840 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1086,6 +1086,13 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
+config ATOMIC64_SELFTEST
+	bool "Perform an atomic64_t self-test at boot"
+	help
+	  Enable this option to test the atomic64_t functions at boot.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index 0d40152..af759f3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -101,6 +101,8 @@ obj-$(CONFIG_GENERIC_CSUM) += checksum.o
 
 obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
 
+obj-$(CONFIG_ATOMIC64_SELFTEST) += atomic64_test.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/atomic64.c b/lib/atomic64.c
index 8bee16e..a21c12b 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -162,12 +162,12 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	unsigned long flags;
 	spinlock_t *lock = lock_addr(v);
-	int ret = 1;
+	int ret = 0;
 
 	spin_lock_irqsave(lock, flags);
 	if (v->counter != u) {
 		v->counter += a;
-		ret = 0;
+		ret = 1;
 	}
 	spin_unlock_irqrestore(lock, flags);
 	return ret;
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
new file mode 100644
index 0000000..65e482c
--- /dev/null
+++ b/lib/atomic64_test.c
@@ -0,0 +1,164 @@
+/*
+ * Testsuite for atomic64_t functions
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/init.h>
+#include <asm/atomic.h>
+
+#define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
+static __init int test_atomic64(void)
+{
+	long long v0 = 0xaaa31337c001d00dLL;
+	long long v1 = 0xdeadbeefdeafcafeLL;
+	long long v2 = 0xfaceabadf00df001LL;
+	long long onestwos = 0x1111111122222222LL;
+	long long one = 1LL;
+
+	atomic64_t v = ATOMIC64_INIT(v0);
+	long long r = v0;
+	BUG_ON(v.counter != r);
+
+	atomic64_set(&v, v1);
+	r = v1;
+	BUG_ON(v.counter != r);
+	BUG_ON(atomic64_read(&v) != r);
+
+	INIT(v0);
+	atomic64_add(onestwos, &v);
+	r += onestwos;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_add(-one, &v);
+	r += -one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r += onestwos;
+	BUG_ON(atomic64_add_return(onestwos, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r += -one;
+	BUG_ON(atomic64_add_return(-one, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_sub(onestwos, &v);
+	r -= onestwos;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_sub(-one, &v);
+	r -= -one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r -= onestwos;
+	BUG_ON(atomic64_sub_return(onestwos, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r -= -one;
+	BUG_ON(atomic64_sub_return(-one, &v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_inc(&v);
+	r += one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r += one;
+	BUG_ON(atomic64_inc_return(&v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	atomic64_dec(&v);
+	r -= one;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	r -= one;
+	BUG_ON(atomic64_dec_return(&v) != r);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_xchg(&v, v1) != v0);
+	r = v1;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_cmpxchg(&v, v0, v1) != v0);
+	r = v1;
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_cmpxchg(&v, v2, v1) != v0);
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(atomic64_add_unless(&v, one, v0));
+	BUG_ON(v.counter != r);
+
+	INIT(v0);
+	BUG_ON(!atomic64_add_unless(&v, one, v1));
+	r += one;
+	BUG_ON(v.counter != r);
+
+#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(_ASM_GENERIC_ATOMIC64_H)
+	INIT(onestwos);
+	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
+	r -= one;
+	BUG_ON(v.counter != r);
+
+	INIT(0);
+	BUG_ON(atomic64_dec_if_positive(&v) != -one);
+	BUG_ON(v.counter != r);
+
+	INIT(-one);
+	BUG_ON(atomic64_dec_if_positive(&v) != (-one - one));
+	BUG_ON(v.counter != r);
+#else
+#warning Please implement atomic64_dec_if_positive for your architecture, and add it to the IF above
+#endif
+
+	INIT(onestwos);
+	BUG_ON(!atomic64_inc_not_zero(&v));
+	r += one;
+	BUG_ON(v.counter != r);
+
+	INIT(0);
+	BUG_ON(atomic64_inc_not_zero(&v));
+	BUG_ON(v.counter != r);
+
+	INIT(-one);
+	BUG_ON(!atomic64_inc_not_zero(&v));
+	r += one;
+	BUG_ON(v.counter != r);
+
+#ifdef CONFIG_X86
+	printk(KERN_INFO "atomic64 test passed for %s platform %s CX8 and %s SSE\n",
+#ifdef CONFIG_X86_64
+	       "x86-64",
+#elif defined(CONFIG_X86_CMPXCHG64)
+	       "i586+",
+#else
+	       "i386+",
+#endif
+	       boot_cpu_has(X86_FEATURE_CX8) ? "with" : "without",
+	       boot_cpu_has(X86_FEATURE_XMM) ? "with" : "without");
+#else
+	printk(KERN_INFO "atomic64 test passed\n");
+#endif
+
+	return 0;
+}
+
+core_initcall(test_atomic64);
