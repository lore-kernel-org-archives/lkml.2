Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1BLG3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 01:29:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:37203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650Ab1BLG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 01:28:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,460,1291622400"; 
   d="scan'208";a="886826361"
Date: Sat, 12 Feb 2011 14:22:20 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATCH v4 2/3]mmc: enable TRIM/ERASE caps for SDHCI host
Message-ID: <20110212062220.GC25519@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHCI host controller has TRIM/ERASE capability, enable these caps for erasing
purpose.

ERASE command needs R1B response. So for such command with busy signal, before
sending command, SDHCI host driver will simply set a maximum value for timeout
control register which is safe to use.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 655617c..fe7cbd0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -41,7 +41,6 @@
 
 static unsigned int debug_quirks = 0;
 
-static void sdhci_prepare_data(struct sdhci_host *, struct mmc_data *);
 static void sdhci_finish_data(struct sdhci_host *);
 
 static void sdhci_send_command(struct sdhci_host *, struct mmc_command *);
@@ -652,16 +651,23 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
 		sdhci_clear_set_irqs(host, dma_irqs, pio_irqs);
 }
 
-static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
+static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 {
 	u8 count;
 	u8 ctrl;
+	struct mmc_data *data = cmd->data;
 	int ret;
 
 	WARN_ON(host->data);
 
-	if (data == NULL)
+	if (data == NULL) {
+		/*
+		 * set timeout to be maximum value for command with busy signal.
+		 */
+		if (cmd->flags & MMC_RSP_BUSY)
+			sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
 		return;
+	}
 
 	/* Sanity checks */
 	BUG_ON(data->blksz * data->blocks > 524288);
@@ -921,7 +927,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	host->cmd = cmd;
 
-	sdhci_prepare_data(host, cmd->data);
+	sdhci_prepare_data(host, cmd);
 
 	sdhci_writel(host, cmd->arg, SDHCI_ARGUMENT);
 
@@ -1939,7 +1945,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->f_min = host->max_clk / SDHCI_MAX_DIV_SPEC_200;
 
 	mmc->f_max = host->max_clk;
-	mmc->caps |= MMC_CAP_SDIO_IRQ;
+	mmc->caps |= MMC_CAP_SDIO_IRQ | MMC_CAP_ERASE;
 
 	/*
 	 * A controller may support 8-bit width, but the board itself
-- 
1.6.6.1

