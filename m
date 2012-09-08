Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2IHWNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:13:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab2IHWNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:13:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v3 1/2] PM / devfreq: add global PM QoS support
Date: Sun, 9 Sep 2012 00:20:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com, kyungmin.park@samsung.com, khilman@ti.com,
        markgross@thegnar.org, jean.pihet@newoldbits.com, mturquette@ti.com,
        jonghwa3.lee@samsung.com
References: <1346317203-7357-1-git-send-email-myungjoo.ham@samsung.com> <1346317203-7357-2-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1346317203-7357-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209090020.01038.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 30, 2012, MyungJoo Ham wrote:
> Even if the performance of a device is controlled properly with devfreq,
> sometimes, we still need to get PM-QoS inputs in order to meet the
> required performance.
> 
> In our testbed of Exynos4412, which has on-chip various DMA devices, the
> memory interface and system bus are controlled according to their
> utilization by devfreq. However, in some multimedia applications
> including video-playing with MFC (multi-function codec) H/W and
> photo/video-capturing with FIMC H/W, we have observed issues due to
> insufficient DMA throughput or latency.
> 
> In such applications, there are deadlines: less than 16.6ms with 60Hz.
> With shorter polling intervals (5 ~ 15ms), the frequencies fluctuate
> within a frame and we get missing frames and distorted pictures.
> With longer polling intervals (20 ~ 100ms), the response time is not
> sufficient and we get distorted or broken images. In other words,
> regardless of polling interval, we get poor results with hard-deadline
> H/Ws. They, in fact, have a preset requirement on DMA throughput.
> 
> Thus, we need PM-QoS capabilities in devfreq. (Note that for general
> user applications, devfreq for bus/memory works fine. They are not so
> sensitive to tens of ms in performance increasing responses in general.
> 
> In order to express how to handle QoS requests in devfreq devices,
> the devfreq device drivers only need to express the mappings of
> QoS value and frequency pairs with QoS class along with
> devfreq_add_device() call.
> 
> As a side effect of the implementation, which happens to be positive,
> min/max freq is now enforced regardless of governor implementation.

Can you please explain in a few words how this is supposed to work in
practice?

> Tested on Exynos4412 machines with memory/bus frequencies and multimedia
> H/W blocks. (camera, video decoding, and video encoding)
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I'm not entirely convinced yet, but a few comments follow.

> ---
> Changed from V2-resend
> - Removed dependencies on global pm-qos class definitions
> - Revised data structure handling pm-qos (being ready for dev-pm-qos)
> 
> Changes from V2
> - Rebased
> 
> Changes from V1
> - Error handling at devfreq_add_device()
> - Handling pm_qos_max information
> - Styly update
> ---
>  drivers/devfreq/devfreq.c |  127 +++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/devfreq.h   |   41 ++++++++++++++
>  2 files changed, 164 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 00e326c..d74b382 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -25,6 +25,7 @@
>  #include <linux/list.h>
>  #include <linux/printk.h>
>  #include <linux/hrtimer.h>
> +#include <linux/pm_qos.h>
>  #include "governor.h"
>  
>  static struct class *devfreq_class;
> @@ -136,8 +137,13 @@ int update_devfreq(struct devfreq *devfreq)
>  	 * List from the highest proiority
>  	 * max_freq (probably called by thermal when it's too hot)
>  	 * min_freq
> +	 * qos_min_freq
>  	 */
>  
> +	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
> +		freq = devfreq->qos_min_freq;
> +		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */

What exactly is the purpose of this last line?

> +	}
>  	if (devfreq->min_freq && freq < devfreq->min_freq) {
>  		freq = devfreq->min_freq;
>  		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> @@ -164,12 +170,12 @@ int update_devfreq(struct devfreq *devfreq)
>   * devfreq_notifier_call() - Notify that the device frequency requirements
>   *			   has been changed out of devfreq framework.
>   * @nb		the notifier_block (supposed to be devfreq->nb)
> - * @type	not used
> + * @val		not used.
>   * @devp	not used
>   *
>   * Called by a notifier that uses devfreq->nb.
>   */
> -static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
> +static int devfreq_notifier_call(struct notifier_block *nb, unsigned long val,
>  				 void *devp)
>  {
>  	struct devfreq *devfreq = container_of(nb, struct devfreq, nb);

The above change is only a cleanup unrelated to the rest of modifications.
Please push it separately (if you _really_ think it's necessary).

> @@ -183,6 +189,49 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
>  }
>  
>  /**
> + * devfreq_qos_notifier_call() -

This looks like a missing kerneldoc comment?

> + */
> +static int devfreq_qos_notifier_call(struct notifier_block *nb,
> +				     unsigned long value, void *devp)
> +{
> +	struct devfreq *devfreq = container_of(nb, struct devfreq, qos_nb);
> +	int ret;
> +	int i;
> +	s32 default_value = PM_QOS_DEFAULT_VALUE;
> +	struct devfreq_pm_qos_table *qos_list = devfreq->profile->qos_list;
> +	bool qos_use_max = devfreq->profile->qos_use_max;
> +
> +	if (!qos_list)
> +		return NOTIFY_DONE;
> +
> +	mutex_lock(&devfreq->lock);
> +
> +	if (value == default_value) {
> +		devfreq->qos_min_freq = 0;
> +		goto update;
> +	}
> +
> +	for (i = 0; qos_list[i].freq; i++) {
> +		/* QoS Met */
> +		if ((qos_use_max && qos_list[i].qos_value >= value) ||
> +		    (!qos_use_max && qos_list[i].qos_value <= value)) {
> +			devfreq->qos_min_freq = qos_list[i].freq;
> +			goto update;
> +		}

What about:

if (qos_use_max) {
	if (qos_list[i].qos_value < value)
		continue;
} else {
	if (qos_list[i].qos_value > value)
		continue;
}
devfreq->qos_min_freq = qos_list[i].freq;
goto update;

> +	}
> +
> +	/* Use the highest QoS freq */
> +	if (i > 0)

Given the sanity checks in devfreq_add_device(), this is always true.
So perhaps you don't even need the "update" label?

> +		devfreq->qos_min_freq = qos_list[i - 1].freq;
> +
> +update:
> +	ret = update_devfreq(devfreq);
> +	mutex_unlock(&devfreq->lock);
> +
> +	return ret;
> +}
> +
> +/**
>   * _remove_devfreq() - Remove devfreq from the device.
>   * @devfreq:	the devfreq struct
>   * @skip:	skip calling device_unregister().
> @@ -219,6 +268,10 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
>  
>  	devfreq->being_removed = true;
>  
> +	if (devfreq->profile->qos_type)
> +		pm_qos_remove_notifier(devfreq->profile->qos_type,
> +				       &devfreq->qos_nb);
> +
>  	if (devfreq->profile->exit)
>  		devfreq->profile->exit(devfreq->dev.parent);
>  
> @@ -390,7 +443,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  				   void *data)
>  {
>  	struct devfreq *devfreq;
> -	int err = 0;
> +	int err = 0, i;
>  
>  	if (!dev || !profile || !governor) {
>  		dev_err(dev, "%s: Invalid parameters.\n", __func__);
> @@ -429,6 +482,61 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  	devfreq->next_polling = devfreq->polling_jiffies
>  			      = msecs_to_jiffies(devfreq->profile->polling_ms);
>  	devfreq->nb.notifier_call = devfreq_notifier_call;
> +	devfreq->qos_nb.notifier_call = devfreq_qos_notifier_call;
> +
> +	/* Check the sanity of qos_list/qos_type */

Any chance to move the sanity checks below to a separate function?

> +	if (profile->qos_type || profile->qos_list) {
> +
> +		if (WARN(!profile->qos_type || !profile->qos_list,
> +			 "QoS requirement partially omitted for %s.\n",
> +			 dev_name(dev))) {
> +
> +			err = -EINVAL;
> +			goto err_dev;
> +		}
> +
> +		if (WARN(!profile->qos_list[0].freq,
> +			 "The first QoS requirement is the end of list for %s.\n",
> +			 dev_name(dev))) {
> +
> +			err = -EINVAL;
> +			goto err_dev;
> +		}
> +
> +		for (i = 1; profile->qos_list[i].freq; i++) {
> +			if (WARN(profile->qos_list[i].freq <=
> +				 profile->qos_list[i - 1].freq,
> +				 "%s's qos_list[].freq not sorted in the ascending order. ([%d]=%lu, [%d]=%lu)\n",
> +				 dev_name(dev), i - 1,
> +				 profile->qos_list[i - 1].freq, i,
> +				 profile->qos_list[i].freq)) {
> +
> +				err = -EINVAL;
> +				goto err_dev;
> +			}
> +
> +			/*
> +			 * If QoS type is throughput(PM_QOS_MAX)-like, qos_value
> +			 * should be sorted in the ascending order.
> +			 * If QoS type is latency(PM_QOS_MIN)-like, qos_value
> +			 * should be sorted in the descending order.
> +			 */
> +			if (WARN((profile->qos_use_max &&
> +				  profile->qos_list[i - 1].qos_value >
> +				  profile->qos_list[i].qos_value) ||
> +				 (!profile->qos_use_max &&
> +				  profile->qos_list[i - 1].qos_value <
> +				  profile->qos_list[i].qos_value),
> +				 "%s's qos_list[].qos_value is not sorted according to its QoS class.\n",
> +				 dev_name(dev))) {
> +
> +				err = -EINVAL;
> +				goto err_dev;
> +			}
> +		}
> +
> +		pm_qos_add_notifier(profile->qos_type, &devfreq->qos_nb);

What QoS types do you think could be used here?

> +	}
>  
>  	devfreq->trans_table =	devm_kzalloc(dev, sizeof(unsigned int) *
>  						devfreq->profile->max_state *
> @@ -443,7 +551,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  	err = device_register(&devfreq->dev);
>  	if (err) {
>  		put_device(&devfreq->dev);
> -		goto err_dev;
> +		goto err_qos_add;
>  	}
>  
>  	if (governor->init)
> @@ -471,6 +579,9 @@ out:
>  
>  err_init:
>  	device_unregister(&devfreq->dev);
> +err_qos_add:
> +	if (profile->qos_type || profile->qos_list)
> +		pm_qos_remove_notifier(profile->qos_type, &devfreq->qos_nb);
>  err_dev:
>  	mutex_unlock(&devfreq->lock);
>  	kfree(devfreq);
> @@ -568,6 +679,13 @@ static ssize_t show_central_polling(struct device *dev,
>  		       !to_devfreq(dev)->governor->no_central_polling);
>  }
>  
> +static ssize_t show_qos_min_freq(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	return sprintf(buf, "%lu\n", to_devfreq(dev)->qos_min_freq);
> +}
> +
>  static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
>  			      const char *buf, size_t count)
>  {
> @@ -685,6 +803,7 @@ static struct device_attribute devfreq_attrs[] = {
>  	       store_polling_interval),
>  	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
>  	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
> +	__ATTR(qos_min_freq, S_IRUGO, show_qos_min_freq, NULL),
>  	__ATTR(trans_stat, S_IRUGO, show_trans_table, NULL),
>  	{ },
>  };
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 30dc0d8..d11db17 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -53,6 +53,21 @@ struct devfreq_dev_status {
>  #define DEVFREQ_FLAG_LEAST_UPPER_BOUND		0x1
>  
>  /**
> + * struct devfreq_pm_qos_table - An PM QoS requiement entry for devfreq dev.
> + * @freq		Lowest frequency to meet the QoS requirement
> + *			represented by qos_value. If freq=0, it means that
> + *			this element is the last in the array.
> + * @qos_value		The qos value defined in pm_qos_params.h

pm_qos_params.h doesn't exist any more.  pm_qos.h only defines default values,
so the meaning of the comment is kind of unclear.

> + *
> + * Note that the array of devfreq_pm_qos_table should be sorted by freq
> + * in the ascending order except for the last element, which should be 0.
> + */
> +struct devfreq_pm_qos_table {
> +	unsigned long freq; /* 0 if this is the last element */
> +	s32 qos_value;
> +};

I like the idea of translating QoS values into frequencies.  However, I don't
think it's always possible to figure out how a given global PM QoS value
translates into a specific range of frequencies for the given devfreq
structure.

What method in particular did you use on your test system?

> +
> +/**
>   * struct devfreq_dev_profile - Devfreq's user device profile
>   * @initial_freq	The operating frequency when devfreq_add_device() is
>   *			called.
> @@ -71,11 +86,33 @@ struct devfreq_dev_status {
>   *			from devfreq_remove_device() call. If the user
>   *			has registered devfreq->nb at a notifier-head,
>   *			this is the time to unregister it.
> + * @qos_type		QoS Type (defined in pm_qos_params.h)
> + *			0 (PM_QOS_RESERVED) if not used.
> + * @qos_use_max		True: the highest QoS value is used (for QoS
> + *			requirement of throughput, bandwidth, or similar)
> + *			False: the lowest QoS value is used (for QoS
> + *			requirement of latency, delay, or similar)
> + * @enable_dev_pm_qos	dev_pm_qos is enabled using the qos_list.
> + * @qos_list		Array of QoS requirements ending with .freq = 0
> + *			NULL if not used. It should be either NULL or
> + *			have a length > 1 with a first element effective.
> + *			This QoS specification is shared by the global
> + *			PM QoS (qos_type) and the per-dev PM QoS
> + *			(enable_dev_pm_qos).
> + *
> + * Note that the array of qos_list should be sorted by freq
> + * in the ascending order.
>   */
>  struct devfreq_dev_profile {
>  	unsigned long initial_freq;
>  	unsigned int polling_ms;
>  
> +	/* Optional QoS Handling Specification */
> +	int qos_type; /* 0: No global PM-QoS support */
> +	bool qos_use_max; /* true if "bandwidth"/"throughput"-like values */
> +	bool enable_dev_pm_qos; /* False: No per-dev PM-QoS support */
> +	struct devfreq_pm_qos_table *qos_list; /* QoS handling specification */
> +
>  	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
>  	int (*get_dev_status)(struct device *dev,
>  			      struct devfreq_dev_status *stat);
> @@ -139,6 +176,8 @@ struct devfreq_governor {
>   *			order to prevent trying to remove the object multiple times.
>   * @min_freq	Limit minimum frequency requested by user (0: none)
>   * @max_freq	Limit maximum frequency requested by user (0: none)
> + * @qos_nb	notifier block used to notify pm qos requests
> + * @qos_min_freq	Limit minimum frequency requested by QoS
>   *
>   * This structure stores the devfreq information for a give device.
>   *
> @@ -167,6 +206,8 @@ struct devfreq {
>  
>  	unsigned long min_freq;
>  	unsigned long max_freq;
> +	struct notifier_block qos_nb;
> +	unsigned long qos_min_freq;
>  
>  	/* information for device freqeuncy transition */
>  	unsigned int total_trans;
> 

I think it would be better to fold [2/2] into [1/2] to avoid some unnecessary
code churn.

Thanks,
Rafael

