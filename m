Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1GOO35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:29:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:53067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1GOO3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267108"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/6] perf: Add interface to add general events to sysfs
Date: Fri, 15 Jul 2011 14:34:58 +0000
Message-Id: <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMU can implement ::add_events() to add its general events to sysfs.

For example,

/sys/bus/event_source/devices/uncore/events
└── cycle

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/perf_event.h |    9 +++++++
 kernel/events/core.c       |   52 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3f2711c..14337a3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -676,6 +676,14 @@ struct pmu {
 	 * for each successful ->add() during the transaction.
 	 */
 	void (*cancel_txn)		(struct pmu *pmu); /* optional */
+
+	void (*add_events)		(void);
+};
+
+struct pmu_event {
+	char name[64];
+	u64 config;
+	struct kobj_attribute attr;
 };
 
 /**
@@ -941,6 +949,7 @@ struct perf_output_handle {
 
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
+extern void perf_pmu_add_events(struct pmu *pmu, struct pmu_event events[], int count);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0567e32..9f4f463 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5571,6 +5571,8 @@ static int pmu_dev_alloc(struct pmu *pmu)
 	if (ret)
 		goto free_dev;
 
+	if (pmu->add_events)
+		pmu->add_events();
 out:
 	return ret;
 
@@ -7035,4 +7037,54 @@ struct cgroup_subsys perf_subsys = {
 	.exit		= perf_cgroup_exit,
 	.attach_task	= perf_cgroup_attach_task,
 };
+
+static ssize_t pmu_event_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct pmu_event *event = container_of(attr, struct pmu_event, attr);
+	int size;
+
+	size = sprintf(buf, "%lld\n", event->config);
+
+	return size;
+}
+
+void perf_pmu_add_events(struct pmu *pmu, struct pmu_event events[], int count)
+{
+	struct attribute_group *attr_group = NULL;
+	struct attribute **all_attrs = NULL;
+	struct kobj_attribute *event_attr;
+	struct pmu_event *event;
+	int i;
+
+	attr_group = kzalloc(sizeof(*attr_group), GFP_KERNEL);
+	if (!attr_group)
+		return;
+	attr_group->name = "events";
+
+	all_attrs = kzalloc(sizeof(*all_attrs) * (count + 1), GFP_KERNEL);
+	if (!all_attrs)
+		goto fail;
+
+	for (i = 0; i < count; i++) {
+		event = &events[i];
+		event_attr = &event->attr;
+
+		sysfs_attr_init(&event_attr->attr);
+		event_attr->attr.name = event->name;
+		event_attr->attr.mode = 0444;
+		event_attr->show = pmu_event_show;
+
+		all_attrs[i] = &event_attr->attr;
+	}
+
+	attr_group->attrs = all_attrs;
+	if (!sysfs_create_group(&pmu->dev->kobj, attr_group))
+		return;
+
+fail:
+	kfree(attr_group);
+	kfree(all_attrs);
+}
+
 #endif /* CONFIG_CGROUP_PERF */
-- 
1.7.5.1

