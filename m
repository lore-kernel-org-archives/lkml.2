Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1L0OCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:02:02 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44221 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab1L0OBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:01:43 -0500
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] drivers/mtd/nand/txx9ndfmc.c: use devm_request_and_ioremap
Date: Tue, 27 Dec 2011 15:01:31 +0100
Message-Id: <1324994491-21828-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1324994491-21828-1-git-send-email-julia@diku.dk>
References: <1324994491-21828-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Reimplement a call to devm_request_mem_region followed by a call to ioremap
or ioremap_nocache by a call to devm_request_and_ioremap.

The semantic patch that makes this transformation is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@nm@
expression myname;
identifier i;
@@

struct platform_driver i = { .driver = { .name = myname } };

@@
expression dev,res,size;
expression nm.myname;
@@

-if (!devm_request_mem_region(dev, res->start, size,
-                              \(res->name\|dev_name(dev)\|myname\))) {
-   ...
-   return ...;
-}
... when != res->start
(
-devm_ioremap(dev,res->start,size)
+devm_request_and_ioremap(dev,res)
|
-devm_ioremap_nocache(dev,res->start,size)
+devm_request_and_ioremap(dev,res)
)
... when any
    when != res->start
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/nand/txx9ndfmc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index ace46fd..c7c4f1d 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -298,11 +298,7 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 	drvdata = devm_kzalloc(&dev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
-	if (!devm_request_mem_region(&dev->dev, res->start,
-				     resource_size(res), dev_name(&dev->dev)))
-		return -EBUSY;
-	drvdata->base = devm_ioremap(&dev->dev, res->start,
-				     resource_size(res));
+	drvdata->base = devm_request_and_ioremap(&dev->dev, res);
 	if (!drvdata->base)
 		return -EBUSY;
 

