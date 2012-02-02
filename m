Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2BBR3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:29:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54196 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab2BBR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:28:56 -0500
Message-ID: <4F2AC7D0.3000405@gmail.com>
Date: Fri, 03 Feb 2012 01:28:48 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/3] KVM: perf: kvm events analysis tool
References: <4F2AC707.7020801@gmail.com>
In-Reply-To: <4F2AC707.7020801@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly

Usage:

- trace kvm events:
	perf kvm-events record, or, if other tracepoints are also
	interesting, we can append the events like this:
	perf kvm-events record -e timer:*

- show the result:
	perf kvm-events report

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-kvm-events.txt |   56 ++
 tools/perf/Makefile                          |    1 +
 tools/perf/builtin-kvm-events.c              |  909 ++++++++++++++++++++++++++
 tools/perf/builtin.h                         |    1 +
 tools/perf/command-list.txt                  |    1 +
 tools/perf/perf.c                            |    1 +
 6 files changed, 969 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-kvm-events.txt
 create mode 100644 tools/perf/builtin-kvm-events.c

diff --git a/tools/perf/Documentation/perf-kvm-events.txt b/tools/perf/Documentation/perf-kvm-events.txt
new file mode 100644
index 0000000..d46789a
--- /dev/null
+++ b/tools/perf/Documentation/perf-kvm-events.txt
@@ -0,0 +1,56 @@
+perf-kvm-events(1)
+============
+
+NAME
+----
+perf-kvm-events - Analyze kvm events
+
+SYNOPSIS
+--------
+[verse]
+'perf kvm-events' {record|report}
+
+DESCRIPTION
+-----------
+You can analyze some crucial kvm events and statistics with this
+'perf kvm-events' command. Currently, vmexit, mmio and ioport events
+are supported.
+
+  'perf kvm-events record <command>' records kvm events(vmexit,
+  mmio and ioport) and the events between start and end <command>.
+  And this command produces the file "perf.data" which contains
+  tracing results of kvm events.
+
+  'perf kvm-events report' reports statistical data which includes
+  events handled time, samples, and so on.
+
+COMMON OPTIONS
+--------------
+
+-i::
+--input=<file>::
+        Input file name. (default: perf.data unless stdin is a fifo)
+
+-v::
+--verbose::
+        Be more verbose (show symbol address, etc).
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
+REPORT OPTIONS
+--------------
+--vcpu=<value>::
+	analyze events which occures on this vcpu
+
+--events=<value>::
+	events to be analyzed. Possible values: vmexit, mmio, ioport.
+-k::
+--key=<value>::
+        Sorting key. Possible values: sample(default, sort by samples number),
+time(sort by average time).
+
+SEE ALSO
+--------
+linkperf:perf[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..ee43451 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -382,6 +382,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
+BUILTIN_OBJS += $(OUTPUT)builtin-kvm-events.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o

diff --git a/tools/perf/builtin-kvm-events.c b/tools/perf/builtin-kvm-events.c
new file mode 100644
index 0000000..8bb191f
--- /dev/null
+++ b/tools/perf/builtin-kvm-events.c
@@ -0,0 +1,909 @@
+#include "builtin.h"
+#include "perf.h"
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+#include "util/debug.h"
+#include "util/debugfs.h"
+#include "util/session.h"
+#include "util/tool.h"
+
+#include <math.h>
+
+#include <linux/kvm.h>
+
+#include "../../arch/x86/include/asm/kvm_exit.h"
+
+struct event_key {
+	#define INVALID_KEY	(~0ULL)
+	u64 key;
+	int info;
+};
+
+struct kvm_events_ops {
+	bool (*is_begin_event)(struct event *event, void *data,
+			       struct event_key *key);
+	bool (*is_end_event)(struct event *event, void *data,
+			     struct event_key *key);
+	void (*decode_key)(struct event_key *key, char decode[20]);
+	const char *name;
+};
+
+static void exit_event_get_key(struct event *event, void *data,
+			       struct event_key *key)
+{
+	key->info = 0;
+	key->key = raw_field_value(event, "exit_reason", data);
+}
+
+static bool kvm_exit_event(struct event *event)
+{
+	return !strcmp(event->name, "kvm_exit");
+}
+
+static bool exit_event_begin(struct event *event, void *data,
+			     struct event_key *key)
+{
+	if (kvm_exit_event(event)) {
+		exit_event_get_key(event, data, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool kvm_entry_event(struct event *event)
+{
+	return !strcmp(event->name, "kvm_entry");
+}
+
+static bool exit_event_end(struct event *event, void *data __unused,
+			   struct event_key *key __unused)
+{
+	return kvm_entry_event(event);
+}
+
+struct exit_reasons_table {
+	unsigned long exit_code;
+	const char *reason;
+};
+
+struct exit_reasons_table vmx_exit_reasons[] = {
+	VMX_EXIT_REASONS
+};
+
+struct exit_reasons_table svm_exit_reasons[] = {
+	SVM_EXIT_REASONS
+};
+
+static int get_cpu_isa(void)
+{
+	FILE *f;
+	char line[512], vendor[64];
+	int ret;
+
+	f = fopen("/proc/cpuinfo", "r");
+	if (!f)
+		die("/proc/cpuinfo does not exist.\n");
+
+	while (fgets(line, sizeof(line), f))
+		if (sscanf(line, "vendor_id	: %s", vendor) > 0) {
+			if (strstr(vendor, "Intel"))
+				ret = 1;
+			else if (strstr(vendor, "AMD"))
+				ret = 0;
+			else
+				break;
+			goto exit;
+		}
+
+	die("CPU vendor is unknown.\n");
+exit:
+	fclose(f);
+	return ret;
+}
+
+static const char *get_exit_reason(u64 exit_code)
+{
+	static int isa = -1;
+	int table_size = ARRAY_SIZE(svm_exit_reasons);
+	struct exit_reasons_table *table = svm_exit_reasons;
+
+	/*
+	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
+	 * traced in the old kernel.
+	 */
+	if (isa < 0)
+		isa = get_cpu_isa();
+
+	if (isa == 1) {
+		table = vmx_exit_reasons;
+		table_size = ARRAY_SIZE(vmx_exit_reasons);
+	}
+
+	while (table_size--) {
+		if (table->exit_code == exit_code)
+			return table->reason;
+		table++;
+	}
+
+	die("unknown kvm exit code:%ld on %s\n", exit_code,
+						isa ? "VMX" : "SVM");
+}
+
+static void exit_event_decode_key(struct event_key *key, char decode[20])
+{
+	const char *exit_reason = get_exit_reason(key->key);
+
+	snprintf(decode, 20, "%s", exit_reason);
+}
+
+static struct kvm_events_ops exit_events = {
+	.is_begin_event = exit_event_begin,
+	.is_end_event = exit_event_end,
+	.decode_key = exit_event_decode_key,
+	.name = "VM-EXIT"
+};
+
+/*
+ * For the old kernel, we treat:
+ * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
+ * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
+ *
+ * For the new kernel, we use kvm_mmio_begin and kvm_mmio_done to make
+ * things better.
+ */
+static void mmio_event_get_key(struct event *event, void *data,
+				struct event_key *key)
+{
+	key->key = raw_field_value(event, "gpa", data);
+	key->info = raw_field_value(event, "type", data);
+}
+
+#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
+#define KVM_TRACE_MMIO_READ 1
+#define KVM_TRACE_MMIO_WRITE 2
+
+static bool kvm_mmio_done_event(struct event *event)
+{
+	return !strcmp(event->name, "kvm_mmio_done");
+}
+
+static bool mmio_event_begin(struct event *event, void *data,
+			     struct event_key *key)
+{
+	/* MMIO read begin in old kernel. */
+	if (kvm_exit_event(event))
+		return true;
+
+	/* MMIO write begin in old kernel. */
+	if (!strcmp(event->name, "kvm_mmio") &&
+	      raw_field_value(event, "type", data) == KVM_TRACE_MMIO_WRITE) {
+		mmio_event_get_key(event, data, key);
+		return true;
+	}
+
+	/* MMIO read/write begin in new kernel. */
+	if (!strcmp(event->name, "kvm_mmio_begin")) {
+		mmio_event_get_key(event, data, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool mmio_event_end(struct event *event,  void *data,
+			   struct event_key *key)
+{
+	/* MMIO write end in old kernel. */
+	if (kvm_entry_event(event))
+		return true;
+
+	/* MMIO read end in the old kernel.*/
+	if (!strcmp(event->name, "kvm_mmio") &&
+	      raw_field_value(event, "type", data) == KVM_TRACE_MMIO_READ) {
+		mmio_event_get_key(event, data, key);
+		return true;
+	}
+
+	/* MMIO read/write end event in the new kernel.*/
+	return kvm_mmio_done_event(event);
+}
+
+static void mmio_event_decode_key(struct event_key *key, char decode[20])
+{
+	snprintf(decode, 20, "%#lx:%s", key->key,
+			      key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
+}
+
+static struct kvm_events_ops mmio_events = {
+	.is_begin_event = mmio_event_begin,
+	.is_end_event = mmio_event_end,
+	.decode_key = mmio_event_decode_key,
+	.name = "MMIO Access"
+};
+
+/*
+ * For the old kernel, the time of emulation pio access is from kvm_pio to
+ * kvm_entry. In the new kernel, the end time is indicated by kvm_mmio_done.
+ */
+static void ioport_event_get_key(struct event *event, void *data,
+				 struct event_key *key)
+{
+	key->key = raw_field_value(event, "port", data);
+	key->info = raw_field_value(event, "rw", data);
+}
+
+static bool ioport_event_begin(struct event *event, void *data,
+			       struct event_key *key)
+{
+	if (!strcmp(event->name, "kvm_pio")) {
+		ioport_event_get_key(event, data, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool ioport_event_end(struct event *event, void *data __unused,
+			     struct event_key *key __unused)
+{
+	if (kvm_entry_event(event))
+		return true;
+
+	return kvm_mmio_done_event(event);
+}
+
+static void ioport_event_decode_key(struct event_key *key, char decode[20])
+{
+	snprintf(decode, 20, "%#lx:%s", key->key, key->info ? "POUT" : "PIN");
+}
+
+static struct kvm_events_ops ioport_events = {
+	.is_begin_event = ioport_event_begin,
+	.is_end_event = ioport_event_end,
+	.decode_key = ioport_event_decode_key,
+	.name = "IO Port Access"
+};
+
+static const char *report_event = "vmexit";
+struct kvm_events_ops *events_ops;
+
+static void register_kvm_events_ops(void)
+{
+	if (!strcmp(report_event, "vmexit"))
+		events_ops = &exit_events;
+	else if (!strcmp(report_event, "mmio"))
+		events_ops = &mmio_events;
+	else if (!strcmp(report_event, "ioport"))
+		events_ops = &ioport_events;
+	else
+		die("Unknown report event:%s\n", report_event);
+}
+
+struct event_stats {
+	u64 count;
+	u64 time;
+
+	/* used to calculate stddev. */
+	double mean;
+	double M2;
+};
+
+struct kvm_event {
+	struct list_head hash_entry;
+	struct rb_node rb;
+
+	struct event_key key;
+
+	struct event_stats total;
+	struct event_stats vcpu[0]; /* max vcpus */
+};
+
+struct {
+	u64 start_time;
+	struct kvm_event *last_event;
+} *vcpu_event_record;
+
+#define EVENTS_BITS			12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+static int kvm_max_vcpus;
+static u64 total_time;
+static u64 total_count;
+static struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+
+#ifndef KVM_CAP_MAX_VCPUS
+#define KVM_CAP_MAX_VCPUS 66
+#endif
+
+static int kvm_max_cpus(void)
+{
+	int kvm_fd, ret;
+
+	kvm_fd = open("/dev/kvm", O_RDWR);
+	if (kvm_fd < 0)
+		die("KVM is not available.\n");
+
+	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
+
+	if (ret <= 0)
+		ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
+
+	if (ret <= 0)
+		die("inquiry max vcpu fail.\n");
+
+	return ret;
+}
+
+static void init_kvm_event_record(void)
+{
+	int i;
+
+	kvm_max_vcpus = kvm_max_cpus();
+
+	vcpu_event_record = zalloc(sizeof(*vcpu_event_record) * kvm_max_vcpus);
+	if (!vcpu_event_record)
+		die("zalloc.\n");
+
+	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
+		INIT_LIST_HEAD(&kvm_events_cache[i]);
+}
+
+static int kvm_events_hash_fn(u64 key)
+{
+	return key & (EVENTS_CACHE_SIZE - 1);
+}
+
+static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
+{
+	struct kvm_event *event;
+
+	event = zalloc(sizeof(*event) +
+		       sizeof(struct event_stats) * kvm_max_vcpus);
+
+	if (!event)
+		die("Not enough memory\n");
+
+	event->key = *key;
+	return event;
+}
+
+static struct kvm_event *find_create_kvm_event(struct event_key *key)
+{
+	struct kvm_event *event;
+	struct list_head *head;
+
+	BUG_ON(key->key == INVALID_KEY);
+
+	head = &kvm_events_cache[kvm_events_hash_fn(key->key)];
+	list_for_each_entry(event, head, hash_entry)
+		if (event->key.key == key->key && event->key.info == key->info)
+			return event;
+
+	event = kvm_alloc_init_event(key);
+	list_add(&event->hash_entry, head);
+	return event;
+}
+
+#define VCPU_ID_BITS			6
+#define VCPU_ID_CACHE_SIZE	(1UL << VCPU_ID_BITS)
+
+struct kvm_tid_vcpu_id {
+	struct list_head hash_entry;
+
+	u32 tid;
+	int vcpu_id;
+};
+
+static struct list_head kvm_vcpu_id_cache[VCPU_ID_CACHE_SIZE];
+
+static int kvm_tid_hash_fn(u32 tid)
+{
+	return tid & (VCPU_ID_CACHE_SIZE - 1);
+}
+
+static int get_vcpu_id(u32 tid)
+{
+	struct list_head *head;
+	struct kvm_tid_vcpu_id *tid2pid;
+
+	head = &kvm_vcpu_id_cache[kvm_tid_hash_fn(tid)];
+	list_for_each_entry(tid2pid, head, hash_entry)
+		if (tid2pid->tid == tid)
+			return tid2pid->vcpu_id;
+
+	return -1;
+}
+
+static int get_record_vcpu_id(struct event *event, u32 tid, void *data)
+{
+	struct list_head *head;
+	struct kvm_tid_vcpu_id *tid2pid;
+	int vcpu_id;
+
+	vcpu_id = get_vcpu_id(tid);
+	if (vcpu_id >= 0)
+		return vcpu_id;
+
+	/* Only kvm_entry records vcpu id. */
+	if (!kvm_entry_event(event))
+		return -1;
+
+	head = &kvm_vcpu_id_cache[kvm_tid_hash_fn(tid)];
+
+	tid2pid = zalloc(sizeof(*tid2pid));
+	if (!tid2pid)
+		die("Not enough memory\n");
+
+	tid2pid->tid = tid;
+	vcpu_id = tid2pid->vcpu_id = raw_field_value(event, "vcpu_id", data);
+	list_add(&tid2pid->hash_entry, head);
+
+	return vcpu_id;
+}
+
+static void init_kvm_tid_to_pid(void)
+{
+	int i;
+
+	for (i = 0; i < (int)VCPU_ID_CACHE_SIZE; i++)
+		INIT_LIST_HEAD(&kvm_vcpu_id_cache[i]);
+}
+
+static void handle_begin_event(struct event_key *key, int vcpu_id,
+			       u64 timestamp)
+{
+	struct kvm_event *event = NULL;
+
+	if (key->key != INVALID_KEY)
+		event = find_create_kvm_event(key);
+
+	vcpu_event_record[vcpu_id].last_event = event;
+	vcpu_event_record[vcpu_id].start_time = timestamp;
+}
+
+static void update_event_stats(struct event_stats *stats, u64 time_diff)
+{
+	double delta;
+
+	stats->count++;
+	stats->time += time_diff;
+
+	delta = time_diff - stats->mean;
+	stats->mean += delta / stats->count;
+	stats->M2 += delta*(time_diff - stats->mean);
+}
+
+static double event_stats_stddev(int vcpu_id, struct kvm_event *event)
+{
+	struct event_stats *stats = &event->total;
+	double variance, variance_mean, stddev;
+
+	if (vcpu_id != -1)
+		stats = &event->vcpu[vcpu_id];
+
+	BUG_ON(!stats->count);
+
+	variance = stats->M2 / (stats->count - 1);
+	variance_mean = variance / stats->count;
+	stddev = sqrt(variance_mean);
+
+	return stddev * 100 / stats->mean;
+}
+
+static void update_kvm_event(struct kvm_event *event, int vcpu_id,
+			     u64 time_diff)
+{
+	update_event_stats(&event->total, time_diff);
+	update_event_stats(&event->vcpu[vcpu_id], time_diff);
+}
+
+static void handle_end_event(struct event_key *key, int vcpu_id, u64 timestamp)
+{
+	struct kvm_event *event;
+	u64 time_begin, time_diff;
+
+	event = vcpu_event_record[vcpu_id].last_event;
+	time_begin = vcpu_event_record[vcpu_id].start_time;
+
+	/* The begin event is not caught. */
+	if (!time_begin)
+		return;
+
+	/* Both begin and end events did not get the key. */
+	if (!event && key->key == INVALID_KEY)
+		return;
+
+	if (!event)
+		event = find_create_kvm_event(key);
+
+	vcpu_event_record[vcpu_id].last_event = NULL;
+	vcpu_event_record[vcpu_id].start_time = 0;
+
+	BUG_ON(timestamp < time_begin);
+
+	time_diff = timestamp - time_begin;
+	update_kvm_event(event, vcpu_id, time_diff);
+}
+
+static void handle_kvm_event(struct event *event, void *data, u64 timestamp,
+			     u32 tid)
+{
+	struct event_key key = {.key = INVALID_KEY};
+	int vcpu_id = get_record_vcpu_id(event, tid, data);
+
+	if (vcpu_id < 0)
+		return;
+
+	if (events_ops->is_begin_event(event, data, &key))
+		return handle_begin_event(&key, vcpu_id, timestamp);
+
+	if (events_ops->is_end_event(event, data, &key))
+		return handle_end_event(&key, vcpu_id, timestamp);
+}
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+static int trace_vcpu = -1;
+#define GET_EVENT_KEY(member)		\
+static u64 get_event_ ##member(struct kvm_event *event, int vcpu)	\
+{									\
+	if (vcpu == -1)							\
+		return event->total.member;				\
+									\
+	return event->vcpu[vcpu].member;				\
+}
+
+#define COMPARE_EVENT_KEY(member)					\
+GET_EVENT_KEY(member)							\
+static int compare_kvm_event_ ## member(struct kvm_event *one,		\
+					struct kvm_event *two, int vcpu)\
+{									\
+	return get_event_ ##member(one, vcpu) >				\
+				get_event_ ##member(two, vcpu);		\
+}
+
+GET_EVENT_KEY(time);
+COMPARE_EVENT_KEY(count);
+COMPARE_EVENT_KEY(mean);
+
+#define DEF_SORT_NAME_KEY(name, compare_key)	\
+	{ #name, compare_kvm_event_ ## compare_key }
+
+static struct kvm_event_key keys[] = {
+	DEF_SORT_NAME_KEY(sample, count),
+	DEF_SORT_NAME_KEY(time, mean),
+	{ NULL, NULL }
+};
+
+static const char *sort_key = "sample";
+static key_cmp_fun compare;
+
+static void select_key(void)
+{
+	int i;
+
+	for (i = 0; keys[i].name; i++) {
+		if (!strcmp(keys[i].name, sort_key)) {
+			compare = keys[i].key;
+			return;
+		}
+	}
+
+	die("Unknown compare key:%s\n", sort_key);
+}
+
+static struct rb_root result;
+static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
+			     int vcpu)
+{
+	struct rb_node **rb = &result.rb_node;
+	struct rb_node *parent = NULL;
+	struct kvm_event *p;
+
+	while (*rb) {
+		p = container_of(*rb, struct kvm_event, rb);
+		parent = *rb;
+
+		if (bigger(event, p, vcpu))
+			rb = &(*rb)->rb_left;
+		else
+			rb = &(*rb)->rb_right;
+	}
+
+	rb_link_node(&event->rb, parent, rb);
+	rb_insert_color(&event->rb, &result);
+}
+
+static void update_total_count(struct kvm_event *event, int vcpu)
+{
+	total_count += get_event_count(event, vcpu);
+	total_time += get_event_time(event, vcpu);
+}
+
+static bool event_is_valid(struct kvm_event *event, int vcpu)
+{
+	return get_event_count(event, vcpu);
+}
+
+static void sort_result(int vcpu)
+{
+	unsigned int i;
+	struct kvm_event *event;
+
+	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
+		list_for_each_entry(event, &kvm_events_cache[i], hash_entry)
+			if (event_is_valid(event, vcpu)) {
+				update_total_count(event, vcpu);
+				insert_to_result(event, compare, vcpu);
+			}
+}
+
+/* returns left most element of result, and erase it */
+static struct kvm_event *pop_from_result(void)
+{
+	struct rb_node *node = result.rb_node;
+
+	if (!node)
+		return NULL;
+
+	while (node->rb_left)
+		node = node->rb_left;
+
+	rb_erase(node, &result);
+	return container_of(node, struct kvm_event, rb);
+}
+
+static void print_vcpu_info(int vcpu)
+{
+	pr_info("Analyze events for ");
+
+	if (vcpu == -1)
+		pr_info("all VCPUs:\n\n");
+	else
+		pr_info("VCPU %d:\n\n", vcpu);
+}
+
+static void print_result(int vcpu)
+{
+	char decode[20];
+	struct kvm_event *event;
+
+	pr_info("\n\n");
+	print_vcpu_info(vcpu);
+	pr_info("%20s ", events_ops->name);
+	pr_info("%10s ", "Samples");
+	pr_info("%9s ", "Samples%");
+
+	pr_info("%9s ", "Time%");
+	pr_info("%16s ", "Avg time");
+	pr_info("\n\n");
+
+	while ((event = pop_from_result())) {
+		u64 ecount, etime;
+
+		ecount = get_event_count(event, vcpu);
+		etime = get_event_time(event, vcpu);
+
+		events_ops->decode_key(&event->key, decode);
+		pr_info("%20s ", decode);
+		pr_info("%10lu ", ecount);
+		pr_info("%8.2f%% ", (double)ecount / total_count * 100);
+		pr_info("%8.2f%% ", (double)etime / total_time * 100);
+		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
+			event_stats_stddev(trace_vcpu, event));
+		pr_info("\n");
+	}
+
+	pr_info("\nTotal Samples:%ld, Total events handled time:%.2fus.\n\n",
+		total_count, total_time / 1e3);
+}
+
+static void process_raw_event(void *data, int __unused cpu, u64 timestamp,
+			      u32 tid)
+{
+	struct event *event;
+	int type;
+
+	type = trace_parse_common_type(data);
+	event = trace_find_event(type);
+
+	return handle_kvm_event(event, data, timestamp, tid);
+}
+
+static int process_sample_event(struct perf_tool *tool __used,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
+				struct machine *machine)
+{
+	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	process_raw_event(sample->raw_data, sample->cpu, sample->time,
+			  sample->tid);
+
+	return 0;
+}
+
+static struct perf_tool eops = {
+	.sample			= process_sample_event,
+	.comm			= perf_event__process_comm,
+	.ordered_samples	= true,
+};
+
+static char const *input_name = "perf.data";
+
+static int read_events(void)
+{
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
+	if (!session)
+		die("Initializing perf session failed\n");
+
+	if (!perf_session__has_traces(session, "kvm record"))
+		return -1;
+
+	return perf_session__process_events(session, &eops);
+}
+
+static void verify_vcpu(int vcpu)
+{
+	if (vcpu != -1 && (vcpu > kvm_max_vcpus || vcpu < 0))
+		die("Unknown vcpu:%d.\n", vcpu);
+
+}
+
+static int kvm_events_report(int vcpu)
+{
+	init_kvm_event_record();
+	init_kvm_tid_to_pid();
+	verify_vcpu(vcpu);
+	select_key();
+	register_kvm_events_ops();
+	setup_pager();
+	read_events();
+	sort_result(vcpu);
+	print_result(vcpu);
+	return 0;
+}
+
+static const char * const record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-f",
+	"-m", "1024",
+	"-c", "1",
+	"-e", "kvm:kvm_entry",
+	"-e", "kvm:kvm_exit",
+	"-e", "kvm:kvm_mmio",
+	"-e", "kvm:kvm_pio",
+};
+
+static const char * const new_event[] = {
+	"kvm_mmio_begin",
+	"kvm_mmio_done"
+};
+
+static bool kvm_events_exist(const char *event)
+{
+	char evt_path[MAXPATHLEN];
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/kvm/%s/id", tracing_events_path,
+		 event);
+
+	fd = open(evt_path, O_RDONLY);
+
+	if (fd < 0)
+		return false;
+
+	close(fd);
+
+	return true;
+}
+
+static int kvm_events_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argc += ARRAY_SIZE(new_event) * 2;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 0; j < ARRAY_SIZE(new_event); j++)
+		if (kvm_events_exist(new_event[j])) {
+			char event[256];
+
+			sprintf(event, "kvm:%s", new_event[j]);
+
+			rec_argv[i++] = strdup("-e");
+			rec_argv[i++] = strdup(event);
+		}
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+static const char * const kvm_events_report_usage[] = {
+	"perf kvm events report [<options>]",
+	NULL
+};
+
+static const struct option kvm_events_report_options[] = {
+	OPT_STRING(0, "event", &report_event, "reprot event",
+		    "event for reporting: vmexit, mmio, ioport"),
+	OPT_INTEGER(0, "vcpu", &trace_vcpu,
+		    "vcpu id to report"),
+	OPT_STRING('k', "key", &sort_key, "sort-key",
+		    "key for sorting: sample(sort by samples number)"
+		    " time (sort by avg time)"),
+	OPT_END()
+};
+
+static const char * const kvm_events_usage[] = {
+	"perf kvm events [<options>] {record|report}",
+	NULL
+};
+
+static const struct option kvm_events_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		 "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+int cmd_kvm_events(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, kvm_events_options, kvm_events_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(kvm_events_usage, kvm_events_options);
+
+	symbol__init();
+
+	if (!strncmp(argv[0], "rec", 3))
+		return kvm_events_record(argc, argv);
+
+	if (!strncmp(argv[0], "report", 6)) {
+		if (argc) {
+			argc = parse_options(argc, argv,
+					     kvm_events_report_options,
+					     kvm_events_report_usage, 0);
+			if (argc)
+				usage_with_options(kvm_events_report_usage,
+						   kvm_events_report_options);
+		}
+		return kvm_events_report(trace_vcpu);
+	}
+
+	usage_with_options(kvm_events_usage, kvm_events_options);
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b382bd5..fb19e3d 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -33,6 +33,7 @@ extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
 extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
+extern int cmd_kvm_events(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);

diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index d695fe4..c5e97d8 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -22,4 +22,5 @@ perf-probe			mainporcelain common
 perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
+perf-kvm-events			mainporcelain common
 perf-test			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2b2e225..ab85ea5 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -317,6 +317,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "kmem",	cmd_kmem,	0 },
 		{ "lock",	cmd_lock,	0 },
 		{ "kvm",	cmd_kvm,	0 },
+		{ "kvm-events", cmd_kvm_events, 0},
 		{ "test",	cmd_test,	0 },
 		{ "inject",	cmd_inject,	0 },
 	};
-- 
1.7.7.5

