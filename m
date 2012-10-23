Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab2JWNsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:48:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:42614 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054Ab2JWNnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191036"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 08/26] mmc: panic write: bypass request completion
Date: Tue, 23 Oct 2012 16:48:06 +0300
Message-Id: <1351000104-13015-9-git-send-email-irina.tirdea@intel.com>
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
 drivers/mmc/core/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index dbe5332..6b2377a 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -148,6 +148,9 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 			cmd->retries = 0;
 	}
 
+	if (mmc_am_panic_task(host))
+		return;
+
 	if (err && cmd->retries && !mmc_card_removed(host->card)) {
 		/*
 		 * Request starter must handle retries - see
@@ -340,7 +343,9 @@ static void mmc_wait_for_req_done(struct mmc_host *host,
 	struct mmc_command *cmd;
 
 	while (1) {
-		wait_for_completion(&mrq->completion);
+		/* Panic task requests must be completed in ->request() */
+		if (!mmc_am_panic_task(host))
+			wait_for_completion(&mrq->completion);
 
 		cmd = mrq->cmd;
 		if (!cmd->error || !cmd->retries ||
-- 
1.7.9.5

