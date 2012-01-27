Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2A0Vgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:36:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab2A0Vgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:46 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 21/25] irqdomain/powerpc: Replace custom xlate functions with library functions
Date: Fri, 27 Jan 2012 14:36:15 -0700
Message-Id: <1327700179-17454-22-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts a number of the powerpc drivers to use the common library
of irq_domain xlate functions, dropping a bunch of lines in the process.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/platforms/powermac/pic.c |   13 +------------
 arch/powerpc/platforms/wsp/opb_pic.c  |   13 +------------
 arch/powerpc/sysdev/cpm2_pic.c        |   14 +-------------
 arch/powerpc/sysdev/ipic.c            |   18 +-----------------
 arch/powerpc/sysdev/qe_lib/qe_ic.c    |   15 +--------------
 arch/powerpc/sysdev/tsi108_pci.c      |   11 +----------
 arch/powerpc/sysdev/uic.c             |   14 +-------------
 drivers/gpio/gpio-mpc8xxx.c           |   17 +----------------
 8 files changed, 8 insertions(+), 107 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 46a5f32..3af29d1 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -288,21 +288,10 @@ static int pmac_pic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int pmac_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
-			       const u32 *intspec, unsigned int intsize,
-			       irq_hw_number_t *out_hwirq,
-			       unsigned int *out_flags)
-
-{
-	*out_flags = IRQ_TYPE_NONE;
-	*out_hwirq = *intspec;
-	return 0;
-}
-
 static const struct irq_domain_ops pmac_pic_host_ops = {
 	.match = pmac_pic_host_match,
 	.map = pmac_pic_host_map,
-	.xlate = pmac_pic_host_xlate,
+	.xlate = irq_domain_xlate_onecell;
 };
 
 static void __init pmac_pic_probe_oldstyle(void)
diff --git a/arch/powerpc/platforms/wsp/opb_pic.c b/arch/powerpc/platforms/wsp/opb_pic.c
index 0c6fe0b..cb565bf 100644
--- a/arch/powerpc/platforms/wsp/opb_pic.c
+++ b/arch/powerpc/platforms/wsp/opb_pic.c
@@ -196,20 +196,9 @@ static int opb_host_map(struct irq_domain *host, unsigned int virq,
 	return 0;
 }
 
-static int opb_host_xlate(struct irq_domain *host, struct device_node *dn,
-		const u32 *intspec, unsigned int intsize,
-		irq_hw_number_t *out_hwirq, unsigned int *out_type)
-{
-	/* Interrupt size must == 2 */
-	BUG_ON(intsize != 2);
-	*out_hwirq = intspec[0];
-	*out_type = intspec[1];
-	return 0;
-}
-
 static const struct irq_domain_ops opb_host_ops = {
 	.map = opb_host_map,
-	.xlate = opb_host_xlate,
+	.xlate = irq_domain_xlate_twocell,
 };
 
 irqreturn_t opb_irq_handler(int irq, void *private)
diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
index 8c9fc9c..d3be961 100644
--- a/arch/powerpc/sysdev/cpm2_pic.c
+++ b/arch/powerpc/sysdev/cpm2_pic.c
@@ -224,21 +224,9 @@ static int cpm2_pic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int cpm2_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
-			    const u32 *intspec, unsigned int intsize,
-			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
-{
-	*out_hwirq = intspec[0];
-	if (intsize > 1)
-		*out_flags = intspec[1];
-	else
-		*out_flags = IRQ_TYPE_NONE;
-	return 0;
-}
-
 static const struct irq_domain_ops cpm2_pic_host_ops = {
 	.map = cpm2_pic_host_map,
-	.xlate = cpm2_pic_host_xlate,
+	.xlate = irq_domain_xlate_onetwocell,
 };
 
 void cpm2_pic_init(struct device_node *node)
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index 0eaaa01..b50f978 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -692,26 +692,10 @@ static int ipic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int ipic_host_xlate(struct irq_domain *h, struct device_node *ct,
-			   const u32 *intspec, unsigned int intsize,
-			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
-
-{
-	/* interrupt sense values coming from the device tree equal either
-	 * LEVEL_LOW (low assertion) or EDGE_FALLING (high-to-low change)
-	 */
-	*out_hwirq = intspec[0];
-	if (intsize > 1)
-		*out_flags = intspec[1];
-	else
-		*out_flags = IRQ_TYPE_NONE;
-	return 0;
-}
-
 static struct irq_domain_ops ipic_host_ops = {
 	.match	= ipic_host_match,
 	.map	= ipic_host_map,
-	.xlate	= ipic_host_xlate,
+	.xlate	= irq_domain_xlate_onetwocell,
 };
 
 struct ipic * __init ipic_init(struct device_node *node, unsigned int flags)
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index e9b3d5c..2fba6ef 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -272,23 +272,10 @@ static int qe_ic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int qe_ic_host_xlate(struct irq_domain *h, struct device_node *ct,
-			    const u32 * intspec, unsigned int intsize,
-			    irq_hw_number_t * out_hwirq,
-			    unsigned int *out_flags)
-{
-	*out_hwirq = intspec[0];
-	if (intsize > 1)
-		*out_flags = intspec[1];
-	else
-		*out_flags = IRQ_TYPE_NONE;
-	return 0;
-}
-
 static struct irq_domain_ops qe_ic_host_ops = {
 	.match = qe_ic_host_match,
 	.map = qe_ic_host_map,
-	.xlate = qe_ic_host_xlate,
+	.xlate = irq_domain_xlate_onetwocell,
 };
 
 /* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index 188012c..470c1ef 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -376,15 +376,6 @@ static struct irq_chip tsi108_pci_irq = {
 	.irq_unmask = tsi108_pci_irq_unmask,
 };
 
-static int pci_irq_host_xlate(struct irq_domain *h, struct device_node *ct,
-			    const u32 *intspec, unsigned int intsize,
-			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
-{
-	*out_hwirq = intspec[0];
-	*out_flags = IRQ_TYPE_LEVEL_HIGH;
-	return 0;
-}
-
 static int pci_irq_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {	unsigned int irq;
@@ -399,7 +390,7 @@ static int pci_irq_host_map(struct irq_domain *h, unsigned int virq,
 
 static struct irq_domain_ops pci_irq_domain_ops = {
 	.map = pci_irq_host_map,
-	.xlate = pci_irq_host_xlate,
+	.xlate = irq_domain_xlate_pci,
 };
 
 /*
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 84e59c9..9203393 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -190,21 +190,9 @@ static int uic_host_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int uic_host_xlate(struct irq_domain *h, struct device_node *ct,
-			  const u32 *intspec, unsigned int intsize,
-			  irq_hw_number_t *out_hwirq, unsigned int *out_type)
-
-{
-	/* UIC intspecs must have 2 cells */
-	BUG_ON(intsize != 2);
-	*out_hwirq = intspec[0];
-	*out_type = intspec[1];
-	return 0;
-}
-
 static struct irq_domain_ops uic_host_ops = {
 	.map	= uic_host_map,
-	.xlate	= uic_host_xlate,
+	.xlate	= irq_domain_xlate_twocell,
 };
 
 void uic_irq_cascade(unsigned int virq, struct irq_desc *desc)
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 149d987..e6568c1 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -296,24 +296,9 @@ static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static int mpc8xxx_gpio_irq_xlate(struct irq_domain *h, struct device_node *ct,
-				  const u32 *intspec, unsigned int intsize,
-				  irq_hw_number_t *out_hwirq,
-				  unsigned int *out_flags)
-
-{
-	/* interrupt sense values coming from the device tree equal either
-	 * EDGE_FALLING or EDGE_BOTH
-	 */
-	*out_hwirq = intspec[0];
-	*out_flags = intspec[1];
-
-	return 0;
-}
-
 static struct irq_domain_ops mpc8xxx_gpio_irq_ops = {
 	.map	= mpc8xxx_gpio_irq_map,
-	.xlate	= mpc8xxx_gpio_irq_xlate,
+	.xlate	= irq_domain_xlate_twocell,
 };
 
 static struct of_device_id mpc8xxx_gpio_ids[] __initdata = {
-- 
1.7.5.4

