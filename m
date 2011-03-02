Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1CBR33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:29:29 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:24921 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab1CBR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:29:12 -0500
X-IronPort-AV: E=Sophos;i="4.62,254,1297036800"; 
   d="scan'208";a="337912172"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 2/3] perf script: prepare to handle more than tracepoint events
Date: Wed,  2 Mar 2011 10:29:19 -0700
Message-Id: <1299086960-26964-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299086960-26964-1-git-send-email-daahern@cisco.com>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-script.c         |   74 +++++++++++++++++++++-------------
 tools/perf/util/trace-event-parse.c |    4 +-
 tools/perf/util/trace-event.h       |    4 +-
 3 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 0bee150..f59d482 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -24,21 +24,45 @@ static void process_event(union perf_event *event,
 			  struct perf_sample *sample,
 			  struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
-
-	if (thread == NULL) {
-		pr_debug("problem processing %d event, skipping it.\n",
-			 event->header.type);
-		return;
+	struct perf_event_attr *attr;
+	struct thread *thread;
+	const char *evname = NULL;
+	static bool check_raw = true;
+
+	attr = perf_header__find_attr(sample->id, &session->header);
+	if (!attr) {
+		pr_debug("No attributes found for sample id %" PRId64 ". "
+		         "skipping it.\n", sample->id);
 	}
 
-	/*
-	 * FIXME: better resolve from pid from the struct trace_entry
-	 * field, although it should be the same than this perf
-	 * event pid
-	 */
-	print_event(sample->cpu, sample->raw_data, sample->raw_size,
-		    sample->time, thread->comm);
+	if (attr->type == PERF_TYPE_TRACEPOINT) {
+		if (check_raw) {
+			if (!perf_session__has_traces(session, "record -R"))
+				return;
+			check_raw = false;
+		}
+
+		thread = perf_session__findnew(session, event->ip.pid);
+		if (thread == NULL) {
+			pr_debug("problem processing %d event, skipping it.\n",
+				 event->header.type);
+			return;
+		}
+
+		/*
+		 * FIXME: better resolve from pid from the struct trace_entry
+		 * field, although it should be the same than this perf
+		 * event pid
+		 */
+		print_tracepoint_event(sample->cpu, sample->raw_data,
+				       sample->raw_size, sample->time,
+				       thread->comm);
+	} else {
+		evname = __event_name(attr->type, attr->config);
+		if (verbose)
+			warning("support for event %s not implemented. skipping\n",
+			evname ? evname : "(unknown)");
+	}
 }
 
 static int default_start_script(const char *script __unused,
@@ -88,19 +112,17 @@ static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_session *session)
 {
-	if (session->sample_type & PERF_SAMPLE_RAW) {
-		if (debug_mode) {
-			if (sample->time < last_timestamp) {
-				pr_err("Samples misordered, previous: %" PRIu64
-					" this: %" PRIu64 "\n", last_timestamp,
-					sample->time);
-				nr_unordered++;
-			}
-			last_timestamp = sample->time;
-			return 0;
+	if (debug_mode) {
+		if (sample->time < last_timestamp) {
+			pr_err("Samples misordered, previous: %" PRIu64
+				" this: %" PRIu64 "\n", last_timestamp,
+				sample->time);
+			nr_unordered++;
 		}
-		scripting_ops->process_event(event, sample, session);
+		last_timestamp = sample->time;
+		return 0;
 	}
+	scripting_ops->process_event(event, sample, session);
 
 	session->hists.stats.total_period += sample->period;
 	return 0;
@@ -778,10 +800,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (strcmp(input_name, "-") &&
-	    !perf_session__has_traces(session, "record -R"))
-		return -EINVAL;
-
 	if (generate_script_lang) {
 		struct stat perf_stat;
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8e622d..efe1628 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2988,8 +2988,8 @@ pretty_print_func_graph(void *data, int size, struct event *event,
 	printf("\n");
 }
 
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
+void print_tracepoint_event(int cpu, void *data, int size,
+		  unsigned long long nsecs, char *comm)
 {
 	struct event *event;
 	unsigned long secs;
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 632b87b1..cafabf3 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -177,8 +177,8 @@ void print_printk(void);
 
 int parse_ftrace_file(char *buf, unsigned long size);
 int parse_event_file(char *buf, unsigned long size, char *sys);
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm);
+void print_tracepoint_event(int cpu, void *data, int size,
+		  unsigned long long nsecs, char *comm);
 
 extern int file_bigendian;
 extern int host_bigendian;
-- 
1.7.4

