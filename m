Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab2EKSmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953Ab2EKSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:41:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] Revert "x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus"
Date: Fri, 11 May 2012 14:41:13 -0400
Message-Id: <1336761675-24296-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1336761675-24296-1-git-send-email-dzickus@redhat.com>
References: <1336761675-24296-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3603a2512f9e69dc87914ba922eb4a0812b21cd6.

Originally I wanted a better hammer to shutdown cpus during panic.
However, this really steps on the toes of various spinlocks in the
panic path.  Sometimes it is easier to wait for the IRQ to become
re-enabled to indictate the cpu left the critical region and then
shutdown the cpu.

The next patch moves the NMI addition after the IRQ part.  To make
it easier to see the logic of everything, revert this patch and
apply the next simpler patch.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/smp.c |   59 +-----------------------------------------------
 1 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 66c74f4..6d20f52 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -29,7 +29,6 @@
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
-#include <asm/nmi.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -149,60 +148,6 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	free_cpumask_var(allbutself);
 }
 
-static atomic_t stopping_cpu = ATOMIC_INIT(-1);
-
-static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
-{
-	/* We are registered on stopping cpu too, avoid spurious NMI */
-	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
-		return NMI_HANDLED;
-
-	stop_this_cpu(NULL);
-
-	return NMI_HANDLED;
-}
-
-static void native_nmi_stop_other_cpus(int wait)
-{
-	unsigned long flags;
-	unsigned long timeout;
-
-	if (reboot_force)
-		return;
-
-	/*
-	 * Use an own vector here because smp_call_function
-	 * does lots of things not suitable in a panic situation.
-	 */
-	if (num_online_cpus() > 1) {
-		/* did someone beat us here? */
-		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
-			return;
-
-		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-					 NMI_FLAG_FIRST, "smp_stop"))
-			/* Note: we ignore failures here */
-			return;
-
-		/* sync above data before sending NMI */
-		wmb();
-
-		apic->send_IPI_allbutself(NMI_VECTOR);
-
-		/*
-		 * Don't wait longer than a second if the caller
-		 * didn't ask us to wait.
-		 */
-		timeout = USEC_PER_SEC;
-		while (num_online_cpus() > 1 && (wait || timeout--))
-			udelay(1);
-	}
-
-	local_irq_save(flags);
-	disable_local_APIC();
-	local_irq_restore(flags);
-}
-
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
  */
@@ -215,7 +160,7 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
-static void native_irq_stop_other_cpus(int wait)
+static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
 	unsigned long timeout;
@@ -298,7 +243,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.stop_other_cpus	= native_nmi_stop_other_cpus,
+	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
-- 
1.7.7.6

