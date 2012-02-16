Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2BPJMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:12:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2BPJJt (ORCPT
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
Subject: [PATCH v5 27/27] irq_domain: For NOMAP revmap, allow users to specify the largest usable virq
Date: Thu, 16 Feb 2012 02:09:28 -0700
Message-Id: <1329383368-12122-28-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the old global setting of irq_virq_count that is only
used by the NOMAP mapping and instead uses a revmap_data property so that
the maximum NOMAP allocation can be set per NOMAP irq_domain.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/platforms/cell/axon_msi.c       |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c |    2 +-
 arch/powerpc/platforms/iseries/irq.c         |    8 +------
 arch/powerpc/platforms/powermac/smp.c        |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c       |    3 +-
 include/linux/irqdomain.h                    |    7 ++---
 kernel/irq/irqdomain.c                       |   29 ++++++-------------------
 7 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index db360fc..369df06 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -392,7 +392,7 @@ static int axon_msi_probe(struct platform_device *device)
 	}
 	memset(msic->fifo_virt, 0xff, MSIC_FIFO_SIZE_BYTES);
 
-	msic->irq_domain = irq_domain_add_nomap(dn, &msic_host_ops, msic);
+	msic->irq_domain = irq_domain_add_nomap(dn, &msic_host_ops, msic, ~0);
 	if (!msic->irq_domain) {
 		printk(KERN_ERR "axon_msi: couldn't allocate irq_domain for %s\n",
 		       dn->full_name);
diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index e5c3a2c..4315349 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -239,7 +239,7 @@ void __init beatic_init_IRQ(void)
 	ppc_md.get_irq = beatic_get_irq;
 
 	/* Allocate an irq host */
-	beatic_host = irq_domain_add_nomap(NULL, &beatic_pic_host_ops, NULL);
+	beatic_host = irq_domain_add_nomap(NULL, &beatic_pic_host_ops, NULL, ~0);
 	BUG_ON(beatic_host == NULL);
 	irq_set_default_host(beatic_host);
 }
diff --git a/arch/powerpc/platforms/iseries/irq.c b/arch/powerpc/platforms/iseries/irq.c
index 05ce516..db48abe 100644
--- a/arch/powerpc/platforms/iseries/irq.c
+++ b/arch/powerpc/platforms/iseries/irq.c
@@ -371,16 +371,10 @@ void __init iSeries_init_IRQ(void)
 	struct irq_domain *host;
 	int ret;
 
-	/*
-	 * The Hypervisor only allows us up to 256 interrupt
-	 * sources (the irq number is passed in a u8).
-	 */
-	irq_set_virq_count(256);
-
 	/* Create irq host. No need for a revmap since HV will give us
 	 * back our virtual irq number
 	 */
-	host = irq_domain_add_nomap(NULL, &iseries_irq_domain_ops, NULL);
+	host = irq_domain_add_nomap(NULL, &iseries_irq_domain_ops, NULL, 256);
 	BUG_ON(host == NULL);
 	irq_set_default_host(host);
 
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index a81e5a8..40f12af 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -192,7 +192,7 @@ static int psurge_secondary_ipi_init(void)
 {
 	int rc = -ENOMEM;
 
-	psurge_host = irq_domain_add_nomap(NULL, &psurge_host_ops, NULL);
+	psurge_host = irq_domain_add_nomap(NULL, &psurge_host_ops, NULL, ~0);
 
 	if (psurge_host)
 		psurge_secondary_virq = irq_create_direct_mapping(psurge_host);
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 2a4ff86..0700a98 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -753,9 +753,8 @@ void __init ps3_init_IRQ(void)
 	unsigned cpu;
 	struct irq_domain *host;
 
-	host = irq_domain_add_nomap(NULL, &ps3_host_ops, NULL);
+	host = irq_domain_add_nomap(NULL, &ps3_host_ops, NULL, PS3_PLUG_MAX + 1);
 	irq_set_default_host(host);
-	irq_set_virq_count(PS3_PLUG_MAX + 1);
 
 	for_each_possible_cpu(cpu) {
 		struct ps3_private *pd = &per_cpu(ps3_private, cpu);
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 47af458..80bb917 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -105,6 +105,7 @@ struct irq_domain {
 			unsigned int *revmap;
 		} linear;
 		struct radix_tree_root tree;
+		unsigned int nomap_max_virq;
 	} revmap_data;
 	const struct irq_domain_ops *ops;
 	void *host_data;
@@ -126,15 +127,14 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
-					 const struct irq_domain_ops *ops,
-					 void *host_data);
+					const struct irq_domain_ops *ops,
+					void *host_data, unsigned int max_virq);
 struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
 
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
-extern void irq_set_virq_count(unsigned int count);
 
 static inline struct irq_domain *irq_domain_add_legacy_isa(
 				struct device_node *of_node,
@@ -146,7 +146,6 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 }
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
-extern void irq_set_virq_count(unsigned int count);
 
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index e7d8e96..e820b53 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -23,7 +23,6 @@ static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 
 static DEFINE_MUTEX(revmap_trees_mutex);
-static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_domain *irq_default_domain;
 
 /**
@@ -185,12 +184,14 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
-					 void *host_data)
+					 void *host_data, unsigned int max_virq)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
 					IRQ_DOMAIN_MAP_NOMAP, ops, host_data);
-	if (domain)
+	if (domain) {
+		domain->revmap_data.nomap_max_virq = max_virq;
 		irq_domain_add(domain);
+	}
 	return domain;
 }
 
@@ -262,22 +263,6 @@ void irq_set_default_host(struct irq_domain *domain)
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
@@ -321,9 +306,9 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 		pr_debug("irq: create_direct virq allocation failed\n");
 		return 0;
 	}
-	if (virq >= irq_virq_count) {
+	if (virq > domain->revmap_data.nomap_max_virq) {
 		pr_err("ERROR: no free irqs available below %i maximum\n",
-			irq_virq_count);
+			domain->revmap_data.nomap_max_virq);
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -549,7 +534,7 @@ static unsigned int irq_find_mapping_slow(struct irq_domain *domain,
 	unsigned int i;
 
 	/* Slow path does a linear search of the map */
-	for (i = 0; i < irq_virq_count; i++)  {
+	for (i = 0; i < nr_irqs; i++)  {
 		struct irq_data *data = irq_get_irq_data(i);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
 			return i;
-- 
1.7.9

