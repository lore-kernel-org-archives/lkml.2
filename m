Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1BJXiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:23 -0500
Received: from www.tglx.de ([62.245.132.106]:44469 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab1BJXiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:20 -0500
Message-Id: <20110210223259.991739762@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 59/75] genirq: Wrap the remaning IRQ_* flags
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-remaning-status-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wrappers to keep them away from the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/autoprobe.c |    4 +--
 kernel/irq/chip.c      |    3 +-
 kernel/irq/manage.c    |   10 ++++-----
 kernel/irq/settings.h  |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -45,7 +45,7 @@ unsigned long probe_irq_on(void)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
+		if (!desc->action && irq_settings_can_probe(desc)) {
 			/*
 			 * An old-style architecture might still have
 			 * the handle_bad_irq handler there:
@@ -74,7 +74,7 @@ unsigned long probe_irq_on(void)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
+		if (!desc->action && irq_settings_can_probe(desc)) {
 			desc->istate |= IRQS_AUTODETECT | IRQS_WAITING;
 			if (irq_startup(desc)) {
 				irq_compat_set_pending(desc);
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -700,7 +700,8 @@ __set_irq_handler(unsigned int irq, irq_
 	desc->name = name;
 
 	if (handle != handle_bad_irq && is_chained) {
-		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
+		irq_settings_set_noprobe(desc);
+		irq_settings_set_norequest(desc);
 		irq_startup(desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -103,7 +103,7 @@ void irq_set_thread_affinity(struct irq_
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 static inline bool irq_can_move_pcntxt(struct irq_desc *desc)
 {
-	return desc->status & IRQ_MOVE_PCNTXT;
+	return irq_settings_can_move_pcntxt(desc);
 }
 static inline bool irq_move_pending(struct irq_desc *desc)
 {
@@ -419,7 +419,7 @@ void __enable_irq(struct irq_desc *desc,
 		if (desc->istate & IRQS_SUSPENDED)
 			goto err_out;
 		/* Prevent probing on this irq: */
-		desc->status |= IRQ_NOPROBE;
+		irq_settings_set_noprobe(desc);
 		irq_enable(desc);
 		check_irq_resend(desc, irq);
 		/* fall-through */
@@ -532,7 +532,7 @@ int can_request_irq(unsigned int irq, un
 	if (!desc)
 		return 0;
 
-	if (desc->status & IRQ_NOREQUEST)
+	if (!irq_settings_can_request(desc))
 		return 0;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -923,7 +923,7 @@ __setup_irq(unsigned int irq, struct irq
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
 
-		if (!(desc->status & IRQ_NOAUTOEN))
+		if (irq_settings_can_autoenable(desc))
 			irq_startup(desc);
 		else
 			/* Undo nested disables: */
@@ -1218,7 +1218,7 @@ int request_threaded_irq(unsigned int ir
 	if (!desc)
 		return -EINVAL;
 
-	if (desc->status & IRQ_NOREQUEST)
+	if (!irq_settings_can_request(desc))
 		return -EINVAL;
 
 	if (!handler) {
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -6,6 +6,10 @@ enum {
 	_IRQ_DEFAULT_INIT_FLAGS	= IRQ_DEFAULT_INIT_FLAGS,
 	_IRQ_PER_CPU		= IRQ_PER_CPU,
 	_IRQ_LEVEL		= IRQ_LEVEL,
+	_IRQ_NOPROBE		= IRQ_NOPROBE,
+	_IRQ_NOREQUEST		= IRQ_NOREQUEST,
+	_IRQ_NOAUTOEN		= IRQ_NOAUTOEN,
+	_IRQ_MOVE_PCNTXT	= IRQ_MOVE_PCNTXT,
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
@@ -34,6 +38,12 @@ enum {
 #define IRQ_AFFINITY_SET	GOT_YOU_MORON
 #undef IRQ_LEVEL
 #define IRQ_LEVEL		GOT_YOU_MORON
+#undef IRQ_NOPROBE
+#define IRQ_NOPROBE		GOT_YOU_MORON
+#undef IRQ_NOREQUEST
+#define IRQ_NOREQUEST		GOT_YOU_MORON
+#undef IRQ_NOAUTOEN
+#define IRQ_NOATOEN		GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 
@@ -90,3 +100,43 @@ static inline void irq_settings_set_leve
 {
 	desc->status |= _IRQ_LEVEL;
 }
+
+static inline bool irq_settings_can_request(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOREQUEST);
+}
+
+static inline void irq_settings_clr_norequest(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_NOREQUEST;
+}
+
+static inline void irq_settings_set_norequest(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NOREQUEST;
+}
+
+static inline bool irq_settings_can_probe(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOPROBE);
+}
+
+static inline void irq_settings_clr_noprobe(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_NOPROBE;
+}
+
+static inline void irq_settings_set_noprobe(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NOPROBE;
+}
+
+static inline bool irq_settings_can_move_pcntxt(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_MOVE_PCNTXT;
+}
+
+static inline bool irq_settings_can_autoenable(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOAUTOEN);
+}


