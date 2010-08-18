Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0HRF2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:28:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55979
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab0HRF17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:27:59 -0400
Date: Tue, 17 Aug 2010 22:28:18 -0700 (PDT)
Message-Id: <20100817.222818.193699062.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: 64-bit ppc rwsem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282107803.22370.173.camel@pasglop>
References: <20100817.191424.183031381.davem@davemloft.net>
	<1282106338.22370.151.camel@pasglop>
	<1282107803.22370.173.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 18 Aug 2010 15:03:23 +1000

> I tried various tricks but so far they didn't work. I'll have another
> look tomorrow, but I may end up having to keep all the crap typecasts.

The casts are pretty much unavoidable.

Here's what I'm going to end up using on sparc64:

--------------------
sparc64: Make rwsems 64-bit.

Basically tip-off the powerpc code, use a 64-bit type and atomic64_t
interfaces for the implementation.

This gets us off of the by-hand asm code I wrote, which frankly I
think probably ruins I-cache hit rates.

The idea was the keep the call chains less deep, but anything taking
the rw-semaphores probably is also calling other stuff and therefore
already has allocated a stack-frame.  So no real stack frame savings
ever.

Ben H. has posted patches to make powerpc use 64-bit too and with some
abstractions we can probably use a shared header file somewhere.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/rwsem-const.h |   12 ---
 arch/sparc/include/asm/rwsem.h       |  120 +++++++++++++++++++++----
 arch/sparc/lib/Makefile              |    2 +-
 arch/sparc/lib/rwsem_64.S            |  163 ----------------------------------
 4 files changed, 104 insertions(+), 193 deletions(-)
 delete mode 100644 arch/sparc/include/asm/rwsem-const.h
 delete mode 100644 arch/sparc/lib/rwsem_64.S

diff --git a/arch/sparc/include/asm/rwsem-const.h b/arch/sparc/include/asm/rwsem-const.h
deleted file mode 100644
index e4c61a1..0000000
--- a/arch/sparc/include/asm/rwsem-const.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* rwsem-const.h: RW semaphore counter constants.  */
-#ifndef _SPARC64_RWSEM_CONST_H
-#define _SPARC64_RWSEM_CONST_H
-
-#define RWSEM_UNLOCKED_VALUE		0x00000000
-#define RWSEM_ACTIVE_BIAS		0x00000001
-#define RWSEM_ACTIVE_MASK		0x0000ffff
-#define RWSEM_WAITING_BIAS		(-0x00010000)
-#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
-
-#endif /* _SPARC64_RWSEM_CONST_H */
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index 6e56210..a2b4302 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -15,16 +15,21 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
-#include <asm/rwsem-const.h>
 
 struct rwsem_waiter;
 
 struct rw_semaphore {
-	signed int count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
+	signed long			count;
+#define RWSEM_UNLOCKED_VALUE		0x00000000L
+#define RWSEM_ACTIVE_BIAS		0x00000001L
+#define RWSEM_ACTIVE_MASK		0xffffffffL
+#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
+#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
+#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+	spinlock_t			wait_lock;
+	struct list_head		wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
+	struct lockdep_map		dep_map;
 #endif
 };
 
@@ -41,6 +46,11 @@ struct rw_semaphore {
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
 
+extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem);
+extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
+
 extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
 			 struct lock_class_key *key);
 
@@ -51,27 +61,103 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)
 
-extern void __down_read(struct rw_semaphore *sem);
-extern int __down_read_trylock(struct rw_semaphore *sem);
-extern void __down_write(struct rw_semaphore *sem);
-extern int __down_write_trylock(struct rw_semaphore *sem);
-extern void __up_read(struct rw_semaphore *sem);
-extern void __up_write(struct rw_semaphore *sem);
-extern void __downgrade_write(struct rw_semaphore *sem);
+/*
+ * lock for reading
+ */
+static inline void __down_read(struct rw_semaphore *sem)
+{
+	if (unlikely(atomic64_inc_return((atomic64_t *)(&sem->count)) <= 0L))
+		rwsem_down_read_failed(sem);
+}
+
+static inline int __down_read_trylock(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	while ((tmp = sem->count) >= 0L) {
+		if (tmp == cmpxchg(&sem->count, tmp,
+				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
+			return 1;
+		}
+	}
+	return 0;
+}
 
+/*
+ * lock for writing
+ */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	__down_write(sem);
+	long tmp;
+
+	tmp = atomic64_add_return(RWSEM_ACTIVE_WRITE_BIAS,
+				  (atomic64_t *)(&sem->count));
+	if (unlikely(tmp != RWSEM_ACTIVE_WRITE_BIAS))
+		rwsem_down_write_failed(sem);
 }
 
-static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline void __down_write(struct rw_semaphore *sem)
 {
-	return atomic_add_return(delta, (atomic_t *)(&sem->count));
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
 }
 
-static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
+/*
+ * unlock after reading
+ */
+static inline void __up_read(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = atomic64_dec_return((atomic64_t *)(&sem->count));
+	if (unlikely(tmp < -1L && (tmp & RWSEM_ACTIVE_MASK) == 0L))
+		rwsem_wake(sem);
+}
+
+/*
+ * unlock after writing
+ */
+static inline void __up_write(struct rw_semaphore *sem)
+{
+	if (unlikely(atomic64_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
+					 (atomic64_t *)(&sem->count)) < 0L))
+		rwsem_wake(sem);
+}
+
+/*
+ * implement atomic add functionality
+ */
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
+{
+	atomic64_add(delta, (atomic64_t *)(&sem->count));
+}
+
+/*
+ * downgrade write lock to read lock
+ */
+static inline void __downgrade_write(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = atomic64_add_return(-RWSEM_WAITING_BIAS, (atomic64_t *)(&sem->count));
+	if (tmp < 0L)
+		rwsem_downgrade_wake(sem);
+}
+
+/*
+ * implement exchange and add functionality
+ */
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	atomic_add(delta, (atomic_t *)(&sem->count));
+	return atomic64_add_return(delta, (atomic64_t *)(&sem->count));
 }
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index c4b5e03..fa4c3ea 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -15,7 +15,7 @@ lib-$(CONFIG_SPARC32) += divdi3.o udivdi3.o
 lib-$(CONFIG_SPARC32) += copy_user.o locks.o
 lib-y                 += atomic_$(BITS).o
 lib-$(CONFIG_SPARC32) += lshrdi3.o ashldi3.o
-lib-y                 += rwsem_$(BITS).o
+lib-$(CONFIG_SPARC32) += rwsem_$(BITS).o
 lib-$(CONFIG_SPARC32) += muldi3.o bitext.o cmpdi2.o
 
 lib-$(CONFIG_SPARC64) += copy_page.o clear_page.o bzero.o
diff --git a/arch/sparc/lib/rwsem_64.S b/arch/sparc/lib/rwsem_64.S
deleted file mode 100644
index 91a7d29..0000000
--- a/arch/sparc/lib/rwsem_64.S
+++ /dev/null
@@ -1,163 +0,0 @@
-/* rwsem.S: RW semaphore assembler.
- *
- * Written by David S. Miller (davem@redhat.com), 2001.
- * Derived from asm-i386/rwsem.h
- */
-
-#include <asm/rwsem-const.h>
-
-	.section	.sched.text, "ax"
-
-	.globl		__down_read
-__down_read:
-1:	lduw		[%o0], %g1
-	add		%g1, 1, %g7
-	cas		[%o0], %g1, %g7
-	cmp		%g1, %g7
-	bne,pn		%icc, 1b
-	 add		%g7, 1, %g7
-	cmp		%g7, 0
-	bl,pn		%icc, 3f
-	 nop
-2:
-	retl
-	 nop
-3:
-	save		%sp, -192, %sp
-	call		rwsem_down_read_failed
-	 mov		%i0, %o0
-	ret
-	 restore
-	.size		__down_read, .-__down_read
-
-	.globl		__down_read_trylock
-__down_read_trylock:
-1:	lduw		[%o0], %g1
-	add		%g1, 1, %g7
-	cmp		%g7, 0
-	bl,pn		%icc, 2f
-	 mov		0, %o1
-	cas		[%o0], %g1, %g7
-	cmp		%g1, %g7
-	bne,pn		%icc, 1b
-	 mov		1, %o1
-2:	retl
-	 mov		%o1, %o0
-	.size		__down_read_trylock, .-__down_read_trylock
-
-	.globl		__down_write
-__down_write:
-	sethi		%hi(RWSEM_ACTIVE_WRITE_BIAS), %g1
-	or		%g1, %lo(RWSEM_ACTIVE_WRITE_BIAS), %g1
-1:
-	lduw		[%o0], %g3
-	add		%g3, %g1, %g7
-	cas		[%o0], %g3, %g7
-	cmp		%g3, %g7
-	bne,pn		%icc, 1b
-	 cmp		%g7, 0
-	bne,pn		%icc, 3f
-	 nop
-2:	retl
-	 nop
-3:
-	save		%sp, -192, %sp
-	call		rwsem_down_write_failed
-	 mov		%i0, %o0
-	ret
-	 restore
-	.size		__down_write, .-__down_write
-
-	.globl		__down_write_trylock
-__down_write_trylock:
-	sethi		%hi(RWSEM_ACTIVE_WRITE_BIAS), %g1
-	or		%g1, %lo(RWSEM_ACTIVE_WRITE_BIAS), %g1
-1:
-	lduw		[%o0], %g3
-	cmp		%g3, 0
-	bne,pn		%icc, 2f
-	 mov		0, %o1
-	add		%g3, %g1, %g7
-	cas		[%o0], %g3, %g7
-	cmp		%g3, %g7
-	bne,pn		%icc, 1b
-	 mov		1, %o1
-2:	retl
-	 mov		%o1, %o0
-	.size		__down_write_trylock, .-__down_write_trylock
-
-	.globl		__up_read
-__up_read:
-1:
-	lduw		[%o0], %g1
-	sub		%g1, 1, %g7
-	cas		[%o0], %g1, %g7
-	cmp		%g1, %g7
-	bne,pn		%icc, 1b
-	 cmp		%g7, 0
-	bl,pn		%icc, 3f
-	 nop
-2:	retl
-	 nop
-3:	sethi		%hi(RWSEM_ACTIVE_MASK), %g1
-	sub		%g7, 1, %g7
-	or		%g1, %lo(RWSEM_ACTIVE_MASK), %g1
-	andcc		%g7, %g1, %g0
-	bne,pn		%icc, 2b
-	 nop
-	save		%sp, -192, %sp
-	call		rwsem_wake
-	 mov		%i0, %o0
-	ret
-	 restore
-	.size		__up_read, .-__up_read
-
-	.globl		__up_write
-__up_write:
-	sethi		%hi(RWSEM_ACTIVE_WRITE_BIAS), %g1
-	or		%g1, %lo(RWSEM_ACTIVE_WRITE_BIAS), %g1
-1:
-	lduw		[%o0], %g3
-	sub		%g3, %g1, %g7
-	cas		[%o0], %g3, %g7
-	cmp		%g3, %g7
-	bne,pn		%icc, 1b
-	 sub		%g7, %g1, %g7
-	cmp		%g7, 0
-	bl,pn		%icc, 3f
-	 nop
-2:
-	retl
-	 nop
-3:
-	save		%sp, -192, %sp
-	call		rwsem_wake
-	 mov		%i0, %o0
-	ret
-	 restore
-	.size		__up_write, .-__up_write
-
-	.globl		__downgrade_write
-__downgrade_write:
-	sethi		%hi(RWSEM_WAITING_BIAS), %g1
-	or		%g1, %lo(RWSEM_WAITING_BIAS), %g1
-1:
-	lduw		[%o0], %g3
-	sub		%g3, %g1, %g7
-	cas		[%o0], %g3, %g7
-	cmp		%g3, %g7
-	bne,pn		%icc, 1b
-	 sub		%g7, %g1, %g7
-	cmp		%g7, 0
-	bl,pn		%icc, 3f
-	 nop
-2:
-	retl
-	 nop
-3:
-	save		%sp, -192, %sp
-	call		rwsem_downgrade_wake
-	 mov		%i0, %o0
-	ret
-	 restore
-	.size		__downgrade_write, .-__downgrade_write
-- 
1.7.2.1

