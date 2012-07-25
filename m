Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2GYMI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:08:58 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39957 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956Ab2GYMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:08:55 -0400
From: Felipe Balbi <balbi@ti.com>
To: zbr@ioremap.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 4/6] w1: omap-hdq: convert to devm_* functions
Date: Wed, 25 Jul 2012 15:05:30 +0300
Message-Id: <1343217932-25372-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.11
In-Reply-To: <1343217932-25372-1-git-send-email-balbi@ti.com>
References: <1343217932-25372-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this lets us remove a bit of boilerplate code.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/w1/masters/omap_hdq.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 1ebddcf..b6eb0ba 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -546,33 +546,31 @@ static void omap_w1_write_byte(void *_hdq, u8 byte)
 
 static int __devinit omap_hdq_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct hdq_data *hdq_data;
 	struct resource *res;
 	int ret, irq;
 	u8 rev;
 
-	hdq_data = kmalloc(sizeof(*hdq_data), GFP_KERNEL);
+	hdq_data = devm_kzalloc(dev, sizeof(*hdq_data), GFP_KERNEL);
 	if (!hdq_data) {
 		dev_dbg(&pdev->dev, "unable to allocate memory\n");
-		ret = -ENOMEM;
-		goto err_kmalloc;
+		return -ENOMEM;
 	}
 
-	hdq_data->dev = &pdev->dev;
+	hdq_data->dev = dev;
 	platform_set_drvdata(pdev, hdq_data);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_dbg(&pdev->dev, "unable to get resource\n");
-		ret = -ENXIO;
-		goto err_resource;
+		return -ENXIO;
 	}
 
-	hdq_data->hdq_base = ioremap(res->start, resource_size(res));
+	hdq_data->hdq_base = devm_request_and_ioremap(dev, res);
 	if (!hdq_data->hdq_base) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
-		ret = -EINVAL;
-		goto err_ioremap;
+		return -ENOMEM;
 	}
 
 	hdq_data->hdq_usecount = 0;
@@ -593,7 +591,8 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	ret = request_irq(irq, hdq_isr, IRQF_DISABLED, "omap_hdq", hdq_data);
+	ret = devm_request_irq(dev, irq, hdq_isr, IRQF_DISABLED,
+			"omap_hdq", hdq_data);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "could not request irq\n");
 		goto err_irq;
@@ -618,16 +617,7 @@ err_irq:
 err_w1:
 	pm_runtime_disable(&pdev->dev);
 
-	iounmap(hdq_data->hdq_base);
-
-err_ioremap:
-err_resource:
-	platform_set_drvdata(pdev, NULL);
-	kfree(hdq_data);
-
-err_kmalloc:
 	return ret;
-
 }
 
 static int __devexit omap_hdq_remove(struct platform_device *pdev)
@@ -646,10 +636,6 @@ static int __devexit omap_hdq_remove(struct platform_device *pdev)
 
 	/* remove module dependency */
 	pm_runtime_disable(&pdev->dev);
-	free_irq(INT_24XX_HDQ_IRQ, hdq_data);
-	platform_set_drvdata(pdev, NULL);
-	iounmap(hdq_data->hdq_base);
-	kfree(hdq_data);
 
 	return 0;
 }
-- 
1.7.11

