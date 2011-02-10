Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1BJXhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:35 -0500
Received: from www.tglx.de ([62.245.132.106]:44254 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab1BJXhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:32 -0500
Message-Id: <20110210223257.391785851@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 32/75] genirq: Add internal state field to irq_desc
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-add-internal-state-field.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That field will contain internal state information which is not going
to be exposed to anything outside the core code - except via accessor
functions. I'm tired of everyone fiddling in irq_desc.status.

core_internal_state__do_not_mess_with_it is clear enough, annoying to
type and easy to grep for. Offenders will be tracked down and slapped
with stinking trouts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdesc.h |    3 ++-
 kernel/irq/internals.h  |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/irqdesc.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqdesc.h
+++ linux-2.6-tip/include/linux/irqdesc.h
@@ -19,6 +19,7 @@ struct timer_rand_state;
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @action:		the irq action chain
  * @status:		status information
+ * @core_internal_state__do_not_mess_with_it: core internal status information
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
@@ -63,7 +64,7 @@ struct irq_desc {
 	irq_flow_handler_t	handle_irq;
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status;		/* IRQ status */
-
+	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -1,8 +1,14 @@
 /*
  * IRQ subsystem internal functions and variables:
+ *
+ * Do not ever include this file from anything else than
+ * kernel/irq/. Do not even think about using any information outside
+ * of this file for your non core code.
  */
 #include <linux/irqdesc.h>
 
+#define istate core_internal_state__do_not_mess_with_it
+
 extern int noirqdebug;
 
 /*


