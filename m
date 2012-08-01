Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2HAJgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:36:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44717 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab2HAJgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:36:52 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] spi: omap2-mcspi: Fix the error handling in probe
Date: Wed, 1 Aug 2012 15:06:28 +0530
Message-ID: <1343813788-19165-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kfree() is taken care of by the spi core (spi_master_release() function)
that is called once the last reference to the underlying struct device has
been released. So the driver need not call kfree.

Also the put was missed in some of the error handling fix the same.
There by fixing the missing device_put in some of the error paths.

Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 7d46b15..b5035e2 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1203,18 +1203,16 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 
 	status = spi_register_master(master);
 	if (status < 0)
-		goto err_spi_register;
+		goto disable_pm;
 
 	return status;
 
-err_spi_register:
-	spi_master_put(master);
 disable_pm:
 	pm_runtime_disable(&pdev->dev);
 dma_chnl_free:
 	kfree(mcspi->dma_channels);
 free_master:
-	kfree(master);
+	spi_master_put(master);
 	platform_set_drvdata(pdev, NULL);
 	return status;
 }
-- 
1.7.5.4

