Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2B2WzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:55:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49065 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab2B2WzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:55:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM / devfreq: add relation of recommended frequency.
Date: Wed, 29 Feb 2012 23:59:04 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, Mike Turquette <mturquette@ti.com>,
        myungjoo.ham@gmail.com
References: <1328858388-22384-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1328858388-22384-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202292359.05122.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, I seem to have overlooked this patch.

On Friday, February 10, 2012, MyungJoo Ham wrote:
> The semantics of "target frequency" given to devfreq driver from
> devfreq framework has always been interpretted as "at least" or GLB
> (greatest lower bound). However, the framework might want the
> device driver to limit its max frequency (LUB: least upper bound),
> especially if it is given by thermal framework (it's too hot).
> 
> Thus, the target fuction should have another parameter to express
> whether the framework wants GLB or LUB. And, the additional parameter,
> "u32 options", does it.

I'd call that "flags" (which usually is the case in the kernel for things
handled with the help of bitwise operators).

> With the update, devfreq_recommended_opp() is also updated.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> ---
>  drivers/devfreq/devfreq.c     |   44 ++++++++++++++++++++++++++++++----------
>  drivers/devfreq/exynos4_bus.c |   16 +++++++++++---
>  include/linux/devfreq.h       |   18 ++++++++++++++--
>  3 files changed, 60 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index a33fc6c..83392a6 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -84,6 +84,7 @@ int update_devfreq(struct devfreq *devfreq)
>  {
>  	unsigned long freq;
>  	int err = 0;
> +	u32 options = 0;
>  
>  	if (!mutex_is_locked(&devfreq->lock)) {
>  		WARN(true, "devfreq->lock must be locked by the caller.\n");
> @@ -104,18 +105,23 @@ int update_devfreq(struct devfreq *devfreq)
>  	 * qos_min_freq
>  	 */
>  
> -	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq)
> +	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
>  		freq = devfreq->qos_min_freq;
> -	if (devfreq->max_freq && freq > devfreq->max_freq)
> +		options &= ~(1 << 0);

What exactly is the (1 << 0) for?

Whatever the case is I'd just use one flag name, e.g.
DEVFREQ_LEAST_UPPER_BOUND (equal to (1U << 0), and assume that the other
option is to be chosen when this flag is not set.


> +		options |= DEVFREQ_OPTION_FREQ_LUB;

So the above would become:

+       if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
                freq = devfreq->qos_min_freq;
-       if (devfreq->max_freq && freq > devfreq->max_freq)
+               options |= DEVFREQ_LEAST_UPPER_BOUND;
+       }

> +	}
> +	if (devfreq->max_freq && freq > devfreq->max_freq) {
>  		freq = devfreq->max_freq;
> -	if (devfreq->min_freq && freq < devfreq->min_freq)
> +		options &= ~(1 << 0);
> +		options |= DEVFREQ_OPTION_FREQ_GLB;
> +	}

and this one would become:

+       if (devfreq->max_freq && freq > devfreq->max_freq) {
                freq = devfreq->max_freq;
-       if (devfreq->min_freq && freq < devfreq->min_freq)
+               options &= ~DEVFREQ_LEAST_UPPER_BOUND;
+       }

Then, the code would be much easier to follow.

> +	if (devfreq->min_freq && freq < devfreq->min_freq) {
>  		freq = devfreq->min_freq;
> +		options &= ~(1 << 0);
> +		options |= DEVFREQ_OPTION_FREQ_LUB;
> +	}
>  
> -	/*
> -	 * TODO in the devfreq-next:
> -	 * add relation or use rance (freq_min, freq_max)
> -	 */
> -	err = devfreq->profile->target(devfreq->dev.parent, &freq);
> +	err = devfreq->profile->target(devfreq->dev.parent, &freq, options);
>  	if (err)
>  		return err;
>  
> @@ -771,14 +777,30 @@ module_exit(devfreq_exit);
>   *			     freq value given to target callback.
>   * @dev		The devfreq user device. (parent of devfreq)
>   * @freq	The frequency given to target function
> + * @floor	false: find LUB first and use GLB if LUB not available.
> + *		true:  find GLB first and use LUB if GLB not available.
> + *
> + * LUB: least upper bound (at least this freq or above, but the least)
> + * GLB: greatest lower bound (at most this freq or below, but the most)
>   *
>   */
> -struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq)
> +struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
> +				    bool floor)

Why don't you use "u32 flags" here too?

>  {
> -	struct opp *opp = opp_find_freq_ceil(dev, freq);
> +	struct opp *opp;
>  
> -	if (opp == ERR_PTR(-ENODEV))
> +	if (floor) {

That would become

+	if (options & DEVFREQ_LEAST_UPPER_BOUND) {

which is a bit more meaningful IMO.

>  		opp = opp_find_freq_floor(dev, freq);
> +
> +		if (opp == ERR_PTR(-ENODEV))
> +			opp = opp_find_freq_ceil(dev, freq);
> +	} else {
> +		opp = opp_find_freq_ceil(dev, freq);
> +
> +		if (opp == ERR_PTR(-ENODEV))
> +			opp = opp_find_freq_floor(dev, freq);
> +	}
> +
>  	return opp;
>  }
>  
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 590d686..c0a78da 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -619,13 +619,21 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
>  	return err;
>  }
>  
> -static int exynos4_bus_target(struct device *dev, unsigned long *_freq)
> +static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
> +			      u32 options)
>  {
>  	int err = 0;
> -	struct busfreq_data *data = dev_get_drvdata(dev);
> -	struct opp *opp = devfreq_recommended_opp(dev, _freq);
> -	unsigned long old_freq = opp_get_freq(data->curr_opp);
> +	unsigned long def = *_freq;
> +	struct platform_device *pdev = container_of(dev, struct platform_device,
> +						    dev);
> +	struct busfreq_data *data = platform_get_drvdata(pdev);
> +	struct opp *opp = devfreq_recommended_opp(dev, _freq, options &
> +						  DEVFREQ_OPTION_FREQ_GLB);
>  	unsigned long freq = opp_get_freq(opp);
> +	unsigned long old_freq = opp_get_freq(data->curr_opp);
> +
> +	if (IS_ERR(opp))
> +		return PTR_ERR(opp);
>  
>  	if (old_freq == freq)
>  		return 0;
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index b853379..1aff012 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -59,6 +59,16 @@ struct devfreq_pm_qos_table {
>  	s32 qos_value;
>  };
>  
> +/*
> + * target callback, which is to provide additional information to the
> + * devfreq driver.
> + */
> +
> +/* The resulting frequency should be at least this. (least upper bound) */
> +#define DEVFREQ_OPTION_FREQ_LUB	0x0
> +/* The resulting frequency should be at most this. (greatest lower bound) */
> +#define DEVFREQ_OPTION_FREQ_GLB 0x1

As I said, I'd use one option name and call it DEVFREQ_LEAST_UPPER_BOUND.
It is not necessary to give a name to the alternative. :-)

> +
>  /**
>   * struct devfreq_dev_profile - Devfreq's user device profile
>   * @initial_freq	The operating frequency when devfreq_add_device() is
> @@ -76,6 +86,8 @@ struct devfreq_pm_qos_table {
>   *			higher than any operable frequency, set maximum.
>   *			Before returning, target function should set
>   *			freq at the current frequency.
> + *			The "option" parameter's possible values are
> + *			explained above with "DEVFREQ_OPTION_*" macros.
>   * @get_dev_status	The device should provide the current performance
>   *			status to devfreq, which is used by governors.
>   * @exit		An optional callback that is called when devfreq
> @@ -95,7 +107,7 @@ struct devfreq_dev_profile {
>  	bool qos_use_max;
>  	struct devfreq_pm_qos_table *qos_list;
>  
> -	int (*target)(struct device *dev, unsigned long *freq);
> +	int (*target)(struct device *dev, unsigned long *freq, u32 options);
>  	int (*get_dev_status)(struct device *dev,
>  			      struct devfreq_dev_status *stat);
>  	void (*exit)(struct device *dev);
> @@ -198,7 +210,7 @@ extern int devfreq_remove_device(struct devfreq *devfreq);
>  
>  /* Helper functions for devfreq user device driver with OPP. */
>  extern struct opp *devfreq_recommended_opp(struct device *dev,
> -					   unsigned long *freq);
> +					   unsigned long *freq, bool floor);
>  extern int devfreq_register_opp_notifier(struct device *dev,
>  					 struct devfreq *devfreq);
>  extern int devfreq_unregister_opp_notifier(struct device *dev,
> @@ -253,7 +265,7 @@ static int devfreq_remove_device(struct devfreq *devfreq)
>  }
>  
>  static struct opp *devfreq_recommended_opp(struct device *dev,
> -					   unsigned long *freq)
> +					   unsigned long *freq, bool floor)
>  {
>  	return -EINVAL;
>  }
> 

Thanks,
Rafael
