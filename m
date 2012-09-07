Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2IGQe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:34:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34345 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2IGQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:53 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 11/31] arm64: IRQ handling
Date: Fri,  7 Sep 2012 17:26:46 +0100
Message-Id: <1347035226-18649-12-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:51.0863 (UTC) FILETIME=[BA098C70:01CD8D15]
X-MC-Unique: 112090717275201801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GYoRd008451

From: Marc Zyngier <marc.zyngier@arm.com>

This patch adds the support for IRQ handling. The actual interrupt
controller will be part of a separate patch (going into
drivers/irqchip/).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/hardirq.h  |   47 +++++++++++++++++++
 arch/arm64/include/asm/irq.h      |    8 +++
 arch/arm64/include/asm/irqflags.h |   91 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/irq.c           |   84 ++++++++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/hardirq.h
 create mode 100644 arch/arm64/include/asm/irq.h
 create mode 100644 arch/arm64/include/asm/irqflags.h
 create mode 100644 arch/arm64/kernel/irq.c

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
new file mode 100644
index 0000000..c6c9514
--- /dev/null
+++ b/arch/arm64/include/asm/hardirq.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_HARDIRQ_H
+#define __ASM_HARDIRQ_H
+
+#include <linux/cache.h>
+#include <linux/threads.h>
+#include <asm/irq.h>
+
+typedef struct {
+	unsigned int __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
+
+#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+
+#define __inc_irq_stat(cpu, member)	__IRQ_STAT(cpu, member)++
+#define __get_irq_stat(cpu, member)	__IRQ_STAT(cpu, member)
+
+#ifdef CONFIG_SMP
+u64 smp_irq_stat_cpu(unsigned int cpu);
+#define arch_irq_stat_cpu	smp_irq_stat_cpu
+#endif
+
+#define __ARCH_IRQ_EXIT_IRQS_DISABLED	1
+
+static inline void ack_bad_irq(unsigned int irq)
+{
+	extern unsigned long irq_err_count;
+	irq_err_count++;
+}
+
+extern void handle_IRQ(unsigned int, struct pt_regs *);
+
+#endif /* __ASM_HARDIRQ_H */
diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
new file mode 100644
index 0000000..a4e1cad
--- /dev/null
+++ b/arch/arm64/include/asm/irq.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_IRQ_H
+#define __ASM_IRQ_H
+
+#include <asm-generic/irq.h>
+
+extern void (*handle_arch_irq)(struct pt_regs *);
+
+#endif
diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
new file mode 100644
index 0000000..aa11943
--- /dev/null
+++ b/arch/arm64/include/asm/irqflags.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_IRQFLAGS_H
+#define __ASM_IRQFLAGS_H
+
+#ifdef __KERNEL__
+
+#include <asm/ptrace.h>
+
+/*
+ * CPU interrupt mask handling.
+ */
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	asm volatile(
+		"mrs	%0, daif		// arch_local_irq_save\n"
+		"msr	daifset, #2"
+		: "=r" (flags)
+		:
+		: "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile(
+		"msr	daifclr, #2		// arch_local_irq_enable"
+		:
+		:
+		: "memory");
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile(
+		"msr	daifset, #2		// arch_local_irq_disable"
+		:
+		:
+		: "memory");
+}
+
+#define local_fiq_enable()	asm("msr	daifclr, #1" : : : "memory")
+#define local_fiq_disable()	asm("msr	daifset, #1" : : : "memory")
+
+/*
+ * Save the current interrupt enable state.
+ */
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile(
+		"mrs	%0, daif		// arch_local_save_flags"
+		: "=r" (flags)
+		:
+		: "memory");
+	return flags;
+}
+
+/*
+ * restore saved IRQ state
+ */
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile(
+		"msr	daif, %0		// arch_local_irq_restore"
+	:
+	: "r" (flags)
+	: "memory");
+}
+
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return flags & PSR_I_BIT;
+}
+
+#endif
+#endif
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
new file mode 100644
index 0000000..0373c66
--- /dev/null
+++ b/arch/arm64/kernel/irq.c
@@ -0,0 +1,84 @@
+/*
+ * Based on arch/arm/kernel/irq.c
+ *
+ * Copyright (C) 1992 Linus Torvalds
+ * Modifications for ARM processor Copyright (C) 1995-2000 Russell King.
+ * Support for Dynamic Tick Timer Copyright (C) 2004-2005 Nokia Corporation.
+ * Dynamic Tick Timer written by Tony Lindgren <tony@atomide.com> and
+ * Tuukka Tikkanen <tuukka.tikkanen@elektrobit.com>.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel_stat.h>
+#include <linux/irq.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/of_irq.h>
+#include <linux/seq_file.h>
+#include <linux/ratelimit.h>
+
+unsigned long irq_err_count;
+
+int arch_show_interrupts(struct seq_file *p, int prec)
+{
+#ifdef CONFIG_SMP
+	show_ipi_list(p, prec);
+#endif
+	seq_printf(p, "%*s: %10lu\n", prec, "Err", irq_err_count);
+	return 0;
+}
+
+/*
+ * handle_IRQ handles all hardware IRQ's.  Decoded IRQs should
+ * not come via this function.  Instead, they should provide their
+ * own 'handler'.  Used by platform code implementing C-based 1st
+ * level decoding.
+ */
+void handle_IRQ(unsigned int irq, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+
+	/*
+	 * Some hardware gives randomly wrong interrupts.  Rather
+	 * than crashing, do something sensible.
+	 */
+	if (unlikely(irq >= nr_irqs)) {
+		pr_warn_ratelimited("Bad IRQ%u\n", irq);
+		ack_bad_irq(irq);
+	} else {
+		generic_handle_irq(irq);
+	}
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+/*
+ * Interrupt controllers supported by the kernel.
+ */
+static const struct of_device_id intctrl_of_match[] __initconst = {
+	/* IRQ controllers { .compatible, .data } info to go here */
+	{}
+};
+
+void __init init_IRQ(void)
+{
+	of_irq_init(intctrl_of_match);
+
+	if (!handle_arch_irq)
+		panic("No interrupt controller found.");
+}

