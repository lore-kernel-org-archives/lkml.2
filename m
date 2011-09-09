Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1IIBQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:16:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50881 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab1IIBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864711"
Message-Id: <20110909010916.327107063@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:04 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 17/36] Hexagon: Add interrupts
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=interrupts.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed init_IRQ wrapper and fixed up some comments.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/include/asm/irq.h |   36 ++++++++++++++++
 arch/hexagon/kernel/irq.c      |   67 ++++++++++++++++++++++++++++++
 arch/hexagon/kernel/irq_cpu.c  |   90 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 193 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/irq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/irq.h	2011-09-07 13:00:30.930646788 -0500
@@ -0,0 +1,36 @@
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
+ * Must define NR_IRQS before including <asm-generic/irq.h>
+ * 64 == the two SIRC's, 176 == the two gpio's
+ *
+ * IRQ configuration is still in flux; defining this to a comfortably
+ * large number.
+ */
+#define NR_IRQS 512
+
+#include <asm-generic/irq.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/irq.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/irq.c	2011-09-07 13:00:31.060646986 -0500
@@ -0,0 +1,67 @@
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
+++ linux-hexagon-kernel/arch/hexagon/kernel/irq_cpu.c	2011-09-07 13:00:31.080647016 -0500
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
+void __init init_IRQ(void)
+{
+	int irq;
+
+	for (irq = 0; irq < HEXAGON_CPUINTS; irq++) {
+		mask_irq_num(irq);
+		irq_set_chip_and_handler(irq, &hexagon_irq_chip,
+						 handle_fasteoi_irq);
+	}
+}

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

