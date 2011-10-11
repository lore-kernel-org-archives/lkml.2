Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1JKPZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1JKPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 2/3] x86, NMI: Add NMI IPI selftest
Date: Tue, 11 Oct 2011 11:24:45 -0400
Message-Id: <1318346686-12349-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
References: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch modified the stop cpus path to use NMI instead of IRQ
as the way to communicate to the other cpus to shutdown.  There were some
concerns that various machines may have problems with using an NMI IPI.

This patch creates a selftest to check if NMI IPI is working at boot.
The idea is to help catch any issues before the machine panics and we
learn the hard way. :-)

If the selftest fails, the code tries to fall back to the original IRQ
method.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/Kconfig.debug     |   12 +++++++++
 arch/x86/include/asm/smp.h |    1 +
 arch/x86/kernel/smp.c      |    5 ++++
 arch/x86/kernel/smpboot.c  |   57 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c0f8a5c..18261c2 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -284,4 +284,16 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
+config DEBUG_NMI_IPI_SELFTEST
+	bool "NMI IPI Selftest"
+	depends on DEBUG_KERNEL
+	---help---
+	  Enabling this option turns on a quick NMI IPI selftest to
+	  verify that sending an NMI this way works for the panic and
+	  kdump paths.
+
+	  This might help diagnose strange hangs in those paths.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 73b11bc..916f89d 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -149,6 +149,7 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 }
 
 void cpu_disable_common(void);
+void native_smp_disable_nmi_ipi(void);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 7bdbf6a..f54e07a 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -247,6 +247,11 @@ static void native_irq_stop_other_cpus(int wait)
 	local_irq_restore(flags);
 }
 
+void native_smp_disable_nmi_ipi(void)
+{
+	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
+}
+
 /*
  * Reschedule call back.
  */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..dcb889f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -71,6 +71,7 @@
 
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
+#include <asm/nmi.h>
 
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
@@ -415,6 +416,57 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 		return cpu_llc_shared_mask(cpu);
 }
 
+#ifdef CONFIG_DEBUG_NMI_IPI_SELFTEST
+/* check to see if NMI IPIs work on this machine */
+static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __read_mostly;
+
+static int check_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, to_cpumask(nmi_ipi_mask))) {
+		cpumask_clear_cpu(cpu, to_cpumask(nmi_ipi_mask));
+		return NMI_HANDLED;
+	}
+
+	return NMI_DONE;
+}
+
+static bool check_nmi_ipi(void)
+{
+	unsigned long timeout;
+
+	if (num_online_cpus() > 1) {
+		cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
+		cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
+
+		if (register_nmi_handler(NMI_LOCAL, check_nmi_ipi_callback,
+					 NMI_FLAG_FIRST, "check_nmi_ipi"))
+			return false;
+
+		/* sync above data before sending NMI */
+		wmb();
+
+		apic->send_IPI_allbutself(NMI_VECTOR);
+
+		/* Don't wait longer than a second */
+		timeout = USEC_PER_SEC;
+		while (!cpumask_empty(to_cpumask(nmi_ipi_mask)) && timeout--)
+			udelay(1);
+
+		/* What happens if we timeout, do we still unregister?? */
+		unregister_nmi_handler(NMI_LOCAL, "check_nmi_ipi");
+
+		if (!timeout) {
+			pr_warn("CPU does not support NMI IPIs\n");
+			return false;
+		}
+	}
+	pr_info("NMI IPIs selftest passed\n");
+	return true;
+}
+#endif
+
 static void impress_friends(void)
 {
 	int cpu;
@@ -1142,6 +1194,11 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	pr_debug("Boot done.\n");
 
+#ifdef CONFIG_DEBUG_NMI_IPI_SELFTEST
+	/* if NMI IPI doesn't work, fallback to old irq method for panic */
+	if (check_nmi_ipi())
+		native_smp_disable_nmi_ipi();
+#endif
 	impress_friends();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
-- 
1.7.6.4

