Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2AQH3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 02:29:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:45816 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab2AQH3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 02:29:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="57156200"
Message-ID: <4F152347.1060703@intel.com>
Date: Tue, 17 Jan 2012 09:29:11 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Dmitry Antipov <dmitry.antipov@linaro.org>
CC: Chris Ball <cjb@laptop.org>, patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: change mmc_delay() to use usleep_range()
References: <1326696200-514-1-git-send-email-dmitry.antipov@linaro.org>
In-Reply-To: <1326696200-514-1-git-send-email-dmitry.antipov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/12 08:43, Dmitry Antipov wrote:
> Use the usleep_range() to simplify mmc_delay() and give some more
> accuracy to it - but with an exception of mmc_card_sleepawake():
> for the hosts with very small (<100us) sleep/awake timeout, it's
> value is rounded up to 100us so usleep_range() always makes sense.
> ---
>  drivers/mmc/core/core.h    |    8 ++------
>  drivers/mmc/core/mmc_ops.c |    9 ++++++---
>  2 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index 3bdafbc..fbd2cba 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -48,12 +48,8 @@ void mmc_power_off(struct mmc_host *host);
>  
>  static inline void mmc_delay(unsigned int ms)
>  {
> -	if (ms < 1000 / HZ) {
> -		cond_resched();
> -		mdelay(ms);
> -	} else {
> -		msleep(ms);
> -	}
> +	unsigned long us = ms * USEC_PER_MSEC;
> +	usleep_range(us, us + 1000);
>  }
>  
>  void mmc_rescan(struct work_struct *work);
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 4d41fa9..457443a 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -82,9 +82,12 @@ int mmc_card_sleepawake(struct mmc_host *host, int sleep)
>  	 * SEND_STATUS command to poll the status because that command (and most
>  	 * others) is invalid while the card sleeps.
>  	 */
> -	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
> -		mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
> -
> +	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY)) {
> +		/* JEDEC MMCA 4.41 specifies the timeout value is in 200ns..838.86ms
> +		   range, which is rounded it up to 100us here. */
> +		unsigned long us = DIV_ROUND_UP(card->ext_csd.sa_timeout, 1000);

The divisor has changed from 10000 to 1000 but the change is from ms to us,
so it ought to be 3 zeros different - unless it is a bug fix (which should
be a separate patch)?


> +		usleep_range(us, us + 100);
> +	}
>  	if (!sleep)
>  		err = mmc_select_card(card);
>  

