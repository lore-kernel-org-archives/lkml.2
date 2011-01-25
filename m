Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1AYIE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:04:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39032 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1AYIE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QINodzk6RT3WxNASNKzt2ax6BwCn8/Dt6y/OE8MykTWqZVHmLfukZ0b3qqvMuc5eBj
         HhhZP788ufQBGMVPL/rOhs7kbdqHEHKaLWetHwa2/0MghFRY4NISSDQnJDfAM99qZhP4
         4D7pULNxAMe472YuGBPeOC24zc+V7SiArqem8=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 3/6] MIPS MT kernel modes ( VSMP/SMTC ) support for MSP platforms.
Date: Tue, 25 Jan 2011 13:51:03 +0530
Message-Id: <1295943663-20192-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Following patch will add VSMP and SMTC platform specific hooks.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/pmc-sierra/msp71xx/Makefile    |    2 +
 arch/mips/pmc-sierra/msp71xx/msp_setup.c |   10 +++
 arch/mips/pmc-sierra/msp71xx/msp_smp.c   |   77 +++++++++++++++++++++
 arch/mips/pmc-sierra/msp71xx/msp_smtc.c  |  107 ++++++++++++++++++++++++++++++
 4 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/pmc-sierra/msp71xx/msp_smp.c
 create mode 100644 arch/mips/pmc-sierra/msp71xx/msp_smtc.c

diff --git a/arch/mips/pmc-sierra/msp71xx/Makefile b/arch/mips/pmc-sierra/msp71xx/Makefile
index b25f354..a002fa2 100644
--- a/arch/mips/pmc-sierra/msp71xx/Makefile
+++ b/arch/mips/pmc-sierra/msp71xx/Makefile
@@ -10,3 +10,5 @@ obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
 obj-$(CONFIG_PCI) += msp_pci.o
 obj-$(CONFIG_MSPETH) += msp_eth.o
 obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
+obj-$(CONFIG_MIPS_MT_SMP) += msp_smp.o
+obj-$(CONFIG_MIPS_MT_SMTC) += msp_smtc.o
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_setup.c b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
index a54e85b..fb37a10 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_setup.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
@@ -146,6 +146,8 @@ void __init plat_mem_setup(void)
 	pm_power_off = msp_power_off;
 }
 
+extern struct plat_smp_ops msp_smtc_smp_ops;
+
 void __init prom_init(void)
 {
 	unsigned long family;
@@ -226,6 +228,14 @@ void __init prom_init(void)
 	 */
 	msp_serial_setup();
 
+#ifdef CONFIG_MIPS_MT_SMP
+	register_smp_ops(&vsmp_smp_ops);
+#endif
+
+#ifdef CONFIG_MIPS_MT_SMTC
+	register_smp_ops(&msp_smtc_smp_ops);
+#endif
+
 #ifdef CONFIG_PMCTWILED
 	/*
 	 * Setup LED states before the subsys_initcall loads other
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_smp.c b/arch/mips/pmc-sierra/msp71xx/msp_smp.c
new file mode 100644
index 0000000..43a9e26
--- /dev/null
+++ b/arch/mips/pmc-sierra/msp71xx/msp_smp.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2000, 2001, 2004 MIPS Technologies, Inc.
+ * Copyright (C) 2001 Ralf Baechle
+ * Copyright (C) 2010 PMC-Sierra, Inc.
+ *
+ *  VSMP support for MSP platforms . Derived from malta vsmp support.
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ */
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+
+#ifdef CONFIG_MIPS_MT_SMP
+#define MIPS_CPU_IPI_RESCHED_IRQ 0	/* SW int 0 for resched */
+#define MIPS_CPU_IPI_CALL_IRQ 1		/* SW int 1 for call */
+
+
+static void ipi_resched_dispatch(void)
+{
+	do_IRQ(MIPS_CPU_IPI_RESCHED_IRQ);
+}
+
+static void ipi_call_dispatch(void)
+{
+	do_IRQ(MIPS_CPU_IPI_CALL_IRQ);
+}
+
+static irqreturn_t ipi_resched_interrupt(int irq, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ipi_call_interrupt(int irq, void *dev_id)
+{
+	smp_call_function_interrupt();
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction irq_resched = {
+	.handler	= ipi_resched_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.name		= "IPI_resched"
+};
+
+static struct irqaction irq_call = {
+	.handler	= ipi_call_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.name		= "IPI_call"
+};
+
+void __init arch_init_ipiirq(int irq, struct irqaction *action)
+{
+	setup_irq(irq, action);
+	set_irq_handler(irq, handle_percpu_irq);
+}
+
+void __init msp_vsmp_int_init(void)
+{
+	set_vi_handler(MIPS_CPU_IPI_RESCHED_IRQ, ipi_resched_dispatch);
+	set_vi_handler(MIPS_CPU_IPI_CALL_IRQ, ipi_call_dispatch);
+	arch_init_ipiirq(MIPS_CPU_IPI_RESCHED_IRQ, &irq_resched);
+	arch_init_ipiirq(MIPS_CPU_IPI_CALL_IRQ, &irq_call);
+}
+#endif /* CONFIG_MIPS_MT_SMP */
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_smtc.c b/arch/mips/pmc-sierra/msp71xx/msp_smtc.c
new file mode 100644
index 0000000..1504c76
--- /dev/null
+++ b/arch/mips/pmc-sierra/msp71xx/msp_smtc.c
@@ -0,0 +1,107 @@
+/*
+ * MSP71xx Platform-specific hooks for SMP operation
+ */
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+
+#include <asm/mipsregs.h>
+#include <asm/mipsmtregs.h>
+#include <asm/smtc.h>
+#include <asm/smtc_ipi.h>
+
+/* VPE/SMP Prototype implements platform interfaces directly */
+
+/*
+ * Cause the specified action to be performed on a targeted "CPU"
+ */
+
+static void msp_smtc_send_ipi_single(int cpu, unsigned int action)
+{
+	/* "CPU" may be TC of same VPE, VPE of same CPU, or different CPU */
+	smtc_send_ipi(cpu, LINUX_SMP_IPI, action);
+}
+
+static void msp_smtc_send_ipi_mask(const struct cpumask *mask,
+						unsigned int action)
+{
+	unsigned int i;
+
+	for_each_cpu(i, mask)
+		msp_smtc_send_ipi_single(i, action);
+}
+
+/*
+ * Post-config but pre-boot cleanup entry point
+ */
+static void __cpuinit msp_smtc_init_secondary(void)
+{
+	void smtc_init_secondary(void);
+	int myvpe;
+
+	/* Don't enable Malta I/O interrupts (IP2) for secondary VPEs */
+	myvpe = read_c0_tcbind() & TCBIND_CURVPE;
+	if (myvpe > 0)
+		change_c0_status(ST0_IM, STATUSF_IP0 | STATUSF_IP1 |
+				STATUSF_IP6 | STATUSF_IP7);
+	smtc_init_secondary();
+}
+
+/*
+ * Platform "CPU" startup hook
+ */
+static void __cpuinit msp_smtc_boot_secondary(int cpu,
+					struct task_struct *idle)
+{
+	smtc_boot_secondary(cpu, idle);
+}
+
+/*
+ * SMP initialization finalization entry point
+ */
+static void __cpuinit msp_smtc_smp_finish(void)
+{
+	smtc_smp_finish();
+}
+
+/*
+ * Hook for after all CPUs are online
+ */
+
+static void msp_smtc_cpus_done(void)
+{
+}
+
+/*
+ * Platform SMP pre-initialization
+ *
+ * As noted above, we can assume a single CPU for now
+ * but it may be multithreaded.
+ */
+
+static void __init msp_smtc_smp_setup(void)
+{
+	/*
+	 * we won't get the definitive value until
+	 * we've run smtc_prepare_cpus later, but
+	 */
+
+	if (read_c0_config3() & (1 << 2))
+		smp_num_siblings = smtc_build_cpu_map(0);
+}
+
+static void __init msp_smtc_prepare_cpus(unsigned int max_cpus)
+{
+	smtc_prepare_cpus(max_cpus);
+}
+
+struct plat_smp_ops msp_smtc_smp_ops = {
+	.send_ipi_single	= msp_smtc_send_ipi_single,
+	.send_ipi_mask		= msp_smtc_send_ipi_mask,
+	.init_secondary		= msp_smtc_init_secondary,
+	.smp_finish		= msp_smtc_smp_finish,
+	.cpus_done		= msp_smtc_cpus_done,
+	.boot_secondary		= msp_smtc_boot_secondary,
+	.smp_setup		= msp_smtc_smp_setup,
+	.prepare_cpus		= msp_smtc_prepare_cpus,
+};
-- 
1.7.0.4

