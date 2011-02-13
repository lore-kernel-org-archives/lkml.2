Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1BMLv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:51:29 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58507 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab1BMLum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:50:42 -0500
From: Julia Lawall <julia@diku.dk>
To: ben-linux@fluff.org
Cc: kernel-janitors@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>, Dave Airlie <airlied@linux.ie>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/i2c/busses/i2c-nuc900.c: Convert release_resource to release_region/release_mem_region
Date: Sun, 13 Feb 2011 13:12:12 +0100
Message-Id: <1297599132-7226-6-git-send-email-julia@diku.dk>
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
nuc900_i2c_remove to release the region.  The field ioarea is also printed
in some debugging code.

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

 drivers/i2c/busses/i2c-nuc900.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nuc900.c b/drivers/i2c/busses/i2c-nuc900.c
index 7243426..97b16b7 100644
--- a/drivers/i2c/busses/i2c-nuc900.c
+++ b/drivers/i2c/busses/i2c-nuc900.c
@@ -568,15 +568,13 @@ static int __devinit nuc900_i2c_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	i2c->ioarea = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
-
-	if (i2c->ioarea == NULL) {
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
 		dev_err(&pdev->dev, "cannot request IO\n");
 		ret = -ENXIO;
 		goto err_clk;
 	}
 
+	i2c->ioarea = res;
 	i2c->regs = ioremap(res->start, resource_size(res));
 
 	if (i2c->regs == NULL) {
@@ -645,8 +643,7 @@ static int __devinit nuc900_i2c_probe(struct platform_device *pdev)
 	iounmap(i2c->regs);
 
  err_ioarea:
-	release_resource(i2c->ioarea);
-	kfree(i2c->ioarea);
+	release_mem_region(res->start, resource_size(res));
 
  err_clk:
 	clk_disable(i2c->clk);
@@ -665,6 +662,7 @@ static int __devinit nuc900_i2c_probe(struct platform_device *pdev)
 static int __devexit nuc900_i2c_remove(struct platform_device *pdev)
 {
 	struct nuc900_i2c *i2c = platform_get_drvdata(pdev);
+	struct resource *res = i2c->ioarea;
 
 	i2c_del_adapter(&i2c->adap);
 	free_irq(i2c->irq, i2c);
@@ -674,8 +672,7 @@ static int __devexit nuc900_i2c_remove(struct platform_device *pdev)
 
 	iounmap(i2c->regs);
 
-	release_resource(i2c->ioarea);
-	kfree(i2c->ioarea);
+	release_mem_region(res->start, resource_size(res));
 	kfree(i2c);
 
 	return 0;

