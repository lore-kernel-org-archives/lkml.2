Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab0JIT6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 15:58:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760502Ab0JIT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 15:58:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
        Mathieu Lacage <mathieu.lacage@sophia.inria.fr>,
        Mathieu Lacage <mathieu.lacage@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/6] asm-generic: make atomic_add_unless a function
Date: Sat,  9 Oct 2010 21:57:47 +0200
Message-Id: <1286654272-21483-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286654272-21483-1-git-send-email-arnd@arndb.de>
References: <1286654272-21483-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:oqIrxhImfGO+vwFxbk0CHoqirgXDB06hoZNzhnRn0Hd
 Rw0Y2uWNNmvFYNRIhMd7RDcgeeUBmZ8osfohBu9cOiGEUdbjNT
 frML0hBbgf/DzBsB45b3fhPpeD+FRWGdc1yA11TFR0TGOeLxMF
 5U6KOJlUcVtTyHQ5bhnUe2yKsTOgtqQI9zysDTqOih/CHA5Jsl
 jC8H/mQme1YM3QC931DHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>

atomic_add_unless is a macro so, bad things happen if the caller defines
a local variable named c, just like like the local variable c defined by
the macro. Thus, convert atomic_add_unless to a function. (bug triggered
by net/ipv4/netfilter/ipt_CLUSTERIP.c: clusterip_config_find_get calls
atomic_inc_not_zero)

Signed-off-by: Mathieu Lacage <mathieu.lacage@inria.fr>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/atomic.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e53347f..a6cc019 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -119,14 +119,23 @@ static inline void atomic_dec(atomic_t *v)
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
 #define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
+
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+  int c, old;
+  c = atomic_read(v);
+  while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
+    c = old;
+  return c != u;
+}
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
@@ -140,15 +149,6 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 	raw_local_irq_restore(flags);
 }
 
-#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
-
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
 #define smp_mb__after_atomic_dec()	barrier()
-- 
1.7.1

