Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2EBSfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:35:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60943 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab2EBSf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:35:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6698"; a="184696043"
Message-ID: <6c62e1bf619db82fb165dce5c6f383c4.squirrel@www.codeaurora.org>
In-Reply-To: <001601cd2668$8a074940$9e15dbc0$%jun@samsung.com>
References: <49230ae96550a05ad57cc55c38f31136.squirrel@www.codeaurora.org>
    <001601cd2668$8a074940$9e15dbc0$%jun@samsung.com>
Date: Wed, 2 May 2012 11:35:28 -0700 (PDT)
Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 
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

>> > @@ -1291,10 +1657,42 @@ static int mmc_blk_issue_rw_rq(struct
>> mmc_queue
>> *mq, struct request *rqc)
>> >  			 * A block was successfully transferred.
>> >  			 */
>> >  			mmc_blk_reset_success(md, type);
>> > -			spin_lock_irq(&md->lock);
>> > -			ret = __blk_end_request(req, 0,
>> > +
>> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
>> > +				int idx = mq_rq->packed_fail_idx, i = 0;
>> > +				ret = 0;
>> > +				while (!list_empty(&mq_rq->packed_list)) {
>> > +					prq = list_entry_rq(
>> > +						mq_rq->packed_list.next);
>> > +					if (idx == i) {
>> > +						/* retry from error index */
>> > +						mq_rq->packed_num -= idx;
>> > +						mq_rq->req = prq;
>> > +						ret = 1;
>> > +						break;
>> > +					}
>> > +					list_del_init(&prq->queuelist);
>> > +					spin_lock_irq(&md->lock);
>> > +					__blk_end_request(prq, 0,
>> > +							blk_rq_bytes(prq));
>> > +					spin_unlock_irq(&md->lock);
>> > +					i++;
>> > +				}
>> > +				if (mq_rq->packed_num == MMC_PACKED_N_SINGLE) {
>> > +					prq = list_entry_rq(
>> > +						mq_rq->packed_list.next);
>> You already get the prq inside the while. There is no need to do it
>> again.
> Right, but if while loop isn't taken, then prq can be used uninitialized.
> Though that case wouldn't happen actually, we don't want to see the
> compiling error.

The loop must be taken since we are inside the case of packed commands so
the list can't be empty.

If the compiler complained, you can set prq to be the first request before
entering the loop instead of setting it again in the if that follows the
loop. It will probably be more understood.
If you decide to leave it as is, I would also add the following to the if:
+                                                mq_rq->req = prq;
+                                                ret = 1;
Otherwise it seems like there could be a bug in cases where the loop is
not taken (since prq is the only one that is set) and the code is less
understood.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


