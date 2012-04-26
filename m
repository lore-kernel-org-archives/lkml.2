Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab2DZMV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:21:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9670 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753504Ab2DZMV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:21:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="185113628"
Message-ID: <49230ae96550a05ad57cc55c38f31136.squirrel@www.codeaurora.org>
Date: Thu, 26 Apr 2012 05:21:16 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5   
             device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, "'Maya Erez'" <merez@codeaurora.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeon,

Any update for splitting between the read and write packing?
I also have a few more comments:

> +static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request
*req)
> +{
> +	struct request_queue *q = mq->queue;
> +	struct mmc_card *card = mq->card;
> +	struct request *cur = req, *next = NULL;
> +	struct mmc_blk_data *md = mq->data;
> +	bool en_rel_wr = card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN;
+	unsigned int req_sectors = 0, phys_segments = 0;
> +	unsigned int max_blk_count, max_phys_segs;
> +	u8 put_back = 0;
> +	u8 max_packed_rw = 0;
> +	u8 reqs = 0;
> +
> +	mq->mqrq_cur->packed_num = MMC_PACKED_N_ZERO;
> +
> +	if (!(md->flags & MMC_BLK_CMD23) ||
> +			!card->ext_csd.packed_event_en)
> +		goto no_packed;
> +
> +	if ((rq_data_dir(cur) == READ) &&
> +			(card->host->caps2 & MMC_CAP2_PACKED_RD))
> +		max_packed_rw = card->ext_csd.max_packed_reads;
> +	else if ((rq_data_dir(cur) == WRITE) &&
> +			(card->host->caps2 & MMC_CAP2_PACKED_WR))
> +		max_packed_rw = card->ext_csd.max_packed_writes;
> +
> +	if (max_packed_rw == 0)
> +		goto no_packed;
> +
> +	if (mmc_req_rel_wr(cur) &&
> +			(md->flags & MMC_BLK_REL_WR) &&
> +			!en_rel_wr) {
> +		goto no_packed;
> +	}
> +
> +	max_blk_count = min(card->host->max_blk_count,
> +			card->host->max_req_size >> 9);
> +	if (unlikely(max_blk_count > 0xffff))
> +		max_blk_count = 0xffff;
> +
> +	max_phys_segs = queue_max_segments(q);
> +	req_sectors += blk_rq_sectors(cur);
> +	phys_segments += req->nr_phys_segments;
It would be best to change req to cur. This is the only place you use req,
in all other places you refer to cur.

> @@ -1291,10 +1657,42 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
*mq, struct request *rqc)
>  			 * A block was successfully transferred.
>  			 */
>  			mmc_blk_reset_success(md, type);
> -			spin_lock_irq(&md->lock);
> -			ret = __blk_end_request(req, 0,
> +
> +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> +				int idx = mq_rq->packed_fail_idx, i = 0;
> +				ret = 0;
> +				while (!list_empty(&mq_rq->packed_list)) {
> +					prq = list_entry_rq(
> +						mq_rq->packed_list.next);
> +					if (idx == i) {
> +						/* retry from error index */
> +						mq_rq->packed_num -= idx;
> +						mq_rq->req = prq;
> +						ret = 1;
> +						break;
> +					}
> +					list_del_init(&prq->queuelist);
> +					spin_lock_irq(&md->lock);
> +					__blk_end_request(prq, 0,
> +							blk_rq_bytes(prq));
> +					spin_unlock_irq(&md->lock);
> +					i++;
> +				}
> +				if (mq_rq->packed_num == MMC_PACKED_N_SINGLE) {
> +					prq = list_entry_rq(
> +						mq_rq->packed_list.next);
You already get the prq inside the while. There is no need to do it again.


> @@ -1329,6 +1727,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
*mq,
> struct request *rqc)
>  				break;
>  			if (err == -ENODEV)
>  				goto cmd_abort;
> +			if (mq_rq->packed_cmd != MMC_PACKED_NONE)
> +				break;
This can cause an endless loop in case of MMC_BLK_DATA_ERR. The same
packed command will be sent over and over again without a beaking point.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





