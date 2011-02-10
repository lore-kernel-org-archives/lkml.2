Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab1BJXsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:48:03 -0500
Received: from www.tglx.de ([62.245.132.106]:44161 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab1BJXhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:09 -0500
Message-Id: <20110210223257.199002001@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 30/75] genirq: Implement generic irq_show_interrupts()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-implement-generic-show-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All archs implement show_interrupts() in more or less the same
way. That's tons of duplicated code with different bugs with no
value. Implement a generic version and deprecate show_interrupts()

Unfortunately we need some ifdeffery for !GENERIC_HARDIRQ archs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/interrupts.c      |    2 -
 include/linux/interrupt.h |    8 +++++
 kernel/irq/Kconfig        |    3 ++
 kernel/irq/proc.c         |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/fs/proc/interrupts.c
===================================================================
--- linux-2.6-tip.orig/fs/proc/interrupts.c
+++ linux-2.6-tip/fs/proc/interrupts.c
@@ -30,7 +30,7 @@ static const struct seq_operations int_s
 	.start = int_seq_start,
 	.next  = int_seq_next,
 	.stop  = int_seq_stop,
-	.show  = show_interrupts
+	.show  = proc_show_interrupts
 };
 
 static int interrupts_open(struct inode *inode, struct file *filp)
Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -662,7 +662,15 @@ static inline void init_irq_proc(void)
 #endif
 
 struct seq_file;
+#ifdef CONFIG_GENERIC_HARDIRQS
+int __deprecated show_interrupts(struct seq_file *p, void *v);
+int irq_show_interrupts(struct seq_file *p, void *v);
+int arch_show_interrupts(struct seq_file *p, int prec);
+# define proc_show_interrupts irq_show_interrupts
+#else
 int show_interrupts(struct seq_file *p, void *v);
+# define proc_show_interrupts show_interrupts
+#endif
 
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Kconfig
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -20,6 +20,9 @@ config HAVE_SPARSE_IRQ
 config GENERIC_IRQ_PROBE
 	def_bool n
 
+config GENERIC_IRQ_SHOW
+       def_bool n
+
 config GENERIC_PENDING_IRQ
 	def_bool n
 
Index: linux-2.6-tip/kernel/irq/proc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/proc.c
+++ linux-2.6-tip/kernel/irq/proc.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
 
 #include "internals.h"
 
@@ -357,3 +358,70 @@ void init_irq_proc(void)
 	}
 }
 
+#ifdef CONFIG_GENERIC_IRQ_SHOW
+
+int __weak arch_show_interrupts(struct seq_file *p, int prec)
+{
+	return 0;
+}
+
+int irq_show_interrupts(struct seq_file *p, void *v)
+{
+	static int prec;
+
+	unsigned long flags, any_count = 0;
+	int i = *(loff_t *) v, j;
+	struct irqaction *action;
+	struct irq_desc *desc;
+
+	if (i > nr_irqs)
+		return 0;
+
+	if (i == nr_irqs)
+		return arch_show_interrupts(p, prec);
+
+	/* print header and calculate the width of the first column */
+	if (i == 0) {
+		for (prec = 3, j = 1000; prec < 10 && j <= nr_irqs; ++prec)
+			j *= 10;
+
+		seq_printf(p, "%*s", prec + 8, "");
+		for_each_online_cpu(j)
+			seq_printf(p, "CPU%-8d", j);
+		seq_putc(p, '\n');
+	}
+
+	desc = irq_to_desc(i);
+	if (!desc)
+		return 0;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	for_each_online_cpu(j)
+		any_count |= kstat_irqs_cpu(i, j);
+	action = desc->action;
+	if (!action && !any_count)
+		goto out;
+
+	seq_printf(p, "%*d: ", prec, i);
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+	seq_printf(p, " %8s", desc->irq_data.chip->name);
+	seq_printf(p, "-%-8s", desc->name);
+
+	if (action) {
+		seq_printf(p, "  %s", action->name);
+		while ((action = action->next) != NULL)
+			seq_printf(p, ", %s", action->name);
+	}
+
+	seq_putc(p, '\n');
+out:
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
+#else
+int irq_show_interrupts(struct seq_file *p, void *v)
+{
+	return show_interrupts(p, v);
+}
+#endif


