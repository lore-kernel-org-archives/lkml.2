Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967373Ab2EPFBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:01:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:54288 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966393Ab2EPFAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100617314"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] perf: Generic pci uncore device support
Date: Wed, 16 May 2012 13:00:00 +0800
Message-Id: <1337144403-30841-8-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds generic support for uncore pmu presented as
pci device.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  175 ++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   66 +++++++++
 2 files changed, 236 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 84f9ae6..9a43fb4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2,6 +2,11 @@
 
 static struct intel_uncore_type *empty_uncore[] = { NULL, };
 static struct intel_uncore_type **msr_uncores = empty_uncore;
+static struct intel_uncore_type **pci_uncores = empty_uncore;
+/* pci bus to socket mapping */
+static int pcibus_to_physid[256] = { [0 ... 255] = -1, };
+
+static DEFINE_RAW_SPINLOCK(uncore_box_lock);
 
 /* mask of cpus that collect uncore events */
 static cpumask_t uncore_cpu_mask;
@@ -205,13 +210,13 @@ static void uncore_assign_hw_event(struct intel_uncore_box *box,
 	hwc->last_tag = ++box->tags[idx];
 
 	if (hwc->idx == UNCORE_PMC_IDX_FIXED) {
-		hwc->event_base = uncore_msr_fixed_ctr(box);
-		hwc->config_base = uncore_msr_fixed_ctl(box);
+		hwc->event_base = uncore_fixed_ctr(box);
+		hwc->config_base = uncore_fixed_ctl(box);
 		return;
 	}
 
-	hwc->config_base = uncore_msr_event_ctl(box, hwc->idx);
-	hwc->event_base =  uncore_msr_perf_ctr(box, hwc->idx);
+	hwc->config_base = uncore_event_ctl(box, hwc->idx);
+	hwc->event_base =  uncore_perf_ctr(box, hwc->idx);
 }
 
 static void uncore_perf_event_update(struct intel_uncore_box *box,
@@ -305,6 +310,22 @@ struct intel_uncore_box *uncore_alloc_box(int cpu)
 static struct intel_uncore_box *
 uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 {
+	static struct intel_uncore_box *box;
+
+	box =  *per_cpu_ptr(pmu->box, cpu);
+	if (box)
+		return box;
+
+	raw_spin_lock(&uncore_box_lock);
+	list_for_each_entry(box, &pmu->box_list, list) {
+		if (box->phys_id == topology_physical_package_id(cpu)) {
+			atomic_inc(&box->refcnt);
+			*per_cpu_ptr(pmu->box, cpu) = box;
+			break;
+		}
+	}
+	raw_spin_unlock(&uncore_box_lock);
+
 	return *per_cpu_ptr(pmu->box, cpu);
 }
 
@@ -706,6 +727,13 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->attr_groups[1] = NULL;
 }
 
+static void uncore_types_exit(struct intel_uncore_type **types)
+{
+	int i;
+	for (i = 0; types[i]; i++)
+		uncore_type_exit(types[i]);
+}
+
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
@@ -725,6 +753,7 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		pmus[i].func_id = -1;
 		pmus[i].pmu_idx = i;
 		pmus[i].type = type;
+		INIT_LIST_HEAD(&pmus[i].box_list);
 		pmus[i].box = alloc_percpu(struct intel_uncore_box *);
 		if (!pmus[i].box)
 			goto fail;
@@ -771,6 +800,127 @@ static int __init uncore_types_init(struct intel_uncore_type **types)
 	return ret;
 }
 
+static struct pci_driver *uncore_pci_driver;
+static bool pcidrv_registered;
+
+/*
+ * add a pci uncore device
+ */
+static int __devinit uncore_pci_add(struct intel_uncore_type *type,
+				    struct pci_dev *pdev)
+{
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *box;
+	int i,  phys_id;
+
+	phys_id = pcibus_to_physid[pdev->bus->number];
+	if (phys_id < 0)
+		return -ENODEV;
+
+	box = uncore_alloc_box(0);
+	if (!box)
+		return -ENOMEM;
+
+	/*
+	 * for performance monitoring unit with multiple boxes,
+	 * each box has a different function id.
+	 */
+	for (i = 0; i < type->num_boxes; i++) {
+		pmu = &type->pmus[i];
+		if (pmu->func_id == pdev->devfn)
+			break;
+		if (pmu->func_id < 0) {
+			pmu->func_id = pdev->devfn;
+			break;
+		}
+		pmu = NULL;
+	}
+
+	if (!pmu) {
+		kfree(box);
+		return -EINVAL;
+	}
+
+	box->phys_id = phys_id;
+	box->pci_dev = pdev;
+	box->pmu = pmu;
+	uncore_box_init(box);
+	pci_set_drvdata(pdev, box);
+
+	raw_spin_lock(&uncore_box_lock);
+	list_add_tail(&box->list, &pmu->box_list);
+	raw_spin_unlock(&uncore_box_lock);
+
+	return 0;
+}
+
+static void __devexit uncore_pci_remove(struct pci_dev *pdev)
+{
+	struct intel_uncore_box *box = pci_get_drvdata(pdev);
+	struct intel_uncore_pmu *pmu = box->pmu;
+	int cpu, phys_id = pcibus_to_physid[pdev->bus->number];
+
+	if (WARN_ON_ONCE(phys_id != box->phys_id))
+		return;
+
+	raw_spin_lock(&uncore_box_lock);
+	list_del(&box->list);
+	raw_spin_unlock(&uncore_box_lock);
+
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(pmu->box, cpu) == box) {
+			*per_cpu_ptr(pmu->box, cpu) = NULL;
+			atomic_dec(&box->refcnt);
+		}
+	}
+
+	WARN_ON_ONCE(atomic_read(&box->refcnt) != 1);
+	kfree(box);
+}
+
+static int __devinit uncore_pci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id)
+{
+	struct intel_uncore_type *type;
+
+	type = (struct intel_uncore_type *)id->driver_data;
+	return uncore_pci_add(type, pdev);
+}
+
+static int __init uncore_pci_init(void)
+{
+	int ret;
+
+	switch (boot_cpu_data.x86_model) {
+	default:
+		return 0;
+	}
+
+	ret =  uncore_types_init(pci_uncores);
+	if (ret)
+		return ret;
+
+	uncore_pci_driver->probe = uncore_pci_probe;
+	uncore_pci_driver->remove = uncore_pci_remove;
+
+	ret = pci_register_driver(uncore_pci_driver);
+	if (ret == 0)
+		pcidrv_registered = true;
+	else
+		uncore_types_exit(pci_uncores);
+
+	return ret;
+}
+
+static void __init uncore_pci_exit(void)
+{
+	if (pcidrv_registered) {
+		pcidrv_registered = false;
+		pci_unregister_driver(uncore_pci_driver);
+		uncore_types_exit(pci_uncores);
+	}
+}
+
 static void __cpuinit uncore_cpu_dying(int cpu)
 {
 	struct intel_uncore_type *type;
@@ -919,6 +1069,7 @@ static void __cpuinit uncore_event_exit_cpu(int cpu)
 		cpumask_set_cpu(target, &uncore_cpu_mask);
 
 	uncore_change_context(msr_uncores, cpu, target);
+	uncore_change_context(pci_uncores, cpu, target);
 }
 
 static void __cpuinit uncore_event_init_cpu(int cpu)
@@ -934,6 +1085,7 @@ static void __cpuinit uncore_event_init_cpu(int cpu)
 	cpumask_set_cpu(cpu, &uncore_cpu_mask);
 
 	uncore_change_context(msr_uncores, -1, cpu);
+	uncore_change_context(pci_uncores, -1, cpu);
 }
 
 static int __cpuinit uncore_cpu_notifier(struct notifier_block *self,
@@ -1048,6 +1200,14 @@ static int __init uncore_pmus_register(void)
 		}
 	}
 
+	for (i = 0; pci_uncores[i]; i++) {
+		type = pci_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			uncore_pmu_register(pmu);
+		}
+	}
+
 	return 0;
 }
 
@@ -1058,9 +1218,14 @@ static int __init intel_uncore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return -ENODEV;
 
-	ret = uncore_cpu_init();
+	ret = uncore_pci_init();
 	if (ret)
 		goto fail;
+	ret = uncore_cpu_init();
+	if (ret) {
+		uncore_pci_exit();
+		goto fail;
+	}
 
 	uncore_pmus_register();
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index eeb5ca5..aa01df8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 #include <linux/perf_event.h>
 #include "perf_event.h"
 
@@ -110,6 +111,7 @@ struct intel_uncore_pmu {
 	int func_id;
 	struct intel_uncore_type *type;
 	struct intel_uncore_box ** __percpu box;
+	struct list_head box_list;
 };
 
 struct intel_uncore_box {
@@ -123,6 +125,7 @@ struct intel_uncore_box {
 	struct perf_event *event_list[UNCORE_PMC_IDX_MAX];
 	unsigned long active_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
 	u64 tags[UNCORE_PMC_IDX_MAX];
+	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
 	struct hrtimer hrtimer;
 	struct list_head list;
@@ -161,6 +164,33 @@ static ssize_t uncore_event_show(struct kobject *kobj,
 	return sprintf(buf, "%s", event->config);
 }
 
+static inline unsigned uncore_pci_box_ctl(struct intel_uncore_box *box)
+{
+	return box->pmu->type->box_ctl;
+}
+
+static inline unsigned uncore_pci_fixed_ctl(struct intel_uncore_box *box)
+{
+	return box->pmu->type->fixed_ctl;
+}
+
+static inline unsigned uncore_pci_fixed_ctr(struct intel_uncore_box *box)
+{
+	return box->pmu->type->fixed_ctr;
+}
+
+static inline
+unsigned uncore_pci_event_ctl(struct intel_uncore_box *box, int idx)
+{
+	return idx * 4 + box->pmu->type->event_ctl;
+}
+
+static inline
+unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
+{
+	return idx * 8 + box->pmu->type->perf_ctr;
+}
+
 static inline
 unsigned uncore_msr_box_ctl(struct intel_uncore_box *box)
 {
@@ -200,6 +230,42 @@ unsigned uncore_msr_perf_ctr(struct intel_uncore_box *box, int idx)
 		box->pmu->type->msr_offset * box->pmu->pmu_idx;
 }
 
+static inline
+unsigned uncore_fixed_ctl(struct intel_uncore_box *box)
+{
+	if (box->pci_dev)
+		return uncore_pci_fixed_ctl(box);
+	else
+		return uncore_msr_fixed_ctl(box);
+}
+
+static inline
+unsigned uncore_fixed_ctr(struct intel_uncore_box *box)
+{
+	if (box->pci_dev)
+		return uncore_pci_fixed_ctr(box);
+	else
+		return uncore_msr_fixed_ctr(box);
+}
+
+static inline
+unsigned uncore_event_ctl(struct intel_uncore_box *box, int idx)
+{
+	if (box->pci_dev)
+		return uncore_pci_event_ctl(box, idx);
+	else
+		return uncore_msr_event_ctl(box, idx);
+}
+
+static inline
+unsigned uncore_perf_ctr(struct intel_uncore_box *box, int idx)
+{
+	if (box->pci_dev)
+		return uncore_pci_perf_ctr(box, idx);
+	else
+		return uncore_msr_perf_ctr(box, idx);
+}
+
 static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
 {
 	return box->pmu->type->perf_ctr_bits;
-- 
1.7.7.6

