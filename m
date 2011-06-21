Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1FUJA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:00:57 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38836 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1FUJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:00:55 -0400
Message-ID: <4E005DB2.30306@linux.vnet.ibm.com>
Date: Tue, 21 Jun 2011 14:30:34 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 5/7] cpuidle: (POWER) cpuidle driver for pSeries
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com> <20110607163012.6848.19268.stgit@tringupt.in.ibm.com> <1308285398.32158.12.camel@pasglop>
In-Reply-To: <1308285398.32158.12.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2011 10:06 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2011-06-07 at 22:00 +0530, Trinabh Gupta wrote:
>
>> +static int snooze_loop(struct cpuidle_device *dev,
>> +			struct cpuidle_driver *drv,
>> +			int index)
>> +{
>> +	unsigned long in_purr, out_purr;
>> +	ktime_t kt_before, kt_after;
>> +	s64 usec_delta;
>> +
>> +	/*
>> +	 * Indicate to the HV that we are idle. Now would be
>> +	 * a good time to find other work to dispatch.
>> +	 */
>> +	get_lppaca()->idle = 1;
>> +	get_lppaca()->donate_dedicated_cpu = 1;
>> +	in_purr = mfspr(SPRN_PURR);
>> +
>> +	kt_before = ktime_get_real();
>
> Don't you want to timestamp before you tell the HV that you are idle ?
> Or is the above stuff only polled by phyp when partition interrupts are
> enabled ?

Hi Ben,

Yes, timestamp should be before telling HV that we are idle. Thanks

>
>> +	local_irq_enable();
>> +	set_thread_flag(TIF_POLLING_NRFLAG);
>> +	while (!need_resched()) {
>> +		ppc64_runlatch_off();
>> +		HMT_low();
>> +		HMT_very_low();
>> +	}
>> +	HMT_medium();
>> +	clear_thread_flag(TIF_POLLING_NRFLAG);
>> +	smp_mb();
>> +	local_irq_disable();
>> +
>> +	kt_after = ktime_get_real();
>> +	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
>> +
>> +	out_purr = mfspr(SPRN_PURR);
>> +	get_lppaca()->wait_state_cycles += out_purr - in_purr;
>> +	get_lppaca()->donate_dedicated_cpu = 0;
>> +	get_lppaca()->idle = 0;
>> +
>> +	dev->last_residency = (int)usec_delta;
>> +
>> +	return index;
>> +}
>> +
>> +static int dedicated_cede_loop(struct cpuidle_device *dev,
>> +				struct cpuidle_driver *drv,
>> +				int index)
>> +{
>> +	unsigned long in_purr, out_purr;
>> +	ktime_t kt_before, kt_after;
>> +	s64 usec_delta;
>> +
>> +	/*
>> +	 * Indicate to the HV that we are idle. Now would be
>> +	 * a good time to find other work to dispatch.
>> +	 */
>> +	get_lppaca()->idle = 1;
>> +	get_lppaca()->donate_dedicated_cpu = 1;
>> +	in_purr = mfspr(SPRN_PURR);
>> +
>> +	kt_before = ktime_get_real();
>
> There's a bit too much code duplication for my taste here between the
> two functions. Not sure if it can be helped, maybe with some inlines
> for the prolog/epilogue ... Looks like stuff that's easy to "fix" in one
> place and forget the other...
>

Yes, I agree that there is too much code duplication in these idle
routines; will fix this.

Thanks
-Trinabh

>> +	ppc64_runlatch_off();
>> +	HMT_medium();
>> +	cede_processor();
>> +
>> +	kt_after = ktime_get_real();
>> +	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
>> +
>> +	out_purr = mfspr(SPRN_PURR);
>> +	get_lppaca()->wait_state_cycles += out_purr - in_purr;
>> +	get_lppaca()->donate_dedicated_cpu = 0;
>> +	get_lppaca()->idle = 0;
>> +
>> +	dev->last_residency = (int)usec_delta;
>> +
>> +	return index;
>> +}
>> +
>> +static int shared_cede_loop(struct cpuidle_device *dev,
>> +			struct cpuidle_driver *drv,
>> +			int index)
>> +{
>> +	unsigned long in_purr, out_purr;
>> +	ktime_t kt_before, kt_after;
>> +	s64 usec_delta;
>> +
>> +	/*
>> +	 * Indicate to the HV that we are idle. Now would be
>> +	 * a good time to find other work to dispatch.
>> +	 */
>> +	get_lppaca()->idle = 1;
>> +	get_lppaca()->donate_dedicated_cpu = 1;
>> +	in_purr = mfspr(SPRN_PURR);
>> +
>> +	kt_before = ktime_get_real();
>> +	/*
>> +	 * Yield the processor to the hypervisor.  We return if
>> +	 * an external interrupt occurs (which are driven prior
>> +	 * to returning here) or if a prod occurs from another
>> +	 * processor. When returning here, external interrupts
>> +	 * are enabled.
>> +	 */
>> +	cede_processor();
>> +
>> +	kt_after = ktime_get_real();
>> +
>> +	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
>> +
>> +	out_purr = mfspr(SPRN_PURR);
>> +	get_lppaca()->wait_state_cycles += out_purr - in_purr;
>> +	get_lppaca()->donate_dedicated_cpu = 0;
>> +	get_lppaca()->idle = 0;
>> +
>> +	dev->last_residency = (int)usec_delta;
>> +
>> +	return index;
>> +}
>> +
>> +/*
>> + * States for dedicated partition case.
>> + */
>> +static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
>> +	{ /* Snooze */
>> +		.name = "snooze",
>> +		.desc = "snooze",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 0,
>> +		.target_residency = 0,
>> +		.enter =&snooze_loop },
>> +	{ /* CEDE */
>> +		.name = "CEDE",
>> +		.desc = "CEDE",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 1,
>> +		.target_residency = 10,
>> +		.enter =&dedicated_cede_loop },
>> +};
>> +
>> +/*
>> + * States for shared partition case.
>> + */
>> +static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
>> +	{ /* Shared Cede */
>> +		.name = "Shared Cede",
>> +		.desc = "Shared Cede",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 0,
>> +		.target_residency = 0,
>> +		.enter =&shared_cede_loop },
>> +};
>> +
>> +int pseries_notify_cpuidle_add_cpu(int cpu)
>> +{
>> +	struct cpuidle_device *dev =
>> +			per_cpu_ptr(pseries_idle_cpuidle_devices, cpu);
>> +	if (dev&&  cpuidle_get_driver()) {
>> +		cpuidle_disable_device(dev);
>> +		cpuidle_enable_device(dev);
>> +	}
>> +	return 0;
>> +}
>> +
>> +/*
>> + * pseries_idle_cpuidle_driver_init()
>> + */
>> +static int pseries_idle_cpuidle_driver_init(void)
>> +{
>> +	int cstate;
>> +	struct cpuidle_driver *drv =&pseries_idle_driver;
>> +
>> +	drv->state_count = 0;
>> +
>> +	for (cstate = 0; cstate<  MAX_IDLE_STATE_COUNT; ++cstate) {
>> +
>> +		if (cstate>  max_cstate)
>> +			break;
>> +
>> +		/* is the state not enabled? */
>> +		if (cpuidle_state_table[cstate].enter == NULL)
>> +			continue;
>> +
>> +		drv->states[drv->state_count] =	/* structure copy */
>> +			cpuidle_state_table[cstate];
>> +
>> +		if (cpuidle_state_table == dedicated_states)
>> +			drv->states[drv->state_count].target_residency =
>> +				__get_cpu_var(smt_snooze_delay);
>> +
>> +		drv->state_count += 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* pseries_idle_devices_uninit(void)
>> + * unregister cpuidle devices and de-allocate memory
>> + */
>> +static void pseries_idle_devices_uninit(void)
>> +{
>> +	int i;
>> +	struct cpuidle_device *dev;
>> +
>> +	for_each_possible_cpu(i) {
>> +		dev = per_cpu_ptr(pseries_idle_cpuidle_devices, i);
>> +		cpuidle_unregister_device(dev);
>> +	}
>> +
>> +	free_percpu(pseries_idle_cpuidle_devices);
>> +	return;
>> +}
>> +
>> +/* pseries_idle_devices_init()
>> + * allocate, initialize and register cpuidle device
>> + */
>> +static int pseries_idle_devices_init(void)
>> +{
>> +	int i;
>> +	struct cpuidle_driver *drv =&pseries_idle_driver;
>> +	struct cpuidle_device *dev;
>> +
>> +	pseries_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
>> +	if (pseries_idle_cpuidle_devices == NULL)
>> +		return -ENOMEM;
>> +
>> +	for_each_possible_cpu(i) {
>> +		dev = per_cpu_ptr(pseries_idle_cpuidle_devices, i);
>> +		dev->state_count = drv->state_count;
>> +		dev->cpu = i;
>> +		if (cpuidle_register_device(dev)) {
>> +			printk(KERN_DEBUG "cpuidle_register_device %d failed!\n",
>> +				 i);
>> +			return -EIO;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * pseries_idle_probe()
>> + * Choose state table for shared versus dedicated partition
>> + */
>> +static int pseries_idle_probe(void)
>> +{
>> +	if (max_cstate == 0) {
>> +		printk(KERN_DEBUG "pseries processor idle disabled.\n");
>> +		return -EPERM;
>> +	}
>> +
>> +	if (!firmware_has_feature(FW_FEATURE_SPLPAR)) {
>> +		printk(KERN_DEBUG "Using default idle\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (get_lppaca()->shared_proc)
>> +		cpuidle_state_table = shared_states;
>> +	else
>> +		cpuidle_state_table = dedicated_states;
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init pseries_processor_idle_init(void)
>> +{
>> +	int retval;
>> +
>> +	retval = pseries_idle_probe();
>> +	if (retval)
>> +		return retval;
>> +
>> +	pseries_idle_cpuidle_driver_init();
>> +	retval = cpuidle_register_driver(&pseries_idle_driver);
>> +	if (retval) {
>> +		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
>> +		return retval;
>> +	}
>> +
>> +	retval = pseries_idle_devices_init();
>> +	if (retval) {
>> +		pseries_idle_devices_uninit();
>> +		cpuidle_unregister_driver(&pseries_idle_driver);
>> +		return retval;
>> +	}
>> +
>> +	printk(KERN_DEBUG "pseries_idle_driver registered\n");
>> +
>> +	return 0;
>> +}
>> +
>> +device_initcall(pseries_processor_idle_init);
>> diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
>> index e9f6d28..7c60380 100644
>> --- a/arch/powerpc/platforms/pseries/pseries.h
>> +++ b/arch/powerpc/platforms/pseries/pseries.h
>> @@ -56,4 +56,7 @@ extern struct device_node *dlpar_configure_connector(u32);
>>   extern int dlpar_attach_node(struct device_node *);
>>   extern int dlpar_detach_node(struct device_node *);
>>
>> +/* Snooze Delay, pseries_idle */
>> +DECLARE_PER_CPU(long, smt_snooze_delay);
>> +
>>   #endif /* _PSERIES_PSERIES_H */
>> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
>> index 593acce..6893a0c 100644
>> --- a/arch/powerpc/platforms/pseries/setup.c
>> +++ b/arch/powerpc/platforms/pseries/setup.c
>> @@ -584,9 +584,6 @@ static int __init pSeries_probe(void)
>>   	return 1;
>>   }
>>
>> -
>> -DECLARE_PER_CPU(long, smt_snooze_delay);
>> -
>>   static void pseries_dedicated_idle_sleep(void)
>>   {
>>   	unsigned int cpu = smp_processor_id();
>> diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
>> index fbffd7e..2e46883 100644
>> --- a/arch/powerpc/platforms/pseries/smp.c
>> +++ b/arch/powerpc/platforms/pseries/smp.c
>> @@ -150,6 +150,7 @@ static void __devinit smp_xics_setup_cpu(int cpu)
>>   	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
>>   	set_default_offline_state(cpu);
>>   #endif
>> +	pseries_notify_cpuidle_add_cpu(cpu);
>>   }
>>
>>   static int __devinit smp_pSeries_kick_cpu(int nr)
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
>
>
