Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2BWTeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:34:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42156 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2BWTeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:34:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.50.222.132 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <1329989454.24994.57.camel@twins>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	<1329989454.24994.57.camel@twins>
Date: Thu, 23 Feb 2012 11:34:11 -0800
Message-ID: <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts
 to an idle CPU -v1
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 1:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, 2012-02-22 at 16:36 -0800, Venkatesh Pallipadi wrote:
>
> > Changes since previous versions:
>
> >   Moved the changes into arch specific code as per PeterZ suggestion
>
> You failed:
>
> >  include/linux/sched.h               |    2 +
> >  kernel/sched/core.c                 |   13 ++++++
>
>
>
> > diff --git a/arch/x86/include/asm/ipiless_poke.h
> > b/arch/x86/include/asm/ipiless_poke.h
> > new file mode 100644
> > index 0000000..58670c7
> > --- /dev/null
> > +++ b/arch/x86/include/asm/ipiless_poke.h
> > @@ -0,0 +1,82 @@
> > +#ifndef _ASM_X86_IPILESS_POKE_H
> > +#define _ASM_X86_IPILESS_POKE_H
> > +
> > +#include <linux/sched.h>
> > +#include <asm/thread_info.h>
> > +
> > +#ifdef CONFIG_SMP
> > +
> > +DECLARE_PER_CPU(atomic_t *, idle_task_ti_flags);
> > +
> > +/*
> > + * Use 2 bits in idle_task's thead info flags:
> > + * TIF_IPILESS_IDLE marks enter to and exit from idle states with
> > ipiless
> > + * wakeup capability.
> > + * TIF_IPI_PENDING set by IPI source CPU if it finds that the IPI
> > target CPU
> > + * is in TIF_IPILESS_IDLE state (and TIF_IPI_PENDING is not already
> > set).
> > + * Setting of TIF_IPI_PENDING bit brings the target CPU out of idle
> > state.
> > + */
> > +
> > +static inline void ipiless_idle_enter(void)
> > +{
> > +     set_thread_flag(TIF_IPILESS_IDLE);
> > +}
> > +
> > +static inline void ipiless_idle_exit(void)
> > +{
> > +     clear_thread_flag(TIF_IPILESS_IDLE);
> > +}
> > +
> > +static inline int is_ipi_pending(void)
> > +{
> > +     return unlikely(test_thread_flag(TIF_IPI_PENDING));
> > +}
> > +
> > +static inline int need_wakeup(void)
> > +{
> > +     return need_resched() || is_ipi_pending();
> > +}
> > +
> > +static inline void ipiless_pending_work(void)
> > +{
> > +     if (is_ipi_pending()) {
> > +             clear_thread_flag(TIF_IPI_PENDING);
> > +             local_bh_disable();
> > +             local_irq_disable();
>
> That local_bh_disable() is completely superfluous, disabling IRQs
> already kills bh.

The reason for local_bh_disable/enable was to check for potential
softirqs after these interrupt.

>
> > +             generic_smp_call_function_single_interrupt();
> > +             __scheduler_ipi();
>
> Why not scheduler_ipi()?

Was trying to avoid irq_enter/exit. As the work here is done in idle
thread context, I though we could avoid enter/exit. Also, if we need
it, we should ideally do it once across scheduler and smp_call work
together instead of in scheduler_ipi().

>
> Also, you could keep a pending vector bitmask in a per-cpu variable to
> avoid having to call all handlers. not sure that's worth it for just
> two, but something to keep in mind for if/when this starts expanding.
>

Agree. For anything more than two, it will be better to have an
additional bitmask.

> > +             local_irq_enable();
> > +             local_bh_enable();
> > +     }
> > +}
>
> Why doesn't ipiless_idle_exit() call this? That would keep it isolated
> to just those idle routines that actually use mwait instead of bothering
> the generic idle paths with this.

ipiless_idle_exit is called in the inner most part of idle entry exit.
In mwait case we may not even have interrupts enabled at that time and
there is code that does idle residency timing etc which will get
impacted if we start doing the pending ipi work there. Doing it at
higher level along with things like enter-exit tickless felt nicer.

>
> > +static inline int ipiless_magic_poke(int cpu)
> > +{
> > +     int val;
> > +     atomic_t *idle_flag = per_cpu(idle_task_ti_flags, cpu);
>
> What's this atomic_t nonsense about? thread_info::flags is __u32,
> casting it to atomic_t is complete rubbish.
>

I have to say I was not a big fan of that typecast as well. I just did
not know about ACCESS_ONCE() interface.
Thanks for the tips below. This is the first thing I am going to
change in this patch.

> > +
> > +     val = atomic_read(idle_flag);
>
> The __u32 version would look like: val = ACCESS_ONCE(*idle_flag);
>
> > +     if (unlikely(val & _TIF_IPI_PENDING))
> > +             return 1;
> > +
> > +     if (!(val & _TIF_IPILESS_IDLE))
> > +             return 0;
> > +
> > +     if (val == atomic_cmpxchg(idle_flag, val, val | _TIF_IPI_PENDING))
>
> The __u32 version would look like:
>
>  if (val == cmpxchg(idle_flag, val, val | _TIF_IPI_PENDING))
>
> Bonus win for being shorter!
>
> > +             return 1;
> > +
> > +     return 0;
> > +}
> > +
> > +#else
> > +static inline void ipiless_pending_work(void) { }
> > +static inline void ipiless_idle_enter(void) { }
> > +static inline void ipiless_idle_exit(void) { }
> > +
> > +static inline int need_wakeup(void)
> > +{
> > +     return need_resched();
> > +}
> > +#endif
> > +
> > +#endif /* _ASM_X86_IPILESS_POKE_H */
>
>
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index a8ff227..e66a4c8 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -27,6 +27,7 @@
> >  #include <asm/mtrr.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> > +#include <asm/ipiless_poke.h>
> >  #include <asm/proto.h>
> >  #include <asm/apic.h>
> >  #include <asm/nmi.h>
> > @@ -109,6 +110,14 @@
> >   *   about nothing of note with C stepping upwards.
> >   */
> >
> > +DEFINE_PER_CPU(atomic_t *, idle_task_ti_flags);
> > +
> > +void __cpuinit thread_idle_state_setup(struct task_struct *idle, int
> > cpu)
> > +{
> > +     per_cpu(idle_task_ti_flags, cpu) =
> > +                             (atomic_t
> > *)(&(task_thread_info(idle)->flags));
> > +}
>
> As Ingo already pointed out, its the architecture that actually sets up
> the idle threads, so putting callbacks into the generic code to find
> them is kinda backwards.

Yes. I need to spend a bit more time looking at cleanups Ingo suggested.

>
> Again, *yuck* at that atomic_t business.

They are gone now...

>
>
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 5255c9d..1558316 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1451,6 +1451,14 @@ static void sched_ttwu_pending(void)
> >       raw_spin_unlock(&rq->lock);
> >  }
> >
> > +void __scheduler_ipi(void)
> > +{
> > +     if (llist_empty(&this_rq()->wake_list))
> > +             return;
> > +
> > +     sched_ttwu_pending();
> > +}
>
> FAIL!! It should be 100% identical to a normal IPI, that calls
> scheduler_ipi() so this should too.
>
> >  void scheduler_ipi(void)
> >  {
> >       if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
> > @@ -4827,6 +4835,10 @@ void __cpuinit init_idle_bootup_task(struct
> > task_struct *idle)
> >       idle->sched_class = &idle_sched_class;
> >  }
> >
> > +void __cpuinit __weak thread_idle_state_setup(struct task_struct *idle,
> > int cpu)
> > +{
> > +}
> > +
> >  /**
> >   * init_idle - set up an idle thread for a given CPU
> >   * @idle: task in question
> > @@ -4869,6 +4881,7 @@ void __cpuinit init_idle(struct task_struct *idle,
> > int cpu)
> >
> >       /* Set the preempt count _outside_ the spinlocks! */
> >       task_thread_info(idle)->preempt_count = 0;
> > +     thread_idle_state_setup(idle, cpu);
>
> I suggest you put this in smpboot.c someplace ;-)

Thanks,
Venki
