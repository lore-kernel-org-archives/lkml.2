Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2BUSFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:05:05 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46422 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2BUSFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:05:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="162718773"
Message-ID: <4F43DCBA.5070605@codeaurora.org>
Date: Tue, 21 Feb 2012 10:04:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Yaniv Gardi <ygardi@codeaurora.org>
CC: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, axboe@kernel.dk,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] mmc: card: Adding support for Sanitize in eMMC
 v4.5
References: <1329832825-8844-1-git-send-email-ygardi@codeaurora.org> <1329832825-8844-3-git-send-email-ygardi@codeaurora.org>
In-Reply-To: <1329832825-8844-3-git-send-email-ygardi@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/12 06:00, Yaniv Gardi wrote:
> @@ -922,6 +918,44 @@ out:
>  	return err ? 0 : 1;
>  }
>  
> +int mmc_blk_issue_sanitize_rq(struct mmc_queue *mq,
> +			       struct request *req)
> +{
> +	struct mmc_blk_data *md = mq->data;
> +	struct mmc_card *card = md->queue.card;
> +	int err = 0;
> +
> +	if (!(mmc_can_sanitize(card) && (mq->card->host->caps2 & MMC_CAP2_SANITIZE))) {
> +		pr_err("%s: SANITIZE is not supported", __func__);
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	pr_info("%s: SANITIZE is supported", __func__);

These look like debug printks. Please remove them.

> +
> +	mmc_sd_card_set_sanitize_in_progress(card);
> +
> +	pr_info("%s: issueing SANITIZE command...", __func__);
> +
> +	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +					 EXT_CSD_SANITIZE_START, 1, 0);
> +
> +	pr_info("%s: SANITIZE command returned...", __func__);
> +
> +	if (err)
> +		pr_err("%s: mmcblk: mmc_switch() failed. err=%d\n",
> +		       __func__, err);
> +
> +	mmc_sd_card_set_sanitize_completed(card);
> +
> +out:
> +	spin_lock_irq(&md->lock);
> +	__blk_end_request(req, err, blk_rq_bytes(req));
> +	spin_unlock_irq(&md->lock);
> +
> +	return err ? 0 : 1;
> +}
> +
>  static int mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
>  {
>  	struct mmc_blk_data *md = mq->data;
> @@ -181,6 +186,11 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
>  	if (mmc_can_erase(card))
>  		mmc_queue_setup_discard(mq->queue, card);
>  
> +	if ((mmc_can_sanitize(card) && (host->caps2 & MMC_CAP2_SANITIZE)))
> +		mmc_queue_setup_sanitize(mq->queue);
> +	else
> +		pr_info("%s - card doesn't support sanitize", __func__);

debug printk again?

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

