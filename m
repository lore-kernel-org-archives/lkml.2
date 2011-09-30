Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1I3T2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:28:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43828 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab1I3T2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:28:15 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] irq: support domains with non-zero hwirq base
Date: Fri, 30 Sep 2011 14:27:58 -0500
Message-Id: <1317410880-24828-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
References: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Interrupt controllers can have non-zero starting value for h/w irq numbers.
Adding support in irq_domain allows the domain hwirq numbering to match
the interrupt controllers' numbering.

As this makes looping over irqs for a domain more complicated, add loop
iterators to iterate over all hwirqs and irqs for a domain.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/irqdomain.h |   16 +++++++++++++++-
 kernel/irq/irqdomain.c    |   12 ++++++------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 3ad553e..c0026b6 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -47,6 +47,7 @@ struct irq_domain_ops {
  *            of the irq_domain is responsible for allocating the array of
  *            irq_desc structures.
  * @nr_irq: Number of irqs managed by the irq domain
+ * @hwirq_base: Starting number for hwirqs managed by the irq domain
  * @ops: pointer to irq_domain methods
  * @priv: private data pointer for use by owner.  Not touched by irq_domain
  *        core code.
@@ -57,6 +58,7 @@ struct irq_domain {
 	struct list_head list;
 	unsigned int irq_base;
 	unsigned int nr_irq;
+	unsigned int hwirq_base;
 	const struct irq_domain_ops *ops;
 	void *priv;
 	struct device_node *of_node;
@@ -72,9 +74,21 @@ struct irq_domain {
 static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 					     unsigned long hwirq)
 {
-	return d->ops->to_irq ? d->ops->to_irq(d, hwirq) : d->irq_base + hwirq;
+	if (d->ops->to_irq)
+		return d->ops->to_irq(d, hwirq);
+	if (hwirq < d->hwirq_base)
+		return NO_IRQ;
+	return d->irq_base + hwirq - d->hwirq_base;
 }
 
+#define irq_domain_for_each_hwirq(d, hw) \
+	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
+
+#define irq_domain_for_each_irq(d, hw, irq) \
+	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
+	     hw < d->hwirq_base + d->nr_irq; \
+	     hw++, irq = irq_domain_to_irq(d, hw))
+
 extern void irq_domain_add(struct irq_domain *domain);
 extern void irq_domain_del(struct irq_domain *domain);
 #endif /* CONFIG_IRQ_DOMAIN */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 84f4110..6b67057 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -20,15 +20,15 @@ static DEFINE_MUTEX(irq_domain_mutex);
 void irq_domain_add(struct irq_domain *domain)
 {
 	struct irq_data *d;
-	int hwirq;
+	int hwirq, irq;
 
 	/*
 	 * This assumes that the irq_domain owner has already allocated
 	 * the irq_descs.  This block will be removed when support for dynamic
 	 * allocation of irq_descs is added to irq_domain.
 	 */
-	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
-		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
+	irq_domain_for_each_irq(domain, hwirq, irq) {
+		d = irq_get_irq_data(irq);
 		if (d && d->domain) {
 			/* things are broken; just report, don't clean up */
 			WARN(1, "error: irq_desc already assigned to a domain");
@@ -50,15 +50,15 @@ void irq_domain_add(struct irq_domain *domain)
 void irq_domain_del(struct irq_domain *domain)
 {
 	struct irq_data *d;
-	int hwirq;
+	int hwirq, irq;
 
 	mutex_lock(&irq_domain_mutex);
 	list_del(&domain->list);
 	mutex_unlock(&irq_domain_mutex);
 
 	/* Clear the irq_domain assignments */
-	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
-		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
+	irq_domain_for_each_irq(domain, hwirq, irq) {
+		d = irq_get_irq_data(irq);
 		d->domain = NULL;
 	}
 }
-- 
1.7.5.4

