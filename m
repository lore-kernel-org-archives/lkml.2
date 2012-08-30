Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2H3HhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 03:37:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39771 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2H3HhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 03:37:00 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-b4-503f181a18f9
Message-id: <503F1813.2010900@samsung.com>
Date: Thu, 30 Aug 2012 16:36:51 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: Maya Erez <merez@codeaurora.org>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] mmc: core: Add support for idle time BKOPs
References: <n@samsung.com>
 <1344172153-5800-1-git-send-email-merez@codeaurora.org>
In-reply-to: <1344172153-5800-1-git-send-email-merez@codeaurora.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQV1pCfsAg29z2Cwm7j/LbnF5F5B1
	5H8/owOzx+dNcgGMUVw2Kak5mWWpRfp2CVwZzeu2Mhc8b2es+HWkmaWBsTOni5GTQ0LARGLS
	xYcsELaYxIV769m6GLk4hASmM0ocf/KcCcJ5yShx73k7K0gVr4CWxPRFX5lAbBYBVYnnW7+C
	xdkEdCS2fzsOFhcVCJG4vmcDI0S9oMSPyffANogIqEhsv/4EbCizwCJGiX9X3jCDJIQFnCUu
	tV0AaxASCJXYtPgj2FBOAReJDy1vwWqYgRbsb53GBmHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj
	8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4NB8JrWDcWWDxSFGAQ5GJR5ejky7ACHWxLLi
	ytxDjBIczEoivOz89gFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZ3OAVULpCeWpGanphakFsFk
	mTg4pRoY927xuRb+b4XVtxNNhm7RUiuUPIUWC2t2ROfqJDKWc+0VcmxZHCd1fnPciw21/mcc
	28ucW1JfNnzZ5HV5U2/uxPrIQ17sOttmcgaK18WHF0yzO3a8c+3EY3uzZ2wzPPggrDrvUNji
	hWe028Re127msbdseM+cF+Oj6MfSdEpB9E+XwdnZp94rsRRnJBpqMRcVJwIAS/waQ0kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 10:08 PM, Maya Erez wrote:
> When the mmcqd thread is idle, a delayed work is created to check the
> need for BKOPs. The time to start the delayed work is calculated based
> on the host controller suspend timeout, in case it was set. If not, a
> default time is used.
> If BKOPs is required in level 1, which is non-blocking, there will be
> polling of the card status to wait for the BKOPs completion and prevent
> suspend that will interrupt the BKOPs.
> If the card raised an exception, the need for urgent BKOPs (level 2/3)
> will be checked immediately and if needed, the BKOPs will be performed
> without waiting for the next idle time.
> 
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> ---
> This patch depends on the following patch:
>   [PATCH v11] mmc: support BKOPS feature for eMMC
> 
> This patch is based on the periodic BKOPs implementation in version 8 of "support BKOPS feature for eMMC" patch.
> The patch was modified to answer the following issues:
> - In order to prevent a race condition between going into suspend and starting BKOPs, 
>   the suspend timeout of the host controller is taking into accound in determination of the start time 
>   of the delayed work
> - Since mmc_start_bkops is called from two contexts now, mmc_claim_host was moved to the beginning of the function
> - Also, the check of doing_bkops should be protected when determing if an HPI is needed due to the same reason.
> - Starting and canceling the delayed work in each idle caused degradation of iozone performance. Therefore,
>   the delayed work is not started on each idle. Currently the number of issued requests from the last delayed work 
>   is the trigger. We still investigate the best trigger for starting the delayed work.
> - To prevent degaradtion of iozone performance we also moved the call to mmc_claim_host outside of mmc_stop_bkops  
>   and its release is done after issue_fn. This prevents an addition of a full claim and release, that is also done 
>   in issue_fn for the first request after idle time.
> ---
>  drivers/mmc/card/block.c |    3 +
>  drivers/mmc/card/queue.c |   20 +++++
>  drivers/mmc/core/core.c  |  188 +++++++++++++++++++++++++++++++++++++++++++---
>  drivers/mmc/core/host.c  |   24 ++++++
>  include/linux/mmc/card.h |    3 +
>  include/linux/mmc/core.h |    3 +
>  include/linux/mmc/host.h |   25 ++++++
>  7 files changed, 256 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index f1c84de..4519271 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -1268,6 +1268,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
>  	if (!rqc && !mq->mqrq_prev->req)
>  		return 0;
>  
> +	if (rqc)
> +		card->idle_bkops_rw_reqs_nr++;
> +
>  	do {
>  		if (rqc) {
>  			/*
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index e360a97..c9e1cee 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -51,6 +51,7 @@ static int mmc_queue_thread(void *d)
>  {
>  	struct mmc_queue *mq = d;
>  	struct request_queue *q = mq->queue;
> +	bool release_host = false;
>  
>  	current->flags |= PF_MEMALLOC;
>  
> @@ -66,13 +67,32 @@ static int mmc_queue_thread(void *d)
>  		spin_unlock_irq(q->queue_lock);
>  
>  		if (req || mq->mqrq_prev->req) {
> +			/*
> +			 * If this is the first request, BKOPs might be in
> +			 * progress and needs to be stopped before issuing the
> +			 * request
> +			 * */
> +			if (!mq->mqrq_prev->req &&
> +			    mq->card->ext_csd.bkops_en &&
> +			    mq->card->idle_bkops_rw_reqs_nr == 0) {
> +				release_host = true;
> +				mmc_claim_host(mq->card->host);
> +				mmc_stop_bkops(mq->card);
> +			}
> +
>  			set_current_state(TASK_RUNNING);
>  			mq->issue_fn(mq, req);
> +			if (release_host) {
> +				release_host = false;
> +				mmc_release_host(mq->card->host);
> +			}
>  		} else {
>  			if (kthread_should_stop()) {
>  				set_current_state(TASK_RUNNING);
>  				break;
>  			}
> +
> +			mmc_start_delayed_bkops(mq->card);
>  			up(&mq->thread_sem);
>  			schedule();
>  			down(&mq->thread_sem);
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index ed2cc93..14830d4 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -46,6 +46,15 @@
>   * operations the card has to perform
>   */
>  #define MMC_BKOPS_MAX_TIMEOUT	(4 * 60 * 1000) /* max time to wait in ms */
> +/* Polling timeout and interval for waiting on non-blocking BKOPs completion */
> +#define BKOPS_COMPLETION_POLLING_TIMEOUT 10000 /* in ms */
> +#define BKOPS_COMPLETION_POLLING_INTERVAL 1000 /* in ms */
> +/*
> + * Since canceling the delayed work might have significant effect on the
> + * performance of small requests we won't queue the delayed work every time
> + * mmcqd thread is idle
> + */
> +#define BKOPS_MIN_REQS_TO_QUEUE_DELAYED_WORK 1000
How did you get the minimum request number "1000"?
Is this tunable value?
>  
>  static struct workqueue_struct *workqueue;
>  static const unsigned freqs[] = { 400000, 300000, 200000, 100000 };
> @@ -252,6 +261,37 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>  }
>  
>  /**
> + *      mmc_start_delayed_bkops() - Start a delayed work to check for the need
> + *      of non urgent BKOPs
> + *
> + *      @card: MMC card to start BKOPS
> + */
> +void mmc_start_delayed_bkops(struct mmc_card *card)
> +{
> +	if (!card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
> +		return;
if mmc_card_doing_bkops or didn't support bkops, idle_bkops_rw_reqs_nr need to reset?
> +
> +	if (card->idle_bkops_rw_reqs_nr < BKOPS_MIN_REQS_TO_QUEUE_DELAYED_WORK)
> +		return;
> +
> +	pr_debug("%s: %s: queueing delayed_bkops_work", __func__,
> +		 mmc_hostname(card->host));
missed "\n"..almost missed the new line("\n") at pr_debug.
> +
> +	card->idle_bkops_rw_reqs_nr = 0;
> +
> +	/*
> +	 * cancel_delayed_bkops_work will prevent a race condition between
> +	 * fetching a request by the queue_thread and the delayed work
> +	 */
> +	card->host->bkops_info.cancel_delayed_work = false;
> +	queue_delayed_work(card->host->bkops_info. wq,
> +			   &card->host->bkops_info.idle_time_dw,
> +		   msecs_to_jiffies(
> +			   card->host->bkops_info.time_to_start_bkops_ms));
> +}
> +EXPORT_SYMBOL(mmc_start_delayed_bkops);
> +
> +/**
>   *	mmc_start_bkops - start BKOPS for supported cards
>   *	@card: MMC card to start BKOPS
>   *	@form_exception: A flags to indicate if this function was
> @@ -268,23 +308,47 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
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
> +	if ((card->host->bkops_info.cancel_delayed_work) && !from_exception) {
> +		pr_debug("%s: %s: cancel_delayed_work was set, exit",
> +			 __func__, mmc_hostname(card->host));
> +		card->host->bkops_info.cancel_delayed_work = false;
> +		goto out;
> +	}
> +
> +	if (mmc_card_doing_bkops(card)) {
> +		pr_debug("%s: %s: already doing bkops, exit", __func__,
> +			 mmc_hostname(card->host));
> +		goto out;
> +	}
> +
>  	err = mmc_read_bkops_status(card);
>  	if (err) {
> -		pr_err("%s: Didn't read bkops status : %d\n",
> +		pr_err("%s: Error %d while reading bkops status\n",
>  		       mmc_hostname(card->host), err);
> -		return;
> +		goto out;
>  	}
> -
>  	if (!card->ext_csd.raw_bkops_status)
> -		return;
> +		goto out;
>  
> -	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2
> -	    && (from_exception))
> -		return;
> +	pr_info("%s: %s: card->ext_csd.raw_bkops_status = %d", __func__,
> +		mmc_hostname(card->host), card->ext_csd.raw_bkops_status);
> +
> +	/*
> +	 * If the function was called due to exception but there is no need
> +	 * for urgent BKOPs, BKOPs will be performed by the delayed BKOPs
> +	 * work, before going to suspend
> +	 */
> +	if ((card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2)
> +	    && (from_exception)) {
> +		pr_debug("%s: %s: Level 1 from exception, exit", __func__,
> +			 mmc_hostname(card->host));
> +		goto out;
> +	}
>  
>  	mmc_claim_host(card->host);
>  	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
> @@ -308,13 +372,101 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
>  	 * bkops executed synchronously, otherwise
>  	 * the operation is in progress
>  	 */
> -	if (!use_busy_signal)
> +	if (!use_busy_signal) {
>  		mmc_card_set_doing_bkops(card);
> +		pr_debug("%s: %s: starting the polling thread", __func__,
> +			 mmc_hostname(card->host));
> +		card->host->bkops_info.exit_wait_on_completion = false;
> +		queue_work(system_nrt_wq,
> +			   &card->host->bkops_info.completion_polling);
> +	}
>  out:
>  	mmc_release_host(card->host);
> +
>  }
>  EXPORT_SYMBOL(mmc_start_bkops);
>  
> +/**
> + * mmc_bkops_completion_polling() - Poll on the card status to
> + * wait for the non-blocking BKOPs completion
> + * @work:	The completion polling work
> + *
> + * The on-going reading of the card status will prevent the card
> + * from getting into suspend while it is in the middle of
> + * performing BKOPs.
> + * Since the non blocking BKOPs can be interrupted by a fetched
> + * request we also check exit_wait_on_completion.
> + */
> +void mmc_bkops_completion_polling(struct work_struct *work)
> +{
> +	struct mmc_host *host = container_of(work, struct mmc_host,
> +			bkops_info.completion_polling);
> +	unsigned long timeout_jiffies = jiffies +
> +		msecs_to_jiffies(BKOPS_COMPLETION_POLLING_TIMEOUT);
> +	u32 status;
> +	int err;
> +
> +	/*
> +	 * Wait for the BKOPs to complete. Keep reading the status to prevent
> +	 * the host from getting into suspend
> +	 */
> +	do {
> +		mmc_claim_host(host);
> +
> +		if (host->bkops_info.exit_wait_on_completion ||
> +			(!mmc_card_doing_bkops(host->card))) {
> +			goto out;
> +		}
> +
> +		err = mmc_send_status(host->card, &status);
> +		if (err) {
> +			pr_err("%s: error %d requesting status\n",
> +			       mmc_hostname(host), err);
> +			goto out;
> +		}
> +
> +		/*
> +		 * Some cards mishandle the status bits, so make sure to check
> +		 * both the busy indication and the card state.
> +		 */
> +		if ((status & R1_READY_FOR_DATA) &&
> +		    (R1_CURRENT_STATE(status) != R1_STATE_PRG)) {
> +			pr_debug("%s: completed BKOPs, exit polling", __func__);
missing "..\n". other pr_debug also missed.
> +			mmc_card_clr_doing_bkops(host->card);
> +			goto out;
> +		}
> +
> +		mmc_release_host(host);
> +
> +		/*
> +		 * Sleep before checking the card status again to allow the
> +		 * card to complete the BKOPs operation
> +		 */
> +		msleep(BKOPS_COMPLETION_POLLING_INTERVAL);
> +	} while (time_before(jiffies, timeout_jiffies));
> +
> +	pr_debug("%s: exit polling due to timeout", __func__);
> +
> +	return;
> +out:
> +	mmc_release_host(host);
> +}
> +
> +/**
> + * mmc_start_idle_time_bkops() - check if a non urgent BKOPs is
> + * needed
> + * @work:	The idle time BKOPs work
> + */
> +void mmc_start_idle_time_bkops(struct work_struct *work)
> +{
> +	struct mmc_host *host = container_of(work, struct mmc_host,
> +			bkops_info.idle_time_dw.work);
> +
> +	mmc_start_bkops(host->card, false);
> +
> +}
> +EXPORT_SYMBOL(mmc_start_idle_time_bkops);
> +
>  static void mmc_wait_done(struct mmc_request *mrq)
>  {
>  	complete(&mrq->completion);
> @@ -574,12 +726,28 @@ EXPORT_SYMBOL(mmc_wait_for_cmd);
>   *	to allow rapid servicing of foreground operations,e.g. read/
>   *	writes. Wait until the card comes out of the programming state
>   *	to avoid errors in servicing read/write requests.
> + *
> + *      This function should be called when the host is claimed
>   */
>  int mmc_stop_bkops(struct mmc_card *card)
>  {
>  	int err = 0;
>  
>  	BUG_ON(!card);
> +
> +	if (delayed_work_pending(&card->host->bkops_info.idle_time_dw))
> +		cancel_delayed_work_sync(&card->host->bkops_info.idle_time_dw);
> +
> +	/*
> +	 * Notify the delayed work to be cancelled, in case it was already
> +	 * removed from the queue, but was not started yet
> +	 */
> +	card->host->bkops_info.cancel_delayed_work = true;
> +
> +	if (!mmc_card_doing_bkops(card))
> +		return err;
> +
> +	card->host->bkops_info.exit_wait_on_completion = true;
>  	err = mmc_interrupt_hpi(card);
>  
>  	/*
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 597f189..d328191 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -27,6 +27,11 @@
>  #include "core.h"
>  #include "host.h"
>  
> +/*
> + * A default time for checking the need for non urgent BKOPs once MMC thread
> + * is idle.
> + */
> +#define MMC_IDLE_BKOPS_TIME_MS 2000
>  #define cls_dev_to_mmc_host(d)	container_of(d, struct mmc_host, class_dev)
>  
>  static void mmc_host_classdev_release(struct device *dev)
> @@ -336,6 +341,11 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
>  	spin_lock_init(&host->lock);
>  	init_waitqueue_head(&host->wq);
>  	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
> +	host->bkops_info. wq = create_singlethread_workqueue("bkops_wq");
> +	INIT_DELAYED_WORK(&host->bkops_info.idle_time_dw,
> +			  mmc_start_idle_time_bkops);
> +	INIT_WORK(&host->bkops_info.completion_polling,
> +		  mmc_bkops_completion_polling);
>  #ifdef CONFIG_PM
>  	host->pm_notify.notifier_call = mmc_pm_notify;
>  #endif
> @@ -386,6 +396,20 @@ int mmc_add_host(struct mmc_host *host)
>  #endif
>  	mmc_host_clk_sysfs_init(host);
>  
> +	/*
> +	 * Calculate the time to start the BKOPs checking.
> +	 * The idle time of the host controller should be taken into account
> +	 * in order to prevent a race condition before starting BKOPs and
> +	 * going into suspend.
> +	 * If the host controller didn't set its idle time, a default value is
> +	 * used.
> +	 */
> +	host->bkops_info.time_to_start_bkops_ms = MMC_IDLE_BKOPS_TIME_MS;
> +	if (host->bkops_info.host_suspend_tout_ms)
> +		host->bkops_info.time_to_start_bkops_ms = min(
> +			host->bkops_info.time_to_start_bkops_ms,
> +			host->bkops_info.host_suspend_tout_ms/2);
> +
>  	mmc_start_host(host);
>  	register_pm_notifier(&host->pm_notify);
>  
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 342fe84..835d6c8 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -280,6 +280,9 @@ struct mmc_card {
>  	struct dentry		*debugfs_root;
>  	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
>  	unsigned int    nr_parts;
> +
> +	/* num of read/write reqs since last BKOPs delayed work was queued */
> +	unsigned int idle_bkops_rw_reqs_nr;
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
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f578a71..8aaaf1d 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -176,6 +176,29 @@ struct mmc_supply {
>  	struct regulator *vqmmc;	/* Optional Vccq supply */
>  };
>  
> +/**
> + * struct mmc_bkops_info - BKOPs data
> + * @wq:			workqueue
> + * @idle_time_dw:	Idle time bkops delayed work
> + * @host_suspend_tout_ms:	The host controller idle time,
> + *         before getting into suspend
> + * @time_to_start_bkops_ms:	The time to start the BKOPs
> + *		  delayed work once MMC thread is idle
> + * @completion_polling:	Poll on BKOPs completion
> + * @cancel_delayed_work: A flag to indicate if the delayed work
> + *	       should be cancelled
> + * @exit_wait_on_completion:  Exit flag for non blocking BKOPs
> + */
> +struct mmc_bkops_info {
> +	struct workqueue_struct *wq;
> +	struct delayed_work	idle_time_dw;
> +	unsigned int		host_suspend_tout_ms;
> +	unsigned int		time_to_start_bkops_ms;
> +	struct work_struct	completion_polling;
> +	bool			cancel_delayed_work;
> +	bool			exit_wait_on_completion;
> +};
> +
>  struct mmc_host {
>  	struct device		*parent;
>  	struct device		class_dev;
> @@ -340,6 +363,8 @@ struct mmc_host {
>  
>  	unsigned int		actual_clock;	/* Actual HC clock rate */
>  
> +	struct mmc_bkops_info	bkops_info;
> +
>  	unsigned long		private[0] ____cacheline_aligned;
>  };
>  
> 

