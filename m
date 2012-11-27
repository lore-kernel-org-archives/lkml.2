Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2K0R3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:29:39 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:53463 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab2K0R3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:29:37 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/uio/uio_pdrv_genirq.c: Fix memory leak & confusing labels
Date: Tue, 27 Nov 2012 19:29:32 +0200
User-Agent: KMail/1.9.10
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211271929.32315.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory leak was caused by jumping to the wrong exit label. So, it is good time
to improve misleading label names too.

Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
---
 drivers/uio/uio_pdrv_genirq.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 42202cd..b88cf7b 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -110,7 +110,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		if (!uioinfo) {
 			ret = -ENOMEM;
 			dev_err(&pdev->dev, "unable to kmalloc\n");
-			goto bad2;
+			goto out;
 		}
 		uioinfo->name = pdev->dev.of_node->name;
 		uioinfo->version = "devicetree";
@@ -125,20 +125,20 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 
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
@@ -150,7 +150,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		ret = platform_get_irq(pdev, 0);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad0;
+			goto out_priv;
 		}
 		uioinfo->irq = ret;
 	}
@@ -205,19 +205,20 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
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
+out_priv:
+	kfree(priv);
+out_uioinfo:
 	/* kfree uioinfo for OF */
 	if (pdev->dev.of_node)
 		kfree(uioinfo);
- bad2:
+out:
 	return ret;
 }
 
-- 
1.7.8.6
