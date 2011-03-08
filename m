Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1CHRpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 12:45:18 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:50863 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1CHRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 12:45:12 -0500
X-IronPort-AV: E=Sophos;i="4.62,285,1297036800"; 
   d="scan'208";a="272624676"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 2/5] perf script: move printing of 'common' data from print_event and rename
Date: Tue,  8 Mar 2011 10:45:39 -0700
Message-Id: <1299606342-26745-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299606342-26745-1-git-send-email-daahern@cisco.com>
References: <1299606342-26745-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change does impact output: latency data is trace specific and is now
printed after the common data - comm, tid, cpu, time and event name.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-script.c         |   38 ++++++++++--
 tools/perf/util/trace-event-parse.c |  106 +++--------------------------------
 tools/perf/util/trace-event.h       |    3 +-
 3 files changed, 40 insertions(+), 107 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b2bdd55..0a79da2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -20,18 +20,42 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 
+static void print_sample_start(struct perf_sample *sample,
+			       struct thread *thread)
+{
+	int type;
+	struct event *event;
+	const char *evname = NULL;
+	unsigned long secs;
+	unsigned long usecs;
+	unsigned long long nsecs = sample->time;
+
+	if (latency_format)
+		printf("%8.8s-%-5d %3d", thread->comm, sample->tid, sample->cpu);
+	else
+		printf("%16s-%-5d [%03d]", thread->comm, sample->tid, sample->cpu);
+
+	secs = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs = nsecs / NSECS_PER_USEC;
+	printf(" %5lu.%06lu: ", secs, usecs);
+
+	type = trace_parse_common_type(sample->raw_data);
+	event = trace_find_event(type);
+	if (event)
+		evname = event->name;
+
+	printf("%s: ", evname ? evname : "(unknown)");
+}
+
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_session *session __unused,
 			  struct thread *thread)
 {
-	/*
-	 * FIXME: better resolve from pid from the struct trace_entry
-	 * field, although it should be the same than this perf
-	 * event pid
-	 */
-	print_event(sample->cpu, sample->raw_data, sample->raw_size,
-		    sample->time, thread->comm);
+	print_sample_start(sample, thread);
+	print_trace_event(sample->cpu, sample->raw_data, sample->raw_size);
+	printf("\n");
 }
 
 static int default_start_script(const char *script __unused,
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8e622d..3717f06 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2648,63 +2648,8 @@ static void print_lat_fmt(void *data, int size __unused)
 		printf("%d", lock_depth);
 }
 
-/* taken from Linux, written by Frederic Weisbecker */
-static void print_graph_cpu(int cpu)
-{
-	int i;
-	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpus);
-
-
-	/*
-	 * Start with a space character - to make it stand out
-	 * to the right a bit when trace output is pasted into
-	 * email:
-	 */
-	printf(" ");
-
-	/*
-	 * Tricky - we space the CPU field according to the max
-	 * number of online CPUs. On a 2-cpu system it would take
-	 * a maximum of 1 digit - on a 128 cpu system it would
-	 * take up to 3 digits:
-	 */
-	for (i = 0; i < log10_all - log10_this; i++)
-		printf(" ");
-
-	printf("%d) ", cpu);
-}
-
-#define TRACE_GRAPH_PROCINFO_LENGTH	14
 #define TRACE_GRAPH_INDENT	2
 
-static void print_graph_proc(int pid, const char *comm)
-{
-	/* sign + log10(MAX_INT) + '\0' */
-	char pid_str[11];
-	int spaces = 0;
-	int len;
-	int i;
-
-	sprintf(pid_str, "%d", pid);
-
-	/* 1 stands for the "-" character */
-	len = strlen(comm) + strlen(pid_str) + 1;
-
-	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
-		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
-
-	/* First spaces to align center */
-	for (i = 0; i < spaces / 2; i++)
-		printf(" ");
-
-	printf("%s-%s", comm, pid_str);
-
-	/* Last spaces to align center */
-	for (i = 0; i < spaces - (spaces / 2); i++)
-		printf(" ");
-}
-
 static struct record *
 get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 		    struct record *next)
@@ -2876,21 +2821,13 @@ static void print_graph_nested(struct event *event, void *data)
 
 static void
 pretty_print_func_ent(void *data, int size, struct event *event,
-		      int cpu, int pid, const char *comm,
-		      unsigned long secs, unsigned long usecs)
+		      int cpu, int pid)
 {
 	struct format_field *field;
 	struct record *rec;
 	void *copy_data;
 	unsigned long val;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
-
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
-	printf(" | ");
-
 	if (latency_format) {
 		print_lat_fmt(data, size);
 		printf(" | ");
@@ -2923,22 +2860,13 @@ out_free:
 }
 
 static void
-pretty_print_func_ret(void *data, int size __unused, struct event *event,
-		      int cpu, int pid, const char *comm,
-		      unsigned long secs, unsigned long usecs)
+pretty_print_func_ret(void *data, int size __unused, struct event *event)
 {
 	unsigned long long rettime, calltime;
 	unsigned long long duration, depth;
 	struct format_field *field;
 	int i;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
-
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
-	printf(" | ");
-
 	if (latency_format) {
 		print_lat_fmt(data, size);
 		printf(" | ");
@@ -2976,31 +2904,21 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 
 static void
 pretty_print_func_graph(void *data, int size, struct event *event,
-			int cpu, int pid, const char *comm,
-			unsigned long secs, unsigned long usecs)
+			int cpu, int pid)
 {
 	if (event->flags & EVENT_FL_ISFUNCENT)
-		pretty_print_func_ent(data, size, event,
-				      cpu, pid, comm, secs, usecs);
+		pretty_print_func_ent(data, size, event, cpu, pid);
 	else if (event->flags & EVENT_FL_ISFUNCRET)
-		pretty_print_func_ret(data, size, event,
-				      cpu, pid, comm, secs, usecs);
+		pretty_print_func_ret(data, size, event);
 	printf("\n");
 }
 
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
+void print_trace_event(int cpu, void *data, int size)
 {
 	struct event *event;
-	unsigned long secs;
-	unsigned long usecs;
 	int type;
 	int pid;
 
-	secs = nsecs / NSECS_PER_SEC;
-	nsecs -= secs * NSECS_PER_SEC;
-	usecs = nsecs / NSECS_PER_USEC;
-
 	type = trace_parse_common_type(data);
 
 	event = trace_find_event(type);
@@ -3012,17 +2930,10 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	pid = trace_parse_common_pid(data);
 
 	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
-		return pretty_print_func_graph(data, size, event, cpu,
-					       pid, comm, secs, usecs);
+		return pretty_print_func_graph(data, size, event, cpu, pid);
 
-	if (latency_format) {
-		printf("%8.8s-%-5d %3d",
-		       comm, pid, cpu);
+	if (latency_format)
 		print_lat_fmt(data, size);
-	} else
-		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
-
-	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
 
 	if (event->flags & EVENT_FL_FAILED) {
 		printf("EVENT '%s' FAILED TO PARSE\n",
@@ -3031,7 +2942,6 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	}
 
 	pretty_print(data, size, event);
-	printf("\n");
 }
 
 static void print_fields(struct print_flag_sym *field)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 5f7b513..b04da57 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -177,8 +177,7 @@ void print_printk(void);
 
 int parse_ftrace_file(char *buf, unsigned long size);
 int parse_event_file(char *buf, unsigned long size, char *sys);
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm);
+void print_trace_event(int cpu, void *data, int size);
 
 extern int file_bigendian;
 extern int host_bigendian;
-- 
1.7.4

