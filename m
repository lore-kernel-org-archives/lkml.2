Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab2JWNpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:45:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:19320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138Ab2JWNns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191327"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 24/26] mmc: sdhci: panic write: abort request in progress
Date: Tue, 23 Oct 2012 16:48:22 +0300
Message-Id: <1351000104-13015-25-git-send-email-irina.tirdea@intel.com>
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
 drivers/mmc/host/sdhci.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 496adc8..9a24417 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1351,6 +1351,11 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	sdhci_lock_irqsave(host, flags);
 
+	if (mmc_am_panic_task(mmc) && host->mrq) {
+		host->mrq->cmd->error = -EILSEQ;
+		sdhci_sched_tasklet(host, finish);
+	}
+
 	WARN_ON(host->mrq != NULL);
 
 #ifndef SDHCI_USE_LEDS_CLASS
-- 
1.7.9.5

