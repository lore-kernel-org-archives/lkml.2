Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0EXUby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:31:54 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0EXUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:31:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=oAGUIWuTNjZOgYB7Gfa9c2/038aTjmRKA3h7dbO5vxO28kGcgHltZXqxgK9KTNHI8
	IVt8Q/z5TyLZaJG/YyuUw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 02/11] x86 rwsem: minor cleanups
Date: Mon, 24 May 2010 13:31:12 -0700
Message-Id: <1274733081-4623-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274733081-4623-1-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarified few comments and made initialization of %edx/%rdx more uniform
accross __down_write_nested, __up_read and __up_write functions.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/x86/include/asm/rwsem.h |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 3fd1ed3..0892acc 100644
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
 
@@ -218,7 +216,7 @@ static inline void __up_write(struct rw_semaphore *sem)
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* substracts 0xffff0001, returns the old value */
 		     "  jns        1f\n\t"
-		     "  call call_rwsem_wake\n"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n\t"
 		     "# ending __up_write\n"
 		     : "+m" (sem->count), "=d" (tmp)
-- 
1.7.0.1

