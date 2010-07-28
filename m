Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0G1WIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:08:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538Ab0G1WIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:08:39 -0400
Date: Wed, 28 Jul 2010 14:55:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ai Li <aili@codeaurora.org>
Cc: dwalker@codeaurora.org, arjan@linux.intel.com, mingo@elte.hu,
        shemminger@vyatta.com, czoccolo@gmail.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH v2] cpuidle: extend cpuidle and menu governor to handle
 dynamic states
Message-Id: <20100728145545.35caf67a.akpm@linux-foundation.org>
In-Reply-To: <1280352443-28044-1-git-send-email-aili@codeaurora.org>
References: <1280352443-28044-1-git-send-email-aili@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 15:27:23 -0600
Ai Li <aili@codeaurora.org> wrote:

> On some SoC chips, HW resources may be in use during any particular idle
> period.  As a consequence, the cpuidle states that the SoC is safe to
> enter can change from idle period to idle period.  In addition, the
> latency and threshold of each cpuidle state can vary, depending on the
> operating condition when the CPU becomes idle, e.g. the current cpu
> frequency, the current state of the HW blocks, etc.
> 
> cpuidle core and the menu governor, in the current form, are geared
> towards cpuidle states that are static, i.e. the availabiltiy of the
> states, their latencies, their thresholds are non-changing during run
> time.  cpuidle does not provide any hook that cpuidle drivers can use
> to adjust those values on the fly for the current idle period before the
> menu governor selects the target cpuidle state.
> 
> This patch extends cpuidle core and the menu governor to handle states
> that are dynamic.  There are three additions in the patch and the patch
> maintains backwards-compatibility with existing cpuidle drivers.
> 
> 1) add prepare() to struct cpuidle_device.  A cpuidle driver can hook
> into the callback and cpuidle will call prepare() before calling the
> governor's select function.  The callback gives the cpuidle driver a
> chance to update the dynamic information of the cpuidle states for the
> current idle period, e.g. state availability, latencies, thresholds,
> power values, etc.
> 
> 2) add CPUIDLE_FLAG_IGNORE as one of the state flags.  In the prepare()
> function, a cpuidle driver can set/clear the flag to indicate to the
> menu governor whether a cpuidle state should be ignored, i.e. not
> available, during the current idle period.
> 
> 3) add power_specified bit to struct cpuidle_device.  The menu governor
> currently assumes that the cpuidle states are arranged in the order of
> increasing latency, threshold, and power savings.  This is true or can
> be made true for static states.  Once the state parameters are dynamic,
> the latencies, thresholds, and power savings for the cpuidle states can
> increase or decrease by different amounts from idle period to idle
> period.  So the assumption of increasing latency, threshold, and power
> savings from Cn to C(n+1) can no longer be guaranteed.
> 
> It can be straight forward to calculate the power consumption of each
> available state and to specify it in power_usage for the idle period.
> Using the power_usage fields, the menu governor then selects the state
> that has the lowest power consumption and that still satisfies all other
> critieria.  The power_specified bit defaults to 0.  For existing cpuidle
> drivers, cpuidle detects that power_specified is 0 and fills in a dummy
> set of power_usage values.

grumbles.

> Signed-off-by: Ai Li <aili@codeaurora.org>
> ---
>  drivers/cpuidle/cpuidle.c        |   13 +++++++++++++
>  drivers/cpuidle/governors/menu.c |   22 +++++++++++++++-------
>  include/linux/cpuidle.h          |    4 ++++
>  3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 1994885..7df8094 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -74,6 +74,10 @@ static void cpuidle_idle_call(void)
>  	 */
>  	hrtimer_peek_ahead_timers();
>  #endif
> +
> +	if (dev->prepare)
> +		dev->prepare(dev);

->prepare is unused in this patch and is undocumented in the code.  So
nobody knows what it does nor how to use it.

>  	/* ask the governor for the next state */
>  	next_state = cpuidle_curr_governor->select(dev);
>  	if (need_resched()) {
> @@ -282,6 +286,15 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>  
>  	poll_idle_init(dev);
>  
> +	/* fake out the power numbers of the device states if the driver
> +	 * does not specify them
> +	 */

A more typical, preferred and better-punctuated comment layout is

	/*
	 * Fake out the power numbers of the device states if the driver
	 * does not specify them.
	 */

checkpatch used to warn about this but someone broke it.

> +	if (!dev->power_specified) {
> +		int i;
> +		for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++)
> +			dev->states[i].power_usage = ~0U - i;
> +	}

Also, "fake out" is a poor description of the code.  The value is being
set to -1-i and there's no explanation here describing why this
peculiar value is used, nor what its effects are.

>  	per_cpu(cpuidle_devices, dev->cpu) = dev;
>  	list_add(&dev->device_list, &cpuidle_detected_devices);
>  	if ((ret = cpuidle_add_sysfs(sys_dev))) {
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 1b12870..ec2b330 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -234,6 +234,7 @@ static int menu_select(struct cpuidle_device *dev)
>  {
>  	struct menu_device *data = &__get_cpu_var(menu_devices);
>  	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
> +	unsigned int power_usage = ~0U;

It's a bit idiomatic, but I prefer plain old "-1" for the "all ones"
pattern.  Because it Just Works in all circumstances and continues to
work if someone changes the type to ulong and so the reader doesn't
have to check that the "U" and the type match each other.

>  	int i;
>  	int multiplier;
>  
> @@ -278,19 +279,26 @@ static int menu_select(struct cpuidle_device *dev)
>  	if (data->expected_us > 5)
>  		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
>  
> -
> -	/* find the deepest idle state that satisfies our constraints */
> +	/* find the idle state with the lowest power while satisfying
> +	 * our constraints
> +	 */

layout and punctuation.

>  	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
>  		struct cpuidle_state *s = &dev->states[i];
>  
> +		if (s->flags & CPUIDLE_FLAG_IGNORE)
> +			continue;
>  		if (s->target_residency > data->predicted_us)
> -			break;
> +			continue;
>  		if (s->exit_latency > latency_req)
> -			break;
> +			continue;
>  		if (s->exit_latency * multiplier > data->predicted_us)
> -			break;
> -		data->exit_us = s->exit_latency;
> -		data->last_state_idx = i;
> +			continue;
> +
> +		if (s->power_usage < power_usage) {
> +			power_usage = s->power_usage;
> +			data->last_state_idx = i;
> +			data->exit_us = s->exit_latency;
> +		}
>  	}
>  
>  	return data->last_state_idx;
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 55215cc..36ca972 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -52,6 +52,7 @@ struct cpuidle_state {
>  #define CPUIDLE_FLAG_SHALLOW	(0x20) /* low latency, minimal savings */
>  #define CPUIDLE_FLAG_BALANCED	(0x40) /* medium latency, moderate savings */
>  #define CPUIDLE_FLAG_DEEP	(0x80) /* high latency, large savings */
> +#define CPUIDLE_FLAG_IGNORE	(0x100) /* ignore during this idle period */
>  
>  #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
>  
> @@ -84,6 +85,7 @@ struct cpuidle_state_kobj {
>  struct cpuidle_device {
>  	unsigned int		registered:1;
>  	unsigned int		enabled:1;
> +	unsigned int		power_specified:1;
>  	unsigned int		cpu;

Again, power_specified is unused and undocumented and hence unusable.

And because it's a bitfield we need to beware that modifications to
this field can race against modifications to other fields.  But I
wasn't able to check for this in my code review because the code which
manipulates power_specified simply isn't here.

>  	int			last_residency;
> @@ -97,6 +99,8 @@ struct cpuidle_device {
>  	struct completion	kobj_unregister;
>  	void			*governor_data;
>  	struct cpuidle_state	*safe_state;
> +
> +	int (*prepare)		(struct cpuidle_device *dev);
>  };
>  
>  DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);

