Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab0HEUkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:40:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760609Ab0HEUio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:44 -0400
Date: Thu, 5 Aug 2010 20:38:06 GMT
Message-Id: <201008052038.o75Kc6QU022126@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/rwsem for 2.6.36
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ying Han <yinghan@google.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-rwsem-for-linus

Michel Lespinasse (2):
      x86, rwsem: Stay on fast path when count > 0 in __up_write()
      x86, rwsem: Minor cleanups

 arch/x86/include/asm/rwsem.h |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..d1e41b0 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -118,7 +118,7 @@ static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
 		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
-		     /* adds 0x00000001, returns the old value */
+		     /* adds 0x00000001 */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
 		     "1:\n\t"
@@ -156,11 +156,9 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	rwsem_count_t tmp;
-
-	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* subtract 0x0000ffff, returns the old value */
+		     /* adds 0xffff0001, returns the old value */
 		     "  test      %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
@@ -168,7 +166,7 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 		     "1:\n"
 		     "# ending down_write"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (tmp)
+		     : "a" (sem), "1" (RWSEM_ACTIVE_WRITE_BIAS)
 		     : "memory", "cc");
 }
 
@@ -195,16 +193,16 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp = -RWSEM_ACTIVE_READ_BIAS;
+	rwsem_count_t tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
-		     "  call call_rwsem_wake\n"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n"
 		     "# ending __up_read\n"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (tmp)
+		     : "a" (sem), "1" (-RWSEM_ACTIVE_READ_BIAS)
 		     : "memory", "cc");
 }
 
@@ -216,10 +214,9 @@ static inline void __up_write(struct rw_semaphore *sem)
 	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* tries to transition
-			0xffff0001 -> 0x00000000 */
-		     "  jz       1f\n"
-		     "  call call_rwsem_wake\n"
+		     /* subtracts 0xffff0001, returns the old value */
+		     "  jns        1f\n\t"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n\t"
 		     "# ending __up_write\n"
 		     : "+m" (sem->count), "=d" (tmp)
