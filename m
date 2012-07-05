Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2GENCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:02:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42775 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GENCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <CACV3sb+aadXJYu7_JUedCodgQmF8d1q7OxSVoz=vwfc+Ow_caA@mail.gmail.com>
References: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com>
	<1341476877.7709.0.camel@twins>
	<CACV3sb+aadXJYu7_JUedCodgQmF8d1q7OxSVoz=vwfc+Ow_caA@mail.gmail.com>
Date: Thu, 5 Jul 2012 21:02:05 +0800
Message-ID: <CACV3sbLJpv2KSSkrRRDVuJ6xtJOSwCKaJfhO1wMF6DgAU9eCBw@mail.gmail.com>
Subject: Re: [PATCH] perf: add /proc/perf_events file for dump perf events info
From: Jovi Zhang <bookjovi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 4:40 PM, Jovi Zhang <bookjovi@gmail.com> wrote:
>
>
>
> On Thu, Jul 5, 2012 at 4:27 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> On Thu, 2012-07-05 at 16:23 +0800, Jovi Zhang wrote:
>> > This new /proc/perf_events file is used for real time dump all
>> > perf events info in whole system wide machine, this patch also add
>> > a new field perf_entry in struct perf_event, for connect to
>> > global list perf_events_list.
>>
>> This fails to mention why you'd want something like that.
>
>
> Watch all perf events in system wide can be very useful for perf subsystem issue handling,
> to know which perf event is active in system,
> perf event is a resouce, it would like to be managed easily for user, with more visable, like /proc/timer, etc...
>
> .jovi


Ping...

Sorry that initial patch format corrupted because gmail client problem.
below patch with more readable format.

 From 91fbcca37a2c9979083f4b9a6fa9c1875fc2886f Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Fri, 6 Jul 2012 00:05:40 +0800
Subject: [PATCH] perf: add /proc/perf_events file for dump perf events info

This new /proc/perf_events file is used for real time dump all
perf events info in whole system wide machine, this patch also add
a new field perf_entry in struct perf_event, for connect to
global list perf_events_list.

$./perf record -e mem:0xc09b7020 -g -a -d
$cat /proc/perf_events

1:
pmu:		tracepoint
state:		ACTIVE
attach_state:	ATTACH_CONTEXT ATTACH_GROUP
oncpu:		0
cpu:		0
count:		71
id:		18
attr.type:		TRACEPOINT
attr.config:		927
attr.sample_type:	IP TID TIME CPU RAW
attr.bp_type:	EMPTY
attr.bp_addr:	0x0
attr.bp_len:	0
attr flag:		disabled(1) inherit(1) pinned(0) exclusive(0)
exclude_user(0) exclude_kernel(0) exclude_hv(0) exclude_idle(0)
mmap(1) comm(1) freq(0) inherit_stat(0) enable_on_exec(0) task(0)
watermark(0) precise_ip(0) mmap_data(0) sample_id_all(1)
exclude_host(0) exclude_guest(1)

2:
pmu:		tracepoint
state:		ACTIVE
attach_state:	ATTACH_CONTEXT ATTACH_GROUP
oncpu:		1
cpu:		1
count:		178
id:		19
attr.type:		TRACEPOINT
attr.config:		927
attr.sample_type:	IP TID TIME CPU RAW
attr.bp_type:	EMPTY
attr.bp_addr:	0x0
attr.bp_len:	0
attr flag:		disabled(1) inherit(1) pinned(0) exclusive(0)
exclude_user(0) exclude_kernel(0) exclude_hv(0) exclude_idle(0)
mmap(1) comm(1) freq(0) inherit_stat(0) enable_on_exec(0) task(0)
watermark(0) precise_ip(0) mmap_data(0) sample_id_all(1)
exclude_host(0) exclude_guest(1)

...

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 include/linux/perf_event.h       |    1 +
 kernel/events/Makefile           |    1 +
 kernel/events/core.c             |   14 +++
 kernel/events/proc_perf_events.c |  204 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 220 insertions(+)
 create mode 100644 kernel/events/proc_perf_events.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45db49f..7129558 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -871,6 +871,7 @@ struct perf_event {
 	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	struct list_head		perf_entry; /* used for connect with all perf_event*/
 	struct hlist_node		hlist_entry;
 	int			nr_siblings;
 	int			group_flags;
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..8b34070 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -6,4 +6,5 @@ obj-y := core.o ring_buffer.o callchain.o

 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
+obj-$(CONFIG_PROC_FS) += proc_perf_events.o

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7d71d6..55766d0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -147,6 +147,10 @@ static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;

+LIST_HEAD(perf_events_list);
+DEFINE_MUTEX(perf_events_lock);
+
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -2897,6 +2901,10 @@ static void free_event(struct perf_event *event)
 	if (event->ctx)
 		put_ctx(event->ctx);

+	mutex_lock(&perf_events_lock);
+	list_del_rcu(&event->perf_entry);
+	mutex_unlock(&perf_events_lock);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }

@@ -5916,6 +5924,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
+	INIT_LIST_HEAD(&event->perf_entry);

 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
@@ -6013,6 +6022,10 @@ done:
 		}
 	}

+	mutex_lock(&perf_events_lock);
+	list_add_tail_rcu(&event->perf_entry, &perf_events_list);
+	mutex_unlock(&perf_events_lock);
+
 	return event;
 }

@@ -7220,3 +7233,4 @@ struct cgroup_subsys perf_subsys = {
 	.attach		= perf_cgroup_attach,
 };
 #endif /* CONFIG_CGROUP_PERF */
+
diff --git a/kernel/events/proc_perf_events.c b/kernel/events/proc_perf_events.c
new file mode 100644
index 0000000..5c2d56c
--- /dev/null
+++ b/kernel/events/proc_perf_events.c
@@ -0,0 +1,204 @@
+/*
+ *	linux/kerenl/events/proc_perf_events.c
+ *
+ *	Dump information for all perf_event
+ *
+ *	Created by: Jovi Zhang (bookjovi@gmail.com)
+ *
+ */
+
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+extern struct list_head perf_events_list;
+extern struct mutex perf_events_lock;
+
+static const char *perf_state_name(enum perf_event_active_state state)
+{
+	const char *name;
+
+	switch (state) {
+	case PERF_EVENT_STATE_ERROR:
+		name = "ERROR";
+		break;
+	case PERF_EVENT_STATE_OFF:
+		name = "OFF";
+		break;
+	case PERF_EVENT_STATE_INACTIVE:
+		name = "INACTIVE";
+		break;
+	case PERF_EVENT_STATE_ACTIVE:
+		name = "ACTIVE";
+		break;
+	default:
+		name = "NULL";
+	}
+
+	return name;
+}
+
+static void perf_attach_state_show(struct seq_file *m,
+				   unsigned int attach_state)
+{
+	seq_printf(m, "attach_state:\t\t");
+
+	if (attach_state & PERF_ATTACH_CONTEXT)
+		seq_printf(m, "ATTACH_CONTEXT ");
+	if (attach_state & PERF_ATTACH_GROUP)
+		seq_printf(m, "ATTACH_GROUP ");
+	if (attach_state & PERF_ATTACH_TASK)
+		seq_printf(m, " ATTACH_TASK ");
+
+	seq_putc(m, '\n');
+}
+
+static void perf_attr_sample_type_show(struct seq_file *m, __u64 sample_type)
+{
+	int i, valid = 0;
+
+	static char *sample_type_name[] = {
+		"IP",
+		"TID",
+		"TIME",
+		"ADDR",
+		"READ",
+		"CALLCHAIN",
+		"ID",
+		"CPU",
+		"PERIOD",
+		"STREAM_ID",
+		"RAW",
+		"BRANCH_STACK"
+	};
+
+	seq_printf(m, "attr.sample_type:\t");
+
+	for (i = 0; i < ARRAY_SIZE(sample_type_name); i++) {
+		if (sample_type & (1UL << i)) {
+			seq_printf(m, "%s ", sample_type_name[i]);
+			valid = 1;
+		}
+	}
+
+	if (!valid)
+		seq_printf(m, "NULL");
+
+	seq_putc(m, '\n');
+}
+
+static void perf_event_bp_show(struct seq_file *m,
+			       __u32 bp_type, __u32 bp_addr, __u32 bp_len)
+{
+	char *name;
+
+	seq_printf(m, "attr.bp_type:\t\t");
+	switch (bp_type) {
+	case HW_BREAKPOINT_EMPTY:
+		name = "EMPTY";
+		break;
+	case HW_BREAKPOINT_R:
+		name = "R";
+		break;
+	case HW_BREAKPOINT_W:
+		name = "W";
+		break;
+	case HW_BREAKPOINT_RW:
+		name = "RW";
+		break;
+	case HW_BREAKPOINT_X:
+		name = "X";
+		break;
+	case HW_BREAKPOINT_INVALID:
+		name = "INVALID";
+		break;
+	default:
+		name = "NULL";
+	}
+	seq_printf(m, "%s\n", name);
+
+	seq_printf(m, "attr.bp_addr:\t\t0x%x\n", bp_addr);
+	seq_printf(m, "attr.bp_len:\t\t%d\n", bp_len);
+}
+
+static void perf_event_attr_show(struct seq_file *m,
+				 struct perf_event_attr *attr)
+{
+	static const char * const type_name[] = {
+		"HARDWARE",
+		"SOFTWARE",
+		"TRACEPOINT",
+		"HW_CACHE",
+		"RAW",
+		"BREAKPOINT"
+	};
+
+	seq_printf(m, "attr.type:\t\t%s\n", type_name[attr->type]);
+	seq_printf(m, "attr.config:\t\t%llu\n", attr->config);
+	perf_attr_sample_type_show(m, attr->sample_type);
+	perf_event_bp_show(m, attr->bp_type, attr->bp_addr, attr->bp_len);
+	seq_printf(m, "attr flag:\t\tdisabled(%d) inherit(%d) pinned(%d) "
+			"exclusive(%d) exclude_user(%d) exclude_kernel(%d) "
+			"exclude_hv(%d) exclude_idle(%d) mmap(%d) comm(%d) "
+			"freq(%d) inherit_stat(%d) enable_on_exec(%d) task(%d) "
+			"watermark(%d) precise_ip(%d) mmap_data(%d) "
+			"sample_id_all(%d) exclude_host(%d) exclude_guest(%d)",
+			attr->disabled, attr->inherit, attr->pinned,
+			attr->exclusive, attr->exclude_user,
+			attr->exclude_kernel, attr->exclude_hv,
+			attr->exclude_idle, attr->mmap, attr->comm, attr->freq,
+			attr->inherit_stat, attr->enable_on_exec, attr->task,
+			attr->watermark, attr->precise_ip, attr->mmap_data,
+			attr->sample_id_all, attr->exclude_host,
+			attr->exclude_guest);
+	seq_putc(m, '\n');
+}
+
+static int perf_events_proc_show(struct seq_file *m, void *v)
+{
+	struct perf_event *event;
+	int i = 0;
+
+	mutex_lock(&perf_events_lock);
+	list_for_each_entry(event, &perf_events_list, perf_entry) {
+		i++;
+		seq_printf(m, "%d:\n", i);
+		seq_printf(m, "pmu:\t\t\t%s\n",
+				event->pmu ? event->pmu->name : "NULL");
+		seq_printf(m, "state:\t\t\t%s\n",
+				perf_state_name(event->state));
+		perf_attach_state_show(m, event->attach_state);
+		seq_printf(m, "oncpu:\t\t\t%d\n", event->oncpu);
+		seq_printf(m, "cpu:\t\t\t%d\n", event->cpu);
+		seq_printf(m, "count:\t\t\t%llu\n",
+				local64_read(&event->count));
+		seq_printf(m, "id:\t\t\t%llu\n", event->id);
+		perf_event_attr_show(m, &event->attr);
+
+		seq_putc(m, '\n');
+	}
+	mutex_unlock(&perf_events_lock);
+
+	return 0;
+}
+
+static int perf_events_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, perf_events_proc_show, NULL);
+}
+
+static const struct file_operations perf_events_proc_fops = {
+	.open           = perf_events_proc_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static int __init proc_perf_events_init(void)
+{
+	proc_create("perf_events", 0444, NULL, &perf_events_proc_fops);
+	return 0;
+}
+
+device_initcall(proc_perf_events_init);
-- 
1.7.9.7
