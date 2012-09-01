Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2IAQeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 12:34:46 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:46619
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327Ab2IAQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 12:33:41 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="154399778"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers/mtd/nand/mpc5121_nfc.c: some devm_ cleanups
Date: Sat,  1 Sep 2012 18:33:10 +0200
Message-Id: <1346517191-8794-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm free functions should not have to be explicitly used.

The only thing left that is useful in the function mpc5121_nfc_free is the
call to clk_disable, which is moved to the call sites.

This function also incorrectly called iounmap on devm_ioremap allocated
data.

Use devm_request_and_ioremap in place of devm_request_mem_region and
devm_ioremap.

Use devm_clk_get.

A semantic match that finds the first problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

(
* devm_kfree(...);
|
* devm_free_irq(...);
|
* devm_iounmap(...);
|
* devm_release_region(...);
|
* devm_release_mem_region(...);
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/nand/mpc5121_nfc.c |   35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index c259c24..45183ba 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -632,21 +632,6 @@ out:
 	return ret;
 }
 
-/* Free driver resources */
-static void mpc5121_nfc_free(struct device *dev, struct mtd_info *mtd)
-{
-	struct nand_chip *chip = mtd->priv;
-	struct mpc5121_nfc_prv *prv = chip->priv;
-
-	if (prv->clk) {
-		clk_disable(prv->clk);
-		clk_put(prv->clk);
-	}
-
-	if (prv->csreg)
-		iounmap(prv->csreg);
-}
-
 static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 {
 	struct device_node *rootnode, *dn = op->dev.of_node;
@@ -713,12 +698,7 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	regs_paddr = res.start;
 	regs_size = resource_size(&res);
 
-	if (!devm_request_mem_region(dev, regs_paddr, regs_size, DRV_NAME)) {
-		dev_err(dev, "Error requesting memory region!\n");
-		return -EBUSY;
-	}
-
-	prv->regs = devm_ioremap(dev, regs_paddr, regs_size);
+	prv->regs = devm_request_and_ioremap(dev, &res);
 	if (!prv->regs) {
 		dev_err(dev, "Error mapping memory region!\n");
 		return -ENOMEM;
@@ -752,11 +732,10 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	of_node_put(rootnode);
 
 	/* Enable NFC clock */
-	prv->clk = clk_get(dev, "nfc_clk");
+	prv->clk = devm_clk_get(dev, "nfc_clk");
 	if (IS_ERR(prv->clk)) {
 		dev_err(dev, "Unable to acquire NFC clock!\n");
-		retval = PTR_ERR(prv->clk);
-		goto error;
+		return PTR_ERR(prv->clk);
 	}
 
 	clk_enable(prv->clk);
@@ -803,7 +782,6 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	/* Detect NAND chips */
 	if (nand_scan(mtd, be32_to_cpup(chips_no))) {
 		dev_err(dev, "NAND Flash not found !\n");
-		devm_free_irq(dev, prv->irq, mtd);
 		retval = -ENXIO;
 		goto error;
 	}
@@ -828,7 +806,6 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 
 	default:
 		dev_err(dev, "Unsupported NAND flash!\n");
-		devm_free_irq(dev, prv->irq, mtd);
 		retval = -ENXIO;
 		goto error;
 	}
@@ -839,13 +816,12 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	retval = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
 	if (retval) {
 		dev_err(dev, "Error adding MTD device!\n");
-		devm_free_irq(dev, prv->irq, mtd);
 		goto error;
 	}
 
 	return 0;
 error:
-	mpc5121_nfc_free(dev, mtd);
+	clk_disable(prv->clk);
 	return retval;
 }
 
@@ -857,8 +833,7 @@ static int __devexit mpc5121_nfc_remove(struct platform_device *op)
 	struct mpc5121_nfc_prv *prv = chip->priv;
 
 	nand_release(mtd);
-	devm_free_irq(dev, prv->irq, mtd);
-	mpc5121_nfc_free(dev, mtd);
+	clk_disable(prv->clk);
 
 	return 0;
 }

