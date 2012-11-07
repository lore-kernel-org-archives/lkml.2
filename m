Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2KGJsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:41 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:58050 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2KGJsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:32 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 12/31] ARC: Interrupt Handling
Date: Wed,  7 Nov 2012 10:47:35 +0100
Message-Id: <1352281674-2186-13-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h |    3 ++
 arch/arc/include/asm/hw_irq.h  |    7 ++++
 arch/arc/include/asm/irq.h     |   25 +++++++++++++
 arch/arc/kernel/irq.c          |   79 +++++++++++++++++++++++++++++++++++++++-
 arch/arc/plat-arcfpga/irq.c    |   41 +++++++++++++++++++++
 5 files changed, 153 insertions(+), 2 deletions(-)
 create mode 100644 arch/arc/include/asm/hw_irq.h
 create mode 100644 arch/arc/include/asm/irq.h
 create mode 100644 arch/arc/plat-arcfpga/irq.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index 8ca8faf..3fccb04 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -11,6 +11,9 @@
 
 #ifdef __KERNEL__
 
+/* Build Configuration Registers */
+#define ARC_REG_VECBASE_BCR	0x68
+
 /* status32 Bits Positions */
 #define STATUS_H_BIT		0	/* CPU Halted */
 #define STATUS_E1_BIT		1	/* Int 1 enable */
diff --git a/arch/arc/include/asm/hw_irq.h b/arch/arc/include/asm/hw_irq.h
new file mode 100644
index 0000000..fd565ab
--- /dev/null
+++ b/arch/arc/include/asm/hw_irq.h
@@ -0,0 +1,7 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
new file mode 100644
index 0000000..633416c
--- /dev/null
+++ b/arch/arc/include/asm/irq.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_IRQ_H
+#define __ASM_ARC_IRQ_H
+
+/* Platform Inependent IRQs */
+#define TIMER0_IRQ      3
+#define TIMER1_IRQ      4
+
+#include <asm-generic/irq.h>
+
+extern void __init arc_init_IRQ(void);
+extern void __init plat_init_IRQ(void);
+extern int __init get_hw_config_num_irq(void);
+
+void __cpuinit arc_clockevent_init(void);
+void __cpuinit arc_clock_counter_setup(void);
+
+#endif
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 16fcbe8..03a125c 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -9,8 +9,83 @@
 
 #include <linux/interrupt.h>
 #include <linux/module.h>
-#include <asm/irqflags.h>
-#include <asm/arcregs.h>
+#include <asm/sections.h>
+#include <asm/irq.h>
+
+/*
+ * Early Interrupt sub-system setup
+ * -Called very early (start_kernel -> setup_arch -> setup_processor)
+ * -Platform Independent (must for any ARC700)
+ * -Needed for each CPU (hence not foldable into init_IRQ)
+ *
+ * what it does ?
+ * -setup Vector Table Base Reg - in case Linux not linked at 0x8000_0000
+ * -Disable all IRQs (on CPU side)
+ */
+void __init arc_init_IRQ(void)
+{
+	int level_mask = level_mask;
+
+	write_aux_reg(AUX_INTR_VEC_BASE, _int_vec_base_lds);
+
+	/* Disable all IRQs: enable them as devices request */
+	write_aux_reg(AUX_IENABLE, 0);
+}
+
+/*
+ * Late Interrupt system init called from start_kernel for Boot CPU only
+ *
+ * Since slab must already be initialized, platforms can start doing any
+ * needed request_irq( )s
+ */
+void __init init_IRQ(void)
+{
+	const int irq = TIMER0_IRQ;
+
+	/*
+	 * Each CPU needs to register irq of it's private TIMER0.
+	 * The APIs request_percpu_irq()/enable_percpu_irq() will not be
+	 * functional, if we don't "prep" the generic IRQ sub-system with
+	 * the following:
+	 * -Ensure that devid passed to request_percpu_irq() is indeed per cpu
+	 * -disable NOAUTOEN, w/o which the device handler never gets called
+	 */
+	irq_set_percpu_devid(irq);
+	irq_modify_status(irq, IRQ_NOAUTOEN, 0);
+
+	plat_init_IRQ();
+}
+
+/*
+ * "C" Entry point for any ARC ISR, called from low level vector handler
+ */
+void arch_do_IRQ(unsigned int irq, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	generic_handle_irq(irq);
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+int __init get_hw_config_num_irq(void)
+{
+	uint32_t val = read_aux_reg(ARC_REG_VECBASE_BCR);
+
+	switch (val & 0x03) {
+	case 0:
+		return 16;
+	case 1:
+		return 32;
+	case 2:
+		return 8;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
 
 void arch_local_irq_enable(void)
 {
diff --git a/arch/arc/plat-arcfpga/irq.c b/arch/arc/plat-arcfpga/irq.c
new file mode 100644
index 0000000..a308057
--- /dev/null
+++ b/arch/arc/plat-arcfpga/irq.c
@@ -0,0 +1,41 @@
+/*
+ * ARC FPGA Platform IRQ hookups
+ *
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <asm/irq.h>
+#include <plat/memmap.h>
+
+static void arc_mask_irq(struct irq_data *data)
+{
+	arch_mask_irq(data->irq);
+}
+
+static void arc_unmask_irq(struct irq_data *data)
+{
+	arch_unmask_irq(data->irq);
+}
+
+/*
+ * There's no off-chip Interrupt Controller in the FPGA builds
+ * Below sufficies a simple model for the on-chip controller, with
+ * all interrupts being level triggered.
+ */
+static struct irq_chip fpga_chip = {
+	.irq_mask	= arc_mask_irq,
+	.irq_unmask	= arc_unmask_irq,
+};
+
+void __init plat_init_IRQ(void)
+{
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		irq_set_chip_and_handler(i, &fpga_chip, handle_level_irq);
+}
-- 
1.7.4.1

