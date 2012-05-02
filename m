Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab2EBCH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:07:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:46532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758480Ab2EBCHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:07:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138970467"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] perf: Generic pci uncore device support
Date: Wed,  2 May 2012 10:07:17 +0800
Message-Id: <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds generic support for uncore pmu presented as
pci device.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  210 ++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   29 ++++
 2 files changed, 214 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 6022c8a..b4a15a5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2,6 +2,7 @@
 
 static struct intel_uncore_type *empty_uncore[] = { NULL, };
 static struct intel_uncore_type **msr_uncores = empty_uncore;
+static struct intel_uncore_type **pci_uncores = empty_uncore;
 
 /* mask of cpus that collect uncore events */
 static cpumask_t uncore_cpu_mask;
@@ -205,13 +206,23 @@ static void uncore_assign_hw_event(struct intel_uncore_box *box,
 	hwc->last_tag = ++box->tags[idx];
 
 	if (hwc->idx == UNCORE_PMC_IDX_FIXED) {
-		hwc->event_base = uncore_msr_fixed_ctr(box);
-		hwc->config_base = uncore_msr_fixed_ctl(box);
+		if (box->pci_dev) {
+			hwc->event_base = uncore_pci_fixed_ctr(box);
+			hwc->config_base = uncore_pci_fixed_ctl(box);
+		} else {
+			hwc->event_base = uncore_msr_fixed_ctr(box);
+			hwc->config_base = uncore_msr_fixed_ctl(box);
+		}
 		return;
 	}
 
-	hwc->config_base = uncore_msr_event_ctl(box, hwc->idx);
-	hwc->event_base =  uncore_msr_perf_ctr(box, hwc->idx);
+	if (box->pci_dev) {
+		hwc->config_base = uncore_pci_event_ctl(box, hwc->idx);
+		hwc->event_base =  uncore_pci_perf_ctr(box, hwc->idx);
+	} else {
+		hwc->config_base = uncore_msr_event_ctl(box, hwc->idx);
+		hwc->event_base =  uncore_msr_perf_ctr(box, hwc->idx);
+	}
 }
 
 static void uncore_perf_event_update(struct intel_uncore_box *box,
@@ -733,6 +744,13 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->pmus = NULL;
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
@@ -798,6 +816,121 @@ static int __init uncore_types_init(struct intel_uncore_type **types)
 	return ret;
 }
 
+static DEFINE_SPINLOCK(uncore_pci_lock);
+static struct pci_driver *uncore_pci_driver;
+static bool pcidrv_registered;
+/* pci bus to socket mapping */
+static int pcibus_to_phyid[256] = { [0 ... 255] = -1, };
+
+/*
+ * add a pci uncore device
+ */
+static int __devinit uncore_pci_add(struct intel_uncore_type *type,
+				struct pci_dev *pdev)
+{
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *box;
+	int phyid, i, ret = 0;
+
+	phyid = pcibus_to_phyid[pdev->bus->number];
+	if (phyid < 0)
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
+	if (pmu) {
+		box->phy_id = phyid;
+		box->pci_dev = pdev;
+		box->pmu = pmu;
+		uncore_box_init(box);
+		pci_set_drvdata(pdev, box);
+		spin_lock(&uncore_pci_lock);
+		uncore_pmu_add_box(pmu, box);
+		spin_unlock(&uncore_pci_lock);
+	} else {
+		ret = -EINVAL;
+		kfree(box);
+	}
+	return ret;
+}
+
+static void __devexit uncore_pci_remove(struct pci_dev *pdev)
+{
+	struct intel_uncore_box *box = pci_get_drvdata(pdev);
+	int phyid = pcibus_to_phyid[pdev->bus->number];
+
+	if (WARN_ON_ONCE(phyid != box->phy_id))
+		return;
+
+	box->pci_dev = NULL;
+	if (--box->refcnt == 0) {
+		spin_lock(&uncore_pci_lock);
+		hlist_del_rcu(&box->hlist);
+		spin_unlock(&uncore_pci_lock);
+		kfree_rcu(box, rcu_head);
+	}
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
@@ -882,6 +1015,7 @@ static void __cpuinit uncore_event_exit_cpu(int cpu)
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
+	struct intel_uncore_type **uncores;
 	int i, j, phyid, target;
 
 	/* if exiting cpu is used for collecting uncore events */
@@ -904,22 +1038,28 @@ static void __cpuinit uncore_event_exit_cpu(int cpu)
 	if (target >= 0)
 		cpumask_set_cpu(target, &uncore_cpu_mask);
 
-	for (i = 0; msr_uncores[i]; i++) {
-		type = msr_uncores[i];
-		for (j = 0; j < type->num_boxes; j++) {
-			pmu = &type->pmus[j];
-			box = uncore_pmu_find_box(pmu, phyid);
-			WARN_ON_ONCE(box->cpu != cpu);
-
-			if (target >= 0) {
-				uncore_pmu_cancel_hrtimer(box);
-				perf_pmu_migrate_context(&pmu->pmu,
+	uncores = msr_uncores;
+	while (1) {
+		for (i = 0; uncores[i]; i++) {
+			type = uncores[i];
+			for (j = 0; j < type->num_boxes; j++) {
+				pmu = &type->pmus[j];
+				box = uncore_pmu_find_box(pmu, phyid);
+				WARN_ON_ONCE(box->cpu != cpu);
+
+				if (target >= 0) {
+					uncore_pmu_cancel_hrtimer(box);
+					perf_pmu_migrate_context(&pmu->pmu,
 							cpu, target);
-				box->cpu = target;
-			} else {
-				box->cpu = -1;
+					box->cpu = target;
+				} else {
+					box->cpu = -1;
+				}
 			}
 		}
+		if (uncores != msr_uncores)
+			break;
+		uncores = pci_uncores;
 	}
 }
 
@@ -928,6 +1068,7 @@ static void __cpuinit uncore_event_init_cpu(int cpu)
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
+	struct intel_uncore_type **uncores;
 	int i, j, phyid;
 
 	phyid = topology_physical_package_id(cpu);
@@ -938,14 +1079,20 @@ static void __cpuinit uncore_event_init_cpu(int cpu)
 
 	cpumask_set_cpu(cpu, &uncore_cpu_mask);
 
-	for (i = 0; msr_uncores[i]; i++) {
-		type = msr_uncores[i];
-		for (j = 0; j < type->num_boxes; j++) {
-			pmu = &type->pmus[j];
-			box = uncore_pmu_find_box(pmu, phyid);
-			WARN_ON_ONCE(box->cpu != -1);
-			box->cpu = cpu;
+	uncores = msr_uncores;
+	while (1) {
+		for (i = 0; uncores[i]; i++) {
+			type = uncores[i];
+			for (j = 0; j < type->num_boxes; j++) {
+				pmu = &type->pmus[j];
+				box = uncore_pmu_find_box(pmu, phyid);
+				WARN_ON_ONCE(box->cpu != -1);
+				box->cpu = cpu;
+			}
 		}
+		if (uncores != msr_uncores)
+			break;
+		uncores = pci_uncores;
 	}
 }
 
@@ -1053,6 +1200,14 @@ static int __init uncore_pmus_register(void)
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
 
@@ -1063,9 +1218,14 @@ static int __init intel_uncore_init(void)
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
index 1c87569..b39e623 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 #include <linux/perf_event.h>
 #include "perf_event.h"
 
@@ -124,6 +125,7 @@ struct intel_uncore_box {
 	struct perf_event *event_list[UNCORE_PMC_IDX_MAX];
 	unsigned long active_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
 	u64 tags[UNCORE_PMC_IDX_MAX];
+	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
 	struct hrtimer hrtimer;
 	struct rcu_head rcu_head;
@@ -162,6 +164,33 @@ static ssize_t uncore_event_show(struct kobject *kobj,
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
-- 
1.7.7.6

