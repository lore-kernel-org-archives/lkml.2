Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102Ab2DKXTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:19:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40940 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab2DKXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:58 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 1/3] irq_domain: remove "hint" when allocating irq numbers
Date: Wed, 11 Apr 2012 17:18:44 -0600
Message-Id: <1334186326-22649-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
References: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'hint' used to try and line up irq numbers with hw irq numbers is
rather a hack and not very useful.  It also had some value when irq
reverse mapping was lazy, and not done right at map time.  However, the
lazy mapping is to be removed, so keeping around 'hint' isn't helpful
anymore.  This patch removes it.

v2: Rebase onto v3.4-rc2

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Cc: Olof Johansson <olof@lixom.net>
---
 kernel/irq/irqdomain.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index eb05e40..041710d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -4,6 +4,7 @@
 #include <linux/irq.h>
 #include <linux/irqdesc.h>
 #include <linux/irqdomain.h>
+#include <linux/irqnr.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -350,7 +351,6 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
-	unsigned int hint;
 	int virq;
 
 	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
@@ -378,14 +378,9 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return irq_domain_legacy_revmap(domain, hwirq);
 
 	/* Allocate a virtual interrupt number */
-	hint = hwirq % irq_virq_count;
-	if (hint == 0)
-		hint++;
-	virq = irq_alloc_desc_from(hint, 0);
-	if (virq <= 0)
-		virq = irq_alloc_desc_from(1, 0);
+	virq = irq_alloc_desc_from(1, 0);
 	if (virq <= 0) {
-		pr_debug("irq: -> virq allocation failed\n");
+		pr_debug("irq: irq_desc allocation failed\n");
 		return 0;
 	}
 
@@ -516,7 +511,7 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 			      irq_hw_number_t hwirq)
 {
 	unsigned int i;
-	unsigned int hint = hwirq % irq_virq_count;
+	struct irq_desc *desc;
 
 	/* Look for default domain if nececssary */
 	if (domain == NULL)
@@ -529,17 +524,11 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return irq_domain_legacy_revmap(domain, hwirq);
 
 	/* Slow path does a linear search of the map */
-	if (hint == 0)
-		hint = 1;
-	i = hint;
-	do {
+	for_each_irq_desc(i, desc)  {
 		struct irq_data *data = irq_get_irq_data(i);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
 			return i;
-		i++;
-		if (i >= irq_virq_count)
-			i = 1;
-	} while(i != hint);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
-- 
1.7.9.1

