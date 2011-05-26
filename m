Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1EZG1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:27:07 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:26640
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab1EZG1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:27:04 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/3] mmc: mxs-mmc: call dmaengine API to set mmc->max_segs
Date: Thu, 26 May 2011 14:31:33 +0800
Message-ID: <1306391493-29425-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
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


