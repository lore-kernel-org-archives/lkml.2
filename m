Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0DVUPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:15:15 -0400
Received: from kroah.org ([198.145.64.141]:59865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab0DVUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:13 2010
Message-Id: <20100422195413.620846591@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [086/139] x86-64, rwsem: 64-bit xadd rwsem implementation
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 1838ef1d782f7527e6defe87e180598622d2d071 upstream.

For x86-64, 32767 threads really is not enough.  Change rwsem_count_t
to a signed long, so that it is 64 bits on x86-64.

This required the following changes to the assembly code:

a) %z0 doesn't work on all versions of gcc!  At least gcc 4.4.2 as
   shipped with Fedora 12 emits "ll" not "q" for 64 bits, even for
   integer operands.  Newer gccs apparently do this correctly, but
   avoid this problem by using the _ASM_ macros instead of %z.
b) 64 bits immediates are only allowed in "movq $imm,%reg"
   constructs... no others.  Change some of the constraints to "e",
   and fix the one case where we would have had to use an invalid
   immediate -- in that case, we only care about the upper half
   anyway, so just access the upper half.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <tip-bafaecd11df15ad5b1e598adc7736afcd38ee13d@git.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/rwsem.h |   53 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -41,6 +41,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
+#include <asm/asm.h>
 
 struct rwsem_waiter;
 
@@ -56,18 +57,24 @@ extern asmregparm struct rw_semaphore *
 /*
  * the semaphore definition
  *
- * The bias values and the counter type needs to be extended to 64 bits
- * if we want to have more than 32767 potential readers/writers
+ * The bias values and the counter type limits the number of
+ * potential readers/writers to 32767 for 32 bits and 2147483647
+ * for 64 bits.
  */
 
-#define RWSEM_UNLOCKED_VALUE		0x00000000
-#define RWSEM_ACTIVE_BIAS		0x00000001
-#define RWSEM_ACTIVE_MASK		0x0000ffff
-#define RWSEM_WAITING_BIAS		(-0x00010000)
+#ifdef CONFIG_X86_64
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
 
-typedef signed int rwsem_count_t;
+typedef signed long rwsem_count_t;
 
 struct rw_semaphore {
 	rwsem_count_t		count;
@@ -110,7 +117,7 @@ do {								\
 static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
-		     LOCK_PREFIX "  inc%z0      (%1)\n\t"
+		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
 		     /* adds 0x00000001, returns the old value */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
@@ -225,8 +232,25 @@ static inline void __up_write(struct rw_
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
+#ifdef CONFIG_X86_64
+# if RWSEM_WAITING_BIAS != -0x100000000
+#  error "This code assumes RWSEM_WAITING_BIAS == -2^32"
+# endif
+
+	/* 64-bit immediates are special and expensive, and not needed here */
+	asm volatile("# beginning __downgrade_write\n\t"
+		     LOCK_PREFIX "incl 4(%1)\n\t"
+		     /* transitions 0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 */
+		     "  jns       1f\n\t"
+		     "  call call_rwsem_downgrade_wake\n"
+		     "1:\n\t"
+		     "# ending __downgrade_write\n"
+		     : "+m" (sem->count)
+		     : "a" (sem)
+		     : "memory", "cc");
+#else
 	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "  add%z0    %2,(%1)\n\t"
+		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
 		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
@@ -235,22 +259,25 @@ static inline void __downgrade_write(str
 		     : "+m" (sem->count)
 		     : "a" (sem), "i" (-RWSEM_WAITING_BIAS)
 		     : "memory", "cc");
+#endif
 }
 
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(rwsem_count_t delta,
+				    struct rw_semaphore *sem)
 {
-	asm volatile(LOCK_PREFIX "add%z0 %1,%0"
+	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0"
 		     : "+m" (sem->count)
-		     : "ir" (delta));
+		     : "er" (delta));
 }
 
 /*
  * implement exchange and add functionality
  */
-static inline rwsem_count_t rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline rwsem_count_t rwsem_atomic_update(rwsem_count_t delta,
+						struct rw_semaphore *sem)
 {
 	rwsem_count_t tmp = delta;
 


