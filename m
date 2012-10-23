Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2JWNnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:21045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab2JWNn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191060"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 11/26] mmc: panic write: bypass clock gating
Date: Tue, 23 Oct 2012 16:48:09 +0300
Message-Id: <1351000104-13015-12-git-send-email-irina.tirdea@intel.com>
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
 drivers/mmc/core/core.c |    5 +++++
 drivers/mmc/core/host.c |    9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 204a9bd..f7552af 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -956,6 +956,11 @@ void mmc_set_ungated(struct mmc_host *host)
 {
 	unsigned long flags;
 
+	if (mmc_am_panic_task(host)) {
+		host->clk_gated = false;
+		return;
+	}
+
 	/*
 	 * We've been given a new frequency while the clock is gated,
 	 * so make sure we regard this as ungating it.
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index ee2e16b..6eda5a1 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -153,6 +153,12 @@ void mmc_host_clk_hold(struct mmc_host *host)
 {
 	unsigned long flags;
 
+	if (mmc_am_panic_task(host)) {
+		if (host->clk_gated)
+			mmc_ungate_clock(host);
+		return;
+	}
+
 	/* cancel any clock gating work scheduled by mmc_host_clk_release() */
 	cancel_delayed_work_sync(&host->clk_gate_work);
 	mutex_lock(&host->clk_gate_mutex);
@@ -200,6 +206,9 @@ void mmc_host_clk_release(struct mmc_host *host)
 {
 	unsigned long flags;
 
+	if (mmc_am_panic_task(host))
+		return;
+
 	spin_lock_irqsave(&host->clk_lock, flags);
 	host->clk_requests--;
 	if (mmc_host_may_gate_card(host->card) &&
-- 
1.7.9.5

