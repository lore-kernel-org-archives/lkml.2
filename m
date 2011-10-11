Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1JKPZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab1JKPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:25:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] x86, reboot:  Use NMI instead of REBOOT_VECTOR to stop cpus
Date: Tue, 11 Oct 2011 11:24:44 -0400
Message-Id: <1318346686-12349-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
References: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent discussion started talking about the locking on the pstore fs
and how it relates to the kmsg infrastructure.  We noticed it was possible
for userspace to r/w to the pstore fs (grabbing the locks in the process)
and block the panic path from r/w to the same fs.

The reason was the cpu with the lock could be doing work while the crashing
cpu is panic'ing.  Busting those spinlocks might cause those cpus to step
on each other's data.  Fine, fair enough.

It was suggested it would be nice to serialize the panic path (ie stop
the other cpus) and have only one cpu running.  This would allow us to
bust the spinlocks and not worry about another cpu stepping on the data.

Of course, smp_send_stop() does this in the panic case.  kmsg_dump() would
have to be moved to be called after it.  Easy enough.

The only problem is on x86 the smp_send_stop() function calls the
REBOOT_VECTOR.  Any cpu with irqs disabled (which pstore and its backend
ERST would do), block this IPI and thus do not stop.  This makes it
difficult to reliably log data to the pstore fs.

The patch below switches from the REBOOT_VECTOR to NMI (and mimics what
kdump does).  Switching to NMI allows us to deliver the IPI when irqs are
disabled, increasing the reliability of this function.

However, Andi carefully noted that on some machines this approach does not
work because of broken BIOSes or whatever.

To help accomodate this, the next couple of patches will run a selftest and
provide a knob to disable.

V2:
  uses atomic ops to serialize the cpu that shuts everyone down

Signed-off-by: Don Zickus <dzickus@redhat.com>
---

[note] this patch sits on top of another NMI infrastructure change I have
submitted, so the nmi registeration might not apply cleanly without that patch.
---
 arch/x86/kernel/smp.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 013e7eb..7bdbf6a 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -28,6 +28,7 @@
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -147,6 +148,59 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	free_cpumask_var(allbutself);
 }
 
+static atomic_t stopping_cpu = ATOMIC_INIT(-1);
+
+static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
+{
+	/* We are registered on stopping cpu too, avoid spurious NMI */
+	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
+		return NMI_HANDLED;
+
+	stop_this_cpu(NULL);
+
+	return NMI_HANDLED;
+}
+
+static void native_nmi_stop_other_cpus(int wait)
+{
+	unsigned long flags;
+	unsigned long timeout;
+
+	if (reboot_force)
+		return;
+
+	/*
+	 * Use an own vector here because smp_call_function
+	 * does lots of things not suitable in a panic situation.
+	 */
+	if (num_online_cpus() > 1) {
+		/* did someone beat us here? */
+		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
+			return;
+
+		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
+					 NMI_FLAG_FIRST, "smp_stop"))
+			return;		/* return what? */
+
+		/* sync above data before sending NMI */
+		wmb();
+
+		apic->send_IPI_allbutself(NMI_VECTOR);
+
+		/*
+		 * Don't wait longer than a second if the caller
+		 * didn't ask us to wait.
+		 */
+		timeout = USEC_PER_SEC;
+		while (num_online_cpus() > 1 && (wait || timeout--))
+			udelay(1);
+	}
+
+	local_irq_save(flags);
+	disable_local_APIC();
+	local_irq_restore(flags);
+}
+
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
  */
@@ -159,7 +213,7 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
-static void native_stop_other_cpus(int wait)
+static void native_irq_stop_other_cpus(int wait)
 {
 	unsigned long flags;
 	unsigned long timeout;
@@ -229,7 +283,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.stop_other_cpus	= native_stop_other_cpus,
+	.stop_other_cpus	= native_nmi_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
-- 
1.7.6.4

