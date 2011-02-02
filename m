Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1BBVmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:42:16 -0500
Received: from www.tglx.de ([62.245.132.106]:38943 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1BBVmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:42:01 -0500
Message-Id: <20110202212552.531432946@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 8/8] genirq: Make handle_IRQ_event private to the core code
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline;
	filename=genirq-make-handle_IRQ_event-private-to-genirq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users outside of kernel/irq. We really want to have flow
handlers in the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/DocBook/genericirq.tmpl |   10 +++++-----
 include/linux/irq.h                   |    3 ---
 kernel/irq/chip.c                     |   10 +++++-----
 kernel/irq/handle.c                   |    4 ++--
 kernel/irq/internals.h                |    3 +++
 kernel/irq/spurious.c                 |    2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/Documentation/DocBook/genericirq.tmpl
===================================================================
--- linux-2.6-tip.orig/Documentation/DocBook/genericirq.tmpl
+++ linux-2.6-tip/Documentation/DocBook/genericirq.tmpl
@@ -285,7 +285,7 @@ noop(struct irq_data *data))
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
 desc->chip->irq_mask();
-handle_IRQ_event(desc->action);
+handle_irq_event(desc->action);
 desc->chip->irq_unmask();
 		</programlisting>
 		</para>
@@ -300,7 +300,7 @@ desc->chip->irq_unmask();
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-handle_IRQ_event(desc->action);
+handle_irq_event(desc->action);
 desc->chip->irq_eoi();
 		</programlisting>
 		</para>
@@ -325,7 +325,7 @@ do {
 	if (desc->status &amp; masked)
 		desc->chip->irq_unmask();
 	desc->status &amp;= ~pending;
-	handle_IRQ_event(desc->action);
+	handle_irq_event(desc->action);
 } while (status &amp; pending);
 desc->status &amp;= ~running;
 		</programlisting>
@@ -344,7 +344,7 @@ desc->status &amp;= ~running;
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-handle_IRQ_event(desc->action);
+handle_irq_event(desc->action);
 		</programlisting>
 		</para>
    	    </sect3>
@@ -362,7 +362,7 @@ handle_IRQ_event(desc->action);
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-handle_IRQ_event(desc->action);
+handle_irq_event(desc->action);
 if (desc->chip->irq_eoi)
         desc->chip->irq_eoi();
 		</programlisting>
Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -236,9 +236,6 @@ static inline void move_masked_irq(int i
 
 extern int no_irq_affinity;
 
-/* Handle irq action chains: */
-extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
-
 /*
  * Built-in IRQ handlers for various IRQ types,
  * callable via desc->handle_irq()
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -492,7 +492,7 @@ handle_simple_irq(unsigned int irq, stru
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
-	action_ret = handle_IRQ_event(irq, action);
+	action_ret = handle_irq_event(irq, action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
@@ -537,7 +537,7 @@ handle_level_irq(unsigned int irq, struc
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
-	action_ret = handle_IRQ_event(irq, action);
+	action_ret = handle_irq_event(irq, action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
@@ -590,7 +590,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	desc->status &= ~IRQ_PENDING;
 	raw_spin_unlock(&desc->lock);
 
-	action_ret = handle_IRQ_event(irq, action);
+	action_ret = handle_irq_event(irq, action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
@@ -669,7 +669,7 @@ handle_edge_irq(unsigned int irq, struct
 
 		desc->status &= ~IRQ_PENDING;
 		raw_spin_unlock(&desc->lock);
-		action_ret = handle_IRQ_event(irq, action);
+		action_ret = handle_irq_event(irq, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 		raw_spin_lock(&desc->lock);
@@ -700,7 +700,7 @@ handle_percpu_irq(unsigned int irq, stru
 	if (desc->irq_data.chip->irq_ack)
 		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	action_ret = handle_IRQ_event(irq, desc->action);
+	action_ret = handle_irq_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -52,13 +52,13 @@ static void warn_no_thread(unsigned int 
 }
 
 /**
- * handle_IRQ_event - irq action chain handler
+ * handle_irq_event - irq action chain handler
  * @irq:	the interrupt number
  * @action:	the interrupt action chain for this irq
  *
  * Handles the action chain of an irq event
  */
-irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+irqreturn_t handle_irq_event(unsigned int irq, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -40,6 +40,9 @@ static inline void unregister_handler_pr
 					   struct irqaction *action) { }
 #endif
 
+/* Handle irq action chains: */
+extern irqreturn_t handle_irq_event(unsigned int irq, struct irqaction *action);
+
 extern int irq_select_affinity_usr(unsigned int irq);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -71,7 +71,7 @@ static int try_one_irq(int irq, struct i
 		 */
 		work = 1;
 		raw_spin_unlock(&desc->lock);
-		handle_IRQ_event(irq, action);
+		handle_irq_event(irq, action);
 		raw_spin_lock(&desc->lock);
 		desc->status &= ~IRQ_PENDING;
 	}


