Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2CEFoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 00:44:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:41644 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab2CEFoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 00:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124999030"
Subject: Re: [RFC patch] spindep: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.com, "mingo@redhat.com" <mingo@redhat.com>
Cc: hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, andi.kleen@intel.com
In-Reply-To: <1330917889.18835.46.camel@debian>
References: <1330917630.18835.44.camel@debian>
	 <1330917889.18835.46.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 13:43:54 +0800
Message-ID: <1330926234.18835.51.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2012-03-05 at 11:24 +0800, Alex Shi wrote:
> Oops.
> Sorry, the patch is not tested well! will update it later. 

corrected version:
==========
>From 28745c1970a61a1420d388660cd9dcc619cd38ba Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 5 Mar 2012 13:03:35 +0800
Subject: [PATCH] lockdep: add cross cache lines checking

Modern x86 CPU won't hold whole memory bus when executing 'lock'
prefixed instructions unless the instruction destination is crossing 2
cache lines. If so, it is disaster of system performance.

Actually if the lock is not in the 'packed' structure, gcc places it
safely under x86 arch. But seems add this checking in
CONFIG_DEBUG_LOCK_ALLOC is harmless.

Inspired-by: Andi Kleen <andi.kleen@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/cache.h |    2 +
 include/asm-generic/cache.h  |    2 +
 lib/spinlock_debug.c         |   76 ++++++++++++++++++++++-------------------
 3 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 48f99f1..63c2316 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -7,6 +7,8 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
+#define L1_CACHE_SIZE_MASK	(~(L1_CACHE_BYTES - 1))
+
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
diff --git a/include/asm-generic/cache.h b/include/asm-generic/cache.h
index 1bfcfe5..6f8eb29 100644
--- a/include/asm-generic/cache.h
+++ b/include/asm-generic/cache.h
@@ -9,4 +9,6 @@
 #define L1_CACHE_SHIFT		5
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define L1_CACHE_SIZE_MASK     (~(L1_CACHE_BYTES - 1))
+
 #endif /* __ASM_GENERIC_CACHE_H */
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 5f3eacd..938a145 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -13,41 +13,9 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 
-void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
-			  struct lock_class_key *key)
-{
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
-	 * Make sure we are not reinitializing a held lock:
-	 */
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
-#endif
-	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-	lock->magic = SPINLOCK_MAGIC;
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
-}
-
-EXPORT_SYMBOL(__raw_spin_lock_init);
-
-void __rwlock_init(rwlock_t *lock, const char *name,
-		   struct lock_class_key *key)
-{
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
-	 * Make sure we are not reinitializing a held lock:
-	 */
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
-#endif
-	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
-	lock->magic = RWLOCK_MAGIC;
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
-}
-
-EXPORT_SYMBOL(__rwlock_init);
+#define is_cross_lines(p)						\
+	(((unsigned long)(p) & L1_CACHE_SIZE_MASK) !=			\
+	(((unsigned long)(p) + sizeof(*p) - 1) & L1_CACHE_SIZE_MASK))	\
 
 static void spin_dump(raw_spinlock_t *lock, const char *msg)
 {
@@ -296,3 +264,41 @@ void do_raw_write_unlock(rwlock_t *lock)
 	debug_write_unlock(lock);
 	arch_write_unlock(&lock->raw_lock);
 }
+
+void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
+			  struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+	SPIN_BUG_ON(is_cross_lines(&lock->raw_lock), lock,
+			"!!! the lock cross cache lines !!!");
+#endif
+	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+	lock->magic = SPINLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+EXPORT_SYMBOL(__raw_spin_lock_init);
+
+void __rwlock_init(rwlock_t *lock, const char *name,
+		   struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+	RWLOCK_BUG_ON(is_cross_lines(&lock->raw_lock), lock,
+			"!!! the lock cross cache lines !!!");
+#endif
+	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
+	lock->magic = RWLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+EXPORT_SYMBOL(__rwlock_init);
-- 
1.6.3.3



