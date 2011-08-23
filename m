Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1HWRk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:40:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab1HWRj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6446"; a="112353737"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Murali Palnati <palnatim@codeaurora.org>
Subject: [PATCH 2/6] mmc: msm_sdcc: Enable SDC host->clk only after setting the rate.
Date: Tue, 23 Aug 2011 10:39:14 -0700
Message-Id: <1314121158-3319-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
References: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

For clocks that support rates which can be set (most clocks other
than _pclk AHB clocks), a rate must be set using clk_set_rate()
before the clock is enabled for the first time with clk_enable().
Subsequent calls to clk_enable() need not be preceded with the
clk_set_rate() calls unless we wish to change the clock rate that
is set previously.

SDC host->clk is currently enabled without setting the clock rate
even once. This patch fixes this, by ensuring that the clock rate
for this clock is first set before enabling the clock.

Signed-off-by: Murali Palnati <palnatim@codeaurora.org>
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 0f0b4fd..de00001 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1247,17 +1247,17 @@ msmsdcc_probe(struct platform_device *pdev)
 		goto pclk_put;
 	}
 
-	/* Enable clocks */
-	ret = msmsdcc_enable_clocks(host);
-	if (ret)
-		goto clk_put;
-
 	ret = clk_set_rate(host->clk, msmsdcc_fmin);
 	if (ret) {
 		pr_err("%s: Clock rate set failed (%d)\n", __func__, ret);
-		goto clk_disable;
+		goto clk_put;
 	}
 
+	/* Enable clocks */
+	ret = msmsdcc_enable_clocks(host);
+	if (ret)
+		goto clk_put;
+
 	host->pclk_rate = clk_get_rate(host->pclk);
 	host->clk_rate = clk_get_rate(host->clk);
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

