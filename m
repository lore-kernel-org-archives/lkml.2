Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1DTT0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:26:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2344 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1DTT0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wS8SrI1CbmVVt7rRiVkM1Qm3fUU+PUsI3ZKewMEz8Lng7raIhqUwHXv9xGaDa/W0C9
         6WPgY5HrFTGFeHq7vpfw==
MIME-Version: 1.0
In-Reply-To: <20110420182613.GA31724@redhat.com>
References: <20110420182613.GA31724@redhat.com>
Date: Wed, 20 Apr 2011 21:26:39 +0200
Message-ID: <BANLkTi=jzYOr_i=9nTkp96TYnAimROMYSg@mail.gmail.com>
Subject: Re: [RFC] x86, perf: high volume of events produces a flood of
 unknown NMIs
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        robert.richter@amd.com, andi@firstfloor.org, gorcunov@openvz.org,
        ming.m.lin@intel.com, ying.huang@intel.com,
        mathieu.desnoyers@efficios.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don,

May I suggest that the interrupt handler for Intel double checks
the counters directly to verify that their state actually reflects
the bitmask in GLOBAL_OVF_STATUS. I believe on some
CPUs they may disagree sometimes.



On Wed, Apr 20, 2011 at 8:26 PM, Don Zickus <dzickus@redhat.com> wrote:
> Hi,
>
> Arnaldo pointed me at an NMI problem that happens when he tries to
> generate a high volume of perf events.  He receives a flood of unknown
> NMIs.
>
> I have been poking at the problem and came up with a patch, but it doesn't
> always work.  I was hoping people who understood how the NMI works at a
> low level might be able to help me.
>
> I was able to duplicate this on an AMD Phenom, Pentium 4, Xeon Core2quad,
> and Nehalem.  The problem I think is the large generation of back-to-back
> NMIs.  The perf nmi handler may accidentally handle some of those
> extra/in-flight NMIs in its first pass, leaving the next NMI to be
> unhandled and generating an unknown NMI message.
>
> Robert included logic to check for two back-to-back NMIs, but that falls
> short when more then three are generated.  I modified his logic to account
> for three back-to-back NMIs, but that didn't completely solve the problem.
>
> I took another approach at catching back-to-back NMIs that seemed to work
> on all my machines except for the Xeon core2quad, but I am not entirely
> sure if my approach is valid.
>
> The approach I took was based on the idea that if an NMI is being
> generated while currently in an NMI handler, the current NMI when finished
> won't continue executing the next instruction before the exception but
> instead jump back into another NMI exception frame.
>
> As a result, the args passed in to the NMI handler should have the same ip
> and sp as the previous NMI interrupt.  Otherwise one could assume that
> some amount of time passed between interrupts (enough to return from the
> exception and execute code).
>
> I thought this would allow me to trap an infinite number of back-to-back
> NMIs.  Like I said it seemed to work in a number of machines, except for
> my Xeon core2quad.
>
> Does anyone know if my approach is a valid one?  Or is there a better way
> to catch this condition?  Or maybe some other tips or tricks I can use to
> help come up with a solution for this?
>
> Or perhaps we don't care about this because in the end perf can't even
> capture the data without spitting out a CPU Overload message.
>
> Thoughts?
>
> Attached is the crude patch I was using for testing.  It also includes
> another patch the moves the apic LVTPC un-masking to fix the Pentium4
> machines.
>
> The commands I run to generate this problem is
>
> shell1> mount -t debugfs debugfs /sys/kernel/debug
> shell1> cd /sys/kernel/debug/tracing
> shell1> cat trace_pipe
>
> shell2> <grab kernel source>
> shell2> <cd to kernel source>
> shell2> make -j8
>
> shell3> perf record grep -r foo / &> /dev/null &
> shell3> perf record -F 100000 -g -e cycles -e instructions -e cache-misses
> --pid <pidof make>
>
> takes about a minute or two to duplicate
>
> Cheers,
> Don
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index eed3673a..20aa734 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -104,7 +104,6 @@ struct cpu_hw_events {
>         */
>        struct perf_event       *events[X86_PMC_IDX_MAX]; /* in counter order */
>        unsigned long           active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> -       unsigned long           running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>        int                     enabled;
>
>        int                     n_events;
> @@ -1160,7 +1159,6 @@ static void x86_pmu_start(struct perf_event *event, int flags)
>
>        cpuc->events[idx] = event;
>        __set_bit(idx, cpuc->active_mask);
> -       __set_bit(idx, cpuc->running);
>        x86_pmu.enable(event);
>        perf_event_update_userpage(event);
>  }
> @@ -1284,15 +1282,11 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>
>        cpuc = &__get_cpu_var(cpu_hw_events);
>
> +       /* chipsets have their own quirks when to unmask */
> +       apic_write(APIC_LVTPC, APIC_DM_NMI);
> +
>        for (idx = 0; idx < x86_pmu.num_counters; idx++) {
>                if (!test_bit(idx, cpuc->active_mask)) {
> -                       /*
> -                        * Though we deactivated the counter some cpus
> -                        * might still deliver spurious interrupts still
> -                        * in flight. Catch them:
> -                        */
> -                       if (__test_and_clear_bit(idx, cpuc->running))
> -                               handled++;
>                        continue;
>                }
>
> @@ -1333,8 +1327,8 @@ void perf_events_lapic_init(void)
>  }
>
>  struct pmu_nmi_state {
> -       unsigned int    marked;
> -       int             handled;
> +       unsigned long   ip;
> +       unsigned long   sp;
>  };
>
>  static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
> @@ -1344,8 +1338,9 @@ perf_event_nmi_handler(struct notifier_block *self,
>                         unsigned long cmd, void *__args)
>  {
>        struct die_args *args = __args;
> -       unsigned int this_nmi;
>        int handled;
> +       unsigned long ip = __this_cpu_read(pmu_nmi.ip);
> +       unsigned long sp = __this_cpu_read(pmu_nmi.sp);
>
>        if (!atomic_read(&active_events))
>                return NOTIFY_DONE;
> @@ -1353,46 +1348,20 @@ perf_event_nmi_handler(struct notifier_block *self,
>        switch (cmd) {
>        case DIE_NMI:
>                break;
> -       case DIE_NMIUNKNOWN:
> -               this_nmi = percpu_read(irq_stat.__nmi_count);
> -               if (this_nmi != __this_cpu_read(pmu_nmi.marked))
> -                       /* let the kernel handle the unknown nmi */
> -                       return NOTIFY_DONE;
> -               /*
> -                * This one is a PMU back-to-back nmi. Two events
> -                * trigger 'simultaneously' raising two back-to-back
> -                * NMIs. If the first NMI handles both, the latter
> -                * will be empty and daze the CPU. So, we drop it to
> -                * avoid false-positive 'unknown nmi' messages.
> -                */
> -               return NOTIFY_STOP;
>        default:
>                return NOTIFY_DONE;
>        }
>
> -       apic_write(APIC_LVTPC, APIC_DM_NMI);
> -
> +       __this_cpu_write(pmu_nmi.ip, args->regs->ip);
> +       __this_cpu_write(pmu_nmi.sp, args->regs->sp);
>        handled = x86_pmu.handle_irq(args->regs);
> -       if (!handled)
> +       if (!handled) {
> +               if ((args->regs->ip == ip) && (args->regs->sp == sp)) {
> +                       trace_printk("MATCH: ip - 0x%08lx, sp - 0x%08lx\n", ip, sp);
> +                       return NOTIFY_STOP;
> +               }else
> +                       trace_printk("nomatch: ip - 0x%08lx (0x%08lx), sp - 0x%08lx (0x%08lx)\n", ip, args->regs->ip, sp, args->regs->sp);
>                return NOTIFY_DONE;
> -
> -       this_nmi = percpu_read(irq_stat.__nmi_count);
> -       if ((handled > 1) ||
> -               /* the next nmi could be a back-to-back nmi */
> -           ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
> -            (__this_cpu_read(pmu_nmi.handled) > 1))) {
> -               /*
> -                * We could have two subsequent back-to-back nmis: The
> -                * first handles more than one counter, the 2nd
> -                * handles only one counter and the 3rd handles no
> -                * counter.
> -                *
> -                * This is the 2nd nmi because the previous was
> -                * handling more than one counter. We will mark the
> -                * next (3rd) and then drop it if unhandled.
> -                */
> -               __this_cpu_write(pmu_nmi.marked, this_nmi + 1);
> -               __this_cpu_write(pmu_nmi.handled, handled);
>        }
>
>        return NOTIFY_STOP;
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 8fc2b2c..99b5151 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -937,6 +937,9 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>        handled = intel_pmu_drain_bts_buffer();
>        status = intel_pmu_get_status();
>        if (!status) {
> +               /* chipsets have their own quirks when to unmask */
> +               apic_write(APIC_LVTPC, APIC_DM_NMI);
> +
>                intel_pmu_enable_all(0);
>                return handled;
>        }
> @@ -988,6 +991,9 @@ again:
>                goto again;
>
>  done:
> +       /* chipsets have their own quirks when to unmask */
> +       apic_write(APIC_LVTPC, APIC_DM_NMI);
> +
>        intel_pmu_enable_all(0);
>        return handled;
>  }
> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
> index c2520e1..612bc0e 100644
> --- a/arch/x86/kernel/cpu/perf_event_p4.c
> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -921,9 +921,6 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
>                int overflow;
>
>                if (!test_bit(idx, cpuc->active_mask)) {
> -                       /* catch in-flight IRQs */
> -                       if (__test_and_clear_bit(idx, cpuc->running))
> -                               handled++;
>                        continue;
>                }
>
> @@ -950,11 +947,17 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
>                        p4_pmu_disable_event(event);
>        }
>
> -       if (handled) {
> -               /* p4 quirk: unmask it again */
> -               apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> +       if (handled)
>                inc_irq_stat(apic_perf_irqs);
> -       }
> +
> +        /*
> +        * P4 quirks:
> +        * - An overflown perfctr will assert its interrupt
> +        *   until the OVF flag in its CCCR is cleared.
> +        * - LVTPC is masked on interrupt and must be
> +        *   unmasked by the LVTPC handler.
> +        */
> +       apic_write(APIC_LVTPC, APIC_DM_NMI);
>
>        return handled;
>  }
>
>
>
