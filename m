Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab2ECRND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:13:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33796 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2ECRNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:13:01 -0400
Message-ID: <1336065156.22523.34.camel@twins>
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 19:12:36 +0200
In-Reply-To: <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
> +static struct intel_uncore_box *
> +__uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
> +{
> +       struct intel_uncore_box *box;
> +       struct hlist_head *head;
> +       struct hlist_node *node;
> +
> +       head = &pmu->box_hash[phyid % UNCORE_BOX_HASH_SIZE];
> +       hlist_for_each_entry_rcu(box, node, head, hlist) {
> +               if (box->phy_id == phyid)
> +                       return box;
> +       }
> +
> +       return NULL;
> +} 

I still don't get why something like:

static struct intel_uncore_box *
pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
{
	return per_cpu_ptr(pmu->box, cpu);
}

doesn't work.

Last time you mumbled something about PCI devices, but afaict those are
in all respects identical to MSR devices except you talk to them using
PCI-mmio instead of MSR registers.

In fact, since its all local to the generic code there's nothing
different between pci/msr already.

So how about something like this:

---
 Makefile                  |    4 +-
 perf_event_intel_uncore.c |   92 ++++++++++++++++++----------------------------
 perf_event_intel_uncore.h |    4 +-
 3 files changed, 42 insertions(+), 58 deletions(-)

--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -32,7 +32,9 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o perf_event_intel_uncore.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o 
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o 
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
 endif
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -116,40 +116,21 @@ struct intel_uncore_box *uncore_alloc_bo
 }
 
 static struct intel_uncore_box *
-__uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
+uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 {
-	struct intel_uncore_box *box;
-	struct hlist_head *head;
-	struct hlist_node *node;
-
-	head = &pmu->box_hash[phyid % UNCORE_BOX_HASH_SIZE];
-	hlist_for_each_entry_rcu(box, node, head, hlist) {
-		if (box->phy_id == phyid)
-			return box;
-	}
-
-	return NULL;
-}
-
-static struct intel_uncore_box *
-uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
-{
-	struct intel_uncore_box *box;
-
-	rcu_read_lock();
-	box = __uncore_pmu_find_box(pmu, phyid);
-	rcu_read_unlock();
-
-	return box;
+	return per_cpu_ptr(pmu->box, cpu);
 }
 
 static void uncore_pmu_add_box(struct intel_uncore_pmu *pmu,
 				struct intel_uncore_box *box)
 {
-	struct hlist_head *head;
+	int cpu;
 
-	head = &pmu->box_hash[box->phy_id % UNCORE_BOX_HASH_SIZE];
-	hlist_add_head_rcu(&box->hlist, head);
+	for_each_cpu(cpu) {
+		if (box->phys_id != topology_physical_package_id(cpu))
+			continue;
+		per_cpu_ptr(pmu->box, cpu) = box;
+	}
 }
 
 static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
@@ -163,8 +144,7 @@ static struct intel_uncore_box *uncore_e
 	 * perf core schedules event on the basis of cpu, uncore events are
 	 * collected by one of the cpus inside a physical package.
 	 */
-	int phyid = topology_physical_package_id(smp_processor_id());
-	return uncore_pmu_find_box(uncore_event_to_pmu(event), phyid);
+	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
 }
 
 static int uncore_collect_events(struct intel_uncore_box *box,
@@ -478,8 +458,7 @@ int uncore_pmu_event_init(struct perf_ev
 	 */
 	if (event->cpu < 0)
 		return -EINVAL;
-	box = uncore_pmu_find_box(pmu,
-			topology_physical_package_id(event->cpu));
+	box = uncore_pmu_to_box(pmu, event->cpu);
 	if (!box || box->cpu < 0)
 		return -EINVAL;
 	event->cpu = box->cpu;
@@ -541,7 +520,11 @@ static int __init uncore_pmu_register(st
 
 static void __init uncore_type_exit(struct intel_uncore_type *type)
 {
+	int i;
+
 	kfree(type->attr_groups[1]);
+	for (i = 0; i < type->num_boxes; i++)
+		free_percpu(type->pmus[i].box);
 	kfree(type->pmus);
 	type->attr_groups[1] = NULL;
 	type->pmus = NULL;
@@ -566,9 +549,9 @@ static int __init uncore_type_init(struc
 		pmus[i].func_id = -1;
 		pmus[i].pmu_idx = i;
 		pmus[i].type = type;
-
-		for (j = 0; j < ARRAY_SIZE(pmus[0].box_hash); j++)
-			INIT_HLIST_HEAD(&pmus[i].box_hash[j]);
+		pmus[i].box = alloc_percpu(struct intel_uncore_box *);
+		if (!pmus[i].box)
+			goto fail_percpu;
 	}
 
 	if (type->event_descs) {
@@ -591,6 +574,11 @@ static int __init uncore_type_init(struc
 
 	type->pmus = pmus;
 	return 0;
+
+fail_percpu:
+	for (i = 0; i < type->num_boxes; i++)
+		free_percpu(pmus[i].box);
+
 fail:
 	uncore_type_exit(type);
 	return -ENOMEM;
@@ -617,15 +605,13 @@ static void __cpuinit uncore_cpu_dying(i
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, j, phyid;
-
-	phyid = topology_physical_package_id(cpu);
+	int i, j;
 
 	for (i = 0; msr_uncores[i]; i++) {
 		type = msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
-			box = uncore_pmu_find_box(pmu, phyid);
+			box = uncore_pmu_to_box(pmu, cpu);
 			if (box && --box->refcnt == 0) {
 				hlist_del_rcu(&box->hlist);
 				kfree_rcu(box, rcu_head);
@@ -639,15 +625,13 @@ static int __cpuinit uncore_cpu_starting
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, j, phyid;
-
-	phyid = topology_physical_package_id(cpu);
+	int i, j;
 
 	for (i = 0; msr_uncores[i]; i++) {
 		type = msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
-			box = uncore_pmu_find_box(pmu, phyid);
+			box = uncore_pmu_to_box(pmu, cpu);
 			if (box)
 				uncore_box_init(box);
 		}
@@ -660,9 +644,7 @@ static int __cpuinit uncore_cpu_prepare(
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *exist, *box;
-	int i, j, phyid;
-
-	phyid = topology_physical_package_id(cpu);
+	int i, j;
 
 	/* allocate the box data structure */
 	for (i = 0; msr_uncores[i]; i++) {
@@ -673,7 +655,7 @@ static int __cpuinit uncore_cpu_prepare(
 
 			if (pmu->func_id < 0)
 				pmu->func_id = j;
-			exist = uncore_pmu_find_box(pmu, phyid);
+			exist = uncore_pmu_to_box(pmu, cpu);
 			if (exist)
 				exist->refcnt++;
 			if (exist)
@@ -684,7 +666,7 @@ static int __cpuinit uncore_cpu_prepare(
 				return -ENOMEM;
 
 			box->pmu = pmu;
-			box->phy_id = phyid;
+			box->phys_id = topology_physical_package_id(cpu);
 			uncore_pmu_add_box(pmu, box);
 		}
 	}
@@ -696,19 +678,19 @@ static void __cpuinit uncore_event_exit_
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, j, phyid, target;
+	int i, j, phys_id, target;
 
 	/* if exiting cpu is used for collecting uncore events */
 	if (!cpumask_test_and_clear_cpu(cpu, &uncore_cpu_mask))
 		return;
 
 	/* find a new cpu to collect uncore events */
-	phyid = topology_physical_package_id(cpu);
+	phys_id = topology_physical_package_id(cpu);
 	target = -1;
 	for_each_online_cpu(i) {
 		if (i == cpu)
 			continue;
-		if (phyid == topology_physical_package_id(i)) {
+		if (phys_id == topology_physical_package_id(i)) {
 			target = i;
 			break;
 		}
@@ -722,7 +704,7 @@ static void __cpuinit uncore_event_exit_
 		type = msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
-			box = uncore_pmu_find_box(pmu, phyid);
+			box = uncore_pmu_to_box(pmu, phys_id);
 			WARN_ON_ONCE(box->cpu != cpu);
 
 			if (target >= 0) {
@@ -742,11 +724,11 @@ static void __cpuinit uncore_event_init_
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, j, phyid;
+	int i, j, phys_id;
 
-	phyid = topology_physical_package_id(cpu);
+	phys_id = topology_physical_package_id(cpu);
 	for_each_cpu(i, &uncore_cpu_mask) {
-		if (phyid == topology_physical_package_id(i))
+		if (phys_id == topology_physical_package_id(i))
 			return;
 	}
 
@@ -756,7 +738,7 @@ static void __cpuinit uncore_event_init_
 		type = msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
-			box = uncore_pmu_find_box(pmu, phyid);
+			box = uncore_pmu_to_box(pmu, cpu);
 			WARN_ON_ONCE(box->cpu != -1);
 			box->cpu = cpu;
 		}
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -59,12 +59,12 @@ struct intel_uncore_pmu {
 	int pmu_idx;
 	int func_id;
 	struct intel_uncore_type *type;
-	struct hlist_head box_hash[UNCORE_BOX_HASH_SIZE];
+	struct intel_uncore_box * __per_cpu box;
 };
 
 struct intel_uncore_box {
 	struct hlist_node hlist;
-	int phy_id;
+	int phys_id;
 	int refcnt;
 	int n_active;	/* number of active events */
 	int n_events;

