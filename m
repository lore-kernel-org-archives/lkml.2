Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0EQW1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:27:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab0EQW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ZB8KzOmcpfqQosJjT+GkxHFDXL3T034V0THDgZKsQhykUHc273JN4YPpuKLil6c8u
	rd22xaGO+lv20tuca7HiQ==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 09/10] x86 rwsem: down_read_critical implementation
Date: Mon, 17 May 2010 15:25:53 -0700
Message-Id: <1274135154-24082-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic properties that have been true so far still hold:
- RWSEM_ACTIVE_READ_BIAS  & RWSEM_ACTIVE_MASK == 1
- RWSEM_ACTIVE_WRITE_BIAS & RWSEM_ACTIVE_MASK == 1
- RWSEM_WAITING_BIAS      & RWSEM_ACTIVE_MASK == 0
- RWSEM_ACTIVE_WRITE_BIAS < 0 and RWSEM_WAITING_BIAS < 0

A new property is introduced: RWSEM_ACTIVE_WRITE_BIAS is set to be
'more negative' than RWSEM_WAITING_BIAS. This way, even the first writer
will set the rwsem count to be < RWSEM_WAITING_BIAS and down_read_critical()
can make use of this to determine if there are any active writers.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/include/asm/rwsem.h |   53 ++++++++++++++++++++++++++++++++---------
 arch/x86/lib/rwsem_64.S      |   14 +++++++++-
 arch/x86/lib/semaphore_32.S  |   21 +++++++++++++++-
 3 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 86e0473..fbb068c 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -16,11 +16,10 @@
  * if there are writers (and maybe) readers waiting (in which case it goes to
  * sleep).
  *
- * The value of WAITING_BIAS supports up to 32766 waiting processes. This can
- * be extended to 65534 by manually checking the whole MSW rather than relying
- * on the S flag.
+ * The WRITE_BIAS value supports up to 32767 processes simultaneously
+ * trying to acquire a write lock.
  *
- * The value of ACTIVE_BIAS supports up to 65535 active processes.
+ * The value of ACTIVE_BIAS supports up to 32767 active processes.
  *
  * This should be totally fair - if anything is waiting, a process that wants a
  * lock will go to the back of the queue. When the currently active lock is
@@ -48,6 +47,8 @@ struct rwsem_waiter;
 extern asmregparm struct rw_semaphore *
  rwsem_down_read_failed(struct rw_semaphore *sem);
 extern asmregparm struct rw_semaphore *
+ rwsem_down_read_unfair_failed(struct rw_semaphore *sem);
+extern asmregparm struct rw_semaphore *
  rwsem_down_write_failed(struct rw_semaphore *sem);
 extern asmregparm struct rw_semaphore *
  rwsem_wake(struct rw_semaphore *);
@@ -62,17 +63,22 @@ extern asmregparm struct rw_semaphore *
  * for 64 bits.
  */
 
+
 #ifdef CONFIG_X86_64
-# define RWSEM_ACTIVE_MASK		0xffffffffL
+# define RWSEM_UNLOCKED_VALUE		0x0000000000000000L
+# define RWSEM_ACTIVE_MASK		0x000000007fffffffL
+# define RWSEM_ACTIVE_READ_BIAS		0x0000000000000001L
+# define RWSEM_ACTIVE_WRITE_BIAS	0xffffffff00000001L
+# define RWSEM_WAITING_BIAS		0xffffffff80000000L
 #else
-# define RWSEM_ACTIVE_MASK		0x0000ffffL
+# define RWSEM_UNLOCKED_VALUE		0x00000000L
+# define RWSEM_ACTIVE_MASK		0x00007fffL
+# define RWSEM_ACTIVE_READ_BIAS		0x00000001L
+# define RWSEM_ACTIVE_WRITE_BIAS	0xffff0001L
+# define RWSEM_WAITING_BIAS		0xffff8000L
 #endif
 
-#define RWSEM_UNLOCKED_VALUE		0x00000000L
-#define RWSEM_ACTIVE_BIAS		0x00000001L
-#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
-#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define __HAVE_DOWN_READ_UNFAIR
 
 typedef signed long rwsem_count_t;
 
@@ -129,6 +135,28 @@ static inline void __down_read(struct rw_semaphore *sem)
 }
 
 /*
+ * lock for reading - skip waiting threads
+ */
+static inline void __down_read_unfair(struct rw_semaphore *sem)
+{
+	rwsem_count_t tmp;
+
+	tmp = RWSEM_ACTIVE_READ_BIAS;
+	asm volatile("# beginning down_read_unfair\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
+		     /* adds 0x00000001, returns the old value */
+		     "  cmp       %4,%1\n\t"
+		     /* was the count >= RWSEM_WAITING_BIAS before? */
+		     "  jge       1f\n"
+		     "  call call_rwsem_down_read_unfair_failed\n"
+		     "1:\n"
+		     "# ending down_read_unfair"
+		     : "+m" (sem->count), "=r" (tmp)
+		     : "a" (sem), "1" (tmp), "re" (RWSEM_WAITING_BIAS)
+		     : "memory", "cc");
+}
+
+/*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
@@ -242,7 +270,8 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem),
+		       "er" (RWSEM_ACTIVE_READ_BIAS - RWSEM_ACTIVE_WRITE_BIAS)
 		     : "memory", "cc");
 }
 
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 41fcf00..e99d187 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem_64.S
@@ -51,6 +51,16 @@ ENTRY(call_rwsem_down_read_failed)
 	ret
 	ENDPROC(call_rwsem_down_read_failed)
 
+ENTRY(call_rwsem_down_read_unfair_failed)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_down_read_unfair_failed
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_read_failed)
+
 ENTRY(call_rwsem_down_write_failed)
 	save_common_regs
 	movq %rax,%rdi
@@ -60,8 +70,8 @@ ENTRY(call_rwsem_down_write_failed)
 	ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
-	decl %edx	/* do nothing if still outstanding active readers */
-	jnz 1f
+	cmpl $0x80000001, %edx
+	jne 1f	/* do nothing unless there are waiters and no active threads */
 	save_common_regs
 	movq %rax,%rdi
 	call rwsem_wake
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..fea9a53 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -89,6 +89,23 @@ ENTRY(call_rwsem_down_read_failed)
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_down_read_failed)
 
+ENTRY(call_rwsem_down_read_unfair_failed)
+	CFI_STARTPROC
+	push %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx,0
+	push %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edx,0
+	call rwsem_down_read_unfair_failed
+	pop %edx
+	CFI_ADJUST_CFA_OFFSET -4
+	pop %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	ret
+	CFI_ENDPROC
+	ENDPROC(call_rwsem_down_read_failed)
+
 ENTRY(call_rwsem_down_write_failed)
 	CFI_STARTPROC
 	push %ecx
@@ -103,8 +120,8 @@ ENTRY(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
-	jnz 1f
+	cmpw $0x8001, %dx
+	jne 1f	/* do nothing unless there are waiters and no active threads */
 	push %ecx
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET ecx,0
-- 
1.7.0.1

