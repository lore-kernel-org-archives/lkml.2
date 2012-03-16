Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161313Ab2CPGPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:15:20 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44372 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950Ab2CPGPR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <1331877770-12150-1-git-send-email-myungjoo.ham@samsung.com>
References: <201203150125.14896.rjw@sisk.pl> <1331877770-12150-1-git-send-email-myungjoo.ham@samsung.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 15 Mar 2012 23:14:53 -0700
Message-ID: <CAJOA=zMZE51Bcb67pf-jU99BYswDnhtvPiA+Y+EQcMpToN7xPg@mail.gmail.com>
Subject: Re: [PATCH v3] PM / devfreq: add relation of recommended frequency.
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, myungjoo.ham@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:02 PM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> The semantics of "target frequency" given to devfreq driver from
> devfreq framework has always been interpretted as "at least" or GLB
> (greatest lower bound). However, the framework might want the
> device driver to limit its max frequency (LUB: least upper bound),
> especially if it is given by thermal framework (it's too hot).
>
> Thus, the target fuction should have another parameter to express
> whether the framework wants GLB or LUB. And, the additional parameter,
> "u32 flags", does it.
>
> With the update, devfreq_recommended_opp() is also updated.
>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

I know Rafael already said he'd take it but I might as well add:

Reviewed-by: Mike Turquette <mturquette@ti.com>

> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes from v2
> - Updated comments
> - Rebased.
>
> Changes from v1
> - Style update.
>
>  drivers/devfreq/devfreq.c     |   42 +++++++++++++++++++++++++++++++++++++---
>  drivers/devfreq/exynos4_bus.c |   14 +++++++++---
>  include/linux/devfreq.h       |   16 ++++++++++++--
>  3 files changed, 61 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index a129a7b..70c31d4 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -83,6 +83,7 @@ int update_devfreq(struct devfreq *devfreq)
>  {
>        unsigned long freq;
>        int err = 0;
> +       u32 flags = 0;
>
>        if (!mutex_is_locked(&devfreq->lock)) {
>                WARN(true, "devfreq->lock must be locked by the caller.\n");
> @@ -94,7 +95,24 @@ int update_devfreq(struct devfreq *devfreq)
>        if (err)
>                return err;
>
> -       err = devfreq->profile->target(devfreq->dev.parent, &freq);
> +       /*
> +        * Adjust the freuqency with user freq and QoS.
> +        *
> +        * List from the highest proiority
> +        * max_freq (probably called by thermal when it's too hot)
> +        * min_freq
> +        */
> +
> +       if (devfreq->min_freq && freq < devfreq->min_freq) {
> +               freq = devfreq->min_freq;
> +               flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> +       }
> +       if (devfreq->max_freq && freq > devfreq->max_freq) {
> +               freq = devfreq->max_freq;
> +               flags |= DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use LUB */
> +       }
> +
> +       err = devfreq->profile->target(devfreq->dev.parent, &freq, flags);
>        if (err)
>                return err;
>
> @@ -625,14 +643,30 @@ module_exit(devfreq_exit);
>  *                          freq value given to target callback.
>  * @dev                The devfreq user device. (parent of devfreq)
>  * @freq       The frequency given to target function
> + * @flags      Flags handed from devfreq framework.
>  *
>  */
> -struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq)
> +struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
> +                                   u32 flags)
>  {
> -       struct opp *opp = opp_find_freq_ceil(dev, freq);
> +       struct opp *opp;
>
> -       if (opp == ERR_PTR(-ENODEV))
> +       if (flags & DEVFREQ_FLAG_LEAST_UPPER_BOUND) {
> +               /* The freq is an upper bound. opp should be lower */
>                opp = opp_find_freq_floor(dev, freq);
> +
> +               /* If not available, use the closest opp */
> +               if (opp == ERR_PTR(-ENODEV))
> +                       opp = opp_find_freq_ceil(dev, freq);
> +       } else {
> +               /* The freq is an lower bound. opp should be higher */
> +               opp = opp_find_freq_ceil(dev, freq);
> +
> +               /* If not available, use the closest opp */
> +               if (opp == ERR_PTR(-ENODEV))
> +                       opp = opp_find_freq_floor(dev, freq);
> +       }
> +
>        return opp;
>  }
>
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 590d686..1a361e9 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -619,13 +619,19 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
>        return err;
>  }
>
> -static int exynos4_bus_target(struct device *dev, unsigned long *_freq)
> +static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
> +                             u32 flags)
>  {
>        int err = 0;
> -       struct busfreq_data *data = dev_get_drvdata(dev);
> -       struct opp *opp = devfreq_recommended_opp(dev, _freq);
> -       unsigned long old_freq = opp_get_freq(data->curr_opp);
> +       struct platform_device *pdev = container_of(dev, struct platform_device,
> +                                                   dev);
> +       struct busfreq_data *data = platform_get_drvdata(pdev);
> +       struct opp *opp = devfreq_recommended_opp(dev, _freq, flags);
>        unsigned long freq = opp_get_freq(opp);
> +       unsigned long old_freq = opp_get_freq(data->curr_opp);
> +
> +       if (IS_ERR(opp))
> +               return PTR_ERR(opp);
>
>        if (old_freq == freq)
>                return 0;
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 5862475..281c72a 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -44,6 +44,14 @@ struct devfreq_dev_status {
>        void *private_data;
>  };
>
> +/*
> + * The resulting frequency should be at most this. (this bound is the
> + * least upper bound; thus, the resulting freq should be lower or same)
> + * If the flag is not set, the resulting frequency should be at most the
> + * bound (greatest lower bound)
> + */
> +#define DEVFREQ_FLAG_LEAST_UPPER_BOUND         0x1
> +
>  /**
>  * struct devfreq_dev_profile - Devfreq's user device profile
>  * @initial_freq       The operating frequency when devfreq_add_device() is
> @@ -54,6 +62,8 @@ struct devfreq_dev_status {
>  *                     higher than any operable frequency, set maximum.
>  *                     Before returning, target function should set
>  *                     freq at the current frequency.
> + *                     The "flags" parameter's possible values are
> + *                     explained above with "DEVFREQ_FLAG_*" macros.
>  * @get_dev_status     The device should provide the current performance
>  *                     status to devfreq, which is used by governors.
>  * @exit               An optional callback that is called when devfreq
> @@ -66,7 +76,7 @@ struct devfreq_dev_profile {
>        unsigned long initial_freq;
>        unsigned int polling_ms;
>
> -       int (*target)(struct device *dev, unsigned long *freq);
> +       int (*target)(struct device *dev, unsigned long *freq, u32 flags);
>        int (*get_dev_status)(struct device *dev,
>                              struct devfreq_dev_status *stat);
>        void (*exit)(struct device *dev);
> @@ -165,7 +175,7 @@ extern int devfreq_remove_device(struct devfreq *devfreq);
>
>  /* Helper functions for devfreq user device driver with OPP. */
>  extern struct opp *devfreq_recommended_opp(struct device *dev,
> -                                          unsigned long *freq);
> +                                          unsigned long *freq, u32 flags);
>  extern int devfreq_register_opp_notifier(struct device *dev,
>                                         struct devfreq *devfreq);
>  extern int devfreq_unregister_opp_notifier(struct device *dev,
> @@ -216,7 +226,7 @@ static int devfreq_remove_device(struct devfreq *devfreq)
>  }
>
>  static struct opp *devfreq_recommended_opp(struct device *dev,
> -                                          unsigned long *freq)
> +                                          unsigned long *freq, u32 flags)
>  {
>        return -EINVAL;
>  }
> --
> 1.7.4.1
>
