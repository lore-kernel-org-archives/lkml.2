Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab1J3MtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:49:00 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:36217 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040Ab1J3Msw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:52 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 11/27] m68k/irq: Add genirq support
Date: Sun, 30 Oct 2011 13:48:19 +0100
Message-Id: <1319978915-10933-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabled on all platforms for now

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
[v1] Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/Kconfig               |   17 ++++++++++++
 arch/m68k/include/asm/hardirq.h |    5 +++
 arch/m68k/include/asm/irq.h     |   41 ++++++++++++++++++++++++------
 arch/m68k/kernel/Makefile       |    9 +++++-
 arch/m68k/kernel/ints.c         |   52 ++++++++++++++++++++++++++++++++++++++-
 5 files changed, 112 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6c28582..a7597e1 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -84,6 +84,23 @@ config MMU_SUN3
 	bool
 	depends on MMU && !MMU_MOTOROLA
 
+config USE_GENERIC_HARDIRQS
+	bool "Use genirq"
+	depends on MMU
+	depends on !AMIGA
+	depends on !ATARI
+	depends on !MAC
+	depends on !APOLLO
+	depends on !MVME147
+	depends on !MVME16x
+	depends on !BVME6000
+	depends on !HP300
+	depends on !SUN3X
+	depends on !Q40
+	depends on !SUN3
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_SHOW
+
 menu "Platform setup"
 
 source arch/m68k/Kconfig.cpu
diff --git a/arch/m68k/include/asm/hardirq.h b/arch/m68k/include/asm/hardirq.h
index 870e534..db30ed2 100644
--- a/arch/m68k/include/asm/hardirq.h
+++ b/arch/m68k/include/asm/hardirq.h
@@ -18,6 +18,11 @@
 
 #ifdef CONFIG_MMU
 
+static inline void ack_bad_irq(unsigned int irq)
+{
+	pr_crit("unexpected IRQ trap at vector %02x\n", irq);
+}
+
 /* entry.S is sensitive to the offsets of these fields */
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 9a2bae8..518e61f 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -27,11 +27,6 @@
 
 #ifdef CONFIG_MMU
 
-#include <linux/linkage.h>
-#include <linux/hardirq.h>
-#include <linux/irqreturn.h>
-#include <linux/spinlock_types.h>
-
 /*
  * Interrupt source definitions
  * General interrupt sources are the level 1-7.
@@ -54,10 +49,6 @@
 
 #define IRQ_USER	8
 
-extern unsigned int irq_canonicalize(unsigned int irq);
-
-struct pt_regs;
-
 /*
  * various flags for request_irq() - the Amiga now uses the standard
  * mechanism like all other architectures - IRQF_DISABLED and
@@ -71,6 +62,15 @@ struct pt_regs;
 #define IRQ_FLG_STD	(0x8000)	/* internally used		*/
 #endif
 
+#ifndef CONFIG_GENERIC_HARDIRQS
+
+#include <linux/linkage.h>
+#include <linux/hardirq.h>
+#include <linux/irqreturn.h>
+#include <linux/spinlock_types.h>
+
+struct pt_regs;
+
 /*
  * This structure is used to chain together the ISRs for a particular
  * interrupt source (if it supports chaining).
@@ -121,10 +121,33 @@ extern void m68k_setup_irq_chip(struct irq_chip *, unsigned int, unsigned int);
 extern void generic_handle_irq(unsigned int);
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
 
+#else /* CONFIG_GENERIC_HARDIRQS */
+
+struct irq_data;
+struct irq_chip;
+struct irq_desc;
+extern unsigned int m68k_irq_startup(struct irq_data *data);
+extern unsigned int m68k_irq_startup_irq(unsigned int irq);
+extern void m68k_irq_shutdown(struct irq_data *data);
+extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int,
+						      struct pt_regs *));
+extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
+				      void (*handler)(unsigned int,
+						      struct pt_regs *));
+extern void m68k_setup_irq_controller(struct irq_chip *,
+				      void (*handle)(unsigned int irq,
+						     struct irq_desc *desc),
+				      unsigned int irq, unsigned int cnt);
+
+#endif /* CONFIG_GENERIC_HARDIRQS */
+
+extern unsigned int irq_canonicalize(unsigned int irq);
+
 #else
 #define irq_canonicalize(irq)  (irq)
 #endif /* CONFIG_MMU */
 
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
+extern atomic_t irq_err_count;
 
 #endif /* _M68K_IRQ_H_ */
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index e7f0f2e..1414257 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -9,13 +9,18 @@ extra-y			+= vmlinux.lds
 obj-y	:= entry.o m68k_ksyms.o module.o process.o ptrace.o setup.o signal.o \
 	   sys_m68k.o syscalltable.o time.o traps.o
 
-obj-$(CONFIG_MMU)	+= ints.o devres.o vectors.o
+obj-$(CONFIG_MMU)	+= ints.o vectors.o
 devres-$(CONFIG_MMU)	= ../../../kernel/irq/devres.o
 
 ifndef CONFIG_MMU_SUN3
 obj-y			+= dma.o
 endif
 ifndef CONFIG_MMU
-obj-y			+= init_task.o irq.o
+obj-y			+= init_task.o
+endif
+ifdef CONFIG_GENERIC_HARDIRQS
+obj-y			+= irq.o
+else
+obj-y			+= devres.o
 endif
 
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index f6a4698..cea439f 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -31,6 +31,7 @@ extern u32 auto_irqhandler_fixup[];
 extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 /* table for system interrupt handlers */
 static struct irq_data *irq_list[NR_IRQS];
 static struct irq_chip *irq_chip[NR_IRQS];
@@ -41,6 +42,8 @@ static inline int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 	irq_chip[irq] = chip;
 	return 0;
 }
+#define irq_set_chip_and_handler(irq, chip, dummy)	irq_set_chip(irq, chip)
+#endif /* !CONFIG_GENERIC_HARDIRQS */
 
 static int m68k_first_user_vec;
 
@@ -56,8 +59,10 @@ static struct irq_chip user_irq_chip = {
 	.irq_shutdown	= m68k_irq_shutdown,
 };
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 #define NUM_IRQ_NODES 100
 static struct irq_data nodes[NUM_IRQ_NODES];
+#endif /* !CONFIG_GENERIC_HARDIRQS */
 
 /*
  * void init_IRQ(void)
@@ -81,7 +86,7 @@ void __init init_IRQ(void)
 	}
 
 	for (i = IRQ_AUTO_1; i <= IRQ_AUTO_7; i++)
-		irq_set_chip(i, &auto_irq_chip);
+		irq_set_chip_and_handler(i, &auto_irq_chip, handle_simple_irq);
 
 	mach_init_IRQ();
 }
@@ -128,6 +133,35 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 	flush_icache();
 }
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+
+/**
+ * m68k_setup_irq_controller
+ * @chip: irq chip which controls specified irq
+ * @handle: flow handler which handles specified irq
+ * @irq: first irq to be managed by the controller
+ * @cnt: number of irqs to be managed by the controller
+ *
+ * Change the controller for the specified range of irq, which will be used to
+ * manage these irq. auto/user irq already have a default controller, which can
+ * be changed as well, but the controller probably should use m68k_irq_startup/
+ * m68k_irq_shutdown.
+ */
+void m68k_setup_irq_controller(struct irq_chip *chip,
+			       irq_flow_handler_t handle, unsigned int irq,
+			       unsigned int cnt)
+{
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		irq_set_chip(irq + i, chip);
+		if (handle)
+			irq_set_handler(irq + i, handle);
+	}
+}
+
+#else /* !CONFIG_GENERIC_HARDIRQS */
+
 /**
  * m68k_setup_irq_chip
  * @contr: irq controller which controls specified irq
@@ -316,6 +350,8 @@ void disable_irq_nosync(unsigned int irq) __attribute__((alias("disable_irq")));
 
 EXPORT_SYMBOL(disable_irq_nosync);
 
+#endif /* !CONFIG_GENERIC_HARDIRQS */
+
 unsigned int m68k_irq_startup_irq(unsigned int irq)
 {
 	if (irq <= IRQ_AUTO_7)
@@ -341,6 +377,8 @@ void m68k_irq_shutdown(struct irq_data *data)
 }
 
 
+#ifndef CONFIG_GENERIC_HARDIRQS
+
 /*
  * Do we need these probe functions on the m68k?
  *
@@ -367,6 +405,7 @@ int probe_irq_off (unsigned long irqs)
 }
 
 EXPORT_SYMBOL(probe_irq_off);
+#endif /* CONFIG_GENERIC_HARDIRQS */
 
 unsigned int irq_canonicalize(unsigned int irq)
 {
@@ -379,6 +418,7 @@ unsigned int irq_canonicalize(unsigned int irq)
 
 EXPORT_SYMBOL(irq_canonicalize);
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 void generic_handle_irq(unsigned int irq)
 {
 	struct irq_data *node;
@@ -428,3 +468,13 @@ void init_irq_proc(void)
 	/* Insert /proc/irq driver here */
 }
 #endif
+
+#else /* CONFIG_GENERIC_HARDIRQS */
+
+asmlinkage void handle_badint(struct pt_regs *regs)
+{
+	atomic_inc(&irq_err_count);
+	pr_warn("unexpected interrupt from %u\n", regs->vector);
+}
+
+#endif /* CONFIG_GENERIC_HARDIRQS */
-- 
1.7.0.4

