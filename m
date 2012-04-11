Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089Ab2DKXTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:19:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51033 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069Ab2DKXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:58 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>
Subject: [PATCH 3/3] irq_domain: Move irq_virq_count into NOMAP revmap
Date: Wed, 11 Apr 2012 17:18:46 -0600
Message-Id: <1334186326-22649-4-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
References: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the old global setting of irq_virq_count that is only
used by the NOMAP mapping and instead uses a revmap_data property so that
the maximum NOMAP allocation can be set per NOMAP irq_domain.

There is exactly one user of irq_virq_count in-tree right now: PS3.
Also, irq_virq_count is only useful for the NOMAP mapping.  So,
instead of having a single global irq_virq_count values, this change
drops it entirely and added a max_irq argument to irq_domain_add_nomap().
That makes it a property of an individual nomap irq domain instead of
a global system settting.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/platforms/cell/axon_msi.c       |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c |    2 +-
 arch/powerpc/platforms/powermac/smp.c        |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c       |    3 +-
 include/linux/irqdomain.h                    |    6 +++-
 kernel/irq/irqdomain.c                       |   27 +++++--------------------
 6 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index db360fc..d09f3e8 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -392,7 +392,7 @@ static int axon_msi_probe(struct platform_device *device)
 	}
 	memset(msic->fifo_virt, 0xff, MSIC_FIFO_SIZE_BYTES);
 
-	msic->irq_domain = irq_domain_add_nomap(dn, &msic_host_ops, msic);
+	msic->irq_domain = irq_domain_add_nomap(dn, 0, &msic_host_ops, msic);
 	if (!msic->irq_domain) {
 		printk(KERN_ERR "axon_msi: couldn't allocate irq_domain for %s\n",
 		       dn->full_name);
diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index e5c3a2c..f9a48af 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -239,7 +239,7 @@ void __init beatic_init_IRQ(void)
 	ppc_md.get_irq = beatic_get_irq;
 
 	/* Allocate an irq host */
-	beatic_host = irq_domain_add_nomap(NULL, &beatic_pic_host_ops, NULL);
+	beatic_host = irq_domain_add_nomap(NULL, 0, &beatic_pic_host_ops, NULL);
 	BUG_ON(beatic_host == NULL);
 	irq_set_default_host(beatic_host);
 }
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index a81e5a8..b4ddaa3 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -192,7 +192,7 @@ static int psurge_secondary_ipi_init(void)
 {
 	int rc = -ENOMEM;
 
-	psurge_host = irq_domain_add_nomap(NULL, &psurge_host_ops, NULL);
+	psurge_host = irq_domain_add_nomap(NULL, 0, &psurge_host_ops, NULL);
 
 	if (psurge_host)
 		psurge_secondary_virq = irq_create_direct_mapping(psurge_host);
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 2a4ff86..5f3b232 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -753,9 +753,8 @@ void __init ps3_init_IRQ(void)
 	unsigned cpu;
 	struct irq_domain *host;
 
-	host = irq_domain_add_nomap(NULL, &ps3_host_ops, NULL);
+	host = irq_domain_add_nomap(NULL, PS3_PLUG_MAX + 1, &ps3_host_ops, NULL);
 	irq_set_default_host(host);
-	irq_set_virq_count(PS3_PLUG_MAX + 1);
 
 	for_each_possible_cpu(cpu) {
 		struct ps3_private *pd = &per_cpu(ps3_private, cpu);
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 7a7af17..d0995bd 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -98,6 +98,9 @@ struct irq_domain {
 			unsigned int size;
 			unsigned int *revmap;
 		} linear;
+		struct {
+			unsigned int max_irq;
+		} nomap;
 		struct radix_tree_root tree;
 	} revmap_data;
 	const struct irq_domain_ops *ops;
@@ -120,6 +123,7 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
+					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
@@ -128,7 +132,6 @@ struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
-extern void irq_set_virq_count(unsigned int count);
 
 static inline struct irq_domain *irq_domain_add_legacy_isa(
 				struct device_node *of_node,
@@ -140,7 +143,6 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 }
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
-extern void irq_set_virq_count(unsigned int count);
 
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index df92a34..49d20d4 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -24,7 +24,6 @@ static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 
 static DEFINE_MUTEX(revmap_trees_mutex);
-static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_domain *irq_default_domain;
 
 /**
@@ -185,13 +184,16 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 }
 
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
+					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
 					IRQ_DOMAIN_MAP_NOMAP, ops, host_data);
-	if (domain)
+	if (domain) {
+		domain->revmap_data.nomap.max_irq = max_irq ? max_irq : ~0;
 		irq_domain_add(domain);
+	}
 	return domain;
 }
 
@@ -263,22 +265,6 @@ void irq_set_default_host(struct irq_domain *domain)
 	irq_default_domain = domain;
 }
 
-/**
- * irq_set_virq_count() - Set the maximum number of linux irqs
- * @count: number of linux irqs, capped with NR_IRQS
- *
- * This is mainly for use by platforms like iSeries who want to program
- * the virtual irq number in the controller to avoid the reverse mapping
- */
-void irq_set_virq_count(unsigned int count)
-{
-	pr_debug("irq: Trying to set virq count to %d\n", count);
-
-	BUG_ON(count < NUM_ISA_INTERRUPTS);
-	if (count < NR_IRQS)
-		irq_virq_count = count;
-}
-
 static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
@@ -322,13 +308,12 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 		pr_debug("irq: create_direct virq allocation failed\n");
 		return 0;
 	}
-	if (virq >= irq_virq_count) {
+	if (virq >= domain->revmap_data.nomap.max_irq) {
 		pr_err("ERROR: no free irqs available below %i maximum\n",
-			irq_virq_count);
+			domain->revmap_data.nomap.max_irq);
 		irq_free_desc(virq);
 		return 0;
 	}
-
 	pr_debug("irq: create_direct obtained virq %d\n", virq);
 
 	if (irq_setup_virq(domain, virq, virq)) {
-- 
1.7.9.1

