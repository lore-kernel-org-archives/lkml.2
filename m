Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2KHNEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:04:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:7521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab2KHND7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102248"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 11/26] mmc: panic write: bypass clock gating
Date: Thu,  8 Nov 2012 15:06:09 +0200
Message-Id: <1352379984-18381-12-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
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

