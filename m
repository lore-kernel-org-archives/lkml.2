Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1A0L41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:56:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:53253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1A0L40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:56:26 -0500
Date: Thu, 27 Jan 2011 11:56:05 GMT
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
In-Reply-To: <20110126195833.580335506@linutronix.de>
References: <20110126195833.580335506@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86: Cleanup rwsem_count_t typedef
Message-ID: <tip-bde11efbc21ea84c3351464a422b467eaefabb9a@git.kernel.org>
Git-Commit-ID: bde11efbc21ea84c3351464a422b467eaefabb9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 11:56:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bde11efbc21ea84c3351464a422b467eaefabb9a
Gitweb:     http://git.kernel.org/tip/bde11efbc21ea84c3351464a422b467eaefabb9a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jan 2011 20:05:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Jan 2011 12:30:38 +0100

x86: Cleanup rwsem_count_t typedef

Remove the typedef which has no real reason to be there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
LKML-Reference: <20110126195833.580335506@linutronix.de>

---
 arch/x86/include/asm/rwsem.h |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index a626cff..c30206c 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
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
@@ -127,7 +125,7 @@ static inline void __down_read(struct rw_semaphore *sem)
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	rwsem_count_t result, tmp;
+	long result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
@@ -149,7 +147,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* adds 0xffff0001, returns the old value */
@@ -174,9 +172,8 @@ static inline void __down_write(struct rw_semaphore *sem)
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
@@ -187,7 +184,7 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
@@ -205,7 +202,7 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	long tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 0xffff0001, returns the old value */
@@ -241,8 +238,7 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(rwsem_count_t delta,
-				    struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 {
 	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0"
 		     : "+m" (sem->count)
@@ -252,10 +248,9 @@ static inline void rwsem_atomic_add(rwsem_count_t delta,
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
