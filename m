Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab0FUUEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:04:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50663 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab0FUUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:04:48 -0400
Message-ID: <4C1FC5BC.20008@nokia.com>
Date: Mon, 21 Jun 2010 23:04:12 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-mmc <linux-mmc@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 1/2] MMC: fix all hangs related to mmc/sd card insert/removal
 during suspend/resume.
References: <1276809695.28201.13.camel@maxim-laptop> <1276809814-28683-1-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1276809814-28683-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jun 2010 20:04:12.0807 (UTC) FILETIME=[EB18A970:01CB117C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Maxim Levitsky wrote:
> If you don't use CONFIG_MMC_UNSAFE_RESUME, as soon as you attempt to
> suspend, the card will be removed, therefore this patch doesn't change
> the behavior of this option.
> 
> However the removal will be done by pm notifier, which runs while
> userspace is still not frozen and thus can freely use del_gendisk,
> without the risk of deadlock which would happen otherwise.
> 
> 
> Card detect workqueue is now freezeable,
> therefore if you do use CONFIG_MMC_UNSAFE_RESUME,
> and remove the card during suspend, the removal will be
> detected as soon as userspace is unfrozen, again at the moment
> it is safe to call del_gendisk.
> 
> Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mmc/core/core.c  |   54 +++++++++++++++++++++++++++------------------
>  drivers/mmc/core/host.c  |    6 +++++
>  include/linux/mmc/host.h |    3 ++
>  3 files changed, 41 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 569e94d..0cba53a 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1259,26 +1259,11 @@ int mmc_suspend_host(struct mmc_host *host)
>  
>  	if (host->caps & MMC_CAP_DISABLE)
>  		cancel_delayed_work(&host->disable);
> -	cancel_delayed_work(&host->detect);
> -	mmc_flush_scheduled_work();
>  
>  	mmc_bus_get(host);
>  	if (host->bus_ops && !host->bus_dead) {
>  		if (host->bus_ops->suspend)
>  			err = host->bus_ops->suspend(host);
> -		if (err == -ENOSYS || !host->bus_ops->resume) {
> -			/*
> -			 * We simply "remove" the card in this case.
> -			 * It will be redetected on resume.
> -			 */
> -			if (host->bus_ops->remove)
> -				host->bus_ops->remove(host);
> -			mmc_claim_host(host);
> -			mmc_detach_bus(host);
> -			mmc_release_host(host);
> -			host->pm_flags = 0;
> -			err = 0;
> -		}
>  	}
>  	mmc_bus_put(host);
>  
> @@ -1310,12 +1295,6 @@ int mmc_resume_host(struct mmc_host *host)
>  			printk(KERN_WARNING "%s: error %d during resume "
>  					    "(card was removed?)\n",
>  					    mmc_hostname(host), err);
> -			if (host->bus_ops->remove)
> -				host->bus_ops->remove(host);
> -			mmc_claim_host(host);
> -			mmc_detach_bus(host);
> -			mmc_release_host(host);
> -			/* no need to bother upper layers */
>  			err = 0;
>  		}
>  	}
> @@ -1330,6 +1309,37 @@ int mmc_resume_host(struct mmc_host *host)
>  	return err;
>  }
>  
> +/* Do the card removal on suspend if card is assumed removeable
> + * Do that in pm notifier while userspace isn't yet frozen, so we will be able
> +   to sync the card.
> +*/
> +int mmc_pm_notify(struct notifier_block *notify_block,
> +					unsigned long mode, void *unused)
> +{
> +	struct mmc_host *host = container_of(
> +		notify_block, struct mmc_host, pm_notify);
> +
> +
> +	switch (mode) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +
> +		if (!host->bus_ops || host->bus_ops->suspend)
> +			break;
> +
> +		if (host->bus_ops->remove)
> +			host->bus_ops->remove(host);
> +		mmc_claim_host(host);
> +		mmc_detach_bus(host);
> +		mmc_release_host(host);
> +		host->pm_flags = 0;
> +		break;

Is it possible that you receive PM_SUSPEND_PREPARE
but there is no suspend and therefore no resume
and therefore the card is removed but not detected
again?

Is it possible that you are racing with kmmcd and the
card is added after you receive PM_SUSPEND_PREPARE but
before kmmcd is frozen?

> +
> +	}
> +
> +	return 0;
> +}
> +
>  EXPORT_SYMBOL(mmc_resume_host);
>  
>  #endif
> @@ -1338,7 +1348,7 @@ static int __init mmc_init(void)
>  {
>  	int ret;
>  
> -	workqueue = create_singlethread_workqueue("kmmcd");
> +	workqueue = create_freezeable_workqueue("kmmcd");
>  	if (!workqueue)
>  		return -ENOMEM;
>  
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 4735390..8a631c8 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -17,6 +17,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/leds.h>
>  #include <linux/slab.h>
> +#include <linux/suspend.h>
>  
>  #include <linux/mmc/host.h>
>  
> @@ -85,6 +86,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
>  	init_waitqueue_head(&host->wq);
>  	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
>  	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
> +	host->pm_notify.notifier_call = mmc_pm_notify;
> +
>  
>  	/*
>  	 * By default, hosts do not support SGIO or large requests.
> @@ -133,6 +136,7 @@ int mmc_add_host(struct mmc_host *host)
>  #endif
>  
>  	mmc_start_host(host);
> +	register_pm_notifier(&host->pm_notify);
>  
>  	return 0;
>  }
> @@ -149,6 +153,7 @@ EXPORT_SYMBOL(mmc_add_host);
>   */
>  void mmc_remove_host(struct mmc_host *host)
>  {
> +	unregister_pm_notifier(&host->pm_notify);
>  	mmc_stop_host(host);
>  
>  #ifdef CONFIG_DEBUG_FS
> @@ -158,6 +163,7 @@ void mmc_remove_host(struct mmc_host *host)
>  	device_del(&host->class_dev);
>  
>  	led_trigger_unregister_simple(host->led);
> +
>  }
>  
>  EXPORT_SYMBOL(mmc_remove_host);
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f65913c..b45812d 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -124,6 +124,7 @@ struct mmc_host {
>  	unsigned int		f_min;
>  	unsigned int		f_max;
>  	u32			ocr_avail;
> +	struct notifier_block	pm_notify;
>  
>  #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
>  #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
> @@ -257,6 +258,8 @@ int mmc_card_can_sleep(struct mmc_host *host);
>  int mmc_host_enable(struct mmc_host *host);
>  int mmc_host_disable(struct mmc_host *host);
>  int mmc_host_lazy_disable(struct mmc_host *host);
> +int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
> +
>  
>  static inline void mmc_set_disable_delay(struct mmc_host *host,
>  					 unsigned int disable_delay)

