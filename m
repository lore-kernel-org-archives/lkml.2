Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1IQAqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:46:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab1IQAqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:46:40 -0400
Message-Id: <e97c6e$3hno04@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119267332"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:19:01 -0500
Subject: [PATCH v4 17/36] Hexagon: Add interrupts
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/irq.h |   36 ++++++++++++++++
 arch/hexagon/kernel/irq_cpu.c  |   90 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/irq.h
 create mode 100644 arch/hexagon/kernel/irq_cpu.c

diff --git a/arch/hexagon/include/asm/irq.h b/arch/hexagon/include/asm/irq.h
new file mode 100644
index 0000000..ded8c15
--- /dev/null
+++ b/arch/hexagon/include/asm/irq.h
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
diff --git a/arch/hexagon/kernel/irq_cpu.c b/arch/hexagon/kernel/irq_cpu.c
new file mode 100644
index 0000000..d4416a1
--- /dev/null
+++ b/arch/hexagon/kernel/irq_cpu.c
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
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
