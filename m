Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0LXMnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:43:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54597 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab0LXMmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:42:38 -0500
Message-Id: <20101224123742.724459093@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 24 Dec 2010 13:23:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [RFC][PATCH 05/17] x86: Optimize arch_spin_unlock_wait()
References: <20101224122338.172750730@chello.nl>
Content-Disposition: inline; filename=x86-spin-unlocked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only wait for the current holder to release the lock.

spin_unlock_wait() can only be about the current holder, since
completion of this function is inherently racy with new contenders.
Therefore, there is no reason to wait until the lock is completely
unlocked.

Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/spinlock.h |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/spinlock.h
+++ linux-2.6/arch/x86/include/asm/spinlock.h
@@ -158,18 +158,32 @@ static __always_inline void __ticket_spi
 }
 #endif
 
+#define TICKET_MASK ((1 << TICKET_SHIFT) - 1)
+
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK);
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+	return (((tmp >> TICKET_SHIFT) - tmp) & TICKET_MASK) > 1;
+}
+
+static inline void __ticket_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	if (!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK))
+		return; /* not locked */
+
+	/* wait until the current lock holder goes away */
+	while ((lock->slock & TICKET_MASK) == (tmp & TICKET_MASK))
+		cpu_relax();
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
@@ -206,7 +220,11 @@ static __always_inline void arch_spin_lo
 	arch_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	__ticket_spin_unlock_wait(lock);
+}
+#else
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
@@ -214,6 +232,8 @@ static inline void arch_spin_unlock_wait
 		cpu_relax();
 }
 
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.


