Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0LHLsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:48:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:38091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0LHLsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:48:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,315,1288594800"; 
   d="scan'208";a="685081635"
Date: Wed, 8 Dec 2010 19:44:52 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, adrian.hunter@nokia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2]move erase timeout calculation part to mmc.c and sd.c
Message-ID: <20101208114452.GA18249@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi adrian,
   this 2 patches modify the erase timeout calculation part which added by
   you. Can you help to review that? Thanks.


Since mmc and sd erase timeout calculation only depends on
card registers and host clock, it can be done during card
initialization. No need to calculated the erase timeout value
for erase/trim command before each time sending.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/mmc.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sd.c    |   19 +++++++++++++++++
 include/linux/mmc/card.h |    4 +++
 3 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 77f93c3..ee2f196 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -118,6 +118,54 @@ static void mmc_set_erase_size(struct mmc_card *card)
 	mmc_init_erase(card);
 }
 
+static void mmc_set_mmc_erase_timeout(struct mmc_card *card)
+{
+	unsigned int erase_timeout;
+
+	if (card->ext_csd.erase_group_def & 1) {
+		/* High Capacity Erase Group Size uses HC timeouts */
+		card->trim_timeout = card->ext_csd.trim_timeout;
+		card->erase_timeout = card->ext_csd.hc_erase_timeout;
+	} else {
+		/* CSD Erase Group Size uses write timeout */
+		unsigned int mult = (10 << card->csd.r2w_factor);
+		unsigned int timeout_clks = card->csd.tacc_clks * mult;
+		unsigned int timeout_us;
+
+		/* Avoid overflow: e.g. tacc_ns=80000000 mult=1280 */
+		if (card->csd.tacc_ns < 1000000)
+			timeout_us = (card->csd.tacc_ns * mult) / 1000;
+		else
+			timeout_us = (card->csd.tacc_ns / 1000) * mult;
+
+		/*
+		 * ios.clock is only a target.  The real clock rate might be
+		 * less but not that much less, so fudge it by multiplying by 2.
+		 */
+		timeout_clks <<= 1;
+		timeout_us += (timeout_clks * 1000) /
+			      (card->host->ios.clock / 1000);
+
+		erase_timeout = timeout_us / 1000;
+
+		/*
+		 * Theoretically, the calculation could underflow so round up
+		 * to 1ms in that case.
+		 */
+		if (!erase_timeout)
+			erase_timeout = 1;
+
+		card->trim_timeout = erase_timeout;
+		card->erase_timeout = erase_timeout;
+	}
+
+	/* Multiplier for secure operations */
+	card->sec_trim_timeout = card->erase_timeout *
+		card->ext_csd.sec_trim_mult;
+	card->sec_erase_timeout = card->erase_timeout *
+		card->ext_csd.sec_erase_mult;
+}
+
 /*
  * Given a 128-bit response, decode to our card CSD structure.
  */
@@ -528,6 +576,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 			&& (host->caps & (MMC_CAP_1_2V_DDR)))
 				ddr = MMC_1_2V_DDR_MODE;
 	}
+	/* Erase/trim timeout depends on CSD, EXT_CSD and host clock */
+	mmc_set_mmc_erase_timeout(card);
 
 	/*
 	 * Activate wide bus and DDR (if supported).
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 49da4df..f9afff7 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -250,6 +250,20 @@ out:
 	return err;
 }
 
+static void mmc_set_sd_erase_timeout(struct mmc_card *card)
+{
+	if (card->ssr.erase_timeout)
+		/* Erase timeout specified in SD Status Register (SSR) */
+		card->erase_timeout = card->ssr.erase_timeout;
+	else
+		/*
+		 * Erase timeout not specified in SD Status Register (SSR) so
+		 * use 250ms per write block.
+		 */
+		card->erase_timeout = 250;
+}
+
+
 /*
  * Fetches and decodes switch information
  */
@@ -624,6 +638,11 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	mmc_set_clock(host, mmc_sd_get_max_clock(card));
 
 	/*
+	 * Set erase timeout
+	 * */
+	mmc_set_sd_erase_timeout(card);
+
+	/*
 	 * Switch to wider bus (if supported).
 	 */
 	if ((host->caps & MMC_CAP_4_BIT_DATA) &&
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8ce0827..e95c770 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -126,6 +126,10 @@ struct mmc_card {
  	unsigned int		erase_shift;	/* if erase unit is power 2 */
  	unsigned int		pref_erase;	/* in sectors */
  	u8			erased_byte;	/* value of erased bytes */
+	unsigned int	erase_timeout; /* erase timeout value in ms per blk */
+	unsigned int	trim_timeout; /* trim timeout value in ms per blk */
+	unsigned int	sec_erase_timeout; /* sec erase timeout in ms per blk */
+	unsigned int	sec_trim_timeout; /* sec trim timeout in ms per blk */
 
 	u32			raw_cid[4];	/* raw card CID */
 	u32			raw_csd[4];	/* raw card CSD */
-- 
1.6.6.1

