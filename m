Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1DVPDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:03:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:56077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1DVPDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:03:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,253,1301900400"; 
   d="scan'208";a="737063961"
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore
 support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
In-Reply-To: <BANLkTinxzH-3uXXfj4ALzkM48FnQ+shdvg@mail.gmail.com>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	 <1303478798.2461.11.camel@localhost>
	 <BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
	 <1303482702.2461.40.camel@localhost>
	 <BANLkTinxzH-3uXXfj4ALzkM48FnQ+shdvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 23:03:17 +0800
Message-Id: <1303484597.2461.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 22:41 +0800, Stephane Eranian wrote:
> On Fri, Apr 22, 2011 at 4:31 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > On Fri, 2011-04-22 at 21:46 +0800, Stephane Eranian wrote:
> >> On Fri, Apr 22, 2011 at 3:26 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> >> > On Fri, 2011-04-22 at 20:59 +0800, Stephane Eranian wrote:
> >> >> Lin,
> >> >>
> >> >> In arch/x86/include/asm/smp.h, you added:
> >> >>
> >> >> static inline bool cpu_has_ht_siblings(void)
> >> >> {
> >> >>        bool has_siblings = false;
> >> >> #ifdef CONFIG_SMP
> >> >>        has_siblings = cpu_has_ht && smp_num_siblings > 1;
> >> >> #endif
> >> >>        return has_siblings;
> >> >> }
> >> >>
> >> >> I am wondering about the goal of this function.
> >> >>
> >> >> Is it supposed to return whether or not HT is enabled?
> >> >>
> >> >> Ht enabled != HT supported
> >> >
> >> > It's used to check if HT is supported.
> >> >
> >> Ok, that makes more sense.
> >>
> >> > But unfortunately, we didn't find a way to check if HT is enabled.
> >> > So I just check if HT is supported.
> >> >
> >> >>
> >> >> +static inline int is_ht_enabled(void)
> >> >> +{
> >> >> +       bool has_ht = false;
> >> >> +#ifdef CONFIG_SMP
> >> >> +       int w;
> >> >> +       w = cpumask_weight(cpu_sibling_mask(smp_processor_id()));
> >> >> +       has_ht = cpu_has_ht && w > 1;
> >> >> +#endif
> >> >> +       return has_ht;
> >> >> +}
> >> >>
> >> >> OTOH, you need some validation even in the case HT is off. No two events
> >> >> scheduled together on the same PMU can have different values for the extra
> >
> > I got it now.
> >
> >> >> reg. Thus, the fact that cpu_has_ht_siblings() is imune to HT state helps here,
> >> >> but then what's the point of it?
> >> >
> >> > The points is to avoid the percore resource allocations(which are used
> >> > to sync between HTs) if HT is not supported.
> >> >
> >> But if you check x86_pmu.extra_regs, that should do it as well.
> >
> > I don't understand here.
> > Did you mean we can avoid the percore resource allocations by just
> > checking x86_pmu.extra_regs? How?
> 
> Is you have not extra_regs, i.e., regs that are shared, then why would
> you need the percore allocation?

But "extra_regs" does not imply they are regs that are shared.
It only means some events need to set extra registers to work.

> 
> 
> >
> >>
> >> Suppose HT is disabled and I do:
> >>
> >> perf stat -e offcore_response_0:dmd_data_rd,offcore_response_0:dmnd_rfo ......
> >>
> >> This should still not be allowed.
> >
> > Ah, you are right.
> > We have to always check extra_config even HT is disabled and/or
> > supported.
> >
> Yes. You won't need the locking, though.
> 
> >>
> >> I think in this case, HT supported will cause your code to still allocate the
> >> per-core struct. There will be no matching of per-core structs in starting().
> >> So I suspect things work.
> >
> > This has no problem.
> > If "no matching" found, then below if(...) statement won't be executed.
> >
> > intel_pmu_cpu_starting:
> >
> >        for_each_cpu(i, topology_thread_cpumask(cpu)) {
> >                struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
> >
> >                if (pc && pc->core_id == core_id) {
> >                        kfree(cpuc->per_core);
> >                        cpuc->per_core = pc;
> >                        break;
> >                }
> >        }
> >
> > Or do you see other potential problem?
> >
> I think when HT is off, you will never execute the if statement, because
> no core_id will ever match another.

The "if" statement is not executed so the per-core structs allocated in
intel_pmu_cpu_prepare is not freed.

This is the intended behavior since we don't have a way to check if HT
is off.

> 
> Another thing that struck me when locking at the hotplug code for
> per-core is the lack of locking. I assume that's because hotplug
> cpu is inherently serialized. You cannot have a CPU going offline
> and one going online at the same time. is that right? Otherwise
> I wonder if you could simply do per_core->refcnt++ vs.
> per_core->refcnt--


