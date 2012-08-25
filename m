Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab2HYRmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:42:44 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:60008 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388Ab2HYRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:41:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170801706"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Sekhar Nori <nsekhar@ti.com>
Cc: kernel-janitors@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] i2c: davinci: use devm_ functions
Date: Sat, 25 Aug 2012 19:41:39 +0200
Message-Id: <1345916499-6657-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

The call to platform_get_resource is moved down to the call to
devm_request_and_ioremap that uses it.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.
I was not sure what to do with the comment on the first line, so I just
left it where it is.
I was also concerned about the calls to get_device and put_device, and
whether they would cause &pdev->dev to be freed before the devm-allocated
objects were freed.  Most other platform drivers don't seem to have these
calls.

 drivers/i2c/busses/i2c-davinci.c |   51 +++++++++------------------------------
 1 file changed, 12 insertions(+), 39 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index b6185dc..c8e9c87 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -647,30 +647,16 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	int r;
 
 	/* NOTE: driver uses the static register mapping */
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "no mem resource?\n");
-		return -ENODEV;
-	}
-
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "no irq resource?\n");
 		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start, resource_size(mem),
-				    pdev->name);
-	if (!ioarea) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -EBUSY;
-	}
-
-	dev = kzalloc(sizeof(struct davinci_i2c_dev), GFP_KERNEL);
-	if (!dev) {
-		r = -ENOMEM;
-		goto err_release_region;
-	}
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_i2c_dev),
+			   GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
 
 	init_completion(&dev->cmd_complete);
 #ifdef CONFIG_CPU_FREQ
@@ -699,14 +685,15 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		dev->pdata = &davinci_i2c_platform_data_default;
 	}
 
-	dev->clk = clk_get(&pdev->dev, NULL);
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
 		r = -ENODEV;
 		goto err_free_mem;
 	}
 	clk_enable(dev->clk);
 
-	dev->base = ioremap(mem->start, resource_size(mem));
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!dev->base) {
 		r = -EBUSY;
 		goto err_mem_ioremap;
@@ -714,16 +701,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 
 	i2c_davinci_init(dev);
 
-	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
+	r = devm_request_irq(&pdev->dev, dev->irq, i2c_davinci_isr, 0,
+			     pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
-		goto err_unuse_clocks;
+		goto err_mem_ioremap;
 	}
 
 	r = i2c_davinci_cpufreq_register(dev);
 	if (r) {
 		dev_err(&pdev->dev, "failed to register cpufreq\n");
-		goto err_free_irq;
+		goto err_mem_ioremap;
 	}
 
 	adap = &dev->adapter;
@@ -740,26 +728,18 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
 		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
+		goto err_mem_ioremap;
 	}
 	of_i2c_register_devices(adap);
 
 	return 0;
 
-err_free_irq:
-	free_irq(dev->irq, dev);
-err_unuse_clocks:
-	iounmap(dev->base);
 err_mem_ioremap:
 	clk_disable(dev->clk);
-	clk_put(dev->clk);
 	dev->clk = NULL;
 err_free_mem:
 	platform_set_drvdata(pdev, NULL);
 	put_device(&pdev->dev);
-	kfree(dev);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
 
 	return r;
 }
@@ -767,7 +747,6 @@ err_release_region:
 static int davinci_i2c_remove(struct platform_device *pdev)
 {
 	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
-	struct resource *mem;
 
 	i2c_davinci_cpufreq_deregister(dev);
 
@@ -776,16 +755,10 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 	put_device(&pdev->dev);
 
 	clk_disable(dev->clk);
-	clk_put(dev->clk);
 	dev->clk = NULL;
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
-	free_irq(dev->irq, dev);
-	iounmap(dev->base);
-	kfree(dev);
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 

