Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1IBXyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:54:36 -0400
Received: from claw.goop.org ([74.207.240.146]:45584 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1IBXya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:54:30 -0400
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
Subject: [PATCH 6/8] x86/ticketlocks: when paravirtualizing ticket locks, increment by 2
Date: Fri,  2 Sep 2011 16:54:13 -0700
Message-Id: <82b5dc58aa9e5ce0b6352d06a1eaf78983021f96.1315007226.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
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
 arch/x86/include/asm/spinlock.h       |   16 ++++++++--------
 arch/x86/include/asm/spinlock_types.h |   10 +++++++++-
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d1a3970..7a1c0c4 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -82,7 +82,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __t
  */
 static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
-	register struct __raw_tickets inc = { .tail = 1 };
+	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 
 	inc = xadd(&lock->tickets, inc);
 
@@ -108,7 +108,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	if (old.tickets.head != old.tickets.tail)
 		return 0;
 
-	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
+	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
@@ -117,24 +117,24 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 #if (NR_CPUS < 256)
 static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
+	asm volatile(UNLOCK_LOCK_PREFIX "addb %1, %0"
 		     : "+m" (lock->head_tail)
-		     :
+		     : "i" (TICKET_LOCK_INC)
 		     : "memory", "cc");
 }
 #else
 static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
+	asm volatile(UNLOCK_LOCK_PREFIX "addw %1, %0"
 		     : "+m" (lock->head_tail)
-		     :
+		     : "i" (TICKET_LOCK_INC)
 		     : "memory", "cc");
 }
 #endif
 
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	__ticket_t next = lock->tickets.head + 1;
+	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
 
 	__ticket_unlock_release(lock);
 	__ticket_unlock_kick(lock, next);
@@ -151,7 +151,7 @@ static inline int arch_spin_is_contended(arch_spinlock_t *lock)
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
1.7.6

