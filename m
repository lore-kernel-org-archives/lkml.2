Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2HYRmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:42:05 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:60008 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab2HYRls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:41:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170801703"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Jean Delvare (PC drivers core)" <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] i2c: highlander: use devm_ functions
Date: Sat, 25 Aug 2012 19:41:36 +0200
Message-Id: <1345916499-6657-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/i2c/busses/i2c-highlander.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 19515df..794a5ec 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -369,11 +369,13 @@ static int __devinit highlander_i2c_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev = kzalloc(sizeof(struct highlander_i2c_dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct highlander_i2c_dev),
+			   GFP_KERNEL);
 	if (unlikely(!dev))
 		return -ENOMEM;
 
-	dev->base = ioremap_nocache(res->start, resource_size(res));
+	dev->base = devm_ioremap_nocache(&pdev->dev, res->start,
+					 resource_size(res));
 	if (unlikely(!dev->base)) {
 		ret = -ENXIO;
 		goto err;
@@ -387,10 +389,11 @@ static int __devinit highlander_i2c_probe(struct platform_device *pdev)
 		dev->irq = 0;
 
 	if (dev->irq) {
-		ret = request_irq(dev->irq, highlander_i2c_irq, 0,
-				  pdev->name, dev);
+		ret = devm_request_irq(&pdev->dev, dev->irq,
+				       highlander_i2c_irq, 0,
+				       pdev->name, dev);
 		if (unlikely(ret))
-			goto err_unmap;
+			goto err;
 
 		highlander_i2c_irq_enable(dev);
 	} else {
@@ -417,25 +420,18 @@ static int __devinit highlander_i2c_probe(struct platform_device *pdev)
 	ret = highlander_i2c_reset(dev);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "controller didn't come up\n");
-		goto err_free_irq;
+		goto err;
 	}
 
 	ret = i2c_add_numbered_adapter(adap);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
+		goto err;
 	}
 
 	return 0;
 
-err_free_irq:
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-err_unmap:
-	iounmap(dev->base);
 err:
-	kfree(dev);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return ret;
@@ -447,12 +443,6 @@ static int __devexit highlander_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&dev->adapter);
 
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-
-	iounmap(dev->base);
-	kfree(dev);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;

