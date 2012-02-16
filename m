Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2BPJM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:12:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57178 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2BPJJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:49 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 26/27] irq_domain: mostly eliminate slow-path revmap lookups
Date: Thu, 16 Feb 2012 02:09:27 -0700
Message-Id: <1329383368-12122-27-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current state of irq_domain, the reverse map is always updated
when new IRQs get mapped.  This means that the irq_find_mapping() function
can be simplified to always execute the revmap-specific lookup function.

This patch adds lookup functions for the revmaps that don't yet have one
and removes the slow path lookup from most of the code paths.  The only
place where the slow path legitimately remains is where the linear map
is used with a hwirq number larger than the revmap size.

v5: rewrite to not use a ->revmap() callback.  It is simpler, smaller,
    safer and faster to open code each of the revmap lookups directly into
    irq_find_mapping() via a switch statement.
v4: Fix build failure on incorrect variable reference.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/sysdev/xics/icp-hv.c      |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c  |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c |    3 -
 include/linux/irqdomain.h              |    4 -
 kernel/irq/irqdomain.c                 |  121 ++++++++++++--------------------
 5 files changed, 48 insertions(+), 84 deletions(-)

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
index ea5e204..1d7067d 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -330,9 +330,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
 
 	pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
 
-	/* Insert the interrupt mapping into the radix tree for fast lookup */
-	irq_radix_revmap_insert(xics_host, virq, hw);
-
 	/* They aren't all level sensitive but we just don't really know */
 	irq_set_status_flags(virq, IRQ_LEVEL);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 5245488..47af458 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -155,10 +155,6 @@ extern void irq_dispose_mapping(unsigned int virq);
 extern unsigned int irq_find_mapping(struct irq_domain *host,
 				     irq_hw_number_t hwirq);
 extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
-extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
-				    irq_hw_number_t hwirq);
-extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
-					    irq_hw_number_t hwirq);
 extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index db7adb2..e7d8e96 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -313,7 +313,8 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 		domain = irq_default_domain;
 
 	BUG_ON(domain == NULL);
-	WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
+	if (WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP))
+		return 0;
 
 	virq = irq_alloc_desc_from(1, 0);
 	if (!virq) {
@@ -389,6 +390,18 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
+	switch(domain->revmap_type) {
+	case IRQ_DOMAIN_MAP_LINEAR:
+		if (hwirq < domain->revmap_data.linear.size)
+			domain->revmap_data.linear.revmap[hwirq] = virq;
+		break;
+	case IRQ_DOMAIN_MAP_TREE:
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_insert(&domain->revmap_data.tree, hwirq,
+				  irq_get_irq_data(virq));
+		mutex_unlock(&revmap_trees_mutex);
+		break;
+	}
 	pr_debug("irq: irq %lu on domain %s mapped to virtual irq %u\n",
 		hwirq, domain->of_node ? domain->of_node->full_name : "null", virq);
 
@@ -497,7 +510,7 @@ EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 unsigned int irq_find_mapping(struct irq_domain *domain,
 			      irq_hw_number_t hwirq)
 {
-	unsigned int i;
+	struct irq_data *data;
 
 	/* Look for default domain if nececssary */
 	if (domain == NULL)
@@ -505,74 +518,43 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 	if (domain == NULL)
 		return 0;
 
-	/* legacy -> bail early */
-	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+	switch (domain->revmap_type) {
+	case IRQ_DOMAIN_MAP_LEGACY:
 		return irq_domain_legacy_revmap(domain, hwirq);
-
-	/* Slow path does a linear search of the map */
-	for (i = 0; i < irq_virq_count; i++)  {
-		struct irq_data *data = irq_get_irq_data(i);
+	case IRQ_DOMAIN_MAP_LINEAR:
+		return irq_linear_revmap(domain, hwirq);
+	case IRQ_DOMAIN_MAP_TREE:
+		rcu_read_lock();
+		data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
+		rcu_read_unlock();
+		if (data)
+			return data->irq;
+		break;
+	case IRQ_DOMAIN_MAP_NOMAP:
+		data = irq_get_irq_data(hwirq);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
-			return i;
+			return hwirq;
+		break;
 	}
+
+	WARN(1, "ERROR: irq revmap went horribly wrong. revmap_type=%i\n",
+		domain->revmap_type);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
-/**
- * irq_radix_revmap_lookup() - Find a linux irq from a hw irq number.
- * @domain: domain owning this hardware interrupt
- * @hwirq: hardware irq number in that domain space
- *
- * This is a fast path, for use by irq controller code that uses radix tree
- * revmaps
- */
-unsigned int irq_radix_revmap_lookup(struct irq_domain *domain,
-				     irq_hw_number_t hwirq)
+static unsigned int irq_find_mapping_slow(struct irq_domain *domain,
+					  irq_hw_number_t hwirq)
 {
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
+	unsigned int i;
 
-	if (virq) {
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
-		mutex_unlock(&revmap_trees_mutex);
+	/* Slow path does a linear search of the map */
+	for (i = 0; i < irq_virq_count; i++)  {
+		struct irq_data *data = irq_get_irq_data(i);
+		if (data && (data->domain == domain) && (data->hwirq == hwirq))
+			return i;
 	}
+	return 0;
 }
 
 /**
@@ -581,31 +563,20 @@ void irq_radix_revmap_insert(struct irq_domain *domain, unsigned int virq,
  * @hwirq: hardware irq number in that domain space
  *
  * This is a fast path, for use by irq controller code that uses linear
- * revmaps. It does fallback to the slow path if the revmap doesn't exist
- * yet and will create the revmap entry with appropriate locking
+ * revmaps. It does fallback to the slow path if the hwirq number is outside
+ * the range of the hwirq numbers.
  */
 unsigned int irq_linear_revmap(struct irq_domain *domain,
 			       irq_hw_number_t hwirq)
 {
-	unsigned int *revmap;
-
 	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
 		return irq_find_mapping(domain, hwirq);
 
 	/* Check revmap bounds */
 	if (unlikely(hwirq >= domain->revmap_data.linear.size))
-		return irq_find_mapping(domain, hwirq);
-
-	/* Check if revmap was allocated */
-	revmap = domain->revmap_data.linear.revmap;
-	if (unlikely(revmap == NULL))
-		return irq_find_mapping(domain, hwirq);
-
-	/* Fill up revmap with slow path if no mapping found */
-	if (unlikely(!revmap[hwirq]))
-		revmap[hwirq] = irq_find_mapping(domain, hwirq);
+		return irq_find_mapping_slow(domain, hwirq);
 
-	return revmap[hwirq];
+	return domain->revmap_data.linear.revmap[hwirq];
 }
 
 #ifdef CONFIG_VIRQ_DEBUG
-- 
1.7.9

