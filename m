Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab2ECXJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:09:18 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37726 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756195Ab2ECXJQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <201205040014.05880.rjw@sisk.pl>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
	<1335816551-27756-4-git-send-email-ccross@android.com>
	<201205040014.05880.rjw@sisk.pl>
Date: Thu, 3 May 2012 16:09:15 -0700
X-Google-Sender-Auth: mhbx4NIQbxj4ZU8GNSoMR0m9x_4
Message-ID: <CAMbhsRQVH=f+2A_JXg3J2NKvC3dxqPk-QUDcbQ3G9Rv426c3AA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCHv3 3/5] cpuidle: add support for states that
 affect multiple cpus
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 3:14 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, April 30, 2012, Colin Cross wrote:
<snip>

>> +/**
>> + * DOC: Coupled cpuidle states
>> + *
>> + * On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
>> + * cpus cannot be independently powered down, either due to
>> + * sequencing restrictions (on Tegra 2, cpu 0 must be the last to
>> + * power down), or due to HW bugs (on OMAP4460, a cpu powering up
>> + * will corrupt the gic state unless the other cpu runs a work
>> + * around).  Each cpu has a power state that it can enter without
>> + * coordinating with the other cpu (usually Wait For Interrupt, or
>> + * WFI), and one or more "coupled" power states that affect blocks
>> + * shared between the cpus (L2 cache, interrupt controller, and
>> + * sometimes the whole SoC).  Entering a coupled power state must
>> + * be tightly controlled on both cpus.
>> + *
>> + * The easiest solution to implementing coupled cpu power states is
>> + * to hotplug all but one cpu whenever possible, usually using a
>> + * cpufreq governor that looks at cpu load to determine when to
>> + * enable the secondary cpus.  This causes problems, as hotplug is an
>> + * expensive operation, so the number of hotplug transitions must be
>> + * minimized, leading to very slow response to loads, often on the
>> + * order of seconds.
>
> I'd drop the above paragraph entirely.  It doesn't say much about what's in
> the file and refers to an obviously suboptimal approach.

Sure.


<snip>

>> +/*
>> + * The cpuidle_coupled_poked_mask masked is used to avoid calling
>
> s/masked/mask/ perhaps?

Sure.

<snip>

>> +/**
>> + * cpuidle_coupled_cpus_waiting - check if all cpus in a coupled set are waiting
>> + * @coupled: the struct coupled that contains the current cpu
>> + *
>> + * Returns true if all cpus coupled to this target state are in the wait loop
>> + */
>> +static inline bool cpuidle_coupled_cpus_waiting(struct cpuidle_coupled *coupled)
>> +{
>> +     int alive;
>> +     int waiting;
>> +
>> +     /*
>> +      * Read alive before reading waiting so a booting cpu is not treated as
>> +      * idle
>> +      */
>
> Well, the comment doesn't really explain much.  In particular, why the boot CPU
> could be treated as idle if the reads were in a different order.

Hm, I think the race condition is on a cpu going down.  What about:
Read alive before reading waiting.  If waiting is read before alive,
this cpu could see another cpu as waiting just before it goes offline,
between when it the other cpu decrements waiting and when it
decrements alive, which could cause alive == waiting when one cpu is
not waiting.

>> +     alive = atomic_read(&coupled->alive_count);
>> +     smp_rmb();
>> +     waiting = atomic_read(&coupled->waiting_count);
>
> Have you considered using one atomic variable to accommodate both counters
> such that the upper half contains one counter and the lower half contains
> the other?

There are 3 counters (alive, waiting, and ready).  Do you want me to
squish all of them into a single atomic_t, which would limit to 1023
cpus?

>> +
>> +     return (waiting == alive);
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_get_state - determine the deepest idle state
>> + * @dev: struct cpuidle_device for this cpu
>> + * @coupled: the struct coupled that contains the current cpu
>> + *
>> + * Returns the deepest idle state that all coupled cpus can enter
>> + */
>> +static inline int cpuidle_coupled_get_state(struct cpuidle_device *dev,
>> +             struct cpuidle_coupled *coupled)
>> +{
>> +     int i;
>> +     int state = INT_MAX;
>> +
>> +     for_each_cpu_mask(i, coupled->coupled_cpus)
>> +             if (coupled->requested_state[i] != CPUIDLE_COUPLED_DEAD &&
>> +                 coupled->requested_state[i] < state)
>> +                     state = coupled->requested_state[i];
>> +
>> +     BUG_ON(state >= dev->state_count || state < 0);
>
> Do you have to crash the kernel here if the assertion doesn't hold?  Maybe
> you could use WARN_ON() and return error code?

If this BUG_ON is hit, there is a race condition somewhere that
allowed a cpu out of idle unexpectedly, and there is no way to recover
without more race conditions.  I don't expect this to ever happen, it
is mostly there to detect race conditions during development.  Should
I drop it completely?

>> +
>> +     return state;
>> +}
>> +
>> +static void cpuidle_coupled_poked(void *info)
>> +{
>> +     int cpu = (unsigned long)info;
>> +     cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_poke - wake up a cpu that may be waiting
>> + * @cpu: target cpu
>> + *
>> + * Ensures that the target cpu exits it's waiting idle state (if it is in it)
>> + * and will see updates to waiting_count before it re-enters it's waiting idle
>> + * state.
>> + *
>> + * If cpuidle_coupled_poked_mask is already set for the target cpu, that cpu
>> + * either has or will soon have a pending IPI that will wake it out of idle,
>> + * or it is currently processing the IPI and is not in idle.
>> + */
>> +static void cpuidle_coupled_poke(int cpu)
>> +{
>> +     struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
>> +
>> +     if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
>> +             __smp_call_function_single(cpu, csd, 0);
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_poke_others - wake up all other cpus that may be waiting
>> + * @dev: struct cpuidle_device for this cpu
>> + * @coupled: the struct coupled that contains the current cpu
>> + *
>> + * Calls cpuidle_coupled_poke on all other online cpus.
>> + */
>> +static void cpuidle_coupled_poke_others(struct cpuidle_device *dev,
>> +             struct cpuidle_coupled *coupled)
>
> It looks like you could simply pass cpu (not dev) to this function.

OK.

>> +{
>> +     int cpu;
>> +
>> +     for_each_cpu_mask(cpu, coupled->coupled_cpus)
>> +             if (cpu != dev->cpu && cpu_online(cpu))
>> +                     cpuidle_coupled_poke(cpu);
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_set_waiting - mark this cpu as in the wait loop
>> + * @dev: struct cpuidle_device for this cpu
>> + * @coupled: the struct coupled that contains the current cpu
>> + * @next_state: the index in drv->states of the requested state for this cpu
>> + *
>> + * Updates the requested idle state for the specified cpuidle device,
>> + * poking all coupled cpus out of idle if necessary to let them see the new
>> + * state.
>> + *
>> + * Provides memory ordering around waiting_count.
>> + */
>> +static void cpuidle_coupled_set_waiting(struct cpuidle_device *dev,
>> +             struct cpuidle_coupled *coupled, int next_state)
>
> If you passed cpu (instead of dev) to cpuidle_coupled_poke_others(),
> then you could pass cpu (instead of dev) to this function too, it seems.

OK.

>> +{
>> +     int alive;
>> +
>> +     BUG_ON(coupled->requested_state[dev->cpu] >= 0);
>
> Would be WARN_ON() + do nothing too dangerous here?

If this BUG_ON is hit, then this cpu exited idle without clearing its
waiting state, which could cause another cpu to enter the deeper idle
state while this cpu is still running.  The counters would be out of
sync, so it's not easy to recover.  Again, this is to detect race
conditions during development, but should never happen.  Should I drop
it?

>> +
>> +     coupled->requested_state[dev->cpu] = next_state;
>> +
>> +     /*
>> +      * If this is the last cpu to enter the waiting state, poke
>> +      * all the other cpus out of their waiting state so they can
>> +      * enter a deeper state.  This can race with one of the cpus
>> +      * exiting the waiting state due to an interrupt and
>> +      * decrementing waiting_count, see comment below.
>> +      */
>> +     alive = atomic_read(&coupled->alive_count);
>> +     if (atomic_inc_return(&coupled->waiting_count) == alive)
>> +             cpuidle_coupled_poke_others(dev, coupled);
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_set_not_waiting - mark this cpu as leaving the wait loop
>> + * @dev: struct cpuidle_device for this cpu
>> + * @coupled: the struct coupled that contains the current cpu
>> + *
>> + * Removes the requested idle state for the specified cpuidle device.
>> + *
>> + * Provides memory ordering around waiting_count.
>> + */
>> +static void cpuidle_coupled_set_not_waiting(struct cpuidle_device *dev,
>> +             struct cpuidle_coupled *coupled)
>
> It looks like dev doesn't have to be passed here, cpu would be enough.
>
>> +{
>> +     BUG_ON(coupled->requested_state[dev->cpu] < 0);
>
> Well, like above?
Same as above.

>> +
>> +     /*
>> +      * Decrementing waiting_count can race with incrementing it in
>> +      * cpuidle_coupled_set_waiting, but that's OK.  Worst case, some
>> +      * cpus will increment ready_count and then spin until they
>> +      * notice that this cpu has cleared it's requested_state.
>> +      */
>
> So it looks like having ready_count and waiting_count in one atomic variable
> can spare us this particular race condition.
As above, there are 3 counters here, alive, ready, and waiting.

>> +
>> +     smp_mb__before_atomic_dec();
>> +     atomic_dec(&coupled->waiting_count);
>> +     smp_mb__after_atomic_dec();
>
> Do you really need both the before and after barriers here?  If so, then why?

I believe so, waiting is ordered vs. alive and ready, one barrier is
for each.  Do you want the answers to these questions here or in the
code?  I had comments for every barrier use during development, but it
made it too hard to follow the flow of the code.  I could add a
comment describing the ordering requirements instead, but it's still
hard to translate that to the required barrier locations.

>> +
>> +     coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
>> +}
>> +
>> +/**
>> + * cpuidle_enter_state_coupled - attempt to enter a state with coupled cpus
>> + * @dev: struct cpuidle_device for the current cpu
>> + * @drv: struct cpuidle_driver for the platform
>> + * @next_state: index of the requested state in drv->states
>> + *
>> + * Coordinate with coupled cpus to enter the target state.  This is a two
>> + * stage process.  In the first stage, the cpus are operating independently,
>> + * and may call into cpuidle_enter_state_coupled at completely different times.
>> + * To save as much power as possible, the first cpus to call this function will
>> + * go to an intermediate state (the cpuidle_device's safe state), and wait for
>> + * all the other cpus to call this function.  Once all coupled cpus are idle,
>> + * the second stage will start.  Each coupled cpu will spin until all cpus have
>> + * guaranteed that they will call the target_state.
>
> It would be good to mention the conditions for calling this function (eg.
> interrupts disabled on the local CPU).

OK.

>> + */
>> +int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
>> +             struct cpuidle_driver *drv, int next_state)
>> +{
>> +     int entered_state = -1;
>> +     struct cpuidle_coupled *coupled = dev->coupled;
>> +     int alive;
>> +
>> +     if (!coupled)
>> +             return -EINVAL;
>> +
>> +     BUG_ON(atomic_read(&coupled->ready_count));
>
> Again, I'd do a WARN_ON() and return error code from here (to avoid crashing
> the kernel).
Same as above, if ready_count is not 0 here then the counters are out
of sync and something is about to go horribly wrong, like cutting
power to a running cpu.

>> +     cpuidle_coupled_set_waiting(dev, coupled, next_state);
>> +
>> +retry:
>> +     /*
>> +      * Wait for all coupled cpus to be idle, using the deepest state
>> +      * allowed for a single cpu.
>> +      */
>> +     while (!need_resched() && !cpuidle_coupled_cpus_waiting(coupled)) {
>> +             entered_state = cpuidle_enter_state(dev, drv,
>> +                     dev->safe_state_index);
>> +
>> +             local_irq_enable();
>> +             while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
>> +                     cpu_relax();
>
> Hmm.  What exactly is this loop supposed to achieve?
This is to ensure that the outstanding wakeups have been processed so
we don't go to idle with an interrupt pending an immediately wake up.

>> +             local_irq_disable();
>
> Anyway, you seem to be calling it twice along with this enabling/disabling of
> interrupts.  I'd put that into a separate function and explain its role in a
> kerneldoc comment.

I left it here to be obvious that I was enabling interrupts in the
idle path, but I can refactor it out if you prefer.

>> +     }
>> +
>> +     /* give a chance to process any remaining pokes */
>> +     local_irq_enable();
>> +     while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
>> +             cpu_relax();
>> +     local_irq_disable();
>> +
>> +     if (need_resched()) {
>> +             cpuidle_coupled_set_not_waiting(dev, coupled);
>> +             goto out;
>> +     }
>> +
>> +     /*
>> +      * All coupled cpus are probably idle.  There is a small chance that
>> +      * one of the other cpus just became active.  Increment a counter when
>> +      * ready, and spin until all coupled cpus have incremented the counter.
>> +      * Once a cpu has incremented the counter, it cannot abort idle and must
>> +      * spin until either the count has hit alive_count, or another cpu
>> +      * leaves idle.
>> +      */
>> +
>> +     smp_mb__before_atomic_inc();
>> +     atomic_inc(&coupled->ready_count);
>> +     smp_mb__after_atomic_inc();
>
> It seems that at least one of these barriers is unnecessary ...
The first is to ensure ordering between ready_count and waiting count,
the second is for ready_count vs. alive_count and requested_state.

>> +     /* alive_count can't change while ready_count > 0 */
>> +     alive = atomic_read(&coupled->alive_count);
>> +     while (atomic_read(&coupled->ready_count) != alive) {
>> +             /* Check if any other cpus bailed out of idle. */
>> +             if (!cpuidle_coupled_cpus_waiting(coupled)) {
>> +                     atomic_dec(&coupled->ready_count);
>> +                     smp_mb__after_atomic_dec();
>> +                     goto retry;
>> +             }
>> +
>> +             cpu_relax();
>> +     }
>> +
>> +     /* all cpus have acked the coupled state */
>> +     smp_rmb();
>
> What is the barrier here for?
This protects ready_count vs. requested_state.  It is already
implicitly protected by the atomic_inc_return in set_waiting, but I
thought it would be better to protect it explicitly here.  I think I
added the smp_mb__after_atomic_inc above later, which makes this one
superflous, so I'll drop it.

>> +
>> +     next_state = cpuidle_coupled_get_state(dev, coupled);
>> +
>> +     entered_state = cpuidle_enter_state(dev, drv, next_state);
>> +
>> +     cpuidle_coupled_set_not_waiting(dev, coupled);
>> +     atomic_dec(&coupled->ready_count);
>> +     smp_mb__after_atomic_dec();
>> +
>> +out:
>> +     /*
>> +      * Normal cpuidle states are expected to return with irqs enabled.
>> +      * That leads to an inefficiency where a cpu receiving an interrupt
>> +      * that brings it out of idle will process that interrupt before
>> +      * exiting the idle enter function and decrementing ready_count.  All
>> +      * other cpus will need to spin waiting for the cpu that is processing
>> +      * the interrupt.  If the driver returns with interrupts disabled,
>> +      * all other cpus will loop back into the safe idle state instead of
>> +      * spinning, saving power.
>> +      *
>> +      * Calling local_irq_enable here allows coupled states to return with
>> +      * interrupts disabled, but won't cause problems for drivers that
>> +      * exit with interrupts enabled.
>> +      */
>> +     local_irq_enable();
>> +
>> +     /*
>> +      * Wait until all coupled cpus have exited idle.  There is no risk that
>> +      * a cpu exits and re-enters the ready state because this cpu has
>> +      * already decremented its waiting_count.
>> +      */
>> +     while (atomic_read(&coupled->ready_count) != 0)
>> +             cpu_relax();
>> +
>> +     smp_rmb();
>
> And here?

This was to protect ready_count vs. looping back in and reading
alive_count.  There will be plenty of synchronization calls between
the two with implicit barriers, but I thought it was better to do it
explicitly.

>> +
>> +     return entered_state;
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_register_device - register a coupled cpuidle device
>> + * @dev: struct cpuidle_device for the current cpu
>> + *
>> + * Called from cpuidle_register_device to handle coupled idle init.  Finds the
>> + * cpuidle_coupled struct for this set of coupled cpus, or creates one if none
>> + * exists yet.
>> + */
>> +int cpuidle_coupled_register_device(struct cpuidle_device *dev)
>> +{
>> +     int cpu;
>> +     struct cpuidle_device *other_dev;
>> +     struct call_single_data *csd;
>> +     struct cpuidle_coupled *coupled;
>> +
>> +     if (cpumask_empty(&dev->coupled_cpus))
>> +             return 0;
>> +
>> +     for_each_cpu_mask(cpu, dev->coupled_cpus) {
>> +             other_dev = per_cpu(cpuidle_devices, cpu);
>> +             if (other_dev && other_dev->coupled) {
>> +                     coupled = other_dev->coupled;
>> +                     goto have_coupled;
>> +             }
>> +     }
>> +
>> +     /* No existing coupled info found, create a new one */
>> +     coupled = kzalloc(sizeof(struct cpuidle_coupled), GFP_KERNEL);
>> +     if (!coupled)
>> +             return -ENOMEM;
>> +
>> +     coupled->coupled_cpus = dev->coupled_cpus;
>> +     for_each_cpu_mask(cpu, coupled->coupled_cpus)
>> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
>> +
>> +have_coupled:
>> +     dev->coupled = coupled;
>> +     BUG_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus));
>> +
>> +     if (cpu_online(dev->cpu)) {
>> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
>> +             atomic_inc(&coupled->alive_count);
>> +     }
>> +
>> +     coupled->refcnt++;
>> +
>> +     csd = &per_cpu(cpuidle_coupled_poke_cb, dev->cpu);
>> +     csd->func = cpuidle_coupled_poked;
>> +     csd->info = (void *)(unsigned long)dev->cpu;
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_unregister_device - unregister a coupled cpuidle device
>> + * @dev: struct cpuidle_device for the current cpu
>> + *
>> + * Called from cpuidle_unregister_device to tear down coupled idle.  Removes the
>> + * cpu from the coupled idle set, and frees the cpuidle_coupled_info struct if
>> + * this was the last cpu in the set.
>> + */
>> +void cpuidle_coupled_unregister_device(struct cpuidle_device *dev)
>> +{
>> +     struct cpuidle_coupled *coupled = dev->coupled;
>> +
>> +     if (cpumask_empty(&dev->coupled_cpus))
>> +             return;
>> +
>> +     if (--coupled->refcnt)
>> +             kfree(coupled);
>> +     dev->coupled = NULL;
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_cpu_set_alive - adjust alive_count during hotplug transitions
>> + * @cpu: target cpu number
>> + * @alive: whether the target cpu is going up or down
>> + *
>> + * Run on the cpu that is bringing up the target cpu, before the target cpu
>> + * has been booted, or after the target cpu is completely dead.
>> + */
>> +static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
>> +{
>> +     struct cpuidle_device *dev;
>> +     struct cpuidle_coupled *coupled;
>> +
>> +     mutex_lock(&cpuidle_lock);
>> +
>> +     dev = per_cpu(cpuidle_devices, cpu);
>> +     if (!dev->coupled)
>> +             goto out;
>> +
>> +     coupled = dev->coupled;
>> +
>> +     /*
>> +      * waiting_count must be at least 1 less than alive_count, because
>> +      * this cpu is not waiting.  Spin until all cpus have noticed this cpu
>> +      * is not idle and exited the ready loop before changing alive_count.
>> +      */
>> +     while (atomic_read(&coupled->ready_count))
>> +             cpu_relax();
>> +
>> +     if (alive) {
>> +             smp_mb__before_atomic_inc();
>> +             atomic_inc(&coupled->alive_count);
>> +             smp_mb__after_atomic_inc();
>> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
>> +     } else {
>> +             smp_mb__before_atomic_dec();
>> +             atomic_dec(&coupled->alive_count);
>> +             smp_mb__after_atomic_dec();
>> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
>
> There's too many SMP barriers above, but I'm not quite sure which of them (if
> any) are really necessary.
The ones before order ready_count vs alive_count, the ones after order
alive_count vs. requested_state and future waiting_count increments.

>> +     }
>> +
>> +out:
>> +     mutex_unlock(&cpuidle_lock);
>> +}
>> +
>> +/**
>> + * cpuidle_coupled_cpu_notify - notifier called during hotplug transitions
>> + * @nb: notifier block
>> + * @action: hotplug transition
>> + * @hcpu: target cpu number
>> + *
>> + * Called when a cpu is brought on or offline using hotplug.  Updates the
>> + * coupled cpu set appropriately
>> + */
>> +static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
>> +             unsigned long action, void *hcpu)
>> +{
>> +     int cpu = (unsigned long)hcpu;
>> +
>> +     switch (action & ~CPU_TASKS_FROZEN) {
>> +     case CPU_DEAD:
>> +     case CPU_UP_CANCELED:
>> +             cpuidle_coupled_cpu_set_alive(cpu, false);
>> +             break;
>> +     case CPU_UP_PREPARE:
>> +             cpuidle_coupled_cpu_set_alive(cpu, true);
>> +             break;
>> +     }
>> +     return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block cpuidle_coupled_cpu_notifier = {
>> +     .notifier_call = cpuidle_coupled_cpu_notify,
>> +};
>> +
>> +static int __init cpuidle_coupled_init(void)
>> +{
>> +     return register_cpu_notifier(&cpuidle_coupled_cpu_notifier);
>> +}
>> +core_initcall(cpuidle_coupled_init);
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 4540672..e81cfda 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -171,7 +171,11 @@ int cpuidle_idle_call(void)
>>       trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
>>       trace_cpu_idle_rcuidle(next_state, dev->cpu);
>>
>> -     entered_state = cpuidle_enter_state(dev, drv, next_state);
>> +     if (cpuidle_state_is_coupled(dev, drv, next_state))
>> +             entered_state = cpuidle_enter_state_coupled(dev, drv,
>> +                                                         next_state);
>> +     else
>> +             entered_state = cpuidle_enter_state(dev, drv, next_state);
>>
>>       trace_power_end_rcuidle(dev->cpu);
>>       trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>> @@ -407,9 +411,16 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>>       if (ret)
>>               goto err_sysfs;
>>
>> +     ret = cpuidle_coupled_register_device(dev);
>> +     if (ret)
>> +             goto err_coupled;
>> +
>>       dev->registered = 1;
>>       return 0;
>>
>> +err_coupled:
>> +     cpuidle_remove_sysfs(cpu_dev);
>> +     wait_for_completion(&dev->kobj_unregister);
>>  err_sysfs:
>>       list_del(&dev->device_list);
>>       per_cpu(cpuidle_devices, dev->cpu) = NULL;
>> @@ -464,6 +475,8 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
>>       wait_for_completion(&dev->kobj_unregister);
>>       per_cpu(cpuidle_devices, dev->cpu) = NULL;
>>
>> +     cpuidle_coupled_unregister_device(dev);
>> +
>>       cpuidle_resume_and_unlock();
>>
>>       module_put(cpuidle_driver->owner);
>> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
>> index d8a3ccc..76e7f69 100644
>> --- a/drivers/cpuidle/cpuidle.h
>> +++ b/drivers/cpuidle/cpuidle.h
>> @@ -32,4 +32,34 @@ extern int cpuidle_enter_state(struct cpuidle_device *dev,
>>  extern int cpuidle_add_sysfs(struct device *dev);
>>  extern void cpuidle_remove_sysfs(struct device *dev);
>>
>> +#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
>> +bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
>> +             struct cpuidle_driver *drv, int state);
>> +int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
>> +             struct cpuidle_driver *drv, int next_state);
>> +int cpuidle_coupled_register_device(struct cpuidle_device *dev);
>> +void cpuidle_coupled_unregister_device(struct cpuidle_device *dev);
>> +#else
>> +static inline bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
>> +             struct cpuidle_driver *drv, int state)
>> +{
>> +     return false;
>> +}
>> +
>> +static inline int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
>> +             struct cpuidle_driver *drv, int next_state)
>> +{
>> +     return -1;
>> +}
>> +
>> +static inline int cpuidle_coupled_register_device(struct cpuidle_device *dev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static inline void cpuidle_coupled_unregister_device(struct cpuidle_device *dev)
>> +{
>> +}
>> +#endif
>> +
>>  #endif /* __DRIVER_CPUIDLE_H */
>> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>> index 6c26a3d..6038448 100644
>> --- a/include/linux/cpuidle.h
>> +++ b/include/linux/cpuidle.h
>> @@ -57,6 +57,7 @@ struct cpuidle_state {
>>
>>  /* Idle State Flags */
>>  #define CPUIDLE_FLAG_TIME_VALID      (0x01) /* is residency time measurable? */
>> +#define CPUIDLE_FLAG_COUPLED (0x02) /* state applies to multiple cpus */
>>
>>  #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
>>
>> @@ -100,6 +101,12 @@ struct cpuidle_device {
>>       struct list_head        device_list;
>>       struct kobject          kobj;
>>       struct completion       kobj_unregister;
>> +
>> +#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
>> +     int                     safe_state_index;
>> +     cpumask_t               coupled_cpus;
>> +     struct cpuidle_coupled  *coupled;
>> +#endif
>>  };
>>
>>  DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
>
> Thanks,
> Rafael
