Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0DVT3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:25 -0400
Received: from kroah.org ([198.145.64.141]:41111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab0DVT3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:03 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190917.825791522@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [117/197] x86-32: clean up rwsem inline asm statements
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 59c33fa7791e9948ba467c2b83e307a0d087ab49 upstream.

This makes gcc use the right register names and instruction operand sizes
automatically for the rwsem inline asm statements.

So instead of using "(%%eax)" to specify the memory address that is the
semaphore, we use "(%1)" or similar. And instead of forcing the operation
to always be 32-bit, we use "%z0", taking the size from the actual
semaphore data structure itself.

This doesn't actually matter on x86-32, but if we want to use the same
inline asm for x86-64, we'll need to have the compiler generate the proper
64-bit names for the registers (%rax instead of %eax), and if we want to
use a 64-bit counter too (in order to avoid the 15-bit limit on the
write counter that limits concurrent users to 32767 threads), we'll need
to be able to generate instructions with "q" accesses rather than "l".

Since this header currently isn't enabled on x86-64, none of that matters,
but we do want to use the xadd version of the semaphores rather than have
to take spinlocks to do a rwsem. The mm->mmap_sem can be heavily contended
when you have lots of threads all taking page faults, and the fallback
rwsem code that uses a spinlock performs abysmally badly in that case.

[ hpa: modified the patch to skip size suffixes entirely when they are
  redundant due to register operands. ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/rwsem.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -105,7 +105,7 @@ do {								\
 static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
-		     LOCK_PREFIX "  incl      (%%eax)\n\t"
+		     LOCK_PREFIX "  inc%z0      (%1)\n\t"
 		     /* adds 0x00000001, returns the old value */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
@@ -123,12 +123,12 @@ static inline int __down_read_trylock(st
 {
 	__s32 result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
-		     "  movl      %0,%1\n\t"
+		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
-		     "  movl	     %1,%2\n\t"
-		     "  addl      %3,%2\n\t"
+		     "  mov          %1,%2\n\t"
+		     "  add          %3,%2\n\t"
 		     "  jle	     2f\n\t"
-		     LOCK_PREFIX "  cmpxchgl  %2,%0\n\t"
+		     LOCK_PREFIX "  cmpxchg  %2,%0\n\t"
 		     "  jnz	     1b\n\t"
 		     "2:\n\t"
 		     "# ending __down_read_trylock\n\t"
@@ -147,9 +147,9 @@ static inline void __down_write_nested(s
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtract 0x0000ffff, returns the old value */
-		     "  testl     %%edx,%%edx\n\t"
+		     "  test      %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
 		     "  call call_rwsem_down_write_failed\n"
@@ -185,7 +185,7 @@ static inline void __up_read(struct rw_s
 {
 	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
 	asm volatile("# beginning __up_read\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n"
@@ -201,18 +201,18 @@ static inline void __up_read(struct rw_s
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
+	unsigned long tmp;
 	asm volatile("# beginning __up_write\n\t"
-		     "  movl      %2,%%edx\n\t"
-		     LOCK_PREFIX "  xaddl     %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* tries to transition
 			0xffff0001 -> 0x00000000 */
 		     "  jz       1f\n"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
-		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_ACTIVE_WRITE_BIAS)
-		     : "memory", "cc", "edx");
+		     : "+m" (sem->count), "=d" (tmp)
+		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "memory", "cc");
 }
 
 /*
@@ -221,7 +221,7 @@ static inline void __up_write(struct rw_
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "  addl      %2,(%%eax)\n\t"
+		     LOCK_PREFIX "  add%z0    %2,(%1)\n\t"
 		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
@@ -237,7 +237,7 @@ static inline void __downgrade_write(str
  */
 static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
 {
-	asm volatile(LOCK_PREFIX "addl %1,%0"
+	asm volatile(LOCK_PREFIX "add%z0 %1,%0"
 		     : "+m" (sem->count)
 		     : "ir" (delta));
 }


