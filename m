Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1IBXz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:55:26 -0400
Received: from claw.goop.org ([74.207.240.146]:45584 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1IBXya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 8/8] xen/pvticketlock: allow interrupts to be enabled while blocking
Date: Fri,  2 Sep 2011 16:54:15 -0700
Message-Id: <b927340248ad896330903fe63a6c9adbdf533c6f.1315007226.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If interrupts were enabled when taking the spinlock, we can leave them
enabled while blocking to get the lock.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/spinlock.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index c939723..d2335f88 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -106,11 +106,28 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 
 	start = spin_time_start();
 
-	/* Make sure interrupts are disabled to ensure that these
-	   per-cpu values are not overwritten. */
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
 	local_irq_save(flags);
 
+	/*
+	 * We don't really care if we're overwriting some other
+	 * (lock,want) pair, as that would mean that we're currently
+	 * in an interrupt context, and the outer context had
+	 * interrupts enabled.  That has already kicked the VCPU out
+	 * of xen_poll_irq(), so it will just return spuriously and
+	 * retry with newly setup (lock,want).
+	 *
+	 * The ordering protocol on this is that the "lock" pointer
+	 * may only be set non-NULL if the "want" ticket is correct.
+	 * If we're updating "want", we must first clear "lock".
+	 */
+	w->lock = NULL;
+	smp_wmb();
 	w->want = want;
+	smp_wmb();
 	w->lock = lock;
 
 	/* This uses set_bit, which atomic and therefore a barrier */
@@ -124,21 +141,30 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	/* Only check lock once pending cleared */
 	barrier();
 
-	/* Mark entry to slowpath before doing the pickup test to make
-	   sure we don't deadlock with an unlocker. */
+	/*
+	 * Mark entry to slowpath before doing the pickup test to make
+	 * sure we don't deadlock with an unlocker.
+	 */
 	__ticket_enter_slowpath(lock);
 
-	/* check again make sure it didn't become free while
-	   we weren't looking  */
+	/*
+	 * check again make sure it didn't become free while
+	 * we weren't looking 
+	 */
 	if (ACCESS_ONCE(lock->tickets.head) == want) {
 		ADD_STATS(taken_slow_pickup, 1);
 		goto out;
 	}
 
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
+
 	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
 	xen_poll_irq(irq);
 	ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
 
+	local_irq_save(flags);
+
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 
 out:
@@ -160,7 +186,9 @@ static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 	for_each_cpu(cpu, &waiting_cpus) {
 		const struct xen_lock_waiting *w = &per_cpu(lock_waiting, cpu);
 
-		if (w->lock == lock && w->want == next) {
+		/* Make sure we read lock before want */
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == next) {
 			ADD_STATS(released_slow_kicked, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
 			break;
-- 
1.7.6

