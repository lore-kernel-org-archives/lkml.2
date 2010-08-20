Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0HTFPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:15:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:51601 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0HTFPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:15:20 -0400
Subject: [PATCH 2/2] rwsem: Move powerpc atomic-long based implementation
 to asm-generic
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulus@au.ibm.com,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>
In-Reply-To: <20100818.222925.233689776.davem@davemloft.net>
References: <1282107803.22370.173.camel@pasglop>
	 <20100817.222818.193699062.davem@davemloft.net>
	 <1282195403.22370.296.camel@pasglop>
	 <20100818.222925.233689776.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 15:14:55 +1000
Message-ID: <1282281295.22370.401.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other architectures who support cmpxchg and atomic_long can
use that directly.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/rwsem.h    |  184 +----------------------------------
 include/asm-generic/rwsem-cmpxchg.h |  183 ++++++++++++++++++++++++++++++++++
 2 files changed, 184 insertions(+), 183 deletions(-)
 create mode 100644 include/asm-generic/rwsem-cmpxchg.h

diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 8447d89..1237ad6 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -1,183 +1 @@
-#ifndef _ASM_POWERPC_RWSEM_H
-#define _ASM_POWERPC_RWSEM_H
-
-#ifndef _LINUX_RWSEM_H
-#error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
-#endif
-
-#ifdef __KERNEL__
-
-/*
- * R/W semaphores for PPC using the stuff in lib/rwsem.c.
- * Adapted largely from include/asm-i386/rwsem.h
- * by Paul Mackerras <paulus@samba.org>.
- */
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
-/*
- * the semaphore definition
- */
-#ifdef CONFIG_PPC64
-# define RWSEM_ACTIVE_MASK		0xffffffffL
-#else
-# define RWSEM_ACTIVE_MASK		0x0000ffffL
-#endif
-
-#define RWSEM_UNLOCKED_VALUE		0x00000000L
-#define RWSEM_ACTIVE_BIAS		0x00000001L
-#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
-#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-
-struct rw_semaphore {
-	long			count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
-
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
-extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
-extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
-
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
-/*
- * lock for reading
- */
-static inline void __down_read(struct rw_semaphore *sem)
-{
-	if (unlikely(atomic_long_inc_return((atomic_long_t *)&sem->count) <= 0))
-		rwsem_down_read_failed(sem);
-}
-
-static inline int __down_read_trylock(struct rw_semaphore *sem)
-{
-	long tmp;
-
-	while ((tmp = sem->count) >= 0) {
-		if (tmp == cmpxchg(&sem->count, tmp,
-				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
-			return 1;
-		}
-	}
-	return 0;
-}
-
-/*
- * lock for writing
- */
-static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
-{
-	long tmp;
-
-	tmp = atomic_long_add_return(RWSEM_ACTIVE_WRITE_BIAS,
-				     (atomic_long_t *)&sem->count);
-	if (unlikely(tmp != RWSEM_ACTIVE_WRITE_BIAS))
-		rwsem_down_write_failed(sem);
-}
-
-static inline void __down_write(struct rw_semaphore *sem)
-{
-	__down_write_nested(sem, 0);
-}
-
-static inline int __down_write_trylock(struct rw_semaphore *sem)
-{
-	long tmp;
-
-	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
-		      RWSEM_ACTIVE_WRITE_BIAS);
-	return tmp == RWSEM_UNLOCKED_VALUE;
-}
-
-/*
- * unlock after reading
- */
-static inline void __up_read(struct rw_semaphore *sem)
-{
-	long tmp;
-
-	tmp = atomic_long_dec_return((atomic_long_t *)&sem->count);
-	if (unlikely(tmp < -1 && (tmp & RWSEM_ACTIVE_MASK) == 0))
-		rwsem_wake(sem);
-}
-
-/*
- * unlock after writing
- */
-static inline void __up_write(struct rw_semaphore *sem)
-{
-	if (unlikely(atomic_long_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
-				 (atomic_long_t *)&sem->count) < 0))
-		rwsem_wake(sem);
-}
-
-/*
- * implement atomic add functionality
- */
-static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
-{
-	atomic_long_add(delta, (atomic_long_t *)&sem->count);
-}
-
-/*
- * downgrade write lock to read lock
- */
-static inline void __downgrade_write(struct rw_semaphore *sem)
-{
-	long tmp;
-
-	tmp = atomic_long_add_return(-RWSEM_WAITING_BIAS,
-				     (atomic_long_t *)&sem->count);
-	if (tmp < 0)
-		rwsem_downgrade_wake(sem);
-}
-
-/*
- * implement exchange and add functionality
- */
-static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
-{
-	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
-}
-
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return sem->count != 0;
-}
-
-#endif	/* __KERNEL__ */
-#endif	/* _ASM_POWERPC_RWSEM_H */
+#include <asm-generic/rwsem-cmpxchg.h>
diff --git a/include/asm-generic/rwsem-cmpxchg.h b/include/asm-generic/rwsem-cmpxchg.h
new file mode 100644
index 0000000..2b1c859
--- /dev/null
+++ b/include/asm-generic/rwsem-cmpxchg.h
@@ -0,0 +1,183 @@
+#ifndef _RWSEM_CMPXCHG_H
+#define _RWSEM_CMPXCHG_H
+
+#ifndef _LINUX_RWSEM_H
+#error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
+#endif
+
+#ifdef __KERNEL__
+
+/*
+ * Generic R/W semaphores the stuff in lib/rwsem.c.
+ * Adapted largely from include/asm-i386/rwsem.h
+ * by Paul Mackerras <paulus@samba.org>.
+ */
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <asm/atomic.h>
+#include <asm/system.h>
+
+/*
+ * the semaphore definition
+ */
+#if BITS_PER_LONG == 64
+# define RWSEM_ACTIVE_MASK		0xffffffffL
+#else
+# define RWSEM_ACTIVE_MASK		0x0000ffffL
+#endif
+
+#define RWSEM_UNLOCKED_VALUE		0x00000000L
+#define RWSEM_ACTIVE_BIAS		0x00000001L
+#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
+#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
+#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+
+struct rw_semaphore {
+	long			count;
+	spinlock_t		wait_lock;
+	struct list_head	wait_list;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+#else
+# define __RWSEM_DEP_MAP_INIT(lockname)
+#endif
+
+#define __RWSEM_INITIALIZER(name)				\
+{								\
+	RWSEM_UNLOCKED_VALUE,					\
+	__SPIN_LOCK_UNLOCKED((name).wait_lock),			\
+	LIST_HEAD_INIT((name).wait_list)			\
+	__RWSEM_DEP_MAP_INIT(name)				\
+}
+
+#define DECLARE_RWSEM(name)		\
+	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
+
+extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
+
+extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
+			 struct lock_class_key *key);
+
+#define init_rwsem(sem)					\
+	do {						\
+		static struct lock_class_key __key;	\
+							\
+		__init_rwsem((sem), #sem, &__key);	\
+	} while (0)
+
+/*
+ * lock for reading
+ */
+static inline void __down_read(struct rw_semaphore *sem)
+{
+	if (unlikely(atomic_long_inc_return((atomic_long_t *)&sem->count) <= 0))
+		rwsem_down_read_failed(sem);
+}
+
+static inline int __down_read_trylock(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	while ((tmp = sem->count) >= 0) {
+		if (tmp == cmpxchg(&sem->count, tmp,
+				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * lock for writing
+ */
+static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
+{
+	long tmp;
+
+	tmp = atomic_long_add_return(RWSEM_ACTIVE_WRITE_BIAS,
+				     (atomic_long_t *)&sem->count);
+	if (unlikely(tmp != RWSEM_ACTIVE_WRITE_BIAS))
+		rwsem_down_write_failed(sem);
+}
+
+static inline void __down_write(struct rw_semaphore *sem)
+{
+	__down_write_nested(sem, 0);
+}
+
+static inline int __down_write_trylock(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+		      RWSEM_ACTIVE_WRITE_BIAS);
+	return tmp == RWSEM_UNLOCKED_VALUE;
+}
+
+/*
+ * unlock after reading
+ */
+static inline void __up_read(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = atomic_long_dec_return((atomic_long_t *)&sem->count);
+	if (unlikely(tmp < -1 && (tmp & RWSEM_ACTIVE_MASK) == 0))
+		rwsem_wake(sem);
+}
+
+/*
+ * unlock after writing
+ */
+static inline void __up_write(struct rw_semaphore *sem)
+{
+	if (unlikely(atomic_long_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
+				 (atomic_long_t *)&sem->count) < 0))
+		rwsem_wake(sem);
+}
+
+/*
+ * implement atomic add functionality
+ */
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
+{
+	atomic_long_add(delta, (atomic_long_t *)&sem->count);
+}
+
+/*
+ * downgrade write lock to read lock
+ */
+static inline void __downgrade_write(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = atomic_long_add_return(-RWSEM_WAITING_BIAS,
+				     (atomic_long_t *)&sem->count);
+	if (tmp < 0)
+		rwsem_downgrade_wake(sem);
+}
+
+/*
+ * implement exchange and add functionality
+ */
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
+{
+	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
+}
+
+static inline int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	return sem->count != 0;
+}
+
+#endif	/* __KERNEL__ */
+#endif	/* _RWSEM_CMPXCHG_H */


