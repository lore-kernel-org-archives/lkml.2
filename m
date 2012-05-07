Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2EGUxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:53:53 -0400
Received: from d1.icnet.pl ([212.160.220.21]:35617 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab2EGUxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:53:52 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        linux-mtd@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v2 3.4-rc6] MTD: NAND: ams-delta: fix request_mem_region() failure
Date: Mon,  7 May 2012 22:51:37 +0200
Message-Id: <1336423897-31729-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20120504171125.GD5613@atomide.com>
References: <20120504171125.GD5613@atomide.com>
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

The I/O lines and corresponding registers used by the NAND driver are a
subset of those used for the GPIO function. Then, to avoid run time
collisions, all MPUIO GPIO lines should be marked as requested while
initializing the NAND driver, and vice versa, a single MPUIO GPIO line
already requested before the NAND driver initialization is attempted
should prevent the NAND device from being started successfully.

There is another driver, omap-keypad, which also manipulates MPUIO
registers, but has never been calling request_mem_region() on startup,
so it's not affected by the change in the gpio-omap and works correctly.
It uses the depreciated omap_read/write functions for accessing MPUIO
registers. Unlike the NAND driver, these I/O lines and registers are
separate from those used by the GPIO driver. However, both register sets
are non-contiguous and overlapping, so it would be impractical to
request the two sets separately, one from the gpio-omap, the other form
the omap-keypad driver.

In order to solve all these issues correctly, a solution first suggested
by Artem Bityutskiy, then closer specified by Tony Lindgren while they
commented the initial version of this fix, should be implemented. The
gpio-omap driver should export a few functions which would allow the
other two drivers to access MPUIO registers in a safe manner instead of
trying to manage them in parallel to the GPIO driver.  However, such a
big change, affecting 3 drivers all together, is not suitable for the rc
cycle, and should be prepared for the merge window.  Then, an
alternative solution is proposed as a regression fix.

For the ams-delta NAND driver to initialize correctly in coexistence
with the changed GPIO driver, drop the request_mem_region() call from
the former, especially as this call is going to be removed while the
long-term solution is implemented.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Acked-by: Tony Lindgren <tony@atomide.com>
---
Artem, Tony,
I hope the changelog message is now good enough to make you satisfied,
and render the Tony's Ack valid.

Changes against initial version:
* a comment replacing the removed function call added,
* more details on the three drivers coexistance and possible interaction
  provided,
* a hopefuly decent long-term plan to properly fix all identified issues
  proposed.

 drivers/mtd/nand/ams-delta.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 7341695..358162a 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -212,18 +212,17 @@ static int __devinit ams_delta_init(struct platform_device *pdev)
 	/* Link the private data with the MTD structure */
 	ams_delta_mtd->priv = this;
 
-	if (!request_mem_region(res->start, resource_size(res),
-			dev_name(&pdev->dev))) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		err = -EBUSY;
-		goto out_free;
-	}
+	/*
+	 * Don't try to request the memory region from here,
+	 * it should have been already requested from the
+	 * gpio-omap driver and requesting it again would fail.
+	 */
 
 	io_base = ioremap(res->start, resource_size(res));
 	if (io_base == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		err = -EIO;
-		goto out_release_io;
+		goto out_free;
 	}
 
 	this->priv = io_base;
@@ -271,8 +270,6 @@ out_gpio:
 	platform_set_drvdata(pdev, NULL);
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
 	iounmap(io_base);
-out_release_io:
-	release_mem_region(res->start, resource_size(res));
 out_free:
 	kfree(ams_delta_mtd);
  out:
@@ -293,7 +290,6 @@ static int __devexit ams_delta_cleanup(struct platform_device *pdev)
 	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
 	iounmap(io_base);
-	release_mem_region(res->start, resource_size(res));
 
 	/* Free the MTD device structure */
 	kfree(ams_delta_mtd);
-- 
1.7.3.4

