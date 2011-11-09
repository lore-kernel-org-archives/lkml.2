Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1KILNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:13:53 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42057 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1KILNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:13:51 -0500
Message-ID: <4EBA6046.2060305@linux.vnet.ibm.com>
Date: Wed, 09 Nov 2011 16:43:10 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Nicole Chalhoub <n-chalhoub@ti.com>
Subject: Re: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor
 deeper C-states
References: <1316475315-5905-1-git-send-email-khilman@ti.com> <87d3d75zo6.fsf@ti.com>
In-Reply-To: <87d3d75zo6.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110911-1780-0000-0000-000000CA905B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000229; HX=3.00000177; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00086066; UDB=6.00023389; UTC=2011-11-09
 11:13:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 November 2011 03:16 AM, Kevin Hilman wrote:
> ping v2
> 
> Kevin Hilman <khilman@ti.com> writes:
> 
>> From: Nicole Chalhoub <n-chalhoub@ti.com>
>>
>> While there is CPU load, program a C-state specific one-shot timer in
>> order to give CPUidle another opportunity to pick a deeper C-state
>> instead of spending potentially long idle times in a shallow C-state.
>>
>> Long winded version:
>> When going idle with a high load average, CPUidle menu governor will
>> decide to pick a shallow C-state since one of the guiding principles
>> of the menu governor is "The busier the system, the less impact of
>> C-states is acceptable" (taken from cpuidle/governors/menu.c.)
>> That makes perfect sense.
>>
>> However, there are missed power-saving opportunities for bursty
>> workloads with long idle times (e.g. MP3 playback.)  Given such a
>> workload, because of the load average, CPUidle tends to pick a shallow
>> C-state.  Because we also go tickless, this shallow C-state is used
>> for the duration of the idle period. If the idle period is long, a
>> deeper C state would've resulted in better power savings.
>> This patch provides an additional opportuntity for CPUidle to pick a
>> deeper C-state by programming a timer (with a C-state specific timeout)
>> such that the CPUidle governor will have another opportunity to pick a
>> deeper C-state.
>>
>> Adding this timer for C-state reevaluation improved the load estimation
>> on our ARM/OMAP4 platform and increased the time spent in deep C-states
>> (~50% of idle time in C-states deeper than C1).  A power saving of ~10mA
>> at battery level is observed during MP3 playback on OMAP4/Blaze board.
>>
>> Signed-off-by: Nicole Chalhoub <n-chalhoub@ti.com>
>> Signed-off-by: Kevin Hilman <khilman@ti.com>
>> ---
>>  drivers/cpuidle/cpuidle.c        |   28 +++++++++++++++++++++++++-
>>  drivers/cpuidle/governors/menu.c |   39 ++++++++++++++++++++++++++++++++-----
>>  include/linux/cpuidle.h          |    4 +++
>>  3 files changed, 63 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 1994885..4b1ac0c 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -92,13 +92,33 @@ static void cpuidle_idle_call(void)
>>  	target_state->time += (unsigned long long)dev->last_residency;
>>  	target_state->usage++;
>>  
>> -	/* give the governor an opportunity to reflect on the outcome */
>> -	if (cpuidle_curr_governor->reflect)
>> +	hrtimer_cancel(&dev->cstate_timer);
>> +
>> +	/*
>> +	 * Give the governor an opportunity to reflect on the outcome
>> +	 * Do not take into account the wakeups due to the hrtimer, they
>> +	 * should not impact the predicted idle time.
>> +	 */
>> +	if ((!dev->hrtimer_expired) && cpuidle_curr_governor->reflect)
>>  		cpuidle_curr_governor->reflect(dev);
>>  	trace_power_end(0);
>>  }
>>  
>>  /**
>> + * cstate_reassessment_timer - interrupt handler of the cstate hrtimer
>> + * @handle:	the expired hrtimer
>> + */
>> +static enum hrtimer_restart cstate_reassessment_timer(struct hrtimer *handle)
>> +{
>> +	struct cpuidle_device *data =
>> +		container_of(handle, struct cpuidle_device, cstate_timer);
>> +
>> +	data->hrtimer_expired = 1;
>> +
>> +	return HRTIMER_NORESTART;
>> +}
>> +
>> +/**
>>   * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
>>   */
>>  void cpuidle_install_idle_handler(void)
>> @@ -185,6 +205,10 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
>>  
>>  	dev->enabled = 1;
>>  
>> +	dev->hrtimer_expired = 0;
>> +	hrtimer_init(&dev->cstate_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>> +	dev->cstate_timer.function = cstate_reassessment_timer;
>> +
>>  	enabled_devices++;
>>  	return 0;
>>  
>> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
>> index 1b12870..fd54584 100644
>> --- a/drivers/cpuidle/governors/menu.c
>> +++ b/drivers/cpuidle/governors/menu.c
>> @@ -125,10 +125,21 @@ struct menu_device {
>>  #define LOAD_INT(x) ((x) >> FSHIFT)
>>  #define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
>>  
>> -static int get_loadavg(void)
>> +static int get_loadavg(struct cpuidle_device *dev)
>>  {
>> -	unsigned long this = this_cpu_load();
>> +	unsigned long this;
>>  
>> +	/*
>> +	 * this_cpu_load() returns the value of rq->load.weight
>> +	 * at the previous scheduler tick and not the current value.
>> +	 * If the timer expired, that means we are in idle,there
>> +	 * are no more runnable processes in the current queue
>> +	 * =>return the current value of rq->load.weight which is 0.
>> +	 */
>> +	if (dev->hrtimer_expired == 1)
>> +		return 0;
>> +	else
>> +		this = this_cpu_load();
>>  
>>  	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
>>  }
>> @@ -166,13 +177,13 @@ static inline int which_bucket(unsigned int duration)
>>   * to be, the higher this multiplier, and thus the higher
>>   * the barrier to go to an expensive C state.
>>   */
>> -static inline int performance_multiplier(void)
>> +static inline int performance_multiplier(struct cpuidle_device *dev)
>>  {
>>  	int mult = 1;
>>  
>>  	/* for higher loadavg, we are more reluctant */
>>  
>> -	mult += 2 * get_loadavg();
>> +	mult += 2 * get_loadavg(dev);
>>  
>>  	/* for IO wait tasks (per cpu!) we add 5x each */
>>  	mult += 10 * nr_iowait_cpu(smp_processor_id());
>> @@ -236,6 +247,7 @@ static int menu_select(struct cpuidle_device *dev)
>>  	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>>  	int i;
>>  	int multiplier;
>> +	ktime_t timeout;
>>  
>>  	if (data->needs_update) {
>>  		menu_update(dev);
>> @@ -256,7 +268,7 @@ static int menu_select(struct cpuidle_device *dev)
>>  
>>  	data->bucket = which_bucket(data->expected_us);
>>  
>> -	multiplier = performance_multiplier();
>> +	multiplier = performance_multiplier(dev);
>>  
>>  	/*
>>  	 * if the correction factor is 0 (eg first time init or cpu hotplug
>> @@ -287,12 +299,27 @@ static int menu_select(struct cpuidle_device *dev)
>>  			break;
>>  		if (s->exit_latency > latency_req)
>>  			break;
>> -		if (s->exit_latency * multiplier > data->predicted_us)
>> +		if (s->exit_latency * multiplier > data->predicted_us) {
>> +			/*
>> +			 * Could not enter the next C-state because of a high
>> +			 * load. Set a timer in order to check the load again
>> +			 * after the timeout expires and re-evaluate cstate.
>> +			 */
>> +			if (s->hrtimer_timeout != 0 && get_loadavg(dev)) {
>> +				timeout =
>> +				       ktime_set(0,
>> +					   s->hrtimer_timeout * NSEC_PER_USEC);
>> +				hrtimer_start(&dev->cstate_timer, timeout,
>> +					   HRTIMER_MODE_REL);
>> +			}
>>  			break;
>> +		}
>>  		data->exit_us = s->exit_latency;
>>  		data->last_state_idx = i;
>>  	}
>>  
>> +	/* Reset hrtimer_expired which is set when the hrtimer fires */
>> +	dev->hrtimer_expired = 0;
>>  	return data->last_state_idx;
>>  }
>>  
>> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>> index 55215cc..8d11b52 100644
>> --- a/include/linux/cpuidle.h
>> +++ b/include/linux/cpuidle.h
>> @@ -16,6 +16,7 @@
>>  #include <linux/module.h>
>>  #include <linux/kobject.h>
>>  #include <linux/completion.h>
>> +#include <linux/hrtimer.h>
>>  
>>  #define CPUIDLE_STATE_MAX	8
>>  #define CPUIDLE_NAME_LEN	16
>> @@ -37,6 +38,7 @@ struct cpuidle_state {
>>  	unsigned int	exit_latency; /* in US */
>>  	unsigned int	power_usage; /* in mW */
>>  	unsigned int	target_residency; /* in US */
>> +	unsigned int	hrtimer_timeout; /* in US */
>>  
>>  	unsigned long long	usage;
>>  	unsigned long long	time; /* in US */
>> @@ -97,6 +99,8 @@ struct cpuidle_device {
>>  	struct completion	kobj_unregister;
>>  	void			*governor_data;
>>  	struct cpuidle_state	*safe_state;
>> +	struct hrtimer          cstate_timer;
>> +	unsigned int            hrtimer_expired;
>>  };
>>  
>>  DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

By setting timers when we enter non-deepest C-state possible, such that when it fires we
can re-evaluate and try moving into deeper and deeper C-states enhancing the
power savings is a good feature to have. 

Looking at the current implementation, is it possible to have it as configurable option
where one can enable/disable this functionality through the backhand driver ?

Also I am thinking, instead of having them in governor
wouldnt it be a good idea to have it implemented in 
the backhand driver itself ? 

--Deepthi

