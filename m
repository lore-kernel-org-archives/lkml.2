Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab1FQVKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:10:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56587 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933123Ab1FQVKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:10:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>
Subject: [PATCH] asm-generic/atomic.h: allow SMP peeps to leverage this
Date: Fri, 17 Jun 2011 17:10:46 -0400
Message-Id: <1308345046-13293-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a few core funcs need to be implemented for SMP systems, so allow
the arches to override them while getting the rest for free.

At least, this is enough to allow the Blackfin SMP port use things.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Note: this shouldn't conflict with Arun's changes

 include/asm-generic/atomic.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 5f62e28..2267e4b 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -14,7 +14,12 @@
 #define __ASM_GENERIC_ATOMIC_H
 
 #ifdef CONFIG_SMP
-#error not SMP safe
+/* Force people to define core atomics */
+# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
+     !defined(atomic_clear_mask) || !defined(atomic_set_mask) || \
+     !defined(atomic_test_mask)
+#  error "SMP requires a little arch-specific magic"
+# endif
 #endif
 
 /*
@@ -32,7 +37,9 @@
  *
  * Atomically reads the value of @v.
  */
+#ifndef atomic_read
 #define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#endif
 
 /**
  * atomic_set - set atomic variable
@@ -53,6 +60,7 @@
  *
  * Atomically adds @i to @v and returns the result
  */
+#ifndef atomic_add_return
 static inline int atomic_add_return(int i, atomic_t *v)
 {
 	unsigned long flags;
@@ -66,6 +74,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 
 	return temp;
 }
+#endif
 
 /**
  * atomic_sub_return - subtract integer from atomic variable
@@ -74,6 +83,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
  *
  * Atomically subtracts @i from @v and returns the result
  */
+#ifndef atomic_sub_return
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	unsigned long flags;
@@ -87,6 +97,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 
 	return temp;
 }
+#endif
 
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
@@ -140,6 +151,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
+#ifndef atomic_clear_mask
 static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 {
 	unsigned long flags;
@@ -149,6 +161,7 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 	*addr &= mask;
 	raw_local_irq_restore(flags);
 }
+#endif
 
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
-- 
1.7.5.3

