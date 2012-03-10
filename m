Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2CJVrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:47:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2CJVrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:47:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM / devfreq: add relation of recommended frequency.
Date: Sat, 10 Mar 2012 22:51:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, Mike Turquette <mturquette@ti.com>,
        myungjoo.ham@gmail.com
References: <201202292359.05122.rjw@sisk.pl> <1331106056-14532-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1331106056-14532-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201203102251.10364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 07, 2012, MyungJoo Ham wrote:
> The semantics of "target frequency" given to devfreq driver from
> devfreq framework has always been interpretted as "at least" or GLB
> (greatest lower bound). However, the framework might want the
> device driver to limit its max frequency (LUB: least upper bound),
> especially if it is given by thermal framework (it's too hot).
> 
> Thus, the target fuction should have another parameter to express
> whether the framework wants GLB or LUB. And, the additional parameter,
> "u32 options", does it.
> 
> With the update, devfreq_recommended_opp() is also updated.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This one looks good.

Do you want me to take it as a patch, or to pull it from your tree?

Rafael


> ---
> Changes from v1
> - Style update.
> ---
>  drivers/devfreq/devfreq.c     |   41 ++++++++++++++++++++++++++++++-----------
>  drivers/devfreq/exynos4_bus.c |   14 ++++++++++----
>  include/linux/devfreq.h       |   16 +++++++++++++---
>  3 files changed, 53 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 0b49f59..13794d1 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -84,6 +84,7 @@ int update_devfreq(struct devfreq *devfreq)
>  {
>  	unsigned long freq;
>  	int err = 0;
> +	u32 flags = 0;
>  
>  	if (!mutex_is_locked(&devfreq->lock)) {
>  		WARN(true, "devfreq->lock must be locked by the caller.\n");
> @@ -104,18 +105,20 @@ int update_devfreq(struct devfreq *devfreq)
>  	 * qos_min_freq
>  	 */
>  
> -	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq)
> +	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
>  		freq = devfreq->qos_min_freq;
> -	if (devfreq->max_freq && freq > devfreq->max_freq)
> +		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> +	}
> +	if (devfreq->max_freq && freq > devfreq->max_freq) {
>  		freq = devfreq->max_freq;
> -	if (devfreq->min_freq && freq < devfreq->min_freq)
> +		flags |= DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use LUB */
> +	}
> +	if (devfreq->min_freq && freq < devfreq->min_freq) {
>  		freq = devfreq->min_freq;
> +		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> +	}
>  
> -	/*
> -	 * TODO in the devfreq-next:
> -	 * add relation or use rance (freq_min, freq_max)
> -	 */
> -	err = devfreq->profile->target(devfreq->dev.parent, &freq);
> +	err = devfreq->profile->target(devfreq->dev.parent, &freq, flags);
>  	if (err)
>  		return err;
>  
> @@ -773,14 +776,30 @@ module_exit(devfreq_exit);
>   *			     freq value given to target callback.
>   * @dev		The devfreq user device. (parent of devfreq)
>   * @freq	The frequency given to target function
> + * @flags	Flags handed from devfreq framework.
>   *
>   */
> -struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq)
> +struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
> +				    u32 flags)
>  {
> -	struct opp *opp = opp_find_freq_ceil(dev, freq);
> +	struct opp *opp;
>  
> -	if (opp == ERR_PTR(-ENODEV))
> +	if (flags & DEVFREQ_FLAG_LEAST_UPPER_BOUND) {
> +		/* The freq is an upper bound. opp should be lower */
>  		opp = opp_find_freq_floor(dev, freq);
> +
> +		/* If not available, use the closest opp */
> +		if (opp == ERR_PTR(-ENODEV))
> +			opp = opp_find_freq_ceil(dev, freq);
> +	} else {
> +		/* The freq is an lower bound. opp should be higher */
> +		opp = opp_find_freq_ceil(dev, freq);
> +
> +		/* If not available, use the closest opp */
> +		if (opp == ERR_PTR(-ENODEV))
> +			opp = opp_find_freq_floor(dev, freq);
> +	}
> +
>  	return opp;
>  }
>  
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 590d686..1a361e9 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -619,13 +619,19 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
>  	return err;
>  }
>  
> -static int exynos4_bus_target(struct device *dev, unsigned long *_freq)
> +static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
> +			      u32 flags)
>  {
>  	int err = 0;
> -	struct busfreq_data *data = dev_get_drvdata(dev);
> -	struct opp *opp = devfreq_recommended_opp(dev, _freq);
> -	unsigned long old_freq = opp_get_freq(data->curr_opp);
> +	struct platform_device *pdev = container_of(dev, struct platform_device,
> +						    dev);
> +	struct busfreq_data *data = platform_get_drvdata(pdev);
> +	struct opp *opp = devfreq_recommended_opp(dev, _freq, flags);
>  	unsigned long freq = opp_get_freq(opp);
> +	unsigned long old_freq = opp_get_freq(data->curr_opp);
> +
> +	if (IS_ERR(opp))
> +		return PTR_ERR(opp);
>  
>  	if (old_freq == freq)
>  		return 0;
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index f27d511..85d4b0f 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -59,6 +59,14 @@ struct devfreq_pm_qos_table {
>  	s32 qos_value;
>  };
>  
> +/*
> + * The resulting frequency should be at most this. (this bound is the
> + * least upper bound; thus, the resulting freq should be lower or same)
> + * If the flag is not set, the resulting frequency should be at most the
> + * bound (greatest lower bound)
> + */
> +#define DEVFREQ_FLAG_LEAST_UPPER_BOUND		0x1
> +
>  /**
>   * struct devfreq_dev_profile - Devfreq's user device profile
>   * @initial_freq	The operating frequency when devfreq_add_device() is
> @@ -74,6 +82,8 @@ struct devfreq_pm_qos_table {
>   *			higher than any operable frequency, set maximum.
>   *			Before returning, target function should set
>   *			freq at the current frequency.
> + *			The "flags" parameter's possible values are
> + *			explained above with "DEVFREQ_FLAG_*" macros.
>   * @get_dev_status	The device should provide the current performance
>   *			status to devfreq, which is used by governors.
>   * @exit		An optional callback that is called when devfreq
> @@ -92,7 +102,7 @@ struct devfreq_dev_profile {
>  	int qos_type;
>  	struct devfreq_pm_qos_table *qos_list;
>  
> -	int (*target)(struct device *dev, unsigned long *freq);
> +	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
>  	int (*get_dev_status)(struct device *dev,
>  			      struct devfreq_dev_status *stat);
>  	void (*exit)(struct device *dev);
> @@ -198,7 +208,7 @@ extern int devfreq_remove_device(struct devfreq *devfreq);
>  
>  /* Helper functions for devfreq user device driver with OPP. */
>  extern struct opp *devfreq_recommended_opp(struct device *dev,
> -					   unsigned long *freq);
> +					   unsigned long *freq, u32 flags);
>  extern int devfreq_register_opp_notifier(struct device *dev,
>  					 struct devfreq *devfreq);
>  extern int devfreq_unregister_opp_notifier(struct device *dev,
> @@ -253,7 +263,7 @@ static int devfreq_remove_device(struct devfreq *devfreq)
>  }
>  
>  static struct opp *devfreq_recommended_opp(struct device *dev,
> -					   unsigned long *freq)
> +					   unsigned long *freq, u32 flags)
>  {
>  	return -EINVAL;
>  }
> 

