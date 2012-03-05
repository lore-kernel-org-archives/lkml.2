Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2CEDUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:20:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:1361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2CEDUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:20:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114610642"
Subject: [RFC patch] spin_lock: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.com, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, andi.kleen@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 11:20:30 +0800
Message-ID: <1330917630.18835.44.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern x86 CPU won't hold whole memory bus when executing 'lock'
prefixed instructions unless the instruction destination is crossing 2
cache lines. If so, it is disaster of system performance.

Actually if the lock is not in the 'packed' structure, gcc places it
safely under x86 arch. But seems add this checking in
CONFIG_DEBUG_LOCK_ALLOC is harmless.

btw, change SPIN_BUG_ON macro a little for style complain.

Inspired-by: Andi Kleen <andi.kleen@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 48f99f1..79d146e 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -7,6 +7,8 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
+#define L1_CACHE_SIZE_MASK	(~(L1_CACHE_BYTES - 1)UL)
+
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
diff --git a/include/asm-generic/cache.h b/include/asm-generic/cache.h
index 1bfcfe5..244e528 100644
--- a/include/asm-generic/cache.h
+++ b/include/asm-generic/cache.h
@@ -9,4 +9,6 @@
 #define L1_CACHE_SHIFT		5
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define L1_CACHE_SIZE_MASK     (~(L1_CACHE_BYTES - 1)UL)
+
 #endif /* __ASM_GENERIC_CACHE_H */
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 5f3eacd..554dcda 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -13,6 +13,12 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 
+#define SPIN_BUG_ON(cond, lock, msg) {if (unlikely(cond)) spin_bug(lock, msg); }
+
+#define is_cross_lines(p)						\
+	(((unsigned long)(p) & L1_CACHE_SIZE_MASK) !=			\
+	(((unsigned long)(p) + sizeof(*p) - 1) & L1_CACHE_SIZE_MASK))	\
+
 void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 			  struct lock_class_key *key)
 {
@@ -22,6 +28,8 @@ void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
+	SPIN_BUG_ON(is_cross_lines(lock->raw_lock), lock,
+			"!!! the lock cross cache lines !!!");
 #endif
 	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	lock->magic = SPINLOCK_MAGIC;
@@ -40,6 +48,8 @@ void __rwlock_init(rwlock_t *lock, const char *name,
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
+	SPIN_BUG_ON(is_cross_lines(lock->raw_lock), lock,
+			"!!! the lock cross cache lines !!!");
 #endif
 	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
 	lock->magic = RWLOCK_MAGIC;
@@ -75,8 +85,6 @@ static void spin_bug(raw_spinlock_t *lock, const char *msg)
 	spin_dump(lock, msg);
 }
 
-#define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
-
 static inline void
 debug_spin_lock_before(raw_spinlock_t *lock)
 {


