Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1HXViW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:38:22 -0400
Received: from claw.goop.org ([74.207.240.146]:53489 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1HXVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:37:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/12] x86/ticketlock: convert __ticket_spin_lock to use xadd()
Date: Wed, 24 Aug 2011 14:37:08 -0700
Message-Id: <56b392b17830e5cf3f37ec7d7f58f819ab85720c.1314221624.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Convert the two variants of __ticket_spin_lock() to use xadd(), which
has the effect of making them identical, so remove the duplicate function.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 1c8a23c..adf010a 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -55,26 +55,22 @@
  * save some instructions and make the code more elegant. There really isn't
  * much between them in performance though, especially as locks are out of line.
  */
-#if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	register union {
-		struct __raw_tickets tickets;
-		unsigned short slock;
-	} inc = { .slock = 1 << TICKET_SHIFT };
+	register struct __raw_tickets inc = { .tail = 1 };
 
-	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
-		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
+	inc = xadd(&lock->tickets, inc);
 
 	for (;;) {
-		if (inc.tickets.head == inc.tickets.tail)
+		if (inc.head == inc.tail)
 			break;
 		cpu_relax();
-		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
+#if (NR_CPUS < 256)
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned int tmp, new;
@@ -102,27 +98,6 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 		     : "memory", "cc");
 }
 #else
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
-{
-	unsigned inc = 1 << TICKET_SHIFT;
-	__ticket_t tmp;
-
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
-		     : "+r" (inc), "+m" (lock->slock)
-		     : : "memory", "cc");
-
-	tmp = inc;
-	inc >>= TICKET_SHIFT;
-
-	for (;;) {
-		if ((__ticket_t)inc == tmp)
-			break;
-		cpu_relax();
-		tmp = ACCESS_ONCE(lock->tickets.head);
-	}
-	barrier();		/* make sure nothing creeps before the lock is taken */
-}
-
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned tmp;
-- 
1.7.6

