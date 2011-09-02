Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab1IBA6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:58:03 -0400
Received: from claw.goop.org ([74.207.240.146]:43181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab1IBAz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:27 -0400
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
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/13] x86/ticketlock: only do kick after doing unlock
Date: Thu,  1 Sep 2011 17:55:04 -0700
Message-Id: <8cd2c77886e2d3fcad8258aa62509b3b2fae5545.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

We must release the lock before checking to see if the lock is in
slowpath or else there's a potential race where the lock enters the
slow path after the unlocker has checked the slowpath flag, but before
it has actually unlocked.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h      |    7 +++----
 arch/x86/kernel/paravirt-spinlocks.c |   23 ++++++-----------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 365d787..bf6dff4 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -43,7 +43,7 @@
 
 /* Only defined when CONFIG_PARAVIRT_SPINLOCKS defined, but may as
  * well leave the prototype always visible.  */
-extern void __ticket_unlock_release_slowpath(struct arch_spinlock *lock);
+extern void __ticket_unlock_slowpath(struct arch_spinlock *lock);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
@@ -154,10 +154,9 @@ static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 
+	__ticket_unlock_release(lock);
 	if (unlikely(__ticket_in_slowpath(lock)))
-		__ticket_unlock_release_slowpath(lock);
-	else
-		__ticket_unlock_release(lock);
+		__ticket_unlock_slowpath(lock);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 71b8557..674718f 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -22,32 +22,21 @@ EXPORT_SYMBOL(pv_lock_ops);
  * bits.  However, we need to be careful about this because someone
  * may just be entering as we leave, and enter the slowpath.
  */
-void __ticket_unlock_release_slowpath(struct arch_spinlock *lock)
+void __ticket_unlock_slowpath(struct arch_spinlock *lock)
 {
 	struct arch_spinlock old, new;
 
 	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
 
 	old = ACCESS_ONCE(*lock);
-
 	new = old;
-	new.tickets.head += TICKET_LOCK_INC;
 
 	/* Clear the slowpath flag */
 	new.tickets.tail &= ~TICKET_SLOWPATH_FLAG;
+	if (new.tickets.head == new.tickets.tail)
+		cmpxchg(&lock->head_tail, old.head_tail, new.head_tail);
 
-	/*
-	 * If there's currently people waiting or someone snuck in
-	 * since we read the lock above, then do a normal unlock and
-	 * kick.  If we managed to unlock with no queued waiters, then
-	 * we can clear the slowpath flag.
-	 */
-	if (new.tickets.head != new.tickets.tail ||
-	    cmpxchg(&lock->head_tail,
-		    old.head_tail, new.head_tail) != old.head_tail) {
-		/* still people waiting */
-		__ticket_unlock_release(lock);
-		__ticket_unlock_kick(lock, new.tickets.head);
-	}
+	/* Wake up an appropriate waiter */
+ 	__ticket_unlock_kick(lock, new.tickets.head);
 }
-EXPORT_SYMBOL(__ticket_unlock_release_slowpath);
+EXPORT_SYMBOL(__ticket_unlock_slowpath);
-- 
1.7.6

