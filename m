Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2DABmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 21:42:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:24290 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab2DABln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 21:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125662191"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: [PATCH 2/6] perf: Generic intel uncore support
Date: Sun,  1 Apr 2012 09:41:31 +0800
Message-Id: <1333244495-1020-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
References: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds the generic intel uncore pmu support. The code aims
to provide uncore pmu support for Sandy Bridge-EP, but it also works
for Nehalem and Sandy Bridge. The uncore subsystem in Sandy Bridge-EP
consists of a variety of components, each component contain one or
more boxes.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/Makefile                  |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  793 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  200 +++++++
 3 files changed, 994 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.h

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6ab6aa2..9dfa9e9 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o perf_event_intel_uncore.o
 endif
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
new file mode 100644
index 0000000..083f235
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -0,0 +1,793 @@
+#include "perf_event_intel_uncore.h"
+
+static struct intel_uncore_type *empty_uncore[] = { NULL, };
+static struct intel_uncore_type **msr_uncores = empty_uncore;
+
+/* constraint for box with 2 counters */
+static struct event_constraint unconstrained_2 =
+	EVENT_CONSTRAINT(0, 0x3, 0);
+/* constraint for box with 3 counters */
+static struct event_constraint unconstrained_3 =
+	EVENT_CONSTRAINT(0, 0x7, 0);
+/* constraint for box with 4 counters */
+static struct event_constraint unconstrained_4 =
+	EVENT_CONSTRAINT(0, 0xf, 0);
+/* constraint for box with 8 counters */
+static struct event_constraint unconstrained_8 =
+	EVENT_CONSTRAINT(0, 0xff, 0);
+/* constraint for the fixed countesr */
+static struct event_constraint constraint_fixed =
+	EVENT_CONSTRAINT((u64)-1, 1 << UNCORE_PMC_IDX_FIXED, (u64)-1);
+
+static DEFINE_SPINLOCK(uncore_box_lock);
+
+static void uncore_assign_hw_event(struct intel_uncore_box *box,
+				   struct perf_event *event, int idx)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	hwc->idx = idx;
+	hwc->last_tag = ++box->tags[idx];
+
+	if (hwc->idx == UNCORE_PMC_IDX_FIXED) {
+		hwc->event_base = uncore_msr_fixed_ctr(box);
+		hwc->config_base = uncore_msr_fixed_ctl(box);
+		return;
+	}
+
+	hwc->config_base = uncore_msr_event_ctl(box, hwc->idx);
+	hwc->event_base =  uncore_msr_perf_ctr(box, hwc->idx);
+}
+
+static void __uncore_perf_event_update(struct intel_uncore_box *box,
+				      struct perf_event *event)
+{
+	u64 prev_count, new_count, delta;
+	int shift;
+
+	if (event->hw.idx >= UNCORE_PMC_IDX_FIXED)
+		shift = 64 - uncore_fixed_ctr_bits(box);
+	else
+		shift = 64 - uncore_perf_ctr_bits(box);
+
+	new_count = uncore_read_counter(box, event);
+	prev_count = local64_xchg(&event->hw.prev_count, new_count);
+
+	delta = (new_count << shift) - (prev_count << shift);
+	delta >>= shift;
+
+	local64_add(delta, &event->count);
+}
+
+static void uncore_perf_event_update(struct intel_uncore_box *box,
+				      struct perf_event *event)
+{
+	raw_spin_lock(&box->lock);
+	__uncore_perf_event_update(box, event);
+	raw_spin_unlock(&box->lock);
+}
+
+/*
+ * The overflow interrupt is unavailable for SandyBridge-EP, is broken
+ * for SandyBridge. So we use hrtimer to periodically poll the counter
+ */
+static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
+{
+	struct intel_uncore_box *box;
+	enum hrtimer_restart ret = HRTIMER_RESTART;
+	int bit;
+
+	box = container_of(hrtimer, struct intel_uncore_box, hrtimer);
+	raw_spin_lock(&box->lock);
+
+	if (!box->n_active) {
+		ret = HRTIMER_NORESTART;
+		goto unlock;
+	}
+
+	uncore_disable_all(box);
+
+	for_each_set_bit(bit, box->active_mask, UNCORE_PMC_IDX_MAX)
+		__uncore_perf_event_update(box, box->events[bit]);
+
+	hrtimer_forward_now(hrtimer, ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL));
+
+	uncore_enable_all(box);
+unlock:
+	raw_spin_unlock(&box->lock);
+	return ret;
+}
+
+static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
+{
+	__hrtimer_start_range_ns(&box->hrtimer,
+				ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
+				HRTIMER_MODE_REL_PINNED, 0);
+}
+
+static void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box)
+{
+	hrtimer_cancel(&box->hrtimer);
+}
+
+static void uncore_pmu_init_hrtimer(struct intel_uncore_box *box)
+{
+	hrtimer_init(&box->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	box->hrtimer.function = uncore_pmu_hrtimer;
+}
+
+struct intel_uncore_box *alloc_uncore_box(int cpu)
+{
+	struct intel_uncore_box *box;
+
+	box = kmalloc_node(sizeof(*box), GFP_KERNEL | __GFP_ZERO,
+			cpu_to_node(cpu));
+	if (!box)
+		return NULL;
+
+	raw_spin_lock_init(&box->lock);
+	uncore_pmu_init_hrtimer(box);
+	box->refcnt = 1;
+
+	return box;
+}
+
+static struct intel_uncore_box *
+__uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
+{
+	struct intel_uncore_box *box;
+	struct hlist_head *head;
+	struct hlist_node *node;
+
+	head = &pmu->box_hash[phyid % UNCORE_BOX_HASH_SIZE];
+
+	hlist_for_each_entry_rcu(box, node, head, hlist) {
+		if (box->phy_id == phyid)
+			return box;
+	}
+
+	return NULL;
+}
+
+static struct intel_uncore_box *
+uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
+{
+	struct intel_uncore_box *box;
+
+	rcu_read_lock();
+	box = __uncore_pmu_find_box(pmu, phyid);
+	rcu_read_unlock();
+
+	return box;
+}
+
+/* caller should hold the uncore_box_lock */
+static void uncore_pmu_add_box(struct intel_uncore_pmu *pmu,
+				struct intel_uncore_box *box)
+{
+	struct hlist_head *head;
+
+	head = &pmu->box_hash[box->phy_id % UNCORE_BOX_HASH_SIZE];
+	hlist_add_head_rcu(&box->hlist, head);
+}
+
+static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
+{
+	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
+}
+
+static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
+{
+	int phyid = topology_physical_package_id(smp_processor_id());
+	return uncore_pmu_find_box(uncore_event_to_pmu(event), phyid);
+}
+
+static int uncore_collect_events(struct intel_uncore_box *box,
+			  struct perf_event *leader, bool dogrp)
+{
+	struct perf_event *event;
+	int n, max_count;
+
+	max_count = box->pmu->type->num_counters;
+	if (box->pmu->type->fixed_ctl)
+		max_count++;
+
+	if (box->n_events >= max_count)
+		return -EINVAL;
+
+	n = box->n_events;
+	box->event_list[n] = leader;
+	n++;
+	if (!dogrp)
+		return n;
+
+	list_for_each_entry(event, &leader->sibling_list, group_entry) {
+		if (event->state <= PERF_EVENT_STATE_OFF)
+			continue;
+
+		if (n >= max_count)
+			return -EINVAL;
+
+		box->event_list[n] = event;
+		n++;
+	}
+	return n;
+}
+
+static struct event_constraint *
+uncore_event_constraint(struct intel_uncore_type *type,
+			struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	if (event->hw.config == (u64)-1)
+		return &constraint_fixed;
+
+	if (type->constraints) {
+		for_each_event_constraint(c, type->constraints) {
+			if ((event->hw.config & c->cmask) == c->code)
+				return c;
+		}
+	}
+
+	if (type->num_counters == 2)
+		return &unconstrained_2;
+	if (type->num_counters == 3)
+		return &unconstrained_3;
+	if (type->num_counters == 4)
+		return &unconstrained_4;
+	if (type->num_counters == 8)
+		return &unconstrained_8;
+
+	WARN_ON_ONCE(1);
+	return &unconstrained_2;
+}
+
+static int uncore_assign_events(struct intel_uncore_box *box,
+				int assign[], int n)
+{
+	struct event_constraint *c, *constraints[UNCORE_PMC_IDX_MAX];
+	int i, ret, wmin, wmax;
+
+	for (i = 0, wmin = UNCORE_PMC_IDX_MAX, wmax = 0; i < n; i++) {
+		c = uncore_event_constraint(box->pmu->type,
+				box->event_list[i]);
+		constraints[i] = c;
+		wmin = min(wmin, c->weight);
+		wmax = max(wmax, c->weight);
+	}
+
+	ret = perf_assign_events(constraints, n, wmin, wmax, assign);
+	return ret ? -EINVAL : 0;
+}
+
+static void __uncore_pmu_event_start(struct intel_uncore_box *box,
+				     struct perf_event *event, int flags)
+{
+	int idx = event->hw.idx;
+
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
+	if (WARN_ON_ONCE(idx == -1 || idx >= UNCORE_PMC_IDX_MAX))
+		return;
+
+	event->hw.state = 0;
+	__set_bit(idx, box->active_mask);
+	box->n_active++;
+	box->events[idx] = event;
+
+	local64_set(&event->hw.prev_count, uncore_read_counter(box, event));
+	uncore_enable_event(box, event);
+
+	if (box->n_active == 1)
+		uncore_pmu_start_hrtimer(box);
+}
+
+static void uncore_pmu_event_start(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+
+	raw_spin_lock(&box->lock);
+	__uncore_pmu_event_start(box, event, flags);
+	raw_spin_unlock(&box->lock);
+}
+
+static void __uncore_pmu_event_stop(struct intel_uncore_box *box,
+				    struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (__test_and_clear_bit(hwc->idx, box->active_mask)) {
+		uncore_disable_event(box, event);
+		box->n_active--;
+		box->events[hwc->idx] = NULL;
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+
+		if (box->n_active == 0)
+			uncore_pmu_cancel_hrtimer(box);
+	}
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		/*
+		 * Drain the remaining delta count out of a event
+		 * that we are disabling:
+		 */
+		__uncore_perf_event_update(box, event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+}
+
+static void uncore_pmu_event_stop(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+
+	raw_spin_lock(&box->lock);
+	__uncore_pmu_event_stop(box, event, flags);
+	raw_spin_unlock(&box->lock);
+}
+
+static int uncore_pmu_event_add(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	struct hw_perf_event *hwc = &event->hw;
+	int assign[UNCORE_PMC_IDX_MAX];
+	int i, n, ret;
+
+	if (!box)
+		return -ENODEV;
+
+	raw_spin_lock(&box->lock);
+	uncore_disable_all(box);
+
+	ret = n = uncore_collect_events(box, event, false);
+	if (ret < 0)
+		goto out;
+
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+	if (!(flags & PERF_EF_START))
+		hwc->state |= PERF_HES_ARCH;
+
+	ret = uncore_assign_events(box, assign, n);
+	if (ret)
+		goto out;
+
+	/* save events moving to new counters */
+	for (i = 0; i < box->n_events; i++) {
+		event = box->event_list[i];
+		hwc = &event->hw;
+
+		if (hwc->idx == assign[i] &&
+		    hwc->last_tag == box->tags[assign[i]])
+			continue;
+		/*
+		 * Ensure we don't accidentally enable a stopped
+		 * counter simply because we rescheduled.
+		 */
+		if (hwc->state & PERF_HES_STOPPED)
+			hwc->state |= PERF_HES_ARCH;
+
+		__uncore_pmu_event_stop(box, event, PERF_EF_UPDATE);
+	}
+
+	/* reprogram moved events into new counters */
+	for (i = 0; i < n; i++) {
+		event = box->event_list[i];
+		hwc = &event->hw;
+
+		if (hwc->idx != assign[i] ||
+		    hwc->last_tag != box->tags[assign[i]])
+			uncore_assign_hw_event(box, event, assign[i]);
+		else if (i < box->n_events)
+			continue;
+
+		if (hwc->state & PERF_HES_ARCH)
+			continue;
+
+		__uncore_pmu_event_start(box, event, 0);
+	}
+
+	box->n_events = n;
+	ret = 0;
+out:
+	uncore_enable_all(box);
+	raw_spin_unlock(&box->lock);
+	return ret;
+}
+
+static void uncore_pmu_event_del(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	int i;
+
+	raw_spin_lock(&box->lock);
+	__uncore_pmu_event_stop(box, event, PERF_EF_UPDATE);
+
+	for (i = 0; i < box->n_events; i++) {
+		if (event == box->event_list[i]) {
+			while (++i < box->n_events)
+				box->event_list[i - 1] = box->event_list[i];
+
+			--box->n_events;
+			break;
+		}
+	}
+	raw_spin_unlock(&box->lock);
+}
+
+static void uncore_pmu_event_read(struct perf_event *event)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+
+	uncore_perf_event_update(box, event);
+}
+
+/*
+ * validation ensures the group can be loaded onto the
+ * PMU if it was the only group available.
+ */
+static int uncore_validate_group(struct intel_uncore_pmu *pmu,
+				 struct perf_event *event)
+{
+	struct perf_event *leader = event->group_leader;
+	struct intel_uncore_box *fake_box;
+	int assign[UNCORE_PMC_IDX_MAX];
+	int ret = -EINVAL, n;
+
+	fake_box = alloc_uncore_box(smp_processor_id());
+	if (!fake_box)
+		return -ENOMEM;
+
+	fake_box->pmu = pmu;
+	/*
+	 * the event is not yet connected with its
+	 * siblings therefore we must first collect
+	 * existing siblings, then add the new event
+	 * before we can simulate the scheduling
+	 */
+	n = uncore_collect_events(fake_box, leader, true);
+	if (n < 0)
+		goto out;
+
+	fake_box->n_events = n;
+	n = uncore_collect_events(fake_box, event, false);
+	if (n < 0)
+		goto out;
+
+	fake_box->n_events = n;
+
+	ret = uncore_assign_events(fake_box, assign, n);
+out:
+	kfree(fake_box);
+	return ret;
+}
+
+int uncore_pmu_event_init(struct perf_event *event)
+{
+	struct intel_uncore_pmu *pmu;
+	struct hw_perf_event *hwc = &event->hw;
+	int ret = 0;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	pmu = uncore_event_to_pmu(event);
+	/* no device found for this pmu */
+	if (pmu->func_id < 0)
+		return -ENOENT;
+
+	/*
+	 * Uncore PMU does measure at all privilege level all the time.
+	 * So it doesn't make sense to specify any exclude bits.
+	 */
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_hv || event->attr.exclude_idle)
+		return -EINVAL;
+
+	/* Sampling not supported yet */
+	if (hwc->sample_period)
+		return -EINVAL;
+
+	if (event->attr.config == UNCORE_FIXED_EVENT) {
+		/* no fixed counter */
+		if (!pmu->type->fixed_ctl)
+			return -EINVAL;
+		/*
+		 * if there is only one fixed counter, only the first pmu
+		 * can access the fixed counter
+		 */
+		if (pmu->type->single_fixed && pmu->pmu_idx > 0)
+			return -EINVAL;
+		hwc->config = (u64)-1;
+	} else {
+		hwc->config = event->attr.config & pmu->type->event_mask;
+	}
+
+	event->hw.idx = -1;
+	event->hw.last_tag = ~0ULL;
+
+	if (event->group_leader != event)
+		ret = uncore_validate_group(pmu, event);
+
+	return ret;
+}
+
+static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
+{
+	int ret;
+
+	pmu->pmu.attr_groups	= pmu->type->attr_groups;
+	pmu->pmu.task_ctx_nr	= perf_invalid_context;
+	pmu->pmu.event_init	= uncore_pmu_event_init;
+	pmu->pmu.add		= uncore_pmu_event_add;
+	pmu->pmu.del		= uncore_pmu_event_del;
+	pmu->pmu.start		= uncore_pmu_event_start;
+	pmu->pmu.stop		= uncore_pmu_event_stop;
+	pmu->pmu.read		= uncore_pmu_event_read;
+
+	if (pmu->type->num_boxes == 1)
+		sprintf(pmu->name, "uncore_%s", pmu->type->name);
+	else
+		sprintf(pmu->name, "uncore_%s%d", pmu->type->name,
+			pmu->pmu_idx);
+
+	ret = perf_pmu_register(&pmu->pmu, pmu->name, -1);
+	return ret;
+}
+
+static void __init uncore_type_exit(struct intel_uncore_type *type)
+{
+	kfree(type->attr_groups[1]);
+	kfree(type->pmus);
+	type->attr_groups[1] = NULL;
+	type->pmus = NULL;
+}
+
+static int __init uncore_type_init(struct intel_uncore_type *type)
+{
+	struct intel_uncore_pmu *pmus;
+	struct attribute_group *events_group;
+	struct attribute **attrs;
+	int i, j;
+
+	pmus = kzalloc(sizeof(*pmus) * type->num_boxes, GFP_KERNEL);
+	if (!pmus)
+		return -ENOMEM;
+
+	for (i = 0; i < type->num_boxes; i++) {
+		pmus[i].func_id = -1;
+		pmus[i].pmu_idx = i;
+		pmus[i].type = type;
+
+		for (j = 0; j < ARRAY_SIZE(pmus[0].box_hash); j++)
+			INIT_HLIST_HEAD(&pmus[i].box_hash[j]);
+	}
+
+	if (type->event_descs) {
+		for (i = 0; ; i++) {
+			if (!type->event_descs[i].attr.attr.name)
+				break;
+		}
+
+		events_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
+					sizeof(*events_group), GFP_KERNEL);
+		if (!events_group)
+			goto fail;
+
+		attrs = (struct attribute **)(events_group + 1);
+		events_group->name = "events";
+		events_group->attrs = attrs;
+
+		for (j = 0; j < i; j++)
+			attrs[j] = &type->event_descs[j].attr.attr;
+
+		type->attr_groups[1] = events_group;
+	}
+	type->pmus = pmus;
+	return 0;
+fail:
+	uncore_type_exit(type);
+	return -ENOMEM;
+}
+
+static int __init uncore_types_init(struct intel_uncore_type **types)
+{
+	int i, ret;
+
+	for (i = 0; types[i]; i++) {
+		ret = uncore_type_init(types[i]);
+		if (ret)
+			goto fail;
+	}
+	return 0;
+fail:
+	while (--i >= 0)
+		uncore_type_exit(types[i]);
+	return ret;
+}
+
+static void uncore_cpu_dying(int cpu)
+{
+	struct intel_uncore_type *type;
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *box;
+	int i, j, phyid, free_it;
+
+	phyid = topology_physical_package_id(cpu);
+
+	for (i = 0; msr_uncores[i]; i++) {
+		type = msr_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			box = uncore_pmu_find_box(pmu, phyid);
+			if (box) {
+				free_it = 0;
+				spin_lock(&uncore_box_lock);
+				if (--box->refcnt == 0) {
+					hlist_del_rcu(&box->hlist);
+					free_it = 1;
+				}
+				spin_unlock(&uncore_box_lock);
+				if (free_it)
+					kfree_rcu(box, rcu_head);
+			}
+		}
+	}
+}
+
+static int uncore_cpu_starting(int cpu)
+{
+	struct intel_uncore_type *type;
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *box;
+	int i, j, phyid;
+
+	phyid = topology_physical_package_id(cpu);
+
+	for (i = 0; msr_uncores[i]; i++) {
+		type = msr_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			box = uncore_pmu_find_box(pmu, phyid);
+			if (box)
+				uncore_box_init(box);
+		}
+	}
+	return 0;
+}
+
+static int uncore_cpu_prepare(int cpu)
+{
+	struct intel_uncore_type *type;
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *exist, *box = NULL;
+	int i, j, phyid;
+
+	phyid = topology_physical_package_id(cpu);
+
+	/* allocate the box structure */
+	for (i = 0; msr_uncores[i]; i++) {
+		type = msr_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			exist = NULL;
+			pmu = &type->pmus[j];
+
+			spin_lock(&uncore_box_lock);
+			if (pmu->func_id < 0)
+				pmu->func_id = j;
+			exist = __uncore_pmu_find_box(pmu, phyid);
+			if (exist)
+				exist->refcnt++;
+			spin_unlock(&uncore_box_lock);
+			if (exist)
+				continue;
+
+			if (!box)
+				box = alloc_uncore_box(cpu);
+			if (!box)
+				return -ENOMEM;
+
+			spin_lock(&uncore_box_lock);
+			exist = __uncore_pmu_find_box(pmu, phyid);
+			if (!exist) {
+				box->pmu = pmu;
+				box->phy_id = phyid;
+				uncore_pmu_add_box(pmu, box);
+				box = NULL;
+			}
+			spin_unlock(&uncore_box_lock);
+		}
+	}
+	kfree(box);
+	return 0;
+}
+
+static void __init uncore_cpu_setup(void *dummy)
+{
+	uncore_cpu_starting(smp_processor_id());
+}
+
+static int __cpuinit uncore_cpu_notifier(struct notifier_block *self,
+					 unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		uncore_cpu_prepare(cpu);
+		break;
+	case CPU_STARTING:
+		uncore_cpu_starting(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_DYING:
+		uncore_cpu_dying(cpu);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static int __init uncore_cpu_init(void)
+{
+	int ret, cpu;
+
+	switch (boot_cpu_data.x86_model) {
+	default:
+		return 0;
+	}
+
+	ret = uncore_types_init(msr_uncores);
+	if (ret)
+		return ret;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		uncore_cpu_prepare(cpu);
+
+	on_each_cpu(uncore_cpu_setup, NULL, 1);
+
+	perf_cpu_notifier(uncore_cpu_notifier);
+	put_online_cpus();
+
+	return 0;
+}
+
+static int __init uncore_pmus_register(void)
+{
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_type *type;
+	int i, j;
+
+	for (i = 0; msr_uncores[i]; i++) {
+		type = msr_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			uncore_pmu_register(pmu);
+		}
+	}
+
+	return 0;
+}
+
+static int __init intel_uncore_init(void)
+{
+	int ret;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return -ENODEV;
+
+	ret = uncore_cpu_init();
+	if (ret) {
+		goto fail;
+	}
+
+	uncore_pmus_register();
+	return 0;
+fail:
+	return ret;
+}
+device_initcall(intel_uncore_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
new file mode 100644
index 0000000..2347546
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -0,0 +1,200 @@
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/perf_event.h>
+#include "perf_event.h"
+
+#define UNCORE_PMU_NAME_LEN		16
+#define UNCORE_BOX_HASH_SIZE		8
+
+#define UNCORE_PMU_HRTIMER_INTERVAL	(60 * NSEC_PER_SEC)
+
+#define UNCORE_FIXED_EVENT		0xffff
+#define UNCORE_PMC_IDX_MAX_GENERIC	8
+#define UNCORE_PMC_IDX_FIXED		UNCORE_PMC_IDX_MAX_GENERIC
+#define UNCORE_PMC_IDX_MAX		(UNCORE_PMC_IDX_FIXED + 1)
+
+#define UNCORE_EVENT_CONSTRAINT(c, n) EVENT_CONSTRAINT(c, n, 0xff)
+
+struct intel_uncore_ops;
+struct intel_uncore_pmu;
+struct intel_uncore_box;
+struct uncore_event_desc;
+
+struct intel_uncore_type {
+	const char *name;
+	int num_counters;
+	int num_boxes;
+	int perf_ctr_bits;
+	int fixed_ctr_bits;
+	int single_fixed;
+	unsigned perf_ctr;
+	unsigned event_ctl;
+	unsigned event_mask;
+	unsigned fixed_ctr;
+	unsigned fixed_ctl;
+	unsigned box_ctl;
+	unsigned msr_offset;
+	struct intel_uncore_pmu *pmus;
+	struct intel_uncore_ops *ops;
+	struct event_constraint *constraints;
+	struct uncore_event_desc *event_descs;
+	const struct attribute_group *attr_groups[3];
+};
+
+#define format_group attr_groups[0]
+
+struct intel_uncore_ops {
+	void (*init)(struct intel_uncore_box *);
+	void (*disable_all)(struct intel_uncore_box *);
+	void (*enable_all)(struct intel_uncore_box *);
+	void (*disable_event)(struct intel_uncore_box *, struct perf_event *);
+	void (*enable_event)(struct intel_uncore_box *, struct perf_event *);
+	u64 (*read_counter)(struct intel_uncore_box *, struct perf_event *);
+};
+
+struct intel_uncore_pmu {
+	struct pmu pmu;
+	char name[UNCORE_PMU_NAME_LEN];
+	int pmu_idx;
+	int func_id;
+	struct intel_uncore_type *type;
+	struct hlist_head box_hash[UNCORE_BOX_HASH_SIZE];
+};
+
+struct intel_uncore_box {
+	struct hlist_node hlist;
+	int phy_id;
+	int refcnt;
+	int n_active;
+	int n_events;
+	unsigned long flags;
+	struct perf_event *events[UNCORE_PMC_IDX_MAX];
+	struct perf_event *event_list[UNCORE_PMC_IDX_MAX];
+	unsigned long active_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
+	u64 tags[UNCORE_PMC_IDX_MAX];
+	struct intel_uncore_pmu *pmu;
+	struct hrtimer hrtimer;
+	struct rcu_head rcu_head;
+	raw_spinlock_t lock;
+};
+
+#define UNCORE_BOX_FLAG_INITIATED	0
+
+struct uncore_event_desc {
+	struct kobj_attribute attr;
+	const char *config;
+};
+
+#define INTEL_UNCORE_EVENT_DESC(_name, _config)			\
+{								\
+	.attr	= __ATTR(_name, 0444, uncore_event_show, NULL),	\
+	.config	= _config,					\
+}
+
+#define DEFINE_UNCORE_FORMAT_ATTR(_var, _name, _format)			\
+static ssize_t __uncore_##_var##_show(struct kobject *kobj,		\
+				struct kobj_attribute *attr,		\
+				char *page)				\
+{									\
+	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);			\
+	return sprintf(page, _format "\n");				\
+}									\
+static struct kobj_attribute format_attr_##_var =			\
+	__ATTR(_name, 0444, __uncore_##_var##_show, NULL)
+
+
+static ssize_t uncore_event_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct uncore_event_desc *event =
+		container_of(attr, struct uncore_event_desc, attr);
+	return sprintf(buf, "%s", event->config);
+}
+
+static inline
+unsigned uncore_msr_box_ctl(struct intel_uncore_box *box)
+{
+	if (!box->pmu->type->box_ctl)
+		return 0;
+	return box->pmu->type->box_ctl +
+		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+}
+
+static inline
+unsigned uncore_msr_fixed_ctl(struct intel_uncore_box *box)
+{
+	if (!box->pmu->type->fixed_ctl)
+		return 0;
+	return box->pmu->type->fixed_ctl +
+		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+}
+
+static inline
+unsigned uncore_msr_fixed_ctr(struct intel_uncore_box *box)
+{
+	return box->pmu->type->fixed_ctr +
+		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+}
+
+static inline
+unsigned uncore_msr_event_ctl(struct intel_uncore_box *box, int idx)
+{
+	return idx + box->pmu->type->event_ctl +
+		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+}
+
+static inline
+unsigned uncore_msr_perf_ctr(struct intel_uncore_box *box, int idx)
+{
+	return idx + box->pmu->type->perf_ctr +
+		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+}
+
+static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
+{
+	return box->pmu->type->perf_ctr_bits;
+}
+
+static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
+{
+	return box->pmu->type->fixed_ctr_bits;
+}
+
+static inline int uncore_num_counters(struct intel_uncore_box *box)
+{
+	return box->pmu->type->num_counters;
+}
+
+static inline void uncore_disable_all(struct intel_uncore_box *box)
+{
+	box->pmu->type->ops->disable_all(box);
+}
+
+static inline void uncore_enable_all(struct intel_uncore_box *box)
+{
+	box->pmu->type->ops->enable_all(box);
+}
+
+static inline void uncore_disable_event(struct intel_uncore_box *box,
+				struct perf_event *event)
+{
+	box->pmu->type->ops->disable_event(box, event);
+}
+
+static inline void uncore_enable_event(struct intel_uncore_box *box,
+				struct perf_event *event)
+{
+	box->pmu->type->ops->enable_event(box, event);
+}
+
+static inline u64 uncore_read_counter(struct intel_uncore_box *box,
+				struct perf_event *event)
+{
+	return box->pmu->type->ops->read_counter(box, event);
+}
+
+static inline void uncore_box_init(struct intel_uncore_box *box)
+{
+	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags))
+		box->pmu->type->ops->init(box);
+}
-- 
1.7.7.6

