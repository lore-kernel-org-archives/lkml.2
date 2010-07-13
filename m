Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab0GQAtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:49:31 -0400
Received: from claw.goop.org ([74.207.240.146]:40919 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560Ab0GQAs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:48:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 13 Jul 2010 14:07:45 -0700
Subject: [PATCH RFC 04/12] x86/ticketlock: make large and small ticket versions of spin_lock the same
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>
Message-Id: <20100717004855.B8993A3C4A@abulafia.goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the bulk of __ticket_spin_lock look identical for large and small
number of cpus.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 082990a..7586d7a 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -72,19 +72,16 @@ static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
 #if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	register union {
-		struct __raw_tickets tickets;
-		unsigned short slock;
-	} inc = { .slock = 1 << TICKET_SHIFT };
+	register struct __raw_tickets inc = { .tail = 1 };
 
 	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
-		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
+		      : "+r" (inc), "+m" (lock->tickets) : : "memory", "cc");
 
 	for (;;) {
-		if (inc.tickets.head == inc.tickets.tail)
+		if (inc.head == inc.tail)
 			return;
 		cpu_relax();
-		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
@@ -110,21 +107,17 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 #else
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	unsigned inc = 1 << TICKET_SHIFT;
-	__ticket_t tmp;
+	register struct __raw_tickets inc = { .tickets.tail = 1 };
 
 	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
-		     : "+r" (inc), "+m" (lock->slock)
+		     : "+r" (inc), "+m" (lock->tickets)
 		     : : "memory", "cc");
 
-	tmp = inc;
-	inc >>= TICKET_SHIFT;
-
 	for (;;) {
-		if ((__ticket_t)inc == tmp)
+		if (inc.head == inc.tail)
 			return;
 		cpu_relax();
-		tmp = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
-- 
1.7.1.1


