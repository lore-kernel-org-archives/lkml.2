Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2D3X4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:56:10 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62757 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab2D3X4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:56:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/41] x86: New cpuset nohz irq vector
Date: Tue,  1 May 2012 01:54:43 +0200
Message-Id: <1335830115-14335-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a way to send an IPI (remote or local) in order to
asynchronously restart the tick for CPUs in nohz adaptive mode.

This must be asynchronous such that we can trigger it with irqs
disabled. This must be usable as a self-IPI as well for example
in cases where we want to avoid random dealock scenario while
restarting the tick inline otherwise.

This only settles the x86 backend. The core tick restart function
will be defined in a later patch.

[CHECKME: Perhaps we instead need to use irq work for self IPIs.
But we also need a way to send async remote IPIs.]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/entry_arch.h  |    3 +++
 arch/x86/include/asm/hw_irq.h      |    7 +++++++
 arch/x86/include/asm/irq_vectors.h |    2 ++
 arch/x86/include/asm/smp.h         |   11 +++++++++++
 arch/x86/kernel/entry_64.S         |    4 ++++
 arch/x86/kernel/irqinit.c          |    4 ++++
 arch/x86/kernel/smp.c              |   24 ++++++++++++++++++++++++
 7 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 0baa628..f71872d 100644
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
index eb92a6e..0d26ed7 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -35,6 +35,10 @@ extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+extern void cpuset_update_nohz_interrupt(void);
+#endif
+
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
 extern void invalidate_interrupt1(void);
@@ -152,6 +156,9 @@ extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
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
index 4b44487..11bc691 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -112,6 +112,8 @@
 /* Xen vector callback to receive events in a HVM domain */
 #define XEN_HVM_EVTCHN_CALLBACK		0xf3
 
+#define CPUSET_UPDATE_NOHZ_VECTOR	0xf2
+
 /*
  * Local APIC timer IRQ vector is on a different priority level,
  * to work around the 'lost local interrupt if more than 2 IRQ
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0434c40..475c26b 100644
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
index 1333d98..54f269c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1002,6 +1002,10 @@ apicinterrupt CALL_FUNCTION_VECTOR \
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
index 313fb5c..2220f3c 100644
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
index 66c74f4..94615a3 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -123,6 +123,17 @@ static void native_smp_send_reschedule(int cpu)
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
@@ -267,6 +278,16 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+void smp_cpuset_update_nohz_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	inc_irq_stat(irq_call_count);
+	irq_exit();
+}
+#endif
+
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
@@ -300,6 +321,9 @@ struct smp_ops smp_ops = {
 
 	.stop_other_cpus	= native_nmi_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
+#ifdef CONFIG_CPUSETS_NO_HZ
+	.smp_cpuset_update_nohz = native_smp_cpuset_update_nohz,
+#endif
 
 	.cpu_up			= native_cpu_up,
 	.cpu_die		= native_cpu_die,
-- 
1.7.5.4

