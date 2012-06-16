Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2FPFCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2FPFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:06 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 04/12] irqdomain: Eliminate dedicated radix lookup functions
Date: Fri, 15 Jun 2012 23:01:29 -0600
Message-Id: <1339822897-15840-5-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to remove the slow revmap path, eliminate the public
radix revmap lookup functions.  This simplifies the code and makes the
slowpath removal patch a lot simpler.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/powerpc/sysdev/xics/icp-hv.c      |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c  |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c |    3 --
 include/linux/irqdomain.h              |    4 ---
 kernel/irq/irqdomain.c                 |   62 ++------------------------------
 5 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/arch/powerpc/sysdev/xics/icp-hv.c b/arch/powerpc/sysdev/xics/icp-hv.c
index 253dce9..14469cf 100644
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -111,7 +111,7 @@ static unsigned int icp_hv_get_irq(void)
 	if (vec == XICS_IRQ_SPURIOUS)
 		return NO_IRQ;
 
-	irq = irq_radix_revmap_lookup(xics_host, vec);
+	irq = irq_find_mapping(xics_host, vec);
 	if (likely(irq != NO_IRQ)) {
 		xics_push_cppr(vec);
 		return irq;
diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index 4c79b6f..48861d3 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -119,7 +119,7 @@ static unsigned int icp_native_get_irq(void)
 	if (vec == XICS_IRQ_SPURIOUS)
 		return NO_IRQ;
 
-	irq = irq_radix_revmap_lookup(xics_host, vec);
+	irq = irq_find_mapping(xics_host, vec);
 	if (likely(irq != NO_IRQ)) {
 		xics_push_cppr(vec);
 		return irq;
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index cd1d18d..9049d9f 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -329,9 +329,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
 
 	pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
 
-	/* Insert the interrupt mapping into the radix tree for fast lookup */
-	irq_radix_revmap_insert(xics_host, virq, hw);
-
 	/* They aren't all level sensitive but we just don't really know */
 	irq_set_status_flags(virq, IRQ_LEVEL);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 3425631..d8b88c5 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -169,10 +169,6 @@ static inline int irq_create_identity_mapping(struct irq_domain *host,
 	return irq_create_strict_mappings(host, hwirq, hwirq, 1);
 }
 
-extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
-				    irq_hw_number_t hwirq);
-extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
-					    irq_hw_number_t hwirq);
 extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1a8f3d2..79a7711 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -415,7 +415,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 				domain->revmap_data.linear.revmap[hwirq] = virq;
 			break;
 		case IRQ_DOMAIN_MAP_TREE:
-			irq_radix_revmap_insert(domain, virq, hwirq);
+			mutex_lock(&revmap_trees_mutex);
+			radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
+			mutex_unlock(&revmap_trees_mutex);
 			break;
 		}
 
@@ -688,64 +690,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
 /**
- * irq_radix_revmap_lookup() - Find a linux irq from a hw irq number.
- * @domain: domain owning this hardware interrupt
- * @hwirq: hardware irq number in that domain space
- *
- * This is a fast path, for use by irq controller code that uses radix tree
- * revmaps
- */
-unsigned int irq_radix_revmap_lookup(struct irq_domain *domain,
-				     irq_hw_number_t hwirq)
-{
-	struct irq_data *irq_data;
-
-	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_TREE))
-		return irq_find_mapping(domain, hwirq);
-
-	/*
-	 * Freeing an irq can delete nodes along the path to
-	 * do the lookup via call_rcu.
-	 */
-	rcu_read_lock();
-	irq_data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
-	rcu_read_unlock();
-
-	/*
-	 * If found in radix tree, then fine.
-	 * Else fallback to linear lookup - this should not happen in practice
-	 * as it means that we failed to insert the node in the radix tree.
-	 */
-	return irq_data ? irq_data->irq : irq_find_mapping(domain, hwirq);
-}
-EXPORT_SYMBOL_GPL(irq_radix_revmap_lookup);
-
-/**
- * irq_radix_revmap_insert() - Insert a hw irq to linux irq number mapping.
- * @domain: domain owning this hardware interrupt
- * @virq: linux irq number
- * @hwirq: hardware irq number in that domain space
- *
- * This is for use by irq controllers that use a radix tree reverse
- * mapping for fast lookup.
- */
-void irq_radix_revmap_insert(struct irq_domain *domain, unsigned int virq,
-			     irq_hw_number_t hwirq)
-{
-	struct irq_data *irq_data = irq_get_irq_data(virq);
-
-	if (WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_TREE))
-		return;
-
-	if (virq) {
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
-		mutex_unlock(&revmap_trees_mutex);
-	}
-}
-EXPORT_SYMBOL_GPL(irq_radix_revmap_insert);
-
-/**
  * irq_linear_revmap() - Find a linux irq from a hw irq number.
  * @domain: domain owning this hardware interrupt
  * @hwirq: hardware irq number in that domain space
-- 
1.7.9.5

