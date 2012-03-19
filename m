Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2CSQUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:20:12 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:37364 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162094Ab2CSQUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:20:04 -0400
Date: Mon, 19 Mar 2012 17:19:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/atomic changes for v3.4
Message-ID: <20120319161959.GA8488@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-atomic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-atomic-for-linus

   HEAD: cb8095bba6d24118135a5683a956f4f4fb5f17bb x86: atomic64 assembly improvements

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86: Adjust asm constraints in atomic64 wrappers
      x86: atomic64 assembly improvements


 arch/x86/include/asm/alternative.h |    6 ++
 arch/x86/include/asm/atomic64_32.h |  146 +++++++++++++++++++----------------
 arch/x86/lib/atomic64_32.c         |   59 +--------------
 arch/x86/lib/atomic64_386_32.S     |    6 +-
 arch/x86/lib/atomic64_cx8_32.S     |   29 +++-----
 5 files changed, 101 insertions(+), 145 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 37ad100..49331be 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -145,6 +145,12 @@ static inline int alternatives_text_reserved(void *start, void *end)
  */
 #define ASM_OUTPUT2(a...) a
 
+/*
+ * use this macro if you need clobbers but no inputs in
+ * alternative_{input,io,call}()
+ */
+#define ASM_NO_INPUT_CLOBBER(clbr...) "i" (0) : clbr
+
 struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
 void apply_paravirt(struct paravirt_patch_site *start,
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index fa13f0e..1981199 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -14,13 +14,52 @@ typedef struct {
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
+#define __ATOMIC64_DECL(sym) void atomic64_##sym(atomic64_t *, ...)
+#ifndef ATOMIC64_EXPORT
+#define ATOMIC64_DECL_ONE __ATOMIC64_DECL
+#else
+#define ATOMIC64_DECL_ONE(sym) __ATOMIC64_DECL(sym); \
+	ATOMIC64_EXPORT(atomic64_##sym)
+#endif
+
 #ifdef CONFIG_X86_CMPXCHG64
-#define ATOMIC64_ALTERNATIVE_(f, g) "call atomic64_" #g "_cx8"
+#define __alternative_atomic64(f, g, out, in...) \
+	asm volatile("call %P[func]" \
+		     : out : [func] "i" (atomic64_##g##_cx8), ## in)
+
+#define ATOMIC64_DECL(sym) ATOMIC64_DECL_ONE(sym##_cx8)
 #else
-#define ATOMIC64_ALTERNATIVE_(f, g) ALTERNATIVE("call atomic64_" #f "_386", "call atomic64_" #g "_cx8", X86_FEATURE_CX8)
+#define __alternative_atomic64(f, g, out, in...) \
+	alternative_call(atomic64_##f##_386, atomic64_##g##_cx8, \
+			 X86_FEATURE_CX8, ASM_OUTPUT2(out), ## in)
+
+#define ATOMIC64_DECL(sym) ATOMIC64_DECL_ONE(sym##_cx8); \
+	ATOMIC64_DECL_ONE(sym##_386)
+
+ATOMIC64_DECL_ONE(add_386);
+ATOMIC64_DECL_ONE(sub_386);
+ATOMIC64_DECL_ONE(inc_386);
+ATOMIC64_DECL_ONE(dec_386);
 #endif
 
-#define ATOMIC64_ALTERNATIVE(f) ATOMIC64_ALTERNATIVE_(f, f)
+#define alternative_atomic64(f, out, in...) \
+	__alternative_atomic64(f, f, ASM_OUTPUT2(out), ## in)
+
+ATOMIC64_DECL(read);
+ATOMIC64_DECL(set);
+ATOMIC64_DECL(xchg);
+ATOMIC64_DECL(add_return);
+ATOMIC64_DECL(sub_return);
+ATOMIC64_DECL(inc_return);
+ATOMIC64_DECL(dec_return);
+ATOMIC64_DECL(dec_if_positive);
+ATOMIC64_DECL(inc_not_zero);
+ATOMIC64_DECL(add_unless);
+
+#undef ATOMIC64_DECL
+#undef ATOMIC64_DECL_ONE
+#undef __ATOMIC64_DECL
+#undef ATOMIC64_EXPORT
 
 /**
  * atomic64_cmpxchg - cmpxchg atomic64 variable
@@ -50,11 +89,9 @@ static inline long long atomic64_xchg(atomic64_t *v, long long n)
 	long long o;
 	unsigned high = (unsigned)(n >> 32);
 	unsigned low = (unsigned)n;
-	asm volatile(ATOMIC64_ALTERNATIVE(xchg)
-		     : "=A" (o), "+b" (low), "+c" (high)
-		     : "S" (v)
-		     : "memory"
-		     );
+	alternative_atomic64(xchg, "=&A" (o),
+			     "S" (v), "b" (low), "c" (high)
+			     : "memory");
 	return o;
 }
 
@@ -69,11 +106,9 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 {
 	unsigned high = (unsigned)(i >> 32);
 	unsigned low = (unsigned)i;
-	asm volatile(ATOMIC64_ALTERNATIVE(set)
-		     : "+b" (low), "+c" (high)
-		     : "S" (v)
-		     : "eax", "edx", "memory"
-		     );
+	alternative_atomic64(set, /* no output */,
+			     "S" (v), "b" (low), "c" (high)
+			     : "eax", "edx", "memory");
 }
 
 /**
@@ -85,10 +120,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 static inline long long atomic64_read(const atomic64_t *v)
 {
 	long long r;
-	asm volatile(ATOMIC64_ALTERNATIVE(read)
-		     : "=A" (r), "+c" (v)
-		     : : "memory"
-		     );
+	alternative_atomic64(read, "=&A" (r), "c" (v) : "memory");
 	return r;
  }
 
@@ -101,10 +133,9 @@ static inline long long atomic64_read(const atomic64_t *v)
  */
 static inline long long atomic64_add_return(long long i, atomic64_t *v)
 {
-	asm volatile(ATOMIC64_ALTERNATIVE(add_return)
-		     : "+A" (i), "+c" (v)
-		     : : "memory"
-		     );
+	alternative_atomic64(add_return,
+			     ASM_OUTPUT2("+A" (i), "+c" (v)),
+			     ASM_NO_INPUT_CLOBBER("memory"));
 	return i;
 }
 
@@ -113,32 +144,25 @@ static inline long long atomic64_add_return(long long i, atomic64_t *v)
  */
 static inline long long atomic64_sub_return(long long i, atomic64_t *v)
 {
-	asm volatile(ATOMIC64_ALTERNATIVE(sub_return)
-		     : "+A" (i), "+c" (v)
-		     : : "memory"
-		     );
+	alternative_atomic64(sub_return,
+			     ASM_OUTPUT2("+A" (i), "+c" (v)),
+			     ASM_NO_INPUT_CLOBBER("memory"));
 	return i;
 }
 
 static inline long long atomic64_inc_return(atomic64_t *v)
 {
 	long long a;
-	asm volatile(ATOMIC64_ALTERNATIVE(inc_return)
-		     : "=A" (a)
-		     : "S" (v)
-		     : "memory", "ecx"
-		     );
+	alternative_atomic64(inc_return, "=&A" (a),
+			     "S" (v) : "memory", "ecx");
 	return a;
 }
 
 static inline long long atomic64_dec_return(atomic64_t *v)
 {
 	long long a;
-	asm volatile(ATOMIC64_ALTERNATIVE(dec_return)
-		     : "=A" (a)
-		     : "S" (v)
-		     : "memory", "ecx"
-		     );
+	alternative_atomic64(dec_return, "=&A" (a),
+			     "S" (v) : "memory", "ecx");
 	return a;
 }
 
@@ -151,10 +175,9 @@ static inline long long atomic64_dec_return(atomic64_t *v)
  */
 static inline long long atomic64_add(long long i, atomic64_t *v)
 {
-	asm volatile(ATOMIC64_ALTERNATIVE_(add, add_return)
-		     : "+A" (i), "+c" (v)
-		     : : "memory"
-		     );
+	__alternative_atomic64(add, add_return,
+			       ASM_OUTPUT2("+A" (i), "+c" (v)),
+			       ASM_NO_INPUT_CLOBBER("memory"));
 	return i;
 }
 
@@ -167,10 +190,9 @@ static inline long long atomic64_add(long long i, atomic64_t *v)
  */
 static inline long long atomic64_sub(long long i, atomic64_t *v)
 {
-	asm volatile(ATOMIC64_ALTERNATIVE_(sub, sub_return)
-		     : "+A" (i), "+c" (v)
-		     : : "memory"
-		     );
+	__alternative_atomic64(sub, sub_return,
+			       ASM_OUTPUT2("+A" (i), "+c" (v)),
+			       ASM_NO_INPUT_CLOBBER("memory"));
 	return i;
 }
 
@@ -196,10 +218,8 @@ static inline int atomic64_sub_and_test(long long i, atomic64_t *v)
  */
 static inline void atomic64_inc(atomic64_t *v)
 {
-	asm volatile(ATOMIC64_ALTERNATIVE_(inc, inc_return)
-		     : : "S" (v)
-		     : "memory", "eax", "ecx", "edx"
-		     );
+	__alternative_atomic64(inc, inc_return, /* no output */,
+			       "S" (v) : "memory", "eax", "ecx", "edx");
 }
 
 /**
@@ -210,10 +230,8 @@ static inline void atomic64_inc(atomic64_t *v)
  */
 static inline void atomic64_dec(atomic64_t *v)
 {
-	asm volatile(ATOMIC64_ALTERNATIVE_(dec, dec_return)
-		     : : "S" (v)
-		     : "memory", "eax", "ecx", "edx"
-		     );
+	__alternative_atomic64(dec, dec_return, /* no output */,
+			       "S" (v) : "memory", "eax", "ecx", "edx");
 }
 
 /**
@@ -263,15 +281,15 @@ static inline int atomic64_add_negative(long long i, atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns the old value of @v.
+ * Returns non-zero if the add was done, zero otherwise.
  */
 static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	unsigned low = (unsigned)u;
 	unsigned high = (unsigned)(u >> 32);
-	asm volatile(ATOMIC64_ALTERNATIVE(add_unless) "\n\t"
-		     : "+A" (a), "+c" (v), "+S" (low), "+D" (high)
-		     : : "memory");
+	alternative_atomic64(add_unless,
+			     ASM_OUTPUT2("+A" (a), "+c" (low), "+D" (high)),
+			     "S" (v) : "memory");
 	return (int)a;
 }
 
@@ -279,26 +297,20 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 static inline int atomic64_inc_not_zero(atomic64_t *v)
 {
 	int r;
-	asm volatile(ATOMIC64_ALTERNATIVE(inc_not_zero)
-		     : "=a" (r)
-		     : "S" (v)
-		     : "ecx", "edx", "memory"
-		     );
+	alternative_atomic64(inc_not_zero, "=&a" (r),
+			     "S" (v) : "ecx", "edx", "memory");
 	return r;
 }
 
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long long r;
-	asm volatile(ATOMIC64_ALTERNATIVE(dec_if_positive)
-		     : "=A" (r)
-		     : "S" (v)
-		     : "ecx", "memory"
-		     );
+	alternative_atomic64(dec_if_positive, "=&A" (r),
+			     "S" (v) : "ecx", "memory");
 	return r;
 }
 
-#undef ATOMIC64_ALTERNATIVE
-#undef ATOMIC64_ALTERNATIVE_
+#undef alternative_atomic64
+#undef __alternative_atomic64
 
 #endif /* _ASM_X86_ATOMIC64_32_H */
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 042f682..a0b4a35 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -1,59 +1,4 @@
-#include <linux/compiler.h>
-#include <linux/module.h>
-#include <linux/types.h>
+#define ATOMIC64_EXPORT EXPORT_SYMBOL
 
-#include <asm/processor.h>
-#include <asm/cmpxchg.h>
+#include <linux/export.h>
 #include <linux/atomic.h>
-
-long long atomic64_read_cx8(long long, const atomic64_t *v);
-EXPORT_SYMBOL(atomic64_read_cx8);
-long long atomic64_set_cx8(long long, const atomic64_t *v);
-EXPORT_SYMBOL(atomic64_set_cx8);
-long long atomic64_xchg_cx8(long long, unsigned high);
-EXPORT_SYMBOL(atomic64_xchg_cx8);
-long long atomic64_add_return_cx8(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_add_return_cx8);
-long long atomic64_sub_return_cx8(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_sub_return_cx8);
-long long atomic64_inc_return_cx8(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_inc_return_cx8);
-long long atomic64_dec_return_cx8(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_dec_return_cx8);
-long long atomic64_dec_if_positive_cx8(atomic64_t *v);
-EXPORT_SYMBOL(atomic64_dec_if_positive_cx8);
-int atomic64_inc_not_zero_cx8(atomic64_t *v);
-EXPORT_SYMBOL(atomic64_inc_not_zero_cx8);
-int atomic64_add_unless_cx8(atomic64_t *v, long long a, long long u);
-EXPORT_SYMBOL(atomic64_add_unless_cx8);
-
-#ifndef CONFIG_X86_CMPXCHG64
-long long atomic64_read_386(long long, const atomic64_t *v);
-EXPORT_SYMBOL(atomic64_read_386);
-long long atomic64_set_386(long long, const atomic64_t *v);
-EXPORT_SYMBOL(atomic64_set_386);
-long long atomic64_xchg_386(long long, unsigned high);
-EXPORT_SYMBOL(atomic64_xchg_386);
-long long atomic64_add_return_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_add_return_386);
-long long atomic64_sub_return_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_sub_return_386);
-long long atomic64_inc_return_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_inc_return_386);
-long long atomic64_dec_return_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_dec_return_386);
-long long atomic64_add_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_add_386);
-long long atomic64_sub_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_sub_386);
-long long atomic64_inc_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_inc_386);
-long long atomic64_dec_386(long long a, atomic64_t *v);
-EXPORT_SYMBOL(atomic64_dec_386);
-long long atomic64_dec_if_positive_386(atomic64_t *v);
-EXPORT_SYMBOL(atomic64_dec_if_positive_386);
-int atomic64_inc_not_zero_386(atomic64_t *v);
-EXPORT_SYMBOL(atomic64_inc_not_zero_386);
-int atomic64_add_unless_386(atomic64_t *v, long long a, long long u);
-EXPORT_SYMBOL(atomic64_add_unless_386);
-#endif
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index e8e7e0d..00933d5 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -137,13 +137,13 @@ BEGIN(dec_return)
 RET_ENDP
 #undef v
 
-#define v %ecx
+#define v %esi
 BEGIN(add_unless)
-	addl %eax, %esi
+	addl %eax, %ecx
 	adcl %edx, %edi
 	addl  (v), %eax
 	adcl 4(v), %edx
-	cmpl %eax, %esi
+	cmpl %eax, %ecx
 	je 3f
 1:
 	movl %eax,  (v)
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index 391a083..f5cc9eb 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -55,8 +55,6 @@ ENDPROC(atomic64_set_cx8)
 ENTRY(atomic64_xchg_cx8)
 	CFI_STARTPROC
 
-	movl %ebx, %eax
-	movl %ecx, %edx
 1:
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
@@ -78,7 +76,7 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %edi
 	movl %ecx, %ebp
 
-	read64 %ebp
+	read64 %ecx
 1:
 	movl %eax, %ebx
 	movl %edx, %ecx
@@ -159,23 +157,22 @@ ENTRY(atomic64_add_unless_cx8)
 	SAVE ebx
 /* these just push these two parameters on the stack */
 	SAVE edi
-	SAVE esi
+	SAVE ecx
 
-	movl %ecx, %ebp
-	movl %eax, %esi
+	movl %eax, %ebp
 	movl %edx, %edi
 
-	read64 %ebp
+	read64 %esi
 1:
 	cmpl %eax, 0(%esp)
 	je 4f
 2:
 	movl %eax, %ebx
 	movl %edx, %ecx
-	addl %esi, %ebx
+	addl %ebp, %ebx
 	adcl %edi, %ecx
 	LOCK_PREFIX
-	cmpxchg8b (%ebp)
+	cmpxchg8b (%esi)
 	jne 1b
 
 	movl $1, %eax
@@ -199,13 +196,13 @@ ENTRY(atomic64_inc_not_zero_cx8)
 
 	read64 %esi
 1:
-	testl %eax, %eax
-	je 4f
-2:
+	movl %eax, %ecx
+	orl %edx, %ecx
+	jz 3f
 	movl %eax, %ebx
-	movl %edx, %ecx
+	xorl %ecx, %ecx
 	addl $1, %ebx
-	adcl $0, %ecx
+	adcl %edx, %ecx
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -214,9 +211,5 @@ ENTRY(atomic64_inc_not_zero_cx8)
 3:
 	RESTORE ebx
 	ret
-4:
-	testl %edx, %edx
-	jne 2b
-	jmp 3b
 	CFI_ENDPROC
 ENDPROC(atomic64_inc_not_zero_cx8)
