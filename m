Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3ABVNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:13:19 -0500
Received: from relay3.sgi.com ([192.48.152.1]:37291 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752702Ab3ABVNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:13:18 -0500
Date: Wed, 2 Jan 2013 15:13:15 -0600
From: Russ Anderson <rja@sgi.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rafael.j.wysocki@intel.com, linux-pm@vger.kernel.org,
        pdeschrijver@nvidia.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rja@americas.sgi.com
Subject: Re: [PATCH] cpuidle - fix lock contention in the idle path
Message-ID: <20130102211314.GA29447@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1356516108-11191-1-git-send-email-daniel.lezcano@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356516108-11191-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 11:01:48AM +0100, Daniel Lezcano wrote:
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

I agree.

> The following patch is a hot fix by returning to the initial behavior
> by removing the lock when getting the driver.

The patch fixes the problem.  Verified on a system with 1024 cpus.
Thanks.

> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Reported-by: Russ Anderson <rja@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>

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
> -- 
> 1.7.9.5

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
