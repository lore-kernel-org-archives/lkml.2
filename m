Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2ETNZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:25:45 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:6329 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755131Ab2ETNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:25:40 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2012 09:25:40 EDT
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH] mmc: block: Add write packing control
Date: Sun, 20 May 2012 16:16:45 +0300
Message-Id: <1337519805-31919-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1337519805-31919-1-git-send-email-merez@codeaurora.org>
References: <1337519805-31919-1-git-send-email-merez@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write packing control will ensure that read requests latency is
not increased due to long write packed commands.

The trigger for enabling the write packing is managing to pack several
write requests. The number of potential packed requests that will trigger
the packing can be configured via sysfs.
The trigger for disabling the write packing is a fetch of a read request.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/mmc/card/block.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/card/queue.c |    2 ++
 drivers/mmc/card/queue.h |    2 ++
 drivers/mmc/core/host.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |    5 ++++-
 5 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 2785fd4..c4f7573 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1313,6 +1313,43 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	mmc_queue_bounce_pre(mqrq);
 }

+static void mmc_blk_write_packing_control(struct mmc_queue *mq,
+					  struct request *req)
+{
+	struct mmc_host *host = mq->card->host;
+	int data_dir = 0;
+
+	if (!(host->caps2 & MMC_CAP2_PACKED_WR))
+		return;
+
+	if (!(host->caps2 & MMC_CAP2_PACKED_WR_CONTROL)) {
+		mq->write_packing_enabled = 1;
+		return;
+	}
+
+	if (!req || (req && (req->cmd_flags & REQ_FLUSH))) {
+		if (mq->num_of_potential_packed_wr_reqs >
+				host->num_wr_reqs_to_start_packing)
+			mq->write_packing_enabled = 1;
+		return;
+	}
+
+	data_dir = rq_data_dir(req);
+
+	if (data_dir == READ) {
+		mq->num_of_potential_packed_wr_reqs = 0;
+		mq->write_packing_enabled = 0;
+		return;
+	} else if (data_dir == WRITE) {
+		mq->num_of_potential_packed_wr_reqs++;
+	}
+
+	if (mq->num_of_potential_packed_wr_reqs >
+			host->num_wr_reqs_to_start_packing)
+		mq->write_packing_enabled = 1;
+
+}
+
 static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 {
 	struct request_queue *q = mq->queue;
@@ -1332,6 +1369,9 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 			!card->ext_csd.packed_event_en)
 		goto no_packed;

+	if (!mq->write_packing_enabled)
+		goto no_packed;
+
 	if ((rq_data_dir(cur) == WRITE) &&
 			(card->host->caps2 & MMC_CAP2_PACKED_WR))
 		max_packed_rw = card->ext_csd.max_packed_writes;
@@ -1396,6 +1436,8 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 			break;
 		}

+		if (rq_data_dir(next) == WRITE)
+			mq->num_of_potential_packed_wr_reqs++;
 		list_add_tail(&next->queuelist, &mq->mqrq_cur->packed_list);
 		cur = next;
 		reqs++;
@@ -1780,6 +1822,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		goto out;
 	}

+	mmc_blk_write_packing_control(mq, req);
+
 	if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 165d85a..2d8dcd9 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -181,6 +181,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	mq->mqrq_cur = mqrq_cur;
 	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
+	mq->write_packing_enabled = 0;
+	mq->num_of_potential_packed_wr_reqs = 0;

 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index d761bf1..c5fd2ac 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -44,6 +44,8 @@ struct mmc_queue {
 	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
 	struct mmc_queue_req	*mqrq_prev;
+	int			write_packing_enabled;
+	int			num_of_potential_packed_wr_reqs;
 };

 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 91c84c7..d7e3552 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -345,6 +345,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	host->max_blk_size = 512;
 	host->max_blk_count = PAGE_CACHE_SIZE / 512;

+	host->num_wr_reqs_to_start_packing = 17;
+
 	return host;

 free:
@@ -353,6 +355,49 @@ free:
 }

 EXPORT_SYMBOL(mmc_alloc_host);
+static ssize_t
+show_num_wr_reqs_to_start_packing(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct mmc_host *host = dev_get_drvdata(dev);
+	int num_wr_reqs_to_start_packing = 0;
+
+	spin_lock(&host->lock);
+	num_wr_reqs_to_start_packing = host->num_wr_reqs_to_start_packing;
+	spin_unlock(&host->lock);
+
+	return snprintf(buf, PAGE_SIZE, "num_wr_reqs_to_start_packing = %d\n",
+					num_wr_reqs_to_start_packing);
+}
+
+static ssize_t
+set_num_wr_reqs_to_start_packing(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int value;
+	struct mmc_host *host = dev_get_drvdata(dev);
+	sscanf(buf, "%d", &value);
+	if (value) {
+		spin_lock(&host->lock);
+		host->num_wr_reqs_to_start_packing = value;
+		spin_unlock(&host->lock);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(num_wr_reqs_to_start_packing, S_IRUGO | S_IWUSR,
+		show_num_wr_reqs_to_start_packing,
+		set_num_wr_reqs_to_start_packing);
+
+static struct attribute *dev_attrs[] = {
+	&dev_attr_num_wr_reqs_to_start_packing.attr,
+	NULL,
+};
+static struct attribute_group dev_attr_grp = {
+	.attrs = dev_attrs,
+};

 /**
  *	mmc_add_host - initialise host hardware
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9d0d946..55667a0 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -242,7 +242,7 @@ struct mmc_host {
 #define MMC_CAP2_PACKED_WR	(1 << 11)	/* Allow packed write */
 #define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
 				 MMC_CAP2_PACKED_WR) /* Allow packed commands */
-
+#define MMC_CAP2_PACKED_WR_CONTROL (1 << 12) /* Allow write packing control */
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
 #define MMC_HOST_PW_NOTIFY_NONE		0
@@ -324,6 +324,9 @@ struct mmc_host {

 	unsigned int		actual_clock;	/* Actual HC clock rate */

+	/* Write packing control attributes */
+	int			num_wr_reqs_to_start_packing;
+
 	unsigned long		private[0] ____cacheline_aligned;
 };

--
1.7.3.3
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
