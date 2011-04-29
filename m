Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1D2HfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:35:14 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:51204 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1D2HfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:35:13 -0400
Subject: [PATCH] dt/irq: add of_irq_domain_add_simple() helper
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 29 Apr 2011 01:35:09 -0600
Message-ID: <20110429073324.17840.37136.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_irq_domain_add_simple() is an easy way to generate an irq translation
domain for simple irq controllers.  It assumes a flat 1:1 mapping from
hardware irq number to an offset of the first linux irq number assigned
to the controller

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Following on from the irq_domain patch series I posted earlier, here is a simple
method for registering a 1:1 translation.

g.

 drivers/of/irq.c       |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_irq.h |    2 ++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 6da0964..641590c 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
 #ifndef NO_IRQ
@@ -147,6 +148,49 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
+/*
+ * A simple irq domain implementation that 1:1 translates hwirqs to an offset
+ * from the irq_start value
+ */
+struct of_irq_domain_simple {
+	struct of_irq_domain domain;
+	int irq_start;
+	int irq_size;
+};
+
+static unsigned int of_irq_domain_simple_map(struct of_irq_domain *domain,
+					     struct device_node *controller,
+					     const u32 *intspec, u32 intsize)
+{
+	struct of_irq_domain_simple *ds;
+
+	ds = container_of(domain, struct of_irq_domain_simple, domain);
+	if (intspec[0] >= ds->irq_size)
+		return NO_IRQ;
+	return ds->irq_start + intspec[0];
+}
+
+/**
+ * of_irq_domain_create_simple() - Set up a 'simple' translation range
+ */
+void of_irq_domain_add_simple(struct device_node *controller,
+			      int irq_start, int irq_size)
+{
+	struct of_irq_domain_simple *sd;
+
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd) {
+		WARN_ON(1);
+		return;
+	}
+
+	sd->irq_start = irq_start;
+	sd->irq_size = irq_size;
+	sd->domain.controller = of_node_get(controller);
+	sd->domain.map = of_irq_domain_simple_map;
+	of_irq_domain_add(&sd->domain);
+}
+
 /**
  * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
  * @device: Device node of the device whose interrupt is to be mapped
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 511dbc3..8e49a0e 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -63,6 +63,8 @@ struct of_irq_domain {
 extern void of_irq_domain_add(struct of_irq_domain *domain);
 extern void of_irq_set_default_domain(struct of_irq_domain *host);
 extern struct of_irq_domain *of_irq_domain_find(struct device_node *controller);
+extern void of_irq_domain_add_simple(struct device_node *controller,
+				     int irq_start, int irq_size);
 
 /*
  * Workarounds only applied to 32bit powermac machines

