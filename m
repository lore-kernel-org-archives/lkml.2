Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2LFWPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:15:32 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:42012 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab2LFWPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:15:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,233,1355094000"; 
   d="scan'208";a="185000425"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/w1/masters/ds1wm.c: use devm_ functions
Date: Fri,  7 Dec 2012 00:15:23 +0100
Message-Id: <1354835724-26945-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/w1/masters/ds1wm.c |   52 +++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 7c294f4..96cab6a 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
@@ -459,43 +460,34 @@ static int ds1wm_probe(struct platform_device *pdev)
 	if (!pdev)
 		return -ENODEV;
 
-	ds1wm_data = kzalloc(sizeof(*ds1wm_data), GFP_KERNEL);
+	ds1wm_data = devm_kzalloc(&pdev->dev, sizeof(*ds1wm_data), GFP_KERNEL);
 	if (!ds1wm_data)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, ds1wm_data);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENXIO;
-		goto err0;
-	}
-	ds1wm_data->map = ioremap(res->start, resource_size(res));
-	if (!ds1wm_data->map) {
-		ret = -ENOMEM;
-		goto err0;
-	}
+	if (!res)
+		return -ENXIO;
+	ds1wm_data->map = devm_ioremap(&pdev->dev, res->start,
+				       resource_size(res));
+	if (!ds1wm_data->map)
+		return -ENOMEM;
 
 	/* calculate bus shift from mem resource */
 	ds1wm_data->bus_shift = resource_size(res) >> 3;
 
 	ds1wm_data->pdev = pdev;
 	ds1wm_data->cell = mfd_get_cell(pdev);
-	if (!ds1wm_data->cell) {
-		ret = -ENODEV;
-		goto err1;
-	}
+	if (!ds1wm_data->cell)
+		return -ENODEV;
 	plat = pdev->dev.platform_data;
-	if (!plat) {
-		ret = -ENODEV;
-		goto err1;
-	}
+	if (!plat)
+		return -ENODEV;
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		ret = -ENXIO;
-		goto err1;
-	}
+	if (!res)
+		return -ENXIO;
 	ds1wm_data->irq = res->start;
 	ds1wm_data->int_en_reg_none = (plat->active_high ? DS1WM_INTEN_IAS : 0);
 	ds1wm_data->reset_recover_delay = plat->reset_recover_delay;
@@ -505,10 +497,10 @@ static int ds1wm_probe(struct platform_device *pdev)
 	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
-	ret = request_irq(ds1wm_data->irq, ds1wm_isr,
+	ret = devm_request_irq(&pdev->dev, ds1wm_data->irq, ds1wm_isr,
 			IRQF_DISABLED | IRQF_SHARED, "ds1wm", ds1wm_data);
 	if (ret)
-		goto err1;
+		return ret;
 
 	ds1wm_up(ds1wm_data);
 
@@ -516,17 +508,12 @@ static int ds1wm_probe(struct platform_device *pdev)
 
 	ret = w1_add_master_device(&ds1wm_master);
 	if (ret)
-		goto err2;
+		goto err;
 
 	return 0;
 
-err2:
+err:
 	ds1wm_down(ds1wm_data);
-	free_irq(ds1wm_data->irq, ds1wm_data);
-err1:
-	iounmap(ds1wm_data->map);
-err0:
-	kfree(ds1wm_data);
 
 	return ret;
 }
@@ -560,9 +547,6 @@ static int ds1wm_remove(struct platform_device *pdev)
 
 	w1_remove_master_device(&ds1wm_master);
 	ds1wm_down(ds1wm_data);
-	free_irq(ds1wm_data->irq, ds1wm_data);
-	iounmap(ds1wm_data->map);
-	kfree(ds1wm_data);
 
 	return 0;
 }

