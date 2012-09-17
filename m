Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2IQRUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:20:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57950 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2IQRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/18] perf/x86: Add cpumask for uncore pmu
Date: Mon, 17 Sep 2012 14:18:11 -0300
Message-Id: <1347902292-14536-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yan, Zheng <zheng.z.yan@intel.com>

This patch adds a cpumask file to the uncore pmu sysfs directory.  The
cpumask file contains one active cpu for every socket.

Signed-off-by: "Yan, Zheng" <zheng.z.yan@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1347263631-23175-2-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   28 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    6 +++-
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
1.7.1

