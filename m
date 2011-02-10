Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1BJXi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:56 -0500
Received: from www.tglx.de ([62.245.132.106]:44621 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab1BJXix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:53 -0500
Message-Id: <20110210223300.763271444@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 67/75] genirq: Remove desc->status when
	GENERIC_HARDIRQS_NO_COMPAT=y
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-finalize-no-compat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If everything uses the right accessors, then enabling
GENERIC_HARDIRQS_NO_COMPAT should just work. If not it will tell you.

Don't be lazy and use the trick which I use in the core code!

git grep settings_use_proper_accessors

will unearth it in a split second. Offenders are tracked down and not
slapped with stinking trouts. This time we use frozen shark for a
better educational value.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdesc.h |    6 ++++++
 kernel/irq/internals.h  |    4 ++++
 kernel/irq/settings.h   |    1 +
 3 files changed, 11 insertions(+)

Index: linux-2.6-tip/include/linux/irqdesc.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqdesc.h
+++ linux-2.6-tip/include/linux/irqdesc.h
@@ -64,7 +64,11 @@ struct irq_desc {
 	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
 	struct irqaction	*action;	/* IRQ action list */
+#ifdef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+	unsigned int		settings_use_the_proper_accessors;
+#else
 	unsigned int		status;		/* IRQ status */
+#endif
 	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
@@ -164,6 +168,7 @@ static inline int irq_has_action(unsigne
 	return desc->action != NULL;
 }
 
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 static inline int irq_balancing_disabled(unsigned int irq)
 {
 	struct irq_desc *desc;
@@ -171,6 +176,7 @@ static inline int irq_balancing_disabled
 	desc = irq_to_desc(irq);
 	return desc->status & IRQ_NO_BALANCING_MASK;
 }
+#endif
 
 /* caller has locked the irq_desc and both params are valid */
 static inline void __set_irq_handler_unlocked(int irq,
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -9,6 +9,10 @@
 
 #define istate core_internal_state__do_not_mess_with_it
 
+#ifdef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+# define status settings_use_the_proper_accessors
+#endif
+
 extern int noirqdebug;
 
 /*
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -127,4 +127,5 @@ static inline bool irq_settings_can_auto
 }
 
 /* Nothing should touch desc->status from now on */
+#undef status
 #define status		USE_THE_PROPER_WRAPPERS_YOU_MORON


