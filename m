Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2DADL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:11:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:50478 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2DADLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:11:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83943821"
Message-ID: <4F77C75B.4060105@intel.com>
Date: Sun, 01 Apr 2012 11:11:23 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>  <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com> <1333163902.2960.63.camel@laptop>
In-Reply-To: <1333163902.2960.63.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 11:18 AM, Peter Zijlstra wrote:
> On Wed, 2012-03-28 at 14:43 +0800, Yan, Zheng wrote:
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> new file mode 100644
>> index 0000000..d159e3e
>> --- /dev/null
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -0,0 +1,814 @@
>> +#include "perf_event_intel_uncore.h"
>> +
>> +static struct intel_uncore_type *empty_uncore[] = { NULL, };
>> +static struct intel_uncore_type **msr_uncores = empty_uncore;
>> +
>> +/* constraint for box with 2 counters */
>> +static struct event_constraint unconstrained_2 =
>> +       EVENT_CONSTRAINT(0, 0x3, 0);
>> +/* constraint for box with 3 counters */
>> +static struct event_constraint unconstrained_3 =
>> +       EVENT_CONSTRAINT(0, 0x7, 0);
>> +/* constraint for box with 4 counters */
>> +static struct event_constraint unconstrained_4 =
>> +       EVENT_CONSTRAINT(0, 0xf, 0);
>> +/* constraint for box with 8 counters */
>> +static struct event_constraint unconstrained_8 =
>> +       EVENT_CONSTRAINT(0, 0xff, 0);
>> +/* constraint for the fixed countesr */
>> +static struct event_constraint constraint_fixed =
>> +       EVENT_CONSTRAINT((u64)-1, 1 << UNCORE_PMC_IDX_FIXED, (u64)-1);
> 
> Since they're all different, why not have an struct event_constraint
> unconstrained member in your struct intel_uncore_pmu and fill it out
> whenever you create that.
> 
>> +static DEFINE_SPINLOCK(uncore_box_lock);
> 
>> +/*
>> + * The overflow interrupt is unavailable for SandyBridge-EP, is broken
>> + * for SandyBridge. So we use hrtimer to periodically poll the counter
>> + */
> 
> To avoid overlow and accumulate into the software u64, right? Not to
> actually sample anything.
Yes

> 
> Might also want to say is broken for anything else, since afaik uncore
> PMI has been broken for everything with an uncore.
> 
> 
>> +static struct intel_uncore_box *
>> +__uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
>> +{
>> +       struct intel_uncore_box *box;
>> +       struct hlist_head *head;
>> +       struct hlist_node *node;
>> +
>> +       head = &pmu->box_hash[phyid % UNCORE_BOX_HASH_SIZE];
>> +
>> +       hlist_for_each_entry_rcu(box, node, head, hlist) {
>> +               if (box->phy_id == phyid)
>> +                       return box;
>> +       }
>> +
>> +       return NULL;
>> +}
>> +
>> +static struct intel_uncore_box *
>> +uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
>> +{
>> +       struct intel_uncore_box *box;
>> +
>> +       rcu_read_lock();
>> +       box = __uncore_pmu_find_box(pmu, phyid);
>> +       rcu_read_unlock();
>> +
>> +       return box;
>> +}
>> +
>> +/* caller should hold the uncore_box_lock */
>> +static void uncore_pmu_add_box(struct intel_uncore_pmu *pmu,
>> +                               struct intel_uncore_box *box)
>> +{
>> +       struct hlist_head *head;
>> +
>> +       head = &pmu->box_hash[box->phy_id % UNCORE_BOX_HASH_SIZE];
>> +       hlist_add_head_rcu(&box->hlist, head);
>> +}
>> +
>> +static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
>> +{
>> +       return container_of(event->pmu, struct intel_uncore_pmu, pmu);
>> +}
>> +
>> +static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
>> +{
>> +       int phyid = topology_physical_package_id(smp_processor_id());
> 
> Who says that this event has anything to do with the current cpu?
> 
Because perf core schedules event on the basis of cpu. 

>> +       return uncore_pmu_find_box(uncore_event_to_pmu(event), phyid);
>> +}
> 
> So why not simply use a per-cpu allocation and have something like:
> 
> struct intel_uncore_pmu {
> 	...
> 	struct intel_uncore_box * __percpu box;
> };
> 
> static inline
> struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
> {
> 	return per_cpu_ptr(event->pmu->box, event->cpu);
> }
> 
> And be done with it?

Because using per-cpu allocation is inconvenience for PCI uncore device.

> 
>> +static int uncore_collect_events(struct intel_uncore_box *box,
>> +                         struct perf_event *leader, bool dogrp)
>> +{
>> +       struct perf_event *event;
>> +       int n, max_count;
>> +
>> +       max_count = box->pmu->type->num_counters;
>> +       if (box->pmu->type->fixed_ctl)
>> +               max_count++;
>> +
>> +       if (box->n_events >= max_count)
>> +               return -EINVAL;
>> +
>> +       /*
>> +        * adding the same events twice to the uncore PMU may cause
>> +        * general protection fault
>> +        */
> 
> Is that an errata or a 'feature' of some specific box types, or what?
> 
>> +       for (n = 0; n < box->n_events; n++) {
>> +               event = box->event_list[n];
>> +               if (event->hw.config == leader->hw.config)
>> +                       return -EINVAL;
>> +       }
>> +
>> +       n = box->n_events;
>> +       box->event_list[n] = leader;
>> +       n++;
>> +       if (!dogrp)
>> +               return n;
>> +
>> +       list_for_each_entry(event, &leader->sibling_list, group_entry) {
>> +               if (event->state <= PERF_EVENT_STATE_OFF)
>> +                       continue;
>> +
>> +               if (n >= max_count)
>> +                       return -EINVAL;
>> +
>> +               box->event_list[n] = event;
>> +               n++;
>> +       }
>> +       return n;
>> +}
>> +
>> +static struct event_constraint *
>> +uncore_event_constraint(struct intel_uncore_type *type,
>> +                       struct perf_event *event)
>> +{
>> +       struct event_constraint *c;
>> +
>> +       if (event->hw.config == (u64)-1)
>> +               return &constraint_fixed;
>> +
>> +       if (type->constraints) {
>> +               for_each_event_constraint(c, type->constraints) {
>> +                       if ((event->hw.config & c->cmask) == c->code)
>> +                               return c;
>> +               }
>> +       }
>> +
>> +       if (type->num_counters == 2)
>> +               return &unconstrained_2;
>> +       if (type->num_counters == 3)
>> +               return &unconstrained_3;
>> +       if (type->num_counters == 4)
>> +               return &unconstrained_4;
>> +       if (type->num_counters == 8)
>> +               return &unconstrained_8;
>> +
>> +       WARN_ON_ONCE(1);
>> +       return &unconstrained_2;
> 
> 	return event->pmu->unconstrained;
> 
> seems much saner to me..

will change the code
> 
>> +}
>> +
>> +static int uncore_assign_events(struct intel_uncore_box *box,
>> +                               int assign[], int n)
>> +{
>> +       struct event_constraint *c, *constraints[UNCORE_PMC_IDX_MAX];
>> +       int i, ret, wmin, wmax;
>> +
>> +       for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
>> +               c = uncore_event_constraint(box->pmu->type,
>> +                                       box->event_list[i]);
>> +               constraints[i] = c;
>> +               wmin = min(wmin, c->weight);
>> +               wmax = max(wmax, c->weight);
>> +       }
> 
> No fast path then?

will add the fast path
> 
>> +       ret = perf_assign_events(constraints, n, wmin, wmax, assign);
>> +       return ret ? -EINVAL : 0;
>> +}
> 
> 
>> +static void uncore_pmu_event_start(struct perf_event *event, int flags)
>> +{
>> +       struct intel_uncore_box *box = uncore_event_to_box(event);
>> +
>> +       raw_spin_lock(&box->lock);
>> +       __uncore_pmu_event_start(box, event, flags);
>> +       raw_spin_unlock(&box->lock);
>> +}
> 
>> +static void uncore_pmu_event_stop(struct perf_event *event, int flags)
>> +{
>> +       struct intel_uncore_box *box = uncore_event_to_box(event);
>> +
>> +       raw_spin_lock(&box->lock);
>> +       __uncore_pmu_event_stop(box, event, flags);
>> +       raw_spin_unlock(&box->lock);
>> +}
> 
>> +static int uncore_pmu_event_add(struct perf_event *event, int flags)
>> +{
>> +       struct intel_uncore_box *box = uncore_event_to_box(event);
>> +       struct hw_perf_event *hwc = &event->hw;
>> +       int assign[UNCORE_PMC_IDX_MAX];
>> +       int i, n, ret;
>> +
>> +       if (!box)
>> +               return -ENODEV;
>> +
>> +       raw_spin_lock(&box->lock);
> 
>> +       raw_spin_unlock(&box->lock);
>> +       return ret;
>> +}
>> +
>> +static void uncore_pmu_event_del(struct perf_event *event, int flags)
>> +{
>> +       struct intel_uncore_box *box = uncore_event_to_box(event);
>> +       int i;
>> +
>> +       raw_spin_lock(&box->lock);
> 
>> +       raw_spin_unlock(&box->lock);
>> +}
> 
> So what's up with all this box->lock business.. why does that lock
> exist?

If user doesn't provide the "-C x" option to the perf tool, multiple cpus
will try adding/deleting events at the same time.

> 
>> +static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
>> +{
>> +       int ret;
>> +
>> +       pmu->pmu.attr_groups    = pmu->type->attr_groups;
>> +       pmu->pmu.task_ctx_nr    = perf_invalid_context;
>> +       pmu->pmu.event_init     = uncore_pmu_event_init;
>> +       pmu->pmu.add            = uncore_pmu_event_add;
>> +       pmu->pmu.del            = uncore_pmu_event_del;
>> +       pmu->pmu.start          = uncore_pmu_event_start;
>> +       pmu->pmu.stop           = uncore_pmu_event_stop;
>> +       pmu->pmu.read           = uncore_pmu_event_read;
> 
> Won't this look better as a C99 struct init? Something like:
> 
> 	pmu->pmu = (struct pmu){
> 		.attr_groups	= pmu->type->attr_groups,
> 		.task_ctx_nr	= perf_invalid_context,
> 		.event_init	= uncore_pmu_event_init,
> 		...
> 	};
> 
>> +       if (pmu->type->num_boxes == 1)
>> +               sprintf(pmu->name, "uncore_%s", pmu->type->name);
>> +       else
>> +               sprintf(pmu->name, "uncore_%s%d", pmu->type->name,
>> +                       pmu->pmu_idx);
>> +
>> +       ret = perf_pmu_register(&pmu->pmu, pmu->name, -1);
>> +       return ret;
>> +}
> 
> 
>> +static int __init uncore_type_init(struct intel_uncore_type *type)
>> +{
>> +       struct intel_uncore_pmu *pmus;
>> +       struct attribute_group *events_group;
>> +       struct attribute **attrs;
>> +       int i, j;
>> +
>> +       pmus = kzalloc(sizeof(*pmus) * type->num_boxes, GFP_KERNEL);
>> +       if (!pmus)
>> +               return -ENOMEM;
> 
> Hmm, but if you have a pmu per number of boxes, then what do you need
> that  pmu->box reference for?

Type->num_boxes is number of boxes within one physical cpu. pmu->box_hash
is needed because there can be several physical cpus in a system.  

> 
>> +
>> +       for (i = 0; i < type->num_boxes; i++) {
>> +               pmus[i].func_id = -1;
>> +               pmus[i].pmu_idx = i;
>> +               pmus[i].type = type;
>> +
>> +               for (j = 0; j < ARRAY_SIZE(pmus[0].box_hash); j++)
>> +                       INIT_HLIST_HEAD(&pmus[i].box_hash[j]);
>> +       }
>> +
>> +       if (type->event_descs) {
>> +               for (i = 0; ; i++) {
>> +                       if (!type->event_descs[i].attr.attr.name)
>> +                               break;
>> +               }
>> +
>> +               events_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
>> +                               sizeof(*events_group), GFP_KERNEL);
>> +               if (!events_group)
>> +                       goto fail;
>> +
>> +               attrs = (struct attribute **)(events_group + 1);
>> +               events_group->name = "events";
>> +               events_group->attrs = attrs;
>> +
>> +               for (j = 0; j < i; j++)
>> +                       attrs[j] = &type->event_descs[j].attr.attr;
>> +
>> +               type->attr_groups[1] = events_group;
>> +       }
>> +       type->pmus = pmus;
>> +       return 0;
>> +fail:
>> +       uncore_type_exit(type);
>> +       return -ENOMEM;
>> +}
>> +
> 
> 
> Aside from all this, there's still the problem that you don't place all
> events for a particular phys_id onto a single cpu. It doesn't matter
> which cpu in that package it is, but all events should go to the same.
> 
> This means that on unplug of that cpu, you have to migrate all these
> events etc..

Any hints how to do this. I'm afraid it requires big changes to perf core.

Thank you very much
Yan, Zheng

> 
> I suspect doing this will also allow you to get rid of that box->lock
> thing.


