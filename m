Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2ECWJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:09:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab2ECWJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:09:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCHv3 3/5] cpuidle: add support for states that affect multiple cpus
Date: Fri, 4 May 2012 00:14:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
References: <1335816551-27756-1-git-send-email-ccross@android.com> <1335816551-27756-4-git-send-email-ccross@android.com>
In-Reply-To: <1335816551-27756-4-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205040014.05880.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 30, 2012, Colin Cross wrote:
> On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> cpus cannot be independently powered down, either due to
> sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> power down), or due to HW bugs (on OMAP4460, a cpu powering up
> will corrupt the gic state unless the other cpu runs a work
> around).  Each cpu has a power state that it can enter without
> coordinating with the other cpu (usually Wait For Interrupt, or
> WFI), and one or more "coupled" power states that affect blocks
> shared between the cpus (L2 cache, interrupt controller, and
> sometimes the whole SoC).  Entering a coupled power state must
> be tightly controlled on both cpus.
> 
> The easiest solution to implementing coupled cpu power states is
> to hotplug all but one cpu whenever possible, usually using a
> cpufreq governor that looks at cpu load to determine when to
> enable the secondary cpus.  This causes problems, as hotplug is an
> expensive operation, so the number of hotplug transitions must be
> minimized, leading to very slow response to loads, often on the
> order of seconds.
> 
> This file implements an alternative solution, where each cpu will
> wait in the WFI state until all cpus are ready to enter a coupled
> state, at which point the coupled state function will be called
> on all cpus at approximately the same time.
> 
> Once all cpus are ready to enter idle, they are woken by an smp
> cross call.  At this point, there is a chance that one of the
> cpus will find work to do, and choose not to enter idle.  A
> final pass is needed to guarantee that all cpus will call the
> power state enter function at the same time.  During this pass,
> each cpu will increment the ready counter, and continue once the
> ready counter matches the number of online coupled cpus.  If any
> cpu exits idle, the other cpus will decrement their counter and
> retry.
> 
> To use coupled cpuidle states, a cpuidle driver must:
> 
>    Set struct cpuidle_device.coupled_cpus to the mask of all
>    coupled cpus, usually the same as cpu_possible_mask if all cpus
>    are part of the same cluster.  The coupled_cpus mask must be
>    set in the struct cpuidle_device for each cpu.
> 
>    Set struct cpuidle_device.safe_state to a state that is not a
>    coupled state.  This is usually WFI.
> 
>    Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
>    state that affects multiple cpus.
> 
>    Provide a struct cpuidle_state.enter function for each state
>    that affects multiple cpus.  This function is guaranteed to be
>    called on all cpus at approximately the same time.  The driver
>    should ensure that the cpus all abort together if any cpu tries
>    to abort once the function is called.
> 
> Cc: Len Brown <len.brown@intel.com>
> Cc: Amit Kucheria <amit.kucheria@linaro.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Trinabh Gupta <g.trinabh@gmail.com>
> Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Tested-by: Kevin Hilman <khilman@ti.com>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/cpuidle/Kconfig   |    3 +
>  drivers/cpuidle/Makefile  |    1 +
>  drivers/cpuidle/coupled.c |  571 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cpuidle/cpuidle.c |   15 ++-
>  drivers/cpuidle/cpuidle.h |   30 +++
>  include/linux/cpuidle.h   |    7 +
>  6 files changed, 626 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/cpuidle/coupled.c
> 
> v2:
>    * removed the coupled lock, replacing it with atomic counters
>    * added a check for outstanding pokes before beginning the
>      final transition to avoid extra wakeups
>    * made the cpuidle_coupled struct completely private
>    * fixed kerneldoc comment formatting
> 
> v3:
>    * fixed decrement in cpuidle_coupled_cpu_set_alive
>    * added kerneldoc annotation to the description
> 
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index 78a666d..a76b689 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -18,3 +18,6 @@ config CPU_IDLE_GOV_MENU
>  	bool
>  	depends on CPU_IDLE && NO_HZ
>  	default y
> +
> +config ARCH_NEEDS_CPU_IDLE_COUPLED
> +	def_bool n
> diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
> index 5634f88..38c8f69 100644
> --- a/drivers/cpuidle/Makefile
> +++ b/drivers/cpuidle/Makefile
> @@ -3,3 +3,4 @@
>  #
>  
>  obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
> +obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> new file mode 100644
> index 0000000..d097826
> --- /dev/null
> +++ b/drivers/cpuidle/coupled.c
> @@ -0,0 +1,571 @@
> +/*
> + * coupled.c - helper functions to enter the same idle state on multiple cpus
> + *
> + * Copyright (c) 2011 Google, Inc.
> + *
> + * Author: Colin Cross <ccross@android.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/cpu.h>
> +#include <linux/cpuidle.h>
> +#include <linux/mutex.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include "cpuidle.h"
> +
> +/**
> + * DOC: Coupled cpuidle states
> + *
> + * On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> + * cpus cannot be independently powered down, either due to
> + * sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> + * power down), or due to HW bugs (on OMAP4460, a cpu powering up
> + * will corrupt the gic state unless the other cpu runs a work
> + * around).  Each cpu has a power state that it can enter without
> + * coordinating with the other cpu (usually Wait For Interrupt, or
> + * WFI), and one or more "coupled" power states that affect blocks
> + * shared between the cpus (L2 cache, interrupt controller, and
> + * sometimes the whole SoC).  Entering a coupled power state must
> + * be tightly controlled on both cpus.
> + *
> + * The easiest solution to implementing coupled cpu power states is
> + * to hotplug all but one cpu whenever possible, usually using a
> + * cpufreq governor that looks at cpu load to determine when to
> + * enable the secondary cpus.  This causes problems, as hotplug is an
> + * expensive operation, so the number of hotplug transitions must be
> + * minimized, leading to very slow response to loads, often on the
> + * order of seconds.

I'd drop the above paragraph entirely.  It doesn't say much about what's in
the file and refers to an obviously suboptimal approach.

> + *
> + * This file implements an alternative solution, where each cpu will
> + * wait in the WFI state until all cpus are ready to enter a coupled
> + * state, at which point the coupled state function will be called
> + * on all cpus at approximately the same time.
> + *
> + * Once all cpus are ready to enter idle, they are woken by an smp
> + * cross call.  At this point, there is a chance that one of the
> + * cpus will find work to do, and choose not to enter idle.  A
> + * final pass is needed to guarantee that all cpus will call the
> + * power state enter function at the same time.  During this pass,
> + * each cpu will increment the ready counter, and continue once the
> + * ready counter matches the number of online coupled cpus.  If any
> + * cpu exits idle, the other cpus will decrement their counter and
> + * retry.
> + *
> + * requested_state stores the deepest coupled idle state each cpu
> + * is ready for.  It is assumed that the states are indexed from
> + * shallowest (highest power, lowest exit latency) to deepest
> + * (lowest power, highest exit latency).  The requested_state
> + * variable is not locked.  It is only written from the cpu that
> + * it stores (or by the on/offlining cpu if that cpu is offline),
> + * and only read after all the cpus are ready for the coupled idle
> + * state are are no longer updating it.
> + *
> + * Three atomic counters are used.  alive_count tracks the number
> + * of cpus in the coupled set that are currently or soon will be
> + * online.  waiting_count tracks the number of cpus that are in
> + * the waiting loop, in the ready loop, or in the coupled idle state.
> + * ready_count tracks the number of cpus that are in the ready loop
> + * or in the coupled idle state.
> + *
> + * To use coupled cpuidle states, a cpuidle driver must:
> + *
> + *    Set struct cpuidle_device.coupled_cpus to the mask of all
> + *    coupled cpus, usually the same as cpu_possible_mask if all cpus
> + *    are part of the same cluster.  The coupled_cpus mask must be
> + *    set in the struct cpuidle_device for each cpu.
> + *
> + *    Set struct cpuidle_device.safe_state to a state that is not a
> + *    coupled state.  This is usually WFI.
> + *
> + *    Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
> + *    state that affects multiple cpus.
> + *
> + *    Provide a struct cpuidle_state.enter function for each state
> + *    that affects multiple cpus.  This function is guaranteed to be
> + *    called on all cpus at approximately the same time.  The driver
> + *    should ensure that the cpus all abort together if any cpu tries
> + *    to abort once the function is called.  The function should return
> + *    with interrupts still disabled.
> + */
> +
> +/**
> + * struct cpuidle_coupled - data for set of cpus that share a coupled idle state
> + * @coupled_cpus: mask of cpus that are part of the coupled set
> + * @requested_state: array of requested states for cpus in the coupled set
> + * @ready_count: count of cpus that are ready for the final idle transition
> + * @waiting_count: count of cpus that are waiting for all other cpus to be idle
> + * @alive_count: count of cpus that are online or soon will be
> + * @refcnt: reference count of cpuidle devices that are using this struct
> + */
> +struct cpuidle_coupled {
> +	cpumask_t coupled_cpus;
> +	int requested_state[NR_CPUS];
> +	atomic_t ready_count;
> +	atomic_t waiting_count;
> +	atomic_t alive_count;
> +	int refcnt;
> +};
> +
> +#define CPUIDLE_COUPLED_NOT_IDLE	(-1)
> +#define CPUIDLE_COUPLED_DEAD		(-2)
> +
> +static DEFINE_MUTEX(cpuidle_coupled_lock);
> +static DEFINE_PER_CPU(struct call_single_data, cpuidle_coupled_poke_cb);
> +
> +/*
> + * The cpuidle_coupled_poked_mask masked is used to avoid calling

s/masked/mask/ perhaps?

> + * __smp_call_function_single with the per cpu call_single_data struct already
> + * in use.  This prevents a deadlock where two cpus are waiting for each others
> + * call_single_data struct to be available
> + */
> +static cpumask_t cpuidle_coupled_poked_mask;
> +
> +/**
> + * cpuidle_state_is_coupled - check if a state is part of a coupled set
> + * @dev: struct cpuidle_device for the current cpu
> + * @drv: struct cpuidle_driver for the platform
> + * @state: index of the target state in drv->states
> + *
> + * Returns true if the target state is coupled with cpus besides this one
> + */
> +bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
> +	struct cpuidle_driver *drv, int state)
> +{
> +	return drv->states[state].flags & CPUIDLE_FLAG_COUPLED;
> +}
> +
> +/**
> + * cpuidle_coupled_cpus_waiting - check if all cpus in a coupled set are waiting
> + * @coupled: the struct coupled that contains the current cpu
> + *
> + * Returns true if all cpus coupled to this target state are in the wait loop
> + */
> +static inline bool cpuidle_coupled_cpus_waiting(struct cpuidle_coupled *coupled)
> +{
> +	int alive;
> +	int waiting;
> +
> +	/*
> +	 * Read alive before reading waiting so a booting cpu is not treated as
> +	 * idle
> +	 */

Well, the comment doesn't really explain much.  In particular, why the boot CPU
could be treated as idle if the reads were in a different order.

> +	alive = atomic_read(&coupled->alive_count);
> +	smp_rmb();
> +	waiting = atomic_read(&coupled->waiting_count);

Have you considered using one atomic variable to accommodate both counters
such that the upper half contains one counter and the lower half contains
the other?

> +
> +	return (waiting == alive);
> +}
> +
> +/**
> + * cpuidle_coupled_get_state - determine the deepest idle state
> + * @dev: struct cpuidle_device for this cpu
> + * @coupled: the struct coupled that contains the current cpu
> + *
> + * Returns the deepest idle state that all coupled cpus can enter
> + */
> +static inline int cpuidle_coupled_get_state(struct cpuidle_device *dev,
> +		struct cpuidle_coupled *coupled)
> +{
> +	int i;
> +	int state = INT_MAX;
> +
> +	for_each_cpu_mask(i, coupled->coupled_cpus)
> +		if (coupled->requested_state[i] != CPUIDLE_COUPLED_DEAD &&
> +		    coupled->requested_state[i] < state)
> +			state = coupled->requested_state[i];
> +
> +	BUG_ON(state >= dev->state_count || state < 0);

Do you have to crash the kernel here if the assertion doesn't hold?  Maybe
you could use WARN_ON() and return error code?

> +
> +	return state;
> +}
> +
> +static void cpuidle_coupled_poked(void *info)
> +{
> +	int cpu = (unsigned long)info;
> +	cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
> +}
> +
> +/**
> + * cpuidle_coupled_poke - wake up a cpu that may be waiting
> + * @cpu: target cpu
> + *
> + * Ensures that the target cpu exits it's waiting idle state (if it is in it)
> + * and will see updates to waiting_count before it re-enters it's waiting idle
> + * state.
> + *
> + * If cpuidle_coupled_poked_mask is already set for the target cpu, that cpu
> + * either has or will soon have a pending IPI that will wake it out of idle,
> + * or it is currently processing the IPI and is not in idle.
> + */
> +static void cpuidle_coupled_poke(int cpu)
> +{
> +	struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
> +
> +	if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
> +		__smp_call_function_single(cpu, csd, 0);
> +}
> +
> +/**
> + * cpuidle_coupled_poke_others - wake up all other cpus that may be waiting
> + * @dev: struct cpuidle_device for this cpu
> + * @coupled: the struct coupled that contains the current cpu
> + *
> + * Calls cpuidle_coupled_poke on all other online cpus.
> + */
> +static void cpuidle_coupled_poke_others(struct cpuidle_device *dev,
> +		struct cpuidle_coupled *coupled)

It looks like you could simply pass cpu (not dev) to this function.

> +{
> +	int cpu;
> +
> +	for_each_cpu_mask(cpu, coupled->coupled_cpus)
> +		if (cpu != dev->cpu && cpu_online(cpu))
> +			cpuidle_coupled_poke(cpu);
> +}
> +
> +/**
> + * cpuidle_coupled_set_waiting - mark this cpu as in the wait loop
> + * @dev: struct cpuidle_device for this cpu
> + * @coupled: the struct coupled that contains the current cpu
> + * @next_state: the index in drv->states of the requested state for this cpu
> + *
> + * Updates the requested idle state for the specified cpuidle device,
> + * poking all coupled cpus out of idle if necessary to let them see the new
> + * state.
> + *
> + * Provides memory ordering around waiting_count.
> + */
> +static void cpuidle_coupled_set_waiting(struct cpuidle_device *dev,
> +		struct cpuidle_coupled *coupled, int next_state)

If you passed cpu (instead of dev) to cpuidle_coupled_poke_others(),
then you could pass cpu (instead of dev) to this function too, it seems.

> +{
> +	int alive;
> +
> +	BUG_ON(coupled->requested_state[dev->cpu] >= 0);

Would be WARN_ON() + do nothing too dangerous here?

> +
> +	coupled->requested_state[dev->cpu] = next_state;
> +
> +	/*
> +	 * If this is the last cpu to enter the waiting state, poke
> +	 * all the other cpus out of their waiting state so they can
> +	 * enter a deeper state.  This can race with one of the cpus
> +	 * exiting the waiting state due to an interrupt and
> +	 * decrementing waiting_count, see comment below.
> +	 */
> +	alive = atomic_read(&coupled->alive_count);
> +	if (atomic_inc_return(&coupled->waiting_count) == alive)
> +		cpuidle_coupled_poke_others(dev, coupled);
> +}
> +
> +/**
> + * cpuidle_coupled_set_not_waiting - mark this cpu as leaving the wait loop
> + * @dev: struct cpuidle_device for this cpu
> + * @coupled: the struct coupled that contains the current cpu
> + *
> + * Removes the requested idle state for the specified cpuidle device.
> + *
> + * Provides memory ordering around waiting_count.
> + */
> +static void cpuidle_coupled_set_not_waiting(struct cpuidle_device *dev,
> +		struct cpuidle_coupled *coupled)

It looks like dev doesn't have to be passed here, cpu would be enough.

> +{
> +	BUG_ON(coupled->requested_state[dev->cpu] < 0);

Well, like above?

> +
> +	/*
> +	 * Decrementing waiting_count can race with incrementing it in
> +	 * cpuidle_coupled_set_waiting, but that's OK.  Worst case, some
> +	 * cpus will increment ready_count and then spin until they
> +	 * notice that this cpu has cleared it's requested_state.
> +	 */

So it looks like having ready_count and waiting_count in one atomic variable
can spare us this particular race condition.

> +
> +	smp_mb__before_atomic_dec();
> +	atomic_dec(&coupled->waiting_count);
> +	smp_mb__after_atomic_dec();

Do you really need both the before and after barriers here?  If so, then why?

> +
> +	coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
> +}
> +
> +/**
> + * cpuidle_enter_state_coupled - attempt to enter a state with coupled cpus
> + * @dev: struct cpuidle_device for the current cpu
> + * @drv: struct cpuidle_driver for the platform
> + * @next_state: index of the requested state in drv->states
> + *
> + * Coordinate with coupled cpus to enter the target state.  This is a two
> + * stage process.  In the first stage, the cpus are operating independently,
> + * and may call into cpuidle_enter_state_coupled at completely different times.
> + * To save as much power as possible, the first cpus to call this function will
> + * go to an intermediate state (the cpuidle_device's safe state), and wait for
> + * all the other cpus to call this function.  Once all coupled cpus are idle,
> + * the second stage will start.  Each coupled cpu will spin until all cpus have
> + * guaranteed that they will call the target_state.

It would be good to mention the conditions for calling this function (eg.
interrupts disabled on the local CPU).

> + */
> +int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int next_state)
> +{
> +	int entered_state = -1;
> +	struct cpuidle_coupled *coupled = dev->coupled;
> +	int alive;
> +
> +	if (!coupled)
> +		return -EINVAL;
> +
> +	BUG_ON(atomic_read(&coupled->ready_count));

Again, I'd do a WARN_ON() and return error code from here (to avoid crashing
the kernel).

> +	cpuidle_coupled_set_waiting(dev, coupled, next_state);
> +
> +retry:
> +	/*
> +	 * Wait for all coupled cpus to be idle, using the deepest state
> +	 * allowed for a single cpu.
> +	 */
> +	while (!need_resched() && !cpuidle_coupled_cpus_waiting(coupled)) {
> +		entered_state = cpuidle_enter_state(dev, drv,
> +			dev->safe_state_index);
> +
> +		local_irq_enable();
> +		while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
> +			cpu_relax();

Hmm.  What exactly is this loop supposed to achieve?

> +		local_irq_disable();

Anyway, you seem to be calling it twice along with this enabling/disabling of
interrupts.  I'd put that into a separate function and explain its role in a
kerneldoc comment.

> +	}
> +
> +	/* give a chance to process any remaining pokes */
> +	local_irq_enable();
> +	while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
> +		cpu_relax();
> +	local_irq_disable();
> +
> +	if (need_resched()) {
> +		cpuidle_coupled_set_not_waiting(dev, coupled);
> +		goto out;
> +	}
> +
> +	/*
> +	 * All coupled cpus are probably idle.  There is a small chance that
> +	 * one of the other cpus just became active.  Increment a counter when
> +	 * ready, and spin until all coupled cpus have incremented the counter.
> +	 * Once a cpu has incremented the counter, it cannot abort idle and must
> +	 * spin until either the count has hit alive_count, or another cpu
> +	 * leaves idle.
> +	 */
> +
> +	smp_mb__before_atomic_inc();
> +	atomic_inc(&coupled->ready_count);
> +	smp_mb__after_atomic_inc();

It seems that at least one of these barriers is unnecessary ...

> +	/* alive_count can't change while ready_count > 0 */
> +	alive = atomic_read(&coupled->alive_count);
> +	while (atomic_read(&coupled->ready_count) != alive) {
> +		/* Check if any other cpus bailed out of idle. */
> +		if (!cpuidle_coupled_cpus_waiting(coupled)) {
> +			atomic_dec(&coupled->ready_count);
> +			smp_mb__after_atomic_dec();
> +			goto retry;
> +		}
> +
> +		cpu_relax();
> +	}
> +
> +	/* all cpus have acked the coupled state */
> +	smp_rmb();

What is the barrier here for?

> +
> +	next_state = cpuidle_coupled_get_state(dev, coupled);
> +
> +	entered_state = cpuidle_enter_state(dev, drv, next_state);
> +
> +	cpuidle_coupled_set_not_waiting(dev, coupled);
> +	atomic_dec(&coupled->ready_count);
> +	smp_mb__after_atomic_dec();
> +
> +out:
> +	/*
> +	 * Normal cpuidle states are expected to return with irqs enabled.
> +	 * That leads to an inefficiency where a cpu receiving an interrupt
> +	 * that brings it out of idle will process that interrupt before
> +	 * exiting the idle enter function and decrementing ready_count.  All
> +	 * other cpus will need to spin waiting for the cpu that is processing
> +	 * the interrupt.  If the driver returns with interrupts disabled,
> +	 * all other cpus will loop back into the safe idle state instead of
> +	 * spinning, saving power.
> +	 *
> +	 * Calling local_irq_enable here allows coupled states to return with
> +	 * interrupts disabled, but won't cause problems for drivers that
> +	 * exit with interrupts enabled.
> +	 */
> +	local_irq_enable();
> +
> +	/*
> +	 * Wait until all coupled cpus have exited idle.  There is no risk that
> +	 * a cpu exits and re-enters the ready state because this cpu has
> +	 * already decremented its waiting_count.
> +	 */
> +	while (atomic_read(&coupled->ready_count) != 0)
> +		cpu_relax();
> +
> +	smp_rmb();

And here?

> +
> +	return entered_state;
> +}
> +
> +/**
> + * cpuidle_coupled_register_device - register a coupled cpuidle device
> + * @dev: struct cpuidle_device for the current cpu
> + *
> + * Called from cpuidle_register_device to handle coupled idle init.  Finds the
> + * cpuidle_coupled struct for this set of coupled cpus, or creates one if none
> + * exists yet.
> + */
> +int cpuidle_coupled_register_device(struct cpuidle_device *dev)
> +{
> +	int cpu;
> +	struct cpuidle_device *other_dev;
> +	struct call_single_data *csd;
> +	struct cpuidle_coupled *coupled;
> +
> +	if (cpumask_empty(&dev->coupled_cpus))
> +		return 0;
> +
> +	for_each_cpu_mask(cpu, dev->coupled_cpus) {
> +		other_dev = per_cpu(cpuidle_devices, cpu);
> +		if (other_dev && other_dev->coupled) {
> +			coupled = other_dev->coupled;
> +			goto have_coupled;
> +		}
> +	}
> +
> +	/* No existing coupled info found, create a new one */
> +	coupled = kzalloc(sizeof(struct cpuidle_coupled), GFP_KERNEL);
> +	if (!coupled)
> +		return -ENOMEM;
> +
> +	coupled->coupled_cpus = dev->coupled_cpus;
> +	for_each_cpu_mask(cpu, coupled->coupled_cpus)
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
> +
> +have_coupled:
> +	dev->coupled = coupled;
> +	BUG_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus));
> +
> +	if (cpu_online(dev->cpu)) {
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
> +		atomic_inc(&coupled->alive_count);
> +	}
> +
> +	coupled->refcnt++;
> +
> +	csd = &per_cpu(cpuidle_coupled_poke_cb, dev->cpu);
> +	csd->func = cpuidle_coupled_poked;
> +	csd->info = (void *)(unsigned long)dev->cpu;
> +
> +	return 0;
> +}
> +
> +/**
> + * cpuidle_coupled_unregister_device - unregister a coupled cpuidle device
> + * @dev: struct cpuidle_device for the current cpu
> + *
> + * Called from cpuidle_unregister_device to tear down coupled idle.  Removes the
> + * cpu from the coupled idle set, and frees the cpuidle_coupled_info struct if
> + * this was the last cpu in the set.
> + */
> +void cpuidle_coupled_unregister_device(struct cpuidle_device *dev)
> +{
> +	struct cpuidle_coupled *coupled = dev->coupled;
> +
> +	if (cpumask_empty(&dev->coupled_cpus))
> +		return;
> +
> +	if (--coupled->refcnt)
> +		kfree(coupled);
> +	dev->coupled = NULL;
> +}
> +
> +/**
> + * cpuidle_coupled_cpu_set_alive - adjust alive_count during hotplug transitions
> + * @cpu: target cpu number
> + * @alive: whether the target cpu is going up or down
> + *
> + * Run on the cpu that is bringing up the target cpu, before the target cpu
> + * has been booted, or after the target cpu is completely dead.
> + */
> +static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
> +{
> +	struct cpuidle_device *dev;
> +	struct cpuidle_coupled *coupled;
> +
> +	mutex_lock(&cpuidle_lock);
> +
> +	dev = per_cpu(cpuidle_devices, cpu);
> +	if (!dev->coupled)
> +		goto out;
> +
> +	coupled = dev->coupled;
> +
> +	/*
> +	 * waiting_count must be at least 1 less than alive_count, because
> +	 * this cpu is not waiting.  Spin until all cpus have noticed this cpu
> +	 * is not idle and exited the ready loop before changing alive_count.
> +	 */
> +	while (atomic_read(&coupled->ready_count))
> +		cpu_relax();
> +
> +	if (alive) {
> +		smp_mb__before_atomic_inc();
> +		atomic_inc(&coupled->alive_count);
> +		smp_mb__after_atomic_inc();
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
> +	} else {
> +		smp_mb__before_atomic_dec();
> +		atomic_dec(&coupled->alive_count);
> +		smp_mb__after_atomic_dec();
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;

There's too many SMP barriers above, but I'm not quite sure which of them (if
any) are really necessary.

> +	}
> +
> +out:
> +	mutex_unlock(&cpuidle_lock);
> +}
> +
> +/**
> + * cpuidle_coupled_cpu_notify - notifier called during hotplug transitions
> + * @nb: notifier block
> + * @action: hotplug transition
> + * @hcpu: target cpu number
> + *
> + * Called when a cpu is brought on or offline using hotplug.  Updates the
> + * coupled cpu set appropriately
> + */
> +static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
> +		unsigned long action, void *hcpu)
> +{
> +	int cpu = (unsigned long)hcpu;
> +
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_DEAD:
> +	case CPU_UP_CANCELED:
> +		cpuidle_coupled_cpu_set_alive(cpu, false);
> +		break;
> +	case CPU_UP_PREPARE:
> +		cpuidle_coupled_cpu_set_alive(cpu, true);
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block cpuidle_coupled_cpu_notifier = {
> +	.notifier_call = cpuidle_coupled_cpu_notify,
> +};
> +
> +static int __init cpuidle_coupled_init(void)
> +{
> +	return register_cpu_notifier(&cpuidle_coupled_cpu_notifier);
> +}
> +core_initcall(cpuidle_coupled_init);
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 4540672..e81cfda 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -171,7 +171,11 @@ int cpuidle_idle_call(void)
>  	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
>  	trace_cpu_idle_rcuidle(next_state, dev->cpu);
>  
> -	entered_state = cpuidle_enter_state(dev, drv, next_state);
> +	if (cpuidle_state_is_coupled(dev, drv, next_state))
> +		entered_state = cpuidle_enter_state_coupled(dev, drv,
> +							    next_state);
> +	else
> +		entered_state = cpuidle_enter_state(dev, drv, next_state);
>  
>  	trace_power_end_rcuidle(dev->cpu);
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> @@ -407,9 +411,16 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>  	if (ret)
>  		goto err_sysfs;
>  
> +	ret = cpuidle_coupled_register_device(dev);
> +	if (ret)
> +		goto err_coupled;
> +
>  	dev->registered = 1;
>  	return 0;
>  
> +err_coupled:
> +	cpuidle_remove_sysfs(cpu_dev);
> +	wait_for_completion(&dev->kobj_unregister);
>  err_sysfs:
>  	list_del(&dev->device_list);
>  	per_cpu(cpuidle_devices, dev->cpu) = NULL;
> @@ -464,6 +475,8 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
>  	wait_for_completion(&dev->kobj_unregister);
>  	per_cpu(cpuidle_devices, dev->cpu) = NULL;
>  
> +	cpuidle_coupled_unregister_device(dev);
> +
>  	cpuidle_resume_and_unlock();
>  
>  	module_put(cpuidle_driver->owner);
> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
> index d8a3ccc..76e7f69 100644
> --- a/drivers/cpuidle/cpuidle.h
> +++ b/drivers/cpuidle/cpuidle.h
> @@ -32,4 +32,34 @@ extern int cpuidle_enter_state(struct cpuidle_device *dev,
>  extern int cpuidle_add_sysfs(struct device *dev);
>  extern void cpuidle_remove_sysfs(struct device *dev);
>  
> +#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
> +bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int state);
> +int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int next_state);
> +int cpuidle_coupled_register_device(struct cpuidle_device *dev);
> +void cpuidle_coupled_unregister_device(struct cpuidle_device *dev);
> +#else
> +static inline bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int state)
> +{
> +	return false;
> +}
> +
> +static inline int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int next_state)
> +{
> +	return -1;
> +}
> +
> +static inline int cpuidle_coupled_register_device(struct cpuidle_device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void cpuidle_coupled_unregister_device(struct cpuidle_device *dev)
> +{
> +}
> +#endif
> +
>  #endif /* __DRIVER_CPUIDLE_H */
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 6c26a3d..6038448 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -57,6 +57,7 @@ struct cpuidle_state {
>  
>  /* Idle State Flags */
>  #define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
> +#define CPUIDLE_FLAG_COUPLED	(0x02) /* state applies to multiple cpus */
>  
>  #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
>  
> @@ -100,6 +101,12 @@ struct cpuidle_device {
>  	struct list_head 	device_list;
>  	struct kobject		kobj;
>  	struct completion	kobj_unregister;
> +
> +#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
> +	int			safe_state_index;
> +	cpumask_t		coupled_cpus;
> +	struct cpuidle_coupled	*coupled;
> +#endif
>  };
>  
>  DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);

Thanks,
Rafael
