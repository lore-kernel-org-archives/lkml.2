Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1CPNz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:55:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1CPNzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:55:23 -0400
Date: Wed, 16 Mar 2011 13:54:54 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1299734608-5223-5-git-send-email-daahern@cisco.com>
References: <1299734608-5223-5-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Support custom field selection for output
Message-ID: <tip-745f43e3433a7939bd9c351c8106e0c1db2044c6@git.kernel.org>
Git-Commit-ID: 745f43e3433a7939bd9c351c8106e0c1db2044c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:54:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  745f43e3433a7939bd9c351c8106e0c1db2044c6
Gitweb:     http://git.kernel.org/tip/745f43e3433a7939bd9c351c8106e0c1db2044c6
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 9 Mar 2011 22:23:26 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 17:06:16 -0300

perf script: Support custom field selection for output

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
