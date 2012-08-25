Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2HYRl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:41:56 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:17793 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367Ab2HYRlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:41:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170801705"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Jean Delvare (PC drivers core)" <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] i2c: at91: use devm_ functions
Date: Sat, 25 Aug 2012 19:41:38 +0200
Message-Id: <1345916499-6657-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

This code was missing a free of adapter in the remove function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/i2c/busses/i2c-at91.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index e24484b..b921858 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -196,30 +196,23 @@ static int __devinit at91_i2c_probe(struct platform_device *pdev)
 	int rc;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
 
-	if (!request_mem_region(res->start, resource_size(res), "at91_i2c"))
-		return -EBUSY;
-
-	twi_base = ioremap(res->start, resource_size(res));
-	if (!twi_base) {
-		rc = -ENOMEM;
-		goto fail0;
-	}
+	twi_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!twi_base)
+		return -ENOMEM;
 
 	twi_clk = clk_get(NULL, "twi_clk");
 	if (IS_ERR(twi_clk)) {
 		dev_err(&pdev->dev, "no clock defined\n");
-		rc = -ENODEV;
-		goto fail1;
+		return -ENODEV;
 	}
 
-	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	adapter = devm_kzalloc(&pdev->dev, sizeof(struct i2c_adapter),
+			       GFP_KERNEL);
 	if (adapter == NULL) {
 		dev_err(&pdev->dev, "can't allocate inteface!\n");
 		rc = -ENOMEM;
-		goto fail2;
+		goto fail1;
 	}
 	snprintf(adapter->name, sizeof(adapter->name), "AT91");
 	adapter->algo = &at91_algorithm;
@@ -236,22 +229,17 @@ static int __devinit at91_i2c_probe(struct platform_device *pdev)
 	if (rc) {
 		dev_err(&pdev->dev, "Adapter %s registration failed\n",
 				adapter->name);
-		goto fail3;
+		goto fail2;
 	}
 
 	dev_info(&pdev->dev, "AT91 i2c bus driver.\n");
 	return 0;
 
-fail3:
+fail2:
 	platform_set_drvdata(pdev, NULL);
-	kfree(adapter);
 	clk_disable(twi_clk);
-fail2:
-	clk_put(twi_clk);
 fail1:
-	iounmap(twi_base);
-fail0:
-	release_mem_region(res->start, resource_size(res));
+	clk_put(twi_clk);
 
 	return rc;
 }
@@ -259,16 +247,11 @@ fail0:
 static int __devexit at91_i2c_remove(struct platform_device *pdev)
 {
 	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
-	struct resource *res;
 	int rc;
 
 	rc = i2c_del_adapter(adapter);
 	platform_set_drvdata(pdev, NULL);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	iounmap(twi_base);
-	release_mem_region(res->start, resource_size(res));
-
 	clk_disable(twi_clk);		/* disable peripheral clock */
 	clk_put(twi_clk);
 

