Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2BTTSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab2BTTSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:18:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        tony.luck@intel.com, seiji.aguchi@hds.com, ak@linux.intel.com,
        mjg@redhat.com, levinsasha928@gmail.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH v2] x86, reboot: revert stop_other_cpus to using IRQ with NMI fallback
Date: Mon, 20 Feb 2012 14:18:08 -0500
Message-Id: <1329765488-19764-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v3.3, I added code to use the NMI to stop other cpus in the panic
case.  The idea was to make sure all cpus on the system were definitely
halted to help serialize the panic path to execute the rest of the
code on a single cpu.

The main problem it was trying to solve was how to stop a cpu that
was spinning with its irqs disabled.  A IPI irq would be stuck and
couldn't get in there, but an NMI could.

Things were great until we had another conversation about some pstore
changes.  Because some of the backend pstore still uses spinlocks to
protect the device access, things could get ugly if a panic happened
and we were stuck spinning on a lock.

Now with the NMI shutting down cpus, we could assume no other cpus were
running and just bust the spin lock and proceed.

The counter argument was, well if you do that the backend could be in
a screwed up state and you might not be able to save anything as a result.
If we could have just given the cpu a little more time to finish things,
we could have grabbed the spin lock cleanly and everything would have been
fine.

Well, how do give a cpu a 'little more time' in the panic case?  For the
most part you can't without spinning on the lock and even in that case,
how long do you spin for?

So instead of making it ugly in the pstore code, I had the idea that most
spin locks are held with irqs disabled, naturally blocking other irqs until
they are done.  We just need an irq to sit there and grab the cpu once the
lock is released and irqs are re-enabled again.

I decided to modify stop_other_cpus to go back to the REBOOT_IRQ code and
use that IPI irq as the blocking irq.  This code has been working for a long
time and will give up after one second.  To fix the original problem of what
happens after one second if a cpu hasn't accepted the IPI, I just added the
NMI hammer to clobber the cpu.

The end result of this more complicated-looking-diff-than-it-really-is, is
a patch that mostly reverts

3603a25 x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus

and instead just sticks another if-case after the REBOOT_IRQ and checks to
see if online_cpus are still > 1, and if so, clobber the rest of the cpus with
an NMI.

For the most part, the NMI piece will never get hit, thus behaving just like
pre-v3.3 code.  However, in those rare conditions, we have a fallback plan.

I still wrap the NMI check with the knob 'nonmi_ipi' in case someone still has
issues with NMIs in the panic path.

I also reset the original names of the functions.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
v2:  There are no changes, just splitting the patchseries up.

Peter had questions about patch 2 in the series and how to properly shutdown
cpus to deal with subsystems that rely on cpu notifiers.  This patch does just
tries to revert some of the changes that were added during this v3.3 patch
cycle.  It doesn't really positively nor negatively impact Peter's concerns.

Instead I am trying to prevent a situation were in v3.2 we used IRQs to shutdown
the cpus, v3.3 we used NMI and v3.4 we go back to IRQs.  Instead I would rather
take this small revert to go back to IRQs and have a consistent history.

We can address Peter's concerns in another patch series that changes things at a
lower level.

 arch/x86/kernel/smp.c |  100 ++++++++++++++++++++++--------------------------
 1 files changed, 46 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 66c74f4..48d2b7d 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -109,6 +109,9 @@
  *	about nothing of note with C stepping upwards.
  */
 
+static atomic_t stopping_cpu = ATOMIC_INIT(-1);
+static bool smp_no_nmi_ipi = false;
+
 /*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
@@ -149,8 +152,6 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	free_cpumask_var(allbutself);
 }
 
-static atomic_t stopping_cpu = ATOMIC_INIT(-1);
-
 static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 {
 	/* We are registered on stopping cpu too, avoid spurious NMI */
@@ -162,7 +163,19 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
-static void native_nmi_stop_other_cpus(int wait)
+/*
+ * this function calls the 'stop' function on all other CPUs in the system.
+ */
+
+asmlinkage void smp_reboot_interrupt(void)
+{
+	ack_APIC_irq();
+	irq_enter();
+	stop_this_cpu(NULL);
+	irq_exit();
+}
+
+static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
 	unsigned long timeout;
@@ -174,20 +187,25 @@ static void native_nmi_stop_other_cpus(int wait)
 	 * Use an own vector here because smp_call_function
 	 * does lots of things not suitable in a panic situation.
 	 */
+
+	/*
+	 * We start by using the REBOOT_VECTOR irq.
+	 * The irq is treated as a sync point to allow critical
+	 * regions of code on other cpus to release their spin locks
+	 * and re-enable irqs.  Jumping straight to an NMI might
+	 * accidentally cause deadlocks with further shutdown/panic
+	 * code.  By syncing, we give the cpus up to one second to
+	 * finish their work before we force them off with the NMI.
+	 */
 	if (num_online_cpus() > 1) {
 		/* did someone beat us here? */
 		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
 			return;
 
-		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-					 NMI_FLAG_FIRST, "smp_stop"))
-			/* Note: we ignore failures here */
-			return;
-
-		/* sync above data before sending NMI */
+		/* sync above data before sending IRQ */
 		wmb();
 
-		apic->send_IPI_allbutself(NMI_VECTOR);
+		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
 		/*
 		 * Don't wait longer than a second if the caller
@@ -197,63 +215,37 @@ static void native_nmi_stop_other_cpus(int wait)
 		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
+	
+	/* if the REBOOT_VECTOR didn't work, try with the NMI */
+	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
+		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
+					 NMI_FLAG_FIRST, "smp_stop"))
+			/* Note: we ignore failures here */
+			/* Hope the REBOOT_IRQ is good enough */
+			goto finish;
 
-	local_irq_save(flags);
-	disable_local_APIC();
-	local_irq_restore(flags);
-}
-
-/*
- * this function calls the 'stop' function on all other CPUs in the system.
- */
-
-asmlinkage void smp_reboot_interrupt(void)
-{
-	ack_APIC_irq();
-	irq_enter();
-	stop_this_cpu(NULL);
-	irq_exit();
-}
-
-static void native_irq_stop_other_cpus(int wait)
-{
-	unsigned long flags;
-	unsigned long timeout;
+		/* sync above data before sending IRQ */
+		wmb();
 
-	if (reboot_force)
-		return;
+		pr_emerg("Shutting down cpus with NMI\n");
 
-	/*
-	 * Use an own vector here because smp_call_function
-	 * does lots of things not suitable in a panic situation.
-	 * On most systems we could also use an NMI here,
-	 * but there are a few systems around where NMI
-	 * is problematic so stay with an non NMI for now
-	 * (this implies we cannot stop CPUs spinning with irq off
-	 * currently)
-	 */
-	if (num_online_cpus() > 1) {
-		apic->send_IPI_allbutself(REBOOT_VECTOR);
+		apic->send_IPI_allbutself(NMI_VECTOR);
 
 		/*
-		 * Don't wait longer than a second if the caller
+		 * Don't wait longer than a 10 ms if the caller
 		 * didn't ask us to wait.
 		 */
-		timeout = USEC_PER_SEC;
+		timeout = USEC_PER_MSEC * 10;
 		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
+finish:
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
 
-static void native_smp_disable_nmi_ipi(void)
-{
-	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
-}
-
 /*
  * Reschedule call back.
  */
@@ -287,8 +279,8 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 
 static int __init nonmi_ipi_setup(char *str)
 {
-        native_smp_disable_nmi_ipi();
-        return 1;
+	smp_no_nmi_ipi = true;
+	return 1;
 }
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
@@ -298,7 +290,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.stop_other_cpus	= native_nmi_stop_other_cpus,
+	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
-- 
1.7.7.6

