Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1JXImV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:42:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57401 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1JXImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:42:20 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, Tejun Heo <tj@kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 4/4] watchdog: imx2: simplify resource allocation
Date: Mon, 24 Oct 2011 10:42:09 +0200
Message-Id: <1319445729-14841-5-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new devm_resource_to_mapped_ptr function to simplify the code
and standardize the error-handling. Silently fixes a wrong type for the
resource_size variable as well.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/watchdog/imx2_wdt.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index b8ef2c6..1fc6714 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -247,28 +247,12 @@ static struct miscdevice imx2_wdt_miscdev = {
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
-	int res_size;
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't get device resources\n");
-		return -ENODEV;
-	}
-
-	res_size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, res_size,
-		res->name)) {
-		dev_err(&pdev->dev, "can't allocate %d bytes at %d address\n",
-			res_size, res->start);
-		return -ENOMEM;
-	}
-
-	imx2_wdt.base = devm_ioremap_nocache(&pdev->dev, res->start, res_size);
-	if (!imx2_wdt.base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
-	}
+	ret = devm_resource_to_mapped_ptr(&pdev->dev, res, &imx2_wdt.base);
+	if (ret)
+		return ret;
 
 	imx2_wdt.clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imx2_wdt.clk)) {
-- 
1.7.6.3

