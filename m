Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1AZUGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:30 -0500
Received: from www.tglx.de ([62.245.132.106]:44515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1AZUG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:28 -0500
Message-Id: <20110126195833.580335506@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:05:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 2/6] x86: Cleanup rwsem_count_t typedef
References: <20110126195810.247325792@linutronix.de>
Content-Disposition: inline; filename=x86-cleanup-rwsem-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the typedef which has no real reason to be there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/rwsem.h |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/rwsem.h
+++ linux-2.6/arch/x86/include/asm/rwsem.h
@@ -68,10 +68,8 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-typedef signed long rwsem_count_t;
-
 struct rw_semaphore {
-	rwsem_count_t		count;
+	long			count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -127,7 +125,7 @@ static inline void __down_read(struct rw
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	rwsem_count_t result, tmp;
+	long result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
@@ -149,7 +147,7 @@ static inline int __down_read_trylock(st
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* adds 0xffff0001, returns the old value */
@@ -174,9 +172,8 @@ static inline void __down_write(struct r
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	rwsem_count_t ret = cmpxchg(&sem->count,
-				    RWSEM_UNLOCKED_VALUE,
-				    RWSEM_ACTIVE_WRITE_BIAS);
+	long ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+			   RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
 	return 0;
@@ -187,7 +184,7 @@ static inline int __down_write_trylock(s
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
@@ -205,7 +202,7 @@ static inline void __up_read(struct rw_s
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 0xffff0001, returns the old value */
@@ -241,8 +238,7 @@ static inline void __downgrade_write(str
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(rwsem_count_t delta,
-				    struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 {
 	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0"
 		     : "+m" (sem->count)
@@ -252,10 +248,9 @@ static inline void rwsem_atomic_add(rwse
 /*
  * implement exchange and add functionality
  */
-static inline rwsem_count_t rwsem_atomic_update(rwsem_count_t delta,
-						struct rw_semaphore *sem)
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp = delta;
+	long tmp = delta;
 
 	asm volatile(LOCK_PREFIX "xadd %0,%1"
 		     : "+r" (tmp), "+m" (sem->count)


