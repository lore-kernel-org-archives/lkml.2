Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2DSUNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:13:06 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55819 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2DSUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:13:03 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 20 Apr 2012 01:42:33 +0530
Message-Id: <20120419201231.5411.98124.sendpatchset@codeblue>
In-Reply-To: <20120419201209.5411.43877.sendpatchset@codeblue>
References: <20120419201209.5411.43877.sendpatchset@codeblue>
Subject: [PATCH RFC V7 1/12]  x86/spinlock: replace pv spinlocks with pv ticketlocks
x-cbid: 12041910-5140-0000-0000-0000011AEAD4
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
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Attilio Rao <attilio.rao@citrix.com> 
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/include/asm/paravirt.h       |   32 ++++----------------
 arch/x86/include/asm/paravirt_types.h |   10 ++----
 arch/x86/include/asm/spinlock.h       |   53 ++++++++++++++++++++++++++------
 arch/x86/include/asm/spinlock_types.h |    4 --
 arch/x86/kernel/paravirt-spinlocks.c  |   15 +--------
 arch/x86/xen/spinlock.c               |    8 ++++-
 6 files changed, 61 insertions(+), 61 deletions(-)
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index aa0f913..4bcd146 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -751,36 +751,16 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static inline int arch_spin_is_locked(struct arch_spinlock *lock)
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
+							__ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
+	PVOP_VCALL2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static inline int arch_spin_is_contended(struct arch_spinlock *lock)
+static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
+							__ticket_t ticket)
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
index 76bfa2c..3e47608 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -37,6 +37,35 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+/* How long a lock should spin before we consider blocking */
+#define SPIN_THRESHOLD	(1 << 11)
+
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
+							__ticket_t ticket)
+{
+}
+
+static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
+							 __ticket_t ticket)
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
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
+							__ticket_t next)
+{
+	if (unlikely(lock->tickets.tail != next))
+		____ticket_unlock_kick(lock, next);
+}
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -50,19 +79,24 @@
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
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
+out:	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -81,7 +115,10 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
+	__ticket_t next = lock->tickets.head + 1;
+
 	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
+	__ticket_unlock_kick(lock, next);
 }
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
@@ -98,8 +135,6 @@ static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 	return (__ticket_t)(tmp.tail - tmp.head) > 1;
 }
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
-
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
@@ -132,8 +167,6 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 	arch_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (arch_spin_is_locked(lock))
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index ad0ad07..83fd3c7 100644
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
index 00461a4..f1f4540 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -138,6 +138,9 @@ struct xen_spinlock {
 	xen_spinners_t spinners;	/* count of waiting cpus */
 };
 
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+
+#if 0
 static int xen_spin_is_locked(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
@@ -165,7 +168,6 @@ static int xen_spin_trylock(struct arch_spinlock *lock)
 	return old == 0;
 }
 
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
 
 /*
@@ -353,6 +355,7 @@ static void xen_spin_unlock(struct arch_spinlock *lock)
 	if (unlikely(xl->spinners))
 		xen_spin_unlock_slow(xl);
 }
+#endif
 
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
@@ -389,13 +392,14 @@ void xen_uninit_lock_cpu(int cpu)
 void __init xen_init_spinlocks(void)
 {
 	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
-
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

