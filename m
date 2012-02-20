Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2BTVWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:22:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50916 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2BTVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:22:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="164765306"
Message-ID: <e62a9b49ee1778129ef1b0adf2e14fc7.squirrel@www.codeaurora.org>
In-Reply-To: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
Date: Mon, 20 Feb 2012 13:22:37 -0800 (PST)
Subject: Re: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> @@ -1262,21 +1608,32 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> *mq, struct request *rqc)
>  	int ret = 1, disable_multi = 0, retry = 0, type;
>  	enum mmc_blk_status status;
>  	struct mmc_queue_req *mq_rq;
> -	struct request *req;
> +	struct request *req, *prq;
>  	struct mmc_async_req *areq;
> +	u8 reqs = 0;
>
>  	if (!rqc && !mq->mqrq_prev->req)
>  		return 0;
>
> +	if (rqc)
> +		reqs = mmc_blk_prep_packed_list(mq, rqc);
> +
>  	do {
>  		if (rqc) {
> -			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> +			if (reqs >= card->host->packed_min)
In case host->packed_min will be set to a value bigger than 2 you will
loose all the requests that were added to the packed list. If you want to
support dynamic number of min packed requests you need to move the packed
list preparation to queue.c where you can issue the fetched requests one
after another, when (reqs < card->host->packed_min).
> +				mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
> +			else
> +				mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

