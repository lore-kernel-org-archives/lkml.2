Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab2FAS4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:56:03 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:16502 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933626Ab2FAS4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:56:01 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/1] mmc: block: Add write packing control
Date: Fri,  1 Jun 2012 21:55:11 +0300
Message-Id: <1338576911-17089-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write packing control will ensure that read requests latency is
not increased due to long write packed commands.

The trigger for enabling the write packing is managing to pack several
write requests. The number of potential packed requests that will trigger
the packing can be configured via sysfs by writing the required value to:
/sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
The trigger for disabling the write packing is fetching a read request.

---
 Documentation/mmc/mmc-dev-attrs.txt |   17 ++++++
 drivers/mmc/card/block.c            |  100 ++++++++++++++++++++++++++++++++++-
 drivers/mmc/card/queue.c            |    8 +++
 drivers/mmc/card/queue.h            |    3 +
 include/linux/mmc/host.h            |    1 +
 5 files changed, 128 insertions(+), 1 deletions(-)

diff --git a/Documentation/mmc/mmc-dev-attrs.txt b/Documentation/mmc/mmc-dev-attrs.txt
index 22ae844..08f7312 100644
--- a/Documentation/mmc/mmc-dev-attrs.txt
+++ b/Documentation/mmc/mmc-dev-attrs.txt
@@ -8,6 +8,23 @@ The following attributes are read/write.

 	force_ro		Enforce read-only access even if write protect switch is off.

+	num_wr_reqs_to_start_packing 	This attribute is used to determine
+	the trigger for activating the write packing, in case the write
+	packing control feature is enabled.
+
+	When the MMC manages to reach a point where num_wr_reqs_to_start_packing
+	write requests could be packed, it enables the write packing feature.
+	This allows us to start the write packing only when it is beneficial
+	and has minimum affect on the read latency.
+
+	The number of potential packed requests that will trigger the packing
+	can be configured via sysfs by writing the required value to:
+	/sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
+
+	The default value of num_wr_reqs_to_start_packing was determined by
+	running parallel lmdd write and lmdd read operations and calculating
+	the max number of packed writes requests.
+
 SD and MMC Device Attributes
 ============================

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 2785fd4..ef192fb 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -114,6 +114,7 @@ struct mmc_blk_data {
 	struct device_attribute force_ro;
 	struct device_attribute power_ro_lock;
 	int	area_type;
+	struct device_attribute num_wr_reqs_to_start_packing;
 };

 static DEFINE_MUTEX(open_lock);
@@ -281,6 +282,38 @@ out:
 	return ret;
 }

+static ssize_t
+num_wr_reqs_to_start_packing_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+	int num_wr_reqs_to_start_packing;
+	int ret;
+
+	num_wr_reqs_to_start_packing = md->queue.num_wr_reqs_to_start_packing;
+
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", num_wr_reqs_to_start_packing);
+
+	mmc_blk_put(md);
+	return ret;
+}
+
+static ssize_t
+num_wr_reqs_to_start_packing_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int value;
+	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+
+	sscanf(buf, "%d", &value);
+	if (value >= 0)
+		md->queue.num_wr_reqs_to_start_packing = value;
+
+	mmc_blk_put(md);
+	return count;
+}
+
 static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
@@ -1313,6 +1346,48 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	mmc_queue_bounce_pre(mqrq);
 }

+static void mmc_blk_write_packing_control(struct mmc_queue *mq,
+					  struct request *req)
+{
+	struct mmc_host *host = mq->card->host;
+	int data_dir;
+
+	if (!(host->caps2 & MMC_CAP2_PACKED_WR))
+		return;
+
+	/*
+	 * In case the packing control is not supported by the host, it should
+	 * not have an effect on the write packing. Therefore we have to enable
+	 * the write packing
+	 */
+	if (!(host->caps2 & MMC_CAP2_PACKED_WR_CONTROL)) {
+		mq->wr_packing_enabled = true;
+		return;
+	}
+
+	if (!req || (req && (req->cmd_flags & REQ_FLUSH))) {
+		if (mq->num_of_potential_packed_wr_reqs >
+				mq->num_wr_reqs_to_start_packing)
+			mq->wr_packing_enabled = true;
+		return;
+	}
+
+	data_dir = rq_data_dir(req);
+
+	if (data_dir == READ) {
+		mq->num_of_potential_packed_wr_reqs = 0;
+		mq->wr_packing_enabled = false;
+		return;
+	} else if (data_dir == WRITE) {
+		mq->num_of_potential_packed_wr_reqs++;
+	}
+
+	if (mq->num_of_potential_packed_wr_reqs >
+			mq->num_wr_reqs_to_start_packing)
+		mq->wr_packing_enabled = true;
+
+}
+
 static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 {
 	struct request_queue *q = mq->queue;
@@ -1332,6 +1407,9 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 			!card->ext_csd.packed_event_en)
 		goto no_packed;

+	if (!mq->wr_packing_enabled)
+		goto no_packed;
+
 	if ((rq_data_dir(cur) == WRITE) &&
 			(card->host->caps2 & MMC_CAP2_PACKED_WR))
 		max_packed_rw = card->ext_csd.max_packed_writes;
@@ -1396,6 +1474,8 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 			break;
 		}

+		if (rq_data_dir(next) == WRITE)
+			mq->num_of_potential_packed_wr_reqs++;
 		list_add_tail(&next->queuelist, &mq->mqrq_cur->packed_list);
 		cur = next;
 		reqs++;
@@ -1780,7 +1860,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		goto out;
 	}

-	if (req && req->cmd_flags & REQ_DISCARD) {
+	mmc_blk_write_packing_control(mq, req);
+
+	if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -2010,6 +2092,8 @@ static void mmc_blk_remove_req(struct mmc_blk_data *md)

 	if (md) {
 		card = md->queue.card;
+		device_remove_file(disk_to_dev(md->disk),
+				   &md->num_wr_reqs_to_start_packing);
 		if (md->disk->flags & GENHD_FL_UP) {
 			device_remove_file(disk_to_dev(md->disk), &md->force_ro);
 			if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
@@ -2076,6 +2160,20 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 		if (ret)
 			goto power_ro_lock_fail;
 	}
+
+	md->num_wr_reqs_to_start_packing.show =
+		num_wr_reqs_to_start_packing_show;
+	md->num_wr_reqs_to_start_packing.store =
+		num_wr_reqs_to_start_packing_store;
+	sysfs_attr_init(&md->num_wr_reqs_to_start_packing.attr);
+	md->num_wr_reqs_to_start_packing.attr.name =
+		"num_wr_reqs_to_start_packing";
+	md->num_wr_reqs_to_start_packing.attr.mode = S_IRUGO | S_IWUSR;
+	ret = device_create_file(disk_to_dev(md->disk),
+				 &md->num_wr_reqs_to_start_packing);
+	if (ret)
+		goto power_ro_lock_fail;
+
 	return ret;

 power_ro_lock_fail:
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 165d85a..79ef91b 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -25,6 +25,13 @@
 #define MMC_QUEUE_SUSPENDED	(1 << 0)

 /*
+ * Based on benchmark tests the default num of requests to trigger the write
+ * packing was determined, to keep the read latency as low as possible and
+ * manage to keep the high write throughput.
+ */
+#define DEFAULT_NUM_REQS_TO_START_PACK 17
+
+/*
  * Prepare a MMC request. This just filters out odd stuff.
  */
 static int mmc_prep_request(struct request_queue *q, struct request *req)
@@ -181,6 +188,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	mq->mqrq_cur = mqrq_cur;
 	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
+	mq->num_wr_reqs_to_start_packing = DEFAULT_NUM_REQS_TO_START_PACK;

 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index d761bf1..6c29e0e 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -44,6 +44,9 @@ struct mmc_queue {
 	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
 	struct mmc_queue_req	*mqrq_prev;
+	bool			wr_packing_enabled;
+	int			num_of_potential_packed_wr_reqs;
+	int			num_wr_reqs_to_start_packing;
 };

 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9d0d946..0eb6c7b 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -242,6 +242,7 @@ struct mmc_host {
 #define MMC_CAP2_PACKED_WR	(1 << 11)	/* Allow packed write */
 #define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
 				 MMC_CAP2_PACKED_WR) /* Allow packed commands */
+#define MMC_CAP2_PACKED_WR_CONTROL (1 << 12) /* Allow write packing control */

 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
--
1.7.3.3
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
