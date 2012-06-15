Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2FOSNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:13:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65479 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab2FOSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:13:44 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] irqdomain: Simple NUMA awareness.
Date: Fri, 15 Jun 2012 12:13:30 -0600
Message-Id: <1339784011-7604-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339784011-7604-1-git-send-email-grant.likely@secretlab.ca>
References: <1339784011-7604-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

While common irqdesc allocation is node aware, the irqdomain code is not.

Presently we observe a number of regressions/inconsistencies on
NUMA-capable platforms:

- Platforms using irqdomains with legacy mappings, where the
  irq_descs are allocated node-local and the irqdomain data
  structure is not.

- Drivers implementing irqdomains will lose node locality
  regardless of the underlying struct device's node id.

This plugs in NUMA node id proliferation across the various allocation
callsites by way of_node_to_nid() node lookup. While of_node_to_nid()
does the right thing for OF-capable platforms it doesn't presently handle
the non-DT case. This is trivially dealt with by simply wraping in to
numa_node_id() unconditionally.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 include/linux/of.h     |   15 ++++++++++-----
 kernel/irq/irqdomain.c |   13 ++++++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 1012377..76930ee 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -21,6 +21,7 @@
 #include <linux/kref.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spinlock.h>
+#include <linux/topology.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>
@@ -158,11 +159,6 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 
 #define OF_BAD_ADDR	((u64)-1)
 
-#ifndef of_node_to_nid
-static inline int of_node_to_nid(struct device_node *np) { return -1; }
-#define of_node_to_nid of_node_to_nid
-#endif
-
 static inline const char* of_node_full_name(struct device_node *np)
 {
 	return np ? np->full_name : "<no-node>";
@@ -412,6 +408,15 @@ static inline int of_machine_is_compatible(const char *compat)
 	while (0)
 #endif /* CONFIG_OF */
 
+#ifndef of_node_to_nid
+static inline int of_node_to_nid(struct device_node *np)
+{
+	return numa_node_id();
+}
+
+#define of_node_to_nid of_node_to_nid
+#endif
+
 /**
  * of_property_read_bool - Findfrom a property
  * @np:		device node from which the property value is to be read.
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 38c5eb8..79ae0eb 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/topology.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
@@ -45,7 +46,8 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 {
 	struct irq_domain *domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	domain = kzalloc_node(sizeof(*domain), GFP_KERNEL,
+			      of_node_to_nid(of_node));
 	if (WARN_ON(!domain))
 		return NULL;
 
@@ -229,7 +231,8 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 	struct irq_domain *domain;
 	unsigned int *revmap;
 
-	revmap = kzalloc(sizeof(*revmap) * size, GFP_KERNEL);
+	revmap = kzalloc_node(sizeof(*revmap) * size, GFP_KERNEL,
+			      of_node_to_nid(of_node));
 	if (WARN_ON(!revmap))
 		return NULL;
 
@@ -367,7 +370,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 	BUG_ON(domain == NULL);
 	WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
 
-	virq = irq_alloc_desc_from(1, 0);
+	virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
 	if (!virq) {
 		pr_debug("create_direct virq allocation failed\n");
 		return 0;
@@ -433,9 +436,9 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	hint = hwirq % nr_irqs;
 	if (hint == 0)
 		hint++;
-	virq = irq_alloc_desc_from(hint, 0);
+	virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
 	if (virq <= 0)
-		virq = irq_alloc_desc_from(1, 0);
+		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
-- 
1.7.9.5

