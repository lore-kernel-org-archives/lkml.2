Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0FXDFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:05:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:31949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0FXDFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:05:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="810964577"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 3/5] x86, trigger NMI return notifier soft_irq earlier
Date: Thu, 24 Jun 2010 11:04:56 +0800
Message-Id: <1277348698-17311-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soft_irq is used to run NMI return notifiers. But it may be quite long
from soft_irq is raised in NMI handler to soft_irq is run actually. To
solve the issue, a self interrupt IPI is used to trigger the soft_irq
earlier.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/hardirq.h     |    1 +
 arch/x86/include/asm/hw_irq.h      |    1 +
 arch/x86/include/asm/irq_vectors.h |    5 +++++
 arch/x86/kernel/entry_64.S         |    5 +++++
 arch/x86/kernel/irq.c              |    7 +++++++
 arch/x86/kernel/irqinit.c          |    3 +++
 arch/x86/kernel/traps.c            |   29 +++++++++++++++++++++++++++++
 7 files changed, 51 insertions(+)

--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -11,6 +11,7 @@ typedef struct {
 #ifdef CONFIG_X86_LOCAL_APIC
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
+	unsigned int apic_nmi_return_notifier_irqs;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -35,6 +35,7 @@ extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
 extern void mce_self_interrupt(void);
+extern void nmi_return_notifier_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -125,6 +125,11 @@
  */
 #define MCE_SELF_VECTOR			0xeb
 
+/*
+ * Self IPI vector for NMI return notifier
+ */
+#define NMI_RETURN_NOTIFIER_VECTOR	0xe9
+
 #define NR_VECTORS			 256
 
 #define FPU_IRQ				  13
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1009,6 +1009,11 @@ apicinterrupt MCE_SELF_VECTOR \
 	mce_self_interrupt smp_mce_self_interrupt
 #endif
 
+#ifdef CONFIG_X86_LOCAL_APIC
+apicinterrupt NMI_RETURN_NOTIFIER_VECTOR \
+	nmi_return_notifier_interrupt smp_nmi_return_notifier_interrupt
+#endif
+
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
 	call_function_single_interrupt smp_call_function_single_interrupt
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,6 +63,12 @@ static int show_other_interrupts(struct
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
+
+	seq_printf(p, "%*s: ", prec, "NRN");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->apic_nmi_return_notifier_irqs);
+	seq_printf(p, "  NMI return notifier interrupts\n");
+
 	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
@@ -184,6 +190,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->irq_spurious_count;
+	sum += irq_stats(cpu)->apic_nmi_return_notifier_irqs;
 	sum += irq_stats(cpu)->apic_perf_irqs;
 	sum += irq_stats(cpu)->apic_pending_irqs;
 #endif
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -212,6 +212,9 @@ static void __init apic_intr_init(void)
 #if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
 	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
 #endif
+#ifdef CONFIG_X86_LOCAL_APIC
+	alloc_intr_gate(NMI_RETURN_NOTIFIER_VECTOR, nmi_return_notifier_interrupt);
+#endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -888,3 +888,32 @@ void __init trap_init(void)
 
 	x86_init.irqs.trap_init();
 }
+
+#ifdef CONFIG_X86_LOCAL_APIC
+asmlinkage void smp_nmi_return_notifier_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	inc_irq_stat(apic_nmi_return_notifier_irqs);
+	irq_exit();
+}
+
+void arch_nmi_return_notifier_schedule(struct nmi_return_notifier *nrn)
+{
+	/* Without APIC, hope next soft_irq not too late*/
+	if (!cpu_has_apic)
+		return;
+
+	/*
+	 * Use a self interrupt to trigger the soft_irq for NMI return
+	 * notifiers
+	 */
+	apic->send_IPI_self(NMI_RETURN_NOTIFIER_VECTOR);
+
+	/* Wait for idle afterward so that we don't leave the APIC in
+	 * a non idle state because the normal APIC writes cannot
+	 * exclude us.
+	 */
+	apic_wait_icr_idle();
+}
+#endif
