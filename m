Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1LENWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:22:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1LENWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:22:00 -0500
Date: Mon, 5 Dec 2011 05:21:24 -0800
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
Git-Commit-ID: 3603a2512f9e69dc87914ba922eb4a0812b21cd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:21:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3603a2512f9e69dc87914ba922eb4a0812b21cd6
Gitweb:     http://git.kernel.org/tip/3603a2512f9e69dc87914ba922eb4a0812b21cd6
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 13 Oct 2011 15:14:25 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:00:14 +0100

x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus

A recent discussion started talking about the locking on the
pstore fs and how it relates to the kmsg infrastructure.  We
noticed it was possible for userspace to r/w to the pstore fs
(grabbing the locks in the process) and block the panic path
from r/w to the same fs.

The reason was the cpu with the lock could be doing work while
the crashing cpu is panic'ing.  Busting those spinlocks might
cause those cpus to step on each other's data.  Fine, fair
enough.

It was suggested it would be nice to serialize the panic path
(ie stop the other cpus) and have only one cpu running.  This
would allow us to bust the spinlocks and not worry about another
cpu stepping on the data.

Of course, smp_send_stop() does this in the panic case.
kmsg_dump() would have to be moved to be called after it.  Easy
enough.

The only problem is on x86 the smp_send_stop() function calls
the REBOOT_VECTOR.  Any cpu with irqs disabled (which pstore and
its backend ERST would do), block this IPI and thus do not stop.
 This makes it difficult to reliably log data to the pstore fs.

The patch below switches from the REBOOT_VECTOR to NMI (and
mimics what kdump does).  Switching to NMI allows us to deliver
the IPI when irqs are disabled, increasing the reliability of
this function.

However, Andi carefully noted that on some machines this
approach does not work because of broken BIOSes or whatever.

To help accomodate this, the next couple of patches will run a
selftest and provide a knob to disable.

V2:
  uses atomic ops to serialize the cpu that shuts everyone down
V3:
  comment cleanup

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: seiji.aguchi@hds.com
Cc: vgoyal@redhat.com
Cc: mjg@redhat.com
Cc: tony.luck@intel.com
Cc: gong.chen@intel.com
Cc: satoru.moriya@hds.com
Cc: avi@redhat.com
Cc: Andi Kleen <andi@firstfloor.org>
Link: http://lkml.kernel.org/r/1318533267-18880-2-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smp.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 16204dc..e72b175 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -148,6 +149,60 @@ void native_send_call_func_ipi(const struct cpumask *mask)
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
+			/* Note: we ignore failures here */
+			return;
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
@@ -160,7 +215,7 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
-static void native_stop_other_cpus(int wait)
+static void native_irq_stop_other_cpus(int wait)
 {
 	unsigned long flags;
 	unsigned long timeout;
@@ -230,7 +285,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.stop_other_cpus	= native_stop_other_cpus,
+	.stop_other_cpus	= native_nmi_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
