Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab0ENMlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:41:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19328 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab0ENMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:41:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=PVWeCjSO82yn4MoSFFNgoC32pchAQH+1SgHBCUoQdLTHflKWCntGgkBLJ1XRLVk/x
	AtImRe32zWDSy6bepy+rg==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 01/10] x86 rwsem: minor cleanups
Date: Fri, 14 May 2010 05:39:33 -0700
Message-Id: <1273840782-5920-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273840782-5920-1-git-send-email-walken@google.com>
References: <1273840782-5920-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only functional change here is that __up_write won't call
call_rwsem_wake anymore if the new rwsem value is >0. This makes
no real difference since call_rwsem_wake would have noticed the
active count being nonzero and done nothing anyway.

Besides that, I clarified a few comments.

Feel free to drop this patch from the series if you don't like it;
nothing else depends on it.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/include/asm/rwsem.h |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..86e0473 100644
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
@@ -160,7 +160,7 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* subtract 0x0000ffff, returns the old value */
+		     /* adds 0xffff0001, returns the old value */
 		     "  test      %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
@@ -200,7 +200,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
-		     "  call call_rwsem_wake\n"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n"
 		     "# ending __up_read\n"
 		     : "+m" (sem->count), "=d" (tmp)
@@ -213,17 +213,16 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp;
+	rwsem_count_t tmp = -RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* tries to transition
-			0xffff0001 -> 0x00000000 */
-		     "  jz       1f\n"
-		     "  call call_rwsem_wake\n"
+		     /* substracts 0xffff0001, returns the old value */
+		     "  jns        1f\n\t"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n\t"
 		     "# ending __up_write\n"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "a" (sem), "1" (tmp)
 		     : "memory", "cc");
 }
 
-- 
1.7.0.1

