Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1BJXmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:42:52 -0500
Received: from www.tglx.de ([62.245.132.106]:44427 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab1BJXiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:10 -0500
Message-Id: <20110210223259.513569385@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 54/75] genirq: Move debug code to separate header
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-debugging-stuff.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It'll break when I'm going to undefine the constants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/debug.h     |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/irq/internals.h |   48 ++++--------------------------------------------
 2 files changed, 44 insertions(+), 44 deletions(-)

Index: linux-2.6-tip/kernel/irq/debug.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/irq/debug.h
@@ -0,0 +1,40 @@
+/*
+ * Debugging printout:
+ */
+
+#include <linux/kallsyms.h>
+
+#define P(f) if (desc->status & f) printk("%14s set\n", #f)
+#define PS(f) if (desc->istate & f) printk("%14s set\n", #f)
+
+static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
+		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+	printk("->handle_irq():  %p, ", desc->handle_irq);
+	print_symbol("%s\n", (unsigned long)desc->handle_irq);
+	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
+	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
+	printk("->action(): %p\n", desc->action);
+	if (desc->action) {
+		printk("->action->handler(): %p, ", desc->action->handler);
+		print_symbol("%s\n", (unsigned long)desc->action->handler);
+	}
+
+	P(IRQ_LEVEL);
+	P(IRQ_PER_CPU);
+	P(IRQ_NOPROBE);
+	P(IRQ_NOREQUEST);
+	P(IRQ_NOAUTOEN);
+
+	PS(IRQS_AUTODETECT);
+	PS(IRQS_INPROGRESS);
+	PS(IRQS_REPLAY);
+	PS(IRQS_WAITING);
+	PS(IRQS_DISABLED);
+	PS(IRQS_PENDING);
+	PS(IRQS_MASKED);
+}
+
+#undef P
+#undef PS
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -7,9 +7,6 @@
  */
 #include <linux/irqdesc.h>
 
-#include "compat.h"
-#include "settings.h"
-
 #define istate core_internal_state__do_not_mess_with_it
 
 extern int noirqdebug;
@@ -63,6 +60,10 @@ enum {
 	IRQS_WAKEUP		= 0x00001000,
 };
 
+#include "compat.h"
+#include "debug.h"
+#include "settings.h"
+
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
 
 /* Set default functions for irq_chip structures: */
@@ -136,44 +137,3 @@ static inline void irqd_clr_move_pending
 	d->state_use_accessors &= ~IRQD_SETAFFINITY_PENDING;
 	irq_compat_clr_move_pending(irq_data_to_desc(d));
 }
-
-/*
- * Debugging printout:
- */
-
-#include <linux/kallsyms.h>
-
-#define P(f) if (desc->status & f) printk("%14s set\n", #f)
-#define PS(f) if (desc->istate & f) printk("%14s set\n", #f)
-
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
-{
-	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
-	printk("->handle_irq():  %p, ", desc->handle_irq);
-	print_symbol("%s\n", (unsigned long)desc->handle_irq);
-	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
-	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
-	printk("->action(): %p\n", desc->action);
-	if (desc->action) {
-		printk("->action->handler(): %p, ", desc->action->handler);
-		print_symbol("%s\n", (unsigned long)desc->action->handler);
-	}
-
-	P(IRQ_LEVEL);
-	P(IRQ_PER_CPU);
-	P(IRQ_NOPROBE);
-	P(IRQ_NOREQUEST);
-	P(IRQ_NOAUTOEN);
-
-	PS(IRQS_AUTODETECT);
-	PS(IRQS_INPROGRESS);
-	PS(IRQS_REPLAY);
-	PS(IRQS_WAITING);
-	PS(IRQS_DISABLED);
-	PS(IRQS_PENDING);
-	PS(IRQS_MASKED);
-}
-
-#undef P
-#undef PS


