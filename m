Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab2EQJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:42:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33899 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2EQJmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:42:15 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-7e-4fb4c7e11907
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, merez@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/3] mmc: core: Support packed write command for eMMC4.5
 device
Date: Thu, 17 May 2012 18:41:53 +0900
Message-id: <009e01cd3411$4aa26ee0$dfe74ca0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac00EUo+2nBqzILnT1exc3J2o9DRYg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports packed write command of eMMC4.5 device.
Several writes can be grouped in packed command and all data
of the individual commands can be sent in a single transfer
on the bus.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/card/block.c   |  381 +++++++++++++++++++++++++++++++++++++++++---
 drivers/mmc/card/queue.c   |   45 +++++-
 drivers/mmc/card/queue.h   |   11 ++
 drivers/mmc/core/mmc_ops.c |    1 +
 include/linux/mmc/core.h   |    4 +
 5 files changed, 420 insertions(+), 22 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 91cda75..8f475b1 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -58,6 +58,12 @@ MODULE_ALIAS("mmc:block");
 #define INAND_CMD38_ARG_SECTRIM1 0x81
 #define INAND_CMD38_ARG_SECTRIM2 0x88
 
+#define mmc_req_rel_wr(req)	(((req->cmd_flags & REQ_FUA) || \
+			(req->cmd_flags & REQ_META)) && \
+			(rq_data_dir(req) == WRITE))
+#define PACKED_CMD_VER		0x01
+#define PACKED_CMD_WR		0x02
+
 static DEFINE_MUTEX(block_mutex);
 
 /*
@@ -123,9 +129,21 @@ enum mmc_blk_status {
 	MMC_BLK_NOMEDIUM,
 };
 
+enum {
+	MMC_PACKED_N_IDX = -1,
+	MMC_PACKED_N_ZERO,
+	MMC_PACKED_N_SINGLE,
+};
+
 module_param(perdev_minors, int, 0444);
 MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
 
+static inline void mmc_blk_clear_packed(struct mmc_queue_req *mqrq)
+{
+	mqrq->packed_cmd = MMC_PACKED_NONE;
+	mqrq->packed_num = MMC_PACKED_N_ZERO;
+}
+
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 {
 	struct mmc_blk_data *md;
@@ -1087,12 +1105,60 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	if (!brq->data.bytes_xfered)
 		return MMC_BLK_RETRY;
 
+	if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
+		if (unlikely(brq->data.blocks << 9 != brq->data.bytes_xfered))
+			return MMC_BLK_PARTIAL;
+		else
+			return MMC_BLK_SUCCESS;
+	}
+
 	if (blk_rq_bytes(req) != brq->data.bytes_xfered)
 		return MMC_BLK_PARTIAL;
 
 	return MMC_BLK_SUCCESS;
 }
 
+static int mmc_blk_packed_err_check(struct mmc_card *card,
+				    struct mmc_async_req *areq)
+{
+	struct mmc_queue_req *mq_rq = container_of(areq, struct mmc_queue_req,
+			mmc_active);
+	struct request *req = mq_rq->req;
+	int err, check, status;
+	u8 ext_csd[512];
+
+	check = mmc_blk_err_check(card, areq);
+	err = get_card_status(card, &status, 0);
+	if (err) {
+		pr_err("%s: error %d sending status command\n",
+				req->rq_disk->disk_name, err);
+		return MMC_BLK_ABORT;
+	}
+
+	if (status & R1_EXP_EVENT) {
+		err = mmc_send_ext_csd(card, ext_csd);
+		if (err) {
+			pr_err("%s: error %d sending ext_csd\n",
+					req->rq_disk->disk_name, err);
+			return MMC_BLK_ABORT;
+		}
+
+		if ((ext_csd[EXT_CSD_EXP_EVENTS_STATUS] &
+					EXT_CSD_PACKED_FAILURE) &&
+				(ext_csd[EXT_CSD_PACKED_CMD_STATUS] &
+				 EXT_CSD_PACKED_GENERIC_ERROR)) {
+			if (ext_csd[EXT_CSD_PACKED_CMD_STATUS] &
+					EXT_CSD_PACKED_INDEXED_ERROR) {
+				mq_rq->packed_fail_idx =
+				  ext_csd[EXT_CSD_PACKED_FAILURE_INDEX] - 1;
+				return MMC_BLK_PARTIAL;
+			}
+		}
+	}
+
+	return check;
+}
+
 static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 			       struct mmc_card *card,
 			       int disable_multi,
@@ -1247,10 +1313,196 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	mmc_queue_bounce_pre(mqrq);
 }
 
+static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
+{
+	struct request_queue *q = mq->queue;
+	struct mmc_card *card = mq->card;
+	struct request *cur = req, *next = NULL;
+	struct mmc_blk_data *md = mq->data;
+	bool en_rel_wr = card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN;
+	unsigned int req_sectors = 0, phys_segments = 0;
+	unsigned int max_blk_count, max_phys_segs;
+	u8 put_back = 0;
+	u8 max_packed_rw = 0;
+	u8 reqs = 0;
+
+	mmc_blk_clear_packed(mq->mqrq_cur);
+
+	if (!(md->flags & MMC_BLK_CMD23) ||
+			!card->ext_csd.packed_event_en)
+		goto no_packed;
+
+	if ((rq_data_dir(cur) == WRITE) &&
+			(card->host->caps2 & MMC_CAP2_PACKED_WR))
+		max_packed_rw = card->ext_csd.max_packed_writes;
+
+	if (max_packed_rw == 0)
+		goto no_packed;
+
+	if (mmc_req_rel_wr(cur) &&
+			(md->flags & MMC_BLK_REL_WR) &&
+			!en_rel_wr) {
+		goto no_packed;
+	}
+
+	max_blk_count = min(card->host->max_blk_count,
+			card->host->max_req_size >> 9);
+	if (unlikely(max_blk_count > 0xffff))
+		max_blk_count = 0xffff;
+
+	max_phys_segs = queue_max_segments(q);
+	req_sectors += blk_rq_sectors(cur);
+	phys_segments += cur->nr_phys_segments;
+
+	if (rq_data_dir(cur) == WRITE) {
+		req_sectors++;
+		phys_segments++;
+	}
+
+	while (reqs < max_packed_rw - 1) {
+		spin_lock_irq(q->queue_lock);
+		next = blk_fetch_request(q);
+		spin_unlock_irq(q->queue_lock);
+		if (!next)
+			break;
+
+		if (next->cmd_flags & REQ_DISCARD ||
+				next->cmd_flags & REQ_FLUSH) {
+			put_back = 1;
+			break;
+		}
+
+		if (rq_data_dir(cur) != rq_data_dir(next)) {
+			put_back = 1;
+			break;
+		}
+
+		if (mmc_req_rel_wr(next) &&
+				(md->flags & MMC_BLK_REL_WR) &&
+				!en_rel_wr) {
+			put_back = 1;
+			break;
+		}
+
+		req_sectors += blk_rq_sectors(next);
+		if (req_sectors > max_blk_count) {
+			put_back = 1;
+			break;
+		}
+
+		phys_segments +=  next->nr_phys_segments;
+		if (phys_segments > max_phys_segs) {
+			put_back = 1;
+			break;
+		}
+
+		list_add_tail(&next->queuelist, &mq->mqrq_cur->packed_list);
+		cur = next;
+		reqs++;
+	}
+
+	if (put_back) {
+		spin_lock_irq(q->queue_lock);
+		blk_requeue_request(q, next);
+		spin_unlock_irq(q->queue_lock);
+	}
+
+	if (reqs > 0) {
+		list_add(&req->queuelist, &mq->mqrq_cur->packed_list);
+		mq->mqrq_cur->packed_num = ++reqs;
+		return reqs;
+	}
+
+no_packed:
+	mmc_blk_clear_packed(mq->mqrq_cur);
+	return 0;
+}
+
+static void mmc_blk_packed_hdr_wrq_prep(struct mmc_queue_req *mqrq,
+					struct mmc_card *card,
+					struct mmc_queue *mq)
+{
+	struct mmc_blk_request *brq = &mqrq->brq;
+	struct request *req = mqrq->req;
+	struct request *prq;
+	struct mmc_blk_data *md = mq->data;
+	bool do_rel_wr, do_data_tag;
+	u32 *packed_cmd_hdr = mqrq->packed_cmd_hdr;
+	u8 i = 1;
+
+	mqrq->packed_cmd = MMC_PACKED_WRITE;
+	mqrq->packed_blocks = 0;
+	mqrq->packed_fail_idx = MMC_PACKED_N_IDX;
+
+	memset(packed_cmd_hdr, 0, sizeof(mqrq->packed_cmd_hdr));
+	packed_cmd_hdr[0] = (mqrq->packed_num << 16) |
+		(PACKED_CMD_WR << 8) | PACKED_CMD_VER;
+
+	/*
+	 * Argument for each entry of packed group
+	 */
+	list_for_each_entry(prq, &mqrq->packed_list, queuelist) {
+		do_rel_wr = mmc_req_rel_wr(prq) && (md->flags & MMC_BLK_REL_WR);
+		do_data_tag = (card->ext_csd.data_tag_unit_size) &&
+			(prq->cmd_flags & REQ_META) &&
+			(rq_data_dir(prq) == WRITE) &&
+			((brq->data.blocks * brq->data.blksz) >=
+			 card->ext_csd.data_tag_unit_size);
+		/* Argument of CMD23*/
+		packed_cmd_hdr[(i * 2)] =
+			(do_rel_wr ? MMC_CMD23_ARG_REL_WR : 0) |
+			(do_data_tag ? MMC_CMD23_ARG_TAG_REQ : 0) |
+			blk_rq_sectors(prq);
+		/* Argument of CMD18 or CMD25 */
+		packed_cmd_hdr[((i * 2)) + 1] =
+			mmc_card_blockaddr(card) ?
+			blk_rq_pos(prq) : blk_rq_pos(prq) << 9;
+		mqrq->packed_blocks += blk_rq_sectors(prq);
+		i++;
+	}
+
+	memset(brq, 0, sizeof(struct mmc_blk_request));
+	brq->mrq.cmd = &brq->cmd;
+	brq->mrq.data = &brq->data;
+	brq->mrq.sbc = &brq->sbc;
+	brq->mrq.stop = &brq->stop;
+
+	brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
+	brq->sbc.arg = MMC_CMD23_ARG_PACKED | (mqrq->packed_blocks + 1);
+	brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
+
+	brq->cmd.opcode = MMC_WRITE_MULTIPLE_BLOCK;
+	brq->cmd.arg = blk_rq_pos(req);
+	if (!mmc_card_blockaddr(card))
+		brq->cmd.arg <<= 9;
+	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	brq->data.blksz = 512;
+	brq->data.blocks = mqrq->packed_blocks + 1;
+	brq->data.flags |= MMC_DATA_WRITE;
+
+	brq->stop.opcode = MMC_STOP_TRANSMISSION;
+	brq->stop.arg = 0;
+	brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
+
+	mmc_set_data_timeout(&brq->data, card);
+
+	brq->data.sg = mqrq->sg;
+	brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
+
+	mqrq->mmc_active.mrq = &brq->mrq;
+	mqrq->mmc_active.err_check = mmc_blk_packed_err_check;
+
+	mmc_queue_bounce_pre(mqrq);
+}
+
 static int mmc_blk_cmd_err(struct mmc_blk_data *md, struct mmc_card *card,
 			   struct mmc_blk_request *brq, struct request *req,
 			   int ret)
 {
+	struct mmc_queue_req *mq_rq;
+	mq_rq = container_of(brq, struct mmc_queue_req, brq);
+
 	/*
 	 * If this is an SD card and we're writing, we can first
 	 * mark the known good sectors as ok.
@@ -1269,10 +1521,45 @@ static int mmc_blk_cmd_err(struct mmc_blk_data *md, struct mmc_card *card,
 			spin_unlock_irq(&md->lock);
 		}
 	} else {
+		if (mq_rq->packed_cmd == MMC_PACKED_NONE) {
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+		}
+	}
+	return ret;
+}
+
+static int mmc_blk_end_packed_req(struct mmc_queue *mq,
+				  struct mmc_queue_req *mq_rq)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct request *prq;
+	int idx = mq_rq->packed_fail_idx, i = 0;
+	int ret = 0;
+
+	while (!list_empty(&mq_rq->packed_list)) {
+		prq = list_entry_rq(mq_rq->packed_list.next);
+		if (idx == i) {
+			/* retry from error index */
+			mq_rq->packed_num -= idx;
+			mq_rq->req = prq;
+			ret = 1;
+
+			if (mq_rq->packed_num == MMC_PACKED_N_SINGLE) {
+				list_del_init(&prq->queuelist);
+				mmc_blk_clear_packed(mq_rq);
+			}
+			return ret;
+		}
+		list_del_init(&prq->queuelist);
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
+		__blk_end_request(prq, 0, blk_rq_bytes(prq));
 		spin_unlock_irq(&md->lock);
+		i++;
 	}
+
+	mmc_blk_clear_packed(mq_rq);
 	return ret;
 }
 
@@ -1284,15 +1571,24 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	int ret = 1, disable_multi = 0, retry = 0, type;
 	enum mmc_blk_status status;
 	struct mmc_queue_req *mq_rq;
-	struct request *req;
+	struct request *req, *prq;
 	struct mmc_async_req *areq;
+	const u8 packed_num = 2;
+	u8 reqs = 0;
 
 	if (!rqc && !mq->mqrq_prev->req)
 		return 0;
 
+	if (rqc)
+		reqs = mmc_blk_prep_packed_list(mq, rqc);
+
 	do {
 		if (rqc) {
-			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
+			if (reqs >= packed_num)
+				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur,
+						card, mq);
+			else
+				mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
 			areq = &mq->mqrq_cur->mmc_active;
 		} else
 			areq = NULL;
@@ -1313,10 +1609,17 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			 * A block was successfully transferred.
 			 */
 			mmc_blk_reset_success(md, type);
-			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0,
+
+			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
+				ret = mmc_blk_end_packed_req(mq, mq_rq);
+				break;
+			} else {
+				spin_lock_irq(&md->lock);
+				ret = __blk_end_request(req, 0,
 						brq->data.bytes_xfered);
-			spin_unlock_irq(&md->lock);
+				spin_unlock_irq(&md->lock);
+			}
+
 			/*
 			 * If the blk_end_request function returns non-zero even
 			 * though all data has been transferred and no errors
@@ -1349,7 +1652,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			err = mmc_blk_reset(md, card->host, type);
 			if (!err)
 				break;
-			if (err == -ENODEV)
+			if (err == -ENODEV ||
+				mq_rq->packed_cmd != MMC_PACKED_NONE)
 				goto cmd_abort;
 			/* Fall through */
 		}
@@ -1378,27 +1682,66 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		}
 
 		if (ret) {
-			/*
-			 * In case of a incomplete request
-			 * prepare it again and resend.
-			 */
-			mmc_blk_rw_rq_prep(mq_rq, card, disable_multi, mq);
-			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
+			if (mq_rq->packed_cmd == MMC_PACKED_NONE) {
+				/*
+				 * In case of a incomplete request
+				 * prepare it again and resend.
+				 */
+				mmc_blk_rw_rq_prep(mq_rq, card,
+						disable_multi, mq);
+				mmc_start_req(card->host,
+						&mq_rq->mmc_active, NULL);
+			} else {
+				mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq);
+				mmc_start_req(card->host,
+						&mq_rq->mmc_active, NULL);
+			}
 		}
 	} while (ret);
 
 	return 1;
 
  cmd_abort:
-	spin_lock_irq(&md->lock);
-	if (mmc_card_removed(card))
-		req->cmd_flags |= REQ_QUIET;
-	while (ret)
-		ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
-	spin_unlock_irq(&md->lock);
+	if (mq_rq->packed_cmd == MMC_PACKED_NONE) {
+		spin_lock_irq(&md->lock);
+		if (mmc_card_removed(card))
+			req->cmd_flags |= REQ_QUIET;
+		while (ret)
+			ret = __blk_end_request(req, -EIO,
+					blk_rq_cur_bytes(req));
+		spin_unlock_irq(&md->lock);
+	} else {
+		while (!list_empty(&mq_rq->packed_list)) {
+			prq = list_entry_rq(mq_rq->packed_list.next);
+			list_del_init(&prq->queuelist);
+			spin_lock_irq(&md->lock);
+			__blk_end_request(prq, -EIO, blk_rq_bytes(prq));
+			spin_unlock_irq(&md->lock);
+		}
+		mmc_blk_clear_packed(mq_rq);
+	}
 
  start_new_req:
 	if (rqc) {
+		/*
+		 * If current request is packed, it needs to put back.
+		 */
+		if (mq->mqrq_cur->packed_cmd != MMC_PACKED_NONE) {
+			while (!list_empty(&mq->mqrq_cur->packed_list)) {
+				prq = list_entry_rq(
+					mq->mqrq_cur->packed_list.prev);
+				if (prq->queuelist.prev !=
+						&mq->mqrq_cur->packed_list) {
+					list_del_init(&prq->queuelist);
+					spin_lock_irq(mq->queue->queue_lock);
+					blk_requeue_request(mq->queue, prq);
+					spin_unlock_irq(mq->queue->queue_lock);
+				} else {
+					list_del_init(&prq->queuelist);
+				}
+			}
+			mmc_blk_clear_packed(mq->mqrq_cur);
+		}
 		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
 		mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
 	}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index e360a97..165d85a 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -175,6 +175,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	if (!mq->queue)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&mqrq_cur->packed_list);
+	INIT_LIST_HEAD(&mqrq_prev->packed_list);
+
 	mq->mqrq_cur = mqrq_cur;
 	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
@@ -375,6 +378,35 @@ void mmc_queue_resume(struct mmc_queue *mq)
 	}
 }
 
+static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
+					    struct mmc_queue_req *mqrq,
+					    struct scatterlist *sg)
+{
+	struct scatterlist *__sg;
+	unsigned int sg_len = 0;
+	struct request *req;
+	enum mmc_packed_cmd cmd;
+
+	cmd = mqrq->packed_cmd;
+
+	if (cmd == MMC_PACKED_WRITE) {
+		__sg = sg;
+		sg_set_buf(__sg, mqrq->packed_cmd_hdr,
+				sizeof(mqrq->packed_cmd_hdr));
+		sg_len++;
+		__sg->page_link &= ~0x02;
+	}
+
+	__sg = sg + sg_len;
+	list_for_each_entry(req, &mqrq->packed_list, queuelist) {
+		sg_len += blk_rq_map_sg(mq->queue, req, __sg);
+		__sg = sg + (sg_len - 1);
+		(__sg++)->page_link &= ~0x02;
+	}
+	sg_mark_end(sg + (sg_len - 1));
+	return sg_len;
+}
+
 /*
  * Prepare the sg list(s) to be handed of to the host driver
  */
@@ -385,12 +417,19 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq, struct mmc_queue_req *mqrq)
 	struct scatterlist *sg;
 	int i;
 
-	if (!mqrq->bounce_buf)
-		return blk_rq_map_sg(mq->queue, mqrq->req, mqrq->sg);
+	if (!mqrq->bounce_buf) {
+		if (!list_empty(&mqrq->packed_list))
+			return mmc_queue_packed_map_sg(mq, mqrq, mqrq->sg);
+		else
+			return blk_rq_map_sg(mq->queue, mqrq->req, mqrq->sg);
+	}
 
 	BUG_ON(!mqrq->bounce_sg);
 
-	sg_len = blk_rq_map_sg(mq->queue, mqrq->req, mqrq->bounce_sg);
+	if (!list_empty(&mqrq->packed_list))
+		sg_len = mmc_queue_packed_map_sg(mq, mqrq, mqrq->bounce_sg);
+	else
+		sg_len = blk_rq_map_sg(mq->queue, mqrq->req, mqrq->bounce_sg);
 
 	mqrq->bounce_sg_len = sg_len;
 
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index d2a1eb4..d761bf1 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -12,6 +12,11 @@ struct mmc_blk_request {
 	struct mmc_data		data;
 };
 
+enum mmc_packed_cmd {
+	MMC_PACKED_NONE = 0,
+	MMC_PACKED_WRITE,
+};
+
 struct mmc_queue_req {
 	struct request		*req;
 	struct mmc_blk_request	brq;
@@ -20,6 +25,12 @@ struct mmc_queue_req {
 	struct scatterlist	*bounce_sg;
 	unsigned int		bounce_sg_len;
 	struct mmc_async_req	mmc_active;
+	struct list_head	packed_list;
+	u32			packed_cmd_hdr[128];
+	unsigned int		packed_blocks;
+	enum mmc_packed_cmd	packed_cmd;
+	int		packed_fail_idx;
+	u8		packed_num;
 };
 
 struct mmc_queue {
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 69370f4..2a2fed8 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -335,6 +335,7 @@ int mmc_send_ext_csd(struct mmc_card *card, u8 *ext_csd)
 	return mmc_send_cxd_data(card, card->host, MMC_SEND_EXT_CSD,
 			ext_csd, 512);
 }
+EXPORT_SYMBOL_GPL(mmc_send_ext_csd);
 
 int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp)
 {
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 1b431c7..d787037 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -18,6 +18,9 @@ struct mmc_request;
 struct mmc_command {
 	u32			opcode;
 	u32			arg;
+#define MMC_CMD23_ARG_REL_WR	(1 << 31)
+#define MMC_CMD23_ARG_PACKED	((0 << 31) | (1 << 30))
+#define MMC_CMD23_ARG_TAG_REQ	(1 << 29)
 	u32			resp[4];
 	unsigned int		flags;		/* expected response type */
 #define MMC_RSP_PRESENT	(1 << 0)
@@ -143,6 +146,7 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
 	struct mmc_command *, int);
 extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
+extern int mmc_send_ext_csd(struct mmc_card *card, u8 *ext_csd);
 
 #define MMC_ERASE_ARG		0x00000000
 #define MMC_SECURE_ERASE_ARG	0x80000000
-- 
1.7.0.4


