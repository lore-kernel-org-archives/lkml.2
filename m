Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2BUOBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:01:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15737 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2BUOBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:01:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="162632916"
From: Yaniv Gardi <ygardi@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, axboe@kernel.dk, ygardi@codeaurora.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/2] mmc: card: Adding support for Sanitize in eMMC v4.5
Date: Tue, 21 Feb 2012 16:00:25 +0200
Message-Id: <1329832825-8844-3-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1329832825-8844-1-git-send-email-ygardi@codeaurora.org>
References: <1329832825-8844-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/mmc/card/block.c |   58 ++++++++++++++++++++++++++++++++++++++-------
 drivers/mmc/card/queue.c |   12 ++++++++-
 include/linux/mmc/card.h |    7 +++++
 include/linux/mmc/host.h |    1 +
 4 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 0c959c9..5be77e6 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -830,6 +830,9 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	from = blk_rq_pos(req);
 	nr = blk_rq_sectors(req);
 
+	/* 1ST priority is DISCARD.
+	   2ND is TRIM
+	   3RD is ERASE */
 	if (mmc_can_discard(card))
 		arg = MMC_DISCARD_ARG;
 	else if (mmc_can_trim(card))
@@ -868,18 +871,11 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 	unsigned int from, nr, arg;
 	int err = 0, type = MMC_BLK_SECDISCARD;
 
-	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))) {
+	if (!(mmc_can_secure_erase_trim(card))) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	/* The sanitize operation is supported at v4.5 only */
-	if (mmc_can_sanitize(card)) {
-		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_SANITIZE_START, 1, 0);
-		goto out;
-	}
-
 	from = blk_rq_pos(req);
 	nr = blk_rq_sectors(req);
 
@@ -922,6 +918,44 @@ out:
 	return err ? 0 : 1;
 }
 
+int mmc_blk_issue_sanitize_rq(struct mmc_queue *mq,
+			       struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	int err = 0;
+
+	if (!(mmc_can_sanitize(card) && (mq->card->host->caps2 & MMC_CAP2_SANITIZE))) {
+		pr_err("%s: SANITIZE is not supported", __func__);
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	pr_info("%s: SANITIZE is supported", __func__);
+
+	mmc_sd_card_set_sanitize_in_progress(card);
+
+	pr_info("%s: issueing SANITIZE command...", __func__);
+
+	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+					 EXT_CSD_SANITIZE_START, 1, 0);
+
+	pr_info("%s: SANITIZE command returned...", __func__);
+
+	if (err)
+		pr_err("%s: mmcblk: mmc_switch() failed. err=%d\n",
+		       __func__, err);
+
+	mmc_sd_card_set_sanitize_completed(card);
+
+out:
+	spin_lock_irq(&md->lock);
+	__blk_end_request(req, err, blk_rq_bytes(req));
+	spin_unlock_irq(&md->lock);
+
+	return err ? 0 : 1;
+}
+
 static int mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -1379,7 +1413,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		goto out;
 	}
 
-	if (req && req->cmd_flags & REQ_DISCARD) {
+	if (req && req->cmd_flags & REQ_SANITIZE) {
+		/* complete ongoing async transfer before issuing discard */
+		if (card->host && card->host->areq)
+			mmc_blk_issue_rw_rq(mq, NULL);
+		ret = mmc_blk_issue_sanitize_rq(mq, req);
+	} else if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -1396,6 +1435,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		ret = mmc_blk_issue_rw_rq(mq, req);
 	}
 
+
 out:
 	if (!req)
 		/* release host only when there are no more requests */
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index dcad59c..6946ac1 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -140,10 +140,15 @@ static void mmc_queue_setup_discard(struct request_queue *q,
 	/* granularity must not be greater than max. discard */
 	if (card->pref_erase > max_discard)
 		q->limits.discard_granularity = 0;
-	if (mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))
+	if (mmc_can_secure_erase_trim(card))
 		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
 }
 
+static void mmc_queue_setup_sanitize(struct request_queue *q)
+{
+	queue_flag_set_unlocked(QUEUE_FLAG_SANITIZE, q);
+}
+
 /**
  * mmc_init_queue - initialise a queue structure.
  * @mq: mmc queue
@@ -181,6 +186,11 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	if (mmc_can_erase(card))
 		mmc_queue_setup_discard(mq->queue, card);
 
+	if ((mmc_can_sanitize(card) && (host->caps2 & MMC_CAP2_SANITIZE)))
+		mmc_queue_setup_sanitize(mq->queue);
+	else
+		pr_info("%s - card doesn't support sanitize", __func__);
+
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
 	if (host->max_segs == 1) {
 		unsigned int bouncesz;
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 9478a6b..0890e9c 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -236,6 +236,9 @@ struct mmc_card {
 #define MMC_POWEROFF_SHORT		2
 #define MMC_POWEROFF_LONG		3
 
+/* card is in sanitize progress */
+#define MMC_STATE_SANITIZE_IN_PROGRESS (1<<9)
+
 	unsigned int		erase_size;	/* erase size in sectors */
  	unsigned int		erase_shift;	/* if erase unit is power 2 */
  	unsigned int		pref_erase;	/* in sectors */
@@ -388,6 +391,10 @@ static inline void __maybe_unused remove_quirk(struct mmc_card *card, int data)
 #define mmc_card_set_ddr_mode(c) ((c)->state |= MMC_STATE_HIGHSPEED_DDR)
 #define mmc_card_set_uhs(c) ((c)->state |= MMC_STATE_ULTRAHIGHSPEED)
 #define mmc_sd_card_set_uhs(c) ((c)->state |= MMC_STATE_ULTRAHIGHSPEED)
+#define mmc_sd_card_set_sanitize_in_progress(c) ((c)->state |= \
+		MMC_STATE_SANITIZE_IN_PROGRESS)
+#define mmc_sd_card_set_sanitize_completed(c) ((c)->state &= \
+		~MMC_STATE_SANITIZE_IN_PROGRESS)
 #define mmc_card_set_ext_capacity(c) ((c)->state |= MMC_CARD_SDXC)
 #define mmc_card_set_removed(c) ((c)->state |= MMC_CARD_REMOVED)
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9a03d03..93210aa 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -242,6 +242,7 @@ struct mmc_host {
 #define MMC_CAP2_CACHE_CTRL	(1 << 1)	/* Allow cache control */
 #define MMC_CAP2_POWEROFF_NOTIFY (1 << 2)	/* Notify poweroff supported */
 #define MMC_CAP2_NO_MULTI_READ	(1 << 3)	/* Multiblock reads don't work */
+#define MMC_CAP2_SANITIZE	(1<<4)		/* Support Sanitize */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
-- 
1.7.6
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
