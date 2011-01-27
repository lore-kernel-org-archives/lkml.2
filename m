Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1A0L5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:57:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:40682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1A0L5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:57:19 -0500
Date: Thu, 27 Jan 2011 11:56:55 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, chris@zankel.net, lethal@linux-sh.org,
        tony.luck@intel.com, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, mattst88@gmail.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tony.luck@intel.com, lethal@linux-sh.org,
        chris@zankel.net, davem@davemloft.net, dhowells@redhat.com,
        benh@kernel.crashing.org, mattst88@gmail.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20110126195833.771812729@linutronix.de>
References: <20110126195833.771812729@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem: Move duplicate init macros and functions to linux/rwsem.h
Message-ID: <tip-12249b34414dba7f386aadcf6be7ca36c6878300@git.kernel.org>
Git-Commit-ID: 12249b34414dba7f386aadcf6be7ca36c6878300
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:56:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12249b34414dba7f386aadcf6be7ca36c6878300
Gitweb:     http://git.kernel.org/tip/12249b34414dba7f386aadcf6be7ca36c6878300
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 20:06:00 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:39 +0100

rwsem: Move duplicate init macros and functions to linux/rwsem.h

The rwsem initializers and related macros and functions are mostly the
same. Some of them lack the lockdep initializer, but having it in
place does not matter for architectures which do not support lockdep.

powerpc, sparc, x86: No functional change

sh, s390: Removes the duplicate init_rwsem (inline and #define)

alpha, ia64, xtensa: Use the lockdep capable init function in
       	     	     lib/rwsem.c which is just uninlining the init
       	     	     function for the LOCKDEP=n case

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matt Turner <mattst88@gmail.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
LKML-Reference: <20110126195833.771812729@linutronix.de>

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

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 3e5619e..c9f5b90 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -26,20 +26,6 @@ extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
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
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 1fe4658..3798546 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
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
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index bc1acc2..f86fdf7 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
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
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 6e075f1..f0f52775 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -64,41 +64,6 @@ extern struct rw_semaphore *rwsem_downgrade_write(struct rw_semaphore *);
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
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index dffc625..798699d 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
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
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index 4c16d1d..79f7c1c 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
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
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 995cfe4..c0c91b4 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
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
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index 585cab9..2fa4202 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -24,25 +24,11 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
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
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 8c0dc7f..3470124 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
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
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index e8be18e..8970c3e 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
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
