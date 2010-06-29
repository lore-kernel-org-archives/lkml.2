Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0F2OfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:35:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50583 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab0F2OfW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 29 Jun 2010 10:35:22 -0400
Message-Id: <4C2A20E30200007800008A17@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 29 Jun 2010 15:35:46 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jeremy.fitzhardinge@citrix.com>, "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -
	 improve yield behavior on Xen
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This optional patch improves yielding behavior in that the acquire
function now checks whether the vCPU owning the lock is actually
running, yielding immediately if it isn't.

The (only) additional overhead this introduces for native execution is
the writing of the owning CPU in the lock acquire paths. If this is
considered a problem but the patch otherwise is deemed useful, even
that code could be eliminated for native execution (by further
alternative instruction patching).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KY Srinivasan <ksrinivasan@novell.com>

---
 arch/x86/include/asm/spinlock.h       |   13 +++++++++++++
 arch/x86/include/asm/spinlock_types.h |    5 +++++
 arch/x86/kernel/cpu/xen.c             |    5 ++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock.h
@@ -85,6 +85,15 @@ extern void virt_spin_unlock_stub(void);
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+static __always_inline void __ticket_spin_set_owner(arch_spinlock_t *lock,
+                                                    int owned)
+{
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+	if (owned)
+		lock->owner = percpu_read(cpu_number);
+#endif
+}
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -124,6 +133,7 @@ static __always_inline void __ticket_spi
 		ASM_OUTPUT2("+Q" (inc), "+m" (lock->slock)),
 		[stub] "i" (virt_spin_lock_stub)
 		: "memory", "cc");
+	__ticket_spin_set_owner(lock, true);
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -141,6 +151,7 @@ static __always_inline int __ticket_spin
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
+	__ticket_spin_set_owner(lock, tmp);
 
 	return tmp;
 }
@@ -192,6 +203,7 @@ static __always_inline void __ticket_spi
 		     ASM_OUTPUT2("+r" (inc), "+m" (lock->slock), "=&r" (tmp)),
 		     [stub] "i" (virt_spin_lock_stub)
 		     : "memory", "cc");
+	__ticket_spin_set_owner(lock, true);
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -212,6 +224,7 @@ static __always_inline int __ticket_spin
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
+	__ticket_spin_set_owner(lock, tmp);
 
 	return tmp;
 }
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock_types.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock_types.h
@@ -17,6 +17,11 @@ typedef struct arch_spinlock {
 # else
 			u16 cur, seq;
 # endif
+# if CONFIG_NR_CPUS <= 256
+			u8 owner;
+# else
+			u16 owner;
+# endif
 		};
 #endif
 	};
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/cpu/xen.c
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/cpu/xen.c
@@ -79,7 +79,8 @@ static void xen_spin_lock(struct arch_sp
 
 	for (count = spin_count; ({ barrier(); lock->cur != token; }); )
 		if (likely(cpu_online(raw_smp_processor_id()))
-		    && unlikely(!--count)) {
+		    && (per_cpu(runstate.state, lock->owner) != RUNSTATE_running
+			|| unlikely(!--count))) {
 			struct sched_poll sched_poll;
 
 			set_xen_guest_handle(sched_poll.ports,
@@ -91,6 +92,8 @@ static void xen_spin_lock(struct arch_sp
 		} else
 			cpu_relax();
 
+	lock->owner = raw_smp_processor_id();
+
 	/*
 	 * If we interrupted another spinlock while it was blocking, make
 	 * sure it doesn't block (again) without re-checking the lock.



