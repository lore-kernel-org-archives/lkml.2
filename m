Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2DSURB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:17:01 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52772 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab2DSUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:16:59 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Avi Kivity <avi@redhat.com>,
        Xen Devel <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 01:46:34 +0530
Message-Id: <20120419201631.5411.15263.sendpatchset@codeblue>
In-Reply-To: <20120419201209.5411.43877.sendpatchset@codeblue>
References: <20120419201209.5411.43877.sendpatchset@codeblue>
Subject: [PATCH RFC V7 11/12]  xen/pvticketlock: allow interrupts to be enabled while blocking
x-cbid: 12041910-0260-0000-0000-000000E77645
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
index e2f312f..d2ab57a 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -142,7 +142,20 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
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
@@ -157,24 +170,43 @@ static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
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
@@ -188,7 +220,9 @@ static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 	for_each_cpu(cpu, &waiting_cpus) {
 		const struct xen_lock_waiting *w = &per_cpu(lock_waiting, cpu);
 
-		if (w->lock == lock && w->want == next) {
+		/* Make sure we read lock before want */
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == next) {
 			add_stats(RELEASED_SLOW_KICKED, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
 			break;

