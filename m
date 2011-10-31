Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab1JaVNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:13:10 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39812
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab1JaVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:13:06 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Milton Miller <miltonm@bga.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, cbe-oss-dev@lists.ozlabs.org
Subject: [RFC PATCH 10/10] powerpc/mpic: Add in-core support for cascaded MPICs
Date: Mon, 31 Oct 2011 17:10:11 -0400
Message-Id: <1320095411-20667-11-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cell and PowerMac platforms use virtually identical cascaded-IRQ
setup code, so just merge it into the core.  This does the obvious thing
when an MPIC device-node specifies an "interrupts" property.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/platforms/cell/setup.c   |   22 --------------------
 arch/powerpc/platforms/powermac/pic.c |   36 ++++----------------------------
 arch/powerpc/sysdev/mpic.c            |   27 ++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index 392cbdb..8708a71 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -183,19 +183,6 @@ static int __init cell_publish_devices(void)
 }
 machine_subsys_initcall(cell, cell_publish_devices);
 
-static void cell_mpic_cascade(unsigned int irq, struct irq_desc *desc)
-{
-	struct irq_chip *chip = irq_desc_get_chip(desc);
-	struct mpic *mpic = irq_desc_get_handler_data(desc);
-	unsigned int virq;
-
-	virq = mpic_get_one_irq(mpic);
-	if (virq != NO_IRQ)
-		generic_handle_irq(virq);
-
-	chip->irq_eoi(&desc->irq_data);
-}
-
 static void __init mpic_init_IRQ(void)
 {
 	struct device_node *dn;
@@ -214,15 +201,6 @@ static void __init mpic_init_IRQ(void)
 		if (mpic == NULL)
 			continue;
 		mpic_init(mpic);
-
-		virq = irq_of_parse_and_map(dn, 0);
-		if (virq == NO_IRQ)
-			continue;
-
-		printk(KERN_INFO "%s : hooking up to IRQ %d\n",
-		       dn->full_name, virq);
-		irq_set_handler_data(virq, mpic);
-		irq_set_chained_handler(virq, cell_mpic_cascade);
 	}
 }
 
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index f4dc247..e02cd79 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -466,18 +466,6 @@ int of_irq_map_oldworld(struct device_node *device, int index,
 }
 #endif /* CONFIG_PPC32 */
 
-static void pmac_u3_cascade(unsigned int irq, struct irq_desc *desc)
-{
-	struct irq_chip *chip = irq_desc_get_chip(desc);
-	struct mpic *mpic = irq_desc_get_handler_data(desc);
-	unsigned int cascade_irq = mpic_get_one_irq(mpic);
-
-	if (cascade_irq != NO_IRQ)
-		generic_handle_irq(cascade_irq);
-
-	chip->irq_eoi(&desc->irq_data);
-}
-
 static void __init pmac_pic_setup_mpic_nmi(struct mpic *mpic)
 {
 #if defined(CONFIG_XMON) && defined(CONFIG_PPC32)
@@ -529,7 +517,6 @@ static int __init pmac_pic_probe_mpic(void)
 {
 	struct mpic *mpic1, *mpic2;
 	struct device_node *np, *master = NULL, *slave = NULL;
-	unsigned int cascade;
 
 	/* We can have up to 2 MPICs cascaded */
 	for (np = NULL; (np = of_find_node_by_type(np, "open-pic"))
@@ -565,27 +552,14 @@ static int __init pmac_pic_probe_mpic(void)
 
 	of_node_put(master);
 
-	/* No slave, let's go out */
-	if (slave == NULL)
-		return 0;
-
-	/* Get/Map slave interrupt */
-	cascade = irq_of_parse_and_map(slave, 0);
-	if (cascade == NO_IRQ) {
-		printk(KERN_ERR "Failed to map cascade IRQ\n");
-		return 0;
-	}
-
-	mpic2 = pmac_setup_one_mpic(slave, 0);
-	if (mpic2 == NULL) {
-		printk(KERN_ERR "Failed to setup slave MPIC\n");
+	/* Set up a cascaded controller, if present */
+	if (slave) {
+		mpic2 = pmac_setup_one_mpic(slave, 0);
+		if (mpic2 == NULL)
+			printk(KERN_ERR "Failed to setup slave MPIC\n");
 		of_node_put(slave);
-		return 0;
 	}
-	irq_set_handler_data(cascade, mpic2);
-	irq_set_chained_handler(cascade, pmac_u3_cascade);
 
-	of_node_put(slave);
 	return 0;
 }
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 1826dae..d5cf276 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1113,6 +1113,21 @@ static int mpic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
+/* IRQ handler for a secondary MPIC cascaded from another IRQ controller */
+static void mpic_cascade(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct mpic *mpic = irq_desc_get_handler_data(desc);
+
+	BUG_ON(!(mpic->flags & MPIC_SECONDARY));
+
+	unsigned int virq = mpic_get_one_irq(mpic);
+	if (virq != NO_IRQ)
+		generic_handle_irq(virq);
+
+	chip->irq_eoi(&desc->irq_data);
+}
+
 static struct irq_host_ops mpic_host_ops = {
 	.match = mpic_host_match,
 	.map = mpic_host_map,
@@ -1384,8 +1399,7 @@ void __init mpic_set_default_senses(struct mpic *mpic, u8 *senses, int count)
 
 void __init mpic_init(struct mpic *mpic)
 {
-	int i;
-	int cpu;
+	int i, cpu, virq;
 
 	BUG_ON(mpic->num_sources == 0);
 
@@ -1470,6 +1484,15 @@ void __init mpic_init(struct mpic *mpic)
 				  GFP_KERNEL);
 	BUG_ON(mpic->save_data == NULL);
 #endif
+
+	/* Check if this MPIC is chained from a parent interrupt controller */
+	virq = irq_of_parse_and_map(mpic->node, 0);
+	if (virq != NO_IRQ) {
+		printk(KERN_INFO "%s: hooking up to IRQ %d\n",
+				dn->full_name, virq);
+		irq_set_handler_data(virq, mpic);
+		irq_set_chained_handler(virq, &mpic_cascade);
+	}
 }
 
 void __init mpic_set_clk_ratio(struct mpic *mpic, u32 clock_ratio)
-- 
1.7.2.5

