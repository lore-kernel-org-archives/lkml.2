Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0I3XRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:07 -0400
Received: from www.tglx.de ([62.245.132.106]:52739 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0I3XRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:03 -0400
Message-Id: <20100930221740.248958263@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:02 -0000
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
Subject: [patch 18/47] genirq: Use sane sparse allocator
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-use-sane-allocator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make irq_to_desc_alloc_node() a wrapper around the new allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |  133 ++++++---------------------------------------------
 1 file changed, 17 insertions(+), 116 deletions(-)

Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -85,15 +85,6 @@ static DECLARE_BITMAP(allocated_irqs, NR
 
 #ifdef CONFIG_SPARSE_IRQ
 
-static struct irq_desc irq_desc_init = {
-	.irq	    = -1,
-	.status	    = IRQ_DEFAULT_INIT_FLAGS,
-	.chip	    = &no_irq_chip,
-	.handle_irq = handle_bad_irq,
-	.depth      = 1,
-	.lock       = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-};
-
 void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
 	void *ptr;
@@ -111,32 +102,6 @@ void __ref init_kstat_irqs(struct irq_de
 	}
 }
 
-static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
-{
-	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
-
-	raw_spin_lock_init(&desc->lock);
-	desc->irq = irq;
-	desc->irq_data.irq = irq;
-	desc->irq_data.chip = desc->chip;
-#ifdef CONFIG_SMP
-	desc->node = node;
-	desc->irq_data.affinity = &desc->affinity;
-#endif
-	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_kstat_irqs(desc, node, nr_cpu_ids);
-	if (!desc->kstat_irqs) {
-		printk(KERN_ERR "can not alloc kstat_irqs\n");
-		BUG_ON(1);
-	}
-	if (!alloc_desc_masks(desc, node, false)) {
-		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
-		BUG_ON(1);
-	}
-	init_desc_masks(desc);
-	arch_init_chip_data(desc, node);
-}
-
 static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
 
 static void irq_insert_desc(unsigned int irq, struct irq_desc *desc)
@@ -178,7 +143,7 @@ static inline void free_masks(struct irq
 static struct irq_desc *alloc_desc(int irq, int node)
 {
 	struct irq_desc *desc;
-	gfp_t gfp = GFP_KERNEL;
+	gfp_t gfp = GFP_ATOMIC;
 
 	desc = kzalloc_node(sizeof(*desc), gfp, node);
 	if (!desc)
@@ -231,6 +196,8 @@ static int alloc_descs(unsigned int star
 		desc = alloc_desc(start + i, node);
 		if (!desc)
 			goto err;
+		/* temporary until I fixed x86 madness */
+		arch_init_chip_data(desc, node);
 		raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 		irq_insert_desc(start + i, desc);
 		raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
@@ -247,25 +214,19 @@ err:
 	return -ENOMEM;
 }
 
-static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
-	[0 ... NR_IRQS_LEGACY-1] = {
-		.irq	    = -1,
-		.status	    = IRQ_DEFAULT_INIT_FLAGS,
-		.chip	    = &no_irq_chip,
-		.handle_irq = handle_bad_irq,
-		.depth	    = 1,
-		.lock	    = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-	}
-};
+struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
+{
+	int res = irq_alloc_descs(irq, irq, 1, node);
 
-static unsigned int *kstat_irqs_legacy;
+	if (res == -EEXIST || res == irq)
+		return irq_to_desc(irq);
+	return NULL;
+}
 
 int __init early_irq_init(void)
 {
+	int i, node = first_online_node;
 	struct irq_desc *desc;
-	int legacy_count;
-	int node;
-	int i;
 
 	init_irq_default_affinity();
 
@@ -273,71 +234,14 @@ int __init early_irq_init(void)
 	arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
 
-	desc = irq_desc_legacy;
-	legacy_count = ARRAY_SIZE(irq_desc_legacy);
-	node = first_online_node;
-
-	/* allocate based on nr_cpu_ids */
-	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
-					  sizeof(int), GFP_NOWAIT, node);
-
-	for (i = 0; i < legacy_count; i++) {
-		desc[i].irq = i;
-		desc[i].irq_data.irq = i;
-		desc[i].irq_data.chip = desc[i].chip;
-#ifdef CONFIG_SMP
-		desc[i].node = node;
-		desc[i].irq_data.affinity = &desc[i].affinity;
-#endif
-		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
-		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		alloc_desc_masks(&desc[i], node, true);
-		init_desc_masks(&desc[i]);
-		irq_insert_desc(i, &desc[i]);
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		desc = alloc_desc(i, node);
+		set_bit(i, allocated_irqs);
+		irq_insert_desc(i, desc);
 	}
-
 	return arch_early_irq_init();
 }
 
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	struct irq_desc *desc;
-	unsigned long flags;
-
-	if (irq >= nr_irqs) {
-		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_desc_alloc\n",
-			irq, nr_irqs);
-		return NULL;
-	}
-
-	desc = irq_to_desc(irq);
-	if (desc)
-		return desc;
-
-	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
-
-	/* We have to check it to avoid races with another CPU */
-	desc = irq_to_desc(irq);
-	if (desc)
-		goto out_unlock;
-
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-
-	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
-	if (!desc) {
-		printk(KERN_ERR "can not alloc irq_desc\n");
-		BUG_ON(1);
-	}
-	init_one_irq_desc(irq, desc, node);
-
-	irq_insert_desc(irq, desc);
-
-out_unlock:
-	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
-
-	return desc;
-}
-
 #else /* !CONFIG_SPARSE_IRQ */
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
@@ -368,12 +272,9 @@ int __init early_irq_init(void)
 		desc[i].irq = i;
 		desc[i].irq_data.irq = i;
 		desc[i].irq_data.chip = desc[i].chip;
-#ifdef CONFIG_SMP
-		desc[i].irq_data.affinity = &desc[i].affinity;
-#endif
-		alloc_desc_masks(&desc[i], 0, true);
-		init_desc_masks(&desc[i]);
 		desc[i].kstat_irqs = kstat_irqs_all[i];
+		alloc_masks(desc + 1, GFP_KERNEL, first_online_node);
+		desc_smp_init(desc + i, first_online_node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 	}
 	return arch_early_irq_init();


