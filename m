Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2BUFfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:35:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:20053 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2BUFfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:35:06 -0500
X-AuditID: cbfee61b-b7c62ae000000989-c5-4f432d088969
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
 <e62a9b49ee1778129ef1b0adf2e14fc7.squirrel@www.codeaurora.org>
In-reply-to: <e62a9b49ee1778129ef1b0adf2e14fc7.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Tue, 21 Feb 2012 14:35:03 +0900
Message-id: <000401ccf05a$9032c130$b0984390$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczwFdcPIN1cEJJYQE+cLyLUJDIblgANyLnw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > @@ -1262,21 +1608,32 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> > *mq, struct request *rqc)
> >  	int ret = 1, disable_multi = 0, retry = 0, type;
> >  	enum mmc_blk_status status;
> >  	struct mmc_queue_req *mq_rq;
> > -	struct request *req;
> > +	struct request *req, *prq;
> >  	struct mmc_async_req *areq;
> > +	u8 reqs = 0;
> >
> >  	if (!rqc && !mq->mqrq_prev->req)
> >  		return 0;
> >
> > +	if (rqc)
> > +		reqs = mmc_blk_prep_packed_list(mq, rqc);
> > +
> >  	do {
> >  		if (rqc) {
> > -			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> > +			if (reqs >= card->host->packed_min)
> In case host->packed_min will be set to a value bigger than 2 you will
> loose all the requests that were added to the packed list. If you want to
> support dynamic number of min packed requests you need to move the packed
> list preparation to queue.c where you can issue the fetched requests one
> after another, when (reqs < card->host->packed_min).

That's a good point.
The requests added to the packed list will be remained
if current number of packed request is less than packed_min.
In such a case, requests should be put back to request_queue from packed list.
I think it's a additional and unnecessary work due to packed_min.
It's not interesting. So I want to revert this regulation of packed_min.

And we have discussed the location of mmc_blk_prep_packed_list(block.c or queue.c) several times.
Packed command is valid only if request type is read/write,
so it may be a good location to decide in mmc_blk_issue_rw_rq in block.c.
I guess you want this function to be located in mmc_queue_thread in queue.c, right?
Is it advantageous? Could you explain for this?

Thanks,
Seungwon Jeon
> > +				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
> > +			else
> > +				mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

