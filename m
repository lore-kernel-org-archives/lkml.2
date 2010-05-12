Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0ELDXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:23:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab0ELDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=V75kW7pSIUtffLn2yDTEhXYhMrwHacKUzS2V5JgR9dZtcZUryUKwX76LgnO75KFCk
	cqaxMfFEhFCCktTLTr6bA==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 05/12] x86 rwsem: take advantage of new RWSEM_WAITING_BIAS semantics
Date: Tue, 11 May 2010 20:20:55 -0700
Message-Id: <1273634462-2672-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that an arbitrary number of waiting threads are represented by
a single RWSEM_WAITING_BIAS, the up_read and up_write code paths can be
slightly simplified by checking for waiting threads and no active threads
all at once.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/include/asm/rwsem.h |   23 ++++++++++++++---------
 arch/x86/lib/rwsem_64.S      |    4 +---
 arch/x86/lib/semaphore_32.S  |    4 +---
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..a15b84d 100644
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
@@ -199,12 +199,15 @@ static inline void __up_read(struct rw_semaphore *sem)
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
-		     "  jns        1f\n\t"
+		     "  cmp        %4,%1\n\t"
+		     /* are there waiting threads and no active threads ? */
+		     "  jne        1f\n"
 		     "  call call_rwsem_wake\n"
 		     "1:\n"
 		     "# ending __up_read\n"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (tmp)
+		     : "a" (sem), "1" (tmp),
+		       "er" (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_READ_BIAS)
 		     : "memory", "cc");
 }
 
@@ -213,17 +216,19 @@ static inline void __up_read(struct rw_semaphore *sem)
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
+		     /* substracts 0xffff0001, returns the old value */
+		     "  cmp      %4,%1\n\t"
+		     /* are there waiting threads and no active threads ? */
+		     "  jne      1f\n"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "a" (sem), "1" (tmp),
+		       "er" (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_WRITE_BIAS)
 		     : "memory", "cc");
 }
 
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 41fcf00..770a387 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem_64.S
@@ -60,13 +60,11 @@ ENTRY(call_rwsem_down_write_failed)
 	ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
-	decl %edx	/* do nothing if still outstanding active readers */
-	jnz 1f
 	save_common_regs
 	movq %rax,%rdi
 	call rwsem_wake
 	restore_common_regs
-1:	ret
+	ret
 	ENDPROC(call_rwsem_wake)
 
 /* Fix up special calling conventions */
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..63dbf75 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -103,15 +103,13 @@ ENTRY(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
-	jnz 1f
 	push %ecx
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET ecx,0
 	call rwsem_wake
 	pop %ecx
 	CFI_ADJUST_CFA_OFFSET -4
-1:	ret
+	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_wake)
 
-- 
1.7.0.1

