Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab0GVLLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:11:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:29125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759217Ab0GVLLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:11:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="537789240"
Subject: [RFC][PATCH v1 01/15] perf: core, add functions to export events
 via sysfs
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
Date: Thu, 22 Jul 2010 19:11:59 +0800
Message-ID: <1279797119.20942.82.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: core, add functions to export events via sysfs

---
 include/linux/perf_event.h |   13 +++++
 kernel/perf_event.c        |  110 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0ed315e..5e9f5c6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1057,6 +1057,9 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+
+extern struct kobject *perf_sys_create_events_dir(struct kobject *parent);
+extern int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1092,6 +1095,16 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+
+static inline int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type)
+{
+	return 0;
+}
+
+static inline struct kobject *perf_sys_create_events_dir(struct kobject *parent)
+{
+	return NULL;
+}
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 10945db..26c15a0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5888,3 +5888,113 @@ static int __init perf_event_sysfs_init(void)
 				  &perfclass_attr_group);
 }
 device_initcall(perf_event_sysfs_init);
+
+struct event_kobject {
+	struct kobject *kobj;
+
+	u64 config;
+	int type;
+
+	struct event_kobject *next;
+};
+
+static struct event_kobject *event_kobject_list;
+
+static struct event_kobject *perf_sys_find_event_kobj(struct kobject *kobj)
+{
+	struct event_kobject *event_kobj;
+
+	event_kobj = event_kobject_list;
+
+	while (event_kobj) {
+		if (kobj == event_kobj->kobj)
+			return event_kobj;
+
+		event_kobj = event_kobj->next;
+	}
+
+	return NULL;
+}
+
+#define EVENT_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+static ssize_t config_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct event_kobject *event_kobj;
+
+	event_kobj = perf_sys_find_event_kobj(kobj);
+
+	return sprintf(buf, "%llx\n", event_kobj->config);
+}
+EVENT_ATTR_RO(config);
+
+static ssize_t type_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct event_kobject *event_kobj;
+
+	event_kobj = perf_sys_find_event_kobj(kobj);
+
+	return sprintf(buf, "%d\n", event_kobj->type);
+}
+EVENT_ATTR_RO(type);
+
+static struct attribute *event_attrs[] = {
+	&config_attr.attr,
+	&type_attr.attr,
+	NULL,
+};
+
+static struct attribute_group event_attr_group = {
+	.attrs = event_attrs,
+};
+
+#define EVENTS_DIR "events"
+struct kobject *perf_sys_create_events_dir(struct kobject *parent)
+{
+	if (!parent)
+		return NULL;
+
+	return kobject_create_and_add(EVENTS_DIR, parent);
+}
+
+static DEFINE_SPINLOCK(sys_events_lock);
+
+int perf_sys_add_event(struct kobject *parent, char *name, u64 config, int type)
+{
+	struct event_kobject *event_kobj;
+	struct kobject *kobj;
+	int err;
+
+	if (!name)
+		return -1;
+
+	kobj = kobject_create_and_add(name, parent);
+	if (!kobj)
+		return -ENOMEM;
+	err = sysfs_create_group(kobj, &event_attr_group);
+	if (err) {
+		kobject_put(kobj);
+		return -ENOMEM;
+	}
+
+	event_kobj = kmalloc(sizeof(*event_kobj), GFP_KERNEL);
+	if (!event_kobj) {
+		kobject_put(kobj);
+		return -ENOMEM;
+	}
+
+	spin_lock(&sys_events_lock);
+
+	event_kobj->kobj = kobj;
+	event_kobj->config = config;
+	event_kobj->type = type;
+	event_kobj->next = event_kobject_list;
+	event_kobject_list = event_kobj;
+
+	spin_unlock(&sys_events_lock);
+
+	return 0;
+}




