Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2DQO2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:28:43 -0400
Received: from d1.icnet.pl ([212.160.220.21]:58385 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2DQO2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:28:41 -0400
X-Greylist: delayed 2234 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2012 10:28:41 EDT
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v3.4-rc3] MTD: NAND: ams-delta: Fix request_mem_region() failure
Date: Tue, 17 Apr 2012 15:49:17 +0200
Message-Id: <1334670557-25640-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A call to request_mem_region() has been introduced in the omap-gpio
driver recently (commit 96751fcbe5438e95514b025e9cee7a6d38038f40,
"gpio/omap: Use devm_ API and add request_mem_region"). This change
prevented the Amstrad Delta NAND driver, which was doing the same in
order to take control over OMAP MPU I/O lines that the NAND device hangs
off, from loading successfully.

There is another driver, omap-keypad, which also manipulates OMAP MPUIO
registers, but has never been calling request_mem_region() on startup,
so it's not affected by the change in the gpio-omap and works correctly.

Drop request_mem_region() call and related bits from ams-delta NAND
driver.

Created and tested against linux-3.4-rc3.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/mtd/nand/ams-delta.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 7341695..af76da3 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -212,18 +212,11 @@ static int __devinit ams_delta_init(struct platform_device *pdev)
 	/* Link the private data with the MTD structure */
 	ams_delta_mtd->priv = this;
 
-	if (!request_mem_region(res->start, resource_size(res),
-			dev_name(&pdev->dev))) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		err = -EBUSY;
-		goto out_free;
-	}
-
 	io_base = ioremap(res->start, resource_size(res));
 	if (io_base == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		err = -EIO;
-		goto out_release_io;
+		goto out_free;
 	}
 
 	this->priv = io_base;
@@ -271,8 +264,6 @@ out_gpio:
 	platform_set_drvdata(pdev, NULL);
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
 	iounmap(io_base);
-out_release_io:
-	release_mem_region(res->start, resource_size(res));
 out_free:
 	kfree(ams_delta_mtd);
  out:
@@ -293,7 +284,6 @@ static int __devexit ams_delta_cleanup(struct platform_device *pdev)
 	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
 	iounmap(io_base);
-	release_mem_region(res->start, resource_size(res));
 
 	/* Free the MTD device structure */
 	kfree(ams_delta_mtd);
-- 
1.7.3.4

