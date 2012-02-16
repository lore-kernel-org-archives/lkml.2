Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2BPAJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:09:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40664 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2BPAJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:09:47 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-18-4f3c494ae6ab
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
 <fd4b8ef9df0d19e20c07923077937231.squirrel@www.codeaurora.org>
In-reply-to: <fd4b8ef9df0d19e20c07923077937231.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Thu, 16 Feb 2012 09:09:45 +0900
Message-id: <004301ccec3f$4a4e9320$deebb960$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczrxXAtHh2SiX1qRQ6YTVJH8mMMkQAdYpug
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > @@ -1065,12 +1075,60 @@ static int mmc_blk_err_check(struct mmc_card
> > *card,
> >  	if (!brq->data.bytes_xfered)
> >  		return MMC_BLK_RETRY;
> >
> > +	if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
> > +		if (unlikely(brq->data.blocks << 9 != brq->data.bytes_xfered))
> > +			return MMC_BLK_PARTIAL;
> > +		else
> > +			return MMC_BLK_SUCCESS;
> > +	}
> > +
> >  	if (blk_rq_bytes(req) != brq->data.bytes_xfered)
> >  		return MMC_BLK_PARTIAL;
> >
> >  	return MMC_BLK_SUCCESS;
> >  }
> I think it would be best to keep the request length (brq->data.blocks << 9
> or blk_rq_bytes(req)) in a variable and use it in the original if above.
> This way you can avoid doubling the exit points from the function.
In case of packed command, brq->data.blocks contains the sum of blocks for individual request.
That means blk_rq_bytes(req) doesn't represent all packed length bytes.
And "brq->data.blocks << 9" is not idential to blk_rq_bytes(req) in non-packed command.
"brq->data.blocks" is overwritten during request preparation by the following reasons.
- brq->data.blocks > card->host->max_blk_count
- disable_multi
- do_rel_wr
So "brq->data.blocks << 9" is not good choice for request length  in non-packed command.

Thanks,
Seungwon Jeon

> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

