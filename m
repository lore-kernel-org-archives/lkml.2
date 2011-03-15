Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab1COUF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab1COUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/12] perf script: Support custom field selection for output
Date: Tue, 15 Mar 2011 17:04:58 -0300
Message-Id: <1300219501-15085-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300219501-15085-1-git-send-email-acme@infradead.org>
References: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <daahern@cisco.com>

Allow a user to select which fields to print to stdout for event data.
Options include comm (command name), tid (thread id), pid (process id),
time (perf timestamp), cpu, event (for event name), and trace (for
trace data).

Default is set to maintain compatibility with current output; this
feature does alter output format slightly -- no '-' between command
and pid/tid.

Thanks to Frederic Weisbecker for detailed suggestions on this approach.

Examples (output compressed)

1. trace, default format

perf record -ga -e sched:sched_switch
perf script

swapper    0 [000] 537.037184: sched_switch: prev_comm=swapper prev_pid=0...
   sshd 1675 [000] 537.037309: sched_switch: prev_comm=sshd prev_pid=1675...
netstat 1692 [001] 537.038664: sched_switch: prev_comm=netstat prev_pid=1692...

2. trace, custom format

perf record -ga -e sched:sched_switch
perf script -f comm,pid,time,trace     <--- omitting cpu and event name

swapper    0 537.037184: prev_comm=swapper prev_pid=0 prev_prio=120 ...
   sshd 1675 537.037309: prev_comm=sshd prev_pid=1675 prev_prio=120 ...
netstat 1692 537.038664: prev_comm=netstat prev_pid=1692 prev_prio=120 ...

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-5-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |    5 +
 tools/perf/builtin-script.c              |  141 ++++++++++++++++++++++++++----
 2 files changed, 130 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 29ad942..b73cf58 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -112,6 +112,11 @@ OPTIONS
 --debug-mode::
         Do various checks like samples ordering and lost events.
 
+-f::
+--fields
+        Comma separated list of fields to print. Options are:
+        comm, tid, pid, time, cpu, event, trace
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 0a79da2..c046e6e 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -20,6 +20,38 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 
+enum perf_output_field {
+	PERF_OUTPUT_COMM            = 1U << 0,
+	PERF_OUTPUT_TID             = 1U << 1,
+	PERF_OUTPUT_PID             = 1U << 2,
+	PERF_OUTPUT_TIME            = 1U << 3,
+	PERF_OUTPUT_CPU             = 1U << 4,
+	PERF_OUTPUT_EVNAME          = 1U << 5,
+	PERF_OUTPUT_TRACE           = 1U << 6,
+};
+
+struct output_option {
+	const char *str;
+	enum perf_output_field field;
+} all_output_options[] = {
+	{.str = "comm",  .field = PERF_OUTPUT_COMM},
+	{.str = "tid",   .field = PERF_OUTPUT_TID},
+	{.str = "pid",   .field = PERF_OUTPUT_PID},
+	{.str = "time",  .field = PERF_OUTPUT_TIME},
+	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
+	{.str = "event", .field = PERF_OUTPUT_EVNAME},
+	{.str = "trace", .field = PERF_OUTPUT_TRACE},
+};
+
+/* default set to maintain compatibility with current format */
+static u64 output_fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
+			   PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
+			   PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE;
+
+static bool output_set_by_user;
+
+#define PRINT_FIELD(x)  (output_fields & PERF_OUTPUT_##x)
+
 static void print_sample_start(struct perf_sample *sample,
 			       struct thread *thread)
 {
@@ -28,24 +60,45 @@ static void print_sample_start(struct perf_sample *sample,
 	const char *evname = NULL;
 	unsigned long secs;
 	unsigned long usecs;
-	unsigned long long nsecs = sample->time;
+	unsigned long long nsecs;
+
+	if (PRINT_FIELD(COMM)) {
+		if (latency_format)
+			printf("%8.8s ", thread->comm);
+		else
+			printf("%16s ", thread->comm);
+	}
 
-	if (latency_format)
-		printf("%8.8s-%-5d %3d", thread->comm, sample->tid, sample->cpu);
-	else
-		printf("%16s-%-5d [%03d]", thread->comm, sample->tid, sample->cpu);
+	if (PRINT_FIELD(PID) && PRINT_FIELD(TID))
+		printf("%5d/%-5d ", sample->pid, sample->tid);
+	else if (PRINT_FIELD(PID))
+		printf("%5d ", sample->pid);
+	else if (PRINT_FIELD(TID))
+		printf("%5d ", sample->tid);
+
+	if (PRINT_FIELD(CPU)) {
+		if (latency_format)
+			printf("%3d ", sample->cpu);
+		else
+			printf("[%03d] ", sample->cpu);
+	}
 
-	secs = nsecs / NSECS_PER_SEC;
-	nsecs -= secs * NSECS_PER_SEC;
-	usecs = nsecs / NSECS_PER_USEC;
-	printf(" %5lu.%06lu: ", secs, usecs);
+	if (PRINT_FIELD(TIME)) {
+		nsecs = sample->time;
+		secs = nsecs / NSECS_PER_SEC;
+		nsecs -= secs * NSECS_PER_SEC;
+		usecs = nsecs / NSECS_PER_USEC;
+		printf("%5lu.%06lu: ", secs, usecs);
+	}
 
-	type = trace_parse_common_type(sample->raw_data);
-	event = trace_find_event(type);
-	if (event)
-		evname = event->name;
+	if (PRINT_FIELD(EVNAME)) {
+		type = trace_parse_common_type(sample->raw_data);
+		event = trace_find_event(type);
+		if (event)
+			evname = event->name;
 
-	printf("%s: ", evname ? evname : "(unknown)");
+		printf("%s: ", evname ? evname : "(unknown)");
+	}
 }
 
 static void process_event(union perf_event *event __unused,
@@ -54,7 +107,11 @@ static void process_event(union perf_event *event __unused,
 			  struct thread *thread)
 {
 	print_sample_start(sample, thread);
-	print_trace_event(sample->cpu, sample->raw_data, sample->raw_size);
+
+	if (PRINT_FIELD(TRACE))
+		print_trace_event(sample->cpu, sample->raw_data,
+				  sample->raw_size);
+
 	printf("\n");
 }
 
@@ -311,6 +368,48 @@ static int parse_scriptname(const struct option *opt __used,
 	return 0;
 }
 
+static int parse_output_fields(const struct option *opt __used,
+			    const char *arg, int unset __used)
+{
+	char *tok;
+	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int rc = 0;
+	char *str = strdup(arg);
+
+	if (!str)
+		return -ENOMEM;
+
+	tok = strtok(str, ",");
+	if (!tok) {
+		fprintf(stderr, "Invalid field string.");
+		return -EINVAL;
+	}
+
+	output_fields = 0;
+	while (1) {
+		for (i = 0; i < imax; ++i) {
+			if (strcmp(tok, all_output_options[i].str) == 0) {
+				output_fields |= all_output_options[i].field;
+				break;
+			}
+		}
+		if (i == imax) {
+			fprintf(stderr, "Invalid field requested.");
+			rc = -EINVAL;
+			break;
+		}
+
+		tok = strtok(NULL, ",");
+		if (!tok)
+			break;
+	}
+
+	output_set_by_user = true;
+
+	free(str);
+	return rc;
+}
+
 /* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
 static int is_directory(const char *base_path, const struct dirent *dent)
 {
@@ -623,6 +722,9 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_CALLBACK('f', "fields", NULL, "str",
+		     "comma separated output fields. Options: comm,tid,pid,time,cpu,event,trace",
+		     parse_output_fields),
 
 	OPT_END()
 };
@@ -809,8 +911,15 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 
 	if (generate_script_lang) {
 		struct stat perf_stat;
+		int input;
+
+		if (output_set_by_user) {
+			fprintf(stderr,
+				"custom fields not supported for generated scripts");
+			return -1;
+		}
 
-		int input = open(input_name, O_RDONLY);
+		input = open(input_name, O_RDONLY);
 		if (input < 0) {
 			perror("failed to open file");
 			exit(-1);
-- 
1.6.2.5

