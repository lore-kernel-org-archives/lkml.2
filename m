Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2IQJxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:53:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53405 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2IQJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:53:51 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, jassisinghbrar@gmail.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_req()
Date: Mon, 17 Sep 2012 15:20:22 +0530
Message-Id: <1347875423-7970-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'r->cfg' is being checked for NULL. However, it is dereferenced
in the previous statements. Thus moving those statements within
the check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/pl330.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 2343d7d..018a445 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1567,17 +1567,19 @@ static int pl330_submit_req(void *ch_id, struct pl330_req *r)
 		goto xfer_exit;
 	}
 
-	/* Prefer Secure Channel */
-	if (!_manager_ns(thrd))
-		r->cfg->nonsecure = 0;
-	else
-		r->cfg->nonsecure = 1;
 
 	/* Use last settings, if not provided */
-	if (r->cfg)
+	if (r->cfg) {
+		/* Prefer Secure Channel */
+		if (!_manager_ns(thrd))
+			r->cfg->nonsecure = 0;
+		else
+			r->cfg->nonsecure = 1;
+
 		ccr = _prepare_ccr(r->cfg);
-	else
+	} else {
 		ccr = readl(regs + CC(thrd->id));
+	}
 
 	/* If this req doesn't have valid xfer settings */
 	if (!_is_valid(ccr)) {
-- 
1.7.4.1

