Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397Ab2EDWXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:23:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2EDWXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:23:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [linux-pm] [PATCHv3 3/5] cpuidle: add support for states that affect multiple cpus
Date: Sat, 5 May 2012 00:27:54 +0200
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
References: <1335816551-27756-1-git-send-email-ccross@android.com> <201205041351.25282.rjw@sisk.pl> <CAMbhsRRSGypR-N23vXbHSKLc_TPo6PTjQ2-PFicknCqX8tYq9Q@mail.gmail.com>
In-Reply-To: <CAMbhsRRSGypR-N23vXbHSKLc_TPo6PTjQ2-PFicknCqX8tYq9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205050027.54452.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Colin Cross wrote:
> On Fri, May 4, 2012 at 4:51 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 04, 2012, Colin Cross wrote:
> >> On Thu, May 3, 2012 at 3:14 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > [...]
> >>
> >> >> +/**
> >> >> + * cpuidle_coupled_cpus_waiting - check if all cpus in a coupled set are waiting
> >> >> + * @coupled: the struct coupled that contains the current cpu
> >> >> + *
> >> >> + * Returns true if all cpus coupled to this target state are in the wait loop
> >> >> + */
> >> >> +static inline bool cpuidle_coupled_cpus_waiting(struct cpuidle_coupled *coupled)
> >> >> +{
> >> >> +     int alive;
> >> >> +     int waiting;
> >> >> +
> >> >> +     /*
> >> >> +      * Read alive before reading waiting so a booting cpu is not treated as
> >> >> +      * idle
> >> >> +      */
> >> >
> >> > Well, the comment doesn't really explain much.  In particular, why the boot CPU
> >> > could be treated as idle if the reads were in a different order.
> >>
> >> Hm, I think the race condition is on a cpu going down.  What about:
> >> Read alive before reading waiting.  If waiting is read before alive,
> >> this cpu could see another cpu as waiting just before it goes offline,
> >> between when it the other cpu decrements waiting and when it
> >> decrements alive, which could cause alive == waiting when one cpu is
> >> not waiting.
> >
> > Reading them in this particular order doesn't stop the race, though.  I mean,
> > if the hotplug happens just right after you've read alive_count, you still have
> > a wrong value.  waiting_count is set independently, it seems, so there's no
> > ordering between the two on the "store" side and the "load" side ordering
> > doesn't matter.
> 
> As commented in the hotplug path, hotplug relies on the fact that one
> of the cpus in the cluster is involved in the hotplug of the cpu that
> is changing (this may not be true for multiple clusters, but it is
> easy to fix by IPI-ing to a cpu that is in the same cluster when that
> happens).

That's very fragile and potentially sets a trap for people trying to make
the kernel work on systems with multiple clusters.

> That means that waiting count is always guaranteed to be at
> least 1 less than alive count when alive count changes.  All this read
> ordering needs to do is make sure that this cpu doesn't see
> waiting_count == alive_count by reading them in the wrong order.

So, the concern seems to be that if the local CPU reorders the reads
from waiting_count and alive_count and enough time elapses between one
read and the other, the decrementation of waiting_count may happen
between them and then the CPU may use the outdated value for comparison,
right?

Still, though, even if the barrier is there, the modification of
alive_count in the hotplug notifier routine may not happen before
the read from alive_count in cpuidle_coupled_cpus_waiting() is completed.
Isn't that a problem?

> > I would just make the CPU hotplug notifier routine block until
> > cpuidle_enter_state_coupled() is done and the latter return immediately
> > if the CPU hotplug notifier routine is in progress, perhaps falling back
> > to the safe state.  Or I would make the CPU hotplug notifier routine
> > disable the "coupled cpuidle" entirely on DOWN_PREPARE and UP_PREPARE
> > and only re-enable it after the hotplug has been completed.
> 
> I'll take a look at disabling coupled idle completely during hotplug.

Great, thanks!

> >> >> +     alive = atomic_read(&coupled->alive_count);
> >> >> +     smp_rmb();
> >> >> +     waiting = atomic_read(&coupled->waiting_count);
> >> >
> >> > Have you considered using one atomic variable to accommodate both counters
> >> > such that the upper half contains one counter and the lower half contains
> >> > the other?
> >>
> >> There are 3 counters (alive, waiting, and ready).  Do you want me to
> >> squish all of them into a single atomic_t, which would limit to 1023
> >> cpus?
> >
> > No.  I'd make sure that cpuidle_enter_state_coupled() did't race with CPU
> > hotplug, so as to make alive_count stable from its standpoint, and I'd
> > put the two remaining counters into one atomic_t variable.
> 
> I'll take a look at using a single atomic_t.  My initial worry was
> that the increased contention on the shared variable would cause more
> cmpxchg retries, but since waiting_count and ready_count are designed
> to be modified in sequential phases that shouldn't be an issue.
> 
[...]
> >> >> +     while (!need_resched() && !cpuidle_coupled_cpus_waiting(coupled)) {
> >> >> +             entered_state = cpuidle_enter_state(dev, drv,
> >> >> +                     dev->safe_state_index);
> >> >> +
> >> >> +             local_irq_enable();
> >> >> +             while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
> >> >> +                     cpu_relax();
> >> >
> >> > Hmm.  What exactly is this loop supposed to achieve?
> >> This is to ensure that the outstanding wakeups have been processed so
> >> we don't go to idle with an interrupt pending an immediately wake up.
> >
> > I see.  Is it actually safe to reenable interrupts at this point, though?
> 
> I think so.  The normal idle loop will enable interrupts in a similar
> fashion to what happens here.  There are two things to worry about: a
> processed interrupt causing work to be scheduled that should bring
> this cpu out of idle, or changing the next timer which would
> invalidate the current requested state.  The first is handled by
> checking need_resched() after interrupts are disabled again, the
> second is currently unhandled but does not affect correct operation,
> it just races into a less-than-optimal idle state.

I see.

> >> >> +             local_irq_disable();
> >> >
> >> > Anyway, you seem to be calling it twice along with this enabling/disabling of
> >> > interrupts.  I'd put that into a separate function and explain its role in a
> >> > kerneldoc comment.
> >>
> >> I left it here to be obvious that I was enabling interrupts in the
> >> idle path, but I can refactor it out if you prefer.
> >
> > Well, you can call the function to make it obvious. :-)
> >
> > Anyway, I think that code duplication is a worse thing than a reasonable
> > amount of non-obviousness, so to speak.
> >
> >> >> +     }
> >> >> +
> >> >> +     /* give a chance to process any remaining pokes */
> >> >> +     local_irq_enable();
> >> >> +     while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
> >> >> +             cpu_relax();
> >> >> +     local_irq_disable();
> >> >> +
> >> >> +     if (need_resched()) {
> >> >> +             cpuidle_coupled_set_not_waiting(dev, coupled);
> >> >> +             goto out;
> >> >> +     }
> >> >> +
> >> >> +     /*
> >> >> +      * All coupled cpus are probably idle.  There is a small chance that
> >> >> +      * one of the other cpus just became active.  Increment a counter when
> >> >> +      * ready, and spin until all coupled cpus have incremented the counter.
> >> >> +      * Once a cpu has incremented the counter, it cannot abort idle and must
> >> >> +      * spin until either the count has hit alive_count, or another cpu
> >> >> +      * leaves idle.
> >> >> +      */
> >> >> +
> >> >> +     smp_mb__before_atomic_inc();
> >> >> +     atomic_inc(&coupled->ready_count);
> >> >> +     smp_mb__after_atomic_inc();
> >> >
> >> > It seems that at least one of these barriers is unnecessary ...
> >> The first is to ensure ordering between ready_count and waiting count,
> >
> > Are you afraid that the test against waiting_count from
> > cpuidle_coupled_cpus_waiting() may get reordered after the incrementation
> > of ready_count or is it something else?
> 
> Yes, ready_count must not be incremented before waiting_count == alive_count.

Well, control doesn't reach the atomic_inc() statement if this condition
is not satisfied, so I don't see how it can be possibly reordered before
the while () loop without breaking the control flow guarantees.

> >> the second is for ready_count vs. alive_count and requested_state.
> >
> > This one I can understand, but ...
> >
> >> >> +     /* alive_count can't change while ready_count > 0 */
> >> >> +     alive = atomic_read(&coupled->alive_count);
> >
> > What happens if CPU hotplug happens right here?
> 
> According to the comment above that line that can't happen -
> alive_count can't change while ready_count > 0, because that implies
> that all cpus are waiting and none can be in the hotplug path where
> alive_count is changed.  Looking at it again that is not entirely
> true, alive_count could change on systems with >2 cpus, but I think it
> can't cause an issue because alive_count would be 2 greater than
> waiting_count before alive_count was changed.  Either way, it will be
> fixed by disabling coupled idle during hotplug.

Yup.

> >> >> +     while (atomic_read(&coupled->ready_count) != alive) {
> >> >> +             /* Check if any other cpus bailed out of idle. */
> >> >> +             if (!cpuidle_coupled_cpus_waiting(coupled)) {
> >> >> +                     atomic_dec(&coupled->ready_count);
> >> >> +                     smp_mb__after_atomic_dec();
> >
> > And the barrier here?  Even if the old value of ready_count leaks into
> > the while () loop after retry, that doesn't seem to matter.
> 
> All of these will be academic if ready_count and waiting_count share
> an atomic_t.
> waiting_count must not be decremented by exiting the while loop after
> the retry label until ready_count is decremented here, but that is
> also protected by the barrier in set_not_waiting.  One of them could
> be dropped.
> 
> >> >> +                     goto retry;
> >> >> +             }
> >> >> +
> >> >> +             cpu_relax();
> >> >> +     }
> >> >> +
> >> >> +     /* all cpus have acked the coupled state */
> >> >> +     smp_rmb();
> >> >
> >> > What is the barrier here for?
> >> This protects ready_count vs. requested_state.  It is already
> >> implicitly protected by the atomic_inc_return in set_waiting, but I
> >> thought it would be better to protect it explicitly here.  I think I
> >> added the smp_mb__after_atomic_inc above later, which makes this one
> >> superflous, so I'll drop it.
> >
> > OK
> >
> >> >> +
> >> >> +     next_state = cpuidle_coupled_get_state(dev, coupled);
> >> >> +
> >> >> +     entered_state = cpuidle_enter_state(dev, drv, next_state);
> >> >> +
> >> >> +     cpuidle_coupled_set_not_waiting(dev, coupled);
> >> >> +     atomic_dec(&coupled->ready_count);
> >> >> +     smp_mb__after_atomic_dec();
> >> >> +
> >> >> +out:
> >> >> +     /*
> >> >> +      * Normal cpuidle states are expected to return with irqs enabled.
> >> >> +      * That leads to an inefficiency where a cpu receiving an interrupt
> >> >> +      * that brings it out of idle will process that interrupt before
> >> >> +      * exiting the idle enter function and decrementing ready_count.  All
> >> >> +      * other cpus will need to spin waiting for the cpu that is processing
> >> >> +      * the interrupt.  If the driver returns with interrupts disabled,
> >> >> +      * all other cpus will loop back into the safe idle state instead of
> >> >> +      * spinning, saving power.
> >> >> +      *
> >> >> +      * Calling local_irq_enable here allows coupled states to return with
> >> >> +      * interrupts disabled, but won't cause problems for drivers that
> >> >> +      * exit with interrupts enabled.
> >> >> +      */
> >> >> +     local_irq_enable();
> >> >> +
> >> >> +     /*
> >> >> +      * Wait until all coupled cpus have exited idle.  There is no risk that
> >> >> +      * a cpu exits and re-enters the ready state because this cpu has
> >> >> +      * already decremented its waiting_count.
> >> >> +      */
> >> >> +     while (atomic_read(&coupled->ready_count) != 0)
> >> >> +             cpu_relax();
> >> >> +
> >> >> +     smp_rmb();
> >> >
> >> > And here?
> >>
> >> This was to protect ready_count vs. looping back in and reading
> >> alive_count.
> >
> > Well, I'm lost. :-)
> >
> > You've not modified anything after the previous smp_mb__after_atomic_dec(),
> > so what exactly is the reordering this is supposed to work against?
> >
> > And while we're at it, I'm not quite sure what the things that the previous
> > smp_mb__after_atomic_dec() separates from each other are.
> 
> Instead of justifying all of these, let me try the combined atomic_t
> trick and justify the (many fewer) remaining barriers.

OK, cool! :-)

Thanks,
Rafael
