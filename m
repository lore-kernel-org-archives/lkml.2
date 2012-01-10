Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2AJH1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:27:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50926 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2AJH1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:27:43 -0500
Message-ID: <1326180456.4956.7.camel@phoenix>
Subject: [PATCH RESEND] spi/imx: simplify error handling to free gpios
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Date: Tue, 10 Jan 2012 15:27:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the error handling by moving the code to free gpios in one place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/spi/spi-imx.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index c6e697f..31054e3 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -793,13 +793,8 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
 
 		ret = gpio_request(spi_imx->chipselect[i], DRIVER_NAME);
 		if (ret) {
-			while (i > 0) {
-				i--;
-				if (spi_imx->chipselect[i] >= 0)
-					gpio_free(spi_imx->chipselect[i]);
-			}
 			dev_err(&pdev->dev, "can't get cs gpios\n");
-			goto out_master_put;
+			goto out_gpio_free;
 		}
 	}
 
@@ -881,10 +876,10 @@ out_iounmap:
 out_release_mem:
 	release_mem_region(res->start, resource_size(res));
 out_gpio_free:
-	for (i = 0; i < master->num_chipselect; i++)
+	while (--i >= 0) {
 		if (spi_imx->chipselect[i] >= 0)
 			gpio_free(spi_imx->chipselect[i]);
-out_master_put:
+	}
 	spi_master_put(master);
 	kfree(master);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.5.4



