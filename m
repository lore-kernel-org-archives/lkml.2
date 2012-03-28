Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2C1Gnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:43:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:32211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab2C1Gn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:43:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="82461644"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: [PATCH 4/5] perf: Generic pci uncore device support
Date: Wed, 28 Mar 2012 14:43:17 +0800
Message-Id: <1332916998-10628-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds generic support for uncore pmu presented as pci
device.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  148 ++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   29 +++++
 2 files changed, 173 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 39a1c0e..7e19996 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2,6 +2,12 @@
 
 static struct intel_uncore_type *empty_uncore[] = { NULL, };
 static struct intel_uncore_type **msr_uncores = empty_uncore;
+static struct intel_uncore_type **pci_uncores = empty_uncore;
+static struct pci_driver *uncore_pci_driver;
+static bool pcidrv_registered;
+
+/* pci bus to socket mapping */
+static int pcibus_to_phyid[256] = { [0 ... 255] = -1, };
 
 /* constraint for box with 2 counters */
 static struct event_constraint unconstrained_2 =
@@ -261,13 +267,23 @@ static void uncore_assign_hw_event(struct intel_uncore_box *box,
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
 
 static void __uncore_perf_event_update(struct intel_uncore_box *box,
@@ -856,6 +872,118 @@ static int __init uncore_types_init(struct intel_uncore_type **types)
 	return ret;
 }
 
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
+	box = alloc_uncore_box(0);
+	if (!box)
+		return -ENOMEM;
+
+	spin_lock(&uncore_box_lock);
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
+		uncore_pmu_add_box(pmu, box);
+	} else {
+		ret = -EINVAL;
+	}
+	spin_unlock(&uncore_box_lock);
+	if (ret)
+		kfree(box);
+	return ret;
+}
+
+static void __devexit uncore_pci_remove(struct pci_dev *pdev)
+{
+	struct intel_uncore_box *box = pci_get_drvdata(pdev);
+	int phyid = pcibus_to_phyid[pdev->bus->number];
+	int free_it = 0;
+
+	if (WARN_ON_ONCE(phyid != box->phy_id))
+		return;
+
+	box->pci_dev = NULL;
+	spin_lock(&uncore_box_lock);
+	if (--box->refcnt == 0) {
+		hlist_del_rcu(&box->hlist);
+		free_it = 1;
+	}
+	spin_unlock(&uncore_box_lock);
+	if (free_it)
+		kfree_rcu(box, rcu_head);
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
+		pci_unregister_driver(uncore_pci_driver);
+		pcidrv_registered = false;
+	}
+}
+
 static void uncore_cpu_dying(int cpu)
 {
 	struct intel_uncore_type *type;
@@ -1031,6 +1159,14 @@ static int __init uncore_pmus_register(void)
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
 
@@ -1041,8 +1177,12 @@ static int __init intel_uncore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return -ENODEV;
 
+	ret = uncore_pci_init();
+	if (ret)
+		goto fail;
 	ret = uncore_cpu_init();
 	if (ret) {
+		uncore_pci_exit();
 		goto fail;
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 389e996..39df0ec 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 #include <linux/perf_event.h>
 #include "perf_event.h"
 
@@ -122,6 +123,7 @@ struct intel_uncore_box {
 	struct perf_event *event_list[UNCORE_PMC_IDX_MAX];
 	unsigned long active_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
 	u64 tags[UNCORE_PMC_IDX_MAX];
+	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
 	struct hrtimer hrtimer;
 	struct rcu_head rcu_head;
@@ -161,6 +163,33 @@ static ssize_t uncore_event_show(struct kobject *kobj,
 	return sprintf(buf, "0x%llx\n", event->config);
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

