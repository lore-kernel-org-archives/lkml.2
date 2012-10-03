Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab2JCEKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:10:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2JCEKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:10:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf kvm: move global variables into a perf_kvm struct
Date: Tue,  2 Oct 2012 22:09:53 -0600
Message-Id: <1349237393-86006-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleans up the builtin-kvm code in preparation for the live mode.
No functional changes; only code movement.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/builtin-kvm.c |  460 +++++++++++++++++++++++++---------------------
 1 file changed, 253 insertions(+), 207 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a28c9ca..260abc5 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -32,16 +32,76 @@ struct event_key {
 	int info;
 };
 
+struct kvm_event_stats {
+	u64 time;
+	struct stats stats;
+};
+
+struct kvm_event {
+	struct list_head hash_entry;
+	struct rb_node rb;
+
+	struct event_key key;
+
+	struct kvm_event_stats total;
+
+	#define DEFAULT_VCPU_NUM 8
+	int max_vcpu;
+	struct kvm_event_stats *vcpu;
+};
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+
+struct perf_kvm;
+
 struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct event_key *key, char decode[20]);
+	void (*decode_key)(struct perf_kvm *kvm, struct event_key *key,
+			   char decode[20]);
 	const char *name;
 };
 
+struct exit_reasons_table {
+	unsigned long exit_code;
+	const char *reason;
+};
+
+#define EVENTS_BITS		12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+struct perf_kvm {
+	struct perf_tool    tool;
+	struct perf_session *session;
+
+	const char *file_name;
+	const char *report_event;
+	const char *sort_key;
+	int trace_vcpu;
+
+	struct exit_reasons_table *exit_reasons;
+	int exit_reasons_size;
+	const char *exit_reasons_isa;
+
+	struct kvm_events_ops *events_ops;
+	key_cmp_fun compare;
+	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+	u64 total_time;
+	u64 total_count;
+
+	struct rb_root result;
+};
+
+
 static void exit_event_get_key(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       struct event_key *key)
@@ -78,45 +138,35 @@ static bool exit_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-struct exit_reasons_table {
-	unsigned long exit_code;
-	const char *reason;
-};
-
-struct exit_reasons_table vmx_exit_reasons[] = {
+static struct exit_reasons_table vmx_exit_reasons[] = {
 	VMX_EXIT_REASONS
 };
 
-struct exit_reasons_table svm_exit_reasons[] = {
+static struct exit_reasons_table svm_exit_reasons[] = {
 	SVM_EXIT_REASONS
 };
 
-static int cpu_isa;
-
-static const char *get_exit_reason(u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
 {
-	int table_size = ARRAY_SIZE(svm_exit_reasons);
-	struct exit_reasons_table *table = svm_exit_reasons;
-
-	if (cpu_isa == 1) {
-		table = vmx_exit_reasons;
-		table_size = ARRAY_SIZE(vmx_exit_reasons);
-	}
+	int i = kvm->exit_reasons_size;
+	struct exit_reasons_table *tbl = kvm->exit_reasons;
 
-	while (table_size--) {
-		if (table->exit_code == exit_code)
-			return table->reason;
-		table++;
+	while (i--) {
+		if (tbl->exit_code == exit_code)
+			return tbl->reason;
+		tbl++;
 	}
 
 	pr_err("unknown kvm exit code:%lld on %s\n",
-		(unsigned long long)exit_code, cpu_isa ? "VMX" : "SVM");
+		(unsigned long long)exit_code, kvm->exit_reasons_isa);
 	return "UNKNOWN";
 }
 
-static void exit_event_decode_key(struct event_key *key, char decode[20])
+static void exit_event_decode_key(struct perf_kvm *kvm,
+				  struct event_key *key,
+				  char decode[20])
 {
-	const char *exit_reason = get_exit_reason(key->key);
+	const char *exit_reason = get_exit_reason(kvm, key->key);
 
 	scnprintf(decode, 20, "%s", exit_reason);
 }
@@ -128,11 +178,11 @@ static struct kvm_events_ops exit_events = {
 	.name = "VM-EXIT"
 };
 
-    /*
-     * For the mmio events, we treat:
-     * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
-     * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
-     */
+/*
+ * For the mmio events, we treat:
+ * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
+ * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
+ */
 static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
 			       struct event_key *key)
 {
@@ -178,7 +228,9 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
 	return false;
 }
 
-static void mmio_event_decode_key(struct event_key *key, char decode[20])
+static void mmio_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+				  struct event_key *key,
+				  char decode[20])
 {
 	scnprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
 				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
@@ -219,7 +271,9 @@ static bool ioport_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-static void ioport_event_decode_key(struct event_key *key, char decode[20])
+static void ioport_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+				    struct event_key *key,
+				    char decode[20])
 {
 	scnprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
 				key->info ? "POUT" : "PIN");
@@ -232,64 +286,37 @@ static struct kvm_events_ops ioport_events = {
 	.name = "IO Port Access"
 };
 
-static const char *report_event = "vmexit";
-struct kvm_events_ops *events_ops;
-
-static bool register_kvm_events_ops(void)
+static bool register_kvm_events_ops(struct perf_kvm *kvm)
 {
 	bool ret = true;
 
-	if (!strcmp(report_event, "vmexit"))
-		events_ops = &exit_events;
-	else if (!strcmp(report_event, "mmio"))
-		events_ops = &mmio_events;
-	else if (!strcmp(report_event, "ioport"))
-		events_ops = &ioport_events;
+	if (!strcmp(kvm->report_event, "vmexit"))
+		kvm->events_ops = &exit_events;
+	else if (!strcmp(kvm->report_event, "mmio"))
+		kvm->events_ops = &mmio_events;
+	else if (!strcmp(kvm->report_event, "ioport"))
+		kvm->events_ops = &ioport_events;
 	else {
-		pr_err("Unknown report event:%s\n", report_event);
+		pr_err("Unknown report event:%s\n", kvm->report_event);
 		ret = false;
 	}
 
 	return ret;
 }
 
-struct kvm_event_stats {
-	u64 time;
-	struct stats stats;
-};
-
-struct kvm_event {
-	struct list_head hash_entry;
-	struct rb_node rb;
-
-	struct event_key key;
-
-	struct kvm_event_stats total;
-
-	#define DEFAULT_VCPU_NUM 8
-	int max_vcpu;
-	struct kvm_event_stats *vcpu;
-};
-
 struct vcpu_event_record {
 	int vcpu_id;
 	u64 start_time;
 	struct kvm_event *last_event;
 };
 
-#define EVENTS_BITS			12
-#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
-
-static u64 total_time;
-static u64 total_count;
-static struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
 
-static void init_kvm_event_record(void)
+static void init_kvm_event_record(struct perf_kvm *kvm)
 {
 	int i;
 
 	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
-		INIT_LIST_HEAD(&kvm_events_cache[i]);
+		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
 static int kvm_events_hash_fn(u64 key)
@@ -333,14 +360,15 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	return event;
 }
 
-static struct kvm_event *find_create_kvm_event(struct event_key *key)
+static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
+					       struct event_key *key)
 {
 	struct kvm_event *event;
 	struct list_head *head;
 
 	BUG_ON(key->key == INVALID_KEY);
 
-	head = &kvm_events_cache[kvm_events_hash_fn(key->key)];
+	head = &kvm->kvm_events_cache[kvm_events_hash_fn(key->key)];
 	list_for_each_entry(event, head, hash_entry)
 		if (event->key.key == key->key && event->key.info == key->info)
 			return event;
@@ -353,13 +381,14 @@ static struct kvm_event *find_create_kvm_event(struct event_key *key)
 	return event;
 }
 
-static bool handle_begin_event(struct vcpu_event_record *vcpu_record,
+static bool handle_begin_event(struct perf_kvm *kvm,
+			       struct vcpu_event_record *vcpu_record,
 			       struct event_key *key, u64 timestamp)
 {
 	struct kvm_event *event = NULL;
 
 	if (key->key != INVALID_KEY)
-		event = find_create_kvm_event(key);
+		event = find_create_kvm_event(kvm, key);
 
 	vcpu_record->last_event = event;
 	vcpu_record->start_time = timestamp;
@@ -396,8 +425,10 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
-static bool handle_end_event(struct vcpu_event_record *vcpu_record,
-			     struct event_key *key, u64 timestamp)
+static bool handle_end_event(struct perf_kvm *kvm,
+			     struct vcpu_event_record *vcpu_record,
+			     struct event_key *key,
+			     u64 timestamp)
 {
 	struct kvm_event *event;
 	u64 time_begin, time_diff;
@@ -419,7 +450,7 @@ static bool handle_end_event(struct vcpu_event_record *vcpu_record,
 		return true;
 
 	if (!event)
-		event = find_create_kvm_event(key);
+		event = find_create_kvm_event(kvm, key);
 
 	if (!event)
 		return false;
@@ -455,7 +486,9 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 	return thread->priv;
 }
 
-static bool handle_kvm_event(struct thread *thread, struct perf_evsel *evsel,
+static bool handle_kvm_event(struct perf_kvm *kvm,
+			     struct thread *thread,
+			     struct perf_evsel *evsel,
 			     struct perf_sample *sample)
 {
 	struct vcpu_event_record *vcpu_record;
@@ -465,22 +498,15 @@ static bool handle_kvm_event(struct thread *thread, struct perf_evsel *evsel,
 	if (!vcpu_record)
 		return true;
 
-	if (events_ops->is_begin_event(evsel, sample, &key))
-		return handle_begin_event(vcpu_record, &key, sample->time);
+	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
+		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
-	if (events_ops->is_end_event(evsel, sample, &key))
-		return handle_end_event(vcpu_record, &key, sample->time);
+	if (kvm->events_ops->is_end_event(evsel, sample, &key))
+		return handle_end_event(kvm, vcpu_record, &key, sample->time);
 
 	return true;
 }
 
-typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
-struct kvm_event_key {
-	const char *name;
-	key_cmp_fun key;
-};
-
-static int trace_vcpu = -1;
 #define GET_EVENT_KEY(func, field)					\
 static u64 get_event_ ##func(struct kvm_event *event, int vcpu)		\
 {									\
@@ -515,29 +541,25 @@ static struct kvm_event_key keys[] = {
 	{ NULL, NULL }
 };
 
-static const char *sort_key = "sample";
-static key_cmp_fun compare;
-
-static bool select_key(void)
+static bool select_key(struct perf_kvm *kvm)
 {
 	int i;
 
 	for (i = 0; keys[i].name; i++) {
-		if (!strcmp(keys[i].name, sort_key)) {
-			compare = keys[i].key;
+		if (!strcmp(keys[i].name, kvm->sort_key)) {
+			kvm->compare = keys[i].key;
 			return true;
 		}
 	}
 
-	pr_err("Unknown compare key:%s\n", sort_key);
+	pr_err("Unknown compare key:%s\n", kvm->sort_key);
 	return false;
 }
 
-static struct rb_root result;
-static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
-			     int vcpu)
+static void insert_to_result(struct rb_root *result, struct kvm_event *event,
+			     key_cmp_fun bigger, int vcpu)
 {
-	struct rb_node **rb = &result.rb_node;
+	struct rb_node **rb = &result->rb_node;
 	struct rb_node *parent = NULL;
 	struct kvm_event *p;
 
@@ -552,13 +574,15 @@ static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
 	}
 
 	rb_link_node(&event->rb, parent, rb);
-	rb_insert_color(&event->rb, &result);
+	rb_insert_color(&event->rb, result);
 }
 
-static void update_total_count(struct kvm_event *event, int vcpu)
+static void update_total_count(struct perf_kvm *kvm, struct kvm_event *event)
 {
-	total_count += get_event_count(event, vcpu);
-	total_time += get_event_time(event, vcpu);
+	int vcpu = kvm->trace_vcpu;
+
+	kvm->total_count += get_event_count(event, vcpu);
+	kvm->total_time += get_event_time(event, vcpu);
 }
 
 static bool event_is_valid(struct kvm_event *event, int vcpu)
@@ -566,28 +590,30 @@ static bool event_is_valid(struct kvm_event *event, int vcpu)
 	return !!get_event_count(event, vcpu);
 }
 
-static void sort_result(int vcpu)
+static void sort_result(struct perf_kvm *kvm)
 {
 	unsigned int i;
+	int vcpu = kvm->trace_vcpu;
 	struct kvm_event *event;
 
 	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
-		list_for_each_entry(event, &kvm_events_cache[i], hash_entry)
+		list_for_each_entry(event, &kvm->kvm_events_cache[i], hash_entry)
 			if (event_is_valid(event, vcpu)) {
-				update_total_count(event, vcpu);
-				insert_to_result(event, compare, vcpu);
+				update_total_count(kvm, event);
+				insert_to_result(&kvm->result, event,
+						 kvm->compare, vcpu);
 			}
 }
 
 /* returns left most element of result, and erase it */
-static struct kvm_event *pop_from_result(void)
+static struct kvm_event *pop_from_result(struct rb_root *result)
 {
-	struct rb_node *node = rb_first(&result);
+	struct rb_node *node = rb_first(result);
 
 	if (!node)
 		return NULL;
 
-	rb_erase(node, &result);
+	rb_erase(node, result);
 	return container_of(node, struct kvm_event, rb);
 }
 
@@ -601,14 +627,15 @@ static void print_vcpu_info(int vcpu)
 		pr_info("VCPU %d:\n\n", vcpu);
 }
 
-static void print_result(int vcpu)
+static void print_result(struct perf_kvm *kvm)
 {
 	char decode[20];
 	struct kvm_event *event;
+	int vcpu = kvm->trace_vcpu;
 
 	pr_info("\n\n");
 	print_vcpu_info(vcpu);
-	pr_info("%20s ", events_ops->name);
+	pr_info("%20s ", kvm->events_ops->name);
 	pr_info("%10s ", "Samples");
 	pr_info("%9s ", "Samples%");
 
@@ -616,33 +643,34 @@ static void print_result(int vcpu)
 	pr_info("%16s ", "Avg time");
 	pr_info("\n\n");
 
-	while ((event = pop_from_result())) {
+	while ((event = pop_from_result(&kvm->result))) {
 		u64 ecount, etime;
 
 		ecount = get_event_count(event, vcpu);
 		etime = get_event_time(event, vcpu);
 
-		events_ops->decode_key(&event->key, decode);
+		kvm->events_ops->decode_key(kvm, &event->key, decode);
 		pr_info("%20s ", decode);
 		pr_info("%10llu ", (unsigned long long)ecount);
-		pr_info("%8.2f%% ", (double)ecount / total_count * 100);
-		pr_info("%8.2f%% ", (double)etime / total_time * 100);
+		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
+		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
 		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
 			kvm_event_rel_stddev(vcpu, event));
 		pr_info("\n");
 	}
 
 	pr_info("\nTotal Samples:%lld, Total events handled time:%.2fus.\n\n",
-		(unsigned long long)total_count, total_time / 1e3);
+		(unsigned long long)kvm->total_count, kvm->total_time / 1e3);
 }
 
-static int process_sample_event(struct perf_tool *tool __maybe_unused,
+static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct perf_kvm *kvm = container_of(tool, struct perf_kvm, tool);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -650,18 +678,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (!handle_kvm_event(thread, evsel, sample))
+	if (!handle_kvm_event(kvm, thread, evsel, sample))
 		return -1;
 
 	return 0;
 }
 
-static struct perf_tool eops = {
-	.sample			= process_sample_event,
-	.comm			= perf_event__process_comm,
-	.ordered_samples	= true,
-};
-
 static int get_cpu_isa(struct perf_session *session)
 {
 	char *cpuid = session->header.env.cpuid;
@@ -679,34 +701,43 @@ static int get_cpu_isa(struct perf_session *session)
 	return isa;
 }
 
-static const char *file_name;
-
-static int read_events(void)
+static int read_events(struct perf_kvm *kvm)
 {
-	struct perf_session *kvm_session;
 	int ret;
 
-	kvm_session = perf_session__new(file_name, O_RDONLY, 0, false, &eops);
-	if (!kvm_session) {
+	struct perf_tool eops = {
+		.sample			= process_sample_event,
+		.comm			= perf_event__process_comm,
+		.ordered_samples	= true,
+	};
+
+	kvm->tool = eops;
+	kvm->session = perf_session__new(kvm->file_name, O_RDONLY, 0, false,
+					 &kvm->tool);
+	if (!kvm->session) {
 		pr_err("Initializing perf session failed\n");
 		return -EINVAL;
 	}
 
-	if (!perf_session__has_traces(kvm_session, "kvm record"))
+	if (!perf_session__has_traces(kvm->session, "kvm record"))
 		return -EINVAL;
 
 	/*
 	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
 	 * traced in the old kernel.
 	 */
-	ret = get_cpu_isa(kvm_session);
+	ret = get_cpu_isa(kvm->session);
 
 	if (ret < 0)
 		return ret;
 
-	cpu_isa = ret;
+	if (ret == 1) {
+		kvm->exit_reasons = vmx_exit_reasons;
+		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
+		kvm->exit_reasons_isa = "VMX";
+	}
 
-	return perf_session__process_events(kvm_session, &eops);
+	return perf_session__process_events(kvm->session, &kvm->tool);
 }
 
 static bool verify_vcpu(int vcpu)
@@ -719,28 +750,30 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-static int kvm_events_report_vcpu(int vcpu)
+static int kvm_events_report_vcpu(struct perf_kvm *kvm)
 {
 	int ret = -EINVAL;
+	int vcpu = kvm->trace_vcpu;
 
 	if (!verify_vcpu(vcpu))
 		goto exit;
 
-	if (!select_key())
+	if (!select_key(kvm))
 		goto exit;
 
-	if (!register_kvm_events_ops())
+	if (!register_kvm_events_ops(kvm))
 		goto exit;
 
-	init_kvm_event_record();
+	init_kvm_event_record(kvm);
 	setup_pager();
 
-	ret = read_events();
+	ret = read_events(kvm);
 	if (ret)
 		goto exit;
 
-	sort_result(vcpu);
-	print_result(vcpu);
+	sort_result(kvm);
+	print_result(kvm);
+
 exit:
 	return ret;
 }
@@ -765,7 +798,7 @@ static const char * const record_args[] = {
 		_p;			\
 	})
 
-static int kvm_events_record(int argc, const char **argv)
+static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -780,7 +813,7 @@ static int kvm_events_record(int argc, const char **argv)
 		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
 
 	rec_argv[i++] = STRDUP_FAIL_EXIT("-o");
-	rec_argv[i++] = STRDUP_FAIL_EXIT(file_name);
+	rec_argv[i++] = STRDUP_FAIL_EXIT(kvm->file_name);
 
 	for (j = 1; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
@@ -788,24 +821,24 @@ static int kvm_events_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static const char * const kvm_events_report_usage[] = {
-	"perf kvm stat report [<options>]",
-	NULL
-};
+static int kvm_events_report(struct perf_kvm *kvm, int argc, const char **argv)
+{
+	const struct option kvm_events_report_options[] = {
+		OPT_STRING(0, "event", &kvm->report_event, "report event",
+			    "event for reporting: vmexit, mmio, ioport"),
+		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
+			    "vcpu id to report"),
+		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
+			    "key for sorting: sample(sort by samples number)"
+			    " time (sort by avg time)"),
+		OPT_END()
+	};
 
-static const struct option kvm_events_report_options[] = {
-	OPT_STRING(0, "event", &report_event, "report event",
-		    "event for reporting: vmexit, mmio, ioport"),
-	OPT_INTEGER(0, "vcpu", &trace_vcpu,
-		    "vcpu id to report"),
-	OPT_STRING('k', "key", &sort_key, "sort-key",
-		    "key for sorting: sample(sort by samples number)"
-		    " time (sort by avg time)"),
-	OPT_END()
-};
+	const char * const kvm_events_report_usage[] = {
+		"perf kvm stat report [<options>]",
+		NULL
+	};
 
-static int kvm_events_report(int argc, const char **argv)
-{
 	symbol__init();
 
 	if (argc) {
@@ -817,7 +850,7 @@ static int kvm_events_report(int argc, const char **argv)
 					   kvm_events_report_options);
 	}
 
-	return kvm_events_report_vcpu(trace_vcpu);
+	return kvm_events_report_vcpu(kvm);
 }
 
 static void print_kvm_stat_usage(void)
@@ -831,7 +864,7 @@ static void print_kvm_stat_usage(void)
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }
 
-static int kvm_cmd_stat(int argc, const char **argv)
+static int kvm_cmd_stat(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	if (argc == 1) {
 		print_kvm_stat_usage();
@@ -839,44 +872,16 @@ static int kvm_cmd_stat(int argc, const char **argv)
 	}
 
 	if (!strncmp(argv[1], "rec", 3))
-		return kvm_events_record(argc - 1, argv + 1);
+		return kvm_events_record(kvm, argc - 1, argv + 1);
 
 	if (!strncmp(argv[1], "rep", 3))
-		return kvm_events_report(argc - 1 , argv + 1);
+		return kvm_events_report(kvm, argc - 1 , argv + 1);
 
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
 
-static char			name_buffer[256];
-
-static const char * const kvm_usage[] = {
-	"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
-	NULL
-};
-
-static const struct option kvm_options[] = {
-	OPT_STRING('i', "input", &file_name, "file",
-		   "Input file name"),
-	OPT_STRING('o', "output", &file_name, "file",
-		   "Output file name"),
-	OPT_BOOLEAN(0, "guest", &perf_guest,
-		    "Collect guest os data"),
-	OPT_BOOLEAN(0, "host", &perf_host,
-		    "Collect host os data"),
-	OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
-		   "guest mount directory under which every guest os"
-		   " instance has a subdir"),
-	OPT_STRING(0, "guestvmlinux", &symbol_conf.default_guest_vmlinux_name,
-		   "file", "file saving guest os vmlinux"),
-	OPT_STRING(0, "guestkallsyms", &symbol_conf.default_guest_kallsyms,
-		   "file", "file saving guest os /proc/kallsyms"),
-	OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
-		   "file", "file saving guest os /proc/modules"),
-	OPT_END()
-};
-
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -885,7 +890,7 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("record");
 	rec_argv[i++] = strdup("-o");
-	rec_argv[i++] = strdup(file_name);
+	rec_argv[i++] = strdup(kvm->file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -894,7 +899,7 @@ static int __cmd_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static int __cmd_report(int argc, const char **argv)
+static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -903,7 +908,7 @@ static int __cmd_report(int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("report");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(file_name);
+	rec_argv[i++] = strdup(kvm->file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -912,7 +917,7 @@ static int __cmd_report(int argc, const char **argv)
 	return cmd_report(i, rec_argv, NULL);
 }
 
-static int __cmd_buildid_list(int argc, const char **argv)
+static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -921,7 +926,7 @@ static int __cmd_buildid_list(int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("buildid-list");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(file_name);
+	rec_argv[i++] = strdup(kvm->file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -932,6 +937,43 @@ static int __cmd_buildid_list(int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	struct perf_kvm kvm = {
+		.trace_vcpu	= -1,
+		.report_event	= "vmexit",
+		.sort_key	= "sample",
+
+		.exit_reasons = svm_exit_reasons,
+		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
+		.exit_reasons_isa = "SVM",
+	};
+
+	const struct option kvm_options[] = {
+		OPT_STRING('i', "input", &kvm.file_name, "file",
+			   "Input file name"),
+		OPT_STRING('o', "output", &kvm.file_name, "file",
+			   "Output file name"),
+		OPT_BOOLEAN(0, "guest", &perf_guest,
+			    "Collect guest os data"),
+		OPT_BOOLEAN(0, "host", &perf_host,
+			    "Collect host os data"),
+		OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
+			   "guest mount directory under which every guest os"
+			   " instance has a subdir"),
+		OPT_STRING(0, "guestvmlinux", &symbol_conf.default_guest_vmlinux_name,
+			   "file", "file saving guest os vmlinux"),
+		OPT_STRING(0, "guestkallsyms", &symbol_conf.default_guest_kallsyms,
+			   "file", "file saving guest os /proc/kallsyms"),
+		OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
+			   "file", "file saving guest os /proc/modules"),
+		OPT_END()
+	};
+
+
+	const char * const kvm_usage[] = {
+		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
+		NULL
+	};
+
 	perf_host  = 0;
 	perf_guest = 1;
 
@@ -943,28 +985,32 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!perf_host)
 		perf_guest = 1;
 
-	if (!file_name) {
+	if (!kvm.file_name) {
 		if (perf_host && !perf_guest)
-			sprintf(name_buffer, "perf.data.host");
+			kvm.file_name = strdup("perf.data.host");
 		else if (!perf_host && perf_guest)
-			sprintf(name_buffer, "perf.data.guest");
+			kvm.file_name = strdup("perf.data.guest");
 		else
-			sprintf(name_buffer, "perf.data.kvm");
-		file_name = name_buffer;
+			kvm.file_name = strdup("perf.data.kvm");
+
+		if (!kvm.file_name) {
+			pr_err("Failed to allocate memory for filename\n");
+			return -ENOMEM;
+		}
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
+		return __cmd_record(&kvm, argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
-		return __cmd_report(argc, argv);
+		return __cmd_report(&kvm, argc, argv);
 	else if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
 	else if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
-		return __cmd_buildid_list(argc, argv);
+		return __cmd_buildid_list(&kvm, argc, argv);
 	else if (!strncmp(argv[0], "stat", 4))
-		return kvm_cmd_stat(argc, argv);
+		return kvm_cmd_stat(&kvm, argc, argv);
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
-- 
1.7.10.1

