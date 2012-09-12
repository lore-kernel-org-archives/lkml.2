Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2ILOOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:14:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64725 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab2ILONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:13:46 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH v2 3/3] perf: add sysfs entry to adjust multiplexing interval per PMU
Date: Wed, 12 Sep 2012 16:13:15 +0200
Message-Id: <1347459195-5491-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347459195-5491-1-git-send-email-eranian@google.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds /sys/device/xxx/mux_interval_ms to ajust the
multiplexing interval per PMU. The unit is milliseconds. Value
has to be >= 1.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |   54 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f299fc8..e439034 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -784,6 +784,7 @@ struct pmu {
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
+	int				hrtimer_interval_ms;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
diff --git a/kernel/events/core.c b/kernel/events/core.c
index cf1aec4..681eca2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -690,15 +690,22 @@ static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct hrtimer *hr = &cpuctx->hrtimer;
 	struct pmu *pmu = cpuctx->ctx.pmu;
+	int timer;
 
 	cpuctx->hrtimer_active = 0;
 
 	/* no multiplexing needed for SW PMU */
 	if (pmu->task_ctx_nr == perf_sw_context)
 		return;
+	/*
+	 * check default is sane, if not set then force to
+	 * default interval (1/tick)
+	 */
+	timer = pmu->hrtimer_interval_ms;
+	if (timer < 1)
+		timer = pmu->hrtimer_interval_ms = PERF_CPU_HRTIMER;
 
-	cpuctx->hrtimer_interval =
-		ns_to_ktime(NSEC_PER_MSEC * PERF_CPU_HRTIMER);
+	cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
 
 	hrtimer_init_cpu(cpu, hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hr->function = perf_cpu_hrtimer_handler;
@@ -5999,9 +6006,48 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
 	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
 }
 
+static ssize_t
+mux_interval_ms_show(struct device *dev, struct device_attribute *attr,
+		     char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->hrtimer_interval_ms);
+}
+
+static ssize_t
+mux_interval_ms_store(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	char *end = NULL;
+	int timer, cpu;
+
+	timer = kstrtoul(buf, &end, 0);
+	if (end && *end != '\n' && *end != '\0')
+		return -EINVAL;
+
+	if (timer < 1)
+		return -EINVAL;
+
+	pmu->hrtimer_interval_ms = timer;
+
+	/* update all cpuctx for this PMU */
+	for_each_possible_cpu(cpu) {
+		struct perf_cpu_context *cpuctx;
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
+		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+	}
+
+	return count;
+}
+
+#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+
 static struct device_attribute pmu_dev_attrs[] = {
-       __ATTR_RO(type),
-       __ATTR_NULL,
+	__ATTR_RO(type),
+	__ATTR_RW(mux_interval_ms),
+	__ATTR_NULL,
 };
 
 static int pmu_bus_running;
-- 
1.7.5.4

