Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1HQF71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:59:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:61178 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab1HQF7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:59:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,237,1312182000"; 
   d="scan'208";a="8006716"
Date: Wed, 17 Aug 2011 08:59:58 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mmc: add functions to enable/disable aggressive
 clock gating
Message-ID: <20110817055958.GU16790@intel.com>
References: <e13e177c732ee8ad2d6fe389c9bac21877f60c59.1313400777.git.mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e13e177c732ee8ad2d6fe389c9bac21877f60c59.1313400777.git.mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 01:03:37PM +0300, Mika Westerberg wrote:
> There are few places where we want to make sure that no clock gating takes
> place. For example when we are updating several related fields in ios
> structure and we don't want to accidentally pass the partially filled ios
> to the host driver.
> 
> To solve this we add two functions to enable/disable the aggressive clock
> gating where this is needed.

Chris, Linus W,

Do you have any comments on this series?

I should've added a better explanation of the problem. In summary, to me it
looks like the aggressive clock gating framework can cause an incomplete
ios to be passed to the host driver if we are just updating it in MMC core,
which could cause the host driver to do wrong things. In our case it
happened during call of mmc_power_off(), resulting an BUG() to be
triggered.

Also in mmc_set_ios() there's a possibility that the aggressive clock
gating triggers just after we have tested ios->clock > 0. Next time a
request is started, the mmc_host_clk_ungate() is called but it doesn't
ungate the clock as it is already marked as ungated. This leads to a hang
in our case (as the clock is stopped).

I think the same problem was previously solved in 26fc8775b51 ("mmc: fix a
race between card-detect rescan and clock-gate work instances") which got
reverted.

Thanks.

> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mmc/core/host.c  |   39 ++++++++++++++++++++++++++++++++++++++-
>  drivers/mmc/core/host.h  |   11 +++++++++++
>  include/linux/mmc/host.h |    1 +
>  3 files changed, 50 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index b29d3e8..ee52246 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -178,7 +178,7 @@ void mmc_host_clk_gate(struct mmc_host *host)
>  	spin_lock_irqsave(&host->clk_lock, flags);
>  	host->clk_requests--;
>  	if (mmc_host_may_gate_card(host->card) &&
> -	    !host->clk_requests)
> +	    !host->clk_requests && !host->clk_disabled)
>  		schedule_work(&host->clk_gate_work);
>  	spin_unlock_irqrestore(&host->clk_lock, flags);
>  }
> @@ -204,6 +204,42 @@ unsigned int mmc_host_clk_rate(struct mmc_host *host)
>  }
>  
>  /**
> + *	mmc_host_clk_gate_disable - temporarily disable clock gating
> + *	@host: host to disable clock gating
> + *
> + *	Function temporarily disables aggressive clock gating. This is to
> + *	prevent clock gating worker to kick in for example in a middle of
> + *	ios structure update.
> + *
> + *	After this function returns, it is guaranteed that no clock gating
> + *	takes place until it is re-enabled again.
> + */
> +void mmc_host_clk_gate_disable(struct mmc_host *host)
> +{
> +	spin_lock_irq(&host->clk_lock);
> +	WARN_ON(host->clk_disabled);
> +	host->clk_disabled = true;
> +	spin_unlock_irq(&host->clk_lock);
> +
> +	cancel_work_sync(&host->clk_gate_work);
> +}
> +
> +/**
> + *	mmc_host_clk_gate_enable - re-enables clock gating
> + *	@host: host to re-enable clock gating
> + *
> + *	Allows aggressive clock gating framework to continue gating the
> + *	host clock.
> + */
> +void mmc_host_clk_gate_enable(struct mmc_host *host)
> +{
> +	spin_lock_irq(&host->clk_lock);
> +	WARN_ON(!host->clk_disabled);
> +	host->clk_disabled = false;
> +	spin_unlock_irq(&host->clk_lock);
> +}
> +
> +/**
>   *	mmc_host_clk_init - set up clock gating code
>   *	@host: host with potential clock to control
>   */
> @@ -213,6 +249,7 @@ static inline void mmc_host_clk_init(struct mmc_host *host)
>  	/* Hold MCI clock for 8 cycles by default */
>  	host->clk_delay = 8;
>  	host->clk_gated = false;
> +	host->clk_disabled = false;
>  	INIT_WORK(&host->clk_gate_work, mmc_host_clk_gate_work);
>  	spin_lock_init(&host->clk_lock);
>  	mutex_init(&host->clk_gate_mutex);
> diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
> index de199f9..7148b24 100644
> --- a/drivers/mmc/core/host.h
> +++ b/drivers/mmc/core/host.h
> @@ -19,6 +19,8 @@ void mmc_unregister_host_class(void);
>  void mmc_host_clk_ungate(struct mmc_host *host);
>  void mmc_host_clk_gate(struct mmc_host *host);
>  unsigned int mmc_host_clk_rate(struct mmc_host *host);
> +void mmc_host_clk_gate_disable(struct mmc_host *host);
> +void mmc_host_clk_gate_enable(struct mmc_host *host);
>  
>  #else
>  static inline void mmc_host_clk_ungate(struct mmc_host *host)
> @@ -33,6 +35,15 @@ static inline unsigned int mmc_host_clk_rate(struct mmc_host *host)
>  {
>  	return host->ios.clock;
>  }
> +
> +static inline void mmc_host_clk_gate_disable(struct mmc_host *host)
> +{
> +}
> +
> +static inline void mmc_host_clk_gate_enable(struct mmc_host *host)
> +{
> +}
> +
>  #endif
>  
>  void mmc_host_deeper_disable(struct work_struct *work);
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 1d09562..dea6350 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -240,6 +240,7 @@ struct mmc_host {
>  	unsigned int		clk_old;	/* old clock value cache */
>  	spinlock_t		clk_lock;	/* lock for clk fields */
>  	struct mutex		clk_gate_mutex;	/* mutex for clock gating */
> +	bool			clk_disabled;	/* gating is temporarily disabled */
>  #endif
>  
>  	/* host specific block data */
> -- 
> 1.7.5.4
