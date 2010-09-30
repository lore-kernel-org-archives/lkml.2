Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab0I3XUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:20:05 -0400
Received: from www.tglx.de ([62.245.132.106]:43570 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab0I3XSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:39 -0400
Message-Id: <20100930221742.819254299@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:18:21 -0000
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
Subject: [patch 44/47] sh: Sanitize sparse irq
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=sh-sanitize-sparse-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch over to the new allocator functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sh/kernel/cpu/irq/ipr.c |    6 +++---
 drivers/sh/intc.c            |   37 ++++++++++++++++---------------------
 2 files changed, 19 insertions(+), 24 deletions(-)

Index: linux-2.6-tip/arch/sh/kernel/cpu/irq/ipr.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/kernel/cpu/irq/ipr.c
+++ linux-2.6-tip/arch/sh/kernel/cpu/irq/ipr.c
@@ -62,13 +62,13 @@ void register_ipr_controller(struct ipr_
 
 	for (i = 0; i < desc->nr_irqs; i++) {
 		struct ipr_data *p = desc->ipr_data + i;
-		struct irq_desc *irq_desc;
+		int res;
 
 		BUG_ON(p->ipr_idx >= desc->nr_offsets);
 		BUG_ON(!desc->ipr_offsets[p->ipr_idx]);
 
-		irq_desc = irq_to_desc_alloc_node(p->irq, numa_node_id());
-		if (unlikely(!irq_desc)) {
+		res = irq_alloc_desc_at(p->irq, numa_node_id());
+		if (unlikely(res != p->irq && res != -EEXIST))
 			printk(KERN_INFO "can not get irq_desc for %d\n",
 			       p->irq);
 			continue;
Index: linux-2.6-tip/drivers/sh/intc.c
===================================================================
--- linux-2.6-tip.orig/drivers/sh/intc.c
+++ linux-2.6-tip/drivers/sh/intc.c
@@ -1071,13 +1071,13 @@ int __init register_intc_controller(stru
 	for (i = 0; i < hw->nr_vectors; i++) {
 		struct intc_vect *vect = hw->vectors + i;
 		unsigned int irq = evt2irq(vect->vect);
-		struct irq_desc *irq_desc;
+		int res;
 
 		if (!vect->enum_id)
 			continue;
 
-		irq_desc = irq_to_desc_alloc_node(irq, numa_node_id());
-		if (unlikely(!irq_desc)) {
+		res = irq_alloc_desc_at(irq, numa_node_id());
+		if (res != irq && res != -EEXIST) {
 			pr_err("can't get irq_desc for %d\n", irq);
 			continue;
 		}
@@ -1096,8 +1096,8 @@ int __init register_intc_controller(stru
 			 * IRQ support, each vector still needs to have
 			 * its own backing irq_desc.
 			 */
-			irq_desc = irq_to_desc_alloc_node(irq2, numa_node_id());
-			if (unlikely(!irq_desc)) {
+			res = irq_alloc_desc_at(irq2, numa_node_id());
+			if (res != irq2 && res != -EEXIST) {
 				pr_err("can't get irq_desc for %d\n", irq2);
 				continue;
 			}
@@ -1301,7 +1301,6 @@ unsigned int create_irq_nr(unsigned int 
 {
 	unsigned int irq = 0, new;
 	unsigned long flags;
-	struct irq_desc *desc;
 
 	spin_lock_irqsave(&vector_lock, flags);
 
@@ -1319,26 +1318,22 @@ unsigned int create_irq_nr(unsigned int 
 		__set_bit(new, intc_irq_map);
 	}
 
-	desc = irq_to_desc_alloc_node(new, node);
-	if (unlikely(!desc)) {
+	spin_unlock_irqrestore(&vector_lock, flags);
+
+	irq = irq_alloc_desc_at(new, node);
+	if (unlikely(irq != new)) {
 		pr_err("can't get irq_desc for %d\n", new);
-		goto out_unlock;
+		return 0;
 	}
 
-	desc = move_irq_desc(desc, node);
-	irq = new;
-
-out_unlock:
-	spin_unlock_irqrestore(&vector_lock, flags);
-
-	if (irq > 0) {
-		dynamic_irq_init(irq);
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID); /* Enable IRQ on ARM systems */
+	set_irq_flags(irq, IRQF_VALID); /* Enable IRQ on ARM systems */
 #endif
-	}
+	return 0;
 
-	return irq;
+out_unlock:
+	spin_unlock_irqrestore(&vector_lock, flags);
+	return 0;
 }
 
 int create_irq(void)
@@ -1357,7 +1352,7 @@ void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
 
-	dynamic_irq_cleanup(irq);
+	irq_free_desc(irq);
 
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_bit(irq, intc_irq_map);


