Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0HTQRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:17:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51735 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753408Ab0HTQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:17:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Jassi Brar <jassi.brar@samsung.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] spi/spi_s3c64xx: Make probe more robust against missing board config
Date: Fri, 20 Aug 2010 17:17:07 +0100
Message-Id: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S3C64xx SPI driver requires the machine to call s3c64xx_spi_set_info()
to select a few options, including the clock to use for the SPI controller.
If this is not done then a NULL will be passed as the clock name for
clk_get(), causing an obscure crash. Guard against this and other missing
configuration by validating that the clock name has been filled in in
the platform data that ets passed in.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi_s3c64xx.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index 9736581..a0b63b7 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -919,6 +919,13 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	sci = pdev->dev.platform_data;
+	if (!sci->src_clk_name) {
+		dev_err(&pdev->dev,
+			"Board init must call s3c64xx_spi_set_info()\n");
+		return -EINVAL;
+	}
+
 	/* Check for availability of necessary resource */
 
 	dmatx_res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
@@ -946,8 +953,6 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	sci = pdev->dev.platform_data;
-
 	platform_set_drvdata(pdev, master);
 
 	sdd = spi_master_get_devdata(master);
-- 
1.7.1

