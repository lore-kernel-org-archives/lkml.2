Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2IJJNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:13:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45710 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2IJJNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:13:22 -0400
X-AuditID: cbfee610-b7f4f6d0000002b7-c8-504daf2d5909
Date: Mon, 10 Sep 2012 09:13:17 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/3] devfreq: core updates to support devices which can idle
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Cc: "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120910083934854@myungjoo.ham
Msgkey: 20120910083934854@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120910083934854@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <5560006.329151347268394545.JavaMail.weblogic@epml28>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t/tmbq6630DDDrWGVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mv1evsRTsWMZUsb1/C2MD45t5TF2MnBxCAuoSi5acZAOxJQRM
	JG4vmMMKYYtJXLi3HijOBVQzn1Hiyta9YAkWAVWJh/+WMXcxcnCwCZhL3J8RBBIWFgiQmLx3
	IwtIvYjAcUaJn5s/gC1gFnjGKHFuuwfEMiWJNftesYDYvAKCEidnPmGBWKYqsXrnJkaIuJrE
	2o1foI6QkJg1/QKUzSsxo/0pVL2cxLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zuYQO4E6X1y
	PxhmzO7NX6D+FZCYeuYgVKuWxM6DR6FsPok1C9+ywIzZdWo5M0zv/S1zod5SlJjS/ZAdwtaS
	+PJjHxu6t3gFHCXWXXzCNIFRbhaS1Cwk7bOQtCOrWcDIsopRNLUguaA4KT3VTK84Mbe4NC9d
	Lzk/dxMjONafCexgXNJgcYhRgINRiYfXK1wgQIg1say4MvcQowQHs5IIr0ifb4AQb0piZVVq
	UX58UWlOavEhRmkOFiVx3tkvvvgLCaQnlqRmp6YWpBbBZJk4OKUaGH2Xua3b7LmAf7fCVMsr
	59U4pbYk92u9Ob85rNvXw+fqjKbgDO+n8g0TdlcZ3Sn7X6DQ4PzQy7PDQLaZ6+3K3jLjmtqT
	2q7npihJn2X9f9BenG96H7tGp7N378FA7eCEbUbx0ydckJrw8sCl3e7S98I2Lo/OWn3x0PEV
	pyTe7EuL3eW1358hWomlOCPRUIu5qDgRAKCf54nxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8A9DVCC016899

> Prepare devfreq core framework to support devices which
> can idle. When device idleness is detected perhaps through
> runtime-pm, need some mechanism to suspend devfreq load
> monitoring and resume back when device is online. Present
> code continues monitoring unless device is removed from
> devfreq core.
> 
> This patch introduces following design changes,
> 
> - use per device work instead of global work to monitor device
>   load. This enables suspend/resume of device devfreq and
>   reduces monitoring code complexity.
> - decouple delayed work based load monitoring logic from core
>   by introducing helpers functions to be used by governors. This
>   provides flexibility for governors either to use delayed work
>   based monitoring functions or to implement their own mechanism.
> - devfreq core interacts with governors via events to perform
>   specific actions. These events include start/stop devfreq.
>   This sets ground for adding suspend/resume events.
> 
> The devfreq apis are not modified and are kept intact.

Hello,

Please revise locking mechanism along with event handler.

It appears that we need to do mutex_lock(&devfreq->lock) before calling devfreq->governor->event_handler();
Or at least, userspace_init and userspace_exit functions require mutex_lock.
Event_handler callback won't want the properties in devfreq to be changed externally during its execution.

Plus, please edit Documentation/ABI entry (central_polling is being removed)

Other than that, it looks fine.

Cheers!
MyungJoo

> 
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> ---
>  drivers/devfreq/devfreq.c                 | 376 ++++++++++--------------------
>  drivers/devfreq/governor.h                |   9 +
>  drivers/devfreq/governor_performance.c    |  16 +-
>  drivers/devfreq/governor_powersave.c      |  16 +-
>  drivers/devfreq/governor_simpleondemand.c |  33 +++
>  drivers/devfreq/governor_userspace.c      |  23 +-
>  include/linux/devfreq.h                   |  31 +--
>  7 files changed, 220 insertions(+), 284 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index b146d76..be524c7 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -30,17 +30,11 @@
>  struct class *devfreq_class;
>  
>  /*
> - * devfreq_work periodically monitors every registered device.
> - * The minimum polling interval is one jiffy. The polling interval is
> - * determined by the minimum polling period among all polling devfreq
> - * devices. The resolution of polling interval is one jiffy.
> + * devfreq core provides delayed work based load monitoring helper
> + * functions. Governors can use these or can implement their own
> + * monitoring mechanism.
>   */
> -static bool polling;
>  static struct workqueue_struct *devfreq_wq;
> -static struct delayed_work devfreq_work;
> -
> -/* wait removing if this is to be removed */
> -static struct devfreq *wait_remove_device;
>  
>  /* The list of all device-devfreq */
>  static LIST_HEAD(devfreq_list);
> @@ -72,6 +66,8 @@ static struct devfreq *find_device_devfreq(struct device *dev)
>  	return ERR_PTR(-ENODEV);
>  }
>  
> +/* Load monitoring helper functions for governors use */
> +
>  /**
>   * update_devfreq() - Reevaluate the device and configure frequency.
>   * @devfreq:	the devfreq instance.
> @@ -121,6 +117,90 @@ int update_devfreq(struct devfreq *devfreq)
>  }
>  
>  /**
> + * devfreq_monitor() - Periodically poll devfreq objects.
> + * @work: the work struct used to run devfreq_monitor periodically.
> + *
> + */
> +static void devfreq_monitor(struct work_struct *work)
> +{
> +	int err;
> +	struct devfreq *devfreq = container_of(work,
> +					struct devfreq, work.work);
> +
> +	mutex_lock(&devfreq->lock);
> +	err = update_devfreq(devfreq);
> +	mutex_unlock(&devfreq->lock);
> +	if (err)
> +		dev_err(&devfreq->dev, "dvfs failed with (%d) error\n", err);
> +
> +	queue_delayed_work(devfreq_wq, &devfreq->work,
> +				msecs_to_jiffies(devfreq->profile->polling_ms));
> +}
> +
> +/**
> + * devfreq_monitor_start() - Start load monitoring of devfreq instance
> + *			using default delayed work
> + * @devfreq:	the devfreq instance.
> + *
> + * Returns 0 if monitoring started, non-zero otherwise.
> + * Note: This function is exported for governors.
> + */
> +int devfreq_monitor_start(struct devfreq *devfreq)
> +{
> +	INIT_DEFERRABLE_WORK(&devfreq->work, devfreq_monitor);
> +	return !queue_delayed_work(devfreq_wq, &devfreq->work,
> +			msecs_to_jiffies(devfreq->profile->polling_ms));
> +}
> +
> +/**
> + * devfreq_monitor_stop() - Stop load monitoring of a devfreq instance
> + * @devfreq:	the devfreq instance.
> + *
> + * Note: This function is exported for governors.
> + */
> +void devfreq_monitor_stop(struct devfreq *devfreq)
> +{
> +	cancel_delayed_work_sync(&devfreq->work);
> +}
> +
> +/**
> + * devfreq_monitor_suspend() - Suspend load monitoring of a devfreq instance
> + * @devfreq:    the devfreq instance.
> + *
> + * Note: This function is exported for governors.
> + */
> +int devfreq_monitor_suspend(struct devfreq *devfreq)
> +{
> +	int ret = -EPERM;
> +
> +	if (delayed_work_pending(&devfreq->work)) {
> +		cancel_delayed_work_sync(&devfreq->work);
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * devfreq_monitor_resume() - Resume load monitoring of a devfreq instance
> + * @devfreq:    the devfreq instance.
> + *
> + * Returns 0 if monitoring re-started, non-zero otherwise.
> + * Note: This function is exported for governors.
> + */
> +int devfreq_monitor_resume(struct devfreq *devfreq)
> +{
> +	int ret = -EPERM;
> +
> +	if (!delayed_work_pending(&devfreq->work)) {
> +		ret = !queue_delayed_work(devfreq_wq, &devfreq->work,
> +				msecs_to_jiffies(devfreq->profile->polling_ms));
> +	}
> +
> +	return ret;
> +}
> +
> +/**
>   * devfreq_notifier_call() - Notify that the device frequency requirements
>   *			   has been changed out of devfreq framework.
>   * @nb		the notifier_block (supposed to be devfreq->nb)
> @@ -143,59 +223,33 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
>  }
>  
>  /**
> - * _remove_devfreq() - Remove devfreq from the device.
> + * _remove_devfreq() - Remove devfreq from the devfreq list and
> +		release its resources.
>   * @devfreq:	the devfreq struct
>   * @skip:	skip calling device_unregister().
> - *
> - * Note that the caller should lock devfreq->lock before calling
> - * this. _remove_devfreq() will unlock it and free devfreq
> - * internally. devfreq_list_lock should be locked by the caller
> - * as well (not relased at return)
> - *
> - * Lock usage:
> - * devfreq->lock: locked before call.
> - *		  unlocked at return (and freed)
> - * devfreq_list_lock: locked before call.
> - *		      kept locked at return.
> - *		      if devfreq is centrally polled.
> - *
> - * Freed memory:
> - * devfreq
>   */
>  static void _remove_devfreq(struct devfreq *devfreq, bool skip)
>  {
> -	if (!mutex_is_locked(&devfreq->lock)) {
> -		WARN(true, "devfreq->lock must be locked by the caller.\n");
> -		return;
> -	}
> -	if (!devfreq->governor->no_central_polling &&
> -	    !mutex_is_locked(&devfreq_list_lock)) {
> -		WARN(true, "devfreq_list_lock must be locked by the caller.\n");
> +	mutex_lock(&devfreq_list_lock);
> +	if (IS_ERR(find_device_devfreq(devfreq->dev.parent))) {
> +		mutex_unlock(&devfreq_list_lock);
> +		dev_warn(&devfreq->dev, "releasing devfreq which doesn't exist\n");
>  		return;
>  	}
> +	list_del(&devfreq->node);
> +	mutex_unlock(&devfreq_list_lock);
>  
> -	if (devfreq->being_removed)
> -		return;
> -
> -	devfreq->being_removed = true;
> +	devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_STOP);
>  
>  	if (devfreq->profile->exit)
>  		devfreq->profile->exit(devfreq->dev.parent);
>  
> -	if (devfreq->governor->exit)
> -		devfreq->governor->exit(devfreq);
> -
>  	if (!skip && get_device(&devfreq->dev)) {
>  		device_unregister(&devfreq->dev);
>  		put_device(&devfreq->dev);
>  	}
>  
> -	if (!devfreq->governor->no_central_polling)
> -		list_del(&devfreq->node);
> -
> -	mutex_unlock(&devfreq->lock);
>  	mutex_destroy(&devfreq->lock);
> -
>  	kfree(devfreq);
>  }
>  
> @@ -210,130 +264,8 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
>  static void devfreq_dev_release(struct device *dev)
>  {
>  	struct devfreq *devfreq = to_devfreq(dev);
> -	bool central_polling = !devfreq->governor->no_central_polling;
> -
> -	/*
> -	 * If devfreq_dev_release() was called by device_unregister() of
> -	 * _remove_devfreq(), we cannot mutex_lock(&devfreq->lock) and
> -	 * being_removed is already set. This also partially checks the case
> -	 * where devfreq_dev_release() is called from a thread other than
> -	 * the one called _remove_devfreq(); however, this case is
> -	 * dealt completely with another following being_removed check.
> -	 *
> -	 * Because being_removed is never being
> -	 * unset, we do not need to worry about race conditions on
> -	 * being_removed.
> -	 */
> -	if (devfreq->being_removed)
> -		return;
> -
> -	if (central_polling)
> -		mutex_lock(&devfreq_list_lock);
> -
> -	mutex_lock(&devfreq->lock);
> -
> -	/*
> -	 * Check being_removed flag again for the case where
> -	 * devfreq_dev_release() was called in a thread other than the one
> -	 * possibly called _remove_devfreq().
> -	 */
> -	if (devfreq->being_removed) {
> -		mutex_unlock(&devfreq->lock);
> -		goto out;
> -	}
>  
> -	/* devfreq->lock is unlocked and removed in _removed_devfreq() */
>  	_remove_devfreq(devfreq, true);
> -
> -out:
> -	if (central_polling)
> -		mutex_unlock(&devfreq_list_lock);
> -}
> -
> -/**
> - * devfreq_monitor() - Periodically poll devfreq objects.
> - * @work: the work struct used to run devfreq_monitor periodically.
> - *
> - */
> -static void devfreq_monitor(struct work_struct *work)
> -{
> -	static unsigned long last_polled_at;
> -	struct devfreq *devfreq, *tmp;
> -	int error;
> -	unsigned long jiffies_passed;
> -	unsigned long next_jiffies = ULONG_MAX, now = jiffies;
> -	struct device *dev;
> -
> -	/* Initially last_polled_at = 0, polling every device at bootup */
> -	jiffies_passed = now - last_polled_at;
> -	last_polled_at = now;
> -	if (jiffies_passed == 0)
> -		jiffies_passed = 1;
> -
> -	mutex_lock(&devfreq_list_lock);
> -	list_for_each_entry_safe(devfreq, tmp, &devfreq_list, node) {
> -		mutex_lock(&devfreq->lock);
> -		dev = devfreq->dev.parent;
> -
> -		/* Do not remove tmp for a while */
> -		wait_remove_device = tmp;
> -
> -		if (devfreq->governor->no_central_polling ||
> -		    devfreq->next_polling == 0) {
> -			mutex_unlock(&devfreq->lock);
> -			continue;
> -		}
> -		mutex_unlock(&devfreq_list_lock);
> -
> -		/*
> -		 * Reduce more next_polling if devfreq_wq took an extra
> -		 * delay. (i.e., CPU has been idled.)
> -		 */
> -		if (devfreq->next_polling <= jiffies_passed) {
> -			error = update_devfreq(devfreq);
> -
> -			/* Remove a devfreq with an error. */
> -			if (error && error != -EAGAIN) {
> -
> -				dev_err(dev, "Due to update_devfreq error(%d), devfreq(%s) is removed from the device\n",
> -					error, devfreq->governor->name);
> -
> -				/*
> -				 * Unlock devfreq before locking the list
> -				 * in order to avoid deadlock with
> -				 * find_device_devfreq or others
> -				 */
> -				mutex_unlock(&devfreq->lock);
> -				mutex_lock(&devfreq_list_lock);
> -				/* Check if devfreq is already removed */
> -				if (IS_ERR(find_device_devfreq(dev)))
> -					continue;
> -				mutex_lock(&devfreq->lock);
> -				/* This unlocks devfreq->lock and free it */
> -				_remove_devfreq(devfreq, false);
> -				continue;
> -			}
> -			devfreq->next_polling = devfreq->polling_jiffies;
> -		} else {
> -			devfreq->next_polling -= jiffies_passed;
> -		}
> -
> -		if (devfreq->next_polling)
> -			next_jiffies = (next_jiffies > devfreq->next_polling) ?
> -					devfreq->next_polling : next_jiffies;
> -
> -		mutex_unlock(&devfreq->lock);
> -		mutex_lock(&devfreq_list_lock);
> -	}
> -	wait_remove_device = NULL;
> -	mutex_unlock(&devfreq_list_lock);
> -
> -	if (next_jiffies > 0 && next_jiffies < ULONG_MAX) {
> -		polling = true;
> -		queue_delayed_work(devfreq_wq, &devfreq_work, next_jiffies);
> -	} else {
> -		polling = false;
> -	}
>  }
>  
>  /**
> @@ -357,16 +289,13 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> -
> -	if (!governor->no_central_polling) {
> -		mutex_lock(&devfreq_list_lock);
> -		devfreq = find_device_devfreq(dev);
> -		mutex_unlock(&devfreq_list_lock);
> -		if (!IS_ERR(devfreq)) {
> -			dev_err(dev, "%s: Unable to create devfreq for the device. It already has one.\n", __func__);
> -			err = -EINVAL;
> -			goto err_out;
> -		}
> +	mutex_lock(&devfreq_list_lock);
> +	devfreq = find_device_devfreq(dev);
> +	mutex_unlock(&devfreq_list_lock);
> +	if (!IS_ERR(devfreq)) {
> +		dev_err(dev, "%s: Unable to create devfreq for the device. It already has one.\n", __func__);
> +		err = -EINVAL;
> +		goto err_out;
>  	}
>  
>  	devfreq = kzalloc(sizeof(struct devfreq), GFP_KERNEL);
> @@ -386,48 +315,40 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  	devfreq->governor = governor;
>  	devfreq->previous_freq = profile->initial_freq;
>  	devfreq->data = data;
> -	devfreq->next_polling = devfreq->polling_jiffies
> -			      = msecs_to_jiffies(devfreq->profile->polling_ms);
>  	devfreq->nb.notifier_call = devfreq_notifier_call;
>  
>  	dev_set_name(&devfreq->dev, dev_name(dev));
>  	err = device_register(&devfreq->dev);
>  	if (err) {
>  		put_device(&devfreq->dev);
> +		mutex_unlock(&devfreq->lock);
>  		goto err_dev;
>  	}
>  
> -	if (governor->init)
> -		err = governor->init(devfreq);
> -	if (err)
> -		goto err_init;
> -
>  	mutex_unlock(&devfreq->lock);
>  
> -	if (governor->no_central_polling)
> -		goto out;
> -
>  	mutex_lock(&devfreq_list_lock);
> -
>  	list_add(&devfreq->node, &devfreq_list);
> +	mutex_unlock(&devfreq_list_lock);
>  
> -	if (devfreq_wq && devfreq->next_polling && !polling) {
> -		polling = true;
> -		queue_delayed_work(devfreq_wq, &devfreq_work,
> -				   devfreq->next_polling);
> +	err = devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_START);
> +	if (err) {
> +		dev_err(dev, "%s: Unable to start governor for the device\n",
> +			__func__);
> +		goto err_init;
>  	}
> -	mutex_unlock(&devfreq_list_lock);
> -out:
> +
>  	return devfreq;
>  
>  err_init:
> +	list_del(&devfreq->node);
>  	device_unregister(&devfreq->dev);
>  err_dev:
> -	mutex_unlock(&devfreq->lock);
>  	kfree(devfreq);
>  err_out:
>  	return ERR_PTR(err);
>  }
> +EXPORT_SYMBOL(devfreq_add_device);
>  
>  /**
>   * devfreq_remove_device() - Remove devfreq feature from a device.
> @@ -435,30 +356,14 @@ err_out:
>   */
>  int devfreq_remove_device(struct devfreq *devfreq)
>  {
> -	bool central_polling;
> -
>  	if (!devfreq)
>  		return -EINVAL;
>  
> -	central_polling = !devfreq->governor->no_central_polling;
> -
> -	if (central_polling) {
> -		mutex_lock(&devfreq_list_lock);
> -		while (wait_remove_device == devfreq) {
> -			mutex_unlock(&devfreq_list_lock);
> -			schedule();
> -			mutex_lock(&devfreq_list_lock);
> -		}
> -	}
> -
> -	mutex_lock(&devfreq->lock);
> -	_remove_devfreq(devfreq, false); /* it unlocks devfreq->lock */
> -
> -	if (central_polling)
> -		mutex_unlock(&devfreq_list_lock);
> +	_remove_devfreq(devfreq, false);
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(devfreq_remove_device);
>  
>  static ssize_t show_governor(struct device *dev,
>  			     struct device_attribute *attr, char *buf)
> @@ -492,33 +397,15 @@ static ssize_t store_polling_interval(struct device *dev,
>  
>  	mutex_lock(&df->lock);
>  	df->profile->polling_ms = value;
> -	df->next_polling = df->polling_jiffies
> -			 = msecs_to_jiffies(value);
>  	mutex_unlock(&df->lock);
>  
> +	df->governor->event_handler(df, DEVFREQ_GOV_INTERVAL);
>  	ret = count;
>  
> -	if (df->governor->no_central_polling)
> -		goto out;
> -
> -	mutex_lock(&devfreq_list_lock);
> -	if (df->next_polling > 0 && !polling) {
> -		polling = true;
> -		queue_delayed_work(devfreq_wq, &devfreq_work,
> -				   df->next_polling);
> -	}
> -	mutex_unlock(&devfreq_list_lock);
>  out:
>  	return ret;
>  }
>  
> -static ssize_t show_central_polling(struct device *dev,
> -				    struct device_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%d\n",
> -		       !to_devfreq(dev)->governor->no_central_polling);
> -}
> -
>  static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
>  			      const char *buf, size_t count)
>  {
> @@ -590,7 +477,6 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
>  static struct device_attribute devfreq_attrs[] = {
>  	__ATTR(governor, S_IRUGO, show_governor, NULL),
>  	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
> -	__ATTR(central_polling, S_IRUGO, show_central_polling, NULL),
>  	__ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
>  	       store_polling_interval),
>  	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
> @@ -598,23 +484,6 @@ static struct device_attribute devfreq_attrs[] = {
>  	{ },
>  };
>  
> -/**
> - * devfreq_start_polling() - Initialize data structure for devfreq framework and
> - *			   start polling registered devfreq devices.
> - */
> -static int __init devfreq_start_polling(void)
> -{
> -	mutex_lock(&devfreq_list_lock);
> -	polling = false;
> -	devfreq_wq = create_freezable_workqueue("devfreq_wq");
> -	INIT_DEFERRABLE_WORK(&devfreq_work, devfreq_monitor);
> -	mutex_unlock(&devfreq_list_lock);
> -
> -	devfreq_monitor(&devfreq_work.work);
> -	return 0;
> -}
> -late_initcall(devfreq_start_polling);
> -
>  static int __init devfreq_init(void)
>  {
>  	devfreq_class = class_create(THIS_MODULE, "devfreq");
> @@ -622,7 +491,15 @@ static int __init devfreq_init(void)
>  		pr_err("%s: couldn't create class\n", __FILE__);
>  		return PTR_ERR(devfreq_class);
>  	}
> +
> +	devfreq_wq = create_freezable_workqueue("devfreq_wq");
> +	if (IS_ERR(devfreq_wq)) {
> +		class_destroy(devfreq_class);
> +		pr_err("%s: couldn't create workqueue\n", __FILE__);
> +		return PTR_ERR(devfreq_wq);
> +	}
>  	devfreq_class->dev_attrs = devfreq_attrs;
> +
>  	return 0;
>  }
>  subsys_initcall(devfreq_init);
> @@ -630,6 +507,7 @@ subsys_initcall(devfreq_init);
>  static void __exit devfreq_exit(void)
>  {
>  	class_destroy(devfreq_class);
> +	destroy_workqueue(devfreq_wq);
>  }
>  module_exit(devfreq_exit);
>  
> diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
> index ea7f13c..4a86af7 100644
> --- a/drivers/devfreq/governor.h
> +++ b/drivers/devfreq/governor.h
> @@ -18,7 +18,16 @@
>  
>  #define to_devfreq(DEV)	container_of((DEV), struct devfreq, dev)
>  
> +/* Devfreq events */
> +#define DEVFREQ_GOV_START			0x1
> +#define DEVFREQ_GOV_STOP			0x2
> +#define DEVFREQ_GOV_INTERVAL			0x3
> +
>  /* Caution: devfreq->lock must be locked before calling update_devfreq */
>  extern int update_devfreq(struct devfreq *devfreq);
>  
> +extern int devfreq_monitor_start(struct devfreq *devfreq);
> +extern void devfreq_monitor_stop(struct devfreq *devfreq);
> +extern int devfreq_monitor_suspend(struct devfreq *devfreq);
> +extern int devfreq_monitor_resume(struct devfreq *devfreq);
>  #endif /* _GOVERNOR_H */
> diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
> index af75ddd..b657eff 100644
> --- a/drivers/devfreq/governor_performance.c
> +++ b/drivers/devfreq/governor_performance.c
> @@ -26,14 +26,22 @@ static int devfreq_performance_func(struct devfreq *df,
>  	return 0;
>  }
>  
> -static int performance_init(struct devfreq *devfreq)
> +static int devfreq_performance_handler(struct devfreq *devfreq,
> +					unsigned int event)
>  {
> -	return update_devfreq(devfreq);
> +	int ret = 0;
> +
> +	if (event == DEVFREQ_GOV_START) {
> +		mutex_lock(&devfreq->lock);
> +		ret = update_devfreq(devfreq);
> +		mutex_unlock(&devfreq->lock);
> +	}
> +
> +	return ret;
>  }
>  
>  const struct devfreq_governor devfreq_performance = {
>  	.name = "performance",
> -	.init = performance_init,
>  	.get_target_freq = devfreq_performance_func,
> -	.no_central_polling = true,
> +	.event_handler = devfreq_performance_handler,
>  };
> diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
> index fec0cdb..daa5732 100644
> --- a/drivers/devfreq/governor_powersave.c
> +++ b/drivers/devfreq/governor_powersave.c
> @@ -23,14 +23,22 @@ static int devfreq_powersave_func(struct devfreq *df,
>  	return 0;
>  }
>  
> -static int powersave_init(struct devfreq *devfreq)
> +static int devfreq_powersave_handler(struct devfreq *devfreq,
> +					unsigned int event)
>  {
> -	return update_devfreq(devfreq);
> +	int ret = 0;
> +
> +	if (event == DEVFREQ_GOV_START) {
> +		mutex_lock(&devfreq->lock);
> +		ret = update_devfreq(devfreq);
> +		mutex_unlock(&devfreq->lock);
> +	}
> +
> +	return ret;
>  }
>  
>  const struct devfreq_governor devfreq_powersave = {
>  	.name = "powersave",
> -	.init = powersave_init,
>  	.get_target_freq = devfreq_powersave_func,
> -	.no_central_polling = true,
> +	.event_handler = devfreq_powersave_handler,
>  };
> diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
> index a2e3eae..9802bf9 100644
> --- a/drivers/devfreq/governor_simpleondemand.c
> +++ b/drivers/devfreq/governor_simpleondemand.c
> @@ -12,6 +12,7 @@
>  #include <linux/errno.h>
>  #include <linux/devfreq.h>
>  #include <linux/math64.h>
> +#include "governor.h"
>  
>  /* Default constants for DevFreq-Simple-Ondemand (DFSO) */
>  #define DFSO_UPTHRESHOLD	(90)
> @@ -88,7 +89,39 @@ static int devfreq_simple_ondemand_func(struct devfreq *df,
>  	return 0;
>  }
>  
> +int devfreq_simple_ondemand_handler(struct devfreq *devfreq,
> +					unsigned int event)
> +{
> +	int ret = 0;
> +
> +	switch (event) {
> +	case DEVFREQ_GOV_START:
> +		ret = devfreq_monitor_start(devfreq);
> +		break;
> +
> +	case DEVFREQ_GOV_STOP:
> +		devfreq_monitor_stop(devfreq);
> +		break;
> +
> +	case DEVFREQ_GOV_INTERVAL:
> +		/*
> +		 * if polling interval is set to zero, stop monitoring.
> +		 * otherwise resume load monitoring.
> +		 */
> +		if (!devfreq->profile->polling_ms)
> +			ret = devfreq_monitor_suspend(devfreq);
> +		else
> +			ret = devfreq_monitor_resume(devfreq);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  const struct devfreq_governor devfreq_simple_ondemand = {
>  	.name = "simple_ondemand",
>  	.get_target_freq = devfreq_simple_ondemand_func,
> +	.event_handler = devfreq_simple_ondemand_handler,
>  };
> diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
> index 0681246..c48fca0 100644
> --- a/drivers/devfreq/governor_userspace.c
> +++ b/drivers/devfreq/governor_userspace.c
> @@ -116,10 +116,27 @@ static void userspace_exit(struct devfreq *devfreq)
>  	devfreq->data = NULL;
>  }
>  
> +int devfreq_userspace_handler(struct devfreq *devfreq,
> +				unsigned int event)
> +{
> +	int ret = 0;
> +
> +	switch (event) {
> +	case DEVFREQ_GOV_START:
> +		ret = userspace_init(devfreq);
> +		break;
> +	case DEVFREQ_GOV_STOP:
> +		userspace_exit(devfreq);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  const struct devfreq_governor devfreq_userspace = {
>  	.name = "userspace",
>  	.get_target_freq = devfreq_userspace_func,
> -	.init = userspace_init,
> -	.exit = userspace_exit,
> -	.no_central_polling = true,
> +	.event_handler = devfreq_userspace_handler,
>  };
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 281c72a..7a11c3e 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -91,25 +91,17 @@ struct devfreq_dev_profile {
>   *			status of the device (load = busy_time / total_time).
>   *			If no_central_polling is set, this callback is called
>   *			only with update_devfreq() notified by OPP.
> - * @init		Called when the devfreq is being attached to a device
> - * @exit		Called when the devfreq is being removed from a
> - *			device. Governor should stop any internal routines
> - *			before return because related data may be
> - *			freed after exit().
> - * @no_central_polling	Do not use devfreq's central polling mechanism.
> - *			When this is set, devfreq will not call
> - *			get_target_freq with devfreq_monitor(). However,
> - *			devfreq will call get_target_freq with
> - *			devfreq_update() notified by OPP framework.
> + * @event_handler       Callback for devfreq core framework to notify events
> + *                      to governors. Events include per device governor
> + *                      init and exit, opp changes out of devfreq, suspend
> + *                      and resume of per device devfreq during device idle.
>   *
>   * Note that the callbacks are called with devfreq->lock locked by devfreq.
>   */
>  struct devfreq_governor {
>  	const char name[DEVFREQ_NAME_LEN];
>  	int (*get_target_freq)(struct devfreq *this, unsigned long *freq);
> -	int (*init)(struct devfreq *this);
> -	void (*exit)(struct devfreq *this);
> -	const bool no_central_polling;
> +	int (*event_handler)(struct devfreq *devfreq, unsigned int event);
>  };
>  
>  /**
> @@ -124,16 +116,10 @@ struct devfreq_governor {
>   * @nb		notifier block used to notify devfreq object that it should
>   *		reevaluate operable frequencies. Devfreq users may use
>   *		devfreq.nb to the corresponding register notifier call chain.
> - * @polling_jiffies	interval in jiffies.
> + * @work	delayed work for load monitoring.
>   * @previous_freq	previously configured frequency value.
> - * @next_polling	the number of remaining jiffies to poll with
> - *			"devfreq_monitor" executions to reevaluate
> - *			frequency/voltage of the device. Set by
> - *			profile's polling_ms interval.
>   * @data	Private data of the governor. The devfreq framework does not
>   *		touch this.
> - * @being_removed	a flag to mark that this object is being removed in
> - *			order to prevent trying to remove the object multiple times.
>   * @min_freq	Limit minimum frequency requested by user (0: none)
>   * @max_freq	Limit maximum frequency requested by user (0: none)
>   *
> @@ -153,15 +139,12 @@ struct devfreq {
>  	struct devfreq_dev_profile *profile;
>  	const struct devfreq_governor *governor;
>  	struct notifier_block nb;
> +	struct delayed_work work;
>  
> -	unsigned long polling_jiffies;
>  	unsigned long previous_freq;
> -	unsigned int next_polling;
>  
>  	void *data; /* private data for governors */
>  
> -	bool being_removed;
> -
>  	unsigned long min_freq;
>  	unsigned long max_freq;
>  };
> -- 
> 1.7.11.3
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
