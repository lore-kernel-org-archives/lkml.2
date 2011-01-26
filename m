Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1AZUHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:07:00 -0500
Received: from www.tglx.de ([62.245.132.106]:44586 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab1AZUG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:58 -0500
Message-Id: <20110126195833.679641914@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:05:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 3/6] rwsem: Move duplicate struct rwsem declaration to
	linux/rwsem.h
References: <20110126195810.247325792@linutronix.de>
Content-Disposition: inline;
	filename=rw-sem-move-duplicate-struct-rwsem-declaration-to-global-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The difference between these declarations is the data type of the
count member and the lack of lockdep in some architectures/

long is equivivalent to signed long and the #ifdef guarded dep_map
member does not hurt anyone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |    8 --------
 arch/ia64/include/asm/rwsem.h    |    9 ---------
 arch/powerpc/include/asm/rwsem.h |    9 ---------
 arch/s390/include/asm/rwsem.h    |   12 ------------
 arch/sh/include/asm/rwsem.h      |   12 +-----------
 arch/sparc/include/asm/rwsem.h   |    9 +--------
 arch/x86/include/asm/rwsem.h     |   12 ------------
 arch/xtensa/include/asm/rwsem.h  |    9 +--------
 include/linux/rwsem.h            |   13 ++++++++++++-
 9 files changed, 15 insertions(+), 78 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
+++ linux-2.6/arch/alpha/include/asm/rwsem.h
@@ -19,20 +19,12 @@ extern struct rw_semaphore *rwsem_down_w
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	long			count;
 #define RWSEM_UNLOCKED_VALUE		0x0000000000000000L
 #define RWSEM_ACTIVE_BIAS		0x0000000000000001L
 #define RWSEM_ACTIVE_MASK		0x00000000ffffffffL
 #define RWSEM_WAITING_BIAS		(-0x0000000100000000L)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
 
 #define __RWSEM_INITIALIZER(name) \
 	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
Index: linux-2.6/arch/ia64/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/rwsem.h
+++ linux-2.6/arch/ia64/include/asm/rwsem.h
@@ -27,15 +27,6 @@
 
 #include <asm/intrinsics.h>
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
-
 #define RWSEM_UNLOCKED_VALUE		__IA64_UL_CONST(0x0000000000000000)
 #define RWSEM_ACTIVE_BIAS		(1L)
 #define RWSEM_ACTIVE_MASK		(0xffffffffL)
Index: linux-2.6/arch/powerpc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/rwsem.h
+++ linux-2.6/arch/powerpc/include/asm/rwsem.h
@@ -28,15 +28,6 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-struct rw_semaphore {
-	long			count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
 #else
Index: linux-2.6/arch/s390/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/rwsem.h
+++ linux-2.6/arch/s390/include/asm/rwsem.h
@@ -49,18 +49,6 @@ extern struct rw_semaphore *rwsem_wake(s
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_downgrade_write(struct rw_semaphore *);
 
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
-
 #ifndef __s390x__
 #define RWSEM_UNLOCKED_VALUE	0x00000000
 #define RWSEM_ACTIVE_BIAS	0x00000001
Index: linux-2.6/arch/sh/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/rwsem.h
+++ linux-2.6/arch/sh/include/asm/rwsem.h
@@ -11,23 +11,13 @@
 #endif
 
 #ifdef __KERNEL__
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	long		count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000
 #define RWSEM_ACTIVE_BIAS		0x00000001
 #define RWSEM_ACTIVE_MASK		0x0000ffff
 #define RWSEM_WAITING_BIAS		(-0x00010000)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
Index: linux-2.6/arch/sparc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/rwsem.h
+++ linux-2.6/arch/sparc/include/asm/rwsem.h
@@ -12,20 +12,13 @@
 #endif
 
 #ifdef __KERNEL__
-struct rw_semaphore {
-	signed long			count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
 #define RWSEM_ACTIVE_BIAS		0x00000001L
 #define RWSEM_ACTIVE_MASK		0xffffffffL
 #define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t			wait_lock;
-	struct list_head		wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map		dep_map;
-#endif
-};
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
Index: linux-2.6/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/rwsem.h
+++ linux-2.6/arch/x86/include/asm/rwsem.h
@@ -49,8 +49,6 @@ extern asmregparm struct rw_semaphore *
  rwsem_downgrade_wake(struct rw_semaphore *sem);
 
 /*
- * the semaphore definition
- *
  * The bias values and the counter type limits the number of
  * potential readers/writers to 32767 for 32 bits and 2147483647
  * for 64 bits.
@@ -68,22 +66,12 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-struct rw_semaphore {
-	long			count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
-};
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-
 #define __RWSEM_INITIALIZER(name)				\
 {								\
 	RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -16,20 +16,13 @@
 #ifndef _LINUX_RWSEM_H
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
-/*
- * the semaphore definition
- */
-struct rw_semaphore {
-	signed long		count;
+
 #define RWSEM_UNLOCKED_VALUE		0x00000000
 #define RWSEM_ACTIVE_BIAS		0x00000001
 #define RWSEM_ACTIVE_MASK		0x0000ffff
 #define RWSEM_WAITING_BIAS		(-0x00010000)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-};
 
 #define __RWSEM_INITIALIZER(name) \
 	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h
+++ linux-2.6/include/linux/rwsem.h
@@ -22,7 +22,18 @@ struct rw_semaphore;
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
 #include <linux/rwsem-spinlock.h> /* use a generic implementation */
 #else
-#include <asm/rwsem.h> /* use an arch-specific implementation */
+/* All arch specific implementations share the same struct */
+struct rw_semaphore {
+	long			count;
+	spinlock_t		wait_lock;
+	struct list_head	wait_list;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+/* Include the arch specific part */
+#include <asm/rwsem.h>
 #endif
 
 /*


