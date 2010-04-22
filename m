Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0DVTrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:47:32 -0400
Received: from kroah.org ([198.145.64.141]:41116 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab0DVT3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190917.913490701@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [118/197] x86: clean up rwsem type system
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5d0b7235d83eefdafda300656e97d368afcafc9a upstream.

The fast version of the rwsems (the code that uses xadd) has
traditionally only worked on x86-32, and as a result it mixes different
kinds of types wildly - they just all happen to be 32-bit.  We have
"long", we have "__s32", and we have "int".

To make it work on x86-64, the types suddenly matter a lot more.  It can
be either a 32-bit or 64-bit signed type, and both work (with the caveat
that a 32-bit counter will only have 15 bits of effective write
counters, so it's limited to 32767 users).  But whatever type you
choose, it needs to be used consistently.

This makes a new 'rwsem_counter_t', that is a 32-bit signed type.  For a
64-bit type, you'd need to also update the BIAS values.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/rwsem.h |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -55,6 +55,9 @@ extern asmregparm struct rw_semaphore *
 
 /*
  * the semaphore definition
+ *
+ * The bias values and the counter type needs to be extended to 64 bits
+ * if we want to have more than 32767 potential readers/writers
  */
 
 #define RWSEM_UNLOCKED_VALUE		0x00000000
@@ -64,8 +67,10 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
+typedef signed int rwsem_count_t;
+
 struct rw_semaphore {
-	signed long		count;
+	rwsem_count_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -121,7 +126,7 @@ static inline void __down_read(struct rw
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	__s32 result, tmp;
+	rwsem_count_t result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
@@ -143,7 +148,7 @@ static inline int __down_read_trylock(st
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	int tmp;
+	rwsem_count_t tmp;
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
@@ -170,9 +175,9 @@ static inline void __down_write(struct r
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	signed long ret = cmpxchg(&sem->count,
-				  RWSEM_UNLOCKED_VALUE,
-				  RWSEM_ACTIVE_WRITE_BIAS);
+	rwsem_count_t ret = cmpxchg(&sem->count,
+				    RWSEM_UNLOCKED_VALUE,
+				    RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
 	return 0;
@@ -183,7 +188,7 @@ static inline int __down_write_trylock(s
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
+	rwsem_count_t tmp = -RWSEM_ACTIVE_READ_BIAS;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
@@ -201,7 +206,7 @@ static inline void __up_read(struct rw_s
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	unsigned long tmp;
+	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* tries to transition
@@ -245,9 +250,9 @@ static inline void rwsem_atomic_add(int
 /*
  * implement exchange and add functionality
  */
-static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline rwsem_count_t rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 {
-	int tmp = delta;
+	rwsem_count_t tmp = delta;
 
 	asm volatile(LOCK_PREFIX "xadd %0,%1"
 		     : "+r" (tmp), "+m" (sem->count)


