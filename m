Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab0LTXRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:17:12 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10808 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab0LTXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:17:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67414636"
From: Daniel Walker <dwalker@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 1/5] mmc: msm: consolidate ifdefs for BUSCLK_PWRSAVE
Date: Mon, 20 Dec 2010 15:16:47 -0800
Message-Id: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's cleaner to have ifdef's consolidated in one specific
area. This change pulls adds one ifdef which will swap
out of the function with a stub function if the ifdef is
false.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 1290d14..d6ac82c 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -61,7 +61,7 @@ static unsigned int msmsdcc_sdioirq;
 #define PIO_SPINMAX 30
 #define CMD_SPINMAX 20
 
-
+#ifdef BUSCLK_PWRSAVE
 static inline void
 msmsdcc_disable_clocks(struct msmsdcc_host *host, int deferr)
 {
@@ -83,6 +83,10 @@ msmsdcc_disable_clocks(struct msmsdcc_host *host, int deferr)
 		}
 	}
 }
+#else
+static inline void
+msmsdcc_disable_clocks(struct msmsdcc_host *host, int deferr) { }
+#endif
 
 static inline int
 msmsdcc_enable_clocks(struct msmsdcc_host *host)
@@ -139,9 +143,8 @@ msmsdcc_request_end(struct msmsdcc_host *host, struct mmc_request *mrq)
 	if (mrq->cmd->error == -ETIMEDOUT)
 		mdelay(5);
 
-#if BUSCLK_PWRSAVE
 	msmsdcc_disable_clocks(host, 1);
-#endif
+
 	/*
 	 * Need to drop the host lock here; mmc_request_done may call
 	 * back into the driver...
@@ -259,9 +262,9 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 			mrq->data->bytes_xfered = host->curr.data_xfered;
 
 			spin_unlock_irqrestore(&host->lock, flags);
-#if BUSCLK_PWRSAVE
+
 			msmsdcc_disable_clocks(host, 1);
-#endif
+
 			mmc_request_done(host->mmc, mrq);
 			return;
 		} else
@@ -930,9 +933,9 @@ msmsdcc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->pwr = pwr;
 		msmsdcc_writel(host, pwr, MMCIPOWER);
 	}
-#if BUSCLK_PWRSAVE
+
 	msmsdcc_disable_clocks(host, 1);
-#endif
+
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
@@ -1256,9 +1259,8 @@ msmsdcc_probe(struct platform_device *pdev)
 	if (host->timer.function)
 		pr_info("%s: Polling status mode enabled\n", mmc_hostname(mmc));
 
-#if BUSCLK_PWRSAVE
 	msmsdcc_disable_clocks(host, 1);
-#endif
+
 	return 0;
  cmd_irq_free:
 	free_irq(cmd_irqres->start, host);
@@ -1333,9 +1335,9 @@ msmsdcc_resume(struct platform_device *dev)
 			mmc_resume_host(mmc);
 		if (host->stat_irq)
 			enable_irq(host->stat_irq);
-#if BUSCLK_PWRSAVE
+
 		msmsdcc_disable_clocks(host, 1);
-#endif
+
 	}
 	return 0;
 }
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
