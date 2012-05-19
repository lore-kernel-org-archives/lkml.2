Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab2ESGN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:13:27 -0400
Received: from linux-sh.org ([111.68.239.195]:60864 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab2ESGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:12:05 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 8/8] irqdomain: Support insertion of existing IRQ allocations.
Date: Sat, 19 May 2012 15:11:48 +0900
Message-Id: <1337407908-7421-9-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
In-Reply-To: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms that already do their own irqdesc allocation
irq_domain_associate() can be used for inserting a virq in to the
specified domain. This in turn calls back in to the domain's ->map()
routine, fur further processing by the platform.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/irqdomain.h |    3 ++-
 kernel/irq/irqdomain.c    |   17 ++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index e32d2e7..6bbebfa 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -143,7 +143,8 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 }
 
 extern void irq_domain_remove(struct irq_domain *host);
-
+extern int irq_domain_associate(struct irq_domain *host, unsigned int virq,
+				irq_hw_number_t hwirq);
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
 extern void irq_dispose_mapping(unsigned int virq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index e8ac7df..4b5eb8e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -337,13 +337,19 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
-			    irq_hw_number_t hwirq)
+int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 
+	if (domain == NULL)
+		domain = irq_default_domain;
+	if (domain == NULL)
+		return -1;
+
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
+
 	if (domain->ops->map(domain, virq, hwirq)) {
 		pr_debug("-> mapping failed, freeing\n");
 		irq_data->domain = NULL;
@@ -355,6 +361,7 @@ static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_domain_associate);
 
 /**
  * irq_create_direct_mapping() - Allocate an irq for direct mapping
@@ -387,7 +394,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 	}
 	pr_debug("create_direct obtained virq %d\n", virq);
 
-	if (irq_setup_virq(domain, virq, virq)) {
+	if (irq_domain_associate(domain, virq, virq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -448,7 +455,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_setup_virq(domain, virq, hwirq)) {
+	if (irq_domain_associate(domain, virq, hwirq)) {
 		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
 			irq_free_desc(virq);
 		return 0;
@@ -490,7 +497,7 @@ unsigned int irq_create_identity_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_setup_virq(domain, virq, hwirq)) {
+	if (irq_domain_associate(domain, virq, hwirq)) {
 		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
 			irq_free_desc(virq);
 		return 0;
-- 
1.7.9.rc0.28.g0e1cf

