Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2IAQeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 12:34:01 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:46619
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab2IAQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 12:33:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="154399776"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Grant Likely <grant.likely@secretlab.ca>,
        broonie@opensource.wolfsonmicro.com
Cc: kernel-janitors@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/spi/spi-sh-hspi.c: drop frees of devm_ alloc'd data
Date: Sat,  1 Sep 2012 18:33:08 +0200
Message-Id: <1346517191-8794-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/spi/spi-sh-hspi.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/spi/spi-sh-hspi.c b/drivers/spi/spi-sh-hspi.c
index 934138c..796c077 100644
--- a/drivers/spi/spi-sh-hspi.c
+++ b/drivers/spi/spi-sh-hspi.c
@@ -283,7 +283,7 @@ static int __devinit hspi_probe(struct platform_device *pdev)
 	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "spi_register_master error.\n");
-		goto error2;
+		goto error1;
 	}
 
 	pm_runtime_enable(&pdev->dev);
@@ -292,8 +292,6 @@ static int __devinit hspi_probe(struct platform_device *pdev)
 
 	return 0;
 
- error2:
-	devm_iounmap(hspi->dev, hspi->addr);
  error1:
 	clk_put(clk);
  error0:
@@ -310,7 +308,6 @@ static int __devexit hspi_remove(struct platform_device *pdev)
 
 	clk_put(hspi->clk);
 	spi_unregister_master(hspi->master);
-	devm_iounmap(hspi->dev, hspi->addr);
 
 	return 0;
 }

