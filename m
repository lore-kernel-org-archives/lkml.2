Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2FPFCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2FPFCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:21 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 06/12] irqdomain: eliminate slow-path revmap lookups
Date: Fri, 15 Jun 2012 23:01:31 -0600
Message-Id: <1339822897-15840-7-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current state of irq_domain, the reverse map is always updated
when new IRQs get mapped.  This means that the irq_find_mapping() function
can be simplified to execute the revmap lookup functions unconditionally

This patch adds lookup functions for the revmaps that don't yet have one
and removes the slow path lookup code path.

v8: Broke out unrelated changes into separate patches.  Rebased on Paul's irq
    association patches.
v7: Rebased to irqdomain/next for v3.4 and applied before the removal of 'hint'
v6: Remove the slow path entirely.  The only place where the slow path
    could get called is for a linear mapping if the hwirq number is larger
    than the linear revmap size.  There shouldn't be any interrupt
    controllers that do that.
v5: rewrite to not use a ->revmap() callback.  It is simpler, smaller,
    safer and faster to open code each of the revmap lookups directly into
    irq_find_mapping() via a switch statement.
v4: Fix build failure on incorrect variable reference.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 kernel/irq/irqdomain.c |   67 +++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0483e27..00c383b 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -652,16 +652,11 @@ EXPORT_SYMBOL_GPL(irq_dispose_mapping);
  * irq_find_mapping() - Find a linux irq from an hw irq number.
  * @domain: domain owning this hardware interrupt
  * @hwirq: hardware irq number in that domain space
- *
- * This is a slow path, for use by generic code. It's expected that an
- * irq controller implementation directly calls the appropriate low level
- * mapping function.
  */
 unsigned int irq_find_mapping(struct irq_domain *domain,
 			      irq_hw_number_t hwirq)
 {
-	unsigned int i;
-	unsigned int hint = hwirq % nr_irqs;
+	struct irq_data *data;
 
 	/* Look for default domain if nececssary */
 	if (domain == NULL)
@@ -669,22 +664,27 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 	if (domain == NULL)
 		return 0;
 
-	/* legacy -> bail early */
-	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+	switch (domain->revmap_type) {
+	case IRQ_DOMAIN_MAP_LEGACY:
 		return irq_domain_legacy_revmap(domain, hwirq);
-
-	/* Slow path does a linear search of the map */
-	if (hint == 0)
-		hint = 1;
-	i = hint;
-	do {
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
-		i++;
-		if (i >= nr_irqs)
-			i = 1;
-	} while(i != hint);
+			return hwirq;
+		break;
+	}
+
+	WARN(1, "ERROR: irq revmap went horribly wrong. revmap_type=%i\n",
+		domain->revmap_type);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
@@ -694,32 +694,19 @@ EXPORT_SYMBOL_GPL(irq_find_mapping);
  * @domain: domain owning this hardware interrupt
  * @hwirq: hardware irq number in that domain space
  *
- * This is a fast path, for use by irq controller code that uses linear
- * revmaps. It does fallback to the slow path if the revmap doesn't exist
- * yet and will create the revmap entry with appropriate locking
+ * This is a fast path that can be called directly by irq controller code to
+ * save a handful of instructions.
  */
 unsigned int irq_linear_revmap(struct irq_domain *domain,
 			       irq_hw_number_t hwirq)
 {
-	unsigned int *revmap;
+	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
 
-	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
-		return irq_find_mapping(domain, hwirq);
-
-	/* Check revmap bounds */
-	if (unlikely(hwirq >= domain->revmap_data.linear.size))
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
+	/* Check revmap bounds; complain if exceeded */
+	if (WARN_ON(hwirq >= domain->revmap_data.linear.size))
+		return 0;
 
-	return revmap[hwirq];
+	return domain->revmap_data.linear.revmap[hwirq];
 }
 EXPORT_SYMBOL_GPL(irq_linear_revmap);
 
-- 
1.7.9.5

