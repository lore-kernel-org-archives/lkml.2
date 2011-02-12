Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1BLG3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 01:29:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:37203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657Ab1BLG27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 01:28:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,460,1291622400"; 
   d="scan'208";a="656984000"
Date: Sat, 12 Feb 2011 14:22:26 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATCH v4 3/3]mmc: fix division by zero when cal erase timeout
Message-ID: <20110212062226.GD25519@intel.com>
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
index 0eb27aa..2f4576d 100644
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

