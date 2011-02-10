Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1BJXhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:31 -0500
Received: from www.tglx.de ([62.245.132.106]:44203 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab1BJXhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:21 -0500
Message-Id: <20110210223257.791629335@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 36/75] genirq: Move IRQ_AUTODETECT to internal state
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-autodetect.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of core

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    1 -
 kernel/irq/autoprobe.c |   29 ++++++++++++-----------------
 kernel/irq/internals.h |   15 +++++++++++++--
 kernel/irq/manage.c    |    3 ++-
 4 files changed, 27 insertions(+), 21 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -54,7 +54,6 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
 #define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
 #define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
-#define IRQ_AUTODETECT		0x00001000	/* IRQ is being autodetected */
 #define IRQ_WAITING		0x00002000	/* IRQ not yet seen - for autodetection */
 #define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
 #define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -32,7 +32,6 @@ unsigned long probe_irq_on(void)
 {
 	struct irq_desc *desc;
 	unsigned long mask = 0;
-	unsigned int status;
 	int i;
 
 	/*
@@ -76,7 +75,8 @@ unsigned long probe_irq_on(void)
 	for_each_irq_desc_reverse(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
-			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
+			desc->istate |= IRQS_AUTODETECT;
+			desc->status |= IRQ_WAITING;
 			if (irq_startup(desc))
 				desc->status |= IRQ_PENDING;
 		}
@@ -93,12 +93,11 @@ unsigned long probe_irq_on(void)
 	 */
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		status = desc->status;
 
-		if (status & IRQ_AUTODETECT) {
+		if (desc->istate & IRQS_AUTODETECT) {
 			/* It triggered already - consider it spurious. */
-			if (!(status & IRQ_WAITING)) {
-				desc->status = status & ~IRQ_AUTODETECT;
+			if (!(desc->status & IRQ_WAITING)) {
+				desc->istate &= ~IRQS_AUTODETECT;
 				irq_shutdown(desc);
 			} else
 				if (i < 32)
@@ -125,19 +124,17 @@ EXPORT_SYMBOL(probe_irq_on);
  */
 unsigned int probe_irq_mask(unsigned long val)
 {
-	unsigned int status, mask = 0;
+	unsigned int mask = 0;
 	struct irq_desc *desc;
 	int i;
 
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		status = desc->status;
-
-		if (status & IRQ_AUTODETECT) {
-			if (i < 16 && !(status & IRQ_WAITING))
+		if (desc->istate & IRQS_AUTODETECT) {
+			if (i < 16 && !(desc->status & IRQ_WAITING))
 				mask |= 1 << i;
 
-			desc->status = status & ~IRQ_AUTODETECT;
+			desc->istate &= ~IRQS_AUTODETECT;
 			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -169,19 +166,17 @@ int probe_irq_off(unsigned long val)
 {
 	int i, irq_found = 0, nr_of_irqs = 0;
 	struct irq_desc *desc;
-	unsigned int status;
 
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		status = desc->status;
 
-		if (status & IRQ_AUTODETECT) {
-			if (!(status & IRQ_WAITING)) {
+		if (desc->istate & IRQS_AUTODETECT) {
+			if (!(desc->status & IRQ_WAITING)) {
 				if (!nr_of_irqs)
 					irq_found = i;
 				nr_of_irqs++;
 			}
-			desc->status = status & ~IRQ_AUTODETECT;
+			desc->istate &= ~IRQS_AUTODETECT;
 			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -27,6 +27,15 @@ enum {
 	IRQTF_AFFINITY,
 };
 
+/*
+ * Bit masks for desc->state
+ *
+ * IRQS_AUTODETECT		- autodetection in progress
+ */
+enum {
+	IRQS_AUTODETECT		= 0x00000001,
+};
+
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
 
 /* Set default functions for irq_chip structures: */
@@ -93,6 +102,7 @@ static inline void chip_bus_sync_unlock(
 #include <linux/kallsyms.h>
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
+#define PS(f) if (desc->istate & f) printk("%14s set\n", #f)
 
 static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
@@ -112,7 +122,6 @@ static inline void print_irq_desc(unsign
 	P(IRQ_DISABLED);
 	P(IRQ_PENDING);
 	P(IRQ_REPLAY);
-	P(IRQ_AUTODETECT);
 	P(IRQ_WAITING);
 	P(IRQ_LEVEL);
 	P(IRQ_MASKED);
@@ -122,7 +131,9 @@ static inline void print_irq_desc(unsign
 	P(IRQ_NOPROBE);
 	P(IRQ_NOREQUEST);
 	P(IRQ_NOAUTOEN);
+
+	PS(IRQS_AUTODETECT);
 }
 
 #undef P
-
+#undef PS
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -903,8 +903,9 @@ __setup_irq(unsigned int irq, struct irq
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_ONESHOT |
+		desc->status &= ~(IRQ_WAITING | IRQ_ONESHOT |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
+		desc->istate &= ~IRQS_AUTODETECT;
 
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;


