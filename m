Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1IBXyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:54:33 -0400
Received: from claw.goop.org ([74.207.240.146]:45577 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1IBXya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 1/8] x86/spinlocks: replace pv spinlocks with pv ticketlocks
Date: Fri,  2 Sep 2011 16:54:08 -0700
Message-Id: <f80110dea2b6741d224e3121e489f946d43b9d71.1315007226.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Rather than outright replacing the entire spinlock implementation in
order to paravirtualize it, keep the ticket lock implementation but add
a couple of pvops hooks on the slow patch (long spin on lock, unlocking
a contended lock).

Ticket locks have a number of nice properties, but they also have some
surprising behaviours in virtual environments.  They enforce a strict
FIFO ordering on cpus trying to take a lock; however, if the hypervisor
scheduler does not schedule the cpus in the correct order, the system can
waste a huge amount of time spinning until the next cpu can take the lock.

(See Thomas Friebel's talk "Prevent Guests from Spinning Around"
http://www.xen.org/files/xensummitboston08/LHP.pdf for more details.)

To address this, we add two hooks:
 - __ticket_spin_lock which is called after the cpu has been
   spinning on the lock for a significant number of iterations but has
   failed to take the lock (presumably because the cpu holding the lock
   has been descheduled).  The lock_spinning pvop is expected to block
   the cpu until it has been kicked by the current lock holder.
 - __ticket_spin_unlock, which on releasing a contended lock
   (there are more cpus with tail tickets), it looks to see if the next
   cpu is blocked and wakes it if so.

When compiled with CONFIG_PARAVIRT_SPINLOCKS disabled, a set of stub
functions causes all the extra code to go away.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h       |   30 ++--------------
 arch/x86/include/asm/paravirt_types.h |   10 ++---
 arch/x86/include/asm/spinlock.h       |   59 ++++++++++++++++++++++++++-------
 arch/x86/include/asm/spinlock_types.h |    4 --
 arch/x86/kernel/paravirt-spinlocks.c  |   15 +-------
 arch/x86/xen/spinlock.c               |    7 +++-
 6 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a7d2db9..76cae7a 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -750,36 +750,14 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static inline int arch_spin_is_locked(struct arch_spinlock *lock)
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, __ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
+	PVOP_VCALL2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static inline int arch_spin_is_contended(struct arch_spinlock *lock)
+static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
-}
-#define arch_spin_is_contended	arch_spin_is_contended
-
-static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
-{
-	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
-}
-
-static __always_inline void arch_spin_lock_flags(struct arch_spinlock *lock,
-						  unsigned long flags)
-{
-	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
-}
-
-static __always_inline int arch_spin_trylock(struct arch_spinlock *lock)
-{
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
-}
-
-static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
-{
-	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
+	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
 
 #endif
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8e8b9a4..005e24d 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -327,13 +327,11 @@ struct pv_mmu_ops {
 };
 
 struct arch_spinlock;
+#include <asm/spinlock_types.h>
+
 struct pv_lock_ops {
-	int (*spin_is_locked)(struct arch_spinlock *lock);
-	int (*spin_is_contended)(struct arch_spinlock *lock);
-	void (*spin_lock)(struct arch_spinlock *lock);
-	void (*spin_lock_flags)(struct arch_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct arch_spinlock *lock);
-	void (*spin_unlock)(struct arch_spinlock *lock);
+	void (*lock_spinning)(struct arch_spinlock *lock, __ticket_t ticket);
+	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f5695ee..bafed3b 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -37,6 +37,32 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+/* How long a lock should spin before we consider blocking */
+#define SPIN_THRESHOLD	(1 << 11)
+
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, __ticket_t ticket)
+{
+}
+
+static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
+{
+}
+
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
+
+/* 
+ * If a spinlock has someone waiting on it, then kick the appropriate
+ * waiting cpu.
+ */
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
+{
+	if (unlikely(lock->tickets.tail != next))
+		____ticket_unlock_kick(lock, next);
+}
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -54,19 +80,24 @@
  * save some instructions and make the code more elegant. There really isn't
  * much between them in performance though, especially as locks are out of line.
  */
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc = { .tail = 1 };
 
 	inc = xadd(&lock->tickets, inc);
 
 	for (;;) {
-		if (inc.head == inc.tail)
-			break;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+		unsigned count = SPIN_THRESHOLD;
+
+		do {
+			if (inc.head == inc.tail)
+				goto out;
+			cpu_relax();
+			inc.head = ACCESS_ONCE(lock->tickets.head);
+		} while (--count);
+		__ticket_lock_spinning(lock, inc.tail);
 	}
-	barrier();		/* make sure nothing creeps before the lock is taken */
+out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -84,7 +115,7 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 }
 
 #if (NR_CPUS < 256)
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
 		     : "+m" (lock->head_tail)
@@ -92,7 +123,7 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 		     : "memory", "cc");
 }
 #else
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
 		     : "+m" (lock->head_tail)
@@ -101,6 +132,14 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 }
 #endif
 
+static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+{
+	__ticket_t next = lock->tickets.head + 1;
+
+	__ticket_unlock_release(lock);
+	__ticket_unlock_kick(lock, next);
+}
+
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
@@ -115,8 +154,6 @@ static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
 }
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
-
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
@@ -149,8 +186,6 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 	arch_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (arch_spin_is_locked(lock))
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 8ebd5df..dbe223d 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_X86_SPINLOCK_TYPES_H
 #define _ASM_X86_SPINLOCK_TYPES_H
 
-#ifndef __LINUX_SPINLOCK_TYPES_H
-# error "please don't include this file directly"
-#endif
-
 #include <linux/types.h>
 
 #if (CONFIG_NR_CPUS < 256)
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 676b8c7..c2e010e 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,21 +7,10 @@
 
 #include <asm/paravirt.h>
 
-static inline void
-default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
-{
-	arch_spin_lock(lock);
-}
-
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
-	.spin_is_locked = __ticket_spin_is_locked,
-	.spin_is_contended = __ticket_spin_is_contended,
-
-	.spin_lock = __ticket_spin_lock,
-	.spin_lock_flags = default_spin_lock_flags,
-	.spin_trylock = __ticket_spin_trylock,
-	.spin_unlock = __ticket_spin_unlock,
+	.lock_spinning = paravirt_nop,
+	.unlock_kick = paravirt_nop,
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index cc9b1e1..23af06a 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -121,6 +121,9 @@ struct xen_spinlock {
 	unsigned short spinners;	/* count of waiting cpus */
 };
 
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+
+#if 0
 static int xen_spin_is_locked(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
@@ -148,7 +151,6 @@ static int xen_spin_trylock(struct arch_spinlock *lock)
 	return old == 0;
 }
 
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
 
 /*
@@ -338,6 +340,7 @@ static void xen_spin_unlock(struct arch_spinlock *lock)
 	if (unlikely(xl->spinners))
 		xen_spin_unlock_slow(xl);
 }
+#endif
 
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
@@ -373,12 +376,14 @@ void xen_uninit_lock_cpu(int cpu)
 
 void __init xen_init_spinlocks(void)
 {
+#if 0
 	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
 	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
 	pv_lock_ops.spin_lock = xen_spin_lock;
 	pv_lock_ops.spin_lock_flags = xen_spin_lock_flags;
 	pv_lock_ops.spin_trylock = xen_spin_trylock;
 	pv_lock_ops.spin_unlock = xen_spin_unlock;
+#endif
 }
 
 #ifdef CONFIG_XEN_DEBUG_FS
-- 
1.7.6

