Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2JWNn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:38218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab2JWNnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191030"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 07/26] mmc: panic write: bypass host claiming
Date: Tue, 23 Oct 2012 16:48:05 +0300
Message-Id: <1351000104-13015-8-git-send-email-irina.tirdea@intel.com>
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
 drivers/mmc/core/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 06c42cf..dbe5332 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -767,6 +767,9 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
 	unsigned long flags;
 	int stop;
 
+	if (mmc_am_panic_task(host))
+		return 0;
+
 	might_sleep();
 
 	add_wait_queue(&host->wq, &wait);
@@ -807,6 +810,9 @@ int mmc_try_claim_host(struct mmc_host *host)
 	int claimed_host = 0;
 	unsigned long flags;
 
+	if (mmc_am_panic_task(host))
+		return 1;
+
 	spin_lock_irqsave(&host->lock, flags);
 	if (!host->claimed || host->claimer == current) {
 		host->claimed = 1;
@@ -837,6 +843,9 @@ void mmc_release_host(struct mmc_host *host)
 	if (host->ops->disable && host->claim_cnt == 1)
 		host->ops->disable(host);
 
+	if (mmc_am_panic_task(host))
+		return;
+
 	spin_lock_irqsave(&host->lock, flags);
 	if (--host->claim_cnt) {
 		/* Release for nested claim */
-- 
1.7.9.5

