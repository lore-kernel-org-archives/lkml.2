Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2L2KcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 05:32:05 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63703 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2L2KcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 05:32:03 -0500
Message-ID: <50DEBFD7.5000104@linaro.org>
Date: Sat, 29 Dec 2012 11:03:03 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: rafael.j.wysocki@intel.com, rja@sgi.com
CC: linux-pm@vger.kernel.org, pdeschrijver@nvidia.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle - fix lock contention in the idle path
References: <1356516108-11191-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1356516108-11191-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Russ,

Is it possible you try this patch on your 2048 cpus ?

Thanks

  -- Daniel

On 12/26/2012 11:01 AM, Daniel Lezcano wrote:
> The commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92 introduces
> a lock in the cpuidle_get_cpu_driver function. This function
> is used in the idle_call function.
> 
> The problem is the contention with a large number of cpus because
> they try to access the idle routine at the same time.
> 
> The lock could be safely removed because of how is used the
> cpuidle api. The cpuidle_register_driver is called first but
> until the cpuidle_register_device is not called we don't
> enter in the cpuidle idle call function because the device
> is not enabled.
> 
> The cpuidle_unregister_driver function, leading the a NULL driver,
> is not called before the cpuidle_unregister_device.
> 
> This is how is used the cpuidle api from the different drivers.
> 
> However, a cleanup around the lock and a proper refcounting
> mechanism should be used to ensure the consistency in the api,
> like cpuidle_unregister_driver should failed if its refcounting
> is not 0.
> 
> These modifications will need some code reorganization and rewrite
> which does not fit with a fix.
> 
> The following patch is a hot fix by returning to the initial behavior
> by removing the lock when getting the driver.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/cpuidle/driver.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 3af841f..c2b281a 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -235,16 +235,10 @@ EXPORT_SYMBOL_GPL(cpuidle_get_driver);
>   */
>  struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
>  {
> -	struct cpuidle_driver *drv;
> -
>  	if (!dev)
>  		return NULL;
>  
> -	spin_lock(&cpuidle_driver_lock);
> -	drv = __cpuidle_get_cpu_driver(dev->cpu);
> -	spin_unlock(&cpuidle_driver_lock);
> -
> -	return drv;
> +	return __cpuidle_get_cpu_driver(dev->cpu);
>  }
>  EXPORT_SYMBOL_GPL(cpuidle_get_cpu_driver);
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

