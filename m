Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2JRXUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:20:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:3930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504Ab2JRXUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:20:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="207876597"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/34] perf, x86: Report the arch perfmon events in sysfs
Date: Thu, 18 Oct 2012 16:19:35 -0700
Message-Id: <1350602382-12771-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Report all the supported arch perfmon events as event aliases in
/sys/devices/cpu/...

This is needed to use the TSX intx,intx_cp attributes with
symbolic events, at least for these basic events.

Currently cpu/instructions/ doesn't work because instructions
is also a generic event. It works for all events which are not
the same as generic events though.

Probably needs to be fixed in the perf events parser.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    7 ++++
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |   56 ++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b0f4edd..a5a5bef 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1309,6 +1309,11 @@ static struct attribute_group x86_pmu_format_group = {
 	.attrs = NULL,
 };
 
+static struct attribute_group x86_pmu_events_group = {
+	.name = "events",
+	.attrs = NULL,
+};
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1354,6 +1359,7 @@ static int __init init_hw_perf_events(void)
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
+	x86_pmu_events_group.attrs = x86_pmu.events_attrs;
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
@@ -1646,6 +1652,7 @@ static struct attribute_group x86_pmu_attr_group = {
 static const struct attribute_group *x86_pmu_attr_groups[] = {
 	&x86_pmu_attr_group,
 	&x86_pmu_format_group,
+	&x86_pmu_events_group,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 7b43503..d3b3bb7 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -358,6 +358,7 @@ struct x86_pmu {
 	 */
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
+	struct attribute **events_attrs;
 
 	/*
 	 * CPU Hotplug hooks
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 274ed2c..878814a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -34,6 +34,18 @@ static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
 	[PERF_COUNT_HW_REF_CPU_CYCLES]		= 0x0300, /* pseudo-encoding */
 };
 
+static const char *intel_perfmon_names[PERF_COUNT_HW_MAX] __read_mostly =
+{
+	[PERF_COUNT_HW_CPU_CYCLES]		= "cycles",
+	[PERF_COUNT_HW_INSTRUCTIONS]		= "instructions",
+	[PERF_COUNT_HW_CACHE_REFERENCES]	= "cache-references",
+	[PERF_COUNT_HW_CACHE_MISSES]		= "cache-misses",
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= "branches",
+	[PERF_COUNT_HW_BRANCH_MISSES]		= "branch-misses",
+	[PERF_COUNT_HW_BUS_CYCLES]		= "bus-cycles",
+	[PERF_COUNT_HW_REF_CPU_CYCLES]		= "ref-cycles"
+};
+
 static struct event_constraint intel_core_event_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
@@ -1987,6 +1999,48 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+static struct attribute *intel_arch_events[PERF_COUNT_HW_MAX + 1] __read_mostly;
+
+struct event_attribute {
+	struct device_attribute		attr;
+	u64				config;
+};
+
+static struct event_attribute intel_arch_event_attr[PERF_COUNT_HW_MAX];
+
+static ssize_t show_event(struct device *dev,
+			  struct device_attribute *attr,
+			  char *page)
+{
+	struct event_attribute *e = container_of(attr, struct event_attribute, attr);
+
+	return sprintf(page, "event=%#llx,umask=%#llx",
+		       e->config & 0xff,
+		       (e->config >> 8) & 0xff);
+}
+
+static __init void intel_gen_arch_events(void)
+{
+	int j, i;
+
+	j = 0;
+	for_each_clear_bit(i, x86_pmu.events_mask, ARRAY_SIZE(intel_arch_events_map)) {
+		struct event_attribute *e = intel_arch_event_attr + j;
+		struct device_attribute *d = &e->attr;
+		struct attribute *a = &d->attr;
+		int id = intel_arch_events_map[i].id;
+
+		e->config = intel_perfmon_event_map[id];
+		intel_arch_events[j] = a;
+		a->name = intel_perfmon_names[id];
+		a->mode = 0444;
+		d->show = show_event;
+		j++;
+	}
+	intel_arch_events[j] = NULL;
+	x86_pmu.events_attrs = intel_arch_events;
+}
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2032,6 +2086,8 @@ __init int intel_pmu_init(void)
 
 	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
 
+	intel_gen_arch_events();
+
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
-- 
1.7.7.6

