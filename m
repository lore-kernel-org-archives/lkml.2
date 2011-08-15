Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1HOPxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43560 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab1HOPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 17/32] x86: New cpuset nohz irq vector
Date: Mon, 15 Aug 2011 17:52:14 +0200
Message-Id: <1313423549-27093-18-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a way to send an irq IPI (or local) in
any case and asynchronously in order to restart
the tick for CPUs in nohz adaptive mode

Generic smp operations don't fit into this because
they need interrupts to be enabled and they
try to execute the functions in place if the dest
CPU is the current one. But we always need the
function to be executed in irq context so it
happens quickly and restarting the tick doesn't
mess up with random lock scenarios in place.

In fact this is a temporary solution, what we really need is
an irq work subsystem that supports remote enqueuing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 arch/x86/include/asm/entry_arch.h  |    3 +++
 arch/x86/include/asm/hw_irq.h      |    6 ++++++
 arch/x86/include/asm/irq_vectors.h |    2 ++
 arch/x86/include/asm/smp.h         |   11 +++++++++++
 arch/x86/kernel/entry_64.S         |    4 ++++
 arch/x86/kernel/irqinit.c          |    4 ++++
 arch/x86/kernel/smp.c              |   26 ++++++++++++++++++++++++++
 7 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 1cd6d26..019cf29 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -10,6 +10,9 @@
  * through the ICC by us (IPIs)
  */
 #ifdef CONFIG_SMP
+#ifdef CONFIG_CPUSETS_NO_HZ
+BUILD_INTERRUPT(cpuset_update_nohz_interrupt,CPUSET_UPDATE_NOHZ_VECTOR)
+#endif
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bb9efe8..1978050 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -34,6 +34,9 @@ extern void irq_work_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
+#ifdef CONFIG_CPUSETS_NO_HZ
+extern void cpuset_update_nohz_interrupt(void);
+#endif
 extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
@@ -153,6 +156,9 @@ extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
 #endif
 #ifdef CONFIG_SMP
 extern void smp_reschedule_interrupt(struct pt_regs *);
+#ifdef CONFIG_CPUSETS_NO_HZ
+extern void smp_cpuset_update_nohz_interrupt(struct pt_regs *);
+#endif
 extern void smp_call_function_interrupt(struct pt_regs *);
 extern void smp_call_function_single_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..5e33fec 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -117,6 +117,8 @@
 /* Xen vector callback to receive events in a HVM domain */
 #define XEN_HVM_EVTCHN_CALLBACK		0xf3
 
+#define CPUSET_UPDATE_NOHZ_VECTOR	0xf2
+
 /*
  * Local APIC timer IRQ vector is on a different priority level,
  * to work around the 'lost local interrupt if more than 2 IRQ
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 73b11bc..66dc629 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -70,6 +70,10 @@ struct smp_ops {
 	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+	void (*smp_cpuset_update_nohz)(int cpu);
+#endif
+
 	int (*cpu_up)(unsigned cpu);
 	int (*cpu_disable)(void);
 	void (*cpu_die)(unsigned int cpu);
@@ -138,6 +142,13 @@ static inline void smp_send_reschedule(int cpu)
 	smp_ops.smp_send_reschedule(cpu);
 }
 
+static inline void smp_cpuset_update_nohz(int cpu)
+{
+#ifdef CONFIG_CPUSETS_NO_HZ
+	smp_ops.smp_cpuset_update_nohz(cpu);
+#endif
+}
+
 static inline void arch_send_call_function_single_ipi(int cpu)
 {
 	smp_ops.send_call_func_single_ipi(cpu);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index d656f68..06d79c2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -996,6 +996,10 @@ apicinterrupt CALL_FUNCTION_VECTOR \
 	call_function_interrupt smp_call_function_interrupt
 apicinterrupt RESCHEDULE_VECTOR \
 	reschedule_interrupt smp_reschedule_interrupt
+#ifdef CONFIG_CPUSETS_NO_HZ
+apicinterrupt CPUSET_UPDATE_NOHZ_VECTOR \
+	cpuset_update_nohz_interrupt smp_cpuset_update_nohz_interrupt
+#endif
 #endif
 
 apicinterrupt ERROR_APIC_VECTOR \
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f470e4e..ba5665c 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -172,6 +172,10 @@ static void __init smp_intr_init(void)
 	 */
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+	alloc_intr_gate(CPUSET_UPDATE_NOHZ_VECTOR, cpuset_update_nohz_interrupt);
+#endif
+
 	/* IPIs for invalidation */
 #define ALLOC_INVTLB_VEC(NR) \
 	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+NR, \
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 013e7eb..7c3e399 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/cpuset.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -121,6 +122,17 @@ static void native_smp_send_reschedule(int cpu)
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+static void native_smp_cpuset_update_nohz(int cpu)
+{
+	if (unlikely(cpu_is_offline(cpu))) {
+		WARN_ON(1);
+		return;
+	}
+	apic->send_IPI_mask(cpumask_of(cpu), CPUSET_UPDATE_NOHZ_VECTOR);
+}
+#endif
+
 void native_send_call_func_single_ipi(int cpu)
 {
 	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
@@ -206,6 +218,17 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+void smp_cpuset_update_nohz_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	cpuset_update_nohz();
+	inc_irq_stat(irq_call_count);
+	irq_exit();
+}
+#endif
+
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
@@ -231,6 +254,9 @@ struct smp_ops smp_ops = {
 
 	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
+#ifdef CONFIG_CPUSETS_NO_HZ
+	.smp_cpuset_update_nohz = native_smp_cpuset_update_nohz,
+#endif
 
 	.cpu_up			= native_cpu_up,
 	.cpu_die		= native_cpu_die,
-- 
1.7.5.4

