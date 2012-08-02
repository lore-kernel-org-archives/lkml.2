Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2HBLL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:11:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42537 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2HBLLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:11:46 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Fix the error handling in probe
Date: Thu, 2 Aug 2012 16:41:25 +0530
Message-ID: <1343905885-31549-1-git-send-email-shubhrajyoti@ti.com>
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

Acked-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index bc47781..b2fb141 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1228,18 +1228,16 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 
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

