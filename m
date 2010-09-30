Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0I3XPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:16 -0400
Received: from www.tglx.de ([62.245.132.106]:52285 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0I3XPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:08 -0400
Message-Id: <20100930221738.775267698@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:14:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 03/47] genirq: Provide status modifier
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-provide-status-modifier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a irq_desc.status modifier function to cleanup the direct
access to irq_desc in arch and driver code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |   27 +++++++++++++++++++++++++--
 kernel/irq/chip.c   |   26 +++++++-------------------
 2 files changed, 32 insertions(+), 21 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -72,6 +72,10 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
 
+#define IRQF_MODIFY_MASK	\
+	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
+	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL)
+
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
 # define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
@@ -428,8 +432,27 @@ set_irq_chained_handler(unsigned int irq
 
 extern void set_irq_nested_thread(unsigned int irq, int nest);
 
-extern void set_irq_noprobe(unsigned int irq);
-extern void set_irq_probe(unsigned int irq);
+void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set);
+
+static inline void irq_set_status_flags(unsigned int irq, unsigned long set)
+{
+	irq_modify_status(irq, 0, set);
+}
+
+static inline void irq_clear_status_flags(unsigned int irq, unsigned long clr)
+{
+	irq_modify_status(irq, clr, 0);
+}
+
+static inline void set_irq_noprobe(unsigned int irq)
+{
+	irq_modify_status(irq, 0, IRQ_NOPROBE);
+}
+
+static inline void set_irq_probe(unsigned int irq)
+{
+	irq_modify_status(irq, IRQ_NOPROBE, 0);
+}
 
 /* Handle dynamic irq creation and destruction */
 extern unsigned int create_irq_nr(unsigned int irq_want, int node);
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -849,32 +849,20 @@ set_irq_chip_and_handler_name(unsigned i
 	__set_irq_handler(irq, handle, 0, name);
 }
 
-void set_irq_noprobe(unsigned int irq)
+void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
-	if (!desc) {
-		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
+	if (!desc)
 		return;
-	}
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->status |= IRQ_NOPROBE;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
-void set_irq_probe(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-
-	if (!desc) {
-		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
-		return;
-	}
+	/* Sanitize flags */
+	set &= IRQF_MODIFY_MASK;
+	clr &= IRQF_MODIFY_MASK;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->status &= ~IRQ_NOPROBE;
+	desc->status &= ~clr;
+	desc->status |= set;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }


