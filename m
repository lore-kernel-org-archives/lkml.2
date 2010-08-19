Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab0HSFXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:23:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:45485 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0HSFXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:23:47 -0400
Subject: Re: 64-bit ppc rwsem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20100817.222818.193699062.davem@davemloft.net>
References: <20100817.191424.183031381.davem@davemloft.net>
	 <1282106338.22370.151.camel@pasglop> <1282107803.22370.173.camel@pasglop>
	 <20100817.222818.193699062.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 15:23:23 +1000
Message-ID: <1282195403.22370.296.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 22:28 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Wed, 18 Aug 2010 15:03:23 +1000
> 
> > I tried various tricks but so far they didn't work. I'll have another
> > look tomorrow, but I may end up having to keep all the crap typecasts.
> 
> The casts are pretty much unavoidable.
> 
> Here's what I'm going to end up using on sparc64:

Similar here, but using atomic_long_t instead so it works for 32-bit too
for me. I suppose we could make that part common indeed.

What about asm-generic/rwsem-atomic.h  or rwsem-cmpxchg.h ?

Below is my current patch, seems to boot fine here so far.

Cheers,
Ben

Subject: [PATCH] powerpc: Make rwsem use "long" type

This makes the 64-bit kernel use 64-bit signed integers for the counter
(effectively supporting 32-bit of active count in the semaphore), thus
avoiding things like overflow of the mmap_sem if you use a really crazy
number of threads

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/rwsem.h |   64 ++++++++++++++++++++++----------------
 1 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 24cd928..8447d89 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -21,15 +21,20 @@
 /*
  * the semaphore definition
  */
-struct rw_semaphore {
-	/* XXX this should be able to be an atomic_t  -- paulus */
-	signed int		count;
-#define RWSEM_UNLOCKED_VALUE		0x00000000
-#define RWSEM_ACTIVE_BIAS		0x00000001
-#define RWSEM_ACTIVE_MASK		0x0000ffff
-#define RWSEM_WAITING_BIAS		(-0x00010000)
+#ifdef CONFIG_PPC64
+# define RWSEM_ACTIVE_MASK		0xffffffffL
+#else
+# define RWSEM_ACTIVE_MASK		0x0000ffffL
+#endif
+
+#define RWSEM_UNLOCKED_VALUE		0x00000000L
+#define RWSEM_ACTIVE_BIAS		0x00000001L
+#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+
+struct rw_semaphore {
+	long			count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -43,9 +48,13 @@ struct rw_semaphore {
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
+#define __RWSEM_INITIALIZER(name)				\
+{								\
+	RWSEM_UNLOCKED_VALUE,					\
+	__SPIN_LOCK_UNLOCKED((name).wait_lock),			\
+	LIST_HEAD_INIT((name).wait_list)			\
+	__RWSEM_DEP_MAP_INIT(name)				\
+}
 
 #define DECLARE_RWSEM(name)		\
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
@@ -70,13 +79,13 @@ extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
  */
 static inline void __down_read(struct rw_semaphore *sem)
 {
-	if (unlikely(atomic_inc_return((atomic_t *)(&sem->count)) <= 0))
+	if (unlikely(atomic_long_inc_return((atomic_long_t *)&sem->count) <= 0))
 		rwsem_down_read_failed(sem);
 }
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
 	while ((tmp = sem->count) >= 0) {
 		if (tmp == cmpxchg(&sem->count, tmp,
@@ -92,10 +101,10 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	int tmp;
+	long tmp;
 
-	tmp = atomic_add_return(RWSEM_ACTIVE_WRITE_BIAS,
-				(atomic_t *)(&sem->count));
+	tmp = atomic_long_add_return(RWSEM_ACTIVE_WRITE_BIAS,
+				     (atomic_long_t *)&sem->count);
 	if (unlikely(tmp != RWSEM_ACTIVE_WRITE_BIAS))
 		rwsem_down_write_failed(sem);
 }
@@ -107,7 +116,7 @@ static inline void __down_write(struct rw_semaphore *sem)
 
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
 	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
 		      RWSEM_ACTIVE_WRITE_BIAS);
@@ -119,9 +128,9 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
-	tmp = atomic_dec_return((atomic_t *)(&sem->count));
+	tmp = atomic_long_dec_return((atomic_long_t *)&sem->count);
 	if (unlikely(tmp < -1 && (tmp & RWSEM_ACTIVE_MASK) == 0))
 		rwsem_wake(sem);
 }
@@ -131,17 +140,17 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	if (unlikely(atomic_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
-			      (atomic_t *)(&sem->count)) < 0))
+	if (unlikely(atomic_long_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
+				 (atomic_long_t *)&sem->count) < 0))
 		rwsem_wake(sem);
 }
 
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 {
-	atomic_add(delta, (atomic_t *)(&sem->count));
+	atomic_long_add(delta, (atomic_long_t *)&sem->count);
 }
 
 /*
@@ -149,9 +158,10 @@ static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
-	tmp = atomic_add_return(-RWSEM_WAITING_BIAS, (atomic_t *)(&sem->count));
+	tmp = atomic_long_add_return(-RWSEM_WAITING_BIAS,
+				     (atomic_long_t *)&sem->count);
 	if (tmp < 0)
 		rwsem_downgrade_wake(sem);
 }
@@ -159,14 +169,14 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 /*
  * implement exchange and add functionality
  */
-static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	return atomic_add_return(delta, (atomic_t *)(&sem->count));
+	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
 }
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return (sem->count != 0);
+	return sem->count != 0;
 }
 
 #endif	/* __KERNEL__ */


