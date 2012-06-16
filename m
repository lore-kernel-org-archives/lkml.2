Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2FPFCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2FPFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:05 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 01/12] irqdomain: Split disassociating code into separate function
Date: Fri, 15 Jun 2012 23:01:26 -0600
Message-Id: <1339822897-15840-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the irq disassociation code out into a separate
function in preparation to extend irq_setup_virq to handle multiple
irqs and rename it for use by interrupt controller drivers.  The new
function will be used by irq_setup_virq() in its error path.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 kernel/irq/irqdomain.c |   75 ++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b1f774c..4161d2a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -333,6 +333,52 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
+static void irq_domain_disassociate_many(struct irq_domain *domain,
+					 unsigned int irq_base, int count)
+{
+	/*
+	 * disassociate in reverse order;
+	 * not strictly necessary, but nice for unwinding
+	 */
+	while (count--) {
+		int irq = irq_base + count;
+		struct irq_data *irq_data = irq_get_irq_data(irq);
+		irq_hw_number_t hwirq = irq_data->hwirq;
+
+		if (WARN_ON(!irq_data || irq_data->domain != domain))
+			continue;
+
+		irq_set_status_flags(irq, IRQ_NOREQUEST);
+
+		/* remove chip and handler */
+		irq_set_chip_and_handler(irq, NULL, NULL);
+
+		/* Make sure it's completed */
+		synchronize_irq(irq);
+
+		/* Tell the PIC about it */
+		if (domain->ops->unmap)
+			domain->ops->unmap(domain, irq);
+		smp_mb();
+
+		irq_data->domain = NULL;
+		irq_data->hwirq = 0;
+
+		/* Clear reverse map */
+		switch(domain->revmap_type) {
+		case IRQ_DOMAIN_MAP_LINEAR:
+			if (hwirq < domain->revmap_data.linear.size)
+				domain->revmap_data.linear.revmap[hwirq] = 0;
+			break;
+		case IRQ_DOMAIN_MAP_TREE:
+			mutex_lock(&revmap_trees_mutex);
+			radix_tree_delete(&domain->revmap_data.tree, hwirq);
+			mutex_unlock(&revmap_trees_mutex);
+			break;
+		}
+	}
+}
+
 static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
@@ -513,7 +559,6 @@ void irq_dispose_mapping(unsigned int virq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	struct irq_domain *domain;
-	irq_hw_number_t hwirq;
 
 	if (!virq || !irq_data)
 		return;
@@ -526,33 +571,7 @@ void irq_dispose_mapping(unsigned int virq)
 	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
 		return;
 
-	irq_set_status_flags(virq, IRQ_NOREQUEST);
-
-	/* remove chip and handler */
-	irq_set_chip_and_handler(virq, NULL, NULL);
-
-	/* Make sure it's completed */
-	synchronize_irq(virq);
-
-	/* Tell the PIC about it */
-	if (domain->ops->unmap)
-		domain->ops->unmap(domain, virq);
-	smp_mb();
-
-	/* Clear reverse map */
-	hwirq = irq_data->hwirq;
-	switch(domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_LINEAR:
-		if (hwirq < domain->revmap_data.linear.size)
-			domain->revmap_data.linear.revmap[hwirq] = 0;
-		break;
-	case IRQ_DOMAIN_MAP_TREE:
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_delete(&domain->revmap_data.tree, hwirq);
-		mutex_unlock(&revmap_trees_mutex);
-		break;
-	}
-
+	irq_domain_disassociate_many(domain, virq, 1);
 	irq_free_desc(virq);
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
-- 
1.7.9.5

