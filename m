Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1FFHXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:23:04 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42458 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab1FFHXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:23:02 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 3/3] mmc: mxs-mmc: call dmaengine API to set mmc->max_segs
Date: Mon,  6 Jun 2011 15:30:14 +0800
Message-Id: <1307345414-26872-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
References: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dmaengine API dma_get_max_seg_number added, we now can call
the API to get and number and then set mmc->max_segs instead of
hard-coding it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/mxs-mmc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 99d39a6..d783af3 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -745,11 +745,15 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	mmc->f_max = 288000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-	mmc->max_segs = 52;
 	mmc->max_blk_size = 1 << 0xf;
 	mmc->max_blk_count = (ssp_is_old()) ? 0xff : 0xffffff;
 	mmc->max_req_size = (ssp_is_old()) ? 0xffff : 0xffffffff;
 	mmc->max_seg_size = dma_get_max_seg_size(host->dmach->device->dev);
+	/*
+	 * Reserve one segment for carrying on pio words to get dma engine
+	 * program mmc controller registers
+	 */
+	mmc->max_segs = dma_get_max_seg_number(host->dmach->device->dev) - 1;
 
 	platform_set_drvdata(pdev, mmc);
 
-- 
1.7.4.1

