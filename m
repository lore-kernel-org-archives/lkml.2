Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2IMKBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:01:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35995 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2IMKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:01:45 -0400
Date: Thu, 13 Sep 2012 18:01:36 +0800
From: Shaohua Li <shli@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-ID: <20120913100136.GA12929@kernel.org>
References: <20120913180121.7ef388cab4e6af2b8c52c93e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913180121.7ef388cab4e6af2b8c52c93e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 06:01:21PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> mm/internal.h: In function 'swap_cache_hit':
> mm/internal.h:377:3: error: implicit declaration of function 'atomic_dec_if_positive' [-Werror=implicit-function-declaration]
> 
> Caused by commit "swap: add a simple detector for inappropriate swapin
> readahead" from the akmp tree.  atomic_dec_if_positive() appears to only
> exist on avr32, microblaze, mips, powerpc and x86 ...
> 
> I have reverted that commit (and the following trivial fix commit) for
> today.

The x86 implementation of atomic_dec_if_positive is quite generic, how about
add this one?


Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 arch/microblaze/include/asm/atomic.h |    3 ++-
 arch/powerpc/include/asm/atomic.h    |    3 ++-
 arch/x86/include/asm/atomic.h        |   24 ------------------------
 include/linux/atomic.h               |   25 +++++++++++++++++++++++++
 4 files changed, 29 insertions(+), 26 deletions(-)

Index: linux/arch/microblaze/include/asm/atomic.h
===================================================================
--- linux.orig/arch/microblaze/include/asm/atomic.h	2012-09-13 17:56:54.206807900 +0800
+++ linux/arch/microblaze/include/asm/atomic.h	2012-09-13 17:57:18.202506238 +0800
@@ -9,7 +9,7 @@
  * Atomically test *v and decrement if it is greater than 0.
  * The function returns the old value of *v minus 1.
  */
-static inline int atomic_dec_if_positive(atomic_t *v)
+static inline int __atomic_dec_if_positive(atomic_t *v)
 {
 	unsigned long flags;
 	int res;
@@ -22,5 +22,6 @@ static inline int atomic_dec_if_positive
 
 	return res;
 }
+#define atomic_dec_if_positive __atomic_dec_if_positive
 
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
Index: linux/arch/powerpc/include/asm/atomic.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/atomic.h	2012-09-13 17:56:54.210807849 +0800
+++ linux/arch/powerpc/include/asm/atomic.h	2012-09-13 17:57:18.202506238 +0800
@@ -247,7 +247,7 @@ static __inline__ int atomic_inc_not_zer
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
  */
-static __inline__ int atomic_dec_if_positive(atomic_t *v)
+static __inline__ int __atomic_dec_if_positive(atomic_t *v)
 {
 	int t;
 
@@ -268,6 +268,7 @@ static __inline__ int atomic_dec_if_posi
 
 	return t;
 }
+#define atomic_dec_if_positive __atomic_dec_if_positive
 
 #define smp_mb__before_atomic_dec()     smp_mb()
 #define smp_mb__after_atomic_dec()      smp_mb()
Index: linux/arch/x86/include/asm/atomic.h
===================================================================
--- linux.orig/arch/x86/include/asm/atomic.h	2012-09-13 17:56:54.210807849 +0800
+++ linux/arch/x86/include/asm/atomic.h	2012-09-13 17:57:18.202506238 +0800
@@ -240,30 +240,6 @@ static inline int __atomic_add_unless(at
 	return c;
 }
 
-
-/*
- * atomic_dec_if_positive - decrement by 1 if old value positive
- * @v: pointer of type atomic_t
- *
- * The function returns the old value of *v minus 1, even if
- * the atomic variable, v, was not decremented.
- */
-static inline int atomic_dec_if_positive(atomic_t *v)
-{
-	int c, old, dec;
-	c = atomic_read(v);
-	for (;;) {
-		dec = c - 1;
-		if (unlikely(dec < 0))
-			break;
-		old = atomic_cmpxchg((v), c, dec);
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return dec;
-}
-
 /**
  * atomic_inc_short - increment of a short integer
  * @v: pointer to type int
Index: linux/include/linux/atomic.h
===================================================================
--- linux.orig/include/linux/atomic.h	2012-09-13 17:56:54.210807849 +0800
+++ linux/include/linux/atomic.h	2012-09-13 17:57:18.202506238 +0800
@@ -86,6 +86,31 @@ static inline int atomic_dec_unless_posi
 }
 #endif
 
+/*
+ * atomic_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+#ifndef atomic_dec_if_positive
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
+#endif
+
 #ifndef CONFIG_ARCH_HAS_ATOMIC_OR
 static inline void atomic_or(int i, atomic_t *v)
 {
