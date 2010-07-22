Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab0GVLMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:12:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:2810 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759220Ab0GVLMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:12:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="303089000"
Subject: [RFC][PATCH v1 04/15] perf: export tracepoint events via sysfs:
 sched, raw_syscalls etc.
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
Date: Thu, 22 Jul 2010 19:12:58 +0800
Message-ID: <1279797179.20942.85.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below tracepoint events are exported under /sys/kernel/events/.
sched, raw_syscalls, irq, timer, signal, workqueue, lock and bkl

For example,
/sys/kernel/events/
|-- hrtimer_cancel
|   |-- config
|   `-- type
|-- hrtimer_expire_entry
|   |-- config
|   `-- type
|-- hrtimer_expire_exit
|   |-- config
|   `-- type
|-- hrtimer_init
|   |-- config
|   `-- type
|-- hrtimer_start
|   |-- config
|   `-- type
|-- irq_handler_entry
|   |-- config
|   `-- type
|-- irq_handler_exit
|   |-- config
|   `-- type
|-- itimer_expire
|   |-- config
|   `-- type
|-- itimer_state
|   |-- config
|   `-- type
|-- lock_kernel
|   |-- config
|   `-- type
|-- sched_kthread_stop
|   |-- config
|   `-- type
|-- sched_kthread_stop_ret
|   |-- config
|   `-- type
|-- sched_migrate_task
|   |-- config
|   `-- type
|-- sched_process_exit
|   |-- config
|   `-- type
|-- sched_process_fork
|   |-- config
|   `-- type
|-- sched_process_free
|   |-- config
|   `-- type
|-- sched_process_wait
|   |-- config
|   `-- type
|-- sched_stat_iowait
|   |-- config
|   `-- type
|-- sched_stat_runtime
|   |-- config
|   `-- type
|-- sched_stat_sleep
|   |-- config
|   `-- type
|-- sched_stat_wait
|   |-- config
|   `-- type
|-- sched_switch
|   |-- config
|   `-- type
|-- sched_wait_task
|   |-- config
|   `-- type
|-- sched_wakeup
|   |-- config
|   `-- type
|-- sched_wakeup_new
|   |-- config
|   `-- type
|-- signal_deliver
|   |-- config
|   `-- type
|-- signal_generate
|   |-- config
|   `-- type
|-- signal_lose_info
|   |-- config
|   `-- type
|-- signal_overflow_fail
|   |-- config
|   `-- type
|-- softirq_entry
|   |-- config
|   `-- type
|-- softirq_exit
|   |-- config
|   `-- type
|-- sys_enter
|   |-- config
|   `-- type
|-- sys_exit
|   |-- config
|   `-- type
|-- timer_cancel
|   |-- config
|   `-- type
|-- timer_expire_entry
|   |-- config
|   `-- type
|-- timer_expire_exit
|   |-- config
|   `-- type
|-- timer_init
|   |-- config
|   `-- type
|-- timer_start
|   |-- config
|   `-- type
|-- unlock_kernel
|   |-- config
|   `-- type
|-- workqueue_creation
|   |-- config
|   `-- type
|-- workqueue_destruction
|   |-- config
|   `-- type
|-- workqueue_execution
|   |-- config
|   `-- type
`-- workqueue_insertion
    |-- config
    `-- type


---
 include/linux/perf_event.h |    4 +++
 kernel/perf_event.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fb2ec23..c24197d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1062,6 +1062,8 @@ extern void perf_event_disable(struct perf_event *event);
 
 extern struct kobject *perf_sys_create_events_dir(struct kobject *parent);
 extern int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type);
+extern void perf_sys_add_tp_events(struct kobject *kobj, char *tp_system);
+extern void perf_sys_add_tp(struct kobject *kobj, char *tp_system);
 extern char *perf_hw_event_name(int id);
 extern char *perf_hw_cache_event_name(u8 type, u8 op, u8 result);
 #else
@@ -1108,6 +1110,8 @@ static inline struct kobject *perf_sys_create_events_dir(struct kobject *parent)
 {
 	return NULL;
 }
+static inline void perf_sys_add_tp_events(struct kobject *kobj, char *tp_system) { }
+static inline void perf_sys_add_tp(struct kobject *kobj, char *tp_system) { }
 static inline char *perf_hw_event_name(int id) { return NULL; }
 static inline char *perf_hw_cache_event_name(u8 type, u8 op, u8 result) { return NULL; }
 #endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 21c359d..554311b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5921,6 +5921,26 @@ static struct attribute_group perfclass_attr_group = {
 	.name			= "perf_events",
 };
 
+/*
+ * tracepoint events: sched, raw_syscalls, irq, timer, signal,
+ * workqueue, lock and bkl are exported to
+ * /sys/kernel/events/
+ */
+static void perf_sys_add_kernel_events(void)
+{
+	if (!sys_kernel_events_kobj)
+		return;
+
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "raw_syscalls");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "sched");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "irq");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "timer");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "signal");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "workqueue");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "lock");
+	perf_sys_add_tp_events(sys_kernel_events_kobj, "bkl");
+}
+
 static int __init perf_event_sysfs_init(void)
 {
 	struct pmu *pmu = NULL;
@@ -5928,6 +5948,8 @@ static int __init perf_event_sysfs_init(void)
 
 	sys_kernel_events_kobj = perf_sys_create_events_dir(kernel_kobj);
 
+	perf_sys_add_kernel_events();
+
 	idx = srcu_read_lock(&pmus_srcu);
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		if (pmu->export_events)
@@ -6044,6 +6066,34 @@ int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type)
 	return 0;
 }
 
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+
+void perf_sys_add_tp_events(struct kobject *events_kobj, char *tp_system)
+{
+	struct ftrace_event_call *call;
+
+	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
+		if (call->class->system && !strcmp(call->class->system, tp_system)) {
+			perf_sys_add_event(events_kobj, call->name, call->event.type,
+				PERF_TYPE_TRACEPOINT);
+		}
+	}
+}
+
+void perf_sys_add_tp(struct kobject *parent, char *tp_system)
+{
+	struct kobject *events_kobj;
+
+	events_kobj = perf_sys_create_events_dir(parent);
+	perf_sys_add_tp_events(events_kobj, tp_system);
+}
+
 static char *hw_event_names[] = {
 	"cycles",
 	"instructions",




