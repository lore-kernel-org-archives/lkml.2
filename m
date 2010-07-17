Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966319Ab0GQBDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:03:20 -0400
Received: from claw.goop.org ([74.207.240.146]:46947 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759577Ab0GQBDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:03:07 -0400
Message-Id: <9d5625e61c7f35e72156e8cb881e55910b4fa5dc.1279328276.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 10/12] x86/pvticketlock: keep count of blocked cpus
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 16 Jul 2010 18:03:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU blocks by calling into __ticket_lock_spinning, keep a count in
the spinlock.  This allows __ticket_lock_kick to more accurately tell
whether it has any work to do (in many cases, a spinlock may be contended,
but none of the waiters have gone into blocking).

This adds two locked instructions to the spinlock slow path (once the
lock has already spun for SPIN_THRESHOLD iterations), and adds another
one or two bytes to struct arch_spinlock.

We need to make sure we increment the waiting counter before doing the
last-chance check of the lock to see if we picked it up in the meantime.
If we don't then there's a potential deadlock:

	lock holder		lock waiter

				clear event channel
				check lock for pickup (did not)
	release lock
	check waiting counter
		(=0, no kick)
				add waiting counter
				block (=deadlock)

Moving the "add waiting counter earler" avoids the deadlock:

	lock holder		lock waiter

				clear event channel
				add waiting counter
				check lock for pickup (did not)
	release lock
	check waiting counter
		(=1, kick)
				block (and immediately wake)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h       |   27 ++++++++++++++++++++++++++-
 arch/x86/include/asm/spinlock_types.h |    3 +++
 arch/x86/xen/spinlock.c               |    4 ++++
 3 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index a79dfee..3deabca 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -65,6 +65,31 @@ static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, u
 {
 }
 
+static __always_inline bool __ticket_lock_waiters(const struct arch_spinlock *lock)
+{
+	return false;
+}
+#else
+static inline void __ticket_add_waiting(struct arch_spinlock *lock)
+{
+	if (sizeof(lock->waiting) == sizeof(u8))
+		asm (LOCK_PREFIX "addb $1, %0" : "+m" (lock->waiting) : : "memory");
+	else
+		asm (LOCK_PREFIX "addw $1, %0" : "+m" (lock->waiting) : : "memory");
+}
+
+static inline void __ticket_sub_waiting(struct arch_spinlock *lock)
+{
+	if (sizeof(lock->waiting) == sizeof(u8))
+		asm (LOCK_PREFIX "subb $1, %0" : "+m" (lock->waiting) : : "memory");
+	else
+		asm (LOCK_PREFIX "subw $1, %0" : "+m" (lock->waiting) : : "memory");
+}
+
+static __always_inline bool __ticket_lock_waiters(const struct arch_spinlock *lock)
+{
+	return ACCESS_ONCE(lock->waiting) != 0;
+}
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
 /*
@@ -106,7 +131,7 @@ static __always_inline struct __raw_tickets __ticket_spin_claim(struct arch_spin
  */
 static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 {
-	if (unlikely(lock->tickets.tail != next))
+	if (unlikely(__ticket_lock_waiters(lock)))
 		____ticket_unlock_kick(lock, next);
 }
 
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 48dafc3..b396ed5 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -26,6 +26,9 @@ typedef struct arch_spinlock {
 			__ticket_t head, tail;
 		} tickets;
 	};
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+	__ticket_t waiting;
+#endif
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { .slock = 0 } }
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index e60d5f1..2f81d5e 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -118,6 +118,8 @@ static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
 	/* Only check lock once pending cleared */
 	barrier();
 
+	__ticket_add_waiting(lock);
+
 	/* check again make sure it didn't become free while
 	   we weren't looking  */
 	if (ACCESS_ONCE(lock->tickets.head) == want) {
@@ -132,6 +134,8 @@ static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 
 out:
+	__ticket_sub_waiting(lock);
+
 	cpumask_clear_cpu(cpu, &waiting_cpus);
 	w->lock = NULL;
 	spin_time_accum_blocked(start);
-- 
1.7.1.1


