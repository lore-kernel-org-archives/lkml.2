Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2ADPch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:32:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37100 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2ADPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:32:35 -0500
Date: Wed, 4 Jan 2012 07:31:42 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-cdcd629869fabcd38ebd24a03b0a05ec1cbcafb0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jbeulich@suse.com, cl@linux.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, cl@linux.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F01F12A020000780006A19B@nat28.tlf.novell.com>
References: <4F01F12A020000780006A19B@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Fix and improve cmpxchg_double{,_local}()
Git-Commit-ID: cdcd629869fabcd38ebd24a03b0a05ec1cbcafb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Jan 2012 07:31:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdcd629869fabcd38ebd24a03b0a05ec1cbcafb0
Gitweb:     http://git.kernel.org/tip/cdcd629869fabcd38ebd24a03b0a05ec1cbcafb0
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 2 Jan 2012 17:02:18 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Jan 2012 15:01:54 +0100

x86: Fix and improve cmpxchg_double{,_local}()

Just like the per-CPU ones they had several
problems/shortcomings:

Only the first memory operand was mentioned in the asm()
operands, and the 2x64-bit version didn't have a memory clobber
while the 2x32-bit one did. The former allowed the compiler to
not recognize the need to re-load the data in case it had it
cached in some register, while the latter was overly
destructive.

The types of the local copies of the old and new values were
incorrect (the types of the pointed-to variables should be used
here, to make sure the respective old/new variable types are
compatible).

The __dummy/__junk variables were pointless, given that local
copies of the inputs already existed (and can hence be used for
discarded outputs).

The 32-bit variant of cmpxchg_double_local() referenced
cmpxchg16b_local().

At once also:

 - change the return value type to what it really is: 'bool'
 - unify 32- and 64-bit variants
 - abstract out the common part of the 'normal' and 'local' variants

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F01F12A020000780006A19B@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cmpxchg.h    |   23 ++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h |   46 -------------------------------------
 arch/x86/include/asm/cmpxchg_64.h |   43 ----------------------------------
 mm/slub.c                         |    4 +-
 4 files changed, 25 insertions(+), 91 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 5488e10..0c9fa27 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -207,4 +207,27 @@ extern void __add_wrong_size(void)
 #define add_smp(ptr, inc)	__add((ptr), (inc), LOCK_PREFIX)
 #define add_sync(ptr, inc)	__add((ptr), (inc), "lock; ")
 
+#define __cmpxchg_double(pfx, p1, p2, o1, o2, n1, n2)			\
+({									\
+	bool __ret;							\
+	__typeof__(*(p1)) __old1 = (o1), __new1 = (n1);			\
+	__typeof__(*(p2)) __old2 = (o2), __new2 = (n2);			\
+	BUILD_BUG_ON(sizeof(*(p1)) != sizeof(long));			\
+	BUILD_BUG_ON(sizeof(*(p2)) != sizeof(long));			\
+	VM_BUG_ON((unsigned long)(p1) % (2 * sizeof(long)));		\
+	VM_BUG_ON((unsigned long)((p1) + 1) != (unsigned long)(p2));	\
+	asm volatile(pfx "cmpxchg%c4b %2; sete %0"			\
+		     : "=a" (__ret), "+d" (__old2),			\
+		       "+m" (*(p1)), "+m" (*(p2))			\
+		     : "i" (2 * sizeof(long)), "a" (__old1),		\
+		       "b" (__new1), "c" (__new2));			\
+	__ret;								\
+})
+
+#define cmpxchg_double(p1, p2, o1, o2, n1, n2) \
+	__cmpxchg_double(LOCK_PREFIX, p1, p2, o1, o2, n1, n2)
+
+#define cmpxchg_double_local(p1, p2, o1, o2, n1, n2) \
+	__cmpxchg_double(, p1, p2, o1, o2, n1, n2)
+
 #endif	/* ASM_X86_CMPXCHG_H */
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index fbebb07..53f4b21 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -166,52 +166,6 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 
 #endif
 
-#define cmpxchg8b(ptr, o1, o2, n1, n2)				\
-({								\
-	char __ret;						\
-	__typeof__(o2) __dummy;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile(LOCK_PREFIX "cmpxchg8b %2; setz %1"	\
-		       : "=d"(__dummy), "=a" (__ret), "+m" (*ptr)\
-		       : "a" (__old1), "d"(__old2),		\
-		         "b" (__new1), "c" (__new2)		\
-		       : "memory");				\
-	__ret; })
-
-
-#define cmpxchg8b_local(ptr, o1, o2, n1, n2)			\
-({								\
-	char __ret;						\
-	__typeof__(o2) __dummy;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile("cmpxchg8b %2; setz %1"			\
-		       : "=d"(__dummy), "=a"(__ret), "+m" (*ptr)\
-		       : "a" (__old), "d"(__old2),		\
-		         "b" (__new1), "c" (__new2),		\
-		       : "memory");				\
-	__ret; })
-
-
-#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
-	VM_BUG_ON((unsigned long)(ptr) % 8);				\
-	cmpxchg8b((ptr), (o1), (o2), (n1), (n2));			\
-})
-
-#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
-({									\
-       BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
-       VM_BUG_ON((unsigned long)(ptr) % 8);				\
-       cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));			\
-})
-
 #define system_has_cmpxchg_double() cpu_has_cx8
 
 #endif /* _ASM_X86_CMPXCHG_32_H */
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 285da02..614be87 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -20,49 +20,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 val)
 	cmpxchg_local((ptr), (o), (n));					\
 })
 
-#define cmpxchg16b(ptr, o1, o2, n1, n2)				\
-({								\
-	char __ret;						\
-	__typeof__(o2) __junk;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile(LOCK_PREFIX "cmpxchg16b %2;setz %1"	\
-		       : "=d"(__junk), "=a"(__ret), "+m" (*ptr)	\
-		       : "b"(__new1), "c"(__new2),		\
-		         "a"(__old1), "d"(__old2));		\
-	__ret; })
-
-
-#define cmpxchg16b_local(ptr, o1, o2, n1, n2)			\
-({								\
-	char __ret;						\
-	__typeof__(o2) __junk;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile("cmpxchg16b %2;setz %1"			\
-		       : "=d"(__junk), "=a"(__ret), "+m" (*ptr)	\
-		       : "b"(__new1), "c"(__new2),		\
-		         "a"(__old1), "d"(__old2));		\
-	__ret; })
-
-#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	VM_BUG_ON((unsigned long)(ptr) % 16);				\
-	cmpxchg16b((ptr), (o1), (o2), (n1), (n2));			\
-})
-
-#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	VM_BUG_ON((unsigned long)(ptr) % 16);				\
-	cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));		\
-})
-
 #define system_has_cmpxchg_double() cpu_has_cx16
 
 #endif /* _ASM_X86_CMPXCHG_64_H */
diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..09ccee8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -368,7 +368,7 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page
 	VM_BUG_ON(!irqs_disabled());
 #ifdef CONFIG_CMPXCHG_DOUBLE
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist,
+		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
 			freelist_new, counters_new))
 		return 1;
@@ -402,7 +402,7 @@ static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 {
 #ifdef CONFIG_CMPXCHG_DOUBLE
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist,
+		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
 			freelist_new, counters_new))
 		return 1;
