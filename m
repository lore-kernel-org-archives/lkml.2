Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2CKUMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 16:12:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34027 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2CKUMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 16:12:16 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        wharms@bfs.de, w.sang@pengutronix.de, agust@denx.de
Subject: [PATCH v3] drivers/ata/pata_mpc52xx.c: clean up error handling code
Date: Sun, 11 Mar 2012 21:12:09 +0100
Message-Id: <1331496729-12850-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This patch makes a number of changes with respect to the error-handling
code:

* Remove cleanup calls for the devm functions in both the error handling
  code and the remove function.  This cleanup is done automatically.

* The previous change simplifies the cleanup code at the end of the
  function such that there is nothing to do on the failure of the call to
  devm_ioremap.  So it is changed to just return directly.

* There is no need for the ifs in the cleanup code at the end of the
  function, because in each case the cleanup needed is statically
  known.  Drop the ifs, add new err labels, and drop the initializations of
  the tested variables to NULL.

* Change the call to request_irq to a call to devm_request_irq, so that it
  is cleaned up on exit.

* Cause the return value of devm_request_irq to go into the returned
  variable rv rather than the unused variable ret.  Drop ret.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
This subsumes the previous patch that only removed the calls to the devm
cleanup functions.  It is not tested.  I am not sure about the correctness
of the use of devm_request_irq, since there were no calls to free_irq
before.  I also don't know if there was a reason for not returning the
return value of request_irq previously.

 drivers/ata/pata_mpc52xx.c |   44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 00748ae..d2c102f 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -687,11 +687,11 @@ mpc52xx_ata_probe(struct platform_device *op)
 	int ata_irq = 0;
 	struct mpc52xx_ata __iomem *ata_regs;
 	struct mpc52xx_ata_priv *priv = NULL;
-	int rv, ret, task_irq = 0;
+	int rv, task_irq;
 	int mwdma_mask = 0, udma_mask = 0;
 	const __be32 *prop;
 	int proplen;
-	struct bcom_task *dmatsk = NULL;
+	struct bcom_task *dmatsk;
 
 	/* Get ipb frequency */
 	ipb_freq = mpc5xxx_get_bus_frequency(op->dev.of_node);
@@ -717,8 +717,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	ata_regs = devm_ioremap(&op->dev, res_mem.start, sizeof(*ata_regs));
 	if (!ata_regs) {
 		dev_err(&op->dev, "error mapping device registers\n");
-		rv = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	/*
@@ -753,7 +752,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	if (!priv) {
 		dev_err(&op->dev, "error allocating private structure\n");
 		rv = -ENOMEM;
-		goto err;
+		goto err1;
 	}
 
 	priv->ipb_period = 1000000000 / (ipb_freq / 1000);
@@ -776,15 +775,15 @@ mpc52xx_ata_probe(struct platform_device *op)
 	if (!dmatsk) {
 		dev_err(&op->dev, "bestcomm initialization failed\n");
 		rv = -ENOMEM;
-		goto err;
+		goto err1;
 	}
 
 	task_irq = bcom_get_task_irq(dmatsk);
-	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, 0,
+	rv = devm_request_irq(&op->dev, task_irq, &mpc52xx_ata_task_irq, 0,
 				"ATA task", priv);
-	if (ret) {
+	if (rv) {
 		dev_err(&op->dev, "error requesting DMA IRQ\n");
-		goto err;
+		goto err2;
 	}
 	priv->dmatsk = dmatsk;
 
@@ -792,7 +791,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	rv = mpc52xx_ata_hw_init(priv);
 	if (rv) {
 		dev_err(&op->dev, "error initializing hardware\n");
-		goto err;
+		goto err2;
 	}
 
 	/* Register ourselves to libata */
@@ -800,23 +799,16 @@ mpc52xx_ata_probe(struct platform_device *op)
 				  mwdma_mask, udma_mask);
 	if (rv) {
 		dev_err(&op->dev, "error registering with ATA layer\n");
-		goto err;
+		goto err2;
 	}
 
 	return 0;
 
- err:
-	devm_release_mem_region(&op->dev, res_mem.start, sizeof(*ata_regs));
-	if (ata_irq)
-		irq_dispose_mapping(ata_irq);
-	if (task_irq)
-		irq_dispose_mapping(task_irq);
-	if (dmatsk)
-		bcom_ata_release(dmatsk);
-	if (ata_regs)
-		devm_iounmap(&op->dev, ata_regs);
-	if (priv)
-		devm_kfree(&op->dev, priv);
+ err2:
+	irq_dispose_mapping(task_irq);
+	bcom_ata_release(dmatsk);
+ err1:
+	irq_dispose_mapping(ata_irq);
 	return rv;
 }
 
@@ -835,12 +827,6 @@ mpc52xx_ata_remove(struct platform_device *op)
 	bcom_ata_release(priv->dmatsk);
 	irq_dispose_mapping(priv->ata_irq);
 
-	/* Clear up IO allocations */
-	devm_iounmap(&op->dev, priv->ata_regs);
-	devm_release_mem_region(&op->dev, priv->ata_regs_pa,
-				sizeof(*priv->ata_regs));
-	devm_kfree(&op->dev, priv);
-
 	return 0;
 }
 

