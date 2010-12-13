Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0LMQmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:42:25 -0500
Received: from smtp-out.google.com ([74.125.121.35]:10140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0LMQmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:42:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dc+l+16Cs3jKgVXeIvlp+cYnG0Z+22NLXhCLicPNqnKaWAuLNFKuR9EOD4BRkaZ8V8
         TAew9PK5okqNvCNcuz3A==
MIME-Version: 1.0
In-Reply-To: <1292228848.10384.107.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	<1291922467.6803.44.camel@twins>
	<AANLkTinanAQYQvwtowTzJ0bpLRUvp-5sqF6M9PoMSJR-@mail.gmail.com>
	<1291978036.6803.95.camel@twins>
	<AANLkTin7Jd=4boSH8Ge79e5g-j7EwE-AL81+1kHyNSL3@mail.gmail.com>
	<1292228848.10384.107.camel@minggr.sh.intel.com>
Date: Mon, 13 Dec 2010 17:42:19 +0100
Message-ID: <AANLkTimkXFaB2+zB41-OhWDWu=htvm0UJAoLBJhRvEPg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 9:27 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Sat, 2010-12-11 at 13:49 +0800, Stephane Eranian wrote:
>> Hi,
>>
>> Ok, so I have an explanation for what we are seeing. In fact, what
>> bothered me in all
>> of this is that I did not recall ever running into this problem of
>> double-interrupt with HT
>> when I implemented the perfmon support for uncore sampling. The reason
>> is in fact
>> real simple.
>>
>> You are getting interrupts on both threads because you have enabled uncore PMU
>> on all CPUs, in uncore_cpu_starting():
>> +       rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
>> +       wrmsrl(MSR_IA32_DEBUGCTLMSR, val | DEBUGCTLMSR_ENABLE_UNCORE_PMI);
>
> Yeah! Thanks for the catch.
>
If think there you want something like:

if (cpu == cpumask_first(topology_core_siblings(cpu)) {
      rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
     wrmsrl(MSR_IA32_DEBUGCTLMSR, val | DEBUGCTLMSR_ENABLE_UNCORE_PMI);
}
I have verified that with something like that in place, you get only
one interrupt.
But it seems there may be some initialization of counters missing somewhere
because running perf stat, I got bogus counts back with the uncore
fixed counter.

>>
>> You need to do that only on ONE of the two siblings. In fact, you want
>> that only ONCE
>> per socket. You can do this on the first CPU to  use the uncore to add
>> something a bit
>> more dynamic and to make sure you have some control over where the
>> overhead is applied.
>> Once you do that, only one CPU/socket will get the interrupt and all
>> will be fine.
>
> I'll update the patches.
>
> Thanks,
> Lin Ming
>
>>
>>
>>
>> On Fri, Dec 10, 2010 at 11:47 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Fri, 2010-12-10 at 00:46 +0100, Stephane Eranian wrote:
>> >> Hi,
>> >>
>> >> So I have tested this patch a bit on WSM and as I expected there
>> >> are issues with sampling.
>> >>
>> >> When HT is on, both siblings CPUs get the interrupt. The HW does not
>> >> allow you to only point interrupts to a single HT thread (CPU).
>> >
>> > Egads, how ugly :/
>> >
>> >> I did verify that indeed both threads get the interrupt and that you have a
>> >> race condition. Both sibling CPUs stop uncore, get the status. They may get
>> >> the same overflow status. Both will pass the uncore->active_mask because
>> >> it's shared among siblings cores. Thus,  you have a race for the whole
>> >> interrupt handler execution.
>> >>
>> >> You need some serialization in there. But the patch does not address this.
>> >> The problem is different from the back-to-back interrupt issue that
>> >> Don worked on.
>> >> The per-cpu marked/handled trick cannot work to avoid this problem.
>> >>
>> >> You cannot simply say "the lowest indexed" CPU of a sibling pair
>> >> handles the interrupt
>> >> because you don't know if this in an uncore intr, core interrupt or
>> >> something else. You
>> >> need to check. That means each HT thread needs to check uncore
>> >> ovfl_status. IF the
>> >> status is zero, then return. Otherwise, you need to do a 2nd level
>> >> check before you can
>> >> execute the handler. You need to know if the sibling CPU has already
>> >> "consumed" that
>> >> interrupt.
>> >>
>> >> I think you need some sort of generation counter per physical core and
>> >> per HT thread.
>> >> On interrupt, you could do something along the line of:
>> >>       if (mycpu->intr_count == mysibling->intr_count) {
>> >>           then mycpu->intr_count++
>> >>           execute intr_handler()
>> >>       } else {
>> >>           mycpu->intr_count++
>> >>           return;
>> >>       }
>> >> Of course, the above needs some atomicity and ad locking
>> >
>> > Does that guarantee that the same sibling handles all interrupts? Since
>> > a lot of the infrastructure uses local*_t we're not good with cross-cpu
>> > stuff.
>> >
>> > Damn what a mess.. we need to serialize enough for both cpus to at least
>> > see the overflow bit.. maybe something like:
>> >
>> >
>> > struct intel_percore {
>> >   ...
>> >   atomic_t uncore_barrier;
>> > };
>> >
>> > void uncore_barrier(void)
>> > {
>> >        struct intel_percore *percore = this_cpu_ptr(cpu_hw_events)->percore;
>> >        int armed;
>> >
>> >        armed = atomic_cmpxchg(&percore->uncore_barrier, 0, 1) == 0;
>> >        if (armed) {
>> >                /* we armed, it, now wait for completion */
>> >                while (atomic_read(&percore->uncore_barrier))
>> >                        cpu_relax();
>> >        } else {
>> >                /* our sibling must have, decrement it */
>> >                if (atomic_cmpxchg(&percore->uncore_barrier, 1, 0) != 1)
>> >                        BUG();
>> >        }
>> > }
>> >
>> > Then have something like:
>> >
>> > handle_uncore_interrupt()
>> > {
>> >        u64 overflow = rdmsrl(MSR_UNCORE_PERF_GLOBAL_OVF_STATUS);
>> >        int cpu;
>> >
>> >        if (!overflow)
>> >                return 0; /* not our interrupt to handle */
>> >
>> >        uncore_barrier(); /* wait so our sibling will also observe the overflow */
>> >
>> >        cpu = smp_processor_id();
>> >        if (cpu != cpumask_first(topology_thread_cpumask(cpu)))
>> >                return 1; /* our sibling will handle it, eat the NMI */
>> >
>> >        /* OK, we've got an overflow and we're the first CPU in the thread mask */
>> >
>> >        ... do fancy stuff ...
>> >
>> >        return 1; /* we handled it, eat the NMI */
>> > }
>> >
>> >
>> >> (but I don't think you can use locks in NMI context).
>> >
>> > You can, as long as they're never used from !NMI, its icky, but it
>> > works.
>> >
>> >> This makes me wonder if vectoring uncore to NMI is really needed,
>> >> given you cannot
>> >> correlated to an IP, incl. a kernel IP. If we were to vector to a
>> >> dedicated (lower prio)
>> >> vector, then we could use the trick of saying the lowest indexed CPU in a pair
>> >> handles the interrupt (because we would already know this is an uncore
>> >> interrupt).
>> >> This would be much simpler. Price: not samples in kernel's critical
>> >> section. But those
>> >> are useless anyway with uncore events.
>> >
>> > But the uncore uses the same PMI line, right? You cannot point the
>> > uncore to another vector. /me goes find the docs -- ok, its too early in
>> > the morning to clearly parse that...
>> >
>> > Besides, people asked for the sampling thing didn't they (also we need
>> > it to fold the count to avoid overflow on 48bit). Also the PAPI people
>> > even want per-task uncore counters because that's the only thing PAPI
>> > can do.
>> >
>
>
>
