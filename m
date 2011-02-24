Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1BXLZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:25:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:46792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab1BXLZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:25:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,216,1297065600"; 
   d="scan'208";a="712700113"
Date: Thu, 24 Feb 2011 19:18:01 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: adrian.hunter@nokia.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1]mmc: fix division by zero when calculate mmc erase time
Message-ID: <20110224111801.GA7169@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since if clock gating feature is enabled, the clock frequency may be zero when
host clock is gated. In such scenario, mmc_set_mmc_erase_timeout() may have a
division by zero bug.

So this patch used mmc_host_clk_rate() to fix this.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 34a7e8c..12d0eb8 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1201,8 +1201,14 @@ static void mmc_set_mmc_erase_timeout(struct mmc_card *card,
 		 * less but not that much less, so fudge it by multiplying by 2.
 		 */
 		timeout_clks <<= 1;
-		timeout_us += (timeout_clks * 1000) /
-			      (card->host->ios.clock / 1000);
+
+		/*
+		 * at this moment, host controller maybe clock gated, so make
+		 * sure we can get a correct host clock freq.
+		 */
+		if (mmc_host_clk_rate(card->host))
+			timeout_us += (timeout_clks * 1000) /
+				      (mmc_host_clk_rate(card->host) / 1000);
 
 		erase_timeout = timeout_us / 1000;
 
-- 
1.6.6.1

