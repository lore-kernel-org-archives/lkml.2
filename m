Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1BNOKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:10:01 -0500
Received: from smtp.nokia.com ([147.243.1.48]:20025 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab1BNOJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:09:59 -0500
Message-ID: <4D593762.7020006@nokia.com>
Date: Mon, 14 Feb 2011 16:08:34 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
References: <20110212062214.GB25519@intel.com>
In-Reply-To: <20110212062214.GB25519@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2011 14:08:30.0225 (UTC) FILETIME=[A83D9810:01CBCC50]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/11 08:22, ext Chuanxiao Dong wrote:
> max_discard_sectors value is UINT_MAX which means kernel block layer can pass
> down unlimited sectors to MMC driver to erase. But erasing so many sectors may
> delay some other important I/O requests. This is not preferred.
>
> So use 'pref_erase' to set a suitable max_discard_sectors value for mmc queue to
> avoid erasing too many sectors at one time.
>
> Signed-off-by: Chuanxiao Dong<chuanxiao.dong@intel.com>
> ---
>   drivers/mmc/card/queue.c |    3 ++-
>   drivers/mmc/core/core.c  |   20 ++++++++++++++++++++
>   include/linux/mmc/core.h |    1 +
>   3 files changed, 23 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 4e42d03..6c13859 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -131,7 +131,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
>   	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
>   	if (mmc_can_erase(card)) {
>   		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
> -		mq->queue->limits.max_discard_sectors = UINT_MAX;
> +		mq->queue->limits.max_discard_sectors =
> +			mmc_set_max_discard_sectors(card);
>   		if (card->erased_byte == 0)
>   			mq->queue->limits.discard_zeroes_data = 1;
>   		if (!mmc_can_trim(card)&&  is_power_of_2(card->erase_size)) {
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 34a7e8c..0eb27aa 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1470,6 +1470,26 @@ int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
>   }
>   EXPORT_SYMBOL(mmc_erase_group_aligned);
>
> +/*
> + * Set max_discard_sectors for mmc queue.
> + * max_discard_sectors will determine how many sectors can be erased at one
> + * time. Sometimes user may want to erase a large area of SD or MMC card, it may
> + * take long time which delay some other important I/O requests. So we would
> + * better set some values for max_discard_sectors which can forbid block layer
> + * pass too many sectors at one time.
> + *
> + * 'pref_erase' is initialized for this purpose. We can use it to set a preferred
> + * value for it.
> + */
> +int mmc_set_max_discard_sectors(struct mmc_card *card)
> +{
> +	if (card->pref_erase)
> +		return card->pref_erase;

This will cause orders of magnitude decrease in secure erase
performance for eMMC.

> +	else
> +		return UINT_MAX;
> +}
> +EXPORT_SYMBOL(mmc_set_max_discard_sectors);
> +
>   int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen)
>   {
>   	struct mmc_command cmd;
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 64e013f..a218d57 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -152,6 +152,7 @@ extern int mmc_can_trim(struct mmc_card *card);
>   extern int mmc_can_secure_erase_trim(struct mmc_card *card);
>   extern int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
>   				   unsigned int nr);
> +extern int mmc_set_max_discard_sectors(struct mmc_card *card);
>
>   extern int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen);
>

