Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2KHNJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:09:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:6707 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab2KHNDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102168"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 08/26] mmc: panic write: bypass request completion
Date: Thu,  8 Nov 2012 15:06:06 +0200
Message-Id: <1352379984-18381-9-git-send-email-dragos.tatulea@intel.com>
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

