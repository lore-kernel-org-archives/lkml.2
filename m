Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2HDQu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:50:59 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:37654
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab2HDQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:50:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="152439849"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/6] drivers/thermal/rcar_thermal.c: drop frees of devm allocated data
Date: Sat,  4 Aug 2012 18:50:44 +0200
Message-Id: <1344099049-15212-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kfree and devm_iounmap should not have to be explicitly used.

The semantic patch that fixes one of these problems is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,d;
@@

x = devm_kzalloc(...)
...
?-devm_kfree(d,x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/thermal/rcar_thermal.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 2496b4f..9edbe04 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -206,16 +206,14 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 					  res->start, resource_size(res));
 	if (!priv->base) {
 		dev_err(&pdev->dev, "Unable to ioremap thermal register\n");
-		ret = -ENOMEM;
-		goto error_free_priv;
+		return -ENOMEM;
 	}
 
 	zone = thermal_zone_device_register("rcar_thermal", 0, priv,
 					    &rcar_thermal_zone_ops, 0, 0, 0, 0);
 	if (IS_ERR(zone)) {
 		dev_err(&pdev->dev, "thermal zone device is NULL\n");
-		ret = PTR_ERR(zone);
-		goto error_iounmap;
+		return PTR_ERR(zone);
 	}
 
 	platform_set_drvdata(pdev, zone);
@@ -223,13 +221,6 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "proved\n");
 
 	return 0;
-
-error_iounmap:
-	devm_iounmap(&pdev->dev, priv->base);
-error_free_priv:
-	devm_kfree(&pdev->dev, priv);
-
-	return ret;
 }
 
 static int rcar_thermal_remove(struct platform_device *pdev)
@@ -240,9 +231,6 @@ static int rcar_thermal_remove(struct platform_device *pdev)
 	thermal_zone_device_unregister(zone);
 	platform_set_drvdata(pdev, NULL);
 
-	devm_iounmap(&pdev->dev, priv->base);
-	devm_kfree(&pdev->dev, priv);
-
 	return 0;
 }
 

