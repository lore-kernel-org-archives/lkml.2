Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab2KPCWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:22:45 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61094 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2KPCVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:21:53 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/9] irq_work: Flush work on CPU_DYING
Date: Fri, 16 Nov 2012 03:21:28 +0100
Message-Id: <1353032491-16462-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
References: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

In order not to offline a CPU with pending irq works, flush the
queue from CPU_DYING. The notifier is called by stop_machine on
the CPU that is going down. The code will not be called from irq context
(so things like get_irq_regs() wont work) but I'm not sure what the
requirements are for irq_work in that regard (Peter?). But irqs are
disabled and the CPU is about to go offline. Might as well flush the work.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/irq_work.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index b3c113a..cf8b657 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -12,6 +12,7 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/cpu.h>
 #include <asm/processor.h>
 
 /*
@@ -110,11 +111,7 @@ bool irq_work_needs_cpu(void)
 	return true;
 }
 
-/*
- * Run the irq_work entries on this cpu. Requires to be ran from hardirq
- * context with local IRQs disabled.
- */
-void irq_work_run(void)
+static void __irq_work_run(void)
 {
 	struct irq_work *work;
 	struct llist_head *this_list;
@@ -124,7 +121,6 @@ void irq_work_run(void)
 	if (llist_empty(this_list))
 		return;
 
-	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
 	llnode = llist_del_all(this_list);
@@ -149,6 +145,16 @@ void irq_work_run(void)
 		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
 	}
 }
+
+/*
+ * Run the irq_work entries on this cpu. Requires to be ran from hardirq
+ * context with local IRQs disabled.
+ */
+void irq_work_run(void)
+{
+	BUG_ON(!in_irq());
+	__irq_work_run();
+}
 EXPORT_SYMBOL_GPL(irq_work_run);
 
 /*
@@ -163,3 +169,35 @@ void irq_work_sync(struct irq_work *work)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int irq_work_cpu_notify(struct notifier_block *self,
+			       unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_DYING:
+		/* Called from stop_machine */
+		if (WARN_ON_ONCE(cpu != smp_processor_id()))
+			break;
+		__irq_work_run();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_notify;
+
+static __init int irq_work_init_cpu_notifier(void)
+{
+	cpu_notify.notifier_call = irq_work_cpu_notify;
+	cpu_notify.priority = 0;
+	register_cpu_notifier(&cpu_notify);
+	return 0;
+}
+device_initcall(irq_work_init_cpu_notifier);
+
+#endif /* CONFIG_HOTPLUG_CPU */
-- 
1.7.5.4

