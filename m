Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1AZUGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:40 -0500
Received: from www.tglx.de ([62.245.132.106]:44529 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab1AZUGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:38 -0500
Message-Id: <20110126195833.771812729@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:06:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 4/6] rwsem: Move duplicate init macros and functions to
	linux/rwsem.h
References: <20110126195810.247325792@linutronix.de>
Content-Disposition: inline;
	filename=rwsem-move-duplicate-init-to-global-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rwsem initializers and related macros and functions are mostly the
same. Some of them lack the lockdep initializer, but having it in
place does not matter for architectures which do not support lockdep.

powerpc, sparc, x86: No functional change

sh, s390: Removes the duplicate init_rwsem (inline and #define)

alpha, ia64, xtensa: Use the lockdep capable init function in
       	     	     lib/rwsem.c which is just uninlining the init
       	     	     function for the LOCKDEP=n case

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |   14 --------------
 arch/ia64/include/asm/rwsem.h    |   15 ---------------
 arch/powerpc/include/asm/rwsem.h |   27 ---------------------------
 arch/s390/include/asm/rwsem.h    |   35 -----------------------------------
 arch/sh/include/asm/rwsem.h      |   31 -------------------------------
 arch/sparc/include/asm/rwsem.h   |   23 -----------------------
 arch/x86/include/asm/rwsem.h     |   25 -------------------------
 arch/xtensa/include/asm/rwsem.h  |   14 --------------
 include/linux/rwsem-spinlock.h   |   23 +----------------------
 include/linux/rwsem.h            |   25 +++++++++++++++++++++++++
 10 files changed, 26 insertions(+), 206 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
+++ linux-2.6/arch/alpha/include/asm/rwsem.h
@@ -26,20 +26,6 @@ extern struct rw_semaphore *rwsem_downgr
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
-	LIST_HEAD_INIT((name).wait_list) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
 static inline void __down_read(struct rw_semaphore *sem)
 {
 	long oldcount;
Index: linux-2.6/arch/ia64/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/rwsem.h
+++ linux-2.6/arch/ia64/include/asm/rwsem.h
@@ -34,26 +34,11 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	  LIST_HEAD_INIT((name).wait_list) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-static inline void
-init_rwsem (struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/powerpc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/rwsem.h
+++ linux-2.6/arch/powerpc/include/asm/rwsem.h
@@ -28,38 +28,11 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name)				\
-{								\
-	RWSEM_UNLOCKED_VALUE,					\
-	__SPIN_LOCK_UNLOCKED((name).wait_lock),			\
-	LIST_HEAD_INIT((name).wait_list)			\
-	__RWSEM_DEP_MAP_INIT(name)				\
-}
-
-#define DECLARE_RWSEM(name)		\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)					\
-	do {						\
-		static struct lock_class_key __key;	\
-							\
-		__init_rwsem((sem), #sem, &__key);	\
-	} while (0)
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/s390/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/rwsem.h
+++ linux-2.6/arch/s390/include/asm/rwsem.h
@@ -64,41 +64,6 @@ extern struct rw_semaphore *rwsem_downgr
 #define RWSEM_ACTIVE_WRITE_BIAS	(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
 /*
- * initialisation
- */
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
- { RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait.lock), \
-   LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)				\
-do {						\
-	static struct lock_class_key __key;	\
-						\
-	__init_rwsem((sem), #sem, &__key);	\
-} while (0)
-
-
-/*
  * lock for reading
  */
 static inline void __down_read(struct rw_semaphore *sem)
Index: linux-2.6/arch/sh/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/rwsem.h
+++ linux-2.6/arch/sh/include/asm/rwsem.h
@@ -19,42 +19,11 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	  LIST_HEAD_INIT((name).wait_list) \
-	  __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name)		\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)				\
-do {						\
-	static struct lock_class_key __key;	\
-						\
-	__init_rwsem((sem), #sem, &__key);	\
-} while (0)
-
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/sparc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/rwsem.h
+++ linux-2.6/arch/sparc/include/asm/rwsem.h
@@ -20,34 +20,11 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
-{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)						\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__init_rwsem((sem), #sem, &__key);			\
-} while (0)
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/rwsem.h
+++ linux-2.6/arch/x86/include/asm/rwsem.h
@@ -66,31 +66,6 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name)				\
-{								\
-	RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) \
-}
-
-#define DECLARE_RWSEM(name)					\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)						\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__init_rwsem((sem), #sem, &__key);			\
-} while (0)
-
 /*
  * lock for reading
  */
Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -24,25 +24,11 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
-	  LIST_HEAD_INIT((name).wait_list) }
-
-#define DECLARE_RWSEM(name)		\
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 
-static inline void init_rwsem(struct rw_semaphore *sem)
-{
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
 /*
  * lock for reading
  */
Index: linux-2.6/include/linux/rwsem-spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem-spinlock.h
+++ linux-2.6/include/linux/rwsem-spinlock.h
@@ -29,28 +29,7 @@ struct rw_semaphore {
 #endif
 };
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
-#else
-# define __RWSEM_DEP_MAP_INIT(lockname)
-#endif
-
-#define __RWSEM_INITIALIZER(name) \
-{ 0, __SPIN_LOCK_UNLOCKED(name.wait_lock), LIST_HEAD_INIT((name).wait_list) \
-  __RWSEM_DEP_MAP_INIT(name) }
-
-#define DECLARE_RWSEM(name) \
-	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
-
-extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
-			 struct lock_class_key *key);
-
-#define init_rwsem(sem)						\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__init_rwsem((sem), #sem, &__key);			\
-} while (0)
+#define RWSEM_UNLOCKED_VALUE		0x00000000
 
 extern void __down_read(struct rw_semaphore *sem);
 extern int __down_read_trylock(struct rw_semaphore *sem);
Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h
+++ linux-2.6/include/linux/rwsem.h
@@ -36,6 +36,31 @@ struct rw_semaphore {
 #include <asm/rwsem.h>
 #endif
 
+/* Common initializer macros and functions */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+#else
+# define __RWSEM_DEP_MAP_INIT(lockname)
+#endif
+
+#define __RWSEM_INITIALIZER(name) \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
+
+#define DECLARE_RWSEM(name) \
+	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
+
+extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
+			 struct lock_class_key *key);
+
+#define init_rwsem(sem)						\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__init_rwsem((sem), #sem, &__key);			\
+} while (0)
+
 /*
  * lock for reading
  */


