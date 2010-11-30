Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0K3SJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:09:00 -0500
Received: from smtp.nokia.com ([147.243.1.47]:55905 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0K3SI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:08:59 -0500
Message-ID: <4CF53D8B.7060907@nokia.com>
Date: Tue, 30 Nov 2010 20:08:11 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Yunpeng Gao <yunpeng.gao@intel.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/3]mmc: enable runtime PM support for block driver
References: <20101128054818.GB3318@intel.com>
In-Reply-To: <20101128054818.GB3318@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2010 18:08:11.0954 (UTC) FILETIME=[8D064920:01CB90B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/10 07:48, ext Yunpeng Gao wrote:
>
>> From 51e4d34f19b48552a10a9f6b69f51c5aeed18d03 Mon Sep 17 00:00:00 2001
> From: Yunpeng Gao<yunpeng.gao@intel.com>
> Date: Sun, 28 Nov 2010 08:01:01 +0800
> Subject: [PATCH] Enable runtime pm support for block driver of mmc stack.
>
> Follow the kernel runtime pm framework, this patch enable
> runtime pm support for block driver of mmc stack.
> To validate it, it needs runtime pm support for mmc bus
> and host controller to be enabled also.
>
> Signed-off-by: Yunpeng Gao<yunpeng.gao@intel.com>
> ---
>   drivers/mmc/card/block.c |   24 +++++++++++++++++++++---
>   1 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 217f820..8a35814 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -31,6 +31,7 @@
>   #include<linux/mutex.h>
>   #include<linux/scatterlist.h>
>   #include<linux/string_helpers.h>
> +#include<linux/pm_runtime.h>
>
>   #include<linux/mmc/card.h>
>   #include<linux/mmc/host.h>
> @@ -560,14 +561,24 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
>
>   static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>   {
> +	struct mmc_blk_data *md = mq->data;
> +	struct mmc_card *card = md->queue.card;
> +	int ret;
> +
> +	pm_runtime_get_sync(&card->dev);

Wouldn't it be better to "get" when the queue thread wakes up
and "put" before it goes to sleep?

> +
>   	if (req->cmd_flags&  REQ_DISCARD) {
>   		if (req->cmd_flags&  REQ_SECURE)
> -			return mmc_blk_issue_secdiscard_rq(mq, req);
> +			ret = mmc_blk_issue_secdiscard_rq(mq, req);
>   		else
> -			return mmc_blk_issue_discard_rq(mq, req);
> +			ret = mmc_blk_issue_discard_rq(mq, req);
>   	} else {
> -		return mmc_blk_issue_rw_rq(mq, req);
> +		ret = mmc_blk_issue_rw_rq(mq, req);
>   	}
> +
> +	pm_runtime_put(&card->dev);
> +
> +	return ret;
>   }
>
>   static inline int mmc_blk_readonly(struct mmc_card *card)
> @@ -709,6 +720,11 @@ static int mmc_blk_probe(struct mmc_card *card)
>
>   	mmc_set_drvdata(card, md);
>   	add_disk(md->disk);
> +
> +	/* Indicate to runtime PM core that our device is active */
> +	pm_runtime_set_active(&card->dev);
> +	pm_runtime_enable(&card->dev);
> +
>   	return 0;
>
>    out:
> @@ -732,6 +748,8 @@ static void mmc_blk_remove(struct mmc_card *card)
>   		mmc_blk_put(md);
>   	}
>   	mmc_set_drvdata(card, NULL);
> +
> +	pm_runtime_disable(&card->dev);
>   }
>
>   #ifdef CONFIG_PM

