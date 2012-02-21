Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2BUTC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:02:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17601 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2BUTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:02:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="162737688"
Message-ID: <baeb19a6436a63fd4f97782a6e22b7a6.squirrel@www.codeaurora.org>
In-Reply-To: <000401ccf05a$9032c130$b0984390$%jun@samsung.com>
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
    <e62a9b49ee1778129ef1b0adf2e14fc7.squirrel@www.codeaurora.org>
    <000401ccf05a$9032c130$b0984390$%jun@samsung.com>
Date: Tue, 21 Feb 2012 11:02:25 -0800 (PST)
Subject: RE: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: merez@codeaurora.org, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maya Erez <merez@codeaurora.org> wrote:
>> > @@ -1262,21 +1608,32 @@ static int mmc_blk_issue_rw_rq(struct
>> mmc_queue
>> > *mq, struct request *rqc)
>> >  	int ret = 1, disable_multi = 0, retry = 0, type;
>> >  	enum mmc_blk_status status;
>> >  	struct mmc_queue_req *mq_rq;
>> > -	struct request *req;
>> > +	struct request *req, *prq;
>> >  	struct mmc_async_req *areq;
>> > +	u8 reqs = 0;
>> >
>> >  	if (!rqc && !mq->mqrq_prev->req)
>> >  		return 0;
>> >
>> > +	if (rqc)
>> > +		reqs = mmc_blk_prep_packed_list(mq, rqc);
>> > +
>> >  	do {
>> >  		if (rqc) {
>> > -			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
>> > +			if (reqs >= card->host->packed_min)
>> In case host->packed_min will be set to a value bigger than 2 you will
>> loose all the requests that were added to the packed list. If you want
>> to
>> support dynamic number of min packed requests you need to move the
>> packed
>> list preparation to queue.c where you can issue the fetched requests one
>> after another, when (reqs < card->host->packed_min).
>
> That's a good point.
> The requests added to the packed list will be remained
> if current number of packed request is less than packed_min.
> In such a case, requests should be put back to request_queue from packed
> list.
> I think it's a additional and unnecessary work due to packed_min.
> It's not interesting. So I want to revert this regulation of packed_min.
>
> And we have discussed the location of mmc_blk_prep_packed_list(block.c or
> queue.c) several times.
> Packed command is valid only if request type is read/write,
> so it may be a good location to decide in mmc_blk_issue_rw_rq in block.c.
> I guess you want this function to be located in mmc_queue_thread in
> queue.c, right?
> Is it advantageous? Could you explain for this?
>
> Thanks,
> Seungwon Jeon
Regarding moving the code to queue.c, I think that if we decide to keep
packed_min it will be more efficient to send the fetched requests one
after another instead of requeueing them and fetch them again next time
(which can lead to long fetch->requeue sequences).
I agree we can remove the packed_min and use a constant of 2 instead. It
will make the code much more complex and I don't see a real need for it.
>> > +				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
>> > +			else
>> > +				mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
>>
>> Thanks,
>> Maya Erez
>> Consultant for Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


