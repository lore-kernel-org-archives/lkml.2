Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab0GQBFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:05:06 -0400
Received: from claw.goop.org ([74.207.240.146]:46914 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759564Ab0GQBDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:03:06 -0400
Message-Id: <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 16 Jul 2010 18:03:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inner loop of __ticket_spin_lock isn't doing anything very special,
so reimplement it in C.

For the 8 bit ticket lock variant, we use a register union to get direct
access to the lower and upper bytes in the tickets, but unfortunately gcc
won't generate a direct comparison between the two halves of the register,
so the generated asm isn't quite as pretty as the hand-coded version.
However benchmarking shows that this is actually a small improvement in
runtime performance on some benchmarks, and never a slowdown.

We also need to make sure there's a barrier at the end of the lock loop
to make sure that the compiler doesn't move any instructions from within
the locked region into the region where we don't yet own the lock.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   58 +++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d6d5784..6711d36 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -58,21 +58,21 @@
 #if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	unsigned short inc = 1 << TICKET_SHIFT;
-
-	asm volatile (
-		LOCK_PREFIX "xaddw %w0, %1\n"
-		"1:\t"
-		"cmpb %h0, %b0\n\t"
-		"je 2f\n\t"
-		"rep ; nop\n\t"
-		"movb %1, %b0\n\t"
-		/* don't need lfence here, because loads are in-order */
-		"jmp 1b\n"
-		"2:"
-		: "+Q" (inc), "+m" (lock->slock)
-		:
-		: "memory", "cc");
+	register union {
+		struct __raw_tickets tickets;
+		unsigned short slock;
+	} inc = { .slock = 1 << TICKET_SHIFT };
+
+	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
+		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
+
+	for (;;) {
+		if (inc.tickets.head == inc.tickets.tail)
+			return;
+		cpu_relax();
+		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+	}
+	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -105,22 +105,22 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned inc = 1 << TICKET_SHIFT;
-	unsigned tmp;
+	__ticket_t tmp;
 
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
-		     "movzwl %w0, %2\n\t"
-		     "shrl $16, %0\n\t"
-		     "1:\t"
-		     "cmpl %0, %2\n\t"
-		     "je 2f\n\t"
-		     "rep ; nop\n\t"
-		     "movzwl %1, %2\n\t"
-		     /* don't need lfence here, because loads are in-order */
-		     "jmp 1b\n"
-		     "2:"
-		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
-		     :
-		     : "memory", "cc");
+	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
+		     : "+r" (inc), "+m" (lock->slock)
+		     : : "memory", "cc");
+
+	tmp = inc;
+	inc >>= TICKET_SHIFT;
+
+	for (;;) {
+		if ((__ticket_t)inc == tmp)
+			return;
+		cpu_relax();
+		tmp = ACCESS_ONCE(lock->tickets.head);
+	}
+	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
-- 
1.7.1.1


