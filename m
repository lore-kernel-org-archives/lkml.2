Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2DSUQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:16:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38800 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab2DSUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:16:37 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Avi Kivity <avi@redhat.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 01:46:12 +0530
Message-Id: <20120419201609.5411.66223.sendpatchset@codeblue>
In-Reply-To: <20120419201209.5411.43877.sendpatchset@codeblue>
References: <20120419201209.5411.43877.sendpatchset@codeblue>
Subject: [PATCH RFC V7 10/12]  x86/ticketlock: add slowpath logic
x-cbid: 12041920-9574-0000-0000-000002458DFA
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
clears the slowpath flag.

The unlock code uses a locked add to update the head counter.  This also
acts as a full memory barrier so that its safe to subsequently
read back the slowflag state, knowing that the updated lock is visible
to the other CPUs.  If it were an unlocked add, then the flag read may
just be forwarded from the store buffer before it was visible to the other
CPUs, which could result in a deadlock.

Unfortunately this means we need to do a locked instruction when
unlocking with PV ticketlocks.  However, if PV ticketlocks are not
enabled, then the old non-locked "add" is the only unlocking code.

Note: this code relies on gcc making sure that unlikely() code is out of
line of the fastpath, which only happens when OPTIMIZE_SIZE=n.  If it
doesn't the generated code isn't too bad, but its definitely suboptimal.

Thanks to Srivatsa Vaddagiri for providing a bugfix to the original
version of this change, which has been folded in.
Thanks to Stephan Diestelhorst for commenting on some code which relied
on an inaccurate reading of the x86 memory ordering rules.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/include/asm/paravirt.h       |    2 +-
 arch/x86/include/asm/spinlock.h       |   86 +++++++++++++++++++++++---------
 arch/x86/include/asm/spinlock_types.h |    2 +
 arch/x86/kernel/paravirt-spinlocks.c  |    3 +
 arch/x86/xen/spinlock.c               |    6 ++
 5 files changed, 74 insertions(+), 25 deletions(-)
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 9769096..af49670 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -757,7 +757,7 @@ static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 60b7e83..e6881fd 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -1,11 +1,14 @@
 #ifndef _ASM_X86_SPINLOCK_H
 #define _ASM_X86_SPINLOCK_H
 
+#include <linux/jump_label.h>
 #include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>
 #include <asm/paravirt.h>
+#include <asm/bitops.h>
+
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
@@ -40,32 +43,28 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD	(1 << 11)
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
+extern struct static_key paravirt_ticketlocks_enabled;
+static __always_inline bool static_key_false(struct static_key *key);
 
-static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
-							__ticket_t ticket)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
 {
+	set_bit(0, (volatile unsigned long *)&lock->tickets.tail);
 }
 
-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
-							 __ticket_t ticket)
+#else  /* !CONFIG_PARAVIRT_SPINLOCKS */
+static __always_inline void __ticket_lock_spinning(arch_spinlock_t *lock,
+							__ticket_t ticket)
 {
 }
-
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-
-
-/*
- * If a spinlock has someone waiting on it, then kick the appropriate
- * waiting cpu.
- */
-static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
-							__ticket_t next)
+static inline void __ticket_unlock_kick(arch_spinlock_t *lock,
+							__ticket_t ticket)
 {
-	if (unlikely(lock->tickets.tail != next))
-		____ticket_unlock_kick(lock, next);
 }
 
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -79,20 +78,22 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
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
@@ -104,7 +105,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	arch_spinlock_t old, new;
 
 	old.tickets = ACCESS_ONCE(lock->tickets);
-	if (old.tickets.head != old.tickets.tail)
+	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
 	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
@@ -113,12 +114,49 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
+static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
+					    arch_spinlock_t old)
+{
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
+	    cmpxchg(&lock->head_tail, old.head_tail,
+					new.head_tail) != old.head_tail) {
+		/*
+		 * Lock still has someone queued for it, so wake up an
+		 * appropriate waiter.
+		 */
+		__ticket_unlock_kick(lock, old.tickets.head);
+	}
+}
+
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
+	if (TICKET_SLOWPATH_FLAG &&
+	    static_key_false(&paravirt_ticketlocks_enabled)) {
+		arch_spinlock_t prev;
+
+		prev = *lock;
+		add_smp(&lock->tickets.head, TICKET_LOCK_INC);
+
+		/* add_smp() is a full mb() */
 
-	__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
-	__ticket_unlock_kick(lock, next);
+		if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
+			__ticket_unlock_slowpath(lock, prev);
+	} else
+		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index e96fcbd..4f1bea1 100644
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
index 4251c1d..bbb6c73 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -4,6 +4,7 @@
  */
 #include <linux/spinlock.h>
 #include <linux/module.h>
+#include <linux/jump_label.h>
 
 #include <asm/paravirt.h>
 
@@ -15,3 +16,5 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
+struct static_key paravirt_ticketlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_ticketlocks_enabled);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index b0cdde1..e2f312f 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -157,6 +157,10 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	/* Only check lock once pending cleared */
 	barrier();
 
+	/* Mark entry to slowpath before doing the pickup test to make
+	   sure we don't deadlock with an unlocker. */
+	__ticket_enter_slowpath(lock);
+
 	/* check again make sure it didn't become free while
 	   we weren't looking  */
 	if (ACCESS_ONCE(lock->tickets.head) == want) {
@@ -233,6 +237,8 @@ void __init xen_init_spinlocks(void)
 		return;
 	}
 
+	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }

