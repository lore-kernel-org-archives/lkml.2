Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab0KAQoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:44:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab0KAQoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:44:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6153"; a="60181661"
From: Stephen Caudle <scaudle@codeaurora.org>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwalker@codeaurora.org,
        adharmap@codeaurora.org, Stephen Caudle <scaudle@codeaurora.org>
Subject: [PATCH] [ARM] gic: Unmask private interrupts on all cores during IRQ enable
Date: Mon,  1 Nov 2010 12:39:55 -0400
Message-Id: <1288629595-15331-1-git-send-email-scaudle@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requesting/freeing private peripheral interrupts on multi-core chips that
use only one IRQ number for all cores currently unmasks/masks the interrupt
for only the executing core.

This change prevents the need for a separate call to enable_irq on other
cores after request_irq. Also, shutdown is implemented instead of disable
to allow for lazy IRQ disabling.

Signed-off-by: Stephen Caudle <scaudle@codeaurora.org>
---
 arch/arm/Kconfig      |    5 +++
 arch/arm/common/gic.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..fbf5236 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1298,6 +1298,11 @@ config LOCAL_TIMERS
 	  accounting to be spread across the timer interval, preventing a
 	  "thundering herd" at every timer tick.
 
+config IRQ_PER_CPU
+	bool
+	depends on SMP
+	default n
+
 source kernel/Kconfig.preempt
 
 config HZ
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index ada6359..372cfb3 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -39,12 +39,25 @@ struct gic_chip_data {
 	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+#ifdef CONFIG_IRQ_PER_CPU
+	struct call_single_data ppi_data;
+#endif
 };
 
 #ifndef MAX_GIC_NR
 #define MAX_GIC_NR	1
 #endif
 
+#ifdef CONFIG_IRQ_PER_CPU
+#ifndef GIC_PPI_FIRST
+#define GIC_PPI_FIRST	16
+#endif
+
+#ifndef GIC_PPI_LAST
+#define GIC_PPI_LAST	31
+#endif
+#endif
+
 static struct gic_chip_data gic_data[MAX_GIC_NR];
 
 static inline void __iomem *gic_dist_base(unsigned int irq)
@@ -158,6 +171,72 @@ static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 }
 #endif
 
+#ifdef CONFIG_IRQ_PER_CPU
+static inline void gic_smp_call_function(struct call_single_data *data)
+{
+	int cpu;
+	int this_cpu = smp_processor_id();
+
+	/*
+	 * Since this function is called with interrupts disabled,
+	 * smp_call_function can't be used here because it warns (even
+	 * if wait = 0) when interrupts are disabled.
+	 *
+	 * __smp_call_function_single doesn't warn when interrupts are
+	 * disabled and not waiting, so use it instead.
+	 */
+	for_each_online_cpu(cpu)
+		if (cpu != this_cpu)
+			__smp_call_function_single(cpu, data, 0);
+}
+
+static void gic_mask_ppi(void *info)
+{
+	gic_mask_irq(*(unsigned int *)info);
+}
+
+static void gic_unmask_ppi(void *info)
+{
+	gic_unmask_irq(*(unsigned int *)info);
+}
+
+static void gic_enable_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct gic_chip_data *gic_data = get_irq_chip_data(irq);
+
+	if (irq >= GIC_PPI_FIRST && irq <= GIC_PPI_LAST) {
+		gic_data->ppi_data.func = gic_unmask_ppi;
+		gic_data->ppi_data.info = &desc->irq;
+		gic_data->ppi_data.flags = 0;
+
+		/* Unmask PPIs on all cores during enable. */
+		gic_smp_call_function(&gic_data->ppi_data);
+	}
+
+	desc->chip->unmask(irq);
+	desc->status &= ~IRQ_MASKED;
+}
+
+static void gic_shutdown_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct gic_chip_data *gic_data = get_irq_chip_data(irq);
+
+	if (irq >= GIC_PPI_FIRST && irq <= GIC_PPI_LAST) {
+		gic_data->ppi_data.func = gic_mask_ppi;
+		gic_data->ppi_data.info = &desc->irq;
+		gic_data->ppi_data.flags = 0;
+
+		/* Mask PPIs on all cores during disable. */
+		gic_smp_call_function(&gic_data->ppi_data);
+	}
+
+	desc->chip->mask(irq);
+	desc->status |= IRQ_MASKED;
+}
+#endif
+
 static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct gic_chip_data *chip_data = get_irq_data(irq);
@@ -196,6 +275,10 @@ static struct irq_chip gic_chip = {
 #ifdef CONFIG_SMP
 	.set_affinity	= gic_set_cpu,
 #endif
+#ifdef CONFIG_IRQ_PER_CPU
+	.enable		= gic_enable_irq,
+	.shutdown	= gic_shutdown_irq,
+#endif
 };
 
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
-- 
1.7.3.2

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum

