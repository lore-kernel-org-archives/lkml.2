Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271Ab1FXBTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:19:30 -0400
Received: from claw.goop.org ([74.207.240.146]:41611 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020Ab1FXBT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:19:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/8] x86/ticketlock: make large and small ticket versions of spin_lock the same
Date: Thu, 23 Jun 2011 18:19:16 -0700
Message-Id: <9eea42d16aabc7624488eb62213a763dbbacef38.1308878118.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <05552e1c97739f589cb76c20b5a6565ccd506636.1308878118.git.jeremy.fitzhardinge@citrix.com>
References: <05552e1c97739f589cb76c20b5a6565ccd506636.1308878118.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make the bulk of __ticket_spin_lock look identical for large and small
number of cpus.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 704b0c3..694b8a0 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -70,19 +70,16 @@ static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
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
 			goto out;
 		cpu_relax();
-		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
@@ -108,21 +105,17 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 #else
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	unsigned inc = 1 << TICKET_SHIFT;
-	__ticket_t tmp;
+	register struct __raw_tickets inc = { .tail = 1 };
 
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
 			goto out;
 		cpu_relax();
-		tmp = ACCESS_ONCE(lock->tickets.head);
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 	}
 out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
-- 
1.7.5.4

