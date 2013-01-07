Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3AGM1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:27:36 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:32799 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3AGM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:27:34 -0500
MIME-Version: 1.0
In-Reply-To: <1356357068-31807-2-git-send-email-merez@codeaurora.org>
References: <1356357068-31807-2-git-send-email-merez@codeaurora.org>
Date: Mon, 7 Jan 2013 13:27:32 +0100
Message-ID: <CAPDyKFpB0FLgQEBuDuHV3JR7tcc2AWeKe8kj5_hTudCbkTZEXQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] mmc: core: Add support for idle time BKOPS
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maya,

On 24 December 2012 14:51, Maya Erez <merez@codeaurora.org> wrote:
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
> need for BKOPS. The time to start the delayed work can be set by the host
> controller. If this time is not set, a default time is used.

I believe I have asked this question before; Have you considered to
use runtime PM autosuspend feature instead of adding a delayed work to
handle idle BKOPS?
Similar how sdio is doing mmc_power_save|restore, but for sd/mmc we
handle the BKOPS instead. My feeling is that it could simplify this
patch quite significantly.

It would be interesting to hear about your view of this idea.

> If the card raised an exception, the need for urgent BKOPS (level 2/3)
> will be checked immediately and if needed, the BKOPS will be performed
> without waiting for the next idle time.
>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 21056b9..64bbf75 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -1473,9 +1473,15 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>         struct mmc_blk_data *md = mq->data;
>         struct mmc_card *card = md->queue.card;
>
> -       if (req && !mq->mqrq_prev->req)
> +       if (req && !mq->mqrq_prev->req) {
>                 /* claim host only for the first request */
>                 mmc_claim_host(card->host);
> +               if (card->ext_csd.bkops_en &&
> +                   card->bkops_info.started_delayed_bkops) {
> +                       card->bkops_info.started_delayed_bkops = false;
> +                       mmc_stop_bkops(card);
> +               }
> +       }
>
>         ret = mmc_blk_part_switch(card, md);
>         if (ret) {
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index fadf52e..9d0c96a 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -51,6 +51,7 @@ static int mmc_queue_thread(void *d)
>  {
>         struct mmc_queue *mq = d;
>         struct request_queue *q = mq->queue;
> +       struct mmc_card *card = mq->card;
>
>         current->flags |= PF_MEMALLOC;
>
> @@ -83,6 +84,7 @@ static int mmc_queue_thread(void *d)
>                                 set_current_state(TASK_RUNNING);
>                                 break;
>                         }
> +                       mmc_start_delayed_bkops(card);
>                         up(&mq->thread_sem);
>                         schedule();
>                         down(&mq->thread_sem);
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index aaed768..36cef94 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -256,6 +256,33 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
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
> +       if (!card || !card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
> +               return;
> +
> +       pr_debug("%s: %s: queueing delayed_bkops_work\n",
> +                mmc_hostname(card->host), __func__);
> +
> +       /*
> +        * cancel_delayed_bkops_work will prevent a race condition between
> +        * fetching a request by the mmcqd and the delayed work, in case
> +        * it was removed from the queue work but not started yet
> +        */
> +       card->bkops_info.cancel_delayed_work = false;
> +       card->bkops_info.started_delayed_bkops = true;
> +       queue_delayed_work(system_nrt_wq, &card->bkops_info.dw,
> +                          msecs_to_jiffies(
> +                                  card->bkops_info.delay_ms));
> +}
> +EXPORT_SYMBOL(mmc_start_delayed_bkops);
> +
> +/**
>   *     mmc_start_bkops - start BKOPS for supported cards
>   *     @card: MMC card to start BKOPS
>   *     @form_exception: A flag to indicate if this function was
> @@ -272,25 +299,47 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
>         bool use_busy_signal;
>
>         BUG_ON(!card);
> -
> -       if (!card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
> +       if (!card->ext_csd.bkops_en)
>                 return;
>
> +       mmc_claim_host(card->host);
> +
> +       if ((card->bkops_info.cancel_delayed_work) && !from_exception) {
> +               pr_debug("%s: %s: cancel_delayed_work was set, exit\n",
> +                        mmc_hostname(card->host), __func__);
> +               card->bkops_info.cancel_delayed_work = false;
> +               goto out;
> +       }
> +
> +       if (mmc_card_doing_bkops(card)) {
> +               pr_debug("%s: %s: already doing bkops, exit\n",
> +                        mmc_hostname(card->host), __func__);
> +               goto out;
> +       }
> +
>         err = mmc_read_bkops_status(card);
>         if (err) {
>                 pr_err("%s: Failed to read bkops status: %d\n",
>                        mmc_hostname(card->host), err);
> -               return;
> +               goto out;
>         }
>
>         if (!card->ext_csd.raw_bkops_status)
> -               return;
> +               goto out;
> +
> +       pr_info("%s: %s: card->ext_csd.raw_bkops_status = 0x%x\n",
> +               mmc_hostname(card->host), __func__,
> +               card->ext_csd.raw_bkops_status);
>
> +       /*
> +        * If the function was called due to exception but there is no need
> +        * for urgent BKOPS, BKOPs will be performed by the delayed BKOPs
> +        * work, before going to suspend
> +        */
>         if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
>             from_exception)
> -               return;
> +               goto out;
>
> -       mmc_claim_host(card->host);
>         if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
>                 timeout = MMC_BKOPS_MAX_TIMEOUT;
>                 use_busy_signal = true;
> @@ -319,6 +368,27 @@ out:
>  }
>  EXPORT_SYMBOL(mmc_start_bkops);
>
> +/**
> + * mmc_start_idle_time_bkops() - check if a non urgent BKOPS is
> + * needed
> + * @work:      The idle time BKOPS work
> + */
> +void mmc_start_idle_time_bkops(struct work_struct *work)
> +{
> +       struct mmc_card *card = container_of(work, struct mmc_card,
> +                       bkops_info.dw.work);
> +
> +       /*
> +        * Prevent a race condition between mmc_stop_bkops and the delayed
> +        * BKOPS work in case the delayed work is executed on another CPU
> +        */
> +       if (card->bkops_info.cancel_delayed_work)
> +               return;
> +
> +       mmc_start_bkops(card, false);
> +}
> +EXPORT_SYMBOL(mmc_start_idle_time_bkops);
> +
>  static void mmc_wait_done(struct mmc_request *mrq)
>  {
>         complete(&mrq->completion);
> @@ -585,6 +655,17 @@ int mmc_stop_bkops(struct mmc_card *card)
>         int err = 0;
>
>         BUG_ON(!card);
> +
> +       /*
> +        * Notify the delayed work to be cancelled, in case it was already
> +        * removed from the queue, but was not started yet
> +        */
> +       card->bkops_info.cancel_delayed_work = true;
> +       if (delayed_work_pending(&card->bkops_info.dw))
> +               cancel_delayed_work_sync(&card->bkops_info.dw);
> +       if (!mmc_card_doing_bkops(card))
> +               goto out;
> +
>         err = mmc_interrupt_hpi(card);
>
>         /*
> @@ -596,6 +677,7 @@ int mmc_stop_bkops(struct mmc_card *card)
>                 err = 0;
>         }
>
> +out:
>         return err;
>  }
>  EXPORT_SYMBOL(mmc_stop_bkops);
> @@ -2536,15 +2618,15 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>         switch (mode) {
>         case PM_HIBERNATION_PREPARE:
>         case PM_SUSPEND_PREPARE:
> -               if (host->card && mmc_card_mmc(host->card) &&
> -                   mmc_card_doing_bkops(host->card)) {
> +               if (host->card && mmc_card_mmc(host->card)) {
> +                       mmc_claim_host(host);
>                         err = mmc_stop_bkops(host->card);
> +                       mmc_release_host(host);
>                         if (err) {
>                                 pr_err("%s: didn't stop bkops\n",
>                                         mmc_hostname(host));
>                                 return err;
>                         }
> -                       mmc_card_clr_doing_bkops(host->card);
>                 }
>
>                 spin_lock_irqsave(&host->lock, flags);
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index e6e3911..f68624a 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -1275,6 +1275,26 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                 }
>         }
>
> +       if (!oldcard) {
> +               if (card->ext_csd.bkops_en) {
> +                       INIT_DELAYED_WORK(&card->bkops_info.dw,
> +                                         mmc_start_idle_time_bkops);
> +
> +                       /*
> +                        * Calculate the time to start the BKOPs checking.
> +                        * The host controller can set this time in order to
> +                        * prevent a race condition before starting BKOPs
> +                        * and going into suspend.
> +                        * If the host controller didn't set this time,
> +                        * a default value is used.
> +                        */
> +                       card->bkops_info.delay_ms = MMC_IDLE_BKOPS_TIME_MS;
> +                       if (card->bkops_info.host_delay_ms)
> +                               card->bkops_info.delay_ms =
> +                                       card->bkops_info.host_delay_ms;
> +               }
> +       }
> +
>         if (!oldcard)
>                 host->card = card;
>
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 5c69315..ca4cf19 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -210,6 +210,30 @@ struct mmc_part {
>  #define MMC_BLK_DATA_AREA_RPMB (1<<3)
>  };
>
> +/**
> + * struct mmc_bkops_info - BKOPS data
> + * @dw:        Idle time bkops delayed work
> + * @host_delay_ms:     The host controller time to start bkops
> + * @delay_ms:  The time to start the BKOPS
> + *        delayed work once MMC thread is idle
> + * @cancel_delayed_work: A flag to indicate if the delayed work
> + *        should be cancelled
> + * @started_delayed_bkops:  A flag to indicate if the delayed
> + *        work was scheduled
> + */
> +struct mmc_bkops_info {
> +       struct delayed_work     dw;
> +       unsigned int            host_delay_ms;
> +       unsigned int            delay_ms;
> +/*
> + * A default time for checking the need for non urgent BKOPS once mmcqd
> + * is idle.
> + */
> +#define MMC_IDLE_BKOPS_TIME_MS 2000
> +       bool                    cancel_delayed_work;
> +       bool                    started_delayed_bkops;
> +};
> +
>  /*
>   * MMC device
>   */
> @@ -278,6 +302,8 @@ struct mmc_card {
>         struct dentry           *debugfs_root;
>         struct mmc_part part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
>         unsigned int    nr_parts;
> +
> +       struct mmc_bkops_info   bkops_info;
>  };
>
>  /*
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 5bf7c22..c6426c6 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -145,6 +145,8 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
>  extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
>         struct mmc_command *, int);
>  extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
> +extern void mmc_start_delayed_bkops(struct mmc_card *card);
> +extern void mmc_start_idle_time_bkops(struct work_struct *work);
>  extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
>  extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
>
> --
> 1.7.3.3
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Kind regards
Ulf Hansson
