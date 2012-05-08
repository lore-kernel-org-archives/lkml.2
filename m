Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2EHXlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:41:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2EHXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:41:10 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-3a-4fa9af14acae
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <49230ae96550a05ad57cc55c38f31136.squirrel@www.codeaurora.org>
 <001601cd2668$8a074940$9e15dbc0$%jun@samsung.com>
 <6c62e1bf619db82fb165dce5c6f383c4.squirrel@www.codeaurora.org>
In-reply-to: <6c62e1bf619db82fb165dce5c6f383c4.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Wed, 09 May 2012 08:41:08 +0900
Message-id: <001d01cd2d74$0ac74460$2055cd20$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0okluOJ1dgRa9AQJ6PRB5ZBmUsFQE4QN0w
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of
> merez@codeaurora.org
> Sent: Thursday, May 03, 2012 3:35 AM
> To: Seungwon Jeon
> Cc: merez@codeaurora.org; linux-mmc@vger.kernel.org; 'Chris Ball'; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 device
> 
> >> > @@ -1291,10 +1657,42 @@ static int mmc_blk_issue_rw_rq(struct
> >> mmc_queue
> >> *mq, struct request *rqc)
> >> >  			 * A block was successfully transferred.
> >> >  			 */
> >> >  			mmc_blk_reset_success(md, type);
> >> > -			spin_lock_irq(&md->lock);
> >> > -			ret = __blk_end_request(req, 0,
> >> > +
> >> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> >> > +				int idx = mq_rq->packed_fail_idx, i = 0;
> >> > +				ret = 0;
> >> > +				while (!list_empty(&mq_rq->packed_list)) {
> >> > +					prq = list_entry_rq(
> >> > +						mq_rq->packed_list.next);
> >> > +					if (idx == i) {
> >> > +						/* retry from error index */
> >> > +						mq_rq->packed_num -= idx;
> >> > +						mq_rq->req = prq;
> >> > +						ret = 1;
> >> > +						break;
> >> > +					}
> >> > +					list_del_init(&prq->queuelist);
> >> > +					spin_lock_irq(&md->lock);
> >> > +					__blk_end_request(prq, 0,
> >> > +							blk_rq_bytes(prq));
> >> > +					spin_unlock_irq(&md->lock);
> >> > +					i++;
> >> > +				}
> >> > +				if (mq_rq->packed_num == MMC_PACKED_N_SINGLE) {
> >> > +					prq = list_entry_rq(
> >> > +						mq_rq->packed_list.next);
> >> You already get the prq inside the while. There is no need to do it
> >> again.
> > Right, but if while loop isn't taken, then prq can be used uninitialized.
> > Though that case wouldn't happen actually, we don't want to see the
> > compiling error.
> 
> The loop must be taken since we are inside the case of packed commands so
> the list can't be empty.
> 
> If the compiler complained, you can set prq to be the first request before
> entering the loop instead of setting it again in the if that follows the
> loop. It will probably be more understood.
> If you decide to leave it as is, I would also add the following to the if:
> +                                                mq_rq->req = prq;
> +                                                ret = 1;
> Otherwise it seems like there could be a bug in cases where the loop is
> not taken (since prq is the only one that is set) and the code is less
> understood.
I'll clarify this as you concern.
Thank you for your review.

Best regards,
Seungwon Jeon.

> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

