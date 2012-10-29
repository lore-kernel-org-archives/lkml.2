Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955Ab2J2UtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:49:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2J2Uiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:50 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ns-d0tCk2iIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=J5dhaVSowzEA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=MKp2BgDEtU-pkQ6_m50A:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203847.242305452@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 04/32] x86: New cpuset nohz irq vector
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0004-x86-New-cpuset-nohz-irq-vector.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
 arch/x86/include/asm/smp.h         |   11 ++++++++++-
 arch/x86/kernel/entry_64.S         |    4 ++++
 arch/x86/kernel/irqinit.c          |    4 ++++
 arch/x86/kernel/smp.c              |   24 ++++++++++++++++++++++++
 7 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 40afa00..7e8c38c 100644
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
index 1508e51..f54dea8 100644
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
index 4f19a15..2c30bbd 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -71,7 +71,9 @@ struct smp_ops {
 
 	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
-
+#ifdef CONFIG_CPUSETS_NO_HZ
+	void (*smp_cpuset_update_nohz)(int cpu);
+#endif
 	int (*cpu_up)(unsigned cpu, struct task_struct *tidle);
 	int (*cpu_disable)(void);
 	void (*cpu_die)(unsigned int cpu);
@@ -140,6 +142,13 @@ static inline void smp_send_reschedule(int cpu)
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
index b51b2c7..6d5b77d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1173,6 +1173,10 @@ apicinterrupt CALL_FUNCTION_VECTOR \
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
index 6e03b0d..394e9ec 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -171,6 +171,10 @@ static void __init smp_intr_init(void)
 	 */
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+	alloc_intr_gate(CPUSET_UPDATE_NOHZ_VECTOR, cpuset_update_nohz_interrupt);
+#endif
+
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..4c0b7d2 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -126,6 +126,17 @@ static void native_smp_send_reschedule(int cpu)
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
@@ -259,6 +270,16 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
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
@@ -292,6 +313,9 @@ struct smp_ops smp_ops = {
 
 	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
+#ifdef CONFIG_CPUSETS_NO_HZ
+	.smp_cpuset_update_nohz = native_smp_cpuset_update_nohz,
+#endif
 
 	.cpu_up			= native_cpu_up,
 	.cpu_die		= native_cpu_die,
-- 
1.7.10.4


