Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1HQRGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:06:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26066 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1HQRGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:06:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="111004135"
Message-Id: <20110817163521.444836325@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:14 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 17/36] Hexagon: Add interrupts
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=interrupts.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/hardirq.h |    1 
 arch/hexagon/include/asm/irq.h     |   37 +++++++++++++++
 arch/hexagon/kernel/irq.c          |   74 ++++++++++++++++++++++++++++++
 arch/hexagon/kernel/irq_cpu.c      |   90 +++++++++++++++++++++++++++++++++++++
 4 files changed, 202 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/hardirq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/hardirq.h	2011-08-05 19:38:02.551806912 -0500
@@ -0,0 +1 @@
+#include <asm-generic/hardirq.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/irq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/irq.h	2011-08-05 19:38:02.551806912 -0500
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_IRQ_H_
+#define _ASM_IRQ_H_
+
+/* Number of first-level interrupts associated with the CPU core. */
+#define HEXAGON_CPUINTS 32
+
+/*
+ * XXX TODO FIXME this should be pulled from a platform file!
+ * Must define NR_IRQS before including <asm-generic/irq.h>
+ * 64 == the two SIRC's, 176 == the two gpio's
+ */
+#define NR_IRQS (HEXAGON_CPUINTS + 64 + 176)
+
+#include <asm-generic/irq.h>
+
+extern void __init platform_irq_init(void);
+extern void __init hexagon_cpu_irq_init(void);
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/irq.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/irq.c	2011-08-05 19:42:38.172363921 -0500
@@ -0,0 +1,74 @@
+/*
+ * Interrupt support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
+#include <linux/seq_file.h>
+#include <linux/version.h>
+
+void __init init_IRQ(void)
+{
+	/* Set up core cpu irqs before platform secondaries. */
+	hexagon_cpu_irq_init();
+	platform_irq_init();
+}
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *)v, cpu;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		seq_puts(p, "           ");
+		for_each_online_cpu(cpu)
+			seq_printf(p, "CPU%d       ", cpu);
+		seq_putc(p, '\n');
+	}
+
+	if (i < NR_IRQS) {
+		struct irq_desc *desc = irq_to_desc(i);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		action = irq_desc[i].action;
+		if (action) {
+			seq_printf(p, "%3d: ", i);
+			for_each_online_cpu(cpu) {
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+			}
+			seq_printf(p, " %8s",
+				   irq_desc_get_chip(&irq_desc[i])->name ?
+				   : "-");
+			seq_printf(p, "  %s", action->name);
+			for (action = action->next; action;
+			     action = action->next) {
+				seq_printf(p, ", %s", action->name);
+			}
+
+			seq_putc(p, '\n');
+		}
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	return 0;
+}
Index: linux-hexagon-kernel/arch/hexagon/kernel/irq_cpu.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/irq_cpu.c	2011-08-05 19:38:02.551806912 -0500
@@ -0,0 +1,90 @@
+/*
+ * First-level interrupt controller model for Hexagon.
+ *
+ * Copyright (c) 2010-2011 Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/interrupt.h>
+#include <asm/irq.h>
+#include <asm/hexagon_vm.h>
+
+static void mask_irq(struct irq_data *data)
+{
+	__vmintop_locdis((long) data->irq);
+}
+
+static void mask_irq_num(unsigned int irq)
+{
+	__vmintop_locdis((long) irq);
+}
+
+static void unmask_irq(struct irq_data *data)
+{
+	__vmintop_locen((long) data->irq);
+}
+
+/*  This is actually all we need for handle_fasteoi_irq  */
+static void eoi_irq(struct irq_data *data)
+{
+	__vmintop_globen((long) data->irq);
+}
+
+/* Power mamangement wake call. We don't need this, however,
+ * if this is absent, then an -ENXIO error is returned to the
+ * msm_serial driver, and it fails to correctly initialize.
+ * This is a bug in the msm_serial driver, but, for now, we
+ * work around it here, by providing this bogus handler.
+ * XXX FIXME!!! remove this when msm_serial is fixed.
+ */
+static int set_wake(struct irq_data *data, unsigned int on)
+{
+	return 0;
+}
+
+static struct irq_chip hexagon_irq_chip = {
+	.name		= "HEXAGON",
+	.irq_mask	= mask_irq,
+	.irq_unmask	= unmask_irq,
+	.irq_set_wake	= set_wake,
+	.irq_eoi	= eoi_irq
+};
+
+/**
+ * The hexagon core comes with a first-level interrupt controller
+ * with 32 total possible interrupts.  When the core is embedded
+ * into different systems/platforms, it is typically wrapped by
+ * macro cells that provide one or more second-level interrupt
+ * controllers that are cascaded into one or more of the first-level
+ * interrupts handled here. The precise wiring of these other
+ * irqs varies from platform to platform, and are set up & configured
+ * in the platform-specific files.
+ *
+ * The first-level interrupt controller is wrapped by the VM, which
+ * virtualizes the interrupt controller for us.  It provides a very
+ * simple, fast & efficient API, and so the fasteoi handler is
+ * appropriate for this case.
+ */
+void __init hexagon_cpu_irq_init(void)
+{
+	int irq;
+
+	for (irq = 0; irq < HEXAGON_CPUINTS; irq++) {
+		mask_irq_num(irq);
+		irq_set_chip_and_handler(irq, &hexagon_irq_chip,
+						 handle_fasteoi_irq);
+	}
+}

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

