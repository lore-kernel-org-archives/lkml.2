Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2IUC1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:27:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1202 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab2IUC1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:27:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="237156928"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/10] msm_sdcc: Convert to clk_prepare/unprepare
Date: Thu, 20 Sep 2012 19:26:50 -0700
Message-Id: <1348194419-11486-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to clk_prepare and unprepare so that MSM can migrate to
the common clock framework.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 1d14cda..10cc05b 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1269,10 +1269,18 @@ msmsdcc_probe(struct platform_device *pdev)
 		goto clk_put;
 	}
 
+	ret = clk_prepare(host->pclk);
+	if (ret)
+		goto clk_put;
+
+	ret = clk_prepare(host->clk);
+	if (ret)
+		goto clk_unprepare_p;
+
 	/* Enable clocks */
 	ret = msmsdcc_enable_clocks(host);
 	if (ret)
-		goto clk_put;
+		goto clk_unprepare;
 
 	host->pclk_rate = clk_get_rate(host->pclk);
 	host->clk_rate = clk_get_rate(host->clk);
@@ -1387,6 +1395,10 @@ msmsdcc_probe(struct platform_device *pdev)
 		free_irq(host->stat_irq, host);
  clk_disable:
 	msmsdcc_disable_clocks(host, 0);
+ clk_unprepare:
+	clk_unprepare(host->clk);
+ clk_unprepare_p:
+	clk_unprepare(host->pclk);
  clk_put:
 	clk_put(host->clk);
  pclk_put:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

