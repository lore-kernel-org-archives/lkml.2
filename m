Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2BPJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab2BPJJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:42 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 09/27] irq_domain: remove NO_IRQ from irq domain code
Date: Thu, 16 Feb 2012 02:09:10 -0700
Message-Id: <1329383368-12122-10-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zero always means no irq when using irq domains.  Get rid of the NO_IRQ
references.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Tested-by: Olof Johansson <olof@lixom.net>
---
 kernel/irq/irqdomain.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3fb4880..b1c4e21 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -108,7 +108,7 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 	case IRQ_DOMAIN_MAP_LINEAR:
 		rmap = (unsigned int *)(host + 1);
 		for (i = 0; i < revmap_arg; i++)
-			rmap[i] = NO_IRQ;
+			rmap[i] = 0;
 		host->revmap_data.linear.size = revmap_arg;
 		host->revmap_data.linear.revmap = rmap;
 		break;
@@ -218,9 +218,9 @@ unsigned int irq_create_direct_mapping(struct irq_domain *host)
 	WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
 
 	virq = irq_alloc_desc_from(1, 0);
-	if (virq == NO_IRQ) {
+	if (!virq) {
 		pr_debug("irq: create_direct virq allocation failed\n");
-		return NO_IRQ;
+		return 0;
 	}
 	if (virq >= irq_virq_count) {
 		pr_err("ERROR: no free irqs available below %i maximum\n",
@@ -233,7 +233,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *host)
 
 	if (irq_setup_virq(host, virq, virq)) {
 		irq_free_desc(virq);
-		return NO_IRQ;
+		return 0;
 	}
 
 	return virq;
@@ -263,13 +263,13 @@ unsigned int irq_create_mapping(struct irq_domain *host,
 		printk(KERN_WARNING "irq_create_mapping called for"
 		       " NULL host, hwirq=%lx\n", hwirq);
 		WARN_ON(1);
-		return NO_IRQ;
+		return 0;
 	}
 	pr_debug("irq: -> using host @%p\n", host);
 
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(host, hwirq);
-	if (virq != NO_IRQ) {
+	if (virq) {
 		pr_debug("irq: -> existing mapping on virq %d\n", virq);
 		return virq;
 	}
@@ -279,7 +279,7 @@ unsigned int irq_create_mapping(struct irq_domain *host,
 		/* Handle legacy */
 		virq = (unsigned int)hwirq;
 		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
-			return NO_IRQ;
+			return 0;
 		return virq;
 	} else {
 		/* Allocate a virtual interrupt number */
@@ -289,16 +289,16 @@ unsigned int irq_create_mapping(struct irq_domain *host,
 		virq = irq_alloc_desc_from(hint, 0);
 		if (!virq)
 			virq = irq_alloc_desc_from(1, 0);
-		if (virq == NO_IRQ) {
+		if (!virq) {
 			pr_debug("irq: -> virq allocation failed\n");
-			return NO_IRQ;
+			return 0;
 		}
 	}
 
 	if (irq_setup_virq(host, virq, hwirq)) {
 		if (host->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
 			irq_free_desc(virq);
-		return NO_IRQ;
+		return 0;
 	}
 
 	pr_debug("irq: irq %lu on host %s mapped to virtual irq %u\n",
@@ -323,7 +323,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	if (host == NULL) {
 		printk(KERN_WARNING "irq: no irq host found for %s !\n",
 		       controller->full_name);
-		return NO_IRQ;
+		return 0;
 	}
 
 	/* If host has no translation, then we assume interrupt line */
@@ -332,12 +332,12 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	else {
 		if (host->ops->xlate(host, controller, intspec, intsize,
 				     &hwirq, &type))
-			return NO_IRQ;
+			return 0;
 	}
 
 	/* Create mapping */
 	virq = irq_create_mapping(host, hwirq);
-	if (virq == NO_IRQ)
+	if (!virq)
 		return virq;
 
 	/* Set type if specified and different than the current one */
@@ -358,7 +358,7 @@ void irq_dispose_mapping(unsigned int virq)
 	struct irq_domain *host;
 	irq_hw_number_t hwirq;
 
-	if (virq == NO_IRQ || !irq_data)
+	if (!virq || !irq_data)
 		return;
 
 	host = irq_data->domain;
@@ -387,7 +387,7 @@ void irq_dispose_mapping(unsigned int virq)
 	switch(host->revmap_type) {
 	case IRQ_DOMAIN_MAP_LINEAR:
 		if (hwirq < host->revmap_data.linear.size)
-			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
+			host->revmap_data.linear.revmap[hwirq] = 0;
 		break;
 	case IRQ_DOMAIN_MAP_TREE:
 		mutex_lock(&revmap_trees_mutex);
@@ -422,7 +422,7 @@ unsigned int irq_find_mapping(struct irq_domain *host,
 	if (host == NULL)
 		host = irq_default_host;
 	if (host == NULL)
-		return NO_IRQ;
+		return 0;
 
 	/* legacy -> bail early */
 	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
@@ -440,7 +440,7 @@ unsigned int irq_find_mapping(struct irq_domain *host,
 		if (i >= irq_virq_count)
 			i = 1
 	} while(i != hint);
-	return NO_IRQ;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
@@ -493,7 +493,7 @@ void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
 	if (WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
 		return;
 
-	if (virq != NO_IRQ) {
+	if (virq) {
 		mutex_lock(&revmap_trees_mutex);
 		radix_tree_insert(&host->revmap_data.tree, hwirq, irq_data);
 		mutex_unlock(&revmap_trees_mutex);
@@ -527,7 +527,7 @@ unsigned int irq_linear_revmap(struct irq_domain *host,
 		return irq_find_mapping(host, hwirq);
 
 	/* Fill up revmap with slow path if no mapping found */
-	if (unlikely(revmap[hwirq] == NO_IRQ))
+	if (unlikely(!revmap[hwirq]))
 		revmap[hwirq] = irq_find_mapping(host, hwirq);
 
 	return revmap[hwirq];
-- 
1.7.9

