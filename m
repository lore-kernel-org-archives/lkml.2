Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2JQKbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:31:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55474 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2JQKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:31:21 -0400
Message-ID: <507E88F3.8070403@linaro.org>
Date: Wed, 17 Oct 2012 12:31:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        g.trinabh@gmail.com, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] cpuidle: reinitialize power_usage values when adding/removing
 C-states
References: <1350427184-11684-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1350427184-11684-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 12:39 AM, Julius Werner wrote:
> When cpuidle drivers do not supply explicit power_usage values,
> cpuidle/driver.c inserts dummy values instead. When a running processor
> dynamically gains new C-states (e.g. after ACPI events), the power_usage
> values of those states will stay uninitialized, and cpuidle governors
> will never choose to enter them.
> 
> This patch moves the dummy value initialization from
> cpuidle_register_driver to cpuidle_enable_device, which drivers such as
> acpi/processor_idle.c will call again when they add or remove C-states.
> Tested and verified on an Acer AC700 Chromebook, which supports the C3
> state only when it switches from AC to battery power.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---

This is specific to the acpi and should be handled in the
processor_idle.c file instead of the cpuidle core code.

Could be the function 'acpi_processor_cst_has_changed' the right place
to set a dummy power value for the power in the new C-state ?




>  drivers/cpuidle/cpuidle.c |   24 ++++++++++++++++++++++++
>  drivers/cpuidle/driver.c  |   25 -------------------------
>  2 files changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 7f15b85..bef3a31 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -298,6 +298,28 @@ static void poll_idle_init(struct cpuidle_driver *drv)
>  static void poll_idle_init(struct cpuidle_driver *drv) {}
>  #endif /* CONFIG_ARCH_HAS_CPU_RELAX */
>  
> +static void set_power_states(struct cpuidle_driver *drv)
> +{
> +	int i;
> +
> +	/*
> +	 * cpuidle driver should set the drv->power_specified bit
> +	 * before registering if the driver provides
> +	 * power_usage numbers.
> +	 *
> +	 * If power_specified is not set,
> +	 * we fill in power_usage with decreasing values as the
> +	 * cpuidle code has an implicit assumption that state Cn
> +	 * uses less power than C(n-1).
> +	 *
> +	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
> +	 * an power value of -1.  So we use -2, -3, etc, for other
> +	 * c-states.
> +	 */
> +	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
> +		drv->states[i].power_usage = -1 - i;
> +}
> +
>  /**
>   * cpuidle_enable_device - enables idle PM for a CPU
>   * @dev: the CPU
> @@ -330,6 +352,8 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
>  		cpuidle_enter_tk : cpuidle_enter;
>  
>  	poll_idle_init(drv);
> +	if (!drv->power_specified)
> +		set_power_states(drv);
>  
>  	if ((ret = cpuidle_add_state_sysfs(dev)))
>  		return ret;
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 87db387..caaed27 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -18,28 +18,6 @@ static struct cpuidle_driver *cpuidle_curr_driver;
>  DEFINE_SPINLOCK(cpuidle_driver_lock);
>  int cpuidle_driver_refcount;
>  
> -static void set_power_states(struct cpuidle_driver *drv)
> -{
> -	int i;
> -
> -	/*
> -	 * cpuidle driver should set the drv->power_specified bit
> -	 * before registering if the driver provides
> -	 * power_usage numbers.
> -	 *
> -	 * If power_specified is not set,
> -	 * we fill in power_usage with decreasing values as the
> -	 * cpuidle code has an implicit assumption that state Cn
> -	 * uses less power than C(n-1).
> -	 *
> -	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
> -	 * an power value of -1.  So we use -2, -3, etc, for other
> -	 * c-states.
> -	 */
> -	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
> -		drv->states[i].power_usage = -1 - i;
> -}
> -
>  /**
>   * cpuidle_register_driver - registers a driver
>   * @drv: the driver
> @@ -58,9 +36,6 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
>  		return -EBUSY;
>  	}
>  
> -	if (!drv->power_specified)
> -		set_power_states(drv);
> -
>  	cpuidle_curr_driver = drv;
>  
>  	spin_unlock(&cpuidle_driver_lock);


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

