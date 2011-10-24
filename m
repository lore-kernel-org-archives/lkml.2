Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1JXKYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:24:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40411 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab1JXKYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:24:39 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] OMAP: SPI: Fix the trying to free nonexistent resource error
Date: Mon, 24 Oct 2011 15:54:24 +0530
Message-ID: <1319451864-8212-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is a request_mem_region(r->start, ..
followed by r->start += pdata->regs_offset;

And then in remove

   r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
   release_mem_region(r->start, resource_size(r));

Here the offset addition is not taken care. Fix the code for the
same.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 06dc9a9..471b0f3 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1123,15 +1123,15 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		status = -ENODEV;
 		goto err1;
 	}
+	r->start += pdata->regs_offset;
+	r->end += pdata->regs_offset;
+	mcspi->phys = r->start;
 	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto err1;
 	}
 
-	r->start += pdata->regs_offset;
-	r->end += pdata->regs_offset;
-	mcspi->phys = r->start;
 	mcspi->base = ioremap(r->start, resource_size(r));
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
-- 
1.7.1

