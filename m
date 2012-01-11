Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab2AKWvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:51:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2AKWvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:51:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] PM / devfreq: add min/max_freq limit requested by users.
Date: Wed, 11 Jan 2012 23:54:25 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, Mike Turquette <mturquette@ti.com>,
        myungjoo.ham@gmail.com
References: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201112354.26127.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 11, 2012, MyungJoo Ham wrote:
> The frequency requested to devfreq device driver from devfreq governors
> is restricted by min_freq and max_freq input.

Can you please give us a bit more information about why this change is
necessary or desirable?

Rafael


> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/devfreq/devfreq.c                 |   70 +++++++++++++++++++++++++++++
>  drivers/devfreq/governor_performance.c    |    5 ++-
>  drivers/devfreq/governor_powersave.c      |    2 +-
>  drivers/devfreq/governor_simpleondemand.c |   12 ++++-
>  drivers/devfreq/governor_userspace.c      |   15 +++++-
>  include/linux/devfreq.h                   |    5 ++
>  6 files changed, 101 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 59d24e9..358d129 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -502,12 +502,82 @@ static ssize_t show_central_polling(struct device *dev,
>  		       !to_devfreq(dev)->governor->no_central_polling);
>  }
>  
> +static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	struct devfreq *df = to_devfreq(dev);
> +	unsigned long value;
> +	int ret;
> +	unsigned long max;
> +
> +	ret = sscanf(buf, "%lu", &value);
> +	if (ret != 1)
> +		goto out;
> +
> +	mutex_lock(&df->lock);
> +	max = df->max_freq;
> +	if (value && max && value > max) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	df->min_freq = value;
> +	update_devfreq(df);
> +	ret = count;
> +unlock:
> +	mutex_unlock(&df->lock);
> +out:
> +	return ret;
> +}
> +
> +static ssize_t show_min_freq(struct device *dev, struct device_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%lu\n", to_devfreq(dev)->min_freq);
> +}
> +
> +static ssize_t store_max_freq(struct device *dev, struct device_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	struct devfreq *df = to_devfreq(dev);
> +	unsigned long value;
> +	int ret;
> +	unsigned long min;
> +
> +	ret = sscanf(buf, "%lu", &value);
> +	if (ret != 1)
> +		goto out;
> +
> +	mutex_lock(&df->lock);
> +	min = df->min_freq;
> +	if (value && min && value < min) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	df->max_freq = value;
> +	update_devfreq(df);
> +	ret = count;
> +unlock:
> +	mutex_unlock(&df->lock);
> +out:
> +	return ret;
> +}
> +
> +static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%lu\n", to_devfreq(dev)->max_freq);
> +}
> +
>  static struct device_attribute devfreq_attrs[] = {
>  	__ATTR(governor, S_IRUGO, show_governor, NULL),
>  	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
>  	__ATTR(central_polling, S_IRUGO, show_central_polling, NULL),
>  	__ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
>  	       store_polling_interval),
> +	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
> +	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
>  	{ },
>  };
>  
> diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
> index c0596b2..574a06b 100644
> --- a/drivers/devfreq/governor_performance.c
> +++ b/drivers/devfreq/governor_performance.c
> @@ -18,7 +18,10 @@ static int devfreq_performance_func(struct devfreq *df,
>  	 * target callback should be able to get floor value as
>  	 * said in devfreq.h
>  	 */
> -	*freq = UINT_MAX;
> +	if (!df->max_freq)
> +		*freq = UINT_MAX;
> +	else
> +		*freq = df->max_freq;
>  	return 0;
>  }
>  
> diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
> index 2483a85..d742d4a 100644
> --- a/drivers/devfreq/governor_powersave.c
> +++ b/drivers/devfreq/governor_powersave.c
> @@ -18,7 +18,7 @@ static int devfreq_powersave_func(struct devfreq *df,
>  	 * target callback should be able to get ceiling value as
>  	 * said in devfreq.h
>  	 */
> -	*freq = 0;
> +	*freq = df->min_freq;
>  	return 0;
>  }
>  
> diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
> index efad8dc..a2e3eae 100644
> --- a/drivers/devfreq/governor_simpleondemand.c
> +++ b/drivers/devfreq/governor_simpleondemand.c
> @@ -25,6 +25,7 @@ static int devfreq_simple_ondemand_func(struct devfreq *df,
>  	unsigned int dfso_upthreshold = DFSO_UPTHRESHOLD;
>  	unsigned int dfso_downdifferential = DFSO_DOWNDIFFERENCTIAL;
>  	struct devfreq_simple_ondemand_data *data = df->data;
> +	unsigned long max = (df->max_freq) ? df->max_freq : UINT_MAX;
>  
>  	if (err)
>  		return err;
> @@ -41,7 +42,7 @@ static int devfreq_simple_ondemand_func(struct devfreq *df,
>  
>  	/* Assume MAX if it is going to be divided by zero */
>  	if (stat.total_time == 0) {
> -		*freq = UINT_MAX;
> +		*freq = max;
>  		return 0;
>  	}
>  
> @@ -54,13 +55,13 @@ static int devfreq_simple_ondemand_func(struct devfreq *df,
>  	/* Set MAX if it's busy enough */
>  	if (stat.busy_time * 100 >
>  	    stat.total_time * dfso_upthreshold) {
> -		*freq = UINT_MAX;
> +		*freq = max;
>  		return 0;
>  	}
>  
>  	/* Set MAX if we do not know the initial frequency */
>  	if (stat.current_frequency == 0) {
> -		*freq = UINT_MAX;
> +		*freq = max;
>  		return 0;
>  	}
>  
> @@ -79,6 +80,11 @@ static int devfreq_simple_ondemand_func(struct devfreq *df,
>  	b = div_u64(b, (dfso_upthreshold - dfso_downdifferential / 2));
>  	*freq = (unsigned long) b;
>  
> +	if (df->min_freq && *freq < df->min_freq)
> +		*freq = df->min_freq;
> +	if (df->max_freq && *freq > df->max_freq)
> +		*freq = df->max_freq;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
> index 4f8b563..0681246 100644
> --- a/drivers/devfreq/governor_userspace.c
> +++ b/drivers/devfreq/governor_userspace.c
> @@ -25,10 +25,19 @@ static int devfreq_userspace_func(struct devfreq *df, unsigned long *freq)
>  {
>  	struct userspace_data *data = df->data;
>  
> -	if (!data->valid)
> +	if (data->valid) {
> +		unsigned long adjusted_freq = data->user_frequency;
> +
> +		if (df->max_freq && adjusted_freq > df->max_freq)
> +			adjusted_freq = df->max_freq;
> +
> +		if (df->min_freq && adjusted_freq < df->min_freq)
> +			adjusted_freq = df->min_freq;
> +
> +		*freq = adjusted_freq;
> +	} else {
>  		*freq = df->previous_freq; /* No user freq specified yet */
> -	else
> -		*freq = data->user_frequency;
> +	}
>  	return 0;
>  }
>  
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 98ce812..e9385bf 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -124,6 +124,8 @@ struct devfreq_governor {
>   *		touch this.
>   * @being_removed	a flag to mark that this object is being removed in
>   *			order to prevent trying to remove the object multiple times.
> + * @min_freq	Limit minimum frequency requested by user (0: none)
> + * @max_freq	Limit maximum frequency requested by user (0: none)
>   *
>   * This structure stores the devfreq information for a give device.
>   *
> @@ -149,6 +151,9 @@ struct devfreq {
>  	void *data; /* private data for governors */
>  
>  	bool being_removed;
> +
> +	unsigned long min_freq;
> +	unsigned long max_freq;
>  };
>  
>  #if defined(CONFIG_PM_DEVFREQ)
> 

