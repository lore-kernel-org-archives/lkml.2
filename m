Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2D3AbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:31:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49342 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2D3AbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:31:11 -0400
X-AuditID: cbfee61a-b7bfeae0000070f7-22-4f9ddd4d62e6
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <49230ae96550a05ad57cc55c38f31136.squirrel@www.codeaurora.org>
In-reply-to: <49230ae96550a05ad57cc55c38f31136.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Mon, 30 Apr 2012 09:31:09 +0900
Message-id: <001601cd2668$8a074940$9e15dbc0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0jpzidyOlb8r0eROyT5mKP31ah8QCOfPmw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maya,

Maya Erez <merez@codeaurora.org> wrote:
> 
> Hi Jeon,
> 
> Any update for splitting between the read and write packing?
I'll work soon.
> I also have a few more comments:
> 
> > +static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request
> *req)
> > +{
> > +	struct request_queue *q = mq->queue;
> > +	struct mmc_card *card = mq->card;
> > +	struct request *cur = req, *next = NULL;
> > +	struct mmc_blk_data *md = mq->data;
> > +	bool en_rel_wr = card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN;
> +	unsigned int req_sectors = 0, phys_segments = 0;
> > +	unsigned int max_blk_count, max_phys_segs;
> > +	u8 put_back = 0;
> > +	u8 max_packed_rw = 0;
> > +	u8 reqs = 0;
> > +
> > +	mq->mqrq_cur->packed_num = MMC_PACKED_N_ZERO;
> > +
> > +	if (!(md->flags & MMC_BLK_CMD23) ||
> > +			!card->ext_csd.packed_event_en)
> > +		goto no_packed;
> > +
> > +	if ((rq_data_dir(cur) == READ) &&
> > +			(card->host->caps2 & MMC_CAP2_PACKED_RD))
> > +		max_packed_rw = card->ext_csd.max_packed_reads;
> > +	else if ((rq_data_dir(cur) == WRITE) &&
> > +			(card->host->caps2 & MMC_CAP2_PACKED_WR))
> > +		max_packed_rw = card->ext_csd.max_packed_writes;
> > +
> > +	if (max_packed_rw == 0)
> > +		goto no_packed;
> > +
> > +	if (mmc_req_rel_wr(cur) &&
> > +			(md->flags & MMC_BLK_REL_WR) &&
> > +			!en_rel_wr) {
> > +		goto no_packed;
> > +	}
> > +
> > +	max_blk_count = min(card->host->max_blk_count,
> > +			card->host->max_req_size >> 9);
> > +	if (unlikely(max_blk_count > 0xffff))
> > +		max_blk_count = 0xffff;
> > +
> > +	max_phys_segs = queue_max_segments(q);
> > +	req_sectors += blk_rq_sectors(cur);
> > +	phys_segments += req->nr_phys_segments;
> It would be best to change req to cur. This is the only place you use req,
> in all other places you refer to cur.
Good point.
> 
> > @@ -1291,10 +1657,42 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> *mq, struct request *rqc)
> >  			 * A block was successfully transferred.
> >  			 */
> >  			mmc_blk_reset_success(md, type);
> > -			spin_lock_irq(&md->lock);
> > -			ret = __blk_end_request(req, 0,
> > +
> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> > +				int idx = mq_rq->packed_fail_idx, i = 0;
> > +				ret = 0;
> > +				while (!list_empty(&mq_rq->packed_list)) {
> > +					prq = list_entry_rq(
> > +						mq_rq->packed_list.next);
> > +					if (idx == i) {
> > +						/* retry from error index */
> > +						mq_rq->packed_num -= idx;
> > +						mq_rq->req = prq;
> > +						ret = 1;
> > +						break;
> > +					}
> > +					list_del_init(&prq->queuelist);
> > +					spin_lock_irq(&md->lock);
> > +					__blk_end_request(prq, 0,
> > +							blk_rq_bytes(prq));
> > +					spin_unlock_irq(&md->lock);
> > +					i++;
> > +				}
> > +				if (mq_rq->packed_num == MMC_PACKED_N_SINGLE) {
> > +					prq = list_entry_rq(
> > +						mq_rq->packed_list.next);
> You already get the prq inside the while. There is no need to do it again.
Right, but if while loop isn't taken, then prq can be used uninitialized.
Though that case wouldn't happen actually, we don't want to see the compiling error.
> 
> 
> > @@ -1329,6 +1727,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> *mq,
> > struct request *rqc)
> >  				break;
> >  			if (err == -ENODEV)
> >  				goto cmd_abort;
> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE)
> > +				break;
> This can cause an endless loop in case of MMC_BLK_DATA_ERR. The same
> packed command will be sent over and over again without a beaking point.
Yes. It may be possible in case of twice MMC_BLK_DATA_ERR.

Thanks
Seungwon Jeon.
> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

