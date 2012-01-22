Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2AVD7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:59:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2AVD7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:59:37 -0500
Date: Sat, 21 Jan 2012 19:59:12 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-819165fb34b9777f852429f2c6d6f79fbb71b9eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, luca@luca-barbieri.com, jbeulich@suse.com,
        JBeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, luca@luca-barbieri.com, JBeulich@suse.com,
        jbeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4F19A2A5020000780006E0D9@nat28.tlf.novell.com>
References: <4F19A2A5020000780006E0D9@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86: Adjust asm constraints in atomic64 wrappers
Git-Commit-ID: 819165fb34b9777f852429f2c6d6f79fbb71b9eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jan 2012 19:59:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  819165fb34b9777f852429f2c6d6f79fbb71b9eb
Gitweb:     http://git.kernel.org/tip/819165fb34b9777f852429f2c6d6f79fbb71b9eb
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 20 Jan 2012 16:21:41 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 20 Jan 2012 17:29:31 -0800

x86: Adjust asm constraints in atomic64 wrappers

Eric pointed out overly restrictive constraints in atomic64_set(), but
there are issues throughout the file. In the cited case, %ebx and %ecx
are inputs only (don't get changed by either of the two low level
implementations). This was also the case elsewhere.

Further in many cases early-clobber indicators were missing.

Finally, the previous implementation rolled a custom alternative
instruction macro from scratch, rather than using alternative_call()
(which was introduced with the commit that the description of the
change in question actually refers to). Adjusting has the benefit of
not hiding referenced symbols from the compiler, which however requires
them to be declared not just in the exporting source file (which, as a
desirable side effect, in turn allows that exporting file to become a
real 5-line stub).

This patch does not eliminate the overly restrictive memory clobbers,
however: Doing so would occasionally make the compiler set up a second
register for accessing the memory object (to satisfy the added "m"
constraint), and it's not clear which of the two non-optimal
alternatives is better.

v2: Re-do the declaration and exporting of the internal symbols.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F19A2A5020000780006E0D9@nat28.tlf.novell.com
Cc: Luca Barbieri <luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/alternative.h |    6 ++
 arch/x86/include/asm/atomic64_32.h |  147 +++++++++++++++++++----------------
 arch/x86/lib/atomic64_32.c         |   59 +--------------
 3 files changed, 88 insertions(+), 124 deletions(-)

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
index fa13f0e..908303f 100644
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
@@ -263,15 +281,16 @@ static inline int atomic64_add_negative(long long i, atomic64_t *v)
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
+			     ASM_OUTPUT2("+A" (a), "+c" (v),
+					 "+S" (low), "+D" (high)),
+			     ASM_NO_INPUT_CLOBBER("memory"));
 	return (int)a;
 }
 
@@ -279,26 +298,20 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
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
