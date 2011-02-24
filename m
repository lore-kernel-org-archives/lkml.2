Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1BXL0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:26:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:39663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab1BXL0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:26:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,216,1297065600"; 
   d="scan'208";a="606074906"
Date: Thu, 24 Feb 2011 19:19:35 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 1/1]mmc: set timeout for SDHCI host before sending busy cmd
Message-ID: <20110224111935.GB7169@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the timeout control register for SDHCI host when it needs to send some
commands which need busy signal. Use the maximum timeout value will be safe.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9e15f41..32b7475 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -40,7 +40,6 @@
 
 static unsigned int debug_quirks = 0;
 
-static void sdhci_prepare_data(struct sdhci_host *, struct mmc_data *);
 static void sdhci_finish_data(struct sdhci_host *);
 
 static void sdhci_send_command(struct sdhci_host *, struct mmc_command *);
@@ -651,16 +650,23 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
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
@@ -920,7 +926,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	host->cmd = cmd;
 
-	sdhci_prepare_data(host, cmd->data);
+	sdhci_prepare_data(host, cmd);
 
 	sdhci_writel(host, cmd->arg, SDHCI_ARGUMENT);
 
-- 
1.6.6.1

