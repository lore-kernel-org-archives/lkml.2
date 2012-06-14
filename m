Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2FNUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab2FNUjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:39:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/6] perf, x86: Making hardware events tranlations sysfs available
Date: Thu, 14 Jun 2012 22:38:36 +0200
Message-Id: <1339706321-8802-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making hardware events tranlations available throught the sysfs.
Adding 'events' group attribute under the sysfs x86 PMU record
with attribute/file for each hardware event:

  # ls  /sys/devices/cpu/events/
  branch_instructions
  branch_misses
  bus_cycles
  cache_misses
  cache_references
  cycles
  instructions
  ref_cycles
  stalled_cycles_backend
  stalled_cycles_frontend

The file - ID mappings is:

  file                      hw id
  ----------------------------------------------------------------
  cycles                    PERF_COUNT_HW_CPU_CYCLES
  instructions              PERF_COUNT_HW_INSTRUCTIONS
  cache_references          PERF_COUNT_HW_CACHE_REFERENCES
  cache_misses              PERF_COUNT_HW_CACHE_MISSES
  branch_instructions       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
  branch_misses             PERF_COUNT_HW_BRANCH_MISSES
  bus_cycles                PERF_COUNT_HW_BUS_CYCLES
  stalled_cycles_frontend   PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
  stalled_cycles_backend    PERF_COUNT_HW_STALLED_CYCLES_BACKEND
  ref_cycles                PERF_COUNT_HW_REF_CPU_CYCLES

Each attribute/file contains HW ID event translation for the currently
running CPU model

  # cat /sys/devices/cpu/events/instructions
  0xc0

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   44 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 53cc997..aaa8d85 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1666,9 +1666,53 @@ static struct attribute_group x86_pmu_attr_group = {
 	.attrs = x86_pmu_attrs,
 };
 
+#define PMU_EVENTS_ATTR(_name, _id)					\
+static ssize_t								\
+_name##_show(struct device *dev,					\
+                               struct device_attribute *attr,		\
+                               char *page)				\
+{									\
+	u64 val = x86_pmu.event_map(_id);				\
+	BUILD_BUG_ON(_id >= PERF_COUNT_HW_MAX);				\
+	return sprintf(page, "0x%llx\n", val);				\
+}									\
+									\
+static struct device_attribute event_attr_##_name = __ATTR_RO(_name)
+
+PMU_EVENTS_ATTR(cycles, PERF_COUNT_HW_CPU_CYCLES);
+PMU_EVENTS_ATTR(instructions, PERF_COUNT_HW_INSTRUCTIONS);
+PMU_EVENTS_ATTR(cache_references, PERF_COUNT_HW_CACHE_REFERENCES);
+PMU_EVENTS_ATTR(cache_misses, PERF_COUNT_HW_CACHE_MISSES);
+PMU_EVENTS_ATTR(branch_instructions, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+PMU_EVENTS_ATTR(branch_misses, PERF_COUNT_HW_BRANCH_MISSES);
+PMU_EVENTS_ATTR(bus_cycles, PERF_COUNT_HW_BUS_CYCLES);
+PMU_EVENTS_ATTR(stalled_cycles_frontend, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND);
+PMU_EVENTS_ATTR(stalled_cycles_backend, PERF_COUNT_HW_STALLED_CYCLES_BACKEND);
+PMU_EVENTS_ATTR(ref_cycles, PERF_COUNT_HW_REF_CPU_CYCLES);
+
+static struct attribute *events_attr[] = {
+        &event_attr_cycles.attr,
+        &event_attr_instructions.attr,
+        &event_attr_cache_references.attr,
+        &event_attr_cache_misses.attr,
+        &event_attr_branch_instructions.attr,
+        &event_attr_branch_misses.attr,
+        &event_attr_bus_cycles.attr,
+        &event_attr_stalled_cycles_frontend.attr,
+        &event_attr_stalled_cycles_backend.attr,
+        &event_attr_ref_cycles.attr,
+        NULL,
+};
+
+static struct attribute_group x86_pmu_events_group = {
+	.name = "events",
+	.attrs = events_attr,
+};
+
 static const struct attribute_group *x86_pmu_attr_groups[] = {
 	&x86_pmu_attr_group,
 	&x86_pmu_format_group,
+	&x86_pmu_events_group,
 	NULL,
 };
 
-- 
1.7.7.6

