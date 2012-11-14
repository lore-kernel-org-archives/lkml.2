Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab2KNLFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:05:10 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:60912 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2KNLFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:05:06 -0500
Message-ID: <50A37ADD.8040000@linaro.org>
Date: Wed, 14 Nov 2012 12:05:01 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] cpuidle: Measure idle state durations with monotonic
 clock
References: <1352843563-16392-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1352843563-16392-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 10:52 PM, Julius Werner wrote:
> Many cpuidle drivers measure their time spent in an idle state by
> reading the wallclock time before and after idling and calculating the
> difference. This leads to erroneous results when the wallclock time gets
> updated by another processor in the meantime, adding that clock
> adjustment to the idle state's time counter.
> 
> If the clock adjustment was negative, the result is even worse due to an
> erroneous cast from int to unsigned long long of the last_residency
> variable. The negative 32 bit integer will zero-extend and result in a
> forward time jump of roughly four billion milliseconds or 1.3 hours on
> the idle state residency counter.
> 
> This patch changes all affected cpuidle drivers to use the monotonic
> clock for their measurements instead. It also removes the erroneous
> cast, making sure that negative residency values are applied correctly
> even though they should not appear anymore.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  arch/powerpc/platforms/pseries/processor_idle.c |    4 ++--
>  drivers/acpi/processor_idle.c                   |   12 ++++++------
>  drivers/cpuidle/cpuidle.c                       |    3 +--
>  drivers/idle/intel_idle.c                       |   13 ++++---------
>  4 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
> index 45d00e5..4d806b4 100644
> --- a/arch/powerpc/platforms/pseries/processor_idle.c
> +++ b/arch/powerpc/platforms/pseries/processor_idle.c
> @@ -36,7 +36,7 @@ static struct cpuidle_state *cpuidle_state_table;
>  static inline void idle_loop_prolog(unsigned long *in_purr, ktime_t *kt_before)
>  {
>  
> -	*kt_before = ktime_get_real();
> +	*kt_before = ktime_get();
>  	*in_purr = mfspr(SPRN_PURR);
>  	/*
>  	 * Indicate to the HV that we are idle. Now would be
> @@ -50,7 +50,7 @@ static inline  s64 idle_loop_epilog(unsigned long in_purr, ktime_t kt_before)
>  	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
>  	get_lppaca()->idle = 0;
>  
> -	return ktime_to_us(ktime_sub(ktime_get_real(), kt_before));
> +	return ktime_to_us(ktime_sub(ktime_get(), kt_before));
>  }
>  
>  static int snooze_loop(struct cpuidle_device *dev,
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index e8086c7..8c98d73 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -751,9 +751,9 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>  
>  
>  	lapic_timer_state_broadcast(pr, cx, 1);
> -	kt1 = ktime_get_real();
> +	kt1 = ktime_get();
>  	acpi_idle_do_entry(cx);
> -	kt2 = ktime_get_real();
> +	kt2 = ktime_get();
>  	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>  
>  	/* Update device last_residency*/
> @@ -843,11 +843,11 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>  	if (cx->type == ACPI_STATE_C3)
>  		ACPI_FLUSH_CPU_CACHE();
>  
> -	kt1 = ktime_get_real();
> +	kt1 = ktime_get();
>  	/* Tell the scheduler that we are going deep-idle: */
>  	sched_clock_idle_sleep_event();
>  	acpi_idle_do_entry(cx);
> -	kt2 = ktime_get_real();
> +	kt2 = ktime_get();
>  	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
>  	idle_time = idle_time_ns;
>  	do_div(idle_time, NSEC_PER_USEC);
> @@ -934,7 +934,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  	 */
>  	lapic_timer_state_broadcast(pr, cx, 1);
>  
> -	kt1 = ktime_get_real();
> +	kt1 = ktime_get();
>  	/*
>  	 * disable bus master
>  	 * bm_check implies we need ARB_DIS
> @@ -965,7 +965,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  		c3_cpu_count--;
>  		raw_spin_unlock(&c3_lock);
>  	}
> -	kt2 = ktime_get_real();
> +	kt2 = ktime_get();
>  	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
>  	idle_time = idle_time_ns;
>  	do_div(idle_time, NSEC_PER_USEC);


Maybe you can remove all these computations and set the flag
en_core_tk_irqen for the driver ? That will be handled by the cpuidle
framework, no ?

Same comment for the intel_idle driver.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

