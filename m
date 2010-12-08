Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0LHLsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:48:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:12394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0LHLsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:48:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,315,1288594800"; 
   d="scan'208";a="581727786"
Date: Wed, 8 Dec 2010 19:45:11 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, adrian.hunter@nokia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2]remove the erase calculation part from core.c
Message-ID: <20101208114511.GB18249@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the erase calculation part from core.c

change the mmc_set_erase_timeout rountine to directly get
the erase timeout value according to arg type and erase
groups count.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c |  120 ++++++++++++++--------------------------------
 1 files changed, 37 insertions(+), 83 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6286898..6d1b9e5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1171,99 +1171,53 @@ void mmc_init_erase(struct mmc_card *card)
 	}
 }
 
-static void mmc_set_mmc_erase_timeout(struct mmc_card *card,
-				      struct mmc_command *cmd,
-				      unsigned int arg, unsigned int qty)
+/*
+ * mmc_set_erase_timeout: set the cmd erase_timeout according
+ * to the argument type and erase groups count
+ */
+static void mmc_set_erase_timeout(struct mmc_card *card,
+				  struct mmc_command *cmd, unsigned int arg,
+				  unsigned int qty)
 {
 	unsigned int erase_timeout;
 
-	if (card->ext_csd.erase_group_def & 1) {
-		/* High Capacity Erase Group Size uses HC timeouts */
-		if (arg == MMC_TRIM_ARG)
-			erase_timeout = card->ext_csd.trim_timeout;
-		else
-			erase_timeout = card->ext_csd.hc_erase_timeout;
+	if (mmc_card_sd(card)) {
+		erase_timeout = card->erase_timeout * qty;
+		if (card->ssr.erase_timeout)
+			/*
+			 * Erase timeout specified in SSR,
+			 * plus erase_offset
+			 * */
+			erase_timeout += card->ssr.erase_offset;
+		/* Must not be less than 1 second */
+		if (erase_timeout < 1000)
+			erase_timeout = 1000;
 	} else {
-		/* CSD Erase Group Size uses write timeout */
-		unsigned int mult = (10 << card->csd.r2w_factor);
-		unsigned int timeout_clks = card->csd.tacc_clks * mult;
-		unsigned int timeout_us;
-
-		/* Avoid overflow: e.g. tacc_ns=80000000 mult=1280 */
-		if (card->csd.tacc_ns < 1000000)
-			timeout_us = (card->csd.tacc_ns * mult) / 1000;
-		else
-			timeout_us = (card->csd.tacc_ns / 1000) * mult;
-
-		/*
-		 * ios.clock is only a target.  The real clock rate might be
-		 * less but not that much less, so fudge it by multiplying by 2.
-		 */
-		timeout_clks <<= 1;
-		timeout_us += (timeout_clks * 1000) /
-			      (card->host->ios.clock / 1000);
-
-		erase_timeout = timeout_us / 1000;
-
+		if (arg & MMC_SECURE_ARGS) {
+			if (arg == MMC_SECURE_ERASE_ARG)
+				erase_timeout = qty *
+					card->sec_erase_timeout;
+			else
+				erase_timeout = qty *
+					card->sec_trim_timeout;
+		} else {
+			if (arg == MMC_TRIM_ARG)
+				erase_timeout = qty *
+					card->trim_timeout;
+			else
+				erase_timeout = qty *
+					card->erase_timeout;
+		}
 		/*
-		 * Theoretically, the calculation could underflow so round up
-		 * to 1ms in that case.
+		 * Ensure at least a 1 second timeout for SPI as per
+		 * 'mmc_set_data_timeout()'
 		 */
-		if (!erase_timeout)
-			erase_timeout = 1;
-	}
-
-	/* Multiplier for secure operations */
-	if (arg & MMC_SECURE_ARGS) {
-		if (arg == MMC_SECURE_ERASE_ARG)
-			erase_timeout *= card->ext_csd.sec_erase_mult;
-		else
-			erase_timeout *= card->ext_csd.sec_trim_mult;
+		if (mmc_host_is_spi(card->host) && erase_timeout < 1000)
+			erase_timeout = 1000;
 	}
-
-	erase_timeout *= qty;
-
-	/*
-	 * Ensure at least a 1 second timeout for SPI as per
-	 * 'mmc_set_data_timeout()'
-	 */
-	if (mmc_host_is_spi(card->host) && erase_timeout < 1000)
-		erase_timeout = 1000;
-
 	cmd->erase_timeout = erase_timeout;
 }
 
-static void mmc_set_sd_erase_timeout(struct mmc_card *card,
-				     struct mmc_command *cmd, unsigned int arg,
-				     unsigned int qty)
-{
-	if (card->ssr.erase_timeout) {
-		/* Erase timeout specified in SD Status Register (SSR) */
-		cmd->erase_timeout = card->ssr.erase_timeout * qty +
-				     card->ssr.erase_offset;
-	} else {
-		/*
-		 * Erase timeout not specified in SD Status Register (SSR) so
-		 * use 250ms per write block.
-		 */
-		cmd->erase_timeout = 250 * qty;
-	}
-
-	/* Must not be less than 1 second */
-	if (cmd->erase_timeout < 1000)
-		cmd->erase_timeout = 1000;
-}
-
-static void mmc_set_erase_timeout(struct mmc_card *card,
-				  struct mmc_command *cmd, unsigned int arg,
-				  unsigned int qty)
-{
-	if (mmc_card_sd(card))
-		mmc_set_sd_erase_timeout(card, cmd, arg, qty);
-	else
-		mmc_set_mmc_erase_timeout(card, cmd, arg, qty);
-}
-
 static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 			unsigned int to, unsigned int arg)
 {
-- 
1.6.6.1

