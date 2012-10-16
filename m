Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2JPHy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:54:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20895 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2JPHyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:54:24 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-7e-507d12ae55f7
Message-id: <507D1295.5000908@samsung.com>
Date: Tue, 16 Oct 2012 16:53:57 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-version: 1.0
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mmc: core: Add support for idle time BKOPS
References: <n@samsung.com>
 <1349389748-815-1-git-send-email-merez@codeaurora.org>
In-reply-to: <1349389748-815-1-git-send-email-merez@codeaurora.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd11QrUBBhvX8VpM3H+W3eLyrjls
	Fkf+9zM6MHt83iQXwBjFZZOSmpNZllqkb5fAlXHudWrBouKKN3d/MTcw7o7qYuTkkBAwkZix
	dDkrhC0mceHeerYuRi4OIYFFjBIzpq5ghXBeMko8/NPFBFLFK6AlceD6NDCbRUBVYvnMCywg
	NpuAjsT2b8fB4qICIRJL5n5lh6gXlPgx+R5YjYiAisT260+YQIYyC0xilNix5S9Yg7CAk8Tn
	kxvBioSAmv8f3MwIYnMKOEvM//yWDcRmBlqwv3UalC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw/KZ1A7GlQ0WhxgFOBiVeHgznGsChFgTy4or
	cw8xSnAwK4nwekwECvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJEBJITyxJzU5NLUgtgsky
	cXBKNTAeCj0fVq/0eo+rsPDWyKMrds7TOOD4V5zz6jf7Qr1l6Tu+nBF/9PLAjW0X7qV7R3z+
	1/3t6a76letL4zkco/uFb6v3x+puEVlkmTn193VjBfbFrwRVp3ytv71hreO3c8V9JR2TuJQa
	WoqXsNQ3flZ06349n7lUnqF/wcIMCZ8TRY2Jz45yBvApsRRnJBpqMRcVJwIAOqmnEkcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maya,

I'm testing with your patch..but i need to have the more time for testing.
In now, it looks good to me. Thank you for working the idle bkops.

Best Regards,
Jaehoon Chung

> ---
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 172a768..ed040d5 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -827,6 +827,9 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
>  	from = blk_rq_pos(req);
>  	nr = blk_rq_sectors(req);
>  
> +	if (card->ext_csd.bkops_en)
> +		card->bkops_info.sectors_changed += blk_rq_sectors(req);
using nr?
> +
>  	if (mmc_can_discard(card))
>  		arg = MMC_DISCARD_ARG;
>  	else if (mmc_can_trim(card))
> @@ -1268,6 +1271,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
>  	if (!rqc && !mq->mqrq_prev->req)
>  		return 0;
>  
> +	if (rqc && (card->ext_csd.bkops_en) && (rq_data_dir(rqc) == WRITE))
> +			card->bkops_info.sectors_changed += blk_rq_sectors(rqc);
Fix the indent.
> +
>  	do {
>  		if (rqc) {
>  			/*
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index e360a97..e96f5cf 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -51,6 +51,7 @@ static int mmc_queue_thread(void *d)
>  {
>  	struct mmc_queue *mq = d;
>  	struct request_queue *q = mq->queue;
> +	struct mmc_card *card = mq->card;
>  
>  	current->flags |= PF_MEMALLOC;
>  
> @@ -66,6 +67,17 @@ static int mmc_queue_thread(void *d)
>  		spin_unlock_irq(q->queue_lock);
>  
>  		if (req || mq->mqrq_prev->req) {
> +			/*
> +			 * If this is the first request, BKOPs might be in
> +			 * progress and needs to be stopped before issuing the
> +			 * request
> +			 */
> +			if (card->ext_csd.bkops_en &&
> +			    card->bkops_info.started_delayed_bkops) {
> +				card->bkops_info.started_delayed_bkops = false;
> +				mmc_stop_bkops(card);
if mmc_stop_bkops is failed..?
> +			}
> +
>  			set_current_state(TASK_RUNNING);
>  			mq->issue_fn(mq, req);
>  		} else {
> @@ -73,6 +85,7 @@ static int mmc_queue_thread(void *d)
>  				set_current_state(TASK_RUNNING);
>  				break;
>  			}
> +			mmc_start_delayed_bkops(card);
>  			up(&mq->thread_sem);
>  			schedule();
>  			down(&mq->thread_sem);
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6612163..fd8783d 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -253,9 +253,42 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>  }
>  
>  /**
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
>   *	mmc_start_bkops - start BKOPS for supported cards
>   *	@card: MMC card to start BKOPS
> - *	@form_exception: A flag to indicate if this function was
> + *	@from_exception: A flag to indicate if this function was
>   *			 called due to an exception raised by the card
>   *
>   *	Start background operations whenever requested.
> @@ -269,25 +302,47 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
>  	bool use_busy_signal;
>  
>  	BUG_ON(!card);
> -
> -	if (!card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
> +	if (!card->ext_csd.bkops_en)
>  		return;
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
>  	err = mmc_read_bkops_status(card);
>  	if (err) {
>  		pr_err("%s: Failed to read bkops status: %d\n",
>  		       mmc_hostname(card->host), err);
> -		return;
> +		goto out;
>  	}
>  
>  	if (!card->ext_csd.raw_bkops_status)
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
>  	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
>  	    from_exception)
> -		return;
> +		goto out;
>  
> -	mmc_claim_host(card->host);
>  	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
>  		timeout = MMC_BKOPS_MAX_TIMEOUT;
>  		use_busy_signal = true;
> @@ -309,13 +364,108 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
>  	 * bkops executed synchronously, otherwise
>  	 * the operation is in progress
>  	 */
> -	if (!use_busy_signal)
> +	if (!use_busy_signal) {
>  		mmc_card_set_doing_bkops(card);
> +		pr_debug("%s: %s: starting the polling thread\n",
> +			 mmc_hostname(card->host), __func__);
> +		queue_work(system_nrt_wq,
> +			   &card->bkops_info.poll_for_completion);
> +	}
> +
>  out:
>  	mmc_release_host(card->host);
>  }
>  EXPORT_SYMBOL(mmc_start_bkops);
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
>  static void mmc_wait_done(struct mmc_request *mrq)
>  {
>  	complete(&mrq->completion);
> @@ -582,6 +732,19 @@ int mmc_stop_bkops(struct mmc_card *card)
>  	int err = 0;
>  
>  	BUG_ON(!card);
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
>  	err = mmc_interrupt_hpi(card);
>  
>  	/*
> @@ -593,6 +756,8 @@ int mmc_stop_bkops(struct mmc_card *card)
>  		err = 0;
>  	}
>  
> +out:
> +	mmc_release_host(card->host);
>  	return err;
>  }
>  EXPORT_SYMBOL(mmc_stop_bkops);
> @@ -2566,15 +2731,13 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>  	switch (mode) {
>  	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
> -		if (host->card && mmc_card_mmc(host->card) &&
> -		    mmc_card_doing_bkops(host->card)) {
> +		if (host->card && mmc_card_mmc(host->card)) {
>  			err = mmc_stop_bkops(host->card);
>  			if (err) {
>  				pr_err("%s: didn't stop bkops\n",
>  					mmc_hostname(host));
>  				return err;
>  			}
> -			mmc_card_clr_doing_bkops(host->card);
>  		}
>  
>  		spin_lock_irqsave(&host->lock, flags);
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 7509de1..f8ff640 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -1258,6 +1258,30 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>  		}
>  	}
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
>  	if (!oldcard)
>  		host->card = card;
>  
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 78cc3be..0e4d55a 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -207,6 +207,48 @@ struct mmc_part {
>  #define MMC_BLK_DATA_AREA_GP	(1<<2)
>  };
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
>  /*
>   * MMC device
>   */
> @@ -281,6 +323,8 @@ struct mmc_card {
>  	struct dentry		*debugfs_root;
>  	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
>  	unsigned int    nr_parts;
> +
> +	struct mmc_bkops_info	bkops_info;
>  };
>  
>  /*
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 9b9cdaf..665d345 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -145,6 +145,9 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
>  extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
>  	struct mmc_command *, int);
>  extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
> +extern void mmc_start_delayed_bkops(struct mmc_card *card);
> +extern void mmc_start_idle_time_bkops(struct work_struct *work);
> +extern void mmc_bkops_completion_polling(struct work_struct *work);
>  extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
>  extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
>  
> 

