Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2HHGzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:55:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2HHGzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:55:08 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: i2c-ocores: Use devm_request_and_ioremap()
Date: Wed,  8 Aug 2012 08:54:32 +0200
Message-Id: <1344408872-1051-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:ib1o7GtPeHaoPInzEylUlraoSZesXm0RdSWv9Br4y0L
 cIdSs9rE87w75dhAAxXdTDn6h1eHv7WoL2cIfy9zcJyIU7qWU0
 B4Lvn5xhXZeHiDOMLG3sB6Zn8pXpvvu95P1Fp9Z5WQALpDE71Y
 fr1IubEHiSJRdeXRAKCj1tpi+RxFjNKTjNfIVkiSQlevzsV3f8
 vB59emX+cYyvkUTNaRVZILY6jADMMrurnTat8PNJEzrO9pFkLG
 REdrgSUuDyo62xxNwg//zGW7MjQBYNi+A9nyhv0axkmDt5Fqkm
 JHLmnAcJvg3RoI+Rtbp9TR60cj9CMIDNCHYLY672qFQPHsbGd5
 3p0CSyuaEEW1sOO1LdEmCkg9d7sQ4t+BEFqxHUl6ZYm8Y8nhle
 AXG4K/GW5n2/La+fvvn9mNerHR9s+6us/yS/2gz9YxGy44Pv/1
 u4u7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing the devm_request_mem_region() and devm_ioremap_nocache() calls
by a single call to devm_request_and_ioremap() simplifies the code.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/i2c/busses/i2c-ocores.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index bffd550..1fad4ae 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -283,18 +283,9 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	if (!i2c)
 		return -ENOMEM;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "Memory region busy\n");
-		return -EBUSY;
-	}
-
-	i2c->base = devm_ioremap_nocache(&pdev->dev, res->start,
-					 resource_size(res));
-	if (!i2c->base) {
-		dev_err(&pdev->dev, "Unable to map registers\n");
-		return -EIO;
-	}
+	i2c->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!i2c->base)
+		return -EADDRNOTAVAIL;
 
 	pdata = pdev->dev.platform_data;
 	if (pdata) {
-- 
1.7.11.4

