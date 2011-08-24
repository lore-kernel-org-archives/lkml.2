Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1HXR4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:56:50 -0400
Received: from claw.goop.org ([74.207.240.146]:52878 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab1HXRxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
Date: Wed, 24 Aug 2011 10:53:00 -0700
Message-Id: <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make trylock code common regardless of ticket size.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h       |   49 +++++++--------------------------
 arch/x86/include/asm/spinlock_types.h |    6 +++-
 2 files changed, 14 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 37c3b10..4857dee 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -98,48 +98,19 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
-#if (NR_CPUS < 256)
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	unsigned int tmp, new;
-
-	asm volatile("movzwl %2, %0\n\t"
-		     "cmpb %h0,%b0\n\t"
-		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
-}
-#else
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
-{
-	unsigned tmp;
-	unsigned new;
-
-	asm volatile("movl %2,%0\n\t"
-		     "movl %0,%1\n\t"
-		     "roll $16, %0\n\t"
-		     "cmpl %0,%1\n\t"
-		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
+	arch_spinlock_t old, new;
+
+	old.tickets = ACCESS_ONCE(lock->tickets);
+	if (old.tickets.head != old.tickets.tail)
+		return 0;
+
+	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
+
+	/* cmpxchg is a full barrier, so nothing can move before it */
+	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
-#endif
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index e3ad1e3..72e154e 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -9,8 +9,10 @@
 
 #if (CONFIG_NR_CPUS < 256)
 typedef u8  __ticket_t;
+typedef u16 __ticketpair_t;
 #else
 typedef u16 __ticket_t;
+typedef u32 __ticketpair_t;
 #endif
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
@@ -18,14 +20,14 @@ typedef u16 __ticket_t;
 
 typedef struct arch_spinlock {
 	union {
-		unsigned int slock;
+		__ticketpair_t head_tail;
 		struct __raw_tickets {
 			__ticket_t head, tail;
 		} tickets;
 	};
 } arch_spinlock_t;
 
-#define __ARCH_SPIN_LOCK_UNLOCKED	{ { .slock = 0 } }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
 typedef struct {
 	unsigned int lock;
-- 
1.7.6

