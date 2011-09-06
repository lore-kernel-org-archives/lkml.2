Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1IFRaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:30:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1IFRaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:30:24 -0400
Date: Tue, 6 Sep 2011 12:52:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Corey Minyard <minyard@acm.org>,
        Jack Steiner <steiner@sgi.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [V3][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
Message-ID: <20110906165253.GP5795@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-4-git-send-email-dzickus@redhat.com>
 <20110906161545.GH14200@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906161545.GH14200@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 06:15:45PM +0200, Robert Richter wrote:
> On 25.08.11 12:45:45, Don Zickus wrote:
> > Just convert all the files that have an nmi handler to the new routines.
> > Most of it is straight forward conversion.  A couple of places needed some
> > tweaking like kgdb which separates the debug notifier from the nmi handler
> > and mce removes a call to notify_die (as I couldn't figure out why it was
> > there).
> 
> For mce, see my comment below.
> 
> > 
> > The things that get converted are the registeration/unregistration routines
> > and the nmi handler itself has its args changed along with code removal
> > to check which list it is on (most are on one NMI list except for kgdb
> > which has both an NMI routine and an NMI Unknown routine).
> > 
> > Cc: Jason Wessel <jason.wessel@windriver.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: Robert Richter <robert.richter@amd.com>
> > Cc: Huang Ying <ying.huang@intel.com>
> > Cc: Corey Minyard <minyard@acm.org>
> > Cc: Jack Steiner <steiner@sgi.com>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  arch/x86/include/asm/nmi.h              |   20 ----------
> >  arch/x86/include/asm/reboot.h           |    2 +-
> >  arch/x86/kernel/apic/hw_nmi.c           |   27 +++-----------
> >  arch/x86/kernel/apic/x2apic_uv_x.c      |   20 ++--------
> >  arch/x86/kernel/cpu/mcheck/mce-inject.c |   20 ++++-------
> >  arch/x86/kernel/cpu/mcheck/mce.c        |    3 --
> >  arch/x86/kernel/cpu/perf_event.c        |   60 +++----------------------------
> >  arch/x86/kernel/crash.c                 |    5 +--
> >  arch/x86/kernel/kgdb.c                  |   60 +++++++++++++++++++++++--------
> >  arch/x86/kernel/nmi.c                   |   11 ++++--
> >  arch/x86/kernel/reboot.c                |   23 ++++--------
> >  arch/x86/oprofile/nmi_int.c             |   40 ++++++--------------
> >  arch/x86/oprofile/nmi_timer_int.c       |   28 +++-----------
> >  drivers/acpi/apei/ghes.c                |   22 ++++-------
> >  drivers/char/ipmi/ipmi_watchdog.c       |   32 +++++-----------
> >  drivers/watchdog/hpwdt.c                |   23 +++---------
> >  16 files changed, 125 insertions(+), 271 deletions(-)
> 
> 
> > diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> > index adc66c3..88b0dbb 100644
> > --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> > +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> > @@ -673,18 +673,11 @@ void __cpuinit uv_cpu_init(void)
> >  /*
> >   * When NMI is received, print a stack trace.
> >   */
> > -int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
> > +int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
> >  {
> >         unsigned long real_uv_nmi;
> >         int bid;
> > 
> > -       if (reason != DIE_NMIUNKNOWN)
> > -               return NOTIFY_OK;
> > -
> > -       if (in_crash_kexec)
> > -               /* do nothing if entering the crash kernel */
> > -               return NOTIFY_OK;
> 
> Isn't this removed without a replacement so this check is missing now?
> Code will be executed now in case of in_crash_kexec.

This code was bogus to begin with.  The reason it was executed was because
the kexec stuff had a lower priority.  I fixed this but using a higer
priority in the old code and the flag NMI_FLAG_FIRST, with this change for
the kexec stuff.

SGI was trying to testing the higher priority fix when they ran into
issues with 2048 cpus.  The 1024 case worked.  I don't think they ever
got around to re-running the test case again to verify changing the
priorities obsoletes the above change.

> 
> > -
> >         /*
> >          * Each blade has an MMR that indicates when an NMI has been sent
> >          * to cpus on the blade. If an NMI is detected, atomically
> 
> 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > index 0ed633c..6199232 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > @@ -78,27 +78,20 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
> > 
> >  static cpumask_var_t mce_inject_cpumask;
> > 
> > -static int mce_raise_notify(struct notifier_block *self,
> > -                           unsigned long val, void *data)
> > +static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
> >  {
> > -       struct die_args *args = (struct die_args *)data;
> >         int cpu = smp_processor_id();
> >         struct mce *m = &__get_cpu_var(injectm);
> > -       if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
> > -               return NOTIFY_DONE;
> > +       if (!cpumask_test_cpu(cpu, mce_inject_cpumask))
> > +               return NMI_DONE;
> >         cpumask_clear_cpu(cpu, mce_inject_cpumask);
> >         if (m->inject_flags & MCJ_EXCEPTION)
> > -               raise_exception(m, args->regs);
> > +               raise_exception(m, regs);
> >         else if (m->status)
> >                 raise_poll(m);
> > -       return NOTIFY_STOP;
> > +       return NMI_HANDLED;
> >  }
> > 
> > -static struct notifier_block mce_raise_nb = {
> > -       .notifier_call = mce_raise_notify,
> > -       .priority = NMI_LOCAL_NORMAL_PRIOR,
> > -};
> > -
> >  /* Inject mce on current CPU */
> >  static int raise_local(void)
> >  {
> > @@ -216,7 +209,8 @@ static int inject_init(void)
> >                 return -ENOMEM;
> >         printk(KERN_INFO "Machine check injector initialized\n");
> >         mce_chrdev_ops.write = mce_write;
> > -       register_die_notifier(&mce_raise_nb);
> > +       register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0,
> > +                               "mce_notify");
> >         return 0;
> >  }
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index 08363b0..3fc65b6 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -908,9 +908,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
> > 
> >         percpu_inc(mce_exception_count);
> > 
> > -       if (notify_die(DIE_NMI, "machine check", regs, error_code,
> > -                          18, SIGKILL) == NOTIFY_STOP)
> > -               goto out;
> 
> Yes, this code is strange. I checked all the nmi handlers but couldn't
> find one that is direct related to this call. But it could be to
> handle IPIs even in the case of an mce to let backtrace and reboot
> work. CC'ing mce guys.
> 
> I would rather add an nmi_handle() call here.

I checked to and the code predates 2.6.12, so I have no idea why it was
there.  One of the reasons I wanted to remove it was to keep all the users
internal to the nmi.c file.  Also I remove most of the parameters from
notify_die as they were not being used.  I would hate to add them back in
because of an mce hack.

I'm sure after 4-5 years (whenever this was added), we can find a better
way to do whatever it is doing, no?

But if I have to support this call, it complicates all the changes I made
unnecessarily. :-(

> 
> >         if (!banks)
> >                 goto out;
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 4ee3abf..767371f 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -1375,68 +1375,18 @@ struct pmu_nmi_state {
> >  static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
> > 
> >  static int __kprobes
> > -perf_event_nmi_handler(struct notifier_block *self,
> > -                        unsigned long cmd, void *__args)
> > +perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
> >  {
> > -       struct die_args *args = __args;
> > -       unsigned int this_nmi;
> >         int handled;
> > 
> >         if (!atomic_read(&active_events))
> > -               return NOTIFY_DONE;
> > +               return NMI_DONE;
> > 
> > -       switch (cmd) {
> > -       case DIE_NMI:
> > -               break;
> > -       case DIE_NMIUNKNOWN:
> > -               this_nmi = percpu_read(irq_stat.__nmi_count);
> > -               if (this_nmi != __this_cpu_read(pmu_nmi.marked))
> > -                       /* let the kernel handle the unknown nmi */
> > -                       return NOTIFY_DONE;
> > -               /*
> > -                * This one is a PMU back-to-back nmi. Two events
> > -                * trigger 'simultaneously' raising two back-to-back
> > -                * NMIs. If the first NMI handles both, the latter
> > -                * will be empty and daze the CPU. So, we drop it to
> > -                * avoid false-positive 'unknown nmi' messages.
> > -                */
> > -               return NOTIFY_STOP;
> > -       default:
> > -               return NOTIFY_DONE;
> > -       }
> > -
> > -       handled = x86_pmu.handle_irq(args->regs);
> > -       if (!handled)
> > -               return NOTIFY_DONE;
> > -
> > -       this_nmi = percpu_read(irq_stat.__nmi_count);
> > -       if ((handled > 1) ||
> > -               /* the next nmi could be a back-to-back nmi */
> > -           ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
> > -            (__this_cpu_read(pmu_nmi.handled) > 1))) {
> > -               /*
> > -                * We could have two subsequent back-to-back nmis: The
> > -                * first handles more than one counter, the 2nd
> > -                * handles only one counter and the 3rd handles no
> > -                * counter.
> > -                *
> > -                * This is the 2nd nmi because the previous was
> > -                * handling more than one counter. We will mark the
> > -                * next (3rd) and then drop it if unhandled.
> > -                */
> > -               __this_cpu_write(pmu_nmi.marked, this_nmi + 1);
> > -               __this_cpu_write(pmu_nmi.handled, handled);
> 
> You replace the back-to-back logic by using swallow_nmi later. The
> case above is not covered. Suppose a 2-1-0 sequence of handled nmis.
> Your new code only covers the 2-0 case and will trigger an unknown nmi
> error for 2-1-0.

Ah yes.  It looks like I rushed that change (but that is why I broke it
out as a separate patch :-) ).

> 
> We should reimplement the logic above in nmi.c.
> 
> Also, struct pmu_nmi_state and friends can be removed here.

Ah yes.

Cheers,
Don
