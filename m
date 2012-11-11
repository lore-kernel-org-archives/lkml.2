Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2KKJZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 04:25:35 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14842 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2KKJZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 04:25:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6892"; a="5844451"
Message-ID: <509F6EF5.2070009@codeaurora.org>
Date: Sun, 11 Nov 2012 14:55:09 +0530
From: Subhash Jadavani <subhashj@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Maya Erez <merez@codeaurora.org>
CC: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mmc: core: Add support for idle time BKOPS
References: <n> <1349389748-815-1-git-send-email-merez@codeaurora.org>
In-Reply-To: <1349389748-815-1-git-send-email-merez@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Maya. Looks good to me.
Reviewed-by: subhashj@codeaurora.org

Regards,
Subhash

On 10/5/2012 3:58 AM, Maya Erez wrote:
> Devices have various maintenance operations need to perform internally.
> In order to reduce latencies during time critical operations like read
> and write, it is better to execute maintenance operations in other
> times - when the host is not being serviced. Such operations are called
> Background operations (BKOPS).
> The device notifies the status of the BKOPS need by updating BKOPS_STATUS
> (EXT_CSD byte [246]).
>
> According to the standard a host that supports BKOPS shall check the
> status periodically and start background operations as needed, so that
> the device has enough time for its maintenance operations.
>
> This patch adds support for this periodic check of the BKOPS status.
> Since foreground operations are of higher priority than background
> operations the host will check the need for BKOPS when it is idle,
> and in case of an incoming request the BKOPS operation will be
> interrupted.
>
> When the mmcqd thread is idle, a delayed work is created to check the
> need for BKOPS. The time to start the delayed work is calculated based
> on the host controller suspend timeout, in case it was set. If not, a
> default time is used.
> If BKOPS are required in level 1, which is non-blocking, there will be
> polling of the card status to wait for the BKOPS completion and prevent
> suspend that will interrupt the BKOPS.
> If the card raised an exception, the need for urgent BKOPS (level 2/3)
> will be checked immediately and if needed, the BKOPS will be performed
> without waiting for the next idle time.
>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> ---
> This patch is based on the periodic BKOPS implementation in version 8 of "support BKOPS feature for eMMC" patch.
> The patch was modified to answer the following issues:
> - In order to prevent a race condition between going into suspend and starting BKOPS,
>    the suspend timeout of the host controller is taking into accound in determination of the start time
>    of the delayed work
> - Since mmc_start_bkops is called from two contexts now, mmc_claim_host was moved to the beginning of the function
> - Also, the check of doing_bkops should be protected when determing if an HPI is needed due to the same reason.
> - Starting and canceling the delayed work in each idle caused degradation of iozone performance. Therefore,
>    the delayed work is not started on each idle. The amount of sectors changed (written or discard) from the last
>    delayed work is the trigger for starting the delayed BKOPS work.
> ---
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 172a768..ed040d5 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -827,6 +827,9 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
>   	from = blk_rq_pos(req);
>   	nr = blk_rq_sectors(req);
>   
> +	if (card->ext_csd.bkops_en)
> +		card->bkops_info.sectors_changed += blk_rq_sectors(req);
> +
>   	if (mmc_can_discard(card))
>   		arg = MMC_DISCARD_ARG;
>   	else if (mmc_can_trim(card))
> @@ -1268,6 +1271,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
>   	if (!rqc && !mq->mqrq_prev->req)
>   		return 0;
>   
> +	if (rqc && (card->ext_csd.bkops_en) && (rq_data_dir(rqc) == WRITE))
> +			card->bkops_info.sectors_changed += blk_rq_sectors(rqc);
> +
>   	do {
>   		if (rqc) {
>   			/*
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index e360a97..e96f5cf 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -51,6 +51,7 @@ static int mmc_queue_thread(void *d)
>   {
>   	struct mmc_queue *mq = d;
>   	struct request_queue *q = mq->queue;
> +	struct mmc_card *card = mq->card;
>   
>   	current->flags |= PF_MEMALLOC;
>   
> @@ -66,6 +67,17 @@ static int mmc_queue_thread(void *d)
>   		spin_unlock_irq(q->queue_lock);
>   
>   		if (req || mq->mqrq_prev->req) {
> +			/*
> +			 * If this is the first request, BKOPs might be in
> +			 * progress and needs to be stopped before issuing the
> +			 * request
> +			 */
> +			if (card->ext_csd.bkops_en &&
> +			    card->bkops_info.started_delayed_bkops) {
> +				card->bkops_info.started_delayed_bkops = false;
> +				mmc_stop_bkops(card);
> +			}
> +
>   			set_current_state(TASK_RUNNING);
>   			mq->issue_fn(mq, req);
>   		} else {
> @@ -73,6 +85,7 @@ static int mmc_queue_thread(void *d)
>   				set_current_state(TASK_RUNNING);
>   				break;
>   			}
> +			mmc_start_delayed_bkops(card);
>   			up(&mq->thread_sem);
>   			schedule();
>   			down(&mq->thread_sem);
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6612163..fd8783d 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -253,9 +253,42 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>   }
>   
>   /**
> + * mmc_start_delayed_bkops() - Start a delayed work to check for
> + *      the need of non urgent BKOPS
> + *
> + * @card: MMC card to start BKOPS on
> + */
> +void mmc_start_delayed_bkops(struct mmc_card *card)
> +{
> +	if (!card || !card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
> +		return;
> +
> +	if (card->bkops_info.sectors_changed <
> +	    BKOPS_MIN_SECTORS_TO_QUEUE_DELAYED_WORK)
> +		return;
> +
> +	pr_debug("%s: %s: queueing delayed_bkops_work\n",
> +		 mmc_hostname(card->host), __func__);
> +
> +	card->bkops_info.sectors_changed = 0;
> +
> +	/*
> +	 * cancel_delayed_bkops_work will prevent a race condition between
> +	 * fetching a request by the mmcqd and the delayed work, in case
> +	 * it was removed from the queue work but not started yet
> +	 */
> +	card->bkops_info.cancel_delayed_work = false;
> +	card->bkops_info.started_delayed_bkops = true;
> +	queue_delayed_work(system_nrt_wq, &card->bkops_info.dw,
> +			   msecs_to_jiffies(
> +				   card->bkops_info.delay_ms));
> +}
> +EXPORT_SYMBOL(mmc_start_delayed_bkops);
> +
> +/**
>    *	mmc_start_bkops - start BKOPS for supported cards
>    *	@card: MMC card to start BKOPS
> - *	@form_exception: A flag to indicate if this function was
> + *	@from_exception: A flag to indicate if this function was
>    *			 called due to an exception raised by the card
>    *
>    *	Start background operations whenever requested.
> @@ -269,25 +302,47 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
>   	bool use_busy_signal;
>   
>   	BUG_ON(!card);
> -
> -	if (!card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
> +	if (!card->ext_csd.bkops_en)
>   		return;
>   
> +	mmc_claim_host(card->host);
> +
> +	if ((card->bkops_info.cancel_delayed_work) && !from_exception) {
> +		pr_debug("%s: %s: cancel_delayed_work was set, exit\n",
> +			 mmc_hostname(card->host), __func__);
> +		card->bkops_info.cancel_delayed_work = false;
> +		goto out;
> +	}
> +
> +	if (mmc_card_doing_bkops(card)) {
> +		pr_debug("%s: %s: already doing bkops, exit\n",
> +			 mmc_hostname(card->host), __func__);
> +		goto out;
> +	}
> +
>   	err = mmc_read_bkops_status(card);
>   	if (err) {
>   		pr_err("%s: Failed to read bkops status: %d\n",
>   		       mmc_hostname(card->host), err);
> -		return;
> +		goto out;
>   	}
>   
>   	if (!card->ext_csd.raw_bkops_status)
> -		return;
> +		goto out;
> +
> +	pr_info("%s: %s: card->ext_csd.raw_bkops_status = 0x%x\n",
> +		mmc_hostname(card->host), __func__,
> +		card->ext_csd.raw_bkops_status);
>   
> +	/*
> +	 * If the function was called due to exception but there is no need
> +	 * for urgent BKOPS, BKOPs will be performed by the delayed BKOPs
> +	 * work, before going to suspend
> +	 */
>   	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
>   	    from_exception)
> -		return;
> +		goto out;
>   
> -	mmc_claim_host(card->host);
>   	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
>   		timeout = MMC_BKOPS_MAX_TIMEOUT;
>   		use_busy_signal = true;
> @@ -309,13 +364,108 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
>   	 * bkops executed synchronously, otherwise
>   	 * the operation is in progress
>   	 */
> -	if (!use_busy_signal)
> +	if (!use_busy_signal) {
>   		mmc_card_set_doing_bkops(card);
> +		pr_debug("%s: %s: starting the polling thread\n",
> +			 mmc_hostname(card->host), __func__);
> +		queue_work(system_nrt_wq,
> +			   &card->bkops_info.poll_for_completion);
> +	}
> +
>   out:
>   	mmc_release_host(card->host);
>   }
>   EXPORT_SYMBOL(mmc_start_bkops);
>   
> +/**
> + * mmc_bkops_completion_polling() - Poll on the card status to
> + * wait for the non-blocking BKOPS completion
> + * @work:	The completion polling work
> + *
> + * The on-going reading of the card status will prevent the card
> + * from getting into suspend while it is in the middle of
> + * performing BKOPS.
> + * Since the non blocking BKOPS can be interrupted by a fetched
> + * request we also check IF mmc_card_doing_bkops in each
> + * iteration.
> + */
> +void mmc_bkops_completion_polling(struct work_struct *work)
> +{
> +	struct mmc_card *card = container_of(work, struct mmc_card,
> +			bkops_info.poll_for_completion);
> +	unsigned long timeout_jiffies = jiffies +
> +		msecs_to_jiffies(BKOPS_COMPLETION_POLLING_TIMEOUT_MS);
> +	u32 status;
> +	int err;
> +
> +	/*
> +	 * Wait for the BKOPs to complete. Keep reading the status to prevent
> +	 * the host from getting into suspend
> +	 */
> +	do {
> +		mmc_claim_host(card->host);
> +
> +		if (!mmc_card_doing_bkops(card))
> +			goto out;
> +
> +		err = mmc_send_status(card, &status);
> +		if (err) {
> +			pr_err("%s: error %d requesting status\n",
> +			       mmc_hostname(card->host), err);
> +			goto out;
> +		}
> +
> +		/*
> +		 * Some cards mishandle the status bits, so make sure to check
> +		 * both the busy indication and the card state.
> +		 */
> +		if ((status & R1_READY_FOR_DATA) &&
> +		    (R1_CURRENT_STATE(status) != R1_STATE_PRG)) {
> +			pr_debug("%s: %s: completed BKOPs, exit polling\n",
> +				 mmc_hostname(card->host), __func__);
> +			mmc_card_clr_doing_bkops(card);
> +			card->bkops_info.started_delayed_bkops = false;
> +			goto out;
> +		}
> +
> +		mmc_release_host(card->host);
> +
> +		/*
> +		 * Sleep before checking the card status again to allow the
> +		 * card to complete the BKOPs operation
> +		 */
> +		msleep(BKOPS_COMPLETION_POLLING_INTERVAL_MS);
> +	} while (time_before(jiffies, timeout_jiffies));
> +
> +	pr_err("%s: %s: exit polling due to timeout\n",
> +	       mmc_hostname(card->host), __func__);
> +
> +	return;
> +out:
> +	mmc_release_host(card->host);
> +}
> +
> +/**
> + * mmc_start_idle_time_bkops() - check if a non urgent BKOPS is
> + * needed
> + * @work:	The idle time BKOPS work
> + */
> +void mmc_start_idle_time_bkops(struct work_struct *work)
> +{
> +	struct mmc_card *card = container_of(work, struct mmc_card,
> +			bkops_info.dw.work);
> +
> +	/*
> +	 * Prevent a race condition between mmc_stop_bkops and the delayed
> +	 * BKOPS work in case the delayed work is executed on another CPU
> +	 */
> +	if (card->bkops_info.cancel_delayed_work)
> +		return;
> +
> +	mmc_start_bkops(card, false);
> +}
> +EXPORT_SYMBOL(mmc_start_idle_time_bkops);
> +
>   static void mmc_wait_done(struct mmc_request *mrq)
>   {
>   	complete(&mrq->completion);
> @@ -582,6 +732,19 @@ int mmc_stop_bkops(struct mmc_card *card)
>   	int err = 0;
>   
>   	BUG_ON(!card);
> +
> +	mmc_claim_host(card->host);
> +
> +	/*
> +	 * Notify the delayed work to be cancelled, in case it was already
> +	 * removed from the queue, but was not started yet
> +	 */
> +	card->bkops_info.cancel_delayed_work = true;
> +	if (delayed_work_pending(&card->bkops_info.dw))
> +		cancel_delayed_work_sync(&card->bkops_info.dw);
> +	if (!mmc_card_doing_bkops(card))
> +		goto out;
> +
>   	err = mmc_interrupt_hpi(card);
>   
>   	/*
> @@ -593,6 +756,8 @@ int mmc_stop_bkops(struct mmc_card *card)
>   		err = 0;
>   	}
>   
> +out:
> +	mmc_release_host(card->host);
>   	return err;
>   }
>   EXPORT_SYMBOL(mmc_stop_bkops);
> @@ -2566,15 +2731,13 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>   	switch (mode) {
>   	case PM_HIBERNATION_PREPARE:
>   	case PM_SUSPEND_PREPARE:
> -		if (host->card && mmc_card_mmc(host->card) &&
> -		    mmc_card_doing_bkops(host->card)) {
> +		if (host->card && mmc_card_mmc(host->card)) {
>   			err = mmc_stop_bkops(host->card);
>   			if (err) {
>   				pr_err("%s: didn't stop bkops\n",
>   					mmc_hostname(host));
>   				return err;
>   			}
> -			mmc_card_clr_doing_bkops(host->card);
>   		}
>   
>   		spin_lock_irqsave(&host->lock, flags);
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 7509de1..f8ff640 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -1258,6 +1258,30 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>   		}
>   	}
>   
> +	if (!oldcard) {
> +		if (card->ext_csd.bkops_en) {
> +			INIT_DELAYED_WORK(&card->bkops_info.dw,
> +					  mmc_start_idle_time_bkops);
> +			INIT_WORK(&card->bkops_info.poll_for_completion,
> +				  mmc_bkops_completion_polling);
> +
> +			/*
> +			 * Calculate the time to start the BKOPs checking.
> +			 * The idle time of the host controller should be taken
> +			 * into account in order to prevent a race condition
> +			 * before starting BKOPs and going into suspend.
> +			 * If the host controller didn't set its idle time,
> +			 * a default value is used.
> +			 */
> +			card->bkops_info.delay_ms = MMC_IDLE_BKOPS_TIME_MS;
> +			if (card->bkops_info.host_suspend_tout_ms)
> +				card->bkops_info.delay_ms = min(
> +					card->bkops_info.delay_ms,
> +				      card->bkops_info.host_suspend_tout_ms/2);
> +
> +		}
> +	}
> +
>   	if (!oldcard)
>   		host->card = card;
>   
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 78cc3be..0e4d55a 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -207,6 +207,48 @@ struct mmc_part {
>   #define MMC_BLK_DATA_AREA_GP	(1<<2)
>   };
>   
> +/**
> + * struct mmc_bkops_info - BKOPS data
> + * @dw:	Idle time bkops delayed work
> + * @host_suspend_tout_ms:	The host controller idle time,
> + * before getting into suspend
> + * @delay_ms:	The time to start the BKOPS
> + *        delayed work once MMC thread is idle
> + * @poll_for_completion:	Poll on BKOPS completion
> + * @cancel_delayed_work: A flag to indicate if the delayed work
> + *        should be cancelled
> + * @started_delayed_bkops:  A flag to indicate if the delayed
> + *        work was scheduled
> + * @sectors_changed:  number of  sectors written or
> + *       discard since the last idle BKOPS were scheduled
> + */
> +struct mmc_bkops_info {
> +	struct delayed_work	dw;
> +	unsigned int		host_suspend_tout_ms;
> +	unsigned int		delay_ms;
> +/*
> + * A default time for checking the need for non urgent BKOPS once mmcqd
> + * is idle.
> + */
> +#define MMC_IDLE_BKOPS_TIME_MS 2000
> +	struct work_struct	poll_for_completion;
> +/* Polling timeout and interval for waiting on non-blocking BKOPs completion */
> +#define BKOPS_COMPLETION_POLLING_TIMEOUT_MS 10000 /* in ms */
> +#define BKOPS_COMPLETION_POLLING_INTERVAL_MS 1000 /* in ms */
> +	bool			cancel_delayed_work;
> +	bool			started_delayed_bkops;
> +	unsigned int		sectors_changed;
> +/*
> + * Since canceling the delayed work might have significant effect on the
> + * performance of small requests we won't queue the delayed work every time
> + * mmcqd thread is idle.
> + * The delayed work for idle BKOPS will be scheduled only after a significant
> + * amount of write or discard data.
> + * 100MB is chosen based on benchmark tests.
> + */
> +#define BKOPS_MIN_SECTORS_TO_QUEUE_DELAYED_WORK 204800 /* 100MB */
> +};
> +
>   /*
>    * MMC device
>    */
> @@ -281,6 +323,8 @@ struct mmc_card {
>   	struct dentry		*debugfs_root;
>   	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
>   	unsigned int    nr_parts;
> +
> +	struct mmc_bkops_info	bkops_info;
>   };
>   
>   /*
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 9b9cdaf..665d345 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -145,6 +145,9 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
>   extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
>   	struct mmc_command *, int);
>   extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
> +extern void mmc_start_delayed_bkops(struct mmc_card *card);
> +extern void mmc_start_idle_time_bkops(struct work_struct *work);
> +extern void mmc_bkops_completion_polling(struct work_struct *work);
>   extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
>   extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
>   

