Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3AIIVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:21:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:28796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367Ab3AIIRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="271648599"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 02/16] dw_dmac: absence of pdata isn't critical when autocfg is set
Date: Wed,  9 Jan 2013 10:17:01 +0200
Message-Id: <1357719435-29955-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch allows to probe the device when platform data is absent and hardware
auto configuration is enabled. In that case the default platform data is used
where the channel allocation order is set to ascending, channel priority is set
to ascending, and private property is set to true.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index b5f21ba..bf32797 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1600,13 +1600,6 @@ static int dw_probe(struct platform_device *pdev)
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
@@ -1622,6 +1615,22 @@ static int dw_probe(struct platform_device *pdev)
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

