Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1K1LDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:03:04 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45091 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab1K1LDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:03:02 -0500
Message-ID: <4ED36A5D.5060405@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 16:32:53 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.power-management.general,gmane.linux.ports.ppc64.devel,gmane.linux.kernel
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] cpuidle: (POWER) cpuidle driver for pSeries
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>	<20111117112841.9191.97974.stgit@localhost6.localdomain6> <1322435008.23348.15.camel@pasglop>
In-Reply-To: <1322435008.23348.15.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112801-1396-0000-0000-0000004F3F9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 04:33 AM, Benjamin Herrenschmidt wrote:

> On Thu, 2011-11-17 at 16:58 +0530, Deepthi Dharwar wrote:
>> This patch implements a backhand cpuidle driver for pSeries
>> based on pseries_dedicated_idle_loop and pseries_shared_idle_loop
>> routines.  The driver is built only if CONFIG_CPU_IDLE is set. This
>> cpuidle driver uses global registration of idle states and
>> not per-cpu.
> 
>  .../...
> 
>> +#define MAX_IDLE_STATE_COUNT	2
>> +
>> +static int max_cstate = MAX_IDLE_STATE_COUNT - 1;
> 
> Why "cstate" ? This isn't an x86 :-)


Sure, I shall change it right away :)

> 
>> +static struct cpuidle_device __percpu *pseries_idle_cpuidle_devices;
> 
> Shorter name please. pseries_cpuidle_devs is fine.


I ll do so.

> 
>> +static struct cpuidle_state *cpuidle_state_table;
>> +
>> +void update_smt_snooze_delay(int snooze)
>> +{
>> +	struct cpuidle_driver *drv = cpuidle_get_driver();
>> +	if (drv)
>> +		drv->states[0].target_residency = snooze;
>> +}
>> +
>> +static inline void idle_loop_prolog(unsigned long *in_purr, ktime_t *kt_before)
>> +{
>> +
>> +	*kt_before = ktime_get_real();
>> +	*in_purr = mfspr(SPRN_PURR);
>> +	/*
>> +	 * Indicate to the HV that we are idle. Now would be
>> +	 * a good time to find other work to dispatch.
>> +	 */
>> +	get_lppaca()->idle = 1;
>> +	get_lppaca()->donate_dedicated_cpu = 1;
>> +}
> 
> I notice that you call this on shared processors as well. The old ocde
> used to not set donate_dedicated_cpu in that case. I assume that's not a
> big deal and that the HV will just ignore it in the shared processor
> case but please add a comment after you've verified it.
>


Yes, the old code does not set donate_dedicated_cpu. But yes I will
try testing it in a shared proc config but also remove this
initialization for shared idle loop.

 
>> +static inline  s64 idle_loop_epilog(unsigned long in_purr, ktime_t kt_before)
>> +{
>> +	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
>> +	get_lppaca()->donate_dedicated_cpu = 0;
>> +	get_lppaca()->idle = 0;
>> +
>> +	return ktime_to_us(ktime_sub(ktime_get_real(), kt_before));
>> +}
>> +
>> +
>> +static int snooze_loop(struct cpuidle_device *dev,
>> +			struct cpuidle_driver *drv,
>> +			int index)
>> +{
>> +	unsigned long in_purr;
>> +	ktime_t kt_before;
>> +
>> +	idle_loop_prolog(&in_purr, &kt_before);
>> +
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
>> +	dev->last_residency =
>> +		(int)idle_loop_epilog(in_purr, kt_before);
>> +	return index;
>> +}
> 
> So your snooze loop has no timeout, is that handled by the cpuidle
> driver using some kind of timer ? That sounds a lot less efficient than
> passing a max delay to the snooze loop to handle getting into a deeper
> state after a bit of snoozing rather than interrupting etc...


My bad, snooze_loop is essential for a time out. Nope cpuidle
driver doesn't have any timer mechanism. I ll fix it.
Need to add loop for snooze time.

>> +static int dedicated_cede_loop(struct cpuidle_device *dev,
>> +				struct cpuidle_driver *drv,
>> +				int index)
>> +{
>> +	unsigned long in_purr;
>> +	ktime_t kt_before;
>> +
>> +	idle_loop_prolog(&in_purr, &kt_before);
>> +
>> +	ppc64_runlatch_off();
>> +	HMT_medium();
>> +	cede_processor();
>> +
>> +	dev->last_residency =
>> +		(int)idle_loop_epilog(in_purr, kt_before);
>> +	return index;
>> +}
>> +
>> +static int shared_cede_loop(struct cpuidle_device *dev,
>> +			struct cpuidle_driver *drv,
>> +			int index)
>> +{
>> +	unsigned long in_purr;
>> +	ktime_t kt_before;
>> +
>> +	idle_loop_prolog(&in_purr, &kt_before);
>> +
>> +	/*
>> +	 * Yield the processor to the hypervisor.  We return if
>> +	 * an external interrupt occurs (which are driven prior
>> +	 * to returning here) or if a prod occurs from another
>> +	 * processor. When returning here, external interrupts
>> +	 * are enabled.
>> +	 */
>> +	cede_processor();
>> +
>> +	dev->last_residency =
>> +		(int)idle_loop_epilog(in_purr, kt_before);
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
>> +		.enter = &snooze_loop },
>> +	{ /* CEDE */
>> +		.name = "CEDE",
>> +		.desc = "CEDE",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 1,
>> +		.target_residency = 10,
>> +		.enter = &dedicated_cede_loop },
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
>> +		.enter = &shared_cede_loop },
>> +};
>> +
>> +int pseries_notify_cpuidle_add_cpu(int cpu)
>> +{
>> +	struct cpuidle_device *dev =
>> +			per_cpu_ptr(pseries_idle_cpuidle_devices, cpu);
>> +	if (dev && cpuidle_get_driver()) {
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
> 
> Drop the "idle", those names are too long.


 Sure.

> 
>> +	int cstate;
> 
> And use something else than 'cstate', we are among civilized people
> here ;-)


Yes :)

> 
>> +	struct cpuidle_driver *drv = &pseries_idle_driver;
>> +
>> +	drv->state_count = 0;
>> +
>> +	for (cstate = 0; cstate < MAX_IDLE_STATE_COUNT; ++cstate) {
>> +
>> +		if (cstate > max_cstate)
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
>> +	struct cpuidle_driver *drv = &pseries_idle_driver;
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
>> +			printk(KERN_DEBUG \
>> +				"cpuidle_register_device %d failed!\n", i);
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
> 
> Don't even printk here, this will happen on all !pseries machines and
> the debug output isn't useful. Also move the check of max-cstate to
> after the splpar test.


I ll move the check above.

 
> Overall, I quite like these patches, my comments are all pretty minor,
> hopefully the next round should be the one.


Thank you.

> 
> Cheers,
> Ben.
> 
> 


Regards,
Deepthi

