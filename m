Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1KTTlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 14:41:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39785 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1KTTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 14:41:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6536"; a="139386990"
Message-ID: <c55cd0ae6258c1db111aa0bd229d0e86.squirrel@www.codeaurora.org>
In-Reply-To: <004b01cca4cf$dd318f60$9794ae20$%jun@samsung.com>
References: <e56e6a44db4d8a0103825c1cc909f125.squirrel@www.codeaurora.org>
    <004b01cca4cf$dd318f60$9794ae20$%jun@samsung.com>
Date: Sun, 20 Nov 2011 11:41:04 -0800 (PST)
Subject: RE: [PATCH] mmc: core: Add packed command for eMMC4.5 device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: merez@codeaurora.org, svenkatr@ti.com, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maya Erez wrote:
>>
>> > +			if (reqs >= 2) {
>> > +				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
>> > +				if (rq_data_dir(rqc) == READ) {
>> > +					areq = &mq->mqrq_cur->mmc_active;
>> > +					mmc_wait_for_req(card->host, areq->mrq);
>> Packing read requests requires preparation of two requests. After
>> sending
>> the header we wait for its completion before sending the next request
>> (mmc_wait_for_req is used). Therefore, if we try to pack 2 read requests
>> we might end up with worse performance in comparison to sending each
>> request by itself (which allows the preparation of one request while the
>> other is sent).
>> I suggest to check the size of the packed commands list and in case it
>> is
>> less than 3 send the requests one by one. If you move
>> mmc_blk_chk_packable
>> to queue.c after the first fetch this change should be very easy and can
>> be done by removing the requests from the packed_list and calling
>> issue_fn
>> for each one of them.
>
> Sending header for packed read which doesn't require nand program
> unlike normal data, so it may not spend long time.
> Which point you think is the overhead of packed two-requests
> in comparison to individual request?
When you send the packed commands you have to send an additional sector.
When you have only 2 or even 3 requests to send this might not be
negligible.
I think it's worth checking how often we send 2-3 requests in the packed
commands and if it's better to send it separately or packed. According to
the results you can decide if it's worth handling such cases.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>>
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


