Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2K2Lrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:47:37 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:46440 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2K2Lre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:47:34 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Date: Thu, 29 Nov 2012 13:47:28 +0200
User-Agent: KMail/1.9.10
Cc: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271929.32315.vitas@nppfactor.kiev.ua> <201211281137.23623.vitas@nppfactor.kiev.ua> <20121128211407.GC2590@local>
In-Reply-To: <20121128211407.GC2590@local>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [PATCH] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing issues
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211291347.28273.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. uioinfo was kfreed based on the presence of pdev->dev.of_node, which was
obviously wrong and unrelated to the fact if uioinfo was allocated statically
or dynamically. This patch introduces new flag which clearly shows if uioinfo
was allocated dynamically and kfrees uioinfo based on that flag;
2. Fix: priv data was not freed in case platform_get_irq() failed. As it was
caused mainly by improper exit labels naming, labels were renamed too;
3. The case of uioinfo AND pdev->dev.of_node both NULL (not initialized
in platform data) was not treated properly.

Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
---
 drivers/uio/uio_pdrv_genirq.c |   44 ++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 42202cd..45126e3 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -30,6 +30,11 @@
 
 #define DRIVER_NAME "uio_pdrv_genirq"
 
+enum {
+	bitIRQDisabled = 0,
+	bitUioinfoAlloced = 1,
+};
+
 struct uio_pdrv_genirq_platdata {
 	struct uio_info *uioinfo;
 	spinlock_t lock;
@@ -63,7 +68,7 @@ static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
 	 * remember the state so we can allow user space to enable it later.
 	 */
 
-	if (!test_and_set_bit(0, &priv->flags))
+	if (!test_and_set_bit(bitIRQDisabled, &priv->flags))
 		disable_irq_nosync(irq);
 
 	return IRQ_HANDLED;
@@ -83,10 +88,10 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (irq_on) {
-		if (test_and_clear_bit(0, &priv->flags))
+		if (test_and_clear_bit(bitIRQDisabled, &priv->flags))
 			enable_irq(dev_info->irq);
 	} else {
-		if (!test_and_set_bit(0, &priv->flags))
+		if (!test_and_set_bit(bitIRQDisabled, &priv->flags))
 			disable_irq(dev_info->irq);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -101,8 +106,9 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	struct uio_mem *uiomem;
 	int ret = -EINVAL;
 	int i;
+	bool uioinfo_alloced = false;
 
-	if (!uioinfo) {
+	if (!uioinfo && pdev->dev.of_node) {
 		int irq;
 
 		/* alloc uioinfo for one device */
@@ -110,10 +116,11 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		if (!uioinfo) {
 			ret = -ENOMEM;
 			dev_err(&pdev->dev, "unable to kmalloc\n");
-			goto bad2;
+			goto out;
 		}
 		uioinfo->name = pdev->dev.of_node->name;
 		uioinfo->version = "devicetree";
+		uioinfo_alloced = true;
 
 		/* Multiple IRQs are not supported */
 		irq = platform_get_irq(pdev, 0);
@@ -125,32 +132,33 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 
 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
 		dev_err(&pdev->dev, "missing platform_data\n");
-		goto bad0;
+		goto out_uioinfo;
 	}
 
 	if (uioinfo->handler || uioinfo->irqcontrol ||
 	    uioinfo->irq_flags & IRQF_SHARED) {
 		dev_err(&pdev->dev, "interrupt configuration error\n");
-		goto bad0;
+		goto out_uioinfo;
 	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
 		dev_err(&pdev->dev, "unable to kmalloc\n");
-		goto bad0;
+		goto out_uioinfo;
 	}
 
 	priv->uioinfo = uioinfo;
 	spin_lock_init(&priv->lock);
-	priv->flags = 0; /* interrupt is enabled to begin with */
+	/* interrupt is enabled to begin with */
+	priv->flags = uioinfo_alloced ? (1 << bitUioinfoAlloced) : 0;
 	priv->pdev = pdev;
 
 	if (!uioinfo->irq) {
 		ret = platform_get_irq(pdev, 0);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad0;
+			goto out_priv;
 		}
 		uioinfo->irq = ret;
 	}
@@ -205,19 +213,19 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	ret = uio_register_device(&pdev->dev, priv->uioinfo);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to register uio device\n");
-		goto bad1;
+		goto out_pm;
 	}
 
 	platform_set_drvdata(pdev, priv);
 	return 0;
- bad1:
-	kfree(priv);
+out_pm:
 	pm_runtime_disable(&pdev->dev);
- bad0:
-	/* kfree uioinfo for OF */
-	if (pdev->dev.of_node)
+out_priv:
+	kfree(priv);
+out_uioinfo:
+	if (uioinfo_alloced)
 		kfree(uioinfo);
- bad2:
+out:
 	return ret;
 }
 
@@ -232,7 +240,7 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 	priv->uioinfo->irqcontrol = NULL;
 
 	/* kfree uioinfo for OF */
-	if (pdev->dev.of_node)
+	if (priv->flags & (1 << bitUioinfoAlloced))
 		kfree(priv->uioinfo);
 
 	kfree(priv);
-- 
1.7.8.6
