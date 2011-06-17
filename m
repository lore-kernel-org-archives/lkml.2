Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab1FQVxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:53:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34414 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1FQVxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:53:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 4/6] asm-generic/atomic.h: allow SMP peeps to leverage this
Date: Fri, 17 Jun 2011 17:53:32 -0400
Message-Id: <1308347614-402-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308347614-402-1-git-send-email-vapier@gentoo.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a few core funcs need to be implemented for SMP systems, so allow
the arches to override them while getting the rest for free.

At least, this is enough to allow the Blackfin SMP port use things.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/atomic.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 8275ecd..297f1a8 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -14,7 +14,11 @@
 #define __ASM_GENERIC_ATOMIC_H
 
 #ifdef CONFIG_SMP
-#error not SMP safe
+/* Force people to define core atomics */
+# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
+     !defined(atomic_clear_mask) || !defined(atomic_set_mask)
+#  error "SMP requires a little arch-specific magic"
+# endif
 #endif
 
 /*
@@ -32,7 +36,9 @@
  *
  * Atomically reads the value of @v.
  */
+#ifndef atomic_read
 #define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#endif
 
 /**
  * atomic_set - set atomic variable
@@ -53,6 +59,7 @@
  *
  * Atomically adds @i to @v and returns the result
  */
+#ifndef atomic_add_return
 static inline int atomic_add_return(int i, atomic_t *v)
 {
 	unsigned long flags;
@@ -66,6 +73,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 
 	return temp;
 }
+#endif
 
 /**
  * atomic_sub_return - subtract integer from atomic variable
@@ -74,6 +82,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
  *
  * Atomically subtracts @i from @v and returns the result
  */
+#ifndef atomic_sub_return
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	unsigned long flags;
@@ -87,6 +96,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 
 	return temp;
 }
+#endif
 
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
@@ -147,6 +157,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
  *
  * Atomically clears the bits set in @mask from @v
  */
+#ifndef atomic_clear_mask
 static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 {
 	unsigned long flags;
@@ -156,6 +167,7 @@ static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 	v->counter &= mask;
 	raw_local_irq_restore(flags);
 }
+#endif
 
 /**
  * atomic_set_mask - Atomically set bits in atomic variable
@@ -164,6 +176,7 @@ static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
  *
  * Atomically sets the bits set in @mask in @v
  */
+#ifndef atomic_set_mask
 static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 {
 	unsigned long flags;
@@ -172,6 +185,7 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 	v->counter |= mask;
 	raw_local_irq_restore(flags);
 }
+#endif
 
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
-- 
1.7.5.3

