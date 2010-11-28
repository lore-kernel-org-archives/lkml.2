Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab0K1GOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 01:14:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:56336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0K1GOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 01:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,268,1288594800"; 
   d="scan'208,223";a="630872768"
Date: Sun, 28 Nov 2010 13:48:18 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3]mmc: enable runtime PM support for block driver
Message-ID: <20101128054818.GB3318@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 51e4d34f19b48552a10a9f6b69f51c5aeed18d03 Mon Sep 17 00:00:00 2001
From: Yunpeng Gao <yunpeng.gao@intel.com>
Date: Sun, 28 Nov 2010 08:01:01 +0800
Subject: [PATCH] Enable runtime pm support for block driver of mmc stack.

Follow the kernel runtime pm framework, this patch enable
runtime pm support for block driver of mmc stack.
To validate it, it needs runtime pm support for mmc bus
and host controller to be enabled also.

Signed-off-by: Yunpeng Gao <yunpeng.gao@intel.com>
---
 drivers/mmc/card/block.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..8a35814 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -560,14 +561,24 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	int ret;
+
+	pm_runtime_get_sync(&card->dev);
+
 	if (req->cmd_flags & REQ_DISCARD) {
 		if (req->cmd_flags & REQ_SECURE)
-			return mmc_blk_issue_secdiscard_rq(mq, req);
+			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
-			return mmc_blk_issue_discard_rq(mq, req);
+			ret = mmc_blk_issue_discard_rq(mq, req);
 	} else {
-		return mmc_blk_issue_rw_rq(mq, req);
+		ret = mmc_blk_issue_rw_rq(mq, req);
 	}
+
+	pm_runtime_put(&card->dev);
+
+	return ret;
 }
 
 static inline int mmc_blk_readonly(struct mmc_card *card)
@@ -709,6 +720,11 @@ static int mmc_blk_probe(struct mmc_card *card)
 
 	mmc_set_drvdata(card, md);
 	add_disk(md->disk);
+
+	/* Indicate to runtime PM core that our device is active */
+	pm_runtime_set_active(&card->dev);
+	pm_runtime_enable(&card->dev);
+
 	return 0;
 
  out:
@@ -732,6 +748,8 @@ static void mmc_blk_remove(struct mmc_card *card)
 		mmc_blk_put(md);
 	}
 	mmc_set_drvdata(card, NULL);
+
+	pm_runtime_disable(&card->dev);
 }
 
 #ifdef CONFIG_PM
-- 
1.6.6.1

