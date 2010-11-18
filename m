Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0KRJDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:03:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:52104 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab0KRJDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:03:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,216,1288594800"; 
   d="scan'208,223";a="575038044"
Date: Thu, 18 Nov 2010 17:00:53 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, arjan@linux.intel.com
Subject: [PATCH v2 2/3]mmc: set erase control register for SDHCI HC
Message-ID: <20101118090053.GC18161@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6ddad5c28d1f2d57081df051b79912dde922e322 Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 18 Nov 2010 16:20:39 +0800
Subject: [PATCH 2/3] mmc: set erase control reg value for sdhci HC

For those sdhci host controller which cannot erase the unlimited sectors,
set their timeout value to be the maximum one which is safe for erasing.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c  |    4 ++++
 drivers/mmc/host/sdhci.c |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 947d963..0b77739 100644
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
index fa66988..a466635 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -946,6 +946,12 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
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

