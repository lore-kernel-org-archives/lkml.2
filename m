Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2GJXlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:41:07 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:44637 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755264Ab2GJXlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:41:03 -0400
From: Kevin Hilman <khilman@ti.com>
To: Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>,
        linux-mmc@vger.kernel.org
Cc: linux-omap@vger.kernel.org,
        Balaji T K <balajitk@ti.com> (commit_signer:14/49=29%),
        Rajendra Nayak <rnayak@ti.com> (commit_signer:11/49=22%),
        Adrian Hunter <adrian.hunter@intel.com> (commit_signer:9/49=18%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mmc: omap_hsmmc: ensure probe returns error upon resource failure
Date: Tue, 10 Jul 2012 16:40:56 -0700
Message-Id: <1341963658-20896-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If platform_get_resource_by_name() fails, driver probe is aborted an
should return an error so the driver is not bound to the device.

However, in the current error path of platform_get_resource_by_name(),
probe returns zero since the return value (ret) is not properly set.
With a zero return value, the driver core assumes probe was successful
and will bind the driver to the device.

Fix this by ensuring that probe returns an error code in this failure
path.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 389a3ee..19e60e9 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1931,6 +1931,7 @@ static int __devinit omap_hsmmc_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
 	if (!res) {
 		dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
+		ret = -ENXIO;
 		goto err_irq;
 	}
 	host->dma_line_tx = res->start;
@@ -1938,6 +1939,7 @@ static int __devinit omap_hsmmc_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
 	if (!res) {
 		dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
+		ret = -ENXIO;
 		goto err_irq;
 	}
 	host->dma_line_rx = res->start;
-- 
1.7.9.2

