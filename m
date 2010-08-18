Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0HREj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:39:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:52848 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab0HREjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:39:23 -0400
Subject: 64-bit ppc rwsem (was: Re: [GIT] Sparc)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20100817.191424.183031381.davem@davemloft.net>
References: <20100817.180325.104051399.davem@davemloft.net>
	 <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
	 <AANLkTimZ3rhX2AzPExEGfRCXiFNN-BGOWRKqL241-qNa@mail.gmail.com>
	 <20100817.191424.183031381.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 14:38:58 +1000
Message-ID: <1282106338.22370.151.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 19:14 -0700, David Miller wrote:

> > I merged your pull request, but you've got some fixing up to do,
> > methinks. I also really think you need to make your rwsem's use 64-bit
> > values on sparc64, because otherwise you can overflow the mmap_sem by
> > having more than 65536 threads doing page-faults (on 32-bit, having
> > more than 2**16 threads in one process is unlikely to work for other
> > reasons, like just pure stack usage, so we don't really care about the
> > 32-bit case)
> 
> I have a patch to do this already, just need to test it.
> 
> You should bug the powerpc folks too :-)

32K threads :-) you guys are nuts !

Here's an untested patch for the folks on linuxppc-dev to look at, I'll
review my own stuff & test tomorrow.

Cheers,
Ben.

powerpc: Make rwsem use "long" types on 64-bit platforms

This should avoid overflow of the mmap_sem when playing with insane
number of threads.

Not-signed-off-by-yet.

diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 24cd928..ca64a98 100644
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
+	atomic_long_t		count;
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
+	ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE),			\
+	__SPIN_LOCK_UNLOCKED((name).wait_lock),			\
+	LIST_HEAD_INIT((name).wait_list)			\
+	__RWSEM_DEP_MAP_INIT(name)				\
+}
 
 #define DECLARE_RWSEM(name)		\
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
@@ -70,16 +79,16 @@ extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
  */
 static inline void __down_read(struct rw_semaphore *sem)
 {
-	if (unlikely(atomic_inc_return((atomic_t *)(&sem->count)) <= 0))
+	if (unlikely(atomic_long_inc_return(&sem->count) <= 0))
 		rwsem_down_read_failed(sem);
 }
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
-	while ((tmp = sem->count) >= 0) {
-		if (tmp == cmpxchg(&sem->count, tmp,
+	while ((tmp = atomic_long_read(&sem->count)) >= 0) {
+		if (tmp == cmpxchg((long *)&sem->count, tmp,
 				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
 			return 1;
 		}
@@ -92,10 +101,10 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	int tmp;
+	long tmp;
 
-	tmp = atomic_add_return(RWSEM_ACTIVE_WRITE_BIAS,
-				(atomic_t *)(&sem->count));
+	tmp = atomic_long_add_return(RWSEM_ACTIVE_WRITE_BIAS,
+				     &sem->count);
 	if (unlikely(tmp != RWSEM_ACTIVE_WRITE_BIAS))
 		rwsem_down_write_failed(sem);
 }
@@ -107,9 +116,9 @@ static inline void __down_write(struct rw_semaphore *sem)
 
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
-	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+	tmp = cmpxchg((long *)&sem->count, RWSEM_UNLOCKED_VALUE,
 		      RWSEM_ACTIVE_WRITE_BIAS);
 	return tmp == RWSEM_UNLOCKED_VALUE;
 }
@@ -119,9 +128,9 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
-	tmp = atomic_dec_return((atomic_t *)(&sem->count));
+	tmp = atomic_long_dec_return(&sem->count);
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
+					    &sem->count) < 0))
 		rwsem_wake(sem);
 }
 
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 {
-	atomic_add(delta, (atomic_t *)(&sem->count));
+	atomic_long_add(delta, &sem->count);
 }
 
 /*
@@ -149,9 +158,9 @@ static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
-	int tmp;
+	long tmp;
 
-	tmp = atomic_add_return(-RWSEM_WAITING_BIAS, (atomic_t *)(&sem->count));
+	tmp = atomic_long_add_return(-RWSEM_WAITING_BIAS, &sem->count);
 	if (tmp < 0)
 		rwsem_downgrade_wake(sem);
 }
@@ -159,14 +168,14 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 /*
  * implement exchange and add functionality
  */
-static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	return atomic_add_return(delta, (atomic_t *)(&sem->count));
+	return atomic_long_add_return(delta, &sem->count);
 }
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return (sem->count != 0);
+	return atomic_long_read(&sem->count) != 0;
 }
 
 #endif	/* __KERNEL__ */


