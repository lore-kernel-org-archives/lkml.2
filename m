Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2EDLqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:46:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53087 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab2EDLqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:46:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [linux-pm] [PATCHv3 3/5] cpuidle: add support for states that affect multiple cpus
Date: Fri, 4 May 2012 13:51:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
References: <1335816551-27756-1-git-send-email-ccross@android.com> <201205040014.05880.rjw@sisk.pl> <CAMbhsRQVH=f+2A_JXg3J2NKvC3dxqPk-QUDcbQ3G9Rv426c3AA@mail.gmail.com>
In-Reply-To: <CAMbhsRQVH=f+2A_JXg3J2NKvC3dxqPk-QUDcbQ3G9Rv426c3AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041351.25282.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Colin Cross wrote:
> On Thu, May 3, 2012 at 3:14 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
[...]
> 
> >> +/**
> >> + * cpuidle_coupled_cpus_waiting - check if all cpus in a coupled set are waiting
> >> + * @coupled: the struct coupled that contains the current cpu
> >> + *
> >> + * Returns true if all cpus coupled to this target state are in the wait loop
> >> + */
> >> +static inline bool cpuidle_coupled_cpus_waiting(struct cpuidle_coupled *coupled)
> >> +{
> >> +     int alive;
> >> +     int waiting;
> >> +
> >> +     /*
> >> +      * Read alive before reading waiting so a booting cpu is not treated as
> >> +      * idle
> >> +      */
> >
> > Well, the comment doesn't really explain much.  In particular, why the boot CPU
> > could be treated as idle if the reads were in a different order.
> 
> Hm, I think the race condition is on a cpu going down.  What about:
> Read alive before reading waiting.  If waiting is read before alive,
> this cpu could see another cpu as waiting just before it goes offline,
> between when it the other cpu decrements waiting and when it
> decrements alive, which could cause alive == waiting when one cpu is
> not waiting.

Reading them in this particular order doesn't stop the race, though.  I mean,
if the hotplug happens just right after you've read alive_count, you still have
a wrong value.  waiting_count is set independently, it seems, so there's no
ordering between the two on the "store" side and the "load" side ordering
doesn't matter.

I would just make the CPU hotplug notifier routine block until
cpuidle_enter_state_coupled() is done and the latter return immediately
if the CPU hotplug notifier routine is in progress, perhaps falling back
to the safe state.  Or I would make the CPU hotplug notifier routine
disable the "coupled cpuidle" entirely on DOWN_PREPARE and UP_PREPARE
and only re-enable it after the hotplug has been completed.

> >> +     alive = atomic_read(&coupled->alive_count);
> >> +     smp_rmb();
> >> +     waiting = atomic_read(&coupled->waiting_count);
> >
> > Have you considered using one atomic variable to accommodate both counters
> > such that the upper half contains one counter and the lower half contains
> > the other?
> 
> There are 3 counters (alive, waiting, and ready).  Do you want me to
> squish all of them into a single atomic_t, which would limit to 1023
> cpus?

No.  I'd make sure that cpuidle_enter_state_coupled() did't race with CPU
hotplug, so as to make alive_count stable from its standpoint, and I'd
put the two remaining counters into one atomic_t variable.

> >> +
> >> +     return (waiting == alive);
> >> +}
> >> +
> >> +/**
> >> + * cpuidle_coupled_get_state - determine the deepest idle state
> >> + * @dev: struct cpuidle_device for this cpu
> >> + * @coupled: the struct coupled that contains the current cpu
> >> + *
> >> + * Returns the deepest idle state that all coupled cpus can enter
> >> + */
> >> +static inline int cpuidle_coupled_get_state(struct cpuidle_device *dev,
> >> +             struct cpuidle_coupled *coupled)
> >> +{
> >> +     int i;
> >> +     int state = INT_MAX;
> >> +
> >> +     for_each_cpu_mask(i, coupled->coupled_cpus)
> >> +             if (coupled->requested_state[i] != CPUIDLE_COUPLED_DEAD &&
> >> +                 coupled->requested_state[i] < state)
> >> +                     state = coupled->requested_state[i];
> >> +
> >> +     BUG_ON(state >= dev->state_count || state < 0);
> >
> > Do you have to crash the kernel here if the assertion doesn't hold?  Maybe
> > you could use WARN_ON() and return error code?
> 
> If this BUG_ON is hit, there is a race condition somewhere that
> allowed a cpu out of idle unexpectedly, and there is no way to recover
> without more race conditions.  I don't expect this to ever happen, it
> is mostly there to detect race conditions during development.  Should
> I drop it completely?

I would just drop it, then, in the final respin of the patch.

[...]
> >> +{
> >> +     int alive;
> >> +
> >> +     BUG_ON(coupled->requested_state[dev->cpu] >= 0);
> >
> > Would be WARN_ON() + do nothing too dangerous here?
> 
> If this BUG_ON is hit, then this cpu exited idle without clearing its
> waiting state, which could cause another cpu to enter the deeper idle
> state while this cpu is still running.  The counters would be out of
> sync, so it's not easy to recover.  Again, this is to detect race
> conditions during development, but should never happen.  Should I drop
> it?

Just like above.

> >> +
> >> +     coupled->requested_state[dev->cpu] = next_state;
> >> +
> >> +     /*
> >> +      * If this is the last cpu to enter the waiting state, poke
> >> +      * all the other cpus out of their waiting state so they can
> >> +      * enter a deeper state.  This can race with one of the cpus
> >> +      * exiting the waiting state due to an interrupt and
> >> +      * decrementing waiting_count, see comment below.
> >> +      */
> >> +     alive = atomic_read(&coupled->alive_count);
> >> +     if (atomic_inc_return(&coupled->waiting_count) == alive)
> >> +             cpuidle_coupled_poke_others(dev, coupled);
> >> +}
> >> +
> >> +/**
> >> + * cpuidle_coupled_set_not_waiting - mark this cpu as leaving the wait loop
> >> + * @dev: struct cpuidle_device for this cpu
> >> + * @coupled: the struct coupled that contains the current cpu
> >> + *
> >> + * Removes the requested idle state for the specified cpuidle device.
> >> + *
> >> + * Provides memory ordering around waiting_count.
> >> + */
> >> +static void cpuidle_coupled_set_not_waiting(struct cpuidle_device *dev,
> >> +             struct cpuidle_coupled *coupled)
> >
> > It looks like dev doesn't have to be passed here, cpu would be enough.
> >
> >> +{
> >> +     BUG_ON(coupled->requested_state[dev->cpu] < 0);
> >
> > Well, like above?
> Same as above.

Ditto. :-)

> >> +
> >> +     /*
> >> +      * Decrementing waiting_count can race with incrementing it in
> >> +      * cpuidle_coupled_set_waiting, but that's OK.  Worst case, some
> >> +      * cpus will increment ready_count and then spin until they
> >> +      * notice that this cpu has cleared it's requested_state.
> >> +      */
> >
> > So it looks like having ready_count and waiting_count in one atomic variable
> > can spare us this particular race condition.
> As above, there are 3 counters here, alive, ready, and waiting.

Please refer to my comment about that above.

> >> +
> >> +     smp_mb__before_atomic_dec();
> >> +     atomic_dec(&coupled->waiting_count);
> >> +     smp_mb__after_atomic_dec();
> >
> > Do you really need both the before and after barriers here?  If so, then why?
> 
> I believe so, waiting is ordered vs. alive and ready, one barrier is
> for each.  Do you want the answers to these questions here or in the
> code?  I had comments for every barrier use during development, but it
> made it too hard to follow the flow of the code.  I could add a
> comment describing the ordering requirements instead, but it's still
> hard to translate that to the required barrier locations.

Well, the barriers should be commented in the code, for the sake of people
reading it and wanting to learn from it if nothing else.

Wherever we put an SMP barrier directly like this, there should be a good
reason for that and it should be documented.

[...]
> >> + */
> >> +int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
> >> +             struct cpuidle_driver *drv, int next_state)
> >> +{
> >> +     int entered_state = -1;
> >> +     struct cpuidle_coupled *coupled = dev->coupled;
> >> +     int alive;
> >> +
> >> +     if (!coupled)
> >> +             return -EINVAL;
> >> +
> >> +     BUG_ON(atomic_read(&coupled->ready_count));
> >
> > Again, I'd do a WARN_ON() and return error code from here (to avoid crashing
> > the kernel).
> Same as above, if ready_count is not 0 here then the counters are out
> of sync and something is about to go horribly wrong, like cutting
> power to a running cpu.

OK

> >> +     cpuidle_coupled_set_waiting(dev, coupled, next_state);
> >> +
> >> +retry:
> >> +     /*
> >> +      * Wait for all coupled cpus to be idle, using the deepest state
> >> +      * allowed for a single cpu.
> >> +      */
> >> +     while (!need_resched() && !cpuidle_coupled_cpus_waiting(coupled)) {
> >> +             entered_state = cpuidle_enter_state(dev, drv,
> >> +                     dev->safe_state_index);
> >> +
> >> +             local_irq_enable();
> >> +             while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
> >> +                     cpu_relax();
> >
> > Hmm.  What exactly is this loop supposed to achieve?
> This is to ensure that the outstanding wakeups have been processed so
> we don't go to idle with an interrupt pending an immediately wake up.

I see.  Is it actually safe to reenable interrupts at this point, though?

> >> +             local_irq_disable();
> >
> > Anyway, you seem to be calling it twice along with this enabling/disabling of
> > interrupts.  I'd put that into a separate function and explain its role in a
> > kerneldoc comment.
> 
> I left it here to be obvious that I was enabling interrupts in the
> idle path, but I can refactor it out if you prefer.

Well, you can call the function to make it obvious. :-)

Anyway, I think that code duplication is a worse thing than a reasonable
amount of non-obviousness, so to speak.

> >> +     }
> >> +
> >> +     /* give a chance to process any remaining pokes */
> >> +     local_irq_enable();
> >> +     while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
> >> +             cpu_relax();
> >> +     local_irq_disable();
> >> +
> >> +     if (need_resched()) {
> >> +             cpuidle_coupled_set_not_waiting(dev, coupled);
> >> +             goto out;
> >> +     }
> >> +
> >> +     /*
> >> +      * All coupled cpus are probably idle.  There is a small chance that
> >> +      * one of the other cpus just became active.  Increment a counter when
> >> +      * ready, and spin until all coupled cpus have incremented the counter.
> >> +      * Once a cpu has incremented the counter, it cannot abort idle and must
> >> +      * spin until either the count has hit alive_count, or another cpu
> >> +      * leaves idle.
> >> +      */
> >> +
> >> +     smp_mb__before_atomic_inc();
> >> +     atomic_inc(&coupled->ready_count);
> >> +     smp_mb__after_atomic_inc();
> >
> > It seems that at least one of these barriers is unnecessary ...
> The first is to ensure ordering between ready_count and waiting count,

Are you afraid that the test against waiting_count from
cpuidle_coupled_cpus_waiting() may get reordered after the incrementation
of ready_count or is it something else?

> the second is for ready_count vs. alive_count and requested_state.

This one I can understand, but ...

> >> +     /* alive_count can't change while ready_count > 0 */
> >> +     alive = atomic_read(&coupled->alive_count);

What happens if CPU hotplug happens right here?

> >> +     while (atomic_read(&coupled->ready_count) != alive) {
> >> +             /* Check if any other cpus bailed out of idle. */
> >> +             if (!cpuidle_coupled_cpus_waiting(coupled)) {
> >> +                     atomic_dec(&coupled->ready_count);
> >> +                     smp_mb__after_atomic_dec();

And the barrier here?  Even if the old value of ready_count leaks into
the while () loop after retry, that doesn't seem to matter.

> >> +                     goto retry;
> >> +             }
> >> +
> >> +             cpu_relax();
> >> +     }
> >> +
> >> +     /* all cpus have acked the coupled state */
> >> +     smp_rmb();
> >
> > What is the barrier here for?
> This protects ready_count vs. requested_state.  It is already
> implicitly protected by the atomic_inc_return in set_waiting, but I
> thought it would be better to protect it explicitly here.  I think I
> added the smp_mb__after_atomic_inc above later, which makes this one
> superflous, so I'll drop it.

OK

> >> +
> >> +     next_state = cpuidle_coupled_get_state(dev, coupled);
> >> +
> >> +     entered_state = cpuidle_enter_state(dev, drv, next_state);
> >> +
> >> +     cpuidle_coupled_set_not_waiting(dev, coupled);
> >> +     atomic_dec(&coupled->ready_count);
> >> +     smp_mb__after_atomic_dec();
> >> +
> >> +out:
> >> +     /*
> >> +      * Normal cpuidle states are expected to return with irqs enabled.
> >> +      * That leads to an inefficiency where a cpu receiving an interrupt
> >> +      * that brings it out of idle will process that interrupt before
> >> +      * exiting the idle enter function and decrementing ready_count.  All
> >> +      * other cpus will need to spin waiting for the cpu that is processing
> >> +      * the interrupt.  If the driver returns with interrupts disabled,
> >> +      * all other cpus will loop back into the safe idle state instead of
> >> +      * spinning, saving power.
> >> +      *
> >> +      * Calling local_irq_enable here allows coupled states to return with
> >> +      * interrupts disabled, but won't cause problems for drivers that
> >> +      * exit with interrupts enabled.
> >> +      */
> >> +     local_irq_enable();
> >> +
> >> +     /*
> >> +      * Wait until all coupled cpus have exited idle.  There is no risk that
> >> +      * a cpu exits and re-enters the ready state because this cpu has
> >> +      * already decremented its waiting_count.
> >> +      */
> >> +     while (atomic_read(&coupled->ready_count) != 0)
> >> +             cpu_relax();
> >> +
> >> +     smp_rmb();
> >
> > And here?
> 
> This was to protect ready_count vs. looping back in and reading
> alive_count.

Well, I'm lost. :-)

You've not modified anything after the previous smp_mb__after_atomic_dec(),
so what exactly is the reordering this is supposed to work against?

And while we're at it, I'm not quite sure what the things that the previous
smp_mb__after_atomic_dec() separates from each other are.

> There will be plenty of synchronization calls between
> the two with implicit barriers, but I thought it was better to do it
> explicitly.

[...]
> >> +static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
> >> +{
> >> +     struct cpuidle_device *dev;
> >> +     struct cpuidle_coupled *coupled;
> >> +
> >> +     mutex_lock(&cpuidle_lock);
> >> +
> >> +     dev = per_cpu(cpuidle_devices, cpu);
> >> +     if (!dev->coupled)
> >> +             goto out;
> >> +
> >> +     coupled = dev->coupled;
> >> +
> >> +     /*
> >> +      * waiting_count must be at least 1 less than alive_count, because
> >> +      * this cpu is not waiting.  Spin until all cpus have noticed this cpu
> >> +      * is not idle and exited the ready loop before changing alive_count.
> >> +      */
> >> +     while (atomic_read(&coupled->ready_count))
> >> +             cpu_relax();
> >> +
> >> +     if (alive) {
> >> +             smp_mb__before_atomic_inc();
> >> +             atomic_inc(&coupled->alive_count);
> >> +             smp_mb__after_atomic_inc();
> >> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
> >> +     } else {
> >> +             smp_mb__before_atomic_dec();
> >> +             atomic_dec(&coupled->alive_count);
> >> +             smp_mb__after_atomic_dec();
> >> +             coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
> >
> > There's too many SMP barriers above, but I'm not quite sure which of them (if
> > any) are really necessary.
> The ones before order ready_count vs alive_count, the ones after order
> alive_count vs. requested_state and future waiting_count increments.

Well, so what are the matching barriers for these?

Rafael
