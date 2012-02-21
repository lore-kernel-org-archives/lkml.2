Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2BUCIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:08:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36952 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2BUCIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:08:45 -0500
MIME-Version: 1.0
In-Reply-To: <e62a9b49ee1778129ef1b0adf2e14fc7.squirrel@www.codeaurora.org>
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
	<e62a9b49ee1778129ef1b0adf2e14fc7.squirrel@www.codeaurora.org>
Date: Tue, 21 Feb 2012 11:08:44 +0900
Message-ID: <CAKYAXd_Md14TB+kJz3L5spF6jdcZL86eE1Oe8T6T3umpByyKbQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
From: Namjae Jeon <linkinjeon@gmail.com>
To: merez@codeaurora.org
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/21  <merez@codeaurora.org>:
>>
>> @@ -1262,21 +1608,32 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
>> *mq, struct request *rqc)
>>       int ret = 1, disable_multi = 0, retry = 0, type;
>>       enum mmc_blk_status status;
>>       struct mmc_queue_req *mq_rq;
>> -     struct request *req;
>> +     struct request *req, *prq;
>>       struct mmc_async_req *areq;
>> +     u8 reqs = 0;
>>
>>       if (!rqc && !mq->mqrq_prev->req)
>>               return 0;
>>
>> +     if (rqc)
>> +             reqs = mmc_blk_prep_packed_list(mq, rqc);
>> +
>>       do {
>>               if (rqc) {
>> -                     mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
>> +                     if (reqs >= card->host->packed_min)
> In case host->packed_min will be set to a value bigger than 2 you will
> loose all the requests that were added to the packed list. If you want to
> support dynamic number of min packed requests you need to move the packed
> list preparation to queue.c where you can issue the fetched requests one
> after another, when (reqs < card->host->packed_min).
I don't understand why packed list preparation should be moved to
queue.c for dynamic number of packed min.
we can change packed min value via sysfs without compiling.
Would you explain more ?

>> +                             mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
>> +                     else
>> +                             mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
>
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
