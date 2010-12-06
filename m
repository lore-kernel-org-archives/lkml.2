Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0LFMrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:47:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:32927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0LFMrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:47:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,305,1288594800"; 
   d="scan'208,223";a="684318182"
Date: Mon, 6 Dec 2010 20:19:42 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3]mmc: enable runtime PM support for block driver
Message-ID: <20101206121941.GB30654@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From d444eb5e525e646324451bad5d27e3c13821bbf0 Mon Sep 17 00:00:00 2001
From: Yunpeng Gao <yunpeng.gao@intel.com>
Date: Mon, 6 Dec 2010 18:58:25 +0800
Subject: [PATCH] Add runtime pm support to block driver of mmc stack.

Now use pm_runtime_put_autosuspend() API and set the autosuspend_delay to 100ms.

Signed-off-by: Yunpeng Gao <yunpeng.gao@intel.com>
---
 drivers/mmc/card/block.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..1bd707a 100644
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
+	pm_runtime_put_autosuspend(&card->dev);
+
+	return ret;
 }
 
 static inline int mmc_blk_readonly(struct mmc_card *card)
@@ -709,6 +720,14 @@ static int mmc_blk_probe(struct mmc_card *card)
 
 	mmc_set_drvdata(card, md);
 	add_disk(md->disk);
+
+	/* Indicate to runtime PM core that our device is active */
+	pm_runtime_set_active(&card->dev);
+	pm_runtime_enable(&card->dev);
+
+	/* Set its autosuspend_delay to 100ms */
+	pm_runtime_set_autosuspend_delay(&card->dev, 100);
+
 	return 0;
 
  out:
@@ -732,6 +751,8 @@ static void mmc_blk_remove(struct mmc_card *card)
 		mmc_blk_put(md);
 	}
 	mmc_set_drvdata(card, NULL);
+
+	pm_runtime_disable(&card->dev);
 }
 
 #ifdef CONFIG_PM
-- 
1.6.6.1

