Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1CIINp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:13:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:6492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1CIINn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:13:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,289,1297065600"; 
   d="scan'208";a="718071919"
Date: Wed, 9 Mar 2011 16:06:09 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kmpark@infradead.org, prakity@marvell.com, jh80.chung@samsung.com,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH]mmc: set timeout for SDHCI host before sending busy cmds
Message-ID: <20110309080609.GA23207@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
   From the previous discussion, I do not think we have got a clear conclusion
   about using maximum timeout value. At least we know from Jae hoon Chung
   using 0xE for every case is not a good. So I want to suggest only use 0xE for
   busy command. I personally preferred below implementation, which is similar
   with a RFC patch submitted by Jae hoon Chung, but only without adding a new
   quirk.

   I think sdhci_calc_timeout should be left for data transfer since at least we
   can get a warning if 0xE is not enough for host to use. And if the host
   controller and the card have no bugs, then the calculated timeout should be
   safe. Left the old implementation unchanged is also compatible with all
   existed host controllers and cards.

   But for busy command, we are not clear about how long is safe enough for
   waiting and there is also no function to do the calculation for them. So
   preferred just using 0xE. Below the patch and comment:

Set the timeout control register for SDHCI host when send some commands which
need busy signal. Use the maximum timeout value 0xE will be safe.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 99c372e..8306323 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -659,8 +659,15 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 
 	WARN_ON(host->data);
 
-	if (data == NULL)
+	if (data == NULL) {
+		/*
+		 * set the timeout to be maximum value for commands those with
+		 * busy signal
+		 */
+		if (host->cmd->flags & MMC_RSP_BUSY)
+			sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
 		return;
+	}
 
 	/* Sanity checks */
 	BUG_ON(data->blksz * data->blocks > 524288);
-- 
1.6.6.1

