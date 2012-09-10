Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2IJHy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:54:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:43486 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2IJHx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="190784694"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 1/3] perf/x86: Add cpumask for uncore pmu
Date: Mon, 10 Sep 2012 15:53:49 +0800
Message-Id: <1347263631-23175-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds a cpumask file to the uncore pmu sysfs directory.
The cpumask file contains one active cpu for every socket.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 28 ++++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  6 ++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0a55710..62ec3e6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2341,6 +2341,27 @@ int uncore_pmu_event_init(struct perf_event *event)
 	return ret;
 }
 
+static ssize_t uncore_get_attr_cpumask(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &uncore_cpu_mask);
+
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+
+static DEVICE_ATTR(cpumask, S_IRUGO, uncore_get_attr_cpumask, NULL);
+
+static struct attribute *uncore_pmu_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group uncore_pmu_attr_group = {
+	.attrs = uncore_pmu_attrs,
+};
+
 static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
@@ -2378,8 +2399,8 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 		free_percpu(type->pmus[i].box);
 	kfree(type->pmus);
 	type->pmus = NULL;
-	kfree(type->attr_groups[1]);
-	type->attr_groups[1] = NULL;
+	kfree(type->events_group);
+	type->events_group = NULL;
 }
 
 static void __init uncore_types_exit(struct intel_uncore_type **types)
@@ -2431,9 +2452,10 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		for (j = 0; j < i; j++)
 			attrs[j] = &type->event_descs[j].attr.attr;
 
-		type->attr_groups[1] = events_group;
+		type->events_group = events_group;
 	}
 
+	type->pmu_group = &uncore_pmu_attr_group;
 	type->pmus = pmus;
 	return 0;
 fail:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 5b81c18..e68a455 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -369,10 +369,12 @@ struct intel_uncore_type {
 	struct intel_uncore_pmu *pmus;
 	struct intel_uncore_ops *ops;
 	struct uncore_event_desc *event_descs;
-	const struct attribute_group *attr_groups[3];
+	const struct attribute_group *attr_groups[4];
 };
 
-#define format_group attr_groups[0]
+#define pmu_group attr_groups[0]
+#define format_group attr_groups[1]
+#define events_group attr_groups[2]
 
 struct intel_uncore_ops {
 	void (*init_box)(struct intel_uncore_box *);
-- 
1.7.11.4

