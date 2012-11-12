Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2KLLXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:23:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:52482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2KLLXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:23:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,761,1344236400"; 
   d="scan'208";a="218232429"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: absence of pdata isn't critical when autocfg is set
Date: Mon, 12 Nov 2012 13:23:26 +0200
Message-Id: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch allows to probe the device when platform data is absent and hardware
auto configuration is enabled. In that case the default platform data is used
where the channel allocation order is set to ascending, channel priority is set
to ascending, and private property is set to true.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2c8096d..0ec5c84 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1585,6 +1585,12 @@ dw_dma_parse_dt(struct platform_device *pdev)
 }
 #endif
 
+static struct dw_dma_platform_data dw_dma_pdata = {
+	.is_private = true,
+	.chan_allocation_order = CHAN_ALLOCATION_ASCENDING,
+	.chan_priority = CHAN_PRIORITY_ASCENDING,
+};
+
 static int __devinit dw_probe(struct platform_device *pdev)
 {
 	struct dw_dma_platform_data *pdata;
@@ -1604,9 +1610,6 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	if (!pdata)
 		pdata = dw_dma_parse_dt(pdev);
 
-	if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
-		return -EINVAL;
-
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!io)
 		return -EINVAL;
@@ -1622,6 +1625,12 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	dw_params = dma_read_byaddr(regs, DW_PARAMS);
 	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
 
+	if (!pdata && autocfg)
+		pdata = &dw_dma_pdata;
+
+	if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
+		return -EINVAL;
+
 	if (autocfg)
 		nr_channels = (dw_params >> DW_PARAMS_NR_CHAN & 0x7) + 1;
 	else
-- 
1.7.10.4

