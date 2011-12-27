Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1L0OBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:01:44 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44207 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab1L0OBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:01:39 -0500
From: Julia Lawall <julia@diku.dk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 3/6] drivers/watchdog/imx2_wdt.c: use devm_request_and_ioremap
Date: Tue, 27 Dec 2011 15:01:28 +0100
Message-Id: <1324994491-21828-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1324994491-21828-1-git-send-email-julia@diku.dk>
References: <1324994491-21828-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Reimplement a call to devm_request_mem_region followed by a call to ioremap
or ioremap_nocache by a call to devm_request_and_ioremap.

The variable res_size is then no longer needed.

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
 drivers/watchdog/imx2_wdt.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index b8ef2c6..c44c333 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -247,7 +247,6 @@ static struct miscdevice imx2_wdt_miscdev = {
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
-	int res_size;
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -256,15 +255,7 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	res_size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, res_size,
-		res->name)) {
-		dev_err(&pdev->dev, "can't allocate %d bytes at %d address\n",
-			res_size, res->start);
-		return -ENOMEM;
-	}
-
-	imx2_wdt.base = devm_ioremap_nocache(&pdev->dev, res->start, res_size);
+	imx2_wdt.base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!imx2_wdt.base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		return -ENOMEM;

