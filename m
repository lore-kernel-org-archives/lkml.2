Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2FRLbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:31:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50581 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2FRLa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:57 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFC PATCH 6/8] ARM: smp: Use generic API for ipi
Date: Mon, 18 Jun 2012 13:30:09 +0200
Message-Id: <1340019011-18642-7-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support dynamic IPI allocation. It supports cases
where user wants to use IPI for communication among cpus
and setup own handler for it.

New functions set_ipi_handler/clear_ipi_handler are used
for dynamic allocation.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/arm/include/asm/smp.h |    3 +
 arch/arm/kernel/smp.c      |  104 +++++++++++++++++++++++++------------------
 2 files changed, 63 insertions(+), 44 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index ae29293..308cca9 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -93,4 +93,7 @@ extern void platform_cpu_enable(unsigned int cpu);
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 
+extern int set_ipi_handler(int ipinr, void *handler, char *desc);
+extern void clear_ipi_handler(int ipinr);
+
 #endif /* ifndef __ASM_ARM_SMP_H */
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 47406ee..4af1679 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -51,7 +51,7 @@
 struct secondary_data secondary_data;
 
 enum ipi_msg_type {
-	IPI_TIMER = 2,
+	IPI_TIMER,
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
 	IPI_CALL_FUNC_SINGLE,
@@ -346,13 +346,23 @@ void arch_send_call_function_single_ipi(int cpu)
 	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
-static const char *ipi_types[NR_IPI] = {
-#define S(x,s)	[x - IPI_TIMER] = s
-	S(IPI_TIMER, "Timer broadcast interrupts"),
-	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
-	S(IPI_CALL_FUNC, "Function call interrupts"),
-	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
-	S(IPI_CPU_STOP, "CPU stop interrupts"),
+struct ipi {
+	const char *desc;
+	void (*handler)(void);
+};
+
+static void ipi_timer(void);
+static void ipi_cpu_stop(void);
+
+static struct ipi ipi_types[NR_IPI] = {
+#define S(x, s, f)	[x].desc = s, [x].handler = f
+	S(IPI_TIMER, "Timer broadcast interrupts", ipi_timer),
+	S(IPI_RESCHEDULE, "Rescheduling interrupts", scheduler_ipi),
+	S(IPI_CALL_FUNC, "Function call interrupts",
+					generic_smp_call_function_interrupt),
+	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts",
+				generic_smp_call_function_single_interrupt),
+	S(IPI_CPU_STOP, "CPU stop interrupts", ipi_cpu_stop),
 };
 
 void show_ipi_list(struct seq_file *p, int prec)
@@ -360,13 +370,15 @@ void show_ipi_list(struct seq_file *p, int prec)
 	unsigned int cpu, i;
 
 	for (i = 0; i < NR_IPI; i++) {
-		seq_printf(p, "%*s%u: ", prec - 1, "IPI", i);
+		if (ipi_types[i].handler) {
+			seq_printf(p, "%*s%u: ", prec - 1, "IPI", i);
 
-		for_each_present_cpu(cpu)
-			seq_printf(p, "%10u ",
-				   __get_irq_stat(cpu, ipi_irqs[i]));
+			for_each_present_cpu(cpu)
+				seq_printf(p, "%10u ",
+					__get_irq_stat(cpu, ipi_irqs[i]));
 
-		seq_printf(p, " %s\n", ipi_types[i]);
+			seq_printf(p, " %s\n", ipi_types[i].desc);
+		}
 	}
 }
 
@@ -502,45 +514,49 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	if (ipinr >= IPI_TIMER && ipinr < IPI_TIMER + NR_IPI)
-		__inc_irq_stat(cpu, ipi_irqs[ipinr - IPI_TIMER]);
-
-	switch (ipinr) {
-	case IPI_TIMER:
+	if (ipi_types[ipinr].handler) {
+		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
 		irq_enter();
-		ipi_timer();
+		(*ipi_types[ipinr].handler)();
 		irq_exit();
-		break;
+	} else
+		pr_crit("CPU%u: Unknown IPI message 0x%x\n",
+		       cpu, ipinr);
 
-	case IPI_RESCHEDULE:
-		scheduler_ipi();
-		break;
+	set_irq_regs(old_regs);
+}
 
-	case IPI_CALL_FUNC:
-		irq_enter();
-		generic_smp_call_function_interrupt();
-		irq_exit();
-		break;
+/*
+ * set_ipi_handler:
+ * Interface provided for a kernel module to specify an IPI handler function.
+ */
+int set_ipi_handler(int ipinr, void *handler, char *desc)
+{
+	unsigned int cpu = smp_processor_id();
 
-	case IPI_CALL_FUNC_SINGLE:
-		irq_enter();
-		generic_smp_call_function_single_interrupt();
-		irq_exit();
-		break;
+	if (ipi_types[ipinr].handler) {
+		pr_crit("CPU%u: IPI handler 0x%x already registered to %pf\n",
+					cpu, ipinr, ipi_types[ipinr].handler);
+		return -1;
+	}
 
-	case IPI_CPU_STOP:
-		irq_enter();
-		ipi_cpu_stop();
-		irq_exit();
-		break;
+	ipi_types[ipinr].handler = handler;
+	ipi_types[ipinr].desc = desc;
 
-	default:
-		printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%x\n",
-		       cpu, ipinr);
-		break;
-	}
-	set_irq_regs(old_regs);
+	return 0;
+}
+EXPORT_SYMBOL(set_ipi_handler);
+
+/*
+ * clear_ipi_handler:
+ * Interface provided for a kernel module to clear an IPI handler function.
+ */
+void clear_ipi_handler(int ipinr)
+{
+	ipi_types[ipinr].handler = NULL;
+	ipi_types[ipinr].desc = NULL;
 }
+EXPORT_SYMBOL(clear_ipi_handler);
 
 void smp_send_reschedule(int cpu)
 {
-- 
1.7.0.4

