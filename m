Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2FOHGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:06:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:46085 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab2FOHFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112384706"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>, Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/9] dw_dmac: disable dma in optimal way in probe
Date: Fri, 15 Jun 2012 10:05:10 +0300
Message-Id: <1339743913-6236-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_dma_off call needs to have the all_chan_mask calculated. So, done this
calculations before the call. Moreover, remove duplicate code that masks the
DMA interrupts.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index e2ea243..cffe630 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1433,6 +1433,9 @@ static int __init dw_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(dw->clk);
 
+	/* Calculate all channel mask before DMA setup */
+	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
+
 	/* force dma off, just in case */
 	dw_dma_off(dw);
 
@@ -1444,8 +1447,6 @@ static int __init dw_probe(struct platform_device *pdev)
 
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
-	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
-
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < pdata->nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
@@ -1481,11 +1482,6 @@ static int __init dw_probe(struct platform_device *pdev)
 	dma_writel(dw, CLEAR.DST_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.ERROR, dw->all_chan_mask);
 
-	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
-	channel_clear_bit(dw, MASK.SRC_TRAN, dw->all_chan_mask);
-	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
-	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
-
 	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
 	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
 	if (pdata->is_private)
-- 
1.7.10

