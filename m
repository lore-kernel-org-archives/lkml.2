Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0LBL3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:29:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:6361 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab0LBL3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:29:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208,223";a="863528971"
Date: Thu, 2 Dec 2010 19:26:13 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATCH v3 2/3]set timeout control reg for such SDHCI host
Message-ID: <20101202112613.GC10358@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b1cc696f0fbb0c48f024359977624a862ece93f4 Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 2 Dec 2010 15:53:37 +0800
Subject: [PATCH 2/3] set timeout control reg for SDHCI host when sending erase cmd

Since if erasing needs longer time than the timeout host can wait, host will
generate a timeout interrupt and this will make erasing failed. So before
starting erasing, set the timeout control register value to be the maximum
one which is long enough for SDHCI host to wait.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c  |    4 ++++
 drivers/mmc/host/sdhci.c |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9fe16c2..fbac265 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -170,6 +170,9 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 
 	mrq->cmd->error = 0;
 	mrq->cmd->mrq = mrq;
+	if (mrq->cmd->opcode != MMC_ERASE)
+		mrq->cmd->erase_timeout = 0;
+
 	if (mrq->data) {
 		BUG_ON(mrq->data->blksz > host->max_blk_size);
 		BUG_ON(mrq->data->blocks > host->max_blk_count);
@@ -190,6 +193,7 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 			mrq->data->stop = mrq->stop;
 			mrq->stop->error = 0;
 			mrq->stop->mrq = mrq;
+			mrq->stop->erase_timeout = 0;
 		}
 	}
 	mmc_host_clk_ungate(host);
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b4448a9..de9685d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -949,6 +949,12 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	if (cmd->data)
 		flags |= SDHCI_CMD_DATA;
 
+	if (host->quirks & SDHCI_QUIRK_FORCE_ERASE_SINGLE) {
+		/* Set the timeout to be the maximum value */
+		if (cmd->erase_timeout)
+			sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
+	}
+
 	sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMMAND);
 }
 
-- 
1.6.6.1

