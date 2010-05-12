Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0ELDXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:23:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0ELDWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=b8rdNLYxN9gHoZBy1OogmpnUVwSPWTEe7vM/BxauaZYq4xuHHutpc97uOHPHGSImX
	1g8TUQQddREjgWUZdEToQ==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 11/12] x86 rwsem: down_read_unfair implementation
Date: Tue, 11 May 2010 20:21:01 -0700
Message-Id: <1273634462-2672-12-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RWSEM_ACTIVE_WRITE_BIAS is set to be 'more negative' than RWSEM_WAITING_BIAS
so that down_read_unfair() can check for active writers by comparing
the rwsem count against RWSEM_WAITING_BIAS.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/include/asm/rwsem.h |   43 ++++++++++++++++++++++++++++++++++-------
 arch/x86/lib/rwsem_64.S      |   10 +++++++++
 arch/x86/lib/semaphore_32.S  |   17 ++++++++++++++++
 3 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index a15b84d..0b3a924 100644
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
@@ -63,16 +64,19 @@ extern asmregparm struct rw_semaphore *
  */
 
 #ifdef CONFIG_X86_64
-# define RWSEM_ACTIVE_MASK		0xffffffffL
+# define RWSEM_ACTIVE_MASK		0x7fffffffL
 #else
-# define RWSEM_ACTIVE_MASK		0x0000ffffL
+# define RWSEM_ACTIVE_MASK		0x00007fffL
 #endif
 
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
 #define RWSEM_ACTIVE_BIAS		0x00000001L
 #define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define RWSEM_ACTIVE_WRITE_BIAS		(2 * RWSEM_WAITING_BIAS + \
+					 RWSEM_ACTIVE_BIAS)
+
+#define __HAVE_DOWN_READ_UNFAIR
 
 typedef signed long rwsem_count_t;
 
@@ -129,6 +133,28 @@ static inline void __down_read(struct rw_semaphore *sem)
 }
 
 /*
+ * lock for reading - skip waiting writers
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
@@ -248,7 +274,8 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem),
+		       "er" (RWSEM_ACTIVE_READ_BIAS - RWSEM_ACTIVE_WRITE_BIAS)
 		     : "memory", "cc");
 }
 
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 770a387..328ef64 100644
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
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 63dbf75..115d2ad 100644
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
-- 
1.7.0.1

