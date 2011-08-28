Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1H1WLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 18:11:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1H1WLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 18:11:47 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh <santosh.shilimkar@ti.com>,
        Balaji T Krishnamoorthy <balajitk@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] mmc: omap_hsmmc: DMA unmap only once in case of MMC error
Date: Mon, 29 Aug 2011 00:08:43 +0200
Message-Id: <1314569323-6886-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Russell King:
------------
mmcblk0: error -84 transferring data, sector 149201, nr 64,
cmd response 0x900, card status 0xb00
mmcblk0: retrying using single block read

WARNING: at /home/rmk/git/linux-2.6-rmk/lib/dma-debug.c:811 check_unmap
omap_hsmmc omap_hsmmc.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000080933000] [size=20480 bytes]
-------------

In case of an error dma_unmap() is issued in omap_hsmmc_dma_cleanup()
and then again in omap_hsmmc_post_req(). Resolve this by clearing the
host_cookie to indicate there is no DMA mapped memory to unmap.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
Bug fix on 3.1-rc3

 drivers/mmc/host/omap_hsmmc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 21e4a79..31d9817 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1011,6 +1011,7 @@ static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
 			host->data->sg_len,
 			omap_hsmmc_get_dma_dir(host, host->data));
 		omap_free_dma(dma_ch);
+		host->data->host_cookie = 0;
 	}
 	host->data = NULL;
 }
@@ -1576,8 +1577,10 @@ static void omap_hsmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
 	struct mmc_data *data = mrq->data;
 
 	if (host->use_dma) {
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-			     omap_hsmmc_get_dma_dir(host, data));
+		if (data->host_cookie)
+			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
+				     data->sg_len,
+				     omap_hsmmc_get_dma_dir(host, data));
 		data->host_cookie = 0;
 	}
 }
-- 
1.7.4.1

