Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2AZJIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:08:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20466 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2AZJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:08:06 -0500
X-AuditID: cbfee61b-b7be3ae0000039aa-e5-4f2117f595ca
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Thu, 26 Jan 2012 18:08:04 +0900
Message-id: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczcCgMc2sI9UoInQPO6t9/wZzXSBg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports packed command of eMMC4.5 device.
Several reads(or writes) can be grouped in packed command
and all data of the individual commands can be sent in a
single transfer on the bus.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/card/block.c   |  477 +++++++++++++++++++++++++++++++++++++++++---
 drivers/mmc/card/queue.c   |   48 ++++-
 drivers/mmc/card/queue.h   |   13 ++
 drivers/mmc/core/host.c    |    2 +
 drivers/mmc/core/mmc_ops.c |    1 +
 include/linux/mmc/core.h   |    4 +
 include/linux/mmc/host.h   |    8 +-
 7 files changed, 525 insertions(+), 28 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 176b78e..a03c12e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -59,6 +59,13 @@ MODULE_ALIAS("mmc:block");
 #define INAND_CMD38_ARG_SECTRIM1 0x81
 #define INAND_CMD38_ARG_SECTRIM2 0x88
 
+#define mmc_req_rel_wr(req)	(((req->cmd_flags & REQ_FUA) || \
+			(req->cmd_flags & REQ_META)) && \
+			(rq_data_dir(req) == WRITE))
+#define PACKED_CMD_VER		0x01
+#define PACKED_CMD_RD		0x01
+#define PACKED_CMD_WR		0x02
+
 static DEFINE_MUTEX(block_mutex);
 
 /*
@@ -99,6 +106,7 @@ struct mmc_blk_data {
 #define MMC_BLK_WRITE		BIT(1)
 #define MMC_BLK_DISCARD		BIT(2)
 #define MMC_BLK_SECDISCARD	BIT(3)
+#define MMC_BLK_WR_HDR		BIT(4)
 
 	/*
 	 * Only set in main mmc_blk_data associated
@@ -1028,7 +1036,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 * kind.  If it was a write, we may have transitioned to
 	 * program mode, which we have to wait for it to complete.
 	 */
-	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
+	if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) ||
+			(mq_mrq->packed_cmd == MMC_PACKED_WR_HDR)) {
 		u32 status;
 		do {
 			int err = get_card_status(card, &status, 5);
@@ -1053,7 +1062,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
 		       (unsigned)blk_rq_sectors(req),
 		       brq->cmd.resp[0], brq->stop.resp[0]);
 
-		if (rq_data_dir(req) == READ) {
+		if (rq_data_dir(req) == READ &&
+				mq_mrq->packed_cmd != MMC_PACKED_WR_HDR) {
 			if (ecc_err)
 				return MMC_BLK_ECC_ERR;
 			return MMC_BLK_DATA_ERR;
@@ -1065,12 +1075,60 @@ static int mmc_blk_err_check(struct mmc_card *card,
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
+			     struct mmc_async_req *areq)
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
+					ext_csd[EXT_CSD_PACKED_FAILURE_INDEX] - 1;
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
@@ -1225,10 +1283,246 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
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
+	mq->mqrq_cur->packed_num = 0;
+
+	if (!(md->flags & MMC_BLK_CMD23) ||
+			!card->ext_csd.packed_event_en)
+		goto no_packed;
+
+	if ((rq_data_dir(cur) == READ) &&
+			(card->host->caps2 & MMC_CAP2_PACKED_RD))
+		max_packed_rw = card->ext_csd.max_packed_reads;
+	else if ((rq_data_dir(cur) == WRITE) &&
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
+	phys_segments += req->nr_phys_segments;
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
+	mq->mqrq_cur->packed_cmd = MMC_PACKED_NONE;
+	mq->mqrq_cur->packed_num = 0;
+	return 0;
+}
+
+static void mmc_blk_packed_hdr_wrq_prep(struct mmc_queue_req *mqrq,
+			       struct mmc_card *card,
+			       struct mmc_queue *mq,
+			       u8 reqs)
+{
+	struct mmc_blk_request *brq = &mqrq->brq;
+	struct request *req = mqrq->req;
+	struct request *prq;
+	struct mmc_blk_data *md = mq->data;
+	bool do_rel_wr, do_data_tag;
+	u32 *packed_cmd_hdr = mqrq->packed_cmd_hdr;
+	u8 i = 1;
+
+	mqrq->packed_cmd = (rq_data_dir(req) == READ) ?
+		MMC_PACKED_WR_HDR : MMC_PACKED_WRITE;
+	mqrq->packed_blocks = 0;
+	mqrq->packed_fail_idx = -1;
+
+	memset(packed_cmd_hdr, 0, sizeof(mqrq->packed_cmd_hdr));
+	packed_cmd_hdr[0] = (reqs << 16) |
+		(((rq_data_dir(req) == READ) ?
+		  PACKED_CMD_RD : PACKED_CMD_WR) << 8) |
+		PACKED_CMD_VER;
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
+		packed_cmd_hdr[(i * 2)] = (do_rel_wr ? MMC_CMD23_ARG_REL_WR : 0) |
+			(do_data_tag ? MMC_CMD23_ARG_TAG_REQ : 0) |
+			blk_rq_sectors(prq);
+		/* Argument of CMD18 or CMD25 */
+		packed_cmd_hdr[((i * 2)) + 1] = mmc_card_blockaddr(card) ?
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
+	brq->sbc.arg = MMC_CMD23_ARG_PACKED |
+		((rq_data_dir(req) == READ) ? 1 : mqrq->packed_blocks + 1);
+	brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
+
+	brq->cmd.opcode = MMC_WRITE_MULTIPLE_BLOCK;
+	brq->cmd.arg = blk_rq_pos(req);
+	if (!mmc_card_blockaddr(card))
+		brq->cmd.arg <<= 9;
+	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	brq->data.blksz = 512;
+	/*
+	 * Write separately the packd command header only for packed read.
+	 * In case of packed write, header is sent with blocks of data.
+	 */
+	brq->data.blocks = (rq_data_dir(req) == READ) ?
+		1 : mqrq->packed_blocks + 1;
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
+static void mmc_blk_packed_rrq_prep(struct mmc_queue_req *mqrq,
+			       struct mmc_card *card,
+			       struct mmc_queue *mq)
+{
+	struct mmc_blk_request *brq = &mqrq->brq;
+	struct request *req = mqrq->req;
+
+	mqrq->packed_cmd = MMC_PACKED_READ;
+
+	memset(brq, 0, sizeof(struct mmc_blk_request));
+	brq->mrq.cmd = &brq->cmd;
+	brq->mrq.data = &brq->data;
+	brq->mrq.stop = &brq->stop;
+
+	brq->cmd.opcode = MMC_READ_MULTIPLE_BLOCK;
+	brq->cmd.arg = blk_rq_pos(req);
+	if (!mmc_card_blockaddr(card))
+		brq->cmd.arg <<= 9;
+	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
+	brq->data.blksz = 512;
+	brq->data.blocks = mqrq->packed_blocks;
+	brq->data.flags |= MMC_DATA_READ;
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
@@ -1247,10 +1541,62 @@ static int mmc_blk_cmd_err(struct mmc_blk_data *md, struct mmc_card *card,
 			spin_unlock_irq(&md->lock);
 		}
 	} else {
-		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
-		spin_unlock_irq(&md->lock);
+		if (mq_rq->packed_cmd == MMC_PACKED_NONE) {
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+		}
+	}
+	return ret;
+}
+
+static int mmc_blk_chk_hdr_err(struct mmc_queue *mq, int status)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	int type = MMC_BLK_WR_HDR, err = 0;
+
+	switch (status) {
+	case MMC_BLK_PARTIAL:
+	case MMC_BLK_RETRY:
+		err = 0;
+		break;
+	case MMC_BLK_CMD_ERR:
+	case MMC_BLK_ABORT:
+	case MMC_BLK_DATA_ERR:
+	case MMC_BLK_ECC_ERR:
+		err = mmc_blk_reset(md, card->host, type);
+		if (!err)
+			mmc_blk_reset_success(md, type);
+		break;
 	}
+
+	return err;
+}
+
+static int mmc_blk_issue_packed_rd(struct mmc_queue *mq,
+		struct mmc_queue_req *mq_rq)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	int status, ret, retry = 2;
+
+	do {
+		mmc_start_req(card->host, NULL, (int *) &status);
+		if (status) {
+			ret = mmc_blk_chk_hdr_err(mq, status);
+			if (ret)
+				break;
+			mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq, mq_rq->packed_num);
+			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
+		} else {
+			mmc_blk_packed_rrq_prep(mq_rq, card, mq);
+			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
+			ret = 0;
+			break;
+		}
+	} while (retry-- > 0);
+
 	return ret;
 }
 
@@ -1262,21 +1608,32 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	int ret = 1, disable_multi = 0, retry = 0, type;
 	enum mmc_blk_status status;
 	struct mmc_queue_req *mq_rq;
-	struct request *req;
+	struct request *req, *prq;
 	struct mmc_async_req *areq;
+	u8 reqs = 0;
 
 	if (!rqc && !mq->mqrq_prev->req)
 		return 0;
 
+	if (rqc)
+		reqs = mmc_blk_prep_packed_list(mq, rqc);
+
 	do {
 		if (rqc) {
-			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
+			if (reqs >= card->host->packed_min)
+				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
+			else
+				mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
 			areq = &mq->mqrq_cur->mmc_active;
 		} else
 			areq = NULL;
 		areq = mmc_start_req(card->host, areq, (int *) &status);
-		if (!areq)
-			return 0;
+		if (!areq) {
+			if (mq->mqrq_cur->packed_cmd == MMC_PACKED_WR_HDR)
+				goto snd_packed_rd;
+			else
+				return 0;
+		}
 
 		mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
 		brq = &mq_rq->brq;
@@ -1291,10 +1648,38 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			 * A block was successfully transferred.
 			 */
 			mmc_blk_reset_success(md, type);
-			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0,
+
+			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
+				int idx = mq_rq->packed_fail_idx, i = 0;
+				while (!list_empty(&mq_rq->packed_list)) {
+					prq = list_entry_rq(mq_rq->packed_list.next);
+					list_del_init(&prq->queuelist);
+					if (idx == i) {
+						/* retry from error index */
+						mq_rq->packed_num -= idx;
+						if (mq_rq->packed_num == 1) {
+							mq_rq->packed_cmd = MMC_PACKED_NONE;
+							mq_rq->packed_num = 0;
+						}
+						mq_rq->req = prq;
+						ret = 1;
+						break;
+					}
+					spin_lock_irq(&md->lock);
+					ret = __blk_end_request(prq, 0, blk_rq_bytes(prq));
+					spin_unlock_irq(&md->lock);
+					i++;
+				}
+				if (idx == -1)
+					mq_rq->packed_num = 0;
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
@@ -1329,6 +1714,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				break;
 			if (err == -ENODEV)
 				goto cmd_abort;
+			if (mq_rq->packed_cmd != MMC_PACKED_NONE)
+				break;
 			/* Fall through */
 		}
 		case MMC_BLK_ECC_ERR:
@@ -1356,27 +1743,69 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
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
+				mmc_blk_rw_rq_prep(mq_rq, card, disable_multi, mq);
+				mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
+			} else {
+				mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq, mq_rq->packed_num);
+				mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
+				if (mq_rq->packed_cmd == MMC_PACKED_WR_HDR) {
+					if (mmc_blk_issue_packed_rd(mq, mq_rq))
+						goto cmd_abort;
+				}
+			}
 		}
 	} while (ret);
 
+snd_packed_rd:
+	if (mq->mqrq_cur->packed_cmd == MMC_PACKED_WR_HDR) {
+		if (mmc_blk_issue_packed_rd(mq, mq->mqrq_cur))
+			goto start_new_req;
+	}
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
+			ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
+		spin_unlock_irq(&md->lock);
+	} else {
+		while (!list_empty(&mq_rq->packed_list)) {
+			prq = list_entry_rq(mq_rq->packed_list.next);
+			list_del_init(&prq->queuelist);
+			spin_lock_irq(&md->lock);
+			__blk_end_request(prq, -EIO, blk_rq_bytes(prq));
+			spin_unlock_irq(&md->lock);
+		}
+	}
 
  start_new_req:
 	if (rqc) {
+		/*
+		 * If current request is packed, it need to put back.
+		 */
+		if (mq->mqrq_cur->packed_cmd != MMC_PACKED_NONE) {
+			while (!list_empty(&mq->mqrq_cur->packed_list)) {
+				prq = list_entry_rq(mq->mqrq_cur->packed_list.prev);
+				if (prq->queuelist.prev != &mq->mqrq_cur->packed_list) {
+					list_del_init(&prq->queuelist);
+					spin_lock_irq(mq->queue->queue_lock);
+					blk_requeue_request(mq->queue, prq);
+					spin_unlock_irq(mq->queue->queue_lock);
+				} else {
+					list_del_init(&prq->queuelist);
+				}
+			}
+			mq->mqrq_cur->packed_cmd = MMC_PACKED_NONE;
+			mq->mqrq_cur->packed_num = 0;
+		}
 		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
 		mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
 	}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 2517547..af7aee5 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -177,6 +177,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 
 	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
 	memset(&mq->mqrq_prev, 0, sizeof(mq->mqrq_prev));
+	INIT_LIST_HEAD(&mqrq_cur->packed_list);
+	INIT_LIST_HEAD(&mqrq_prev->packed_list);
 	mq->mqrq_cur = mqrq_cur;
 	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
@@ -377,6 +379,39 @@ void mmc_queue_resume(struct mmc_queue *mq)
 	}
 }
 
+static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
+				struct mmc_queue_req *mqrq,
+				struct scatterlist *sg)
+{
+	struct scatterlist *__sg;
+	unsigned int sg_len = 0;
+	struct request *req;
+	enum mmc_packed_cmd cmd;
+
+	cmd = mqrq->packed_cmd;
+
+	if (cmd == MMC_PACKED_WR_HDR || cmd == MMC_PACKED_WRITE) {
+		__sg = sg;
+		sg_set_buf(__sg, mqrq->packed_cmd_hdr,
+				sizeof(mqrq->packed_cmd_hdr));
+		sg_len++;
+		if (cmd == MMC_PACKED_WR_HDR) {
+			sg_mark_end(__sg);
+			return sg_len;
+		}
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
@@ -387,12 +422,19 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq, struct mmc_queue_req *mqrq)
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
index d2a1eb4..be58b3c 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -12,6 +12,13 @@ struct mmc_blk_request {
 	struct mmc_data		data;
 };
 
+enum mmc_packed_cmd {
+	MMC_PACKED_NONE = 0,
+	MMC_PACKED_WR_HDR,
+	MMC_PACKED_WRITE,
+	MMC_PACKED_READ,
+};
+
 struct mmc_queue_req {
 	struct request		*req;
 	struct mmc_blk_request	brq;
@@ -20,6 +27,12 @@ struct mmc_queue_req {
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
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 30055f2..10350ce 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -346,6 +346,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	host->max_blk_size = 512;
 	host->max_blk_count = PAGE_CACHE_SIZE / 512;
 
+	host->packed_min = 2;
+
 	return host;
 
 free:
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 4d41fa9..1e17bd7 100644
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
index 87a976c..2f3eca2 100644
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
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index e22f541..e6d09ec 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -257,7 +257,10 @@ struct mmc_host {
 #define MMC_CAP2_HS200_1_2V_SDR	(1 << 6)        /* can support */
 #define MMC_CAP2_HS200		(MMC_CAP2_HS200_1_8V_SDR | \
 				 MMC_CAP2_HS200_1_2V_SDR)
-#define MMC_CAP2_PACKED_CMD	(1 << 7)	/* Allow packed command */
+#define MMC_CAP2_PACKED_RD	(1 << 7)	/* Allow packed read */
+#define MMC_CAP2_PACKED_WR	(1 << 8)	/* Allow packed write */
+#define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
+				 MMC_CAP2_PACKED_WR) /* Allow packed commands */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
@@ -286,6 +289,9 @@ struct mmc_host {
 	unsigned int		max_blk_count;	/* maximum number of blocks in one req */
 	unsigned int		max_discard_to;	/* max. discard timeout in ms */
 
+	u8			packed_min;	/* minimum number of packed entries */
+
+
 	/* private data */
 	spinlock_t		lock;		/* lock for claim and bus ops */
 
-- 
1.7.0.4


