Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2FRL7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:59:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39346 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2FRL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:59:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6745"; a="199691639"
Message-ID: <21efe0f84cde4f8317a4ebb4de0b8207.squirrel@www.codeaurora.org>
In-Reply-To: <007c01cd4d15$b7ca1aa0$275e4fe0$%jun@samsung.com>
References: <007c01cd4d15$b7ca1aa0$275e4fe0$%jun@samsung.com>
Date: Mon, 18 Jun 2012 04:59:44 -0700 (PDT)
Subject: Re: [PATCH RESEND v7 3/3] mmc: core: Support packed read command 
     for eMMC4.5 device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, "'Maya Erez'" <merez@codeaurora.org>,
        "'Subhash Jadavani'" <subhashj@codeaurora.org>,
        "'S, Venkatraman'" <svenkatr@ti.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would prefer that you didn't submit this.
Let's wait with packed read until it is proven to be beneficial.

Thanks,
Maya
On Sun, June 17, 2012 10:46 pm, Seungwon Jeon wrote:
> Add the packed read command for issuing data. Unlike the
> packed write, command header is handled separately.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/mmc/card/block.c |  134
> +++++++++++++++++++++++++++++++++++++++++++---
>  drivers/mmc/card/queue.c |    6 ++-
>  drivers/mmc/card/queue.h |    2 +
>  3 files changed, 133 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index eb99e35..25f42e8 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -62,6 +62,7 @@ MODULE_ALIAS("mmc:block");
>  			(req->cmd_flags & REQ_META)) && \
>  			(rq_data_dir(req) == WRITE))
>  #define PACKED_CMD_VER		0x01
> +#define PACKED_CMD_RD		0x01
>  #define PACKED_CMD_WR		0x02
>
>  static DEFINE_MUTEX(block_mutex);
> @@ -104,6 +105,7 @@ struct mmc_blk_data {
>  #define MMC_BLK_WRITE		BIT(1)
>  #define MMC_BLK_DISCARD		BIT(2)
>  #define MMC_BLK_SECDISCARD	BIT(3)
> +#define MMC_BLK_WR_HDR		BIT(4)
>
>  	/*
>  	 * Only set in main mmc_blk_data associated
> @@ -1062,7 +1064,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
>  	 * kind.  If it was a write, we may have transitioned to
>  	 * program mode, which we have to wait for it to complete.
>  	 */
> -	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
> +	if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) ||
> +			(mq_mrq->packed_cmd == MMC_PACKED_WR_HDR)) {
>  		u32 status;
>  		do {
>  			int err = get_card_status(card, &status, 5);
> @@ -1087,7 +1090,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
>  		       (unsigned)blk_rq_sectors(req),
>  		       brq->cmd.resp[0], brq->stop.resp[0]);
>
> -		if (rq_data_dir(req) == READ) {
> +		if (rq_data_dir(req) == READ &&
> +				mq_mrq->packed_cmd != MMC_PACKED_WR_HDR) {
>  			if (ecc_err)
>  				return MMC_BLK_ECC_ERR;
>  			return MMC_BLK_DATA_ERR;
> @@ -1330,6 +1334,9 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue
> *mq, struct request *req)
>  	if ((rq_data_dir(cur) == WRITE) &&
>  			(card->host->caps2 & MMC_CAP2_PACKED_WR))
>  		max_packed_rw = card->ext_csd.max_packed_writes;
> +	else if ((rq_data_dir(cur) == READ) &&
> +			(card->host->caps2 & MMC_CAP2_PACKED_RD))
> +		max_packed_rw = card->ext_csd.max_packed_reads;
>
>  	if (max_packed_rw == 0)
>  		goto no_packed;
> @@ -1426,13 +1433,16 @@ static void mmc_blk_packed_hdr_wrq_prep(struct
> mmc_queue_req *mqrq,
>  	u32 *packed_cmd_hdr = mqrq->packed_cmd_hdr;
>  	u8 i = 1;
>
> -	mqrq->packed_cmd = MMC_PACKED_WRITE;
> +	mqrq->packed_cmd = (rq_data_dir(req) == READ) ?
> +		MMC_PACKED_WR_HDR : MMC_PACKED_WRITE;
>  	mqrq->packed_blocks = 0;
>  	mqrq->packed_fail_idx = MMC_PACKED_N_IDX;
>
>  	memset(packed_cmd_hdr, 0, sizeof(mqrq->packed_cmd_hdr));
>  	packed_cmd_hdr[0] = (mqrq->packed_num << 16) |
> -		(PACKED_CMD_WR << 8) | PACKED_CMD_VER;
> +		(((rq_data_dir(req) == READ) ?
> +		  PACKED_CMD_RD : PACKED_CMD_WR) << 8) |
> +		PACKED_CMD_VER;
>
>  	/*
>  	 * Argument for each entry of packed group
> @@ -1464,7 +1474,8 @@ static void mmc_blk_packed_hdr_wrq_prep(struct
> mmc_queue_req *mqrq,
>  	brq->mrq.stop = &brq->stop;
>
>  	brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
> -	brq->sbc.arg = MMC_CMD23_ARG_PACKED | (mqrq->packed_blocks + 1);
> +	brq->sbc.arg = MMC_CMD23_ARG_PACKED |
> +		((rq_data_dir(req) == READ) ? 1 : mqrq->packed_blocks + 1);
>  	brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
>
>  	brq->cmd.opcode = MMC_WRITE_MULTIPLE_BLOCK;
> @@ -1474,7 +1485,12 @@ static void mmc_blk_packed_hdr_wrq_prep(struct
> mmc_queue_req *mqrq,
>  	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
>
>  	brq->data.blksz = 512;
> -	brq->data.blocks = mqrq->packed_blocks + 1;
> +	/*
> +	 * Write separately the packd command header only for packed read.
> +	 * In case of packed write, header is sent with blocks of data.
> +	 */
> +	brq->data.blocks = (rq_data_dir(req) == READ) ?
> +		1 : mqrq->packed_blocks + 1;
>  	brq->data.flags |= MMC_DATA_WRITE;
>
>  	brq->stop.opcode = MMC_STOP_TRANSMISSION;
> @@ -1487,6 +1503,45 @@ static void mmc_blk_packed_hdr_wrq_prep(struct
> mmc_queue_req *mqrq,
>  	brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
>
>  	mqrq->mmc_active.mrq = &brq->mrq;
> +	mqrq->mmc_active.err_check = (rq_data_dir(req) == READ) ?
> +		mmc_blk_err_check : mmc_blk_packed_err_check;
> +
> +	mmc_queue_bounce_pre(mqrq);
> +}
> +
> +static void mmc_blk_packed_rrq_prep(struct mmc_queue_req *mqrq,
> +				    struct mmc_card *card,
> +				    struct mmc_queue *mq)
> +{
> +	struct mmc_blk_request *brq = &mqrq->brq;
> +	struct request *req = mqrq->req;
> +
> +	mqrq->packed_cmd = MMC_PACKED_READ;
> +
> +	memset(brq, 0, sizeof(struct mmc_blk_request));
> +	brq->mrq.cmd = &brq->cmd;
> +	brq->mrq.data = &brq->data;
> +	brq->mrq.stop = &brq->stop;
> +
> +	brq->cmd.opcode = MMC_READ_MULTIPLE_BLOCK;
> +	brq->cmd.arg = blk_rq_pos(req);
> +	if (!mmc_card_blockaddr(card))
> +		brq->cmd.arg <<= 9;
> +	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
> +	brq->data.blksz = 512;
> +	brq->data.blocks = mqrq->packed_blocks;
> +	brq->data.flags |= MMC_DATA_READ;
> +
> +	brq->stop.opcode = MMC_STOP_TRANSMISSION;
> +	brq->stop.arg = 0;
> +	brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
> +
> +	mmc_set_data_timeout(&brq->data, card);
> +
> +	brq->data.sg = mqrq->sg;
> +	brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
> +
> +	mqrq->mmc_active.mrq = &brq->mrq;
>  	mqrq->mmc_active.err_check = mmc_blk_packed_err_check;
>
>  	mmc_queue_bounce_pre(mqrq);
> @@ -1521,6 +1576,56 @@ static int mmc_blk_cmd_err(struct mmc_blk_data *md,
> struct mmc_card *card,
>  	return ret;
>  }
>
> +static int mmc_blk_chk_hdr_err(struct mmc_queue *mq, int status)
> +{
> +	struct mmc_blk_data *md = mq->data;
> +	struct mmc_card *card = md->queue.card;
> +	int type = MMC_BLK_WR_HDR, err = 0;
> +
> +	switch (status) {
> +	case MMC_BLK_PARTIAL:
> +	case MMC_BLK_RETRY:
> +		err = 0;
> +		break;
> +	case MMC_BLK_CMD_ERR:
> +	case MMC_BLK_ABORT:
> +	case MMC_BLK_DATA_ERR:
> +	case MMC_BLK_ECC_ERR:
> +		err = mmc_blk_reset(md, card->host, type);
> +		if (!err)
> +			mmc_blk_reset_success(md, type);
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int mmc_blk_issue_packed_rd(struct mmc_queue *mq,
> +				   struct mmc_queue_req *mq_rq)
> +{
> +	struct mmc_blk_data *md = mq->data;
> +	struct mmc_card *card = md->queue.card;
> +	int status, ret, retry = 2;
> +
> +	do {
> +		mmc_start_req(card->host, NULL, (int *) &status);
> +		if (status) {
> +			ret = mmc_blk_chk_hdr_err(mq, status);
> +			if (ret)
> +				break;
> +			mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq);
> +			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
> +		} else {
> +			mmc_blk_packed_rrq_prep(mq_rq, card, mq);
> +			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
> +			ret = 0;
> +			break;
> +		}
> +	} while (retry-- > 0);
> +
> +	return ret;
> +}
> +
>  static int mmc_blk_end_packed_req(struct mmc_queue_req *mq_rq)
>  {
>  	struct request *prq;
> @@ -1626,8 +1731,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> *mq, struct request *rqc)
>  		} else
>  			areq = NULL;
>  		areq = mmc_start_req(card->host, areq, (int *) &status);
> -		if (!areq)
> -			return 0;
> +		if (!areq) {
> +			if (mq->mqrq_cur->packed_cmd == MMC_PACKED_WR_HDR)
> +				goto snd_packed_rd;
> +			else
> +				return 0;
> +		}
>
>  		mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
>  		brq = &mq_rq->brq;
> @@ -1726,10 +1835,19 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> *mq, struct request *rqc)
>  				mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq);
>  				mmc_start_req(card->host,
>  						&mq_rq->mmc_active, NULL);
> +				if (mq_rq->packed_cmd == MMC_PACKED_WR_HDR) {
> +					if (mmc_blk_issue_packed_rd(mq, mq_rq))
> +						goto cmd_abort;
> +				}
>  			}
>  		}
>  	} while (ret);
>
> +snd_packed_rd:
> +	if (mq->mqrq_cur->packed_cmd == MMC_PACKED_WR_HDR) {
> +		if (mmc_blk_issue_packed_rd(mq, mq->mqrq_cur))
> +			goto start_new_req;
> +	}
>  	return 1;
>
>   cmd_abort:
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 165d85a..277905e 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -389,11 +389,15 @@ static unsigned int mmc_queue_packed_map_sg(struct
> mmc_queue *mq,
>
>  	cmd = mqrq->packed_cmd;
>
> -	if (cmd == MMC_PACKED_WRITE) {
> +	if (cmd == MMC_PACKED_WR_HDR || cmd == MMC_PACKED_WRITE) {
>  		__sg = sg;
>  		sg_set_buf(__sg, mqrq->packed_cmd_hdr,
>  				sizeof(mqrq->packed_cmd_hdr));
>  		sg_len++;
> +		if (cmd == MMC_PACKED_WR_HDR) {
> +			sg_mark_end(__sg);
> +			return sg_len;
> +		}
>  		__sg->page_link &= ~0x02;
>  	}
>
> diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
> index 5e04938..a8cad1f 100644
> --- a/drivers/mmc/card/queue.h
> +++ b/drivers/mmc/card/queue.h
> @@ -14,7 +14,9 @@ struct mmc_blk_request {
>
>  enum mmc_packed_cmd {
>  	MMC_PACKED_NONE = 0,
> +	MMC_PACKED_WR_HDR,
>  	MMC_PACKED_WRITE,
> +	MMC_PACKED_READ,
>  };
>
>  struct mmc_queue_req {
> --
> 1.7.0.4
>
>
>


-- 
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

