Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1JMAxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:53:03 -0400
Received: from claw.goop.org ([74.207.240.146]:47311 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1JMAvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:51:49 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V5 08/11] x86/pvticketlock: when paravirtualizing ticket locks, increment by 2
Date: Wed, 12 Oct 2011 17:51:40 -0700
Message-Id: <79ae0a17bf2b10eb8d89102ede53b6c2d08dfe94.1318466916.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Increment ticket head/tails by 2 rather than 1 to leave the LSB free
to store a "is in slowpath state" bit.  This halves the number
of possible CPUs for a given ticket size, but this shouldn't matter
in practice - kernels built for 32k+ CPU systems are probably
specially built for the hardware rather than a generic distro
kernel.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h       |   10 +++++-----
 arch/x86/include/asm/spinlock_types.h |   10 +++++++++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f0d6a59..dd155f7 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -78,7 +78,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __t
  */
 static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
-	register struct __raw_tickets inc = { .tail = 1 };
+	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 
 	inc = xadd(&lock->tickets, inc);
 
@@ -104,7 +104,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	if (old.tickets.head != old.tickets.tail)
 		return 0;
 
-	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
+	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
@@ -112,9 +112,9 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	__ticket_t next = lock->tickets.head + 1;
+	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
 
-	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
+	__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
 	__ticket_unlock_kick(lock, next);
 }
 
@@ -129,7 +129,7 @@ static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
+	return ((tmp.tail - tmp.head) & TICKET_MASK) > TICKET_LOCK_INC;
 }
 #define arch_spin_is_contended	arch_spin_is_contended
 
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index dbe223d..aa9a205 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -3,7 +3,13 @@
 
 #include <linux/types.h>
 
-#if (CONFIG_NR_CPUS < 256)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define __TICKET_LOCK_INC	2
+#else
+#define __TICKET_LOCK_INC	1
+#endif
+
+#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
 #else
@@ -11,6 +17,8 @@ typedef u16 __ticket_t;
 typedef u32 __ticketpair_t;
 #endif
 
+#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
+
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 #define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
 
-- 
1.7.6.4

