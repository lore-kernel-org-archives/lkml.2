Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab1FQVxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:53:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34423 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448Ab1FQVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:53:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 6/6] Blackfin: SMP: convert to common asm-generic/atomic.h
Date: Fri, 17 Jun 2011 17:53:34 -0400
Message-Id: <1308347614-402-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308347614-402-1-git-send-email-vapier@gentoo.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that common code supports SMP systems, switch our SMP atomic logic
over to it to avoid code duplication.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/atomic.h |  105 +++--------------------------------
 1 files changed, 9 insertions(+), 96 deletions(-)

diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index c857579..4d611eb 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -1,5 +1,5 @@
 /*
- * Copyright 2004-2009 Analog Devices Inc.
+ * Copyright 2004-2011 Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -7,115 +7,28 @@
 #ifndef __ARCH_BLACKFIN_ATOMIC__
 #define __ARCH_BLACKFIN_ATOMIC__
 
-#ifndef CONFIG_SMP
-# include <asm-generic/atomic.h>
-#else
+#ifdef CONFIG_SMP
 
-#include <linux/types.h>
-#include <asm/system.h>	/* local_irq_XXX() */
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-#define atomic_set(v, i)	(((v)->counter) = i)
-
-#define atomic_read(v)	__raw_uncached_fetch_asm(&(v)->counter)
+#include <linux/linkage.h>
 
 asmlinkage int __raw_uncached_fetch_asm(const volatile int *ptr);
-
 asmlinkage int __raw_atomic_update_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_clear_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_set_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_xor_asm(volatile int *ptr, int value);
-
 asmlinkage int __raw_atomic_test_asm(const volatile int *ptr, int value);
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, i);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, -i);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	return __raw_atomic_update_asm(&v->counter, i);
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return __raw_atomic_update_asm(&v->counter, -i);
-}
-
-static inline void atomic_inc(volatile atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, 1);
-}
-
-static inline void atomic_dec(volatile atomic_t *v)
-{
-	__raw_atomic_update_asm(&v->counter, -1);
-}
-
-static inline void atomic_clear_mask(int mask, atomic_t *v)
-{
-	__raw_atomic_clear_asm(&v->counter, mask);
-}
-
-static inline void atomic_set_mask(int mask, atomic_t *v)
-{
-	__raw_atomic_set_asm(&v->counter, mask);
-}
-
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()    barrier()
-#define smp_mb__after_atomic_dec() barrier()
-#define smp_mb__before_atomic_inc()    barrier()
-#define smp_mb__after_atomic_inc() barrier()
-
-#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
-#define atomic_dec_return(v) atomic_sub_return(1,(v))
-#define atomic_inc_return(v) atomic_add_return(1,(v))
-
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-/*
- * atomic_inc_and_test - increment and test
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)
+#define atomic_read(v) __raw_uncached_fetch_asm(&(v)->counter)
 
-#define atomic_sub_and_test(i,v) (atomic_sub_return((i), (v)) == 0)
-#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
+#define atomic_add_return(i, v) __raw_atomic_update_asm(&(v)->counter, i)
+#define atomic_sub_return(i, v) __raw_atomic_update_asm(&(v)->counter, -(i))
 
-#include <asm-generic/atomic-long.h>
+#define atomic_clear_mask(m, v) __raw_atomic_clear_asm(&(v)->counter, m)
+#define atomic_set_mask(m, v)   __raw_atomic_set_asm(&(v)->counter, m)
 
 #endif
 
+#include <asm-generic/atomic.h>
 #include <asm-generic/atomic64.h>
 
 #endif
-- 
1.7.5.3

