Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2KHNEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:04:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:24988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab2KHNEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:04:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102396"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 17/26] mmc: sdhci: panic write: call tasklets inline
Date: Thu,  8 Nov 2012 15:06:15 +0200
Message-Id: <1352379984-18381-18-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

When in panic task, we need to schedule other tasklets than normally.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/host/sdhci.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 827e34f..ff72e98 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -914,6 +914,17 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 	sdhci_writew(host, mode, SDHCI_TRANSFER_MODE);
 }
 
+static void sdhci_tasklet_card(unsigned long param);
+static void sdhci_tasklet_finish(unsigned long param);
+
+#define sdhci_sched_tasklet(host, name)				\
+{								\
+	if (mmc_am_panic_task(host->mmc))			\
+		sdhci_tasklet_##name((unsigned long)host);	\
+	else							\
+		tasklet_schedule(&host->name##_tasklet);	\
+}
+
 static void sdhci_finish_data(struct sdhci_host *host)
 {
 	struct mmc_data *data;
@@ -965,7 +976,7 @@ static void sdhci_finish_data(struct sdhci_host *host)
 
 		sdhci_send_command(host, data->stop);
 	} else
-		tasklet_schedule(&host->finish_tasklet);
+		sdhci_sched_tasklet(host, finish);
 }
 
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
@@ -994,7 +1005,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 				"inhibit bit(s).\n", mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			cmd->error = -EIO;
-			tasklet_schedule(&host->finish_tasklet);
+			sdhci_sched_tasklet(host, finish);
 			return;
 		}
 		timeout--;
@@ -1015,7 +1026,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 		pr_err("%s: Unsupported response type!\n",
 			mmc_hostname(host->mmc));
 		cmd->error = -EINVAL;
-		tasklet_schedule(&host->finish_tasklet);
+		sdhci_sched_tasklet(host, finish);
 		return;
 	}
 
@@ -1076,7 +1087,7 @@ static void sdhci_finish_command(struct sdhci_host *host)
 			sdhci_finish_data(host);
 
 		if (!host->cmd->data)
-			tasklet_schedule(&host->finish_tasklet);
+			sdhci_sched_tasklet(host, finish);
 
 		host->cmd = NULL;
 	}
@@ -1303,7 +1314,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	if (!present || host->flags & SDHCI_DEVICE_DEAD) {
 		host->mrq->cmd->error = -ENOMEDIUM;
-		tasklet_schedule(&host->finish_tasklet);
+		sdhci_sched_tasklet(host, finish);
 	} else {
 		u32 present_state;
 
@@ -2079,7 +2090,7 @@ static void sdhci_tasklet_card(unsigned long param)
 		sdhci_reset(host, SDHCI_RESET_DATA);
 
 		host->mrq->cmd->error = -ENOMEDIUM;
-		tasklet_schedule(&host->finish_tasklet);
+		sdhci_sched_tasklet(host, finish);
 	}
 
 	sdhci_unlock_irqrestore(host, flags);
@@ -2174,7 +2185,7 @@ static void sdhci_timeout_timer(unsigned long data)
 			else
 				host->mrq->cmd->error = -ETIMEDOUT;
 
-			tasklet_schedule(&host->finish_tasklet);
+			sdhci_sched_tasklet(host, finish);
 		}
 	}
 
@@ -2221,7 +2232,7 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 		host->cmd->error = -EILSEQ;
 
 	if (host->cmd->error) {
-		tasklet_schedule(&host->finish_tasklet);
+		sdhci_sched_tasklet(host, finish);
 		return;
 	}
 
@@ -2429,7 +2440,7 @@ again:
 		sdhci_writel(host, intmask & (SDHCI_INT_CARD_INSERT |
 			     SDHCI_INT_CARD_REMOVE), SDHCI_INT_STATUS);
 		intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
-		tasklet_schedule(&host->card_tasklet);
+		sdhci_sched_tasklet(host, card);
 	}
 
 	if (intmask & SDHCI_INT_CMD_MASK) {
@@ -3192,7 +3203,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 				" transfer!\n", mmc_hostname(host->mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			tasklet_schedule(&host->finish_tasklet);
+			sdhci_sched_tasklet(host, finish);
 		}
 
 		sdhci_unlock_irqrestore(host, flags);
-- 
1.7.9.5

