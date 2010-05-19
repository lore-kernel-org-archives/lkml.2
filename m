Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab0ERRqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:46:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:41163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab0ERRqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:46:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="568316709"
Subject: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:46:42 +0000
Message-Id: <1274233602.3036.84.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now only exports cpu hardware events.

For each PMU, there are 2 sysfs dirs: event_source and events.

For example,
/sys/devices/system/cpu/event_source/
/sys/devices/system/cpu/events/

$ tree /sys/devices/system/cpu/event_source/
/sys/devices/system/cpu/event_source/
`-- id

$ tree /sys/devices/system/cpu/events/
/sys/devices/system/cpu/events/
|-- L1-dcache-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- LLC-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- branch-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- branches
|   |-- event_source -> ../../event_source
|   `-- id
|-- bus-cycles
|   |-- event_source -> ../../event_source
|   `-- id
|-- cache-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- cache-references
|   |-- event_source -> ../../event_source
|   `-- id
|-- cycles
|   |-- event_source -> ../../event_source
|   `-- id
|-- dTLB-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- dTLB-store-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- iTLB-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- iTLB-load-refs
|   |-- event_source -> ../../event_source
|   `-- id
`-- instructions
    |-- event_source -> ../../event_source
    `-- id

Signed-off-by: Lin Ming <ming.m.lin@intel.com> 
---
 drivers/base/node.c        |    3 +-
 include/linux/node.h       |    2 +
 include/linux/perf_event.h |   10 +++
 kernel/perf_event.c        |  169 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 183 insertions(+), 1 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 057979a..3b77585 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -19,10 +19,11 @@
 
 static struct sysdev_class_attribute *node_state_attrs[];
 
-static struct sysdev_class node_class = {
+struct sysdev_class node_class = {
 	.name = "node",
 	.attrs = node_state_attrs,
 };
+EXPORT_SYMBOL(node_class);
 

 static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
diff --git a/include/linux/node.h b/include/linux/node.h
index 06292da..43e4422 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -50,6 +50,8 @@ extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
 extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
 					 node_registration_func_t unregister);
 #endif
+
+extern struct sysdev_class node_class;
 #else
 static inline int register_one_node(int nid)
 {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ad2aea3..ef519d2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -552,12 +552,18 @@ struct perf_event;
 #define PMU_TYPE_CPU 0
 #define PMU_TYPE_NODE 1
 
+struct perf_event_kobject {
+	struct kobject			kobj;
+	u64				id;
+};
+
 /**
  * struct pmu - generic performance monitoring unit
  */
 struct pmu {
 	int				id;
 	struct list_head		entry;
+	struct kobject			kobj;
 
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
@@ -577,6 +583,7 @@ struct pmu {
 	int  (*commit_txn)	(struct pmu *pmu);
 
 	int  (*init_event)	(struct perf_event *event);
+	int  (*register_events)	(struct pmu *pmu, struct kobject *events_kobj);
 };
 
 /**
@@ -1022,6 +1029,9 @@ extern void perf_event_disable(struct perf_event *event);
 
 extern int perf_event_register_pmu(struct pmu *pmu);
 extern void perf_event_unregister_pmu(int id);
+char *perf_hw_event_name(int id);
+char *perf_hw_cache_event_name(u8 type, u8 op, u8 result);
+extern struct kobj_type event_ktype;
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 44e35ad..f6df0f8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/node.h>
 #include <linux/smp.h>
 #include <linux/file.h>
 #include <linux/poll.h>
@@ -5767,6 +5768,174 @@ static int __init perf_event_sysfs_init(void)
 }
 device_initcall(perf_event_sysfs_init);
 
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
+
+static ssize_t event_show(struct kobject *kobj,
+		struct attribute *attr, char *buf)
+{
+	int n;
+	struct perf_event_kobject *event_kobj =
+		container_of(kobj, struct perf_event_kobject, kobj);
+
+	n = sprintf(buf, "0x%llx\n", event_kobj->id);
+
+	return n;
+}
+
+static const struct sysfs_ops event_sysfs_ops = {
+	.show	= event_show,
+	.store	= NULL,
+};
+
+struct kobj_type event_ktype = {
+	.sysfs_ops	= &event_sysfs_ops,
+};
+
+static ssize_t event_source_show(struct kobject *kobj,
+		struct attribute *attr, char *buf)
+{
+	int n;
+	struct pmu *pmu = container_of(kobj, struct pmu, kobj);
+
+	n = sprintf(buf, "%d\n", pmu->id);
+
+	return n;
+}
+
+static const struct sysfs_ops event_source_sysfs_ops = {
+	.show	= event_source_show,
+	.store	= NULL,
+};
+
+static struct kobj_type event_source_ktype = {
+	.sysfs_ops	= &event_source_sysfs_ops,
+};
+
+static struct attribute event_source_id_attr = {
+	.name = "id",
+	.mode = 0444,
+};
+
+static int __init perf_pmu_sysfs_init(void)
+{
+	struct pmu *pmu;
+	struct kobject *parent_kobj, *events_kobj;
+	int err = 0;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		switch (pmu->id) {
+		case PMU_TYPE_CPU:
+			parent_kobj = &cpu_sysdev_class.kset.kobj;
+			break;
+#ifdef CONFIG_NUMA
+		case PMU_TYPE_NODE:
+			parent_kobj = &node_class.kset.kobj;
+			break;
+#endif
+
+		/* TBD: add other pmu types later */
+		default:
+			parent_kobj = NULL;
+			break;
+		}
+
+		if (!parent_kobj)
+			continue;
+
+		/*
+		 * Create event_source sysfs dir, for example
+		 * /sys/devices/system/cpu/event_source
+		 */
+		err = kobject_init_and_add(&pmu->kobj,
+			&event_source_ktype, parent_kobj, "event_source");
+		if (err)
+			break;
+
+		/*
+		 * Create event_source/id attribute, for example
+		 * /sys/devices/system/cpu/event_source/id
+		 */
+		err = sysfs_create_file(&pmu->kobj, &event_source_id_attr);
+		if (err)
+			break;
+
+		/*
+		 * Create events sysfs dir, for example
+		 * /sys/devices/system/cpu/events
+		 */
+		events_kobj = kobject_create_and_add("events", parent_kobj);
+		if (!events_kobj) {
+			err = -ENOMEM;
+			break;
+		}
+
+		/*
+		 * Register all events under events dir, for example
+		 * /sys/devices/system/cpu/events/cycles
+		 * /sys/devices/system/cpu/events/instructions
+		 */
+		if (pmu->register_events) {
+			err = pmu->register_events(pmu, events_kobj);
+			if (err)
+				break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return err;
+}
+device_initcall(perf_pmu_sysfs_init);
+
 int perf_event_register_pmu(struct pmu *pmu)
 {
 	struct pmu *tmp;





