Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2A0VmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:42:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2A0Vgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:39 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 07/25] irq_domain/powerpc: Eliminate virq_is_host()
Date: Fri, 27 Jan 2012 14:36:01 -0700
Message-Id: <1327700179-17454-8-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one user, and it is trivial to open-code.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/include/asm/irq.h         |    1 -
 arch/powerpc/kernel/irq.c              |    7 -------
 arch/powerpc/sysdev/xics/xics-common.c |   12 ++++++------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index abdd7ef..f80f262 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -58,7 +58,6 @@ extern atomic_t ppc_n_lost_interrupts;
 struct irq_data;
 extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
 extern irq_hw_number_t virq_to_hw(unsigned int virq);
-extern bool virq_is_host(unsigned int virq, struct irq_domain *host);
 
 /**
  * irq_alloc_host - Allocate a new irq_domain data structure
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index db5b545..9533fa7 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -510,13 +510,6 @@ irq_hw_number_t virq_to_hw(unsigned int virq)
 }
 EXPORT_SYMBOL_GPL(virq_to_hw);
 
-bool virq_is_host(unsigned int virq, struct irq_domain *host)
-{
-	struct irq_data *irq_data = irq_get_irq_data(virq);
-	return irq_data ? irq_data->domain == host : false;
-}
-EXPORT_SYMBOL_GPL(virq_is_host);
-
 static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
 {
 	return h->of_node != NULL && h->of_node == np;
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index c4b3ce1..fb2e303 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -212,16 +212,16 @@ void xics_migrate_irqs_away(void)
 		/* We can't set affinity on ISA interrupts */
 		if (virq < NUM_ISA_INTERRUPTS)
 			continue;
-		if (!virq_is_host(virq, xics_host))
-			continue;
-		irq = (unsigned int)virq_to_hw(virq);
-		/* We need to get IPIs still. */
-		if (irq == XICS_IPI || irq == XICS_IRQ_SPURIOUS)
-			continue;
 		desc = irq_to_desc(virq);
 		/* We only need to migrate enabled IRQS */
 		if (!desc || !desc->action)
 			continue;
+		if (desc->irq_data.domain != xics_host)
+			continue;
+		irq = desc->irq_data.hwirq;
+		/* We need to get IPIs still. */
+		if (irq == XICS_IPI || irq == XICS_IRQ_SPURIOUS)
+			continue;
 		chip = irq_desc_get_chip(desc);
 		if (!chip || !chip->irq_set_affinity)
 			continue;
-- 
1.7.5.4

