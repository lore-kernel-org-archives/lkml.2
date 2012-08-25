Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2HYRmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:42:00 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:45587 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab2HYRlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:41:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="170801704"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Jean Delvare (PC drivers core)" <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] i2c: au1550: use devm_ functions
Date: Sat, 25 Aug 2012 19:41:37 +0200
Message-Id: <1345916499-6657-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

The initial call to platform_get_resource is moved down to the introduced
call to devm_request_and_ioremap thta uses its result.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/i2c/busses/i2c-au1550.c |   41 +++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index 582d616..0690ef0 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -320,30 +320,16 @@ i2c_au1550_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		ret = -ENODEV;
-		goto out;
-	}
-
-	priv = kzalloc(sizeof(struct i2c_au1550_data), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct i2c_au1550_data),
+			    GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
-	priv->ioarea = request_mem_region(r->start, resource_size(r),
-					  pdev->name);
-	if (!priv->ioarea) {
-		ret = -EBUSY;
-		goto out_mem;
-	}
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	priv->psc_base = ioremap(r->start, resource_size(r));
-	if (!priv->psc_base) {
-		ret = -EIO;
-		goto out_map;
-	}
+	priv->psc_base = devm_request_and_ioremap(&pdev->dev, r);
+	if (!priv->psc_base)
+		return -EIO;
 	priv->xfer_timeout = 200;
 
 	priv->adap.nr = pdev->id;
@@ -362,13 +348,6 @@ i2c_au1550_probe(struct platform_device *pdev)
 	}
 
 	i2c_au1550_disable(priv);
-	iounmap(priv->psc_base);
-out_map:
-	release_resource(priv->ioarea);
-	kfree(priv->ioarea);
-out_mem:
-	kfree(priv);
-out:
 	return ret;
 }
 
@@ -379,10 +358,6 @@ static int __devexit i2c_au1550_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&priv->adap);
 	i2c_au1550_disable(priv);
-	iounmap(priv->psc_base);
-	release_resource(priv->ioarea);
-	kfree(priv->ioarea);
-	kfree(priv);
 	return 0;
 }
 

