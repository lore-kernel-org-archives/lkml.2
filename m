Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2BPJLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2BPJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:48 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 25/27] irq_domain: remove "hint" when allocating irq numbers
Date: Thu, 16 Feb 2012 02:09:26 -0700
Message-Id: <1329383368-12122-26-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'hint' used to try and line up irq numbers with hw irq numbers is
rather a hack and not very useful.  Now that /proc/interrupts also outputs
the hwirq number, it is even less useful to keep around the 'hint' heuristic.

This patch removes it.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Tested-by: Olof Johansson <olof@lixom.net>
---
 kernel/irq/irqdomain.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 2d3dfff..db7adb2 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -350,7 +350,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
-	unsigned int virq, hint;
+	unsigned int virq;
 
 	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
 
@@ -377,12 +377,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return irq_domain_legacy_revmap(domain, hwirq);
 
 	/* Allocate a virtual interrupt number */
-	hint = hwirq % irq_virq_count;
-	if (hint == 0)
-		hint++;
-	virq = irq_alloc_desc_from(hint, 0);
-	if (!virq)
-		virq = irq_alloc_desc_from(1, 0);
+	virq = irq_alloc_desc_from(1, 0);
 	if (!virq) {
 		pr_debug("irq: -> virq allocation failed\n");
 		return 0;
@@ -503,7 +498,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 			      irq_hw_number_t hwirq)
 {
 	unsigned int i;
-	unsigned int hint = hwirq % irq_virq_count;
 
 	/* Look for default domain if nececssary */
 	if (domain == NULL)
@@ -516,17 +510,11 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return irq_domain_legacy_revmap(domain, hwirq);
 
 	/* Slow path does a linear search of the map */
-	if (hint == 0)
-		hint = 1;
-	i = hint;
-	do {
+	for (i = 0; i < irq_virq_count; i++)  {
 		struct irq_data *data = irq_get_irq_data(i);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
 			return i;
-		i++;
-		if (i >= irq_virq_count)
-			i = 1
-	} while(i != hint);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
-- 
1.7.9

