Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1CAIVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:21:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:14823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1CAIVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:21:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,246,1297065600"; 
   d="scan'208";a="607622865"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=eUnZqT3MF7Y8ONrnGh-7MoZJsefisWFR10p7d@mail.gmail.com>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>
	 <AANLkTi=eUnZqT3MF7Y8ONrnGh-7MoZJsefisWFR10p7d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 16:21:45 +0800
Message-ID: <1298967705.4937.91.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 15:43 +0800, Stephane Eranian wrote:
> On Mon, Feb 28, 2011 at 10:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Mon, 2011-02-28 at 15:22 +0800, Lin Ming wrote:
> >> This patch adds basic SandyBridge support, including hardware cache
> >> events and PEBS events support.
> >>
> >> LLC-* hareware cache events don't work for now, it depends on the
> >> offcore patches.
> >
> > What's the status of those, Stephane reported some problems last I
> > remember?
> >
> I tried the trick I mentioned and it seems to work.

Let me make sure I understand the problem correctly.

perf top -C 0 -e LLC-loads -e LLC-store-misses 

LLC-loads and LLC-store-misses events use different extra_config.

1. LLC-loads submitted successfully, era->ref=1
2. LLC-loads event is resubmitted because incremental scheduling,
era->ref=2.
3. LLC-store-misses is submitted, but fail because conflict.

Step 2 is wrong, the reference count should not be incremented with the
same event.

Is my understanding right?

Lin Ming

> 
> Something like below with hwc->extra_alloc.
> Could probably find a better name for that field.
> 
> static struct event_constraint *
> intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> {
>         struct hw_perf_event *hwc = &event->hw;
>         unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
>         struct event_constraint *c;
>         struct intel_percore *pc;
>         struct er_account *era;
>         int i;
>         int free_slot;
>         int found;
> 
>         if (!x86_pmu.percore_constraints)
>                 return NULL;
> 
>         if (hwc->extra_alloc)
>                 return NULL;
> 
>         for (c = x86_pmu.percore_constraints; c->cmask; c++) {
>                 if (e != c->code)
>                         continue;
> 
>                 /*
>                  * Allocate resource per core.
>                  */
>                 c = NULL;
>                 pc = cpuc->per_core;
>                 if (!pc)
>                         break;
>                 c = &emptyconstraint;
>                 raw_spin_lock(&pc->lock);
>                 free_slot = -1;
>                 found = 0;
>                 for (i = 0; i < MAX_EXTRA_REGS; i++) {
>                         era = &pc->regs[i];
>                         if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
>                                 /* Allow sharing same config */
>                                 if (hwc->extra_config == era->extra_config) {
>                                         era->ref++;
>                                         cpuc->percore_used = 1;
>                                         hwc->extra_alloc = 1;
>                                         c = NULL;
>                                 }
>                                 /* else conflict */
>                                 found = 1;
>                                 break;
>                         } else if (era->ref == 0 && free_slot == -1)
>                                 free_slot = i;
>                 }
>                 if (!found && free_slot != -1) {
>                         era = &pc->regs[free_slot];
>                         era->ref = 1;
>                         era->extra_reg = hwc->extra_reg;
>                         era->extra_config = hwc->extra_config;
>                         cpuc->percore_used = 1;
>                         hwc->extra_alloc = 1;
>                         c = NULL;
>                 }
>                 raw_spin_unlock(&pc->lock);
>                 return c;
>         }
> 
>         return NULL;
> }
> 
> static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
>                                         struct perf_event *event)
> {
>         struct extra_reg *er;
>         struct intel_percore *pc;
>         struct er_account *era;
>         struct hw_perf_event *hwc = &event->hw;
>         int i, allref;
> 
>         if (!cpuc->percore_used)
>                 return;
> 
>         for (er = x86_pmu.extra_regs; er->msr; er++) {
>                 if (er->event != (hwc->config & er->config_mask))
>                         continue;
> 
>                 pc = cpuc->per_core;
>                 raw_spin_lock(&pc->lock);
>                 for (i = 0; i < MAX_EXTRA_REGS; i++) {
>                         era = &pc->regs[i];
>                         if (era->ref > 0 &&
>                             era->extra_config == hwc->extra_config &&
>                             era->extra_reg == er->msr) {
>                                 era->ref--;
>                                 hwc->extra_alloc = 0;
>                                 break;
>                         }
>                 }
>                 allref = 0;
>                 for (i = 0; i < MAX_EXTRA_REGS; i++)
>                         allref += pc->regs[i].ref;
>                 if (allref == 0)
>                         cpuc->percore_used = 0;
>                 raw_spin_unlock(&pc->lock);
>                 break;
>         }
> }
> 
> >
> >>  #define INTEL_EVENT_CONSTRAINT(c, n) \
> >>       EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
> >> +#define INTEL_EVENT_CONSTRAINT2(c, n)        \
> >> +     EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
> >
> > That's a particularly bad name, how about something like
> >
> > INTEL_UEVENT_CONSTRAINT or somesuch.
> >
> >> @@ -702,7 +738,13 @@ static void intel_ds_init(void)
> >>                       printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
> >>                       x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
> >>                       x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
> >> -                     x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> >> +                     switch (boot_cpu_data.x86_model) {
> >> +                     case 42: /* SandyBridge */
> >> +                             x86_pmu.pebs_constraints = intel_snb_pebs_events;
> >> +                             break;
> >> +                     default:
> >> +                             x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> >> +                     }
> >>                       break;
> >>
> >>               default:
> >
> > We already have this massive model switch right after this function,
> > might as well move the pebs constraint assignment there.
> >


