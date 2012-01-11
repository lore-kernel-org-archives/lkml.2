Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab2AKUYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:24:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52489 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179Ab2AKUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:22:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 10/14] irq_domain: Replace irq_alloc_host() with revmap-specific initializers
Date: Wed, 11 Jan 2012 13:22:13 -0700
Message-Id: <1326313337-24603-11-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each revmap type has different arguments for setting up the revmap.
This patch splits up the generator functions so that each revmap type
can do its own setup and the user doesn't need to keep track of how
each revmap type handles the arguments.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    3 +-
 arch/powerpc/platforms/52xx/media5200.c          |    6 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    5 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |    4 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    3 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |    5 +-
 arch/powerpc/platforms/86xx/gef_pic.c            |    5 +-
 arch/powerpc/platforms/cell/axon_msi.c           |    3 +-
 arch/powerpc/platforms/cell/beat_interrupt.c     |    4 +-
 arch/powerpc/platforms/cell/interrupt.c          |    3 +-
 arch/powerpc/platforms/cell/spider-pic.c         |    4 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    4 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    3 +-
 arch/powerpc/platforms/iseries/irq.c             |    3 +-
 arch/powerpc/platforms/powermac/pic.c            |    4 +-
 arch/powerpc/platforms/powermac/smp.c            |    3 +-
 arch/powerpc/platforms/ps3/interrupt.c           |    3 +-
 arch/powerpc/platforms/wsp/opb_pic.c             |    5 +-
 arch/powerpc/sysdev/cpm1.c                       |    3 +-
 arch/powerpc/sysdev/cpm2_pic.c                   |    3 +-
 arch/powerpc/sysdev/ehv_pic.c                    |    4 +-
 arch/powerpc/sysdev/fsl_msi.c                    |    4 +-
 arch/powerpc/sysdev/i8259.c                      |    3 +-
 arch/powerpc/sysdev/ipic.c                       |    4 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |    3 +-
 arch/powerpc/sysdev/mpic.c                       |    5 +-
 arch/powerpc/sysdev/mv64x60_pic.c                |    5 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |    3 +-
 arch/powerpc/sysdev/tsi108_pci.c                 |    3 +-
 arch/powerpc/sysdev/uic.c                        |    3 +-
 arch/powerpc/sysdev/xics/xics-common.c           |    3 +-
 arch/powerpc/sysdev/xilinx_intc.c                |    3 +-
 drivers/gpio/gpio-mpc8xxx.c                      |    5 +-
 include/linux/irqdomain.h                        |   16 ++-
 kernel/irq/irqdomain.c                           |  167 ++++++++++++++--------
 35 files changed, 162 insertions(+), 145 deletions(-)

diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
index fefa797..2301f7e 100644
--- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -190,8 +190,7 @@ mpc5121_ads_cpld_pic_init(void)
 
 	cpld_pic_node = of_node_get(np);
 
-	cpld_pic_host =
-	    irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, 16, &cpld_pic_host_ops, 16);
+	cpld_pic_host = irq_domain_add_linear(np, 16, &cpld_pic_host_ops);
 	if (!cpld_pic_host) {
 		printk(KERN_ERR "CPLD PIC: failed to allocate irq host!\n");
 		goto end;
diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
index a746415..626ddfd 100644
--- a/arch/powerpc/platforms/52xx/media5200.c
+++ b/arch/powerpc/platforms/52xx/media5200.c
@@ -173,9 +173,9 @@ static void __init media5200_init_irq(void)
 
 	spin_lock_init(&media5200_irq.lock);
 
-	media5200_irq.irqhost = irq_alloc_host(fpga_np, IRQ_DOMAIN_MAP_LINEAR,
-					       MEDIA5200_NUM_IRQS,
-					       &media5200_irq_ops, -1);
+	media5200_irq.irqhost = irq_domain_add_linear(fpga_np,
+						MEDIA5200_NUM_IRQS,
+						&media5200_irq_ops);
 	if (!media5200_irq.irqhost)
 		goto out;
 	pr_debug("%s: allocated irqhost\n", __func__);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index e90af8f..509ad12 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -252,10 +252,9 @@ mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	if (!cascade_virq)
 		return;
 
-	gpt->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR, 1,
-				      &mpc52xx_gpt_irq_ops, -1);
+	gpt->irqhost = irq_domain_add_linear(node, 1, &mpc52xx_gpt_irq_ops);
 	if (!gpt->irqhost) {
-		dev_err(gpt->dev, "irq_alloc_host() failed\n");
+		dev_err(gpt->dev, "irq_domain_add_linear() failed\n");
 		return;
 	}
 
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index 8c997f1..844405c 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -444,9 +444,9 @@ void __init mpc52xx_init_irq(void)
 	 * As last step, add an irq host to translate the real
 	 * hw irq information provided by the ofw to linux virq
 	 */
-	mpc52xx_irqhost = irq_alloc_host(picnode, IRQ_DOMAIN_MAP_LINEAR,
+	mpc52xx_irqhost = irq_domain_add_linear(picnode,
 	                                 MPC52xx_IRQ_HIGHTESTHWIRQ,
-	                                 &mpc52xx_irqhost_ops, -1);
+	                                 &mpc52xx_irqhost_ops);
 
 	if (!mpc52xx_irqhost)
 		panic(__FILE__ ": Cannot allocate the IRQ host\n");
diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
index bdba174..80c9312 100644
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -156,8 +156,7 @@ int __init pq2ads_pci_init_irq(void)
 	out_be32(&priv->regs->mask, ~0);
 	mb();
 
-	host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, NUM_IRQS,
-	                      &pci_pic_host_ops, NUM_IRQS);
+	host = irq_domain_add_linear(np, NUM_IRQS, &pci_pic_host_ops);
 	if (!host) {
 		ret = -ENOMEM;
 		goto out_unmap_regs;
diff --git a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
index e3ef7c9..655c39e 100644
--- a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -280,9 +280,8 @@ void socrates_fpga_pic_init(struct device_node *pic)
 	int i;
 
 	/* Setup an irq_domain structure */
-	socrates_fpga_pic_irq_host = irq_alloc_host(pic, IRQ_DOMAIN_MAP_LINEAR,
-			SOCRATES_FPGA_NUM_IRQS,	&socrates_fpga_pic_host_ops,
-			SOCRATES_FPGA_NUM_IRQS);
+	socrates_fpga_pic_irq_host = irq_domain_add_linear(pic,
+			SOCRATES_FPGA_NUM_IRQS, &socrates_fpga_pic_host_ops);
 	if (socrates_fpga_pic_irq_host == NULL) {
 		pr_err("FPGA PIC: Unable to allocate host\n");
 		return;
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
index 0cf8af2..ca6f7a2 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/platforms/86xx/gef_pic.c
@@ -212,9 +212,8 @@ void __init gef_pic_init(struct device_node *np)
 	}
 
 	/* Setup an irq_domain structure */
-	gef_pic_irq_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
-					  GEF_PIC_NUM_IRQS,
-					  &gef_pic_host_ops, NO_IRQ);
+	gef_pic_irq_host = irq_domain_add_linear(np, GEF_PIC_NUM_IRQS,
+					  &gef_pic_host_ops);
 	if (gef_pic_irq_host == NULL)
 		return;
 
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 1bfd18a..93b49f1 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -392,8 +392,7 @@ static int axon_msi_probe(struct platform_device *device)
 	}
 	memset(msic->fifo_virt, 0xff, MSIC_FIFO_SIZE_BYTES);
 
-	msic->irq_domain = irq_alloc_host(dn, IRQ_DOMAIN_MAP_NOMAP,
-					NR_IRQS, &msic_host_ops, 0);
+	msic->irq_domain = irq_domain_add_nomap(dn, &msic_host_ops);
 	if (!msic->irq_domain) {
 		printk(KERN_ERR "axon_msi: couldn't allocate irq_domain for %s\n",
 		       dn->full_name);
diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index 21b64cf..2aee1e5 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -239,9 +239,7 @@ void __init beatic_init_IRQ(void)
 	ppc_md.get_irq = beatic_get_irq;
 
 	/* Allocate an irq host */
-	beatic_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0,
-				     &beatic_pic_host_ops,
-					 0);
+	beatic_host = irq_domain_add_nomap(NULL, &beatic_pic_host_ops);
 	BUG_ON(beatic_host == NULL);
 	irq_set_default_host(beatic_host);
 }
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 6888475..dca3825 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -378,8 +378,7 @@ static int __init setup_iic(void)
 void __init iic_init_IRQ(void)
 {
 	/* Setup an irq host data structure */
-	iic_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_LINEAR, IIC_SOURCE_COUNT,
-				  &iic_host_ops, IIC_IRQ_INVALID);
+	iic_host = irq_domain_add_linear(NULL, IIC_SOURCE_COUNT, &iic_host_ops);
 	BUG_ON(iic_host == NULL);
 	irq_set_default_host(iic_host);
 
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 1f935a7..8153e4e 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -299,9 +299,7 @@ static void __init spider_init_one(struct device_node *of_node, int chip,
 		panic("spider_pic: can't map registers !");
 
 	/* Allocate a host */
-	pic->host = irq_alloc_host(of_node, IRQ_DOMAIN_MAP_LINEAR,
-				   SPIDER_SRC_COUNT, &spider_host_ops,
-				   SPIDER_IRQ_INVALID);
+	pic->host = irq_domain_add_linear(of_node, SPIDER_SRC_COUNT, &spider_host_ops);
 	if (pic->host == NULL)
 		panic("spider_pic: can't allocate irq host !");
 	pic->host->host_data = pic;
diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index f862361..5e411ad 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -159,8 +159,8 @@ struct irq_domain * __init flipper_pic_init(struct device_node *np)
 
 	__flipper_quiesce(io_base);
 
-	irq_domain = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, FLIPPER_NR_IRQS,
-				  &flipper_irq_domain_ops, -1);
+	irq_domain = irq_domain_add_linear(np, FLIPPER_NR_IRQS,
+				  &flipper_irq_domain_ops);
 	if (!irq_domain) {
 		pr_err("failed to allocate irq_domain\n");
 		return NULL;
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index 2d4a5d4..00434c8 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -177,8 +177,7 @@ struct irq_domain *hlwd_pic_init(struct device_node *np)
 
 	__hlwd_quiesce(io_base);
 
-	irq_domain = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, HLWD_NR_IRQS,
-				  &hlwd_irq_domain_ops, -1);
+	irq_domain = irq_domain_add_linear(np, HLWD_NR_IRQS, &hlwd_irq_domain_ops);
 	if (!irq_domain) {
 		pr_err("failed to allocate irq_domain\n");
 		return NULL;
diff --git a/arch/powerpc/platforms/iseries/irq.c b/arch/powerpc/platforms/iseries/irq.c
index b07d4f2..efecba5 100644
--- a/arch/powerpc/platforms/iseries/irq.c
+++ b/arch/powerpc/platforms/iseries/irq.c
@@ -380,8 +380,7 @@ void __init iSeries_init_IRQ(void)
 	/* Create irq host. No need for a revmap since HV will give us
 	 * back our virtual irq number
 	 */
-	host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0,
-			      &iseries_irq_domain_ops, 0);
+	host = irq_domain_add_nomap(NULL, &iseries_irq_domain_ops);
 	BUG_ON(host == NULL);
 	irq_set_default_host(host);
 
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index cff326a..079d921 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -352,9 +352,7 @@ static void __init pmac_pic_probe_oldstyle(void)
 	/*
 	 * Allocate an irq host
 	 */
-	pmac_pic_host = irq_alloc_host(master, IRQ_DOMAIN_MAP_LINEAR, max_irqs,
-				       &pmac_pic_host_ops,
-				       max_irqs);
+	pmac_pic_host = irq_domain_add_linear(master, max_irqs, &pmac_pic_host_ops);
 	BUG_ON(pmac_pic_host == NULL);
 	irq_set_default_host(pmac_pic_host);
 
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index 6b1ef2d..1b3b5b7 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -192,8 +192,7 @@ static int psurge_secondary_ipi_init(void)
 {
 	int rc = -ENOMEM;
 
-	psurge_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0,
-		&psurge_host_ops, 0);
+	psurge_host = irq_domain_add_nomap(NULL, &psurge_host_ops);
 
 	if (psurge_host)
 		psurge_secondary_virq = irq_create_direct_mapping(psurge_host);
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index c5980e4..66891b8 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -753,8 +753,7 @@ void __init ps3_init_IRQ(void)
 	unsigned cpu;
 	struct irq_domain *host;
 
-	host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0, &ps3_host_ops,
-		PS3_INVALID_OUTLET);
+	host = irq_domain_add_nomap(NULL, &ps3_host_ops);
 	irq_set_default_host(host);
 	irq_set_virq_count(PS3_PLUG_MAX + 1);
 
diff --git a/arch/powerpc/platforms/wsp/opb_pic.c b/arch/powerpc/platforms/wsp/opb_pic.c
index 76b33bc..ab2c232 100644
--- a/arch/powerpc/platforms/wsp/opb_pic.c
+++ b/arch/powerpc/platforms/wsp/opb_pic.c
@@ -263,12 +263,11 @@ struct opb_pic *opb_pic_init_one(struct device_node *dn)
 		goto free_opb;
 	}
 
-	/* Allocate an irq host so that Linux knows that despite only
+	/* Allocate an irq domain so that Linux knows that despite only
 	 * having one interrupt to issue, we're the controller for multiple
 	 * hardware IRQs, so later we can lookup their virtual IRQs. */
 
-	opb->host = irq_alloc_host(dn, IRQ_DOMAIN_MAP_LINEAR,
-			OPB_NR_IRQS, &opb_host_ops, -1);
+	opb->host = irq_domain_add_linear(dn, OPB_NR_IRQS, &opb_host_ops);
 
 	if (!opb->host) {
 		printk(KERN_ERR "opb: Failed to allocate IRQ host!\n");
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 0877a75..2c90726 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -164,8 +164,7 @@ unsigned int cpm_pic_init(void)
 
 	out_be32(&cpic_reg->cpic_cimr, 0);
 
-	cpm_pic_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
-				      64, &cpm_pic_host_ops, 64);
+	cpm_pic_host = irq_domain_add_linear(np, 64, &cpm_pic_host_ops);
 	if (cpm_pic_host == NULL) {
 		printk(KERN_ERR "CPM2 PIC: failed to allocate irq host!\n");
 		sirq = NO_IRQ;
diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
index b149baa..8754ae3 100644
--- a/arch/powerpc/sysdev/cpm2_pic.c
+++ b/arch/powerpc/sysdev/cpm2_pic.c
@@ -275,8 +275,7 @@ void cpm2_pic_init(struct device_node *node)
 	out_be32(&cpm2_intctl->ic_scprrl, 0x05309770);
 
 	/* create a legacy host */
-	cpm2_pic_host = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
-				       64, &cpm2_pic_host_ops, 64);
+	cpm2_pic_host = irq_domain_add_linear(node, 64, &cpm2_pic_host_ops);
 	if (cpm2_pic_host == NULL) {
 		printk(KERN_ERR "CPM2 PIC: failed to allocate irq host!\n");
 		return;
diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index 48d3ba1..888b75b 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -275,9 +275,7 @@ void __init ehv_pic_init(void)
 		return;
 	}
 
-	ehv_pic->irqhost = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
-		NR_EHV_PIC_INTS, &ehv_pic_host_ops, 0);
-
+	ehv_pic->irqhost = irq_domain_add_linear(np, NR_EHV_PIC_INTS, &ehv_pic_host_ops);
 	if (!ehv_pic->irqhost) {
 		of_node_put(np);
 		kfree(ehv_pic);
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 3f9a301..82bac2c 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -387,8 +387,8 @@ static int __devinit fsl_of_msi_probe(struct platform_device *dev)
 	}
 	platform_set_drvdata(dev, msi);
 
-	msi->irqhost = irq_alloc_host(dev->dev.of_node, IRQ_DOMAIN_MAP_LINEAR,
-				      NR_MSI_IRQS, &fsl_msi_host_ops, 0);
+	msi->irqhost = irq_domain_add_linear(dev->dev.of_node,
+				      NR_MSI_IRQS, &fsl_msi_host_ops);
 
 	if (msi->irqhost == NULL) {
 		dev_err(&dev->dev, "No memory for MSI irqhost\n");
diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
index 7e67890..4a49b5e 100644
--- a/arch/powerpc/sysdev/i8259.c
+++ b/arch/powerpc/sysdev/i8259.c
@@ -263,8 +263,7 @@ void i8259_init(struct device_node *node, unsigned long intack_addr)
 	raw_spin_unlock_irqrestore(&i8259_lock, flags);
 
 	/* create a legacy host */
-	i8259_host = irq_alloc_host(node, IRQ_DOMAIN_MAP_LEGACY,
-				    0, &i8259_host_ops, 0);
+	i8259_host = irq_domain_add_legacy(node, &i8259_host_ops);
 	if (i8259_host == NULL) {
 		printk(KERN_ERR "i8259: failed to allocate irq host !\n");
 		return;
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index 9abed37..b764917 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -728,9 +728,7 @@ struct ipic * __init ipic_init(struct device_node *node, unsigned int flags)
 	if (ipic == NULL)
 		return NULL;
 
-	ipic->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
-				       NR_IPIC_INTS,
-				       &ipic_host_ops, 0);
+	ipic->irqhost = irq_domain_add_linear(node, NR_IPIC_INTS, &ipic_host_ops);
 	if (ipic->irqhost == NULL) {
 		kfree(ipic);
 		return NULL;
diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
index 978dfc4..43f22b2 100644
--- a/arch/powerpc/sysdev/mpc8xx_pic.c
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -171,8 +171,7 @@ int mpc8xx_pic_init(void)
 		goto out;
 	}
 
-	mpc8xx_pic_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
-					 64, &mpc8xx_pic_host_ops, 64);
+	mpc8xx_pic_host = irq_domain_add_linear(np, 64, &mpc8xx_pic_host_ops);
 	if (mpc8xx_pic_host == NULL) {
 		printk(KERN_ERR "MPC8xx PIC: failed to allocate irq host!\n");
 		ret = -ENOMEM;
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index c844d34..45e33e5 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1345,10 +1345,9 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
 	mpic->isu_mask = (1 << mpic->isu_shift) - 1;
 
-	mpic->irqhost = irq_alloc_host(mpic->node, IRQ_DOMAIN_MAP_LINEAR,
+	mpic->irqhost = irq_domain_add_linear(mpic->node,
 				       isu_size ? isu_size : mpic->num_sources,
-				       &mpic_host_ops,
-				       flags & MPIC_LARGE_VECTORS ? 2048 : 256);
+				       &mpic_host_ops);
 
 	/*
 	 * FIXME: The code leaks the MPIC object and mappings here; this
diff --git a/arch/powerpc/sysdev/mv64x60_pic.c b/arch/powerpc/sysdev/mv64x60_pic.c
index 45124a1..3d1ef09 100644
--- a/arch/powerpc/sysdev/mv64x60_pic.c
+++ b/arch/powerpc/sysdev/mv64x60_pic.c
@@ -250,9 +250,8 @@ void __init mv64x60_init_irq(void)
 	paddr = of_translate_address(np, reg);
 	mv64x60_irq_reg_base = ioremap(paddr, reg[1]);
 
-	mv64x60_irq_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
-					  MV64x60_NUM_IRQS,
-					  &mv64x60_host_ops, MV64x60_NUM_IRQS);
+	mv64x60_irq_host = irq_domain_add_linear(np, MV64x60_NUM_IRQS,
+					  &mv64x60_host_ops);
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
 	out_le32(mv64x60_gpp_reg_base + MV64x60_GPP_INTR_MASK,
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 78e9019..621523f 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -339,8 +339,7 @@ void __init qe_ic_init(struct device_node *node, unsigned int flags,
 	if (qe_ic == NULL)
 		return;
 
-	qe_ic->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
-					NR_QE_IC_INTS, &qe_ic_host_ops, 0);
+	qe_ic->irqhost = irq_domain_add_linear(node, NR_QE_IC_INTS, &qe_ic_host_ops);
 	if (qe_ic->irqhost == NULL) {
 		kfree(qe_ic);
 		return;
diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index f375723..6d4a38d 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -419,8 +419,7 @@ void __init tsi108_pci_int_init(struct device_node *node)
 {
 	DBG("Tsi108_pci_int_init: initializing PCI interrupts\n");
 
-	pci_irq_host = irq_alloc_host(node, IRQ_DOMAIN_MAP_LEGACY,
-				      0, &pci_irq_domain_ops, 0);
+	pci_irq_host = irq_domain_add_legacy(node, &pci_irq_domain_ops);
 	if (pci_irq_host == NULL) {
 		printk(KERN_ERR "pci_irq_host: failed to allocate irq domain!\n");
 		return;
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 7eea3a6..139dfab 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -270,8 +270,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 	}
 	uic->dcrbase = *dcrreg;
 
-	uic->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
-				      NR_UIC_INTS, &uic_host_ops, -1);
+	uic->irqhost = irq_domain_add_linear(node, NR_UIC_INTS, &uic_host_ops);
 	if (! uic->irqhost)
 		return NULL; /* FIXME: panic? */
 
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index fb2e303..84c97a7 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -374,8 +374,7 @@ static struct irq_domain_ops xics_host_ops = {
 
 static void __init xics_init_host(void)
 {
-	xics_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_TREE, 0, &xics_host_ops,
-				   XICS_IRQ_SPURIOUS);
+	xics_host = irq_domain_add_tree(NULL, &xics_host_ops);
 	BUG_ON(xics_host == NULL);
 	irq_set_default_host(xics_host);
 }
diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
index 92e7d4d..bed6e5e 100644
--- a/arch/powerpc/sysdev/xilinx_intc.c
+++ b/arch/powerpc/sysdev/xilinx_intc.c
@@ -201,8 +201,7 @@ xilinx_intc_init(struct device_node *np)
 	out_be32(regs + XINTC_MER, 0x3UL); /* Turn on the Master Enable. */
 
 	/* Allocate and initialize an irq_domain structure. */
-	irq = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, XILINX_INTC_MAXIRQS,
-			     &xilinx_intc_ops, -1);
+	irq = irq_domain_add_linear(np, XILINX_INTC_MAXIRQS, &xilinx_intc_ops);
 	if (!irq)
 		panic(__FILE__ ": Cannot allocate IRQ host\n");
 	irq->host_data = regs;
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 9efd597..3ca09c5 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -364,9 +364,8 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 	if (hwirq == NO_IRQ)
 		goto skip_irq;
 
-	mpc8xxx_gc->irq =
-		irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, MPC8XXX_GPIO_PINS,
-			       &mpc8xxx_gpio_irq_ops, MPC8XXX_GPIO_PINS);
+	mpc8xxx_gc->irq = irq_domain_add_linear(np, MPC8XXX_GPIO_PINS,
+						&mpc8xxx_gpio_irq_ops);
 	if (!mpc8xxx_gc->irq)
 		goto skip_irq;
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 18f4ab0..f4325ff 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -120,11 +120,17 @@ struct irq_domain {
 
 #ifdef CONFIG_IRQ_DOMAIN
 #ifdef CONFIG_PPC
-extern struct irq_domain *irq_alloc_host(struct device_node *of_node,
-				       unsigned int revmap_type,
-				       unsigned int revmap_arg,
-				       struct irq_domain_ops *ops,
-				       irq_hw_number_t inval_irq);
+struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
+					 struct irq_domain_ops *ops);
+struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
+					 unsigned int size,
+					 struct irq_domain_ops *ops);
+struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
+					 struct irq_domain_ops *ops);
+struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
+					 struct irq_domain_ops *ops);
+
+
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
 extern void irq_set_virq_count(unsigned int count);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0220798..5959920 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -22,48 +22,69 @@ static int default_irq_domain_match(struct irq_domain *d, struct device_node *np
 }
 
 /**
- * irq_alloc_host() - Allocate a new irq_domain data structure
+ * irq_domain_alloc() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
  * @revmap_type: type of reverse mapping to use
- * @revmap_arg: for IRQ_DOMAIN_MAP_LINEAR linear only: size of the map
  * @ops: map/unmap domain callbacks
- * @inval_irq: provide a hw number in that domain space that is always invalid
  *
- * Allocates and initialize and irq_domain structure. Note that in the case of
- * IRQ_DOMAIN_MAP_LEGACY, the map() callback will be called before this returns
- * for all legacy interrupts except 0 (which is always the invalid irq for
- * a legacy controller). For a IRQ_DOMAIN_MAP_LINEAR, the map is allocated by
- * this call as well. For a IRQ_DOMAIN_MAP_TREE, the radix tree will be
- * allocated later during boot automatically (the reverse mapping will use the
- * slow path until that happens).
+ * Allocates and initialize and irq_domain structure.  Caller is expected to
+ * register allocated irq_domain with irq_domain_register().  Returns pointer
+ * to IRQ domain, or NULL on failure.
  */
-struct irq_domain *irq_alloc_host(struct device_node *of_node,
-				unsigned int revmap_type,
-				unsigned int revmap_arg,
-				struct irq_domain_ops *ops,
-				irq_hw_number_t inval_irq)
+static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
+					   unsigned int revmap_type,
+					   struct irq_domain_ops *ops)
 {
 	struct irq_domain *domain, *h;
-	unsigned int size = sizeof(struct irq_domain);
-	unsigned int i;
-	unsigned int *rmap;
 
-	/* Allocate structure and revmap table if using linear mapping */
-	if (revmap_type == IRQ_DOMAIN_MAP_LINEAR)
-		size += revmap_arg * sizeof(unsigned int);
-	domain = kzalloc(size, GFP_KERNEL);
-	if (domain == NULL)
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (WARN_ON(!domain))
 		return NULL;
 
 	/* Fill structure */
 	domain->revmap_type = revmap_type;
-	domain->inval_irq = inval_irq;
 	domain->ops = ops;
 	domain->of_node = of_node_get(of_node);
 
 	if (domain->ops->match == NULL)
 		domain->ops->match = default_irq_domain_match;
 
+	return domain;
+}
+
+static struct irq_domain *irq_domain_add(struct device_node *of_node,
+					 unsigned int revmap_type,
+					 struct irq_domain_ops *ops)
+{
+	struct irq_domain *domain = irq_domain_alloc(of_node, revmap_type, ops);
+	if (!domain)
+		return NULL;
+
+	mutex_lock(&irq_domain_mutex);
+	list_add(&domain->link, &irq_domain_list);
+	mutex_unlock(&irq_domain_mutex);
+	pr_debug("irq: Allocated domain of type %d @0x%p\n", revmap_type, domain);
+	return domain;
+}
+
+/**
+ * irq_domain_add_legacy() - Allocate and register a legacy revmap irq_domain.
+ * @of_node: pointer to interrupt controller's device tree node.
+ * @ops: map/unmap domain callbacks
+ *
+ * Note: the map() callback will be called before this function returns
+ * for all legacy interrupts except 0 (which is always the invalid irq for
+ * a legacy controller).
+ */
+struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
+					 struct irq_domain_ops *ops)
+{
+	struct irq_domain *domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LEGACY, ops);
+	unsigned int i;
+
+	if (!domain)
+		return NULL;
+
 	mutex_lock(&irq_domain_mutex);
 	/* Make sure only one legacy controller can be created */
 	if (revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
@@ -79,43 +100,70 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
-	/* Additional setups per revmap type */
-	switch(revmap_type) {
-	case IRQ_DOMAIN_MAP_LEGACY:
-		/* 0 is always the invalid number for legacy */
-		domain->inval_irq = 0;
-		/* setup us as the domain for all legacy interrupts */
-		for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
-			struct irq_data *irq_data = irq_get_irq_data(i);
-			irq_data->hwirq = i;
-			irq_data->domain = domain;
-
-			/* Legacy flags are left to default at this point,
-			 * one can then use irq_create_mapping() to
-			 * explicitly change them
-			 */
-			ops->map(domain, i, i);
-
-			/* Clear norequest flags */
-			irq_clear_status_flags(i, IRQ_NOREQUEST);
-		}
-		break;
-	case IRQ_DOMAIN_MAP_LINEAR:
-		rmap = (unsigned int *)(domain + 1);
-		for (i = 0; i < revmap_arg; i++)
-			rmap[i] = 0;
-		domain->revmap_data.linear.size = revmap_arg;
-		domain->revmap_data.linear.revmap = rmap;
-		break;
-	case IRQ_DOMAIN_MAP_TREE:
-		INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
-		break;
-	default:
-		break;
+	/* setup us as the domain for all legacy interrupts */
+	for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
+		struct irq_data *irq_data = irq_get_irq_data(i);
+		irq_data->hwirq = i;
+		irq_data->domain = domain;
+
+		/* Legacy flags are left to default at this point,
+		 * one can then use irq_create_mapping() to
+		 * explicitly change them
+		 */
+		ops->map(domain, i, i);
+
+		/* Clear norequest flags */
+		irq_clear_status_flags(i, IRQ_NOREQUEST);
 	}
+	return domain;
+}
 
-	pr_debug("irq: Allocated domain of type %d @0x%p\n", revmap_type, domain);
+/**
+ * irq_domain_add_linear() - Allocate and register a legacy revmap irq_domain.
+ * @of_node: pointer to interrupt controller's device tree node.
+ * @ops: map/unmap domain callbacks
+ */
+struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
+					 unsigned int size,
+					 struct irq_domain_ops *ops)
+{
+	struct irq_domain *domain;
+	unsigned int *revmap;
+
+	revmap = kzalloc(sizeof(*revmap) * size, GFP_KERNEL);
+	if (WARN_ON(!revmap))
+		return NULL;
 
+	domain = irq_domain_add(of_node, IRQ_DOMAIN_MAP_LINEAR, ops);
+	if (!domain) {
+		kfree(revmap);
+		return NULL;
+	}
+	domain->revmap_data.linear.size = size;
+	domain->revmap_data.linear.revmap = revmap;
+	return domain;
+}
+
+struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
+					 struct irq_domain_ops *ops)
+{
+	return irq_domain_add(of_node, IRQ_DOMAIN_MAP_NOMAP, ops);
+}
+
+/**
+ * irq_domain_add_tree()
+ * @of_node: pointer to interrupt controller's device tree node.
+ * @ops: map/unmap domain callbacks
+ *
+ * Note: The radix tree will be allocated later during boot automatically
+ * (the reverse mapping will use the slow path until that happens).
+ */
+struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
+					 struct irq_domain_ops *ops)
+{
+	struct irq_domain *domain = irq_domain_add(of_node, IRQ_DOMAIN_MAP_TREE, ops);
+	if (domain)
+		INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
 	return domain;
 }
 
@@ -380,9 +428,6 @@ void irq_dispose_mapping(unsigned int virq)
 		break;
 	}
 
-	/* Destroy map */
-	irq_data->hwirq = domain->inval_irq;
-
 	irq_free_desc(virq);
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
-- 
1.7.5.4

