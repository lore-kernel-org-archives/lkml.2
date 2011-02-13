Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1BMLu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:50:57 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58481 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1BMLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:50:34 -0500
From: Julia Lawall <julia@diku.dk>
To: ben-linux@fluff.org
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/i2c/busses/i2c-au1550.c: Convert release_resource to release_region/release_mem_region
Date: Sun, 13 Feb 2011 13:12:08 +0100
Message-Id: <1297599132-7226-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297599132-7226-1-git-send-email-julia@diku.dk>
References: <1297599132-7226-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_region should be used with release_region, not release_resource.

The result of request_mem_region is no longer stored.  Instead the field
ioarea is used to store a pointer to the resource structure that contains
the start address.  This is the information that is needed later in
i2c_au1550_remove to release the region.  The field ioarea is not used for
anything else.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@
(
*x = request_region(...)
|
*x = request_mem_region(...)
)
... when != release_region(x)
    when != x = E
* release_resource(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Not compiled due to incompatible architecture.

 drivers/i2c/busses/i2c-au1550.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index 532828b..2ec78d7 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -389,13 +389,12 @@ i2c_au1550_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	priv->ioarea = request_mem_region(r->start, resource_size(r),
-					  pdev->name);
-	if (!priv->ioarea) {
+	if (!request_mem_region(r->start, resource_size(r), pdev->name)) {
 		ret = -EBUSY;
 		goto out_mem;
 	}
 
+	priv->ioarea = r;
 	priv->psc_base = CKSEG1ADDR(r->start);
 	priv->xfer_timeout = 200;
 	priv->ack_timeout = 200;
@@ -418,8 +417,7 @@ i2c_au1550_probe(struct platform_device *pdev)
 
 	i2c_au1550_disable(priv);
 
-	release_resource(priv->ioarea);
-	kfree(priv->ioarea);
+	release_mem_region(r->start, resource_size(r));
 out_mem:
 	kfree(priv);
 out:
@@ -430,12 +428,12 @@ static int __devexit
 i2c_au1550_remove(struct platform_device *pdev)
 {
 	struct i2c_au1550_data *priv = platform_get_drvdata(pdev);
+	struct resource *r = priv->ioarea;
 
 	platform_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&priv->adap);
 	i2c_au1550_disable(priv);
-	release_resource(priv->ioarea);
-	kfree(priv->ioarea);
+	release_mem_region(r->start, resource_size(r));
 	kfree(priv);
 	return 0;
 }

