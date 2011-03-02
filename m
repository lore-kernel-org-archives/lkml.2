Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab1CBR3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:29:43 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:24921 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab1CBR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:29:11 -0500
X-IronPort-AV: E=Sophos;i="4.62,254,1297036800"; 
   d="scan'208";a="337912145"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 1/3] perf script: change process_event prototype
Date: Wed,  2 Mar 2011 10:29:18 -0700
Message-Id: <1299086960-26964-2-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299086960-26964-1-git-send-email-daahern@cisco.com>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for handling of samples for any event type.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-script.c                        |   40 +++++++++++--------
 .../util/scripting-engines/trace-event-python.c    |   20 ++++++++-
 tools/perf/util/trace-event-scripting.c            |    8 +--
 tools/perf/util/trace-event.h                      |    6 ++-
 4 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5f40df6..0bee150 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -20,6 +20,27 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 
+static void process_event(union perf_event *event,
+			  struct perf_sample *sample,
+			  struct perf_session *session)
+{
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
+		return;
+	}
+
+	/*
+	 * FIXME: better resolve from pid from the struct trace_entry
+	 * field, although it should be the same than this perf
+	 * event pid
+	 */
+	print_event(sample->cpu, sample->raw_data, sample->raw_size,
+		    sample->time, thread->comm);
+}
+
 static int default_start_script(const char *script __unused,
 				int argc __unused,
 				const char **argv __unused)
@@ -40,7 +61,7 @@ static int default_generate_script(const char *outfile __unused)
 static struct scripting_ops default_scripting_ops = {
 	.start_script		= default_start_script,
 	.stop_script		= default_stop_script,
-	.process_event		= print_event,
+	.process_event		= process_event,
 	.generate_script	= default_generate_script,
 };
 
@@ -67,14 +88,6 @@ static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
-
-	if (thread == NULL) {
-		pr_debug("problem processing %d event, skipping it.\n",
-			 event->header.type);
-		return -1;
-	}
-
 	if (session->sample_type & PERF_SAMPLE_RAW) {
 		if (debug_mode) {
 			if (sample->time < last_timestamp) {
@@ -86,14 +99,7 @@ static int process_sample_event(union perf_event *event,
 			last_timestamp = sample->time;
 			return 0;
 		}
-		/*
-		 * FIXME: better resolve from pid from the struct trace_entry
-		 * field, although it should be the same than this perf
-		 * event pid
-		 */
-		scripting_ops->process_event(sample->cpu, sample->raw_data,
-					     sample->raw_size,
-					     sample->time, thread->comm);
+		scripting_ops->process_event(event, sample, session);
 	}
 
 	session->hists.stats.total_period += sample->period;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 2040b85..5b03fb6 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -204,9 +204,9 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void python_process_event(int cpu, void *data,
-				 int size __unused,
-				 unsigned long long nsecs, char *comm)
+static void python_process_event(union perf_event *pevent,
+				struct perf_sample *sample,
+				struct perf_session *session)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -218,6 +218,20 @@ static void python_process_event(int cpu, void *data,
 	int type;
 	int pid;
 
+	int cpu = sample->cpu;
+	void *data = sample->raw_data;
+	unsigned long long nsecs = sample->time;
+	char *comm;
+	struct thread *thread;
+
+	thread = perf_session__findnew(session, pevent->ip.pid);
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			 pevent->header.type);
+		return;
+	}
+	comm = thread->comm;
+
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index f7af2fc..91f1b33 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -36,11 +36,9 @@ static int stop_script_unsupported(void)
 	return 0;
 }
 
-static void process_event_unsupported(int cpu __unused,
-				      void *data __unused,
-				      int size __unused,
-				      unsigned long long nsecs __unused,
-				      char *comm __unused)
+static void process_event_unsupported(union perf_event *event __unused,
+				      struct perf_sample *sample __unused,
+				      struct perf_session *session __unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b5f12ca..632b87b1 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "parse-events.h"
+#include "session.h"
 
 #define __unused __attribute__((unused))
 
@@ -278,8 +279,9 @@ struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
-	void (*process_event) (int cpu, void *data, int size,
-			       unsigned long long nsecs, char *comm);
+	void (*process_event) (union perf_event *event,
+			       struct perf_sample *sample,
+			       struct perf_session *session);
 	int (*generate_script) (const char *outfile);
 };
 
-- 
1.7.4

