Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0I3XQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:16:52 -0400
Received: from www.tglx.de ([62.245.132.106]:52627 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab0I3XQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:16:39 -0400
Message-Id: <20100930221740.055804558@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:51 -0000
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
Subject: [patch 16/47] genirq: Implement sane enumeration
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-implement-sane-enumeration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the allocator bitmap to lookup active interrupts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqnr.h |    5 +++++
 kernel/irq/irqdesc.c  |   17 +++++++++++++++++
 2 files changed, 22 insertions(+)

Index: linux-2.6-tip/include/linux/irqnr.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqnr.h
+++ linux-2.6-tip/include/linux/irqnr.h
@@ -25,6 +25,7 @@
 
 extern int nr_irqs;
 extern struct irq_desc *irq_to_desc(unsigned int irq);
+unsigned int irq_get_next_irq(unsigned int offset);
 
 # define for_each_irq_desc(irq, desc)					\
 	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
@@ -47,6 +48,10 @@ extern struct irq_desc *irq_to_desc(unsi
 #define irq_node(irq)	0
 #endif
 
+# define for_each_active_irq(irq)			\
+	for (irq = irq_get_next_irq(0); irq < nr_irqs;	\
+	     irq = irq_get_next_irq(irq))
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -470,6 +470,23 @@ err:
 	return ret;
 }
 
+/**
+ * irq_get_next_irq - get next allocated irq number
+ * @offset:	where to start the search
+ *
+ * Returns next irq number after offset or nr_irqs if none is found.
+ */
+unsigned int irq_get_next_irq(unsigned int offset)
+{
+	unsigned long flags;
+	unsigned int res;
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+	res = find_next_bit_set(allocated_irqs, nr_irqs, offset);
+	raw_spin_unlock_irqsave(&sparse_irq_lock, flags);
+	return res;
+}
+
 /* Statistics access */
 void clear_kstat_irqs(struct irq_desc *desc)
 {


