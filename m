Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab2GCWB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab2GCWBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/10] perf, x86: Making hardware events translations available in sysfs
Date: Wed,  4 Jul 2012 00:00:42 +0200
Message-Id: <1341352848-11833-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making hardware events translations available through the sysfs.
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

The file - hw event ID mappings is:

  file                      hw event ID
  ---------------------------------------------------------------
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

Each file in 'events' directory contains term translation for the
symbolic hw event for the currently running cpu model.

  # cat /sys/devices/cpu/events/instructions
  config=0xc0

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   44 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 41db515..e7aab56 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1666,9 +1666,53 @@ static struct attribute_group x86_pmu_attr_group = {
 	.attrs = x86_pmu_attrs,
 };
 
+#define PMU_EVENTS_ATTR_CONFIG(_name, _id)				\
+static ssize_t								\
+_name##_show(struct device *dev,					\
+			   struct device_attribute *attr,		\
+			   char *page)					\
+{									\
+	u64 val = x86_pmu.event_map(_id);				\
+	BUILD_BUG_ON(_id >= PERF_COUNT_HW_MAX);				\
+	return sprintf(page, "config=0x%llx\n", val);			\
+}									\
+									\
+static struct device_attribute event_attr_##_name = __ATTR_RO(_name)
+
+PMU_EVENTS_ATTR_CONFIG(cycles, PERF_COUNT_HW_CPU_CYCLES);
+PMU_EVENTS_ATTR_CONFIG(instructions, PERF_COUNT_HW_INSTRUCTIONS);
+PMU_EVENTS_ATTR_CONFIG(cache_references, PERF_COUNT_HW_CACHE_REFERENCES);
+PMU_EVENTS_ATTR_CONFIG(cache_misses, PERF_COUNT_HW_CACHE_MISSES);
+PMU_EVENTS_ATTR_CONFIG(branch_instructions, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+PMU_EVENTS_ATTR_CONFIG(branch_misses, PERF_COUNT_HW_BRANCH_MISSES);
+PMU_EVENTS_ATTR_CONFIG(bus_cycles, PERF_COUNT_HW_BUS_CYCLES);
+PMU_EVENTS_ATTR_CONFIG(stalled_cycles_frontend, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND);
+PMU_EVENTS_ATTR_CONFIG(stalled_cycles_backend, PERF_COUNT_HW_STALLED_CYCLES_BACKEND);
+PMU_EVENTS_ATTR_CONFIG(ref_cycles, PERF_COUNT_HW_REF_CPU_CYCLES);
+
+static struct attribute *events_attr[] = {
+	&event_attr_cycles.attr,
+	&event_attr_instructions.attr,
+	&event_attr_cache_references.attr,
+	&event_attr_cache_misses.attr,
+	&event_attr_branch_instructions.attr,
+	&event_attr_branch_misses.attr,
+	&event_attr_bus_cycles.attr,
+	&event_attr_stalled_cycles_frontend.attr,
+	&event_attr_stalled_cycles_backend.attr,
+	&event_attr_ref_cycles.attr,
+	NULL,
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
1.7.10.4

