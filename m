Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2IAQer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 12:34:47 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:51673
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364Ab2IAQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 12:33:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="154399779"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] drivers/mtd/maps/autcpu12-nvram.c: drop frees of devm_ alloc'd data
Date: Sat,  1 Sep 2012 18:33:11 +0200
Message-Id: <1346517191-8794-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm free functions should not have to be explicitly used.

A semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

(
* devm_kfree(...);
|
* devm_free_irq(...);
|
* devm_iounmap(...);
|
* devm_release_region(...);
|
* devm_release_mem_region(...);
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/maps/autcpu12-nvram.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/mtd/maps/autcpu12-nvram.c b/drivers/mtd/maps/autcpu12-nvram.c
index ef420d9..76fb594 100644
--- a/drivers/mtd/maps/autcpu12-nvram.c
+++ b/drivers/mtd/maps/autcpu12-nvram.c
@@ -38,7 +38,6 @@ static int __devinit autcpu12_nvram_probe(struct platform_device *pdev)
 	map_word tmp, save0, save1;
 	struct resource *res;
 	struct autcpu12_nvram_priv *priv;
-	int err;
 
 	priv = devm_kzalloc(&pdev->dev,
 			    sizeof(struct autcpu12_nvram_priv), GFP_KERNEL);
@@ -50,8 +49,7 @@ static int __devinit autcpu12_nvram_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		err = -ENOENT;
-		goto out;
+		return -ENOENT;
 	}
 
 	priv->map.bankwidth	= 4;
@@ -61,8 +59,7 @@ static int __devinit autcpu12_nvram_probe(struct platform_device *pdev)
 	strcpy((char *)priv->map.name, res->name);
 	if (!priv->map.virt) {
 		dev_err(&pdev->dev, "failed to remap mem resource\n");
-		err = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	simple_map_init(&priv->map);
@@ -90,8 +87,7 @@ static int __devinit autcpu12_nvram_probe(struct platform_device *pdev)
 	priv->mtd = do_map_probe("map_ram", &priv->map);
 	if (!priv->mtd) {
 		dev_err(&pdev->dev, "probing failed\n");
-		err = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	priv->mtd->owner	= THIS_MODULE;
@@ -106,12 +102,7 @@ static int __devinit autcpu12_nvram_probe(struct platform_device *pdev)
 
 	map_destroy(priv->mtd);
 	dev_err(&pdev->dev, "NV-RAM device addition failed\n");
-	err = -ENOMEM;
-
-out:
-	devm_kfree(&pdev->dev, priv);
-
-	return err;
+	return -ENOMEM;
 }
 
 static int __devexit autcpu12_nvram_remove(struct platform_device *pdev)
@@ -120,7 +111,6 @@ static int __devexit autcpu12_nvram_remove(struct platform_device *pdev)
 
 	mtd_device_unregister(priv->mtd);
 	map_destroy(priv->mtd);
-	devm_kfree(&pdev->dev, priv);
 
 	return 0;
 }

