Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2KGJsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:18 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:39258 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KGJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:14 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 02/31] ARC: irqflags
Date: Wed,  7 Nov 2012 10:47:25 +0100
Message-Id: <1352281674-2186-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h  |  114 +++++++++++++++++++++++++++++++
 arch/arc/include/asm/irqflags.h |  143 +++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/irq.c           |   32 +++++++++
 3 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/arcregs.h
 create mode 100644 arch/arc/include/asm/irqflags.h
 create mode 100644 arch/arc/kernel/irq.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
new file mode 100644
index 0000000..8ca8faf
--- /dev/null
+++ b/arch/arc/include/asm/arcregs.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_ARCREGS_H
+#define _ASM_ARC_ARCREGS_H
+
+#ifdef __KERNEL__
+
+/* status32 Bits Positions */
+#define STATUS_H_BIT		0	/* CPU Halted */
+#define STATUS_E1_BIT		1	/* Int 1 enable */
+#define STATUS_E2_BIT		2	/* Int 2 enable */
+#define STATUS_A1_BIT		3	/* Int 1 active */
+#define STATUS_A2_BIT		4	/* Int 2 active */
+#define STATUS_AE_BIT		5	/* Exception active */
+#define STATUS_DE_BIT		6	/* PC is in delay slot */
+#define STATUS_U_BIT		7	/* User/Kernel mode */
+#define STATUS_L_BIT		12	/* Loop inhibit */
+
+/* These masks correspond to the status word(STATUS_32) bits */
+#define STATUS_H_MASK		(1<<STATUS_H_BIT)
+#define STATUS_E1_MASK		(1<<STATUS_E1_BIT)
+#define STATUS_E2_MASK		(1<<STATUS_E2_BIT)
+#define STATUS_A1_MASK		(1<<STATUS_A1_BIT)
+#define STATUS_A2_MASK		(1<<STATUS_A2_BIT)
+#define STATUS_AE_MASK		(1<<STATUS_AE_BIT)
+#define STATUS_DE_MASK		(1<<STATUS_DE_BIT)
+#define STATUS_U_MASK		(1<<STATUS_U_BIT)
+#define STATUS_L_MASK		(1<<STATUS_L_BIT)
+
+/* Auxiliary registers */
+#define AUX_IDENTITY		4
+#define AUX_INTR_VEC_BASE	0x25
+#define AUX_IRQ_LEV		0x200	/* IRQ Priority: L1 or L2 */
+#define AUX_IRQ_HINT		0x201	/* For generating Soft Interrupts */
+#define AUX_IRQ_LV12		0x43	/* interrupt level register */
+
+#define AUX_IENABLE		0x40c
+#define AUX_ITRIGGER		0x40d
+#define AUX_IPULSE		0x415
+
+#ifndef __ASSEMBLY__
+
+/*
+ ******************************************************************
+ *      Inline ASM macros to read/write AUX Regs
+ *      Essentially invocation of lr/sr insns from "C"
+ */
+
+#if 1
+
+#define read_aux_reg(reg)	__builtin_arc_lr(reg)
+
+/* gcc builtin sr needs reg param to be long immediate */
+#define write_aux_reg(reg_immed, val)		\
+		__builtin_arc_sr((unsigned int)val, reg_immed)
+
+#else
+
+#define read_aux_reg(reg)		\
+({					\
+	unsigned int __ret;		\
+	__asm__ __volatile__(		\
+	"	lr    %0, [%1]"		\
+	: "=r"(__ret)			\
+	: "i"(reg));			\
+	__ret;				\
+})
+
+/*
+ * Aux Reg address is specified as long immediate by caller
+ * e.g.
+ *    write_aux_reg(0x69, some_val);
+ * This generates tightest code.
+ */
+#define write_aux_reg(reg_imm, val)	\
+({					\
+	__asm__ __volatile__(		\
+	"	sr   %0, [%1]	\n"	\
+	:				\
+	: "ir"(val), "i"(reg_imm));	\
+})
+
+/*
+ * Aux Reg address is specified in a variable
+ *  * e.g.
+ *      reg_num = 0x69
+ *      write_aux_reg2(reg_num, some_val);
+ * This has to generate glue code to load the reg num from
+ *  memory to a reg hence not recommended.
+ */
+#define write_aux_reg2(reg_in_var, val)		\
+({						\
+	unsigned int tmp;			\
+						\
+	__asm__ __volatile__(			\
+	"	ld   %0, [%2]	\n\t"		\
+	"	sr   %1, [%0]	\n\t"		\
+	: "=&r"(tmp)				\
+	: "r"(val), "memory"(&reg_in_var));	\
+})
+
+#endif
+
+#endif /* __ASEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_ARC_ARCREGS_H */
diff --git a/arch/arc/include/asm/irqflags.h b/arch/arc/include/asm/irqflags.h
new file mode 100644
index 0000000..752e55d
--- /dev/null
+++ b/arch/arc/include/asm/irqflags.h
@@ -0,0 +1,143 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_IRQFLAGS_H
+#define __ASM_ARC_IRQFLAGS_H
+
+/* vineetg: March 2010 : local_irq_save( ) optimisation
+ *  -Remove explicit mov of current status32 into reg, that is not needed
+ *  -Use BIC  insn instead of INVERTED + AND
+ *  -Conditionally disable interrupts (if they are not enabled, don't disable)
+*/
+
+#ifdef __KERNEL__
+
+#include <asm/arcregs.h>
+
+#ifndef __ASSEMBLY__
+
+/******************************************************************
+ * IRQ Control Macros
+ ******************************************************************/
+
+/*
+ * Save IRQ state and disable IRQs
+ */
+static inline long arch_local_irq_save(void)
+{
+	unsigned long temp, flags;
+
+	__asm__ __volatile__(
+	"	lr  %1, [status32]	\n"
+	"	bic %0, %1, %2		\n"
+	"	and.f 0, %1, %2	\n"
+	"	flag.nz %0		\n"
+	: "=r"(temp), "=r"(flags)
+	: "n"((STATUS_E1_MASK | STATUS_E2_MASK))
+	: "cc");
+
+	return flags;
+}
+
+/*
+ * restore saved IRQ state
+ */
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+
+	__asm__ __volatile__(
+	"	flag %0			\n"
+	:
+	: "r"(flags));
+}
+
+/*
+ * Conditionally Enable IRQs
+ */
+extern void arch_local_irq_enable(void);
+
+/*
+ * Unconditionally Disable IRQs
+ */
+static inline void arch_local_irq_disable(void)
+{
+	unsigned long temp;
+
+	__asm__ __volatile__(
+	"	lr  %0, [status32]	\n"
+	"	and %0, %0, %1		\n"
+	"	flag %0			\n"
+	: "=&r"(temp)
+	: "n"(~(STATUS_E1_MASK | STATUS_E2_MASK)));
+}
+
+/*
+ * save IRQ state
+ */
+static inline long arch_local_save_flags(void)
+{
+	unsigned long temp;
+
+	__asm__ __volatile__(
+	"	lr  %0, [status32]	\n"
+	: "=&r"(temp));
+
+	return temp;
+}
+
+/*
+ * Query IRQ state
+ */
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & (STATUS_E1_MASK));
+}
+
+static inline int arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+static inline void arch_mask_irq(unsigned int irq)
+{
+	unsigned int ienb;
+
+	ienb = read_aux_reg(AUX_IENABLE);
+	ienb &= ~(1 << irq);
+	write_aux_reg(AUX_IENABLE, ienb);
+}
+
+static inline void arch_unmask_irq(unsigned int irq)
+{
+	unsigned int ienb;
+
+	ienb = read_aux_reg(AUX_IENABLE);
+	ienb |= (1 << irq);
+	write_aux_reg(AUX_IENABLE, ienb);
+}
+
+#else
+
+.macro IRQ_DISABLE  scratch
+	lr	\scratch, [status32]
+	bic	\scratch, \scratch, (STATUS_E1_MASK | STATUS_E2_MASK)
+	flag	\scratch
+.endm
+
+.macro IRQ_DISABLE_SAVE  scratch, save
+	lr	\scratch, [status32]
+	mov	\save, \scratch		/* Make a copy */
+	bic	\scratch, \scratch, (STATUS_E1_MASK | STATUS_E2_MASK)
+	flag	\scratch
+.endm
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* KERNEL */
+
+#endif
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
new file mode 100644
index 0000000..16fcbe8
--- /dev/null
+++ b/arch/arc/kernel/irq.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2011-12 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <asm/irqflags.h>
+#include <asm/arcregs.h>
+
+void arch_local_irq_enable(void)
+{
+
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	flags |= (STATUS_E1_MASK | STATUS_E2_MASK);
+
+	/*
+	 * If called from hard ISR (between irq_enter and irq_exit)
+	 * don't allow Level 1. In Soft ISR we allow further Level 1s
+	 */
+
+	if (in_irq())
+		flags &= ~(STATUS_E1_MASK | STATUS_E2_MASK);
+
+	arch_local_irq_restore(flags);
+}
+EXPORT_SYMBOL(arch_local_irq_enable);
-- 
1.7.4.1

