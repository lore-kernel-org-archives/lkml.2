Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0ERRpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:45:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:63351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab0ERRpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:45:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="799593248"
Subject: [RFC][PATCH v2 02/11] perf: core, add pmu register and lookup
 functions
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
Date: Wed, 19 May 2010 01:45:02 +0000
Message-Id: <1274233502.3036.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And add new api pmu::init_event

Changes log
v2: Use RCU for synchronization (Peter Zijlstra)
v1: add pmu register and lookup functions

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/perf_event.h |   11 ++++++
 kernel/perf_event.c        |   73 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6c01c5f..40809f5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -549,10 +549,16 @@ struct perf_event;
 
 #define PERF_EVENT_TXN_STARTED 1
 
+#define PMU_TYPE_CPU 0
+#define PMU_TYPE_NODE 1
+
 /**
  * struct pmu - generic performance monitoring unit
  */
 struct pmu {
+	int				id;
+	struct list_head		entry;
+
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
 	int (*start)			(struct perf_event *event);
@@ -569,6 +575,8 @@ struct pmu {
 	void (*start_txn)	(struct pmu *pmu);
 	void (*cancel_txn)	(struct pmu *pmu);
 	int  (*commit_txn)	(struct pmu *pmu);
+
+	int  (*init_event)	(struct perf_event *event);
 };
 
 /**
@@ -1013,6 +1021,9 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+
+extern int perf_event_register_pmu(struct pmu *pmu);
+extern void perf_event_unregister_pmu(int id);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ba7a37a..31b032b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -40,6 +40,12 @@
  */
 static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
 
+/*
+ * The list of multiple hw pmus
+ */
+static struct list_head pmus;
+static DEFINE_SPINLOCK(pmus_lock);
+
 int perf_max_events __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
@@ -4678,6 +4684,34 @@ static struct pmu *sw_perf_event_init(struct perf_event *event)
 	return pmu;
 }
 
+static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
+{
+	struct pmu *pmu = NULL;
+	int pmu_id = event->attr.type;
+
+	switch (event->attr.type) {
+		case PERF_TYPE_HARDWARE:
+		case PERF_TYPE_HW_CACHE:
+		case PERF_TYPE_RAW:
+			pmu_id = PMU_TYPE_CPU;
+			break;
+
+		/* TBD: will add other pmu type later */
+
+		default:
+			return NULL;
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (pmu->id == pmu_id)
+			break;
+	}
+	rcu_read_unlock();
+
+	return pmu;
+}
+
 /*
  * Allocate and initialize a event structure
  */
@@ -5635,6 +5669,8 @@ void __init perf_event_init(void)
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
 			(void *)(long)smp_processor_id());
 	register_cpu_notifier(&perf_cpu_nb);
+
+	INIT_LIST_HEAD(&pmus);
 }
 
 static ssize_t perf_show_reserve_percpu(struct sysdev_class *class,
@@ -5734,3 +5770,40 @@ static int __init perf_event_sysfs_init(void)
 				  &perfclass_attr_group);
 }
 device_initcall(perf_event_sysfs_init);
+
+int perf_event_register_pmu(struct pmu *pmu)
+{
+	struct pmu *tmp;
+	int ret = 1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tmp, &pmus, entry) {
+		if (tmp->id == pmu->id) {
+			ret = 0;
+			goto err;
+		}
+	}
+	rcu_read_unlock();
+
+	spin_lock(&pmus_lock);
+	list_add_tail_rcu(&pmu->entry, &pmus);
+	spin_unlock(&pmus_lock);
+
+err:
+	return ret;
+}
+
+void perf_event_unregister_pmu(int id)
+{
+	struct pmu *tmp = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tmp, &pmus, entry) {
+		if (tmp->id == id)
+			break;
+	}
+	rcu_read_unlock();
+
+	if (tmp)
+		list_del_rcu(&tmp->entry);
+}




