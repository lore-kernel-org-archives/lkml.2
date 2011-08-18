Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1HRMXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:23:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:53444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab1HRMXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:23:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,245,1312182000"; 
   d="scan'208";a="41088465"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 3/3] mmc: use non-reentrant workqueue for clock gating
Date: Thu, 18 Aug 2011 15:23:49 +0300
Message-Id: <3a0f9b45bda585158ba89d15d63967005367e834.1313664897.git.mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1313664897.git.mika.westerberg@linux.intel.com>
References: <cover.1313664897.git.mika.westerberg@linux.intel.com>
In-Reply-To: <cover.1313664897.git.mika.westerberg@linux.intel.com>
References: <cover.1313664897.git.mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default multithread workqueue can cause the same work to be executed
concurrently on a different CPUs. This isn't really suitable for clock
gating as it might already gated the clock and gating it twice results both
host->clk_old and host->ios.clock to be set to 0.

To prevent this from happening we use system_nrt_wq instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/core/host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 96a26b2..793d0a0 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -179,7 +179,7 @@ void mmc_host_clk_release(struct mmc_host *host)
 	host->clk_requests--;
 	if (mmc_host_may_gate_card(host->card) &&
 	    !host->clk_requests)
-		schedule_work(&host->clk_gate_work);
+		queue_work(system_nrt_wq, &host->clk_gate_work);
 	spin_unlock_irqrestore(&host->clk_lock, flags);
 }
 
-- 
1.7.5.4

