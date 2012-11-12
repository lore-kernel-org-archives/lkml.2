Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2KLOjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:39:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:21072 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab2KLOjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:39:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,762,1344236400"; 
   d="scan'208";a="167231463"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2] dw_dmac: absence of pdata isn't critical when autocfg is set
Date: Mon, 12 Nov 2012 16:38:48 +0200
Message-Id: <1352731129-12876-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
Since v1:
 - allocate memory for pdata dynamically

 drivers/dma/dw_dmac.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2c8096d..a4a5c80 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1600,13 +1600,6 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	int			err;
 	int			i;
 
-	pdata = dev_get_platdata(&pdev->dev);
-	if (!pdata)
-		pdata = dw_dma_parse_dt(pdev);
-
-	if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
-		return -EINVAL;
-
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!io)
 		return -EINVAL;
@@ -1622,6 +1615,22 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	dw_params = dma_read_byaddr(regs, DW_PARAMS);
 	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
 
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		pdata = dw_dma_parse_dt(pdev);
+
+	if (!pdata && autocfg) {
+		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+
+		/* Fill platform data with the default values */
+		pdata->is_private = true;
+		pdata->chan_allocation_order = CHAN_ALLOCATION_ASCENDING;
+		pdata->chan_priority = CHAN_PRIORITY_ASCENDING;
+	} else if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
+		return -EINVAL;
+
 	if (autocfg)
 		nr_channels = (dw_params >> DW_PARAMS_NR_CHAN & 0x7) + 1;
 	else
-- 
1.7.10.4

