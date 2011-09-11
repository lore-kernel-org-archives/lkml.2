Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab1IKMDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:03:35 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42702 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 13/28] m68k/irq: Add genirq support
Date: Sun, 11 Sep 2011 13:59:39 +0200
Message-Id: <1315742394-16036-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabled on all platforms for now

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
[v1] Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
v6:
  - Keep irq_canonicalize(), which is needed for ac3200, atari_91C111,
    serial_core, and 8250.

v5:
  - Keep m68k_setup_auto_interrupt(), it's still needed for Q40

v3:
  - Wrapper __m68k_handle_int() for do_IRQ() is no longer needed
  - Use handle_simple_irq() instead of handle_level_irq(), which also
    means we don't need the .irq_{,un}mask methods anymore, so they can
    be removed again.
  - Keep track of spurious interrupts

v2:
  - Add missing "irq" offset in m68k_setup_irq_controller()
  - Set up default handlers for autovector interrupts, and fill in missing
    .irq_{,un}mask methods,
---
 arch/m68k/Kconfig.mmu           |   16 ++++++++++++
 arch/m68k/include/asm/hardirq.h |    5 +++
 arch/m68k/include/asm/irq.h     |   35 +++++++++++++++++++++----
 arch/m68k/kernel/Makefile_mm    |    5 +++-
 arch/m68k/kernel/ints.c         |   52 ++++++++++++++++++++++++++++++++++++++-
 5 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 4ef37c9..557b4b7 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -198,6 +198,22 @@ config SUN3
 
 	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
 
+config USE_GENERIC_HARDIRQS
+	bool "Use genirq"
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
 config NATFEAT
 	bool "ARAnyM emulator support"
 	depends on ATARI
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
index fe625e2..8971647 100644
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
@@ -54,7 +49,12 @@
 
 #define IRQ_USER	8
 
-extern unsigned int irq_canonicalize(unsigned int irq);
+#ifndef CONFIG_GENERIC_HARDIRQS
+
+#include <linux/linkage.h>
+#include <linux/hardirq.h>
+#include <linux/irqreturn.h>
+#include <linux/spinlock_types.h>
 
 struct pt_regs;
 
@@ -108,10 +108,33 @@ extern void m68k_setup_irq_chip(struct irq_chip *, unsigned int, unsigned int);
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
diff --git a/arch/m68k/kernel/Makefile_mm b/arch/m68k/kernel/Makefile_mm
index aced678..8122750 100644
--- a/arch/m68k/kernel/Makefile_mm
+++ b/arch/m68k/kernel/Makefile_mm
@@ -10,8 +10,11 @@ endif
 extra-y	+= vmlinux.lds
 
 obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o module.o \
-	   sys_m68k.o time.o setup.o m68k_ksyms.o devres.o syscalltable.o
+	   sys_m68k.o time.o setup.o m68k_ksyms.o syscalltable.o
 
 devres-y = ../../../kernel/irq/devres.o
 
 obj-y$(CONFIG_MMU_SUN3) += dma.o	# no, it's not a typo
+
+obj-y$(CONFIG_GENERIC_HARDIRQS) += devres.o
+obj-$(CONFIG_GENERIC_HARDIRQS) += irq.o
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

