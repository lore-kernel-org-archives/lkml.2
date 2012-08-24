Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2HXBQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:16:13 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54563 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2HXBPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:15:48 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu
Cc: xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
Date: Fri, 24 Aug 2012 09:15:29 +0800
Message-Id: <1345770929-13667-4-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345770929-13667-1-git-send-email-haodong@linux.vnet.ibm.com>
References: <1345770929-13667-1-git-send-email-haodong@linux.vnet.ibm.com>
x-cbid: 12082401-0542-0000-0000-000002D2639B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Add 'perf kvm stat' support to analyze kvm vmexit/mmio/ioport smartly

Usage:
- kvm stat
  run a command and gather performance counter statistics, it is the alias of
  perf stat

- trace kvm events:
  perf kvm stat record, or, if other tracepoints are interesting as well, we
  can append the events like this:
  perf kvm stat record -e timer:*
  If many guests are running, we can track the specified guest by using -p or
  --pid

- show the result:
  perf kvm stat report

The output example is following:
# pgrep qemu-kvm
26071
32253
32564

total 3 guests are running on the host

Then, track the guest whose pid is 26071:
# ./perf kvm stat record -p 26071
^C[ perf record: Woken up 9 times to write data ]
[ perf record: Captured and wrote 24.903 MB perf.data.guest (~1088034 samples) ]

See the vmexit events:
# ./perf kvm stat report --event=vmexit

Analyze events for all VCPUs:

             VM-EXIT    Samples  Samples%     Time%         Avg time

         APIC_ACCESS      65381    66.58%     5.95%     37.72us ( +-   6.54% )
  EXTERNAL_INTERRUPT      16031    16.32%     3.06%     79.11us ( +-   7.34% )
               CPUID       5360     5.46%     0.06%      4.50us ( +-  35.07% )
                 HLT       4496     4.58%    90.75%   8360.34us ( +-   5.22% )
       EPT_VIOLATION       2667     2.72%     0.04%      5.49us ( +-   5.05% )
   PENDING_INTERRUPT       2242     2.28%     0.03%      5.25us ( +-   2.96% )
       EXCEPTION_NMI       1332     1.36%     0.02%      6.53us ( +-   6.51% )
      IO_INSTRUCTION        383     0.39%     0.09%     93.39us ( +-  40.92% )
           CR_ACCESS        310     0.32%     0.00%      6.10us ( +-   3.95% )

Total Samples:98202, Total events handled time:41419293.63us.

See the mmio events:
# ./perf kvm stat report --event=mmio

Analyze events for all VCPUs:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W      58686    90.21%    15.67%      4.95us ( +-   2.96% )
        0xfee00300:R       2124     3.26%     1.48%     12.93us ( +-  14.75% )
        0xfee00310:W       2124     3.26%     0.34%      3.00us ( +-   1.33% )
        0xfee00300:W       2123     3.26%    82.50%    720.68us ( +-  10.24% )

Total Samples:65057, Total events handled time:1854470.45us.

See the ioport event:
# ./perf kvm stat report --event=ioport

Analyze events for all VCPUs:

      IO Port Access    Samples  Samples%     Time%         Avg time

         0xc090:POUT        383   100.00%   100.00%     89.00us ( +-  42.94% )

Total Samples:383, Total events handled time:34085.56us.

And, --vcpu is used to track the specified vcpu and --key is used to sort the
result:
# ./perf kvm stat report --event=vmexit --vcpu=0 --key=time

Analyze events for VCPU 0:

             VM-EXIT    Samples  Samples%     Time%         Avg time

                 HLT        551     5.05%    94.81%   9501.72us ( +-  12.52% )
  EXTERNAL_INTERRUPT       1390    12.74%     2.39%     94.80us ( +-  20.92% )
         APIC_ACCESS       6186    56.68%     2.62%     23.41us ( +-  23.62% )
      IO_INSTRUCTION         17     0.16%     0.01%     20.39us ( +-  22.33% )
       EXCEPTION_NMI         94     0.86%     0.01%      6.07us ( +-   7.13% )
   PENDING_INTERRUPT        199     1.82%     0.02%      5.48us ( +-   4.36% )
           CR_ACCESS         52     0.48%     0.00%      4.89us ( +-   4.09% )
       EPT_VIOLATION       2057    18.85%     0.12%      3.15us ( +-   1.33% )
               CPUID        368     3.37%     0.02%      2.82us ( +-   2.79% )

Total Samples:10914, Total events handled time:5521782.02us.

[ Dong Hao <haodong@linux.vnet.ibm.com>:
     - rebase it on current acme's tree
     - fix the compiling-error on i386
]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-kvm.txt |   30 +-
 tools/perf/MANIFEST                   |    3 +
 tools/perf/builtin-kvm.c              |  889 ++++++++++++++++++++++++++++++++-
 tools/perf/util/header.c              |   54 ++-
 tools/perf/util/header.h              |    1 +
 tools/perf/util/thread.h              |    2 +
 6 files changed, 973 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index dd84cb2..d52feef 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 	[--guestkallsyms=<path> --guestmodules=<path> | --guestvmlinux=<path>]]
 	{top|record|report|diff|buildid-list}
 'perf kvm' [--host] [--guest] [--guestkallsyms=<path> --guestmodules=<path>
-	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list}
+	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list|stat}
 
 DESCRIPTION
 -----------
@@ -38,6 +38,18 @@ There are a couple of variants of perf kvm:
   so that other tools can be used to fetch packages with matching symbol tables
   for use by perf report.
 
+  'perf kvm stat <command>' to run a command and gather performance counter
+   statistics.
+  Especially, perf 'kvm stat record/report' generates a statistical analysis
+  of KVM events. Currently, vmexit, mmio and ioport events are supported.
+    'perf kvm stat record <command>' records kvm events and the events between
+    start and end <command>.
+    And this command produces a file which contains tracing results of kvm
+    events.
+
+    'perf kvm stat report' reports statistical data which includes events
+    handled time, samples, and so on.
+
 OPTIONS
 -------
 -i::
@@ -68,7 +80,21 @@ OPTIONS
 --guestvmlinux=<path>::
 	Guest os kernel vmlinux.
 
+STAT REPORT OPTIONS
+-------------------
+--vcpu=<value>::
+	analyze events which occures on this vcpu. (default: all vcpus)
+
+--events=<value>::
+	events to be analyzed. Possible values: vmexit, mmio, ioport.
+	(default: vmexit)
+-k::
+--key=<value>::
+	Sorting key. Possible values: sample (default, sort by samples
+	number), time (sort by average time).
+
 SEE ALSO
 --------
 linkperf:perf-top[1], linkperf:perf-record[1], linkperf:perf-report[1],
-linkperf:perf-diff[1], linkperf:perf-buildid-list[1]
+linkperf:perf-diff[1], linkperf:perf-buildid-list[1],
+linkperf:perf-stat[1]
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index b4b572e..6896648 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -15,3 +15,6 @@ arch/*/lib/memset*.S
 include/linux/poison.h
 include/linux/magic.h
 include/linux/hw_breakpoint.h
+arch/x86/include/asm/svm.h
+arch/x86/include/asm/vmx.h
+arch/x86/include/asm/kvm_host.h
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9fc6e0f..5396444 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1,6 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
+#include "util/evsel.h"
 #include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
@@ -10,8 +11,9 @@
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
-
 #include "util/debug.h"
+#include "util/debugfs.h"
+#include "util/tool.h"
 
 #include <sys/prctl.h>
 
@@ -19,11 +21,890 @@
 #include <pthread.h>
 #include <math.h>
 
-static const char		*file_name;
+#include "../../arch/x86/include/asm/svm.h"
+#include "../../arch/x86/include/asm/vmx.h"
+#include "../../arch/x86/include/asm/kvm_host.h"
+
+struct event_key {
+	#define INVALID_KEY	(~0ULL)
+	u64 key;
+	int info;
+};
+
+struct kvm_events_ops {
+	bool (*is_begin_event)(struct event_format *event, void *data,
+			       struct event_key *key);
+	bool (*is_end_event)(struct event_format *event, void *data,
+			     struct event_key *key);
+	void (*decode_key)(struct event_key *key, char decode[20]);
+	const char *name;
+};
+
+static void exit_event_get_key(struct event_format *event, void *data,
+			       struct event_key *key)
+{
+	key->info = 0;
+	key->key = raw_field_value(event, "exit_reason", data);
+}
+
+static bool kvm_exit_event(struct event_format *event)
+{
+	return !strcmp(event->name, "kvm_exit");
+}
+
+static bool exit_event_begin(struct event_format *event, void *data,
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
+static bool kvm_entry_event(struct event_format *event)
+{
+	return !strcmp(event->name, "kvm_entry");
+}
+
+static bool exit_event_end(struct event_format *event, void *data __unused,
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
+static int cpu_isa;
+
+static const char *get_exit_reason(u64 exit_code)
+{
+	int table_size = ARRAY_SIZE(svm_exit_reasons);
+	struct exit_reasons_table *table = svm_exit_reasons;
+
+	if (cpu_isa == 1) {
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
+	pr_err("unknown kvm exit code:%lld on %s\n",
+	       (unsigned long long)exit_code, cpu_isa ? "VMX" : "SVM");
+	return "UNKNOWN";
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
+ * For the new kernel, we use kvm_mmio_begin and kvm_io_done to make
+ * things better.
+ */
+static void mmio_event_get_key(struct event_format *event, void *data,
+			       struct event_key *key)
+{
+	key->key = raw_field_value(event, "gpa", data);
+	key->info = raw_field_value(event, "type", data);
+}
+
+#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
+#define KVM_TRACE_MMIO_READ 1
+#define KVM_TRACE_MMIO_WRITE 2
+
+static bool kvm_io_done_event(struct event_format *event)
+{
+	return !strcmp(event->name, "kvm_io_done");
+}
+
+static bool mmio_event_begin(struct event_format *event, void *data,
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
+static bool mmio_event_end(struct event_format *event,  void *data,
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
+	return kvm_io_done_event(event);
+}
+
+static void mmio_event_decode_key(struct event_key *key, char decode[20])
+{
+	snprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
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
+ * kvm_entry. In the new kernel, the end time is indicated by kvm_io_done.
+ */
+static void ioport_event_get_key(struct event_format *event, void *data,
+				 struct event_key *key)
+{
+	key->key = raw_field_value(event, "port", data);
+	key->info = raw_field_value(event, "rw", data);
+}
+
+static bool ioport_event_begin(struct event_format *event, void *data,
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
+static bool ioport_event_end(struct event_format *event, void *data __unused,
+			     struct event_key *key __unused)
+{
+	if (kvm_entry_event(event))
+		return true;
+
+	return kvm_io_done_event(event);
+}
+
+static void ioport_event_decode_key(struct event_key *key, char decode[20])
+{
+	snprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
+		 key->info ? "POUT" : "PIN");
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
+static bool register_kvm_events_ops(void)
+{
+	bool ret = true;
+
+	if (!strcmp(report_event, "vmexit"))
+		events_ops = &exit_events;
+	else if (!strcmp(report_event, "mmio"))
+		events_ops = &mmio_events;
+	else if (!strcmp(report_event, "ioport"))
+		events_ops = &ioport_events;
+	else {
+		pr_err("Unknown report event:%s\n", report_event);
+		ret = false;
+	}
+
+	return ret;
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
+
+	#define DEFAULT_VCPU_NUM 8
+	int max_vcpu;
+	struct event_stats *vcpu;
+};
+
+struct vcpu_event_record {
+	int vcpu_id;
+	u64 start_time;
+	struct kvm_event *last_event;
+};
+
+#define EVENTS_BITS			12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+static u64 total_time;
+static u64 total_count;
+static struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+
+static void init_kvm_event_record(void)
+{
+	int i;
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
+static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
+{
+	int old_max_vcpu = event->max_vcpu;
+
+	if (vcpu_id < event->max_vcpu)
+		return true;
+
+	while (event->max_vcpu <= vcpu_id)
+		event->max_vcpu += DEFAULT_VCPU_NUM;
+
+	event->vcpu = realloc(event->vcpu,
+			      event->max_vcpu * sizeof(*event->vcpu));
+	if (!event->vcpu) {
+		pr_err("Not enough memory\n");
+		return false;
+	}
+
+	memset(event->vcpu + old_max_vcpu, 0,
+	       (event->max_vcpu - old_max_vcpu) * sizeof(*event->vcpu));
+	return true;
+}
+
+static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
+{
+	struct kvm_event *event;
+
+	event = zalloc(sizeof(*event));
+	if (!event) {
+		pr_err("Not enough memory\n");
+		return NULL;
+	}
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
+	if (!event)
+		return NULL;
+
+	list_add(&event->hash_entry, head);
+	return event;
+}
+
+static void handle_begin_event(struct vcpu_event_record *vcpu_record,
+			       struct event_key *key, u64 timestamp)
+{
+	struct kvm_event *event = NULL;
+
+	if (key->key != INVALID_KEY)
+		event = find_create_kvm_event(key);
+
+	vcpu_record->last_event = event;
+	vcpu_record->start_time = timestamp;
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
+
+	if (!kvm_event_expand(event, vcpu_id))
+		return;
+
+	update_event_stats(&event->vcpu[vcpu_id], time_diff);
+}
+
+static void handle_end_event(struct vcpu_event_record *vcpu_record,
+			     struct event_key *key, u64 timestamp)
+{
+	struct kvm_event *event;
+	u64 time_begin, time_diff;
+
+	event = vcpu_record->last_event;
+	time_begin = vcpu_record->start_time;
+
+	/* The begin event is not caught. */
+	if (!time_begin)
+		return;
+
+	/*
+	 * In some case, the 'begin event' only records the start timestamp,
+	 * the actual event is recognized in the 'end event' (e.g. mmio-event
+	 * in the old kernel).
+	 */
+
+	/* Both begin and end events did not get the key. */
+	if (!event && key->key == INVALID_KEY)
+		return;
+
+	if (!event)
+		event = find_create_kvm_event(key);
+
+	if (!event)
+		return;
+
+	vcpu_record->last_event = NULL;
+	vcpu_record->start_time = 0;
+
+	BUG_ON(timestamp < time_begin);
+
+	time_diff = timestamp - time_begin;
+	update_kvm_event(event, vcpu_record->vcpu_id, time_diff);
+}
+
+static struct vcpu_event_record
+*per_vcpu_record(struct thread *thread, struct event_format *event, void *data)
+{
+	/* Only kvm_entry records vcpu id. */
+	if (!thread->priv && kvm_entry_event(event)) {
+		struct vcpu_event_record *vcpu_record;
+
+		vcpu_record = zalloc(sizeof(struct vcpu_event_record));
+		if (!vcpu_record) {
+			pr_err("Not enough memory\n");
+			return NULL;
+		}
+
+		vcpu_record->vcpu_id = raw_field_value(event, "vcpu_id", data);
+		thread->priv = vcpu_record;
+	}
+
+	return (struct vcpu_event_record *)thread->priv;
+}
+
+static void handle_kvm_event(struct thread *thread, struct event_format *event,
+			     void *data, u64 timestamp)
+{
+	struct vcpu_event_record *vcpu_record;
+	struct event_key key = {.key = INVALID_KEY};
+
+	vcpu_record = per_vcpu_record(thread, event, data);
+	if (!vcpu_record)
+		return;
+
+	if (events_ops->is_begin_event(event, data, &key))
+		return handle_begin_event(vcpu_record, &key, timestamp);
+
+	if (events_ops->is_end_event(event, data, &key))
+		return handle_end_event(vcpu_record, &key, timestamp);
+}
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+static int trace_vcpu = -1;
+#define GET_EVENT_KEY(member)						\
+static u64 get_event_ ##member(struct kvm_event *event, int vcpu)	\
+{									\
+	if (vcpu == -1)							\
+		return event->total.member;				\
+									\
+	if (vcpu >= event->max_vcpu)					\
+		return 0;						\
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
+static bool select_key(void)
+{
+	int i;
+
+	for (i = 0; keys[i].name; i++) {
+		if (!strcmp(keys[i].name, sort_key)) {
+			compare = keys[i].key;
+			return true;
+		}
+	}
+
+	pr_err("Unknown compare key:%s\n", sort_key);
+	return false;
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
+	return !!get_event_count(event, vcpu);
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
+		pr_info("%10llu ", (unsigned long long)ecount);
+		pr_info("%8.2f%% ", (double)ecount / total_count * 100);
+		pr_info("%8.2f%% ", (double)etime / total_time * 100);
+		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
+			event_stats_stddev(trace_vcpu, event));
+		pr_info("\n");
+	}
+
+	pr_info("\nTotal Samples:%lld, Total events handled time:%.2fus.\n\n",
+		(unsigned long long)total_count, total_time / 1e3);
+}
+
+static int process_sample_event(struct perf_tool *tool __used,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
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
+	handle_kvm_event(thread, evsel->tp_format, sample->raw_data,
+			 sample->time);
+	return 0;
+}
+
+static struct perf_tool eops = {
+	.sample			= process_sample_event,
+	.comm			= perf_event__process_comm,
+	.ordered_samples	= true,
+};
+
+static int get_cpu_isa(struct perf_session *session)
+{
+	char *cpuid;
+	int isa;
+
+	cpuid = perf_header__read_feature(session, HEADER_CPUID);
+
+	if (!cpuid) {
+		pr_err("read HEADER_CPUID failed.\n");
+		return -ENOTSUP;
+	}
+
+	if (strstr(cpuid, "Intel"))
+		isa = 1;
+	else if (strstr(cpuid, "AMD"))
+		isa = 0;
+	else {
+		pr_err("CPU %s is not supported.\n", cpuid);
+		isa = -ENOTSUP;
+	}
+
+	free(cpuid);
+	return isa;
+}
+
+static const char *file_name;
+
+static int read_events(void)
+{
+	struct perf_session *kvm_session;
+	int ret;
+
+	kvm_session = perf_session__new(file_name, O_RDONLY, 0, false, &eops);
+	if (!kvm_session) {
+		pr_err("Initializing perf session failed\n");
+		return -EINVAL;
+	}
+
+	if (!perf_session__has_traces(kvm_session, "kvm record"))
+		return -EINVAL;
+
+	/*
+	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
+	 * traced in the old kernel.
+	 */
+	ret = get_cpu_isa(kvm_session);
+
+	if (ret < 0)
+		return ret;
+
+	cpu_isa = ret;
+
+	return perf_session__process_events(kvm_session, &eops);
+}
+
+static bool verify_vcpu(int vcpu)
+{
+	if (vcpu != -1 && vcpu < 0) {
+		pr_err("Invalid vcpu:%d.\n", vcpu);
+		return false;
+	}
+
+	return true;
+}
+
+static int kvm_events_report_vcpu(int vcpu)
+{
+	int ret = -EINVAL;
+
+	if (!verify_vcpu(vcpu))
+		goto exit;
+
+	if (!select_key())
+		goto exit;
+
+	if (!register_kvm_events_ops())
+		goto exit;
+
+	init_kvm_event_record();
+	setup_pager();
+
+	ret = read_events();
+	if (ret)
+		goto exit;
+
+	sort_result(vcpu);
+	print_result(vcpu);
+exit:
+	return ret;
+}
+
+static const char * const record_args[] = {
+	"record",
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
+	"kvm_io_done"
+};
+
+static bool kvm_record_specified_guest(int argc, const char **argv)
+{
+	int i;
+
+	for (i = 0; i < argc; i++)
+		if (!strcmp(argv[i], "-p") || !strcmp(argv[i], "--pid"))
+			return true;
+
+	return false;
+}
+
+#define STRDUP_FAIL_EXIT(s)		\
+	({	char *_p;		\
+		_p = strdup(s);		\
+		if (!_p)		\
+			return -ENOMEM;	\
+		_p;			\
+	})
+
+static int kvm_events_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc + 2;
+	rec_argc += ARRAY_SIZE(new_event) * 2;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
+
+	/*
+	 * Append "-a" only if "-p"/"--pid" is not specified since they
+	 * are mutually exclusive.
+	 */
+	if (!kvm_record_specified_guest(argc, argv))
+		rec_argv[i++] = STRDUP_FAIL_EXIT("-a");
+
+	rec_argv[i++] = STRDUP_FAIL_EXIT("-o");
+	rec_argv[i++] = STRDUP_FAIL_EXIT(file_name);
+
+	for (j = 0; j < ARRAY_SIZE(new_event); j++)
+		if (is_valid_tracepoint(new_event[j])) {
+			char event[256];
+
+			sprintf(event, "kvm:%s", new_event[j]);
+
+			rec_argv[i++] = STRDUP_FAIL_EXIT("-e");
+			rec_argv[i++] = STRDUP_FAIL_EXIT(event);
+		}
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+static const char * const kvm_events_report_usage[] = {
+	"perf kvm stat report [<options>]",
+	NULL
+};
+
+static const struct option kvm_events_report_options[] = {
+	OPT_STRING(0, "event", &report_event, "report event",
+		    "event for reporting: vmexit, mmio, ioport"),
+	OPT_INTEGER(0, "vcpu", &trace_vcpu,
+		    "vcpu id to report"),
+	OPT_STRING('k', "key", &sort_key, "sort-key",
+		    "key for sorting: sample(sort by samples number)"
+		    " time (sort by avg time)"),
+	OPT_END()
+};
+
+static int kvm_events_report(int argc, const char **argv)
+{
+	symbol__init();
+
+	if (argc) {
+		argc = parse_options(argc, argv,
+				     kvm_events_report_options,
+				     kvm_events_report_usage, 0);
+		if (argc)
+			usage_with_options(kvm_events_report_usage,
+					   kvm_events_report_options);
+	}
+
+	return kvm_events_report_vcpu(trace_vcpu);
+}
+
+static int kvm_cmd_stat(int argc, const char **argv)
+{
+	if (argc > 1) {
+		if (!strncmp(argv[1], "rec", 3))
+			return kvm_events_record(argc - 1, argv + 1);
+
+		if (!strncmp(argv[1], "rep", 3))
+			return kvm_events_report(argc - 1 , argv + 1);
+	}
+
+	return cmd_stat(argc, argv, NULL);
+}
+
 static char			name_buffer[256];
 
 static const char * const kvm_usage[] = {
-	"perf kvm [<options>] {top|record|report|diff|buildid-list}",
+	"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
 	NULL
 };
 
@@ -135,6 +1016,8 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __used)
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(argc, argv);
+	else if (!strncmp(argv[0], "stat", 4))
+		return kvm_cmd_stat(argc, argv);
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1e5b6aa..c684aba 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1504,9 +1504,15 @@ static int process_build_id(struct perf_file_section *section,
 	return 0;
 }
 
+static char *read_cpuid(struct perf_header *ph, int fd)
+{
+	return do_read_string(fd, ph);
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	char *(*read)(struct perf_header *h, int fd);
 	int (*process)(struct perf_file_section *section,
 		       struct perf_header *h, int feat, int fd, void *data);
 	const char *name;
@@ -1521,6 +1527,9 @@ struct feature_ops {
 #define FEAT_OPF(n, func) \
 	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
 		.full_only = true }
+#define FEAT_OPA_R(n, func) \
+	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
+		.read  = read_##func }
 
 /* feature_ops not implemented: */
 #define print_tracing_data	NULL
@@ -1535,7 +1544,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_ARCH,		arch),
 	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
 	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
-	FEAT_OPA(HEADER_CPUID,		cpuid),
+	FEAT_OPA_R(HEADER_CPUID,	cpuid),
 	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
 	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
 	FEAT_OPA(HEADER_CMDLINE,	cmdline),
@@ -1589,6 +1598,49 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 	return 0;
 }
 
+struct header_read_data {
+	int feat;
+	char *result;
+};
+
+static int perf_file_section__read_feature(struct perf_file_section *section,
+					   struct perf_header *ph,
+					   int feat, int fd, void *data)
+{
+	struct header_read_data *hd = data;
+
+	if (feat != hd->feat)
+		return 0;
+
+	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
+		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
+				"%d, continuing...\n", section->offset, feat);
+		return 0;
+	}
+
+	if (feat >= HEADER_LAST_FEATURE) {
+		pr_warning("unknown feature %d\n", feat);
+		return 0;
+	}
+
+	hd->result = feat_ops[feat].read(ph, fd);
+	return 0;
+}
+
+char *perf_header__read_feature(struct perf_session *session, int feat)
+{
+	struct perf_header *header = &session->header;
+	struct header_read_data hd;
+	int fd = session->fd;
+
+	hd.feat = feat;
+	hd.result = NULL;
+
+	perf_header__process_sections(header, fd, &hd,
+				  perf_file_section__read_feature);
+	return hd.result;
+}
+
 static int do_write_feat(int fd, struct perf_header *h, int type,
 			 struct perf_file_section **p,
 			 struct perf_evlist *evlist)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 24962e7..3b65aca 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -93,6 +93,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 				  int feat, int fd, void *data));
 
 int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
+char *perf_header__read_feature(struct perf_session *session, int feat);
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 70c2c13..f66610b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -16,6 +16,8 @@ struct thread {
 	bool			comm_set;
 	char			*comm;
 	int			comm_len;
+
+	void			*priv;
 };
 
 struct machine;
-- 
1.7.2.5

