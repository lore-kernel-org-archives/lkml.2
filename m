Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2GQKvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:51:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19616 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2GQKvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:51:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6774"; a="209039341"
Message-ID: <ecae62c06045a085e7ee93ce819925d5.squirrel@www.codeaurora.org>
In-Reply-To: <5d5a6ed38f663d9234eb36f9f2e79a4d.squirrel@www.codeaurora.org>
References: <1340872367-16206-1-git-send-email-ygardi@codeaurora.org>
    <1340872367-16206-3-git-send-email-ygardi@codeaurora.org>
    <5d5a6ed38f663d9234eb36f9f2e79a4d.squirrel@www.codeaurora.org>
Date: Tue, 17 Jul 2012 03:51:05 -0700 (PDT)
Subject: Re: [PATCH RESEND v7 2/2] mmc: card: Adding support for sanitize   
        in eMMC 4.5
From: "Yaniv Gardi" <ygardi@codeaurora.org>
To: merez@codeaurora.org
Cc: "Yaniv Gardi" <ygardi@codeaurora.org>, linux-mmc@vger.kernel.org,
        merez@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>, "Chris Ball" <cjb@laptop.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Can you push this patch to mmc-next?

Thanks,
Yaniv
> Looks good to me.
> Reviewed-by: Maya Erez <merez@codeaurora.org>
>
> On Thu, June 28, 2012 1:32 am, Yaniv Gardi wrote:
>> This feature delete the unmap memory region of the eMMC card,
>> by writing to a specific register in the EXT_CSD
>> unmap region is the memory region that were previously deleted
>> (by erase, trim or discard operation)
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/mmc/card/block.c |   72
>> +++++++++++++++++++++++++++++++++-------------
>>  drivers/mmc/card/queue.c |   10 ++++++-
>>  include/linux/mmc/host.h |    1 +
>>  3 files changed, 62 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index dd2d374..139971e 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -874,10 +874,10 @@ static int mmc_blk_issue_secdiscard_rq(struct
>> mmc_queue *mq,
>>  {
>>  	struct mmc_blk_data *md = mq->data;
>>  	struct mmc_card *card = md->queue.card;
>> -	unsigned int from, nr, arg, trim_arg, erase_arg;
>> +	unsigned int from, nr, arg;
>>  	int err = 0, type = MMC_BLK_SECDISCARD;
>>
>> -	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))) {
>> +	if (!(mmc_can_secure_erase_trim(card))) {
>>  		err = -EOPNOTSUPP;
>>  		goto out;
>>  	}
>> @@ -885,23 +885,10 @@ static int mmc_blk_issue_secdiscard_rq(struct
>> mmc_queue *mq,
>>  	from = blk_rq_pos(req);
>>  	nr = blk_rq_sectors(req);
>>
>> -	/* The sanitize operation is supported at v4.5 only */
>> -	if (mmc_can_sanitize(card)) {
>> -		erase_arg = MMC_ERASE_ARG;
>> -		trim_arg = MMC_TRIM_ARG;
>> -	} else {
>> -		erase_arg = MMC_SECURE_ERASE_ARG;
>> -		trim_arg = MMC_SECURE_TRIM1_ARG;
>> -	}
>> -
>> -	if (mmc_erase_group_aligned(card, from, nr))
>> -		arg = erase_arg;
>> -	else if (mmc_can_trim(card))
>> -		arg = trim_arg;
>> -	else {
>> -		err = -EINVAL;
>> -		goto out;
>> -	}
>> +	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
>> +		arg = MMC_SECURE_TRIM1_ARG;
>> +	else
>> +		arg = MMC_SECURE_ERASE_ARG;
>>  retry:
>>  	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
>>  		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> @@ -953,6 +940,46 @@ out:
>>  	return err ? 0 : 1;
>>  }
>>
>> +static int mmc_blk_issue_sanitize_rq(struct mmc_queue *mq,
>> +				      struct request *req)
>> +{
>> +	struct mmc_blk_data *md = mq->data;
>> +	struct mmc_card *card = md->queue.card;
>> +	int err = 0;
>> +
>> +	BUG_ON(!card);
>> +	BUG_ON(!card->host);
>> +
>> +	if (!(mmc_can_sanitize(card) &&
>> +	     (card->host->caps2 & MMC_CAP2_SANITIZE))) {
>> +			pr_warning("%s: %s - SANITIZE is not supported\n",
>> +				   mmc_hostname(card->host), __func__);
>> +			err = -EOPNOTSUPP;
>> +			goto out;
>> +	}
>> +
>> +	pr_debug("%s: %s - SANITIZE IN PROGRESS...\n",
>> +		mmc_hostname(card->host), __func__);
>> +
>> +	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> +					 EXT_CSD_SANITIZE_START, 1, 0);
>> +
>> +	if (err)
>> +		pr_err("%s: %s - mmc_switch() with "
>> +		       "EXT_CSD_SANITIZE_START failed. err=%d\n",
>> +		       mmc_hostname(card->host), __func__, err);
>> +
>> +	pr_debug("%s: %s - SANITIZE COMPLETED\n", mmc_hostname(card->host),
>> +					     __func__);
>> +
>> +out:
>> +	spin_lock_irq(&md->lock);
>> +	__blk_end_request(req, err, blk_rq_bytes(req));
>> +	spin_unlock_irq(&md->lock);
>> +
>> +	return err ? 0 : 1;
>> +}
>> +
>>  static int mmc_blk_issue_flush(struct mmc_queue *mq, struct request
>> *req)
>>  {
>>  	struct mmc_blk_data *md = mq->data;
>> @@ -1437,7 +1464,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
>> struct request *req)
>>  		goto out;
>>  	}
>>
>> -	if (req && req->cmd_flags & REQ_DISCARD) {
>> +	if (req && req->cmd_flags & REQ_SANITIZE) {
>> +		/* complete ongoing async transfer before issuing sanitize */
>> +		if (card->host && card->host->areq)
>> +			mmc_blk_issue_rw_rq(mq, NULL);
>> +		ret = mmc_blk_issue_sanitize_rq(mq, req);
>> +	} else if (req && req->cmd_flags & REQ_DISCARD) {
>>  		/* complete ongoing async transfer before issuing discard */
>>  		if (card->host->areq)
>>  			mmc_blk_issue_rw_rq(mq, NULL);
>> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
>> index e360a97..4f3250e 100644
>> --- a/drivers/mmc/card/queue.c
>> +++ b/drivers/mmc/card/queue.c
>> @@ -145,10 +145,15 @@ static void mmc_queue_setup_discard(struct
>> request_queue *q,
>>  	/* granularity must not be greater than max. discard */
>>  	if (card->pref_erase > max_discard)
>>  		q->limits.discard_granularity = 0;
>> -	if (mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))
>> +	if (mmc_can_secure_erase_trim(card))
>>  		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
>>  }
>>
>> +static void mmc_queue_setup_sanitize(struct request_queue *q)
>> +{
>> +	queue_flag_set_unlocked(QUEUE_FLAG_SANITIZE, q);
>> +}
>> +
>>  /**
>>   * mmc_init_queue - initialise a queue structure.
>>   * @mq: mmc queue
>> @@ -184,6 +189,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct
>> mmc_card *card,
>>  	if (mmc_can_erase(card))
>>  		mmc_queue_setup_discard(mq->queue, card);
>>
>> +	if ((mmc_can_sanitize(card) && (host->caps2 & MMC_CAP2_SANITIZE)))
>> +		mmc_queue_setup_sanitize(mq->queue);
>> +
>>  #ifdef CONFIG_MMC_BLOCK_BOUNCE
>>  	if (host->max_segs == 1) {
>>  		unsigned int bouncesz;
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index 0707d22..be2b89f 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -238,6 +238,7 @@ struct mmc_host {
>>  #define MMC_CAP2_BROKEN_VOLTAGE	(1 << 7)	/* Use the broken voltage */
>>  #define MMC_CAP2_DETECT_ON_ERR	(1 << 8)	/* On I/O err check card
>> removal
>> */
>>  #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
>> +#define MMC_CAP2_SANITIZE	(1 << 10)		/* Support Sanitize */
>>
>>  	mmc_pm_flag_t		pm_caps;	/* supported pm features */
>>  	unsigned int        power_notify_type;
>> --
>> 1.7.6
>> --
>> Sent by a consultant of the Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Sent by consultant of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Yaniv Gardi
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum


