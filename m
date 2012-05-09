Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2EIU6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:58:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065Ab2EIU6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:58:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCHv4 1/4] cpuidle: refactor out cpuidle_enter_state
Date: Wed, 9 May 2012 23:03:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
References: <1336438662-10484-1-git-send-email-ccross@android.com> <1336438662-10484-2-git-send-email-ccross@android.com>
In-Reply-To: <1336438662-10484-2-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205092303.36059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012, Colin Cross wrote:
> Split the code to enter a state and update the stats into a helper
> function, cpuidle_enter_state, and export it.  This function will
> be called by the coupled state code to handle entering the safe
> state and the final coupled state.
> 
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Tested-by: Kevin Hilman <khilman@ti.com>
> Signed-off-by: Colin Cross <ccross@android.com>

I've said

Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>

to this already.  Any chance to update the tags?

Rafael


> ---
>  drivers/cpuidle/cpuidle.c |   42 +++++++++++++++++++++++++++++-------------
>  drivers/cpuidle/cpuidle.h |    2 ++
>  2 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 2f0083a..3e3e3e4 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -103,6 +103,34 @@ int cpuidle_play_dead(void)
>  }
>  
>  /**
> + * cpuidle_enter_state - enter the state and update stats
> + * @dev: cpuidle device for this cpu
> + * @drv: cpuidle driver for this cpu
> + * @next_state: index into drv->states of the state to enter
> + */
> +int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
> +		int next_state)
> +{
> +	int entered_state;
> +
> +	entered_state = cpuidle_enter_ops(dev, drv, next_state);
> +
> +	if (entered_state >= 0) {
> +		/* Update cpuidle counters */
> +		/* This can be moved to within driver enter routine
> +		 * but that results in multiple copies of same code.
> +		 */
> +		dev->states_usage[entered_state].time +=
> +				(unsigned long long)dev->last_residency;
> +		dev->states_usage[entered_state].usage++;
> +	} else {
> +		dev->last_residency = 0;
> +	}
> +
> +	return entered_state;
> +}
> +
> +/**
>   * cpuidle_idle_call - the main idle loop
>   *
>   * NOTE: no locks or semaphores should be used here
> @@ -143,23 +171,11 @@ int cpuidle_idle_call(void)
>  	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
>  	trace_cpu_idle_rcuidle(next_state, dev->cpu);
>  
> -	entered_state = cpuidle_enter_ops(dev, drv, next_state);
> +	entered_state = cpuidle_enter_state(dev, drv, next_state);
>  
>  	trace_power_end_rcuidle(dev->cpu);
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>  
> -	if (entered_state >= 0) {
> -		/* Update cpuidle counters */
> -		/* This can be moved to within driver enter routine
> -		 * but that results in multiple copies of same code.
> -		 */
> -		dev->states_usage[entered_state].time +=
> -				(unsigned long long)dev->last_residency;
> -		dev->states_usage[entered_state].usage++;
> -	} else {
> -		dev->last_residency = 0;
> -	}
> -
>  	/* give the governor an opportunity to reflect on the outcome */
>  	if (cpuidle_curr_governor->reflect)
>  		cpuidle_curr_governor->reflect(dev, entered_state);
> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
> index 7db1866..d8a3ccc 100644
> --- a/drivers/cpuidle/cpuidle.h
> +++ b/drivers/cpuidle/cpuidle.h
> @@ -14,6 +14,8 @@
>  extern struct mutex cpuidle_lock;
>  extern spinlock_t cpuidle_driver_lock;
>  extern int cpuidle_disabled(void);
> +extern int cpuidle_enter_state(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int next_state);
>  
>  /* idle loop */
>  extern void cpuidle_install_idle_handler(void);
> 

