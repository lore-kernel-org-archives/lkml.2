Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2AXNA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:00:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35670 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab2AXNAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 08:00:53 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/omap2/dss: use devm_ functions
Date: Tue, 24 Jan 2012 14:00:45 +0100
Message-Id: <1327410045-3906-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1327410045-3906-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1327410045-3906-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/video/omap2/dss/dispc.c |   16 ++++++----------
 drivers/video/omap2/dss/dsi.c   |   28 +++++++++-------------------
 drivers/video/omap2/dss/dss.c   |    9 +++------
 drivers/video/omap2/dss/rfbi.c  |    5 ++---
 drivers/video/omap2/dss/venc.c  |    8 +++-----
 5 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
index a5ec7f3..6fa866a 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -3322,7 +3322,8 @@ static int omap_dispchw_probe(struct platform_device *pdev)
 		r = -EINVAL;
 		goto err_ioremap;
 	}
-	dispc.base = ioremap(dispc_mem->start, resource_size(dispc_mem));
+	dispc.base = devm_ioremap(&pdev->dev, dispc_mem->start,
+				  resource_size(dispc_mem));
 	if (!dispc.base) {
 		DSSERR("can't ioremap DISPC\n");
 		r = -ENOMEM;
@@ -3332,14 +3333,14 @@ static int omap_dispchw_probe(struct platform_device *pdev)
 	if (dispc.irq < 0) {
 		DSSERR("platform_get_irq failed\n");
 		r = -ENODEV;
-		goto err_irq;
+		goto err_ioremap;
 	}
 
-	r = request_irq(dispc.irq, omap_dispc_irq_handler, IRQF_SHARED,
-		"OMAP DISPC", dispc.pdev);
+	r = devm_request_irq(&pdev->dev, dispc.irq, omap_dispc_irq_handler,
+			     IRQF_SHARED, "OMAP DISPC", dispc.pdev);
 	if (r < 0) {
 		DSSERR("request_irq failed\n");
-		goto err_irq;
+		goto err_ioremap;
 	}
 
 	pm_runtime_enable(&pdev->dev);
@@ -3362,9 +3363,6 @@ static int omap_dispchw_probe(struct platform_device *pdev)
 
 err_runtime_get:
 	pm_runtime_disable(&pdev->dev);
-	free_irq(dispc.irq, dispc.pdev);
-err_irq:
-	iounmap(dispc.base);
 err_ioremap:
 	clk_put(dispc.dss_clk);
 err_get_clk:
@@ -3377,8 +3375,6 @@ static int omap_dispchw_remove(struct platform_device *pdev)
 
 	clk_put(dispc.dss_clk);
 
-	free_irq(dispc.irq, dispc.pdev);
-	iounmap(dispc.base);
 	return 0;
 }
 
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/omap2/dss/dsi.c
index d4d676c..52b9359 100644
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -4695,7 +4695,7 @@ static int omap_dsihw_probe(struct platform_device *dsidev)
 	struct resource *dsi_mem;
 	struct dsi_data *dsi;
 
-	dsi = kzalloc(sizeof(*dsi), GFP_KERNEL);
+	dsi = devm_kzalloc(&dsidev->dev, sizeof(*dsi), GFP_KERNEL);
 	if (!dsi) {
 		r = -ENOMEM;
 		goto err_alloc;
@@ -4724,7 +4724,7 @@ static int omap_dsihw_probe(struct platform_device *dsidev)
 
 	r = dsi_get_clocks(dsidev);
 	if (r)
-		goto err_get_clk;
+		goto err_alloc;
 
 	pm_runtime_enable(&dsidev->dev);
 
@@ -4742,7 +4742,8 @@ static int omap_dsihw_probe(struct platform_device *dsidev)
 		r = -EINVAL;
 		goto err_ioremap;
 	}
-	dsi->base = ioremap(dsi_mem->start, resource_size(dsi_mem));
+	dsi->base = devm_ioremap(&dsidev->dev, dsi_mem->start,
+				 resource_size(dsi_mem));
 	if (!dsi->base) {
 		DSSERR("can't ioremap DSI\n");
 		r = -ENOMEM;
@@ -4752,14 +4753,14 @@ static int omap_dsihw_probe(struct platform_device *dsidev)
 	if (dsi->irq < 0) {
 		DSSERR("platform_get_irq failed\n");
 		r = -ENODEV;
-		goto err_get_irq;
+		goto err_ioremap;
 	}
 
-	r = request_irq(dsi->irq, omap_dsi_irq_handler, IRQF_SHARED,
-		dev_name(&dsidev->dev), dsi->pdev);
+	r = devm_request_irq(&dsidev->dev, dsi->irq, omap_dsi_irq_handler,
+			     IRQF_SHARED, dev_name(&dsidev->dev), dsi->pdev);
 	if (r < 0) {
 		DSSERR("request_irq failed\n");
-		goto err_get_irq;
+		goto err_ioremap;
 	}
 
 	/* DSI VCs initialization */
@@ -4773,7 +4774,7 @@ static int omap_dsihw_probe(struct platform_device *dsidev)
 
 	r = dsi_runtime_get(dsidev);
 	if (r)
-		goto err_get_dsi;
+		goto err_ioremap;
 
 	rev = dsi_read_reg(dsidev, DSI_REVISION);
 	dev_dbg(&dsidev->dev, "OMAP DSI rev %d.%d\n",
@@ -4791,14 +4792,8 @@ static int omap_dsihw_probe(struct platform_device *dsidev)
 
 	return 0;
 
-err_get_dsi:
-	free_irq(dsi->irq, dsi->pdev);
-err_get_irq:
-	iounmap(dsi->base);
 err_ioremap:
 	pm_runtime_disable(&dsidev->dev);
-err_get_clk:
-	kfree(dsi);
 err_alloc:
 	return r;
 }
@@ -4823,11 +4818,6 @@ static int omap_dsihw_remove(struct platform_device *dsidev)
 		dsi->vdds_dsi_reg = NULL;
 	}
 
-	free_irq(dsi->irq, dsi->pdev);
-	iounmap(dsi->base);
-
-	kfree(dsi);
-
 	return 0;
 }
 
diff --git a/drivers/video/omap2/dss/dss.c b/drivers/video/omap2/dss/dss.c
index 1703345..e75f837 100644
--- a/drivers/video/omap2/dss/dss.c
+++ b/drivers/video/omap2/dss/dss.c
@@ -751,7 +751,8 @@ static int omap_dsshw_probe(struct platform_device *pdev)
 		r = -EINVAL;
 		goto err_ioremap;
 	}
-	dss.base = ioremap(dss_mem->start, resource_size(dss_mem));
+	dss.base = devm_ioremap(&pdev->dev, dss_mem->start,
+				resource_size(dss_mem));
 	if (!dss.base) {
 		DSSERR("can't ioremap DSS\n");
 		r = -ENOMEM;
@@ -760,7 +761,7 @@ static int omap_dsshw_probe(struct platform_device *pdev)
 
 	r = dss_get_clocks();
 	if (r)
-		goto err_clocks;
+		goto err_ioremap;
 
 	pm_runtime_enable(&pdev->dev);
 
@@ -808,8 +809,6 @@ err_dpi:
 err_runtime_get:
 	pm_runtime_disable(&pdev->dev);
 	dss_put_clocks();
-err_clocks:
-	iounmap(dss.base);
 err_ioremap:
 	return r;
 }
@@ -819,8 +818,6 @@ static int omap_dsshw_remove(struct platform_device *pdev)
 	dpi_exit();
 	sdi_exit();
 
-	iounmap(dss.base);
-
 	pm_runtime_disable(&pdev->dev);
 
 	dss_put_clocks();
diff --git a/drivers/video/omap2/dss/rfbi.c b/drivers/video/omap2/dss/rfbi.c
index 814bb95..159e914 100644
--- a/drivers/video/omap2/dss/rfbi.c
+++ b/drivers/video/omap2/dss/rfbi.c
@@ -925,7 +925,8 @@ static int omap_rfbihw_probe(struct platform_device *pdev)
 		r = -EINVAL;
 		goto err_ioremap;
 	}
-	rfbi.base = ioremap(rfbi_mem->start, resource_size(rfbi_mem));
+	rfbi.base = devm_ioremap(&pdev->dev, rfbi_mem->start,
+				 resource_size(rfbi_mem));
 	if (!rfbi.base) {
 		DSSERR("can't ioremap RFBI\n");
 		r = -ENOMEM;
@@ -963,7 +964,6 @@ err_get_ick:
 	rfbi_runtime_put();
 err_get_rfbi:
 	pm_runtime_disable(&pdev->dev);
-	iounmap(rfbi.base);
 err_ioremap:
 	return r;
 }
@@ -971,7 +971,6 @@ err_ioremap:
 static int omap_rfbihw_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
-	iounmap(rfbi.base);
 	return 0;
 }
 
diff --git a/drivers/video/omap2/dss/venc.c b/drivers/video/omap2/dss/venc.c
index b3e9f90..1dfdde1 100644
--- a/drivers/video/omap2/dss/venc.c
+++ b/drivers/video/omap2/dss/venc.c
@@ -793,7 +793,8 @@ static int omap_venchw_probe(struct platform_device *pdev)
 		r = -EINVAL;
 		goto err_ioremap;
 	}
-	venc.base = ioremap(venc_mem->start, resource_size(venc_mem));
+	venc.base = devm_ioremap(&pdev->dev, venc_mem->start,
+				 resource_size(venc_mem));
 	if (!venc.base) {
 		DSSERR("can't ioremap VENC\n");
 		r = -ENOMEM;
@@ -802,7 +803,7 @@ static int omap_venchw_probe(struct platform_device *pdev)
 
 	r = venc_get_clocks(pdev);
 	if (r)
-		goto err_get_clk;
+		goto err_ioremap;
 
 	pm_runtime_enable(&pdev->dev);
 
@@ -820,8 +821,6 @@ static int omap_venchw_probe(struct platform_device *pdev)
 err_get_venc:
 	pm_runtime_disable(&pdev->dev);
 	venc_put_clocks();
-err_get_clk:
-	iounmap(venc.base);
 err_ioremap:
 	return r;
 }
@@ -837,7 +836,6 @@ static int omap_venchw_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	venc_put_clocks();
 
-	iounmap(venc.base);
 	return 0;
 }
 

