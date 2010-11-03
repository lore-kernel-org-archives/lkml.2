Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0KCPAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:00:42 -0400
Received: from claw.goop.org ([74.207.240.146]:35121 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0KCPAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:00:38 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/20] x86/ticketlock: make __ticket_spin_trylock common
Date: Wed,  3 Nov 2010 10:59:47 -0400
Message-Id: <4cea7b0804de5a2c1249034fc5c4840ade043ff4.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make trylock code common regardless of ticket size.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h       |   55 +++++++++-----------------------
 arch/x86/include/asm/spinlock_types.h |    3 ++
 2 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 4f9fa24..507f83c 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -100,48 +100,25 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
-#if (NR_CPUS < 256)
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	unsigned int tmp, new;
-
-	asm volatile("movzwl %2, %0\n\t"
-		     "cmpb %h0,%b0\n\t"
-		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
-}
-#else
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
-{
-	unsigned tmp;
-	unsigned new;
-
-	asm volatile("movl %2,%0\n\t"
-		     "movl %0,%1\n\t"
-		     "roll $16, %0\n\t"
-		     "cmpl %0,%1\n\t"
-		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
+	union {
+		struct __raw_tickets tickets;
+		__ticketpair_t slock;
+	} tmp, new;
+	int ret;
+
+	tmp.tickets = ACCESS_ONCE(lock->tickets);
+	if (tmp.tickets.head != tmp.tickets.tail)
+		return 0;
+
+	new.slock = tmp.slock + (1 << TICKET_SHIFT);
+
+	ret = cmpxchg(&lock->ticketpair, tmp.slock, new.slock) == tmp.slock;
+	barrier();		/* just make nothing creeps before lock is claimed */
+
+	return ret;
 }
-#endif
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 4582640..48dafc3 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -9,8 +9,10 @@
 
 #if (CONFIG_NR_CPUS < 256)
 typedef u8  __ticket_t;
+typedef u16 __ticketpair_t;
 #else
 typedef u16 __ticket_t;
+typedef u32 __ticketpair_t;
 #endif
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
@@ -19,6 +21,7 @@ typedef u16 __ticket_t;
 typedef struct arch_spinlock {
 	union {
 		unsigned int slock;
+		__ticketpair_t ticketpair;
 		struct __raw_tickets {
 			__ticket_t head, tail;
 		} tickets;
-- 
1.7.2.3

