Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab1IBAz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:55:56 -0400
Received: from claw.goop.org ([74.207.240.146]:43181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911Ab1IBAzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:41 -0400
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
Subject: [PATCH 06/13] x86/ticketlock: add slowpath logic
Date: Thu,  1 Sep 2011 17:54:59 -0700
Message-Id: <8a788f3fbf2ad1316e462bf5aae623bab9d38319.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Maintain a flag in both LSBs of the ticket lock which indicates whether
anyone is in the lock slowpath and may need kicking when the current
holder unlocks.  The flags are set when the first locker enters
the slowpath, and cleared when unlocking to an empty queue.

In the specific implementation of lock_spinning(), make sure to set
the slowpath flags on the lock just before blocking.  We must do
this before the last-chance pickup test to prevent a deadlock
with the unlocker:

Unlocker			Locker
				test for lock pickup
					-> fail
test slowpath + unlock
	-> false
				set slowpath flags
				block

Whereas this works in any ordering:

Unlocker			Locker
				set slowpath flags
				test for lock pickup
					-> fail
				block
test slowpath + unlock
	-> true, kick

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h       |   41 +++++++++++++++++++++++++++++---
 arch/x86/include/asm/spinlock_types.h |    2 +
 arch/x86/kernel/paravirt-spinlocks.c  |   37 +++++++++++++++++++++++++++++
 arch/x86/xen/spinlock.c               |    4 +++
 4 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 6028b01..2135a48 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -41,7 +41,38 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD	(1 << 11)
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
+/* Only defined when CONFIG_PARAVIRT_SPINLOCKS defined, but may as
+ * well leave the prototype always visible.  */
+extern void __ticket_unlock_release_slowpath(struct arch_spinlock *lock);
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+/*
+ * Return true if someone is in the slowpath on this lock.  This
+ * should only be used by the current lock-holder.
+ */
+static inline bool __ticket_in_slowpath(struct arch_spinlock *lock)
+{
+	return !!(lock->tickets.tail & TICKET_SLOWPATH_FLAG);
+}
+
+static inline void __ticket_enter_slowpath(struct arch_spinlock *lock)
+{
+	if (sizeof(lock->tickets.tail) == sizeof(u8))
+		asm (LOCK_PREFIX "orb %1, %0"
+		     : "+m" (lock->tickets.tail)
+		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
+	else
+		asm (LOCK_PREFIX "orw %1, %0"
+		     : "+m" (lock->tickets.tail)
+		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
+}
+
+#else  /* !CONFIG_PARAVIRT_SPINLOCKS */
+static inline bool __ticket_in_slowpath(struct arch_spinlock *lock)
+{
+	return false;
+}
 
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock, unsigned ticket)
 {
@@ -86,6 +117,7 @@ static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 
 	inc = xadd(&lock->tickets, inc);
+	inc.tail &= ~TICKET_SLOWPATH_FLAG;
 
 	for (;;) {
 		unsigned count = SPIN_THRESHOLD;
@@ -135,10 +167,11 @@ static __always_inline void __ticket_unlock_release(arch_spinlock_t *lock)
 
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
 
-	__ticket_unlock_release(lock);
-	__ticket_unlock_kick(lock, next);
+	if (unlikely(__ticket_in_slowpath(lock)))
+		__ticket_unlock_release_slowpath(lock);
+	else
+		__ticket_unlock_release(lock);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 0553c0b..7b383e2 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -9,8 +9,10 @@
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 #define __TICKET_LOCK_INC	2
+#define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
 #else
 #define __TICKET_LOCK_INC	1
+#define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
 #endif
 
 #if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 4251c1d..21b6986 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -15,3 +15,40 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
+
+/*
+ * If we're unlocking and we're leaving the lock uncontended (there's
+ * nobody else waiting for the lock), then we can clear the slowpath
+ * bits.  However, we need to be careful about this because someone
+ * may just be entering as we leave, and enter the slowpath.
+ */
+void __ticket_unlock_release_slowpath(struct arch_spinlock *lock)
+{
+	struct arch_spinlock old, new;
+
+	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
+
+	old = ACCESS_ONCE(*lock);
+
+	new = old;
+	new.tickets.head += TICKET_LOCK_INC;
+
+	/* Clear the slowpath flag */
+	new.tickets.tail &= ~TICKET_SLOWPATH_FLAG;
+
+	/*
+	 * If there's currently people waiting or someone snuck in
+	 * since we read the lock above, then do a normal unlock and
+	 * kick.  If we managed to unlock with no queued waiters, then
+	 * we can clear the slowpath flag.
+	 */
+	if (new.tickets.head != new.tickets.tail ||
+	    cmpxchg(&lock->head_tail,
+		    old.head_tail, new.head_tail) != old.head_tail) {
+		/* still people waiting */
+		__ticket_unlock_release(lock);
+	}
+
+	__ticket_unlock_kick(lock, new.tickets.head);
+}
+EXPORT_SYMBOL(__ticket_unlock_release_slowpath);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index b133865..4c46144 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -119,6 +119,10 @@ static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
 	/* Only check lock once pending cleared */
 	barrier();
 
+	/* Mark entry to slowpath before doing the pickup test to make
+	   sure we don't deadlock with an unlocker. */
+	__ticket_enter_slowpath(lock);
+
 	/* check again make sure it didn't become free while
 	   we weren't looking  */
 	if (ACCESS_ONCE(lock->tickets.head) == want) {
-- 
1.7.6

