Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0FLJ2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:28:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:54293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab0FLJ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:28:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,407,1272870000"; 
   d="scan'208";a="807276934"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 1/3] Unified NMI delayed call mechanism
Date: Sat, 12 Jun 2010 17:28:14 +0800
Message-Id: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NMI can be triggered even when IRQ is masked. So it is not safe for
NMI handler to call some functions. One solution is to delay the call
via self interrupt, so that the delayed call can be done once the
interrupt is enabled again. This has been implemented in MCE and perf
event. This patch provides a unified version and make it easier for
other NMI semantic handler to take use of the delayed call.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    1 
 arch/x86/include/asm/hw_irq.h      |    1 
 arch/x86/include/asm/irq_vectors.h |    5 +
 arch/x86/include/asm/nmi.h         |    7 ++
 arch/x86/kernel/entry_64.S         |    3 +
 arch/x86/kernel/irqinit.c          |    3 +
 arch/x86/kernel/traps.c            |  104 +++++++++++++++++++++++++++++++++++++
 7 files changed, 124 insertions(+)

--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -65,4 +65,5 @@ BUILD_INTERRUPT(threshold_interrupt,THRE
 BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
 #endif
 
+BUILD_INTERRUPT(nmi_delayed_call_interrupt,NMI_DELAYED_CALL_VECTOR)
 #endif
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -35,6 +35,7 @@ extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
 extern void mce_self_interrupt(void);
+extern void nmi_delayed_call_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -125,6 +125,11 @@
  */
 #define MCE_SELF_VECTOR			0xeb
 
+/*
+ * Self IPI vector for NMI delayed call
+ */
+#define NMI_DELAYED_CALL_VECTOR		0xe9
+
 #define NR_VECTORS			 256
 
 #define FPU_IRQ				  13
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -75,4 +75,11 @@ void enable_lapic_nmi_watchdog(void);
 void stop_nmi(void);
 void restart_nmi(void);
 
+#define NMI_DELAYED_CALL_ID_INVALID	-1
+
+typedef void (*nmi_delayed_call_func_t)(void);
+int nmi_delayed_call_register(nmi_delayed_call_func_t func);
+void nmi_delayed_call_unregister(int id);
+void nmi_delayed_call_schedule(int id);
+
 #endif /* _ASM_X86_NMI_H */
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1009,6 +1009,9 @@ apicinterrupt MCE_SELF_VECTOR \
 	mce_self_interrupt smp_mce_self_interrupt
 #endif
 
+apicinterrupt NMI_DELAYED_CALL_VECTOR \
+	nmi_delayed_call_interrupt smp_nmi_delayed_call_interrupt
+
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
 	call_function_single_interrupt smp_call_function_single_interrupt
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -212,6 +212,9 @@ static void __init apic_intr_init(void)
 #if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
 	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
 #endif
+#if defined(CONFIG_X86_LOCAL_APIC)
+	alloc_intr_gate(NMI_DELAYED_CALL_VECTOR, nmi_delayed_call_interrupt);
+#endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -888,3 +888,107 @@ void __init trap_init(void)
 
 	x86_init.irqs.trap_init();
 }
+
+#define NMI_DELAYED_CALL_ID_MAX		32
+#define NMI_DELAYED_CALL_RESTART_MAX	5
+
+static nmi_delayed_call_func_t nmi_delayed_call_funcs[NMI_DELAYED_CALL_ID_MAX];
+static DEFINE_SPINLOCK(nmi_delayed_call_lock);
+
+static DEFINE_PER_CPU(unsigned long, nmi_delayed_call_pending);
+
+static void nmi_delayed_call_run(void)
+{
+	int cpu, restart = NMI_DELAYED_CALL_RESTART_MAX;
+	unsigned long pending, *ppending;
+	nmi_delayed_call_func_t *pfunc, func;
+
+	cpu = smp_processor_id();
+	ppending = per_cpu_ptr(&nmi_delayed_call_pending, cpu);
+	while (*ppending && restart--) {
+		pending = xchg(ppending, 0);
+		pfunc = nmi_delayed_call_funcs;
+		do {
+			if (pending & 1) {
+				func = *pfunc;
+				if (func)
+					func();
+			}
+			pfunc++;
+			pending >>= 1;
+		} while (pending);
+	}
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+asmlinkage void smp_nmi_delayed_call_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	nmi_delayed_call_run();
+	irq_exit();
+}
+#endif
+
+int nmi_delayed_call_register(nmi_delayed_call_func_t func)
+{
+	unsigned long flags;
+	int i, id = NMI_DELAYED_CALL_ID_INVALID;
+
+	spin_lock_irqsave(&nmi_delayed_call_lock, flags);
+	for (i = 0; i < NMI_DELAYED_CALL_ID_MAX; i++) {
+		if (!nmi_delayed_call_funcs[i]) {
+			nmi_delayed_call_funcs[i] = func;
+			id = i;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&nmi_delayed_call_lock, flags);
+	return id;
+}
+EXPORT_SYMBOL_GPL(nmi_delayed_call_register);
+
+/* Corresponding NMI handler should complete before invoking this
+ * function */
+void nmi_delayed_call_unregister(int id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&nmi_delayed_call_lock, flags);
+	nmi_delayed_call_funcs[id] = NULL;
+	spin_unlock_irqrestore(&nmi_delayed_call_lock, flags);
+}
+EXPORT_SYMBOL_GPL(nmi_delayed_call_unregister);
+
+void nmi_delayed_call_schedule(int id)
+{
+	int cpu;
+
+	if (id == NMI_DELAYED_CALL_ID_INVALID)
+		return;
+	BUG_ON(id < 0 || id >= NMI_DELAYED_CALL_ID_MAX);
+
+	cpu = smp_processor_id();
+	set_bit(id, per_cpu_ptr(&nmi_delayed_call_pending, cpu));
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	/* Without APIC do not schedule */
+	if (!cpu_has_apic)
+		return;
+
+	/*
+	 * In nmi we cannot use kernel services safely. Trigger an
+	 * self interrupt through the APIC to instead do the
+	 * notification after interrupts are reenabled again.
+	 */
+	apic->send_IPI_self(NMI_DELAYED_CALL_VECTOR);
+
+	/*
+	 * Wait for idle afterwards again so that we don't leave the
+	 * APIC in a non idle state because the normal APIC writes
+	 * cannot exclude us.
+	 */
+	apic_wait_icr_idle();
+#endif
+}
+EXPORT_SYMBOL_GPL(nmi_delayed_call_schedule);
