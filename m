Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2KNK5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:57:46 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55897 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2KNK5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:57:43 -0500
Message-ID: <50A37921.7050909@linaro.org>
Date: Wed, 14 Nov 2012 11:57:37 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, Sameer Nanda <snanda@chromium.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] cpuidle: Measure idle state durations with monotonic
 clock
References: <1352843563-16392-1-git-send-email-jwerner@chromium.org> <50A35F21.9040003@linux.vnet.ibm.com>
In-Reply-To: <50A35F21.9040003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:06 AM, Deepthi Dharwar wrote:
> On 11/14/2012 03:22 AM, Julius Werner wrote:
>> Many cpuidle drivers measure their time spent in an idle state by
>> reading the wallclock time before and after idling and calculating the
>> difference. This leads to erroneous results when the wallclock time gets
>> updated by another processor in the meantime, adding that clock
>> adjustment to the idle state's time counter.
>>
>> If the clock adjustment was negative, the result is even worse due to an
>> erroneous cast from int to unsigned long long of the last_residency
>> variable. The negative 32 bit integer will zero-extend and result in a
>> forward time jump of roughly four billion milliseconds or 1.3 hours on
>> the idle state residency counter.
>>
>> This patch changes all affected cpuidle drivers to use the monotonic
>> clock for their measurements instead. It also removes the erroneous
>> cast, making sure that negative residency values are applied correctly
>> even though they should not appear anymore.
> 
> Currently tegra/cpuidle uses ktime_get(). Good to have it for all
> the other arch idle residency time logging too.

Actually it is used by all arm cpuidle drivers through the wrapper
"cpuidle_wrap_enter" and the en_core_tk_irqen flag.

> Tested patch on pseries.
> 
> Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> 
> Cheers,
> Deepthi
> 
>>
>> Signed-off-by: Julius Werner <jwerner@chromium.org>
>> ---
>>  arch/powerpc/platforms/pseries/processor_idle.c |    4 ++--
>>  drivers/acpi/processor_idle.c                   |   12 ++++++------
>>  drivers/cpuidle/cpuidle.c                       |    3 +--
>>  drivers/idle/intel_idle.c                       |   13 ++++---------
>>  4 files changed, 13 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
>> index 45d00e5..4d806b4 100644
>> --- a/arch/powerpc/platforms/pseries/processor_idle.c
>> +++ b/arch/powerpc/platforms/pseries/processor_idle.c
>> @@ -36,7 +36,7 @@ static struct cpuidle_state *cpuidle_state_table;
>>  static inline void idle_loop_prolog(unsigned long *in_purr, ktime_t *kt_before)
>>  {
>>
>> -	*kt_before = ktime_get_real();
>> +	*kt_before = ktime_get();
>>  	*in_purr = mfspr(SPRN_PURR);
>>  	/*
>>  	 * Indicate to the HV that we are idle. Now would be
>> @@ -50,7 +50,7 @@ static inline  s64 idle_loop_epilog(unsigned long in_purr, ktime_t kt_before)
>>  	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
>>  	get_lppaca()->idle = 0;
>>
>> -	return ktime_to_us(ktime_sub(ktime_get_real(), kt_before));
>> +	return ktime_to_us(ktime_sub(ktime_get(), kt_before));
>>  }
>>
>>  static int snooze_loop(struct cpuidle_device *dev,
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index e8086c7..8c98d73 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -751,9 +751,9 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>>
>>
>>  	lapic_timer_state_broadcast(pr, cx, 1);
>> -	kt1 = ktime_get_real();
>> +	kt1 = ktime_get();
>>  	acpi_idle_do_entry(cx);
>> -	kt2 = ktime_get_real();
>> +	kt2 = ktime_get();
>>  	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>>
>>  	/* Update device last_residency*/
>> @@ -843,11 +843,11 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>>  	if (cx->type == ACPI_STATE_C3)
>>  		ACPI_FLUSH_CPU_CACHE();
>>
>> -	kt1 = ktime_get_real();
>> +	kt1 = ktime_get();
>>  	/* Tell the scheduler that we are going deep-idle: */
>>  	sched_clock_idle_sleep_event();
>>  	acpi_idle_do_entry(cx);
>> -	kt2 = ktime_get_real();
>> +	kt2 = ktime_get();
>>  	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
>>  	idle_time = idle_time_ns;
>>  	do_div(idle_time, NSEC_PER_USEC);
>> @@ -934,7 +934,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>>  	 */
>>  	lapic_timer_state_broadcast(pr, cx, 1);
>>
>> -	kt1 = ktime_get_real();
>> +	kt1 = ktime_get();
>>  	/*
>>  	 * disable bus master
>>  	 * bm_check implies we need ARB_DIS
>> @@ -965,7 +965,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>>  		c3_cpu_count--;
>>  		raw_spin_unlock(&c3_lock);
>>  	}
>> -	kt2 = ktime_get_real();
>> +	kt2 = ktime_get();
>>  	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
>>  	idle_time = idle_time_ns;
>>  	do_div(idle_time, NSEC_PER_USEC);
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 7f15b85..1536edd 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -109,8 +109,7 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>>  		/* This can be moved to within driver enter routine
>>  		 * but that results in multiple copies of same code.
>>  		 */
>> -		dev->states_usage[entered_state].time +=
>> -				(unsigned long long)dev->last_residency;
>> +		dev->states_usage[entered_state].time += dev->last_residency;
>>  		dev->states_usage[entered_state].usage++;
>>  	} else {
>>  		dev->last_residency = 0;
>> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
>> index b0f6b4c..6329a97 100644
>> --- a/drivers/idle/intel_idle.c
>> +++ b/drivers/idle/intel_idle.c
>> @@ -56,7 +56,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/cpuidle.h>
>>  #include <linux/clockchips.h>
>> -#include <linux/hrtimer.h>	/* ktime_get_real() */
>> +#include <linux/hrtimer.h>	/* ktime_get() */
>>  #include <trace/events/power.h>
>>  #include <linux/sched.h>
>>  #include <linux/notifier.h>
>> @@ -281,8 +281,7 @@ static int intel_idle(struct cpuidle_device *dev,
>>  	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
>>  	unsigned long eax = (unsigned long)cpuidle_get_statedata(state_usage);
>>  	unsigned int cstate;
>> -	ktime_t kt_before, kt_after;
>> -	s64 usec_delta;
>> +	ktime_t kt_before;
>>  	int cpu = smp_processor_id();
>>
>>  	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
>> @@ -297,7 +296,7 @@ static int intel_idle(struct cpuidle_device *dev,
>>  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
>>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>>
>> -	kt_before = ktime_get_real();
>> +	kt_before = ktime_get();
>>
>>  	stop_critical_timings();
>>  	if (!need_resched()) {
>> @@ -310,17 +309,13 @@ static int intel_idle(struct cpuidle_device *dev,
>>
>>  	start_critical_timings();
>>
>> -	kt_after = ktime_get_real();
>> -	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
>> +	dev->last_residency = ktime_to_us(ktime_sub(ktime_get(), kt_before));
>>
>>  	local_irq_enable();
>>
>>  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
>>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
>>
>> -	/* Update cpuidle counters */
>> -	dev->last_residency = (int)usec_delta;
>> -
>>  	return index;
>>  }
>>
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

