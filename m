Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2ESGMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:12:39 -0400
Received: from linux-sh.org ([111.68.239.195]:60856 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab2ESGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:12:05 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/8] irqdomain: Support removal of IRQ domains.
Date: Sat, 19 May 2012 15:11:41 +0900
Message-Id: <1337407908-7421-2-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
In-Reply-To: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that IRQ domains are being used by modules it's necessary to support
removing them, too. This adds a new irq_domain_remove() routine for doing
the bulk of the heavy lifting. It's left as an exercise to the caller to
ensure all mappings have been appropriatey disposed of before attempting
to remove the domain.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/irqdomain.h |    4 ++-
 kernel/irq/irqdomain.c    |   61 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c65740d..a796dbf 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -141,10 +141,12 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
 				     host_data);
 }
+
+extern void irq_domain_remove(struct irq_domain *host);
+
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
 
-
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
 extern void irq_dispose_mapping(unsigned int virq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0e0ba5f..9cae0b2 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -56,6 +56,12 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 	return domain;
 }
 
+static void irq_domain_free(struct irq_domain *domain)
+{
+	of_node_put(domain->of_node);
+	kfree(domain);
+}
+
 static void irq_domain_add(struct irq_domain *domain)
 {
 	mutex_lock(&irq_domain_mutex);
@@ -65,6 +71,58 @@ static void irq_domain_add(struct irq_domain *domain)
 		 domain->revmap_type, domain);
 }
 
+/**
+ * irq_domain_remove() - Remove an irq domain.
+ * @domain: domain to remove
+ *
+ * This routine is used to remove an irq domain. The caller must ensure
+ * that all mappings within the domain have been disposed of prior to
+ * use, depending on the revmap type.
+ */
+void irq_domain_remove(struct irq_domain *domain)
+{
+	mutex_lock(&irq_domain_mutex);
+
+	switch (domain->revmap_type) {
+	case IRQ_DOMAIN_MAP_LEGACY:
+		/*
+		 * Legacy domains don't manage their own irq_desc
+		 * allocations, we expect the caller to handle irq_desc
+		 * freeing on their own.
+		 */
+		break;
+	case IRQ_DOMAIN_MAP_TREE:
+		/*
+		 * radix_tree_delete() takes care of destroying the root
+		 * node when all entries are removed. Shout if there are
+		 * any mappings left.
+		 */
+		WARN_ON(domain->revmap_data.tree.height);
+		break;
+	case IRQ_DOMAIN_MAP_LINEAR:
+		kfree(domain->revmap_data.linear.revmap);
+		domain->revmap_data.linear.size = 0;
+		break;
+	case IRQ_DOMAIN_MAP_NOMAP:
+		break;
+	}
+
+	list_del(&domain->link);
+
+	/*
+	 * If the going away domain is the default one, reset it.
+	 */
+	if (unlikely(irq_default_domain == domain))
+		irq_set_default_host(NULL);
+
+	mutex_unlock(&irq_domain_mutex);
+
+	pr_debug("irq: Removed domain of type %d @0x%p\n",
+		 domain->revmap_type, domain);
+
+	irq_domain_free(domain);
+}
+
 static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
 					     irq_hw_number_t hwirq)
 {
@@ -117,8 +175,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 
 		if (WARN_ON(!irq_data || irq_data->domain)) {
 			mutex_unlock(&irq_domain_mutex);
-			of_node_put(domain->of_node);
-			kfree(domain);
+			irq_domain_free(domain);
 			return NULL;
 		}
 	}
-- 
1.7.9.rc0.28.g0e1cf

