Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab2JWNnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:56255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab2JWNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191075"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 13/26] mmc: panic write: trap non panic tasks
Date: Tue, 23 Oct 2012 16:48:11 +0300
Message-Id: <1351000104-13015-14-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/core/core.c |   10 +++++++++-
 drivers/mmc/core/host.c |    2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d3caa7e..4fd7061 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -252,6 +252,7 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 	}
 	mmc_host_clk_hold(host);
 	led_trigger_event(host->led, LED_FULL);
+	mmc_trap_nonpanic_tasks(host);
 	host->ops->request(host, mrq);
 }
 
@@ -344,8 +345,10 @@ static void mmc_wait_for_req_done(struct mmc_host *host,
 
 	while (1) {
 		/* Panic task requests must be completed in ->request() */
-		if (!mmc_am_panic_task(host))
+		if (!mmc_am_panic_task(host)) {
 			wait_for_completion(&mrq->completion);
+			mmc_trap_nonpanic_tasks(host);
+		}
 
 		cmd = mrq->cmd;
 		if (!cmd->error || !cmd->retries ||
@@ -774,6 +777,8 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
 
 	if (mmc_am_panic_task(host))
 		return 0;
+	else
+		mmc_trap_nonpanic_tasks(host);
 
 	might_sleep();
 
@@ -817,6 +822,8 @@ int mmc_try_claim_host(struct mmc_host *host)
 
 	if (mmc_am_panic_task(host))
 		return 1;
+	else
+		mmc_trap_nonpanic_tasks(host);
 
 	spin_lock_irqsave(&host->lock, flags);
 	if (!host->claimed || host->claimer == current) {
@@ -880,6 +887,7 @@ static inline void mmc_set_ios(struct mmc_host *host)
 
 	if (ios->clock > 0)
 		mmc_set_ungated(host);
+	mmc_trap_nonpanic_tasks(host);
 	host->ops->set_ios(host, ios);
 }
 
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 6eda5a1..b76bfc8 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -90,6 +90,8 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
 	unsigned long freq = host->ios.clock;
 	unsigned long flags;
 
+	mmc_trap_nonpanic_tasks(host);
+
 	if (!freq) {
 		pr_debug("%s: frequency set to 0 in disable function, "
 			 "this means the clock is already disabled.\n",
-- 
1.7.9.5

