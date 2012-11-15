Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992593Ab2KOGRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:17:15 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48668 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2KOGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:17:13 -0500
Message-ID: <50A488DD.6090106@linux.vnet.ibm.com>
Date: Thu, 15 Nov 2012 14:17:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Josh Boyer <jwboyer@gmail.com>, David Howells <dhowells@redhat.com>,
        mingo@kernel.org, haodong@linux.vnet.ibm.com,
        runzhen@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/2] perf kvm: rename perf_kvm to perf_kvm_stat
References: <1378.1352379110@warthog.procyon.org.uk> <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com> <18065.1352820271@warthog.procyon.org.uk> <CA+5PVA6qaxCzr8RBV616D3kEXyj9XjS3okeZXhJJL1R4+-Yv_A@mail.gmail.com> <20121113163458.GA1023@ghostprotocols.net>
In-Reply-To: <20121113163458.GA1023@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111506-8256-0000-0000-00000503B702
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then, let it only be used in 'perf kvm stat'

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |  111 +++++++++++++++++++++++++---------------------
 1 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 836c82f..7fb426b 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -58,7 +58,7 @@ struct kvm_event_key {
 };


-struct perf_kvm;
+struct perf_kvm_stat;

 struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
@@ -66,7 +66,7 @@ struct kvm_events_ops {
 			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct perf_kvm *kvm, struct event_key *key,
+	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
 			   char decode[20]);
 	const char *name;
 };
@@ -79,7 +79,7 @@ struct exit_reasons_table {
 #define EVENTS_BITS		12
 #define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)

-struct perf_kvm {
+struct perf_kvm_stat {
 	struct perf_tool    tool;
 	struct perf_session *session;

@@ -146,7 +146,7 @@ static struct exit_reasons_table svm_exit_reasons[] = {
 	SVM_EXIT_REASONS
 };

-static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm_stat *kvm, u64 exit_code)
 {
 	int i = kvm->exit_reasons_size;
 	struct exit_reasons_table *tbl = kvm->exit_reasons;
@@ -162,7 +162,7 @@ static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
 	return "UNKNOWN";
 }

-static void exit_event_decode_key(struct perf_kvm *kvm,
+static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 				  struct event_key *key,
 				  char decode[20])
 {
@@ -228,7 +228,7 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
 	return false;
 }

-static void mmio_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				  struct event_key *key,
 				  char decode[20])
 {
@@ -271,7 +271,7 @@ static bool ioport_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }

-static void ioport_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				    struct event_key *key,
 				    char decode[20])
 {
@@ -286,7 +286,7 @@ static struct kvm_events_ops ioport_events = {
 	.name = "IO Port Access"
 };

-static bool register_kvm_events_ops(struct perf_kvm *kvm)
+static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 {
 	bool ret = true;

@@ -311,7 +311,7 @@ struct vcpu_event_record {
 };


-static void init_kvm_event_record(struct perf_kvm *kvm)
+static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 {
 	unsigned int i;

@@ -360,7 +360,7 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	return event;
 }

-static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
+static struct kvm_event *find_create_kvm_event(struct perf_kvm_stat *kvm,
 					       struct event_key *key)
 {
 	struct kvm_event *event;
@@ -382,7 +382,7 @@ static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
 	return event;
 }

-static bool handle_begin_event(struct perf_kvm *kvm,
+static bool handle_begin_event(struct perf_kvm_stat *kvm,
 			       struct vcpu_event_record *vcpu_record,
 			       struct event_key *key, u64 timestamp)
 {
@@ -429,7 +429,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }

-static bool handle_end_event(struct perf_kvm *kvm,
+static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
 			     u64 timestamp)
@@ -496,7 +496,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 	return thread->priv;
 }

-static bool handle_kvm_event(struct perf_kvm *kvm,
+static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 			     struct thread *thread,
 			     struct perf_evsel *evsel,
 			     struct perf_sample *sample)
@@ -556,7 +556,7 @@ static struct kvm_event_key keys[] = {
 	{ NULL, NULL }
 };

-static bool select_key(struct perf_kvm *kvm)
+static bool select_key(struct perf_kvm_stat *kvm)
 {
 	int i;

@@ -592,7 +592,8 @@ static void insert_to_result(struct rb_root *result, struct kvm_event *event,
 	rb_insert_color(&event->rb, result);
 }

-static void update_total_count(struct perf_kvm *kvm, struct kvm_event *event)
+static void
+update_total_count(struct perf_kvm_stat *kvm, struct kvm_event *event)
 {
 	int vcpu = kvm->trace_vcpu;

@@ -605,7 +606,7 @@ static bool event_is_valid(struct kvm_event *event, int vcpu)
 	return !!get_event_count(event, vcpu);
 }

-static void sort_result(struct perf_kvm *kvm)
+static void sort_result(struct perf_kvm_stat *kvm)
 {
 	unsigned int i;
 	int vcpu = kvm->trace_vcpu;
@@ -644,7 +645,7 @@ static void print_vcpu_info(int vcpu)
 		pr_info("VCPU %d:\n\n", vcpu);
 }

-static void print_result(struct perf_kvm *kvm)
+static void print_result(struct perf_kvm_stat *kvm)
 {
 	char decode[20];
 	struct kvm_event *event;
@@ -687,7 +688,8 @@ static int process_sample_event(struct perf_tool *tool,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->tid);
-	struct perf_kvm *kvm = container_of(tool, struct perf_kvm, tool);
+	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
+						 tool);

 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -718,7 +720,7 @@ static int get_cpu_isa(struct perf_session *session)
 	return isa;
 }

-static int read_events(struct perf_kvm *kvm)
+static int read_events(struct perf_kvm_stat *kvm)
 {
 	int ret;

@@ -767,7 +769,7 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }

-static int kvm_events_report_vcpu(struct perf_kvm *kvm)
+static int kvm_events_report_vcpu(struct perf_kvm_stat *kvm)
 {
 	int ret = -EINVAL;
 	int vcpu = kvm->trace_vcpu;
@@ -815,7 +817,8 @@ static const char * const record_args[] = {
 		_p;			\
 	})

-static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -838,7 +841,8 @@ static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }

-static int kvm_events_report(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	const struct option kvm_events_report_options[] = {
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
@@ -881,24 +885,36 @@ static void print_kvm_stat_usage(void)
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }

-static int kvm_cmd_stat(struct perf_kvm *kvm, int argc, const char **argv)
+static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 {
+	struct perf_kvm_stat kvm = {
+		.file_name = file_name,
+
+		.trace_vcpu	= -1,
+		.report_event	= "vmexit",
+		.sort_key	= "sample",
+
+		.exit_reasons = svm_exit_reasons,
+		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
+		.exit_reasons_isa = "SVM",
+	};
+
 	if (argc == 1) {
 		print_kvm_stat_usage();
 		goto perf_stat;
 	}

 	if (!strncmp(argv[1], "rec", 3))
-		return kvm_events_record(kvm, argc - 1, argv + 1);
+		return kvm_events_record(&kvm, argc - 1, argv + 1);

 	if (!strncmp(argv[1], "rep", 3))
-		return kvm_events_report(kvm, argc - 1 , argv + 1);
+		return kvm_events_report(&kvm, argc - 1 , argv + 1);

 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }

-static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
+static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -907,7 +923,7 @@ static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("record");
 	rec_argv[i++] = strdup("-o");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];

@@ -916,7 +932,7 @@ static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }

-static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
+static int __cmd_report(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -925,7 +941,7 @@ static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("report");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];

@@ -934,7 +950,8 @@ static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_report(i, rec_argv, NULL);
 }

-static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+__cmd_buildid_list(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -943,7 +960,7 @@ static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("buildid-list");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];

@@ -954,20 +971,12 @@ static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)

 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	struct perf_kvm kvm = {
-		.trace_vcpu	= -1,
-		.report_event	= "vmexit",
-		.sort_key	= "sample",
-
-		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
-		.exit_reasons_isa = "SVM",
-	};
+	const char *file_name;

 	const struct option kvm_options[] = {
-		OPT_STRING('i', "input", &kvm.file_name, "file",
+		OPT_STRING('i', "input", &file_name, "file",
 			   "Input file name"),
-		OPT_STRING('o', "output", &kvm.file_name, "file",
+		OPT_STRING('o', "output", &file_name, "file",
 			   "Output file name"),
 		OPT_BOOLEAN(0, "guest", &perf_guest,
 			    "Collect guest os data"),
@@ -1002,32 +1011,32 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!perf_host)
 		perf_guest = 1;

-	if (!kvm.file_name) {
+	if (!file_name) {
 		if (perf_host && !perf_guest)
-			kvm.file_name = strdup("perf.data.host");
+			file_name = strdup("perf.data.host");
 		else if (!perf_host && perf_guest)
-			kvm.file_name = strdup("perf.data.guest");
+			file_name = strdup("perf.data.guest");
 		else
-			kvm.file_name = strdup("perf.data.kvm");
+			file_name = strdup("perf.data.kvm");

-		if (!kvm.file_name) {
+		if (!file_name) {
 			pr_err("Failed to allocate memory for filename\n");
 			return -ENOMEM;
 		}
 	}

 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(&kvm, argc, argv);
+		return __cmd_record(file_name, argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
-		return __cmd_report(&kvm, argc, argv);
+		return __cmd_report(file_name, argc, argv);
 	else if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
 	else if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
-		return __cmd_buildid_list(&kvm, argc, argv);
+		return __cmd_buildid_list(file_name, argc, argv);
 	else if (!strncmp(argv[0], "stat", 4))
-		return kvm_cmd_stat(&kvm, argc, argv);
+		return kvm_cmd_stat(file_name, argc, argv);
 	else
 		usage_with_options(kvm_usage, kvm_options);

-- 
1.7.7.6

