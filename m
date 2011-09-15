Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1IOAnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 20:43:41 -0400
Received: from claw.goop.org ([74.207.240.146]:38198 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab1IOAm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 20:42:57 -0400
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
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [PATCH 08/10] x86/ticketlock: add slowpath logic
Date: Wed, 14 Sep 2011 17:31:40 -0700
Message-Id: <618bff1804602d2f67b8a248cb86dd580fa37a79.1315878463.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Maintain a flag in the LSB of the ticket lock tail which indicates
whether anyone is in the lock slowpath and may need kicking when
the current holder unlocks.  The flags are set when the first locker
enters the slowpath, and cleared when unlocking to an empty queue (ie,
no contention).

In the specific implementation of lock_spinning(), make sure to set
the slowpath flags on the lock just before blocking.  We must do
this before the last-chance pickup test to prevent a deadlock
with the unlocker:

Unlocker			Locker
				test for lock pickup
					-> fail
unlock
test slowpath
	-> false
				set slowpath flags
				block

Whereas this works in any ordering:

Unlocker			Locker
				set slowpath flags
				test for lock pickup
					-> fail
				block
unlock
test slowpath
	-> true, kick

If the unlocker finds that the lock has the slowpath flag set but it is
actually uncontended (ie, head == tail, so nobody is waiting), then it
clear the slowpath flag.

Note on memory access ordering:
When unlocking a ticketlock with PV callbacks enabled, unlock
first "add"s to the lock head, then checks to see if the slowpath
flag is set in the lock tail.

However, because reads are not ordered with respect to writes in
different memory locations, the CPU could perform the read before
updating head to release the lock.

This would deadlock with another CPU in the lock slowpath, as it will
set the slowpath flag before checking to see if the lock has been
released in the interim.

A heavyweight fix would be to stick a full mfence between the two.
However, a lighterweight fix is to simply make sure the flag tests
loads both head and tail of the lock in a single operation, thereby
making sure that it overlaps with the memory written by the unlock,
forcing the CPU to maintain ordering.

Note: this code relies on gcc making sure that unlikely() code is out of
line of the fastpath, which only happens when OPTIMIZE_SIZE=n.  If it
doesn't the generated code isn't too bad, but its definitely suboptimal.

(Thanks to Srivatsa Vaddagiri for providing a bugfix to the original
version of this change, which has been folded in.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 arch/x86/include/asm/paravirt.h       |    2 +-
 arch/x86/include/asm/spinlock.h       |   92 ++++++++++++++++++++++++++------
 arch/x86/include/asm/spinlock_types.h |    2 +
 arch/x86/kernel/paravirt-spinlocks.c  |    1 +
 arch/x86/xen/spinlock.c               |    4 ++
 5 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 50281c7..13b3d8b 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -755,7 +755,7 @@ static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, _
 	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 40c90aa..c1f6981 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -40,29 +40,56 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD	(1 << 11)
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
 
-static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, __ticket_t ticket)
+/*
+ * Return true if someone is in the slowpath on this lock.  This
+ * should only be used by the current lock-holder.
+ */
+static inline bool __ticket_in_slowpath(arch_spinlock_t *lock)
 {
+	/*
+	 * This deliberately reads both head and tail as a single
+	 * memory operation, and then tests the flag in tail.  This is
+	 * to guarantee that this read is ordered after the "add" to
+	 * head which does the unlock.  If we were to only read "tail"
+	 * to test the flag, then the CPU would be free to reorder the
+	 * read to before the write to "head" (since it is a different
+	 * memory location), which could cause a deadlock with someone
+	 * setting the flag before re-checking the lock availability.
+	 */
+	return ACCESS_ONCE(lock->head_tail) & (TICKET_SLOWPATH_FLAG << TICKET_SHIFT);
 }
 
-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
+static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
 {
+	if (sizeof(lock->tickets.tail) == sizeof(u8))
+		asm (LOCK_PREFIX "orb %1, %0"
+		     : "+m" (lock->tickets.tail)
+		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
+	else
+		asm (LOCK_PREFIX "orw %1, %0"
+		     : "+m" (lock->tickets.tail)
+		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+#else  /* !CONFIG_PARAVIRT_SPINLOCKS */
+static inline bool __ticket_in_slowpath(arch_spinlock_t *lock)
+{
+	return false;
+}
 
+static __always_inline void __ticket_lock_spinning(arch_spinlock_t *lock, __ticket_t ticket)
+{
+}
 
-/* 
- * If a spinlock has someone waiting on it, then kick the appropriate
- * waiting cpu.
- */
-static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
+static inline void __ticket_unlock_kick(arch_spinlock_t *lock, __ticket_t ticket)
 {
-	if (unlikely(lock->tickets.tail != next))
-		____ticket_unlock_kick(lock, next);
 }
 
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -76,20 +103,22 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __t
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
  */
-static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 
 	inc = xadd(&lock->tickets, inc);
+	if (likely(inc.head == inc.tail))
+		goto out;
 
+	inc.tail &= ~TICKET_SLOWPATH_FLAG;
 	for (;;) {
 		unsigned count = SPIN_THRESHOLD;
 
 		do {
-			if (inc.head == inc.tail)
+			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
 				goto out;
 			cpu_relax();
-			inc.head = ACCESS_ONCE(lock->tickets.head);
 		} while (--count);
 		__ticket_lock_spinning(lock, inc.tail);
 	}
@@ -101,7 +130,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	arch_spinlock_t old, new;
 
 	old.tickets = ACCESS_ONCE(lock->tickets);
-	if (old.tickets.head != old.tickets.tail)
+	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
 	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
@@ -128,12 +157,39 @@ static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 }
 #endif
 
-static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
+static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
+					    arch_spinlock_t old)
 {
-	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
+	arch_spinlock_t new;
+
+	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
+
+	/* Perform the unlock on the "before" copy */
+	old.tickets.head += TICKET_LOCK_INC;
+
+	/* Clear the slowpath flag */
+	new.head_tail = old.head_tail & ~(TICKET_SLOWPATH_FLAG << TICKET_SHIFT);
+
+	/*
+	 * If the lock is uncontended, clear the flag - use cmpxchg in
+	 * case it changes behind our back though.
+	 */
+	if (new.tickets.head != new.tickets.tail ||
+	    cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) != old.head_tail) {
+		/*
+		 * Lock still has someone queued for it, so wake up an
+		 * appropriate waiter.
+		 */
+		__ticket_unlock_kick(lock, old.tickets.head);
+	}
+}
 
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	arch_spinlock_t prev = *lock;
 	__ticket_unlock_release(lock);
-	__ticket_unlock_kick(lock, next);
+	if (unlikely(__ticket_in_slowpath(lock)))
+		__ticket_unlock_slowpath(lock, prev);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index aa9a205..407f7f7 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -5,8 +5,10 @@
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 #define __TICKET_LOCK_INC	2
+#define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
 #else
 #define __TICKET_LOCK_INC	1
+#define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
 #endif
 
 #if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 4251c1d..0883c48 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -15,3 +15,4 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
+
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 7a04950..c939723 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -124,6 +124,10 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	/* Only check lock once pending cleared */
 	barrier();
 
+	/* Mark entry to slowpath before doing the pickup test to make
+	   sure we don't deadlock with an unlocker. */
+	__ticket_enter_slowpath(lock);
+
 	/* check again make sure it didn't become free while
 	   we weren't looking  */
 	if (ACCESS_ONCE(lock->tickets.head) == want) {
-- 
1.7.6

