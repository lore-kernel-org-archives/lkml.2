Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2EBKIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:08:51 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49510 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2EBKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:08:48 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-doc@vger.kernel.org,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 15:38:30 +0530
Message-Id: <20120502100830.13206.31058.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V8 11/17]  xen/pvticketlock: Allow interrupts to be enabled while blocking
x-cbid: 12050210-5564-0000-0000-0000026E9EF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If interrupts were enabled when taking the spinlock, we can leave them
enabled while blocking to get the lock.

If we can enable interrupts while waiting for the lock to become
available, and we take an interrupt before entering the poll,
and the handler takes a spinlock which ends up going into
the slow state (invalidating the per-cpu "lock" and "want" values),
then when the interrupt handler returns the event channel will
remain pending so the poll will return immediately, causing it to
return out to the main spinlock loop.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/xen/spinlock.c |   46 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 6 deletions(-)
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index d4abaf9..3bf93d5 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -140,7 +140,20 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	 * partially setup state.
 	 */
 	local_irq_save(flags);
-
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
 	smp_wmb();
 	w->lock = lock;
@@ -155,24 +168,43 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
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
 		add_stats(TAKEN_SLOW_PICKUP, 1);
 		goto out;
 	}
+
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
+
+	/*
+	 * If an interrupt happens here, it will leave the wakeup irq
+	 * pending, which will cause xen_poll_irq() to return
+	 * immediately.
+	 */
+
 	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
 	xen_poll_irq(irq);
 	add_stats(TAKEN_SLOW_SPURIOUS, !xen_test_irq_pending(irq));
+
+	local_irq_save(flags);
+
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 out:
 	cpumask_clear_cpu(cpu, &waiting_cpus);
 	w->lock = NULL;
+
 	local_irq_restore(flags);
+
 	spin_time_accum_blocked(start);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
@@ -186,7 +218,9 @@ static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 	for_each_cpu(cpu, &waiting_cpus) {
 		const struct xen_lock_waiting *w = &per_cpu(lock_waiting, cpu);
 
-		if (w->lock == lock && w->want == next) {
+		/* Make sure we read lock before want */
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == next) {
 			add_stats(RELEASED_SLOW_KICKED, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
 			break;

