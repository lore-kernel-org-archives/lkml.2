Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1CPNzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:55:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:35726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1CPNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:55:28 -0400
Date: Wed, 16 Mar 2011 13:54:34 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1299734608-5223-4-git-send-email-daahern@cisco.com>
References: <1299734608-5223-4-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Move printing of 'common' data from print_event and rename
Message-ID: <tip-c70c94b47405d2c94df19c16273daf1f5fb9193d@git.kernel.org>
Git-Commit-ID: c70c94b47405d2c94df19c16273daf1f5fb9193d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c70c94b47405d2c94df19c16273daf1f5fb9193d
Gitweb:     http://git.kernel.org/tip/c70c94b47405d2c94df19c16273daf1f5fb9193d
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 9 Mar 2011 22:23:25 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 17:05:55 -0300

perf script: Move printing of 'common' data from print_event and rename

This change does impact output: latency data is trace specific and is
now printed after the common data - comm, tid, cpu, time and event name.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-4-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c         |   38 ++++++++++++++++++++++-----
 tools/perf/util/trace-event-parse.c |   49 +++++++---------------------------
 tools/perf/util/trace-event.h       |    3 +-
 3 files changed, 42 insertions(+), 48 deletions(-)

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
index dd5f058..0a7ed5b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2643,9 +2643,9 @@ static void print_lat_fmt(void *data, int size __unused)
 		printf(".");
 
 	if (lock_depth < 0)
-		printf(".");
+		printf(". ");
 	else
-		printf("%d", lock_depth);
+		printf("%d ", lock_depth);
 }
 
 #define TRACE_GRAPH_INDENT	2
@@ -2821,18 +2821,13 @@ static void print_graph_nested(struct event *event, void *data)
 
 static void
 pretty_print_func_ent(void *data, int size, struct event *event,
-		      int cpu, int pid, const char *comm __unused,
-		      unsigned long secs, unsigned long usecs)
+		      int cpu, int pid)
 {
 	struct format_field *field;
 	struct record *rec;
 	void *copy_data;
 	unsigned long val;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
-
-	printf(" | ");
-
 	if (latency_format) {
 		print_lat_fmt(data, size);
 		printf(" | ");
@@ -2865,19 +2860,13 @@ out_free:
 }
 
 static void
-pretty_print_func_ret(void *data, int size __unused, struct event *event,
-		      int cpu __unused, int pid __unused, const char *comm __unused,
-		      unsigned long secs, unsigned long usecs)
+pretty_print_func_ret(void *data, int size __unused, struct event *event)
 {
 	unsigned long long rettime, calltime;
 	unsigned long long duration, depth;
 	struct format_field *field;
 	int i;
 
-	printf("%5lu.%06lu |  ", secs, usecs);
-
-	printf(" | ");
-
 	if (latency_format) {
 		print_lat_fmt(data, size);
 		printf(" | ");
@@ -2915,31 +2904,21 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 
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
@@ -2951,17 +2930,10 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
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
@@ -2970,7 +2942,6 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
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
