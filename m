Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2FNKXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:23:36 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38601 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659Ab2FNKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:32 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 11/17] i2c: omap: switch to devm_* API
Date: Thu, 14 Jun 2012 13:20:44 +0300
Message-Id: <1339669250-9183-12-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that helps deleting some boiler plate code
and lets driver-core manage our resources
for us.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   43 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index c20c45f..d805270 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1045,7 +1045,7 @@ omap_i2c_probe(struct platform_device *pdev)
 {
 	struct omap_i2c_dev	*dev;
 	struct i2c_adapter	*adap;
-	struct resource		*mem, *irq, *ioarea;
+	struct resource		*mem, *irq;
 	struct omap_i2c_bus_platform_data *pdata = pdev->dev.platform_data;
 	struct device_node	*node = pdev->dev.of_node;
 	const struct of_device_id *match;
@@ -1058,23 +1058,17 @@ omap_i2c_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "no mem resource?\n");
 		return -ENODEV;
 	}
+
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "no irq resource?\n");
 		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start, resource_size(mem),
-			pdev->name);
-	if (!ioarea) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -EBUSY;
-	}
-
-	dev = kzalloc(sizeof(struct omap_i2c_dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct omap_i2c_dev), GFP_KERNEL);
 	if (!dev) {
-		r = -ENOMEM;
-		goto err_release_region;
+		dev_err(&pdev->dev, "not enough memory\n");
+		return -ENOMEM;
 	}
 
 	match = of_match_device(of_match_ptr(omap_i2c_of_match), &pdev->dev);
@@ -1097,10 +1091,10 @@ omap_i2c_probe(struct platform_device *pdev)
 
 	dev->dev = &pdev->dev;
 	dev->irq = irq->start;
-	dev->base = ioremap(mem->start, resource_size(mem));
+	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!dev->base) {
-		r = -ENOMEM;
-		goto err_free_mem;
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, dev);
@@ -1151,7 +1145,7 @@ omap_i2c_probe(struct platform_device *pdev)
 
 	isr = (dev->rev < OMAP_I2C_OMAP1_REV_2) ? omap_i2c_omap1_isr :
 								   omap_i2c_isr;
-	r = request_irq(dev->irq, isr, 0, pdev->name, dev);
+	r = devm_request_irq(&pdev->dev, dev->irq, isr, 0, pdev->name, dev);
 
 	if (r) {
 		dev_err(dev->dev, "failure requesting irq %i\n", dev->irq);
@@ -1177,24 +1171,16 @@ omap_i2c_probe(struct platform_device *pdev)
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
 		dev_err(dev->dev, "failure adding adapter\n");
-		goto err_free_irq;
+		goto err_unuse_clocks;
 	}
 
 	of_i2c_register_devices(adap);
 
 	return 0;
 
-err_free_irq:
-	free_irq(dev->irq, dev);
 err_unuse_clocks:
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
 	pm_runtime_put(dev->dev);
-	iounmap(dev->base);
-err_free_mem:
-	platform_set_drvdata(pdev, NULL);
-	kfree(dev);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
 
 	return r;
 }
@@ -1203,17 +1189,10 @@ static int
 omap_i2c_remove(struct platform_device *pdev)
 {
 	struct omap_i2c_dev	*dev = platform_get_drvdata(pdev);
-	struct resource		*mem;
 
-	platform_set_drvdata(pdev, NULL);
-
-	free_irq(dev->irq, dev);
 	i2c_del_adapter(&dev->adapter);
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
-	iounmap(dev->base);
-	kfree(dev);
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
+
 	return 0;
 }
 
-- 
1.7.10.4

