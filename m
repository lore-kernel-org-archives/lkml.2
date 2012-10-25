Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab2JYTM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:12:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58958 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab2JYTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:12:27 -0400
Message-ID: <50898F97.3000202@gmail.com>
Date: Thu, 25 Oct 2012 21:14:31 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "hongbo.zhang" <hongbo.zhang@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
CC: STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org, Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH V2 4/6] Thermal: Remove the cooling_cpufreq_list
In-Reply-To: <1351079900-32236-5-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>, <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>, <1351079900-32236-5-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Hongbo Zhang wrote:
> Problem of using this list is that the cpufreq_get_max_state callback will be
> called when register cooling device by thermal_cooling_device_register, but
> this list isn't ready at this moment. What's more, there is no need to maintain
> such a list, we can get cpufreq_cooling_device instance by the private
> thermal_cooling_device.devdata.
> 
> Signed-off-by: hongbo.zhang <hongbo.zhang at linaro.com>
> ---
>  drivers/thermal/cpu_cooling.c | 81 +++++++++----------------------------------
>  1 file changed, 16 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 415b041..cc80d29 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -58,8 +58,9 @@ struct cpufreq_cooling_device {
>  };
>  static LIST_HEAD(cooling_cpufreq_list);
>  static DEFINE_IDR(cpufreq_idr);
> +static DEFINE_MUTEX(cooling_cpufreq_lock);
>  
> -static struct mutex cooling_cpufreq_lock;
> +static unsigned int cpufreq_dev_count;
>  
>  /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
>  #define NOTIFY_INVALID NULL
> @@ -241,20 +242,12 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>  				 unsigned long *state)
>  {
>  	int ret = -EINVAL, i = 0;
> -	struct cpufreq_cooling_device *cpufreq_device;
> +	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
>  	struct cpumask *maskPtr;
>  	unsigned int cpu;
>  	struct cpufreq_frequency_table *table;
>  	unsigned long count = 0;
>  
> -	mutex_lock(&cooling_cpufreq_lock);
> -	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
> -		if (cpufreq_device && cpufreq_device->cool_dev == cdev)
> -			break;
> -	}
> -	if (cpufreq_device == NULL)
> -		goto return_get_max_state;
> -
>  	maskPtr = &cpufreq_device->allowed_cpus;
>  	cpu = cpumask_any(maskPtr);
>  	table = cpufreq_frequency_get_table(cpu);
> @@ -276,7 +269,6 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>  	}
>  
>  return_get_max_state:
> -	mutex_unlock(&cooling_cpufreq_lock);
>  	return ret;

Since there is no mutex locking/unlocking anymore, I'd say the goto
label should be removed.

[...]
>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>  {
> -	struct cpufreq_cooling_device *cpufreq_dev = NULL;
> -	unsigned int cpufreq_dev_count = 0;
> +	struct cpufreq_cooling_device *cpufreq_dev = cdev->devdata;
>  
> -	mutex_lock(&cooling_cpufreq_lock);
> -	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
> -		if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
> -			break;
> -		cpufreq_dev_count++;
> -	}
> -
> -	if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
> -		mutex_unlock(&cooling_cpufreq_lock);
> -		return;
> -	}
> +	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
>  
> -	list_del(&cpufreq_dev->node);
> +	mutex_lock(&cooling_cpufreq_lock);
> +	cpufreq_dev_count--;
>  
>  	/* Unregister the notifier for the last cpufreq cooling device */
> -	if (cpufreq_dev_count == 1) {
> +	if (cpufreq_dev_count == 0) {
>  		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
>  					CPUFREQ_POLICY_NOTIFIER);
>  	}
>  	mutex_unlock(&cooling_cpufreq_lock);
> -	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);

Why did you move the call to thermal_cooling_device_unregister() from
here? I don't see any reason for moving it.

> +
>  	release_idr(&cpufreq_idr, cpufreq_dev->id);
> -	if (cpufreq_dev_count == 1)
> -		mutex_destroy(&cooling_cpufreq_lock);
>  	kfree(cpufreq_dev);
>  }
>  EXPORT_SYMBOL(cpufreq_cooling_unregister);
> -- 
> 1.7.11.3

--
Francesco
