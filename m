Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab0GVLMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:12:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:58239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759234Ab0GVLM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:12:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="303088919"
Subject: [RFC][PATCH v1 03/15] perf: export software events via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:12:42 +0800
Message-ID: <1279797162.20942.84.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Software events are exported under /sys/kernel/events/, for example

/sys/kernel/events/
|-- alignment-faults
|   |-- config
|   `-- type
|-- context-switches
|   |-- config
|   `-- type
|-- cpu-clock
|   |-- config
|   `-- type
|-- cpu-migrations
|   |-- config
|   `-- type
|-- emulation-faults
|   |-- config
|   `-- type
|-- major-faults
|   |-- config
|   `-- type
|-- minor-faults
|   |-- config
|   `-- type
|-- page-faults
|   |-- config
|   `-- type
....
---
 kernel/perf_event.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1f51ab9..21c359d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4383,6 +4383,22 @@ static int perf_swevent_init(struct perf_event *event)
 	return 0;
 }
 
+struct kobject *sys_kernel_events_kobj;
+static char *perf_sw_event_name(int id);
+
+static void perf_swevent_export(void)
+{
+	int i;
+
+	if (!sys_kernel_events_kobj)
+		return;
+
+	for (i = PERF_COUNT_SW_PAGE_FAULTS; i < PERF_COUNT_SW_MAX; i++) {
+		perf_sys_add_event(sys_kernel_events_kobj, perf_sw_event_name(i),
+			i, PERF_TYPE_SOFTWARE);
+	}
+}
+
 static struct pmu perf_swevent = {
 	.event_init	= perf_swevent_init,
 	.add		= perf_swevent_add,
@@ -4390,6 +4406,7 @@ static struct pmu perf_swevent = {
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
+	.export_events	= perf_swevent_export,
 };
 
 #ifdef CONFIG_EVENT_TRACING
@@ -4662,6 +4679,16 @@ static int cpu_clock_event_init(struct perf_event *event)
 	return 0;
 }
 
+static void cpu_clock_event_export(void)
+{
+	if (!sys_kernel_events_kobj)
+		return;
+
+	perf_sys_add_event(sys_kernel_events_kobj,
+		perf_sw_event_name(PERF_COUNT_SW_CPU_CLOCK),
+		PERF_COUNT_SW_CPU_CLOCK, PERF_TYPE_SOFTWARE);
+}
+
 static struct pmu perf_cpu_clock = {
 	.event_init	= cpu_clock_event_init,
 	.add		= cpu_clock_event_add,
@@ -4669,6 +4696,7 @@ static struct pmu perf_cpu_clock = {
 	.start		= cpu_clock_event_start,
 	.stop		= cpu_clock_event_stop,
 	.read		= cpu_clock_event_read,
+	.export_events	= cpu_clock_event_export,
 };
 
 /*
@@ -4737,6 +4765,16 @@ static int task_clock_event_init(struct perf_event *event)
 	return 0;
 }
 
+static void task_clock_event_export(void)
+{
+	if (!sys_kernel_events_kobj)
+		return;
+
+	perf_sys_add_event(sys_kernel_events_kobj,
+		perf_sw_event_name(PERF_COUNT_SW_TASK_CLOCK),
+		PERF_COUNT_SW_TASK_CLOCK, PERF_TYPE_SOFTWARE);
+}
+
 static struct pmu perf_task_clock = {
 	.event_init	= task_clock_event_init,
 	.add		= task_clock_event_add,
@@ -4744,6 +4782,7 @@ static struct pmu perf_task_clock = {
 	.start		= task_clock_event_start,
 	.stop		= task_clock_event_stop,
 	.read		= task_clock_event_read,
+	.export_events	= task_clock_event_export,
 };
 
 static LIST_HEAD(pmus);
@@ -5887,6 +5926,8 @@ static int __init perf_event_sysfs_init(void)
 	struct pmu *pmu = NULL;
 	int idx;
 
+	sys_kernel_events_kobj = perf_sys_create_events_dir(kernel_kobj);
+
 	idx = srcu_read_lock(&pmus_srcu);
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		if (pmu->export_events)
@@ -6033,6 +6074,18 @@ static char *hw_cache_result[] = {
 	"misses",
 };
 
+static char *sw_event_names[] = {
+	"cpu-clock",
+	"task-clock",
+	"page-faults",
+	"minor-faults",
+	"major-faults",
+	"context-switches",
+	"cpu-migrations",
+	"alignment-faults",
+	"emulation-faults",
+};
+
 char *perf_hw_event_name(int id)
 {
 	if (id >= ARRAY_SIZE(hw_event_names))
@@ -6051,3 +6104,11 @@ char *perf_hw_cache_event_name(u8 cache_type, u8 cache_op, u8 cache_result)
 
 	return name;
 }
+
+static char *perf_sw_event_name(int id)
+{
+	if (id >= ARRAY_SIZE(sw_event_names))
+		return NULL;
+
+	return sw_event_names[id];
+}



