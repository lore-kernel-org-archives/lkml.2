Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab0GVLMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:12:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:11266 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759003Ab0GVLMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="588614646"
Subject: [RFC][PATCH v1 02/15] perf: export generic hardware events via
 sysfs
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
Date: Thu, 22 Jul 2010 19:12:22 +0800
Message-ID: <1279797142.20942.83.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic hardware events are exported under
/sys/devices/system/cpu/cpu0...N/events, for example

/sys/devices/system/cpu/cpu0/events
|-- L1-dcache-load-misses
|   |-- config
|   `-- type
|-- LLC-load-misses
|   |-- config
|   `-- type
|-- branch-misses
|   |-- config
|   `-- type
|-- branches
|   |-- config
|   `-- type
|-- bus-cycles
|   |-- config
|   `-- type
|-- cache-misses
|   |-- config
|   `-- type
|-- cache-references
|   |-- config
|   `-- type
|-- cycles
|   |-- config
|   `-- type
|-- dTLB-load-misses
|   |-- config
|   `-- type
|-- dTLB-store-misses
|   |-- config
|   `-- type
|-- iTLB-load-misses
|   |-- config
|   `-- type
|-- iTLB-load-refs
|   |-- config
|   `-- type
`-- instructions
    |-- config
    `-- type

---
 arch/x86/kernel/cpu/perf_event.c |   55 +++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h       |    7 ++++-
 kernel/perf_event.c              |   59 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2712414..2e66c35 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1328,6 +1328,59 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
+static void export_events(struct kobject *cpu_kobj)
+{
+	struct kobject *events_kobj;
+	int type, op, i;
+	int cache_id;
+	int err = 0;
+
+	if (!cpu_kobj)
+		return;
+
+	events_kobj = perf_sys_create_events_dir(cpu_kobj);
+	if (!events_kobj)
+		return;
+
+	for (i = PERF_COUNT_HW_CPU_CYCLES; i < PERF_COUNT_HW_MAX; i++) {
+		perf_sys_add_event(events_kobj, perf_hw_event_name(i),
+			i, PERF_TYPE_HARDWARE);
+	}
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+
+				cache_id = hw_cache_event_ids[type][op][i];
+				if (cache_id <= 0)
+					continue;
+
+				err = perf_sys_add_event(events_kobj,
+					perf_hw_cache_event_name(type, op, i),
+					cache_id, PERF_TYPE_HW_CACHE);
+				if (err)
+					break;
+			}
+		}
+	}
+}
+
+static void x86_pmu_export_events(void)
+{
+	struct sys_device *cpu_dev;
+	int cpu;
+
+	/* /sys/devices/system/cpu/cpu0...cpuN/events/ */
+
+	for_each_online_cpu(cpu) {
+		cpu_dev = get_cpu_sysdev(cpu);
+		if (!cpu_dev)
+			break;
+
+		export_events(&cpu_dev->kobj);
+	}
+}
+
 void __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
@@ -1600,6 +1653,8 @@ static struct pmu pmu = {
 	.start_txn	= x86_pmu_start_txn,
 	.cancel_txn	= x86_pmu_cancel_txn,
 	.commit_txn	= x86_pmu_commit_txn,
+
+	.export_events	= x86_pmu_export_events,
 };
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5e9f5c6..fb2ec23 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -630,6 +630,8 @@ struct pmu {
 	 * for each successfull ->add() during the transaction.
 	 */
 	void (*cancel_txn)	(struct pmu *pmu); /* optional */
+
+	void (*export_events)	(void);
 };
 
 /**
@@ -1060,6 +1062,8 @@ extern void perf_event_disable(struct perf_event *event);
 
 extern struct kobject *perf_sys_create_events_dir(struct kobject *parent);
 extern int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type);
+extern char *perf_hw_event_name(int id);
+extern char *perf_hw_cache_event_name(u8 type, u8 op, u8 result);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1100,11 +1104,12 @@ static inline int perf_sys_add_event(struct kobject *parent, char *name, u64 con
 {
 	return 0;
 }
-
 static inline struct kobject *perf_sys_create_events_dir(struct kobject *parent)
 {
 	return NULL;
 }
+static inline char *perf_hw_event_name(int id) { return NULL; }
+static inline char *perf_hw_cache_event_name(u8 type, u8 op, u8 result) { return NULL; }
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ae95633..1f51ab9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5884,6 +5884,16 @@ static struct attribute_group perfclass_attr_group = {
 
 static int __init perf_event_sysfs_init(void)
 {
+	struct pmu *pmu = NULL;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (pmu->export_events)
+			pmu->export_events();
+	}
+	srcu_read_unlock(&pmus_srcu, idx);
+
 	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
 				  &perfclass_attr_group);
 }
@@ -5992,3 +6002,52 @@ int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type)
 
 	return 0;
 }
+
+static char *hw_event_names[] = {
+	"cycles",
+	"instructions",
+	"cache-references",
+	"cache-misses",
+	"branches",
+	"branch-misses",
+	"bus-cycles",
+};
+
+static char *hw_cache[] = {
+	"L1-dcache",
+	"L1-icache",
+	"LLC",
+	"dTLB",
+	"iTLB",
+	"branch",
+};
+
+static char *hw_cache_op[] = {
+	"load",
+	"store",
+	"prefetch",
+};
+
+static char *hw_cache_result[] = {
+	"refs",
+	"misses",
+};
+
+char *perf_hw_event_name(int id)
+{
+	if (id >= ARRAY_SIZE(hw_event_names))
+		return NULL;
+
+	return hw_event_names[id];
+}
+
+char *perf_hw_cache_event_name(u8 cache_type, u8 cache_op, u8 cache_result)
+{
+	static char name[50];
+
+	sprintf(name, "%s-%s-%s", hw_cache[cache_type],
+		hw_cache_op[cache_op],
+		hw_cache_result[cache_result]);
+
+	return name;
+}



