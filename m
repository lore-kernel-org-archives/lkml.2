Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1CJFYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:24:23 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:45745 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1CJFWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 00:22:53 -0500
X-IronPort-AV: E=Sophos;i="4.62,294,1297036800"; 
   d="scan'208";a="276249611"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 1/6] perf script: change process_event prototype
Date: Wed,  9 Mar 2011 22:23:23 -0700
Message-Id: <1299734608-5223-2-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299734608-5223-1-git-send-email-daahern@cisco.com>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for handling of samples for any event type.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-script.c                        |   25 ++++++++++++-------
 .../perf/util/scripting-engines/trace-event-perl.c |   11 ++++++--
 .../util/scripting-engines/trace-event-python.c    |   11 ++++++--
 tools/perf/util/trace-event-scripting.c            |    9 +++----
 tools/perf/util/trace-event.h                      |    7 ++++-
 5 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 5f40df6..b2bdd55 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -20,6 +20,20 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 
+static void process_event(union perf_event *event __unused,
+			  struct perf_sample *sample,
+			  struct perf_session *session __unused,
+			  struct thread *thread)
+{
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
@@ -40,7 +54,7 @@ static int default_generate_script(const char *outfile __unused)
 static struct scripting_ops default_scripting_ops = {
 	.start_script		= default_start_script,
 	.stop_script		= default_stop_script,
-	.process_event		= print_event,
+	.process_event		= process_event,
 	.generate_script	= default_generate_script,
 };
 
@@ -86,14 +100,7 @@ static int process_sample_event(union perf_event *event,
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
+		scripting_ops->process_event(event, sample, session, thread);
 	}
 
 	session->hists.stats.total_period += sample->period;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 9368081..6214272 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -245,9 +245,10 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void perl_process_event(int cpu, void *data,
-			       int size __unused,
-			       unsigned long long nsecs, char *comm)
+static void perl_process_event(union perf_event *pevent __unused,
+			       struct perf_sample *sample,
+			       struct perf_session *session __unused,
+			       struct thread *thread)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -256,6 +257,10 @@ static void perl_process_event(int cpu, void *data,
 	struct event *event;
 	int type;
 	int pid;
+	int cpu = sample->cpu;
+	void *data = sample->raw_data;
+	unsigned long long nsecs = sample->time;
+	char *comm = thread->comm;
 
 	dSP;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 2040b85..1b85d60 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -204,9 +204,10 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void python_process_event(int cpu, void *data,
-				 int size __unused,
-				 unsigned long long nsecs, char *comm)
+static void python_process_event(union perf_event *pevent __unused,
+				 struct perf_sample *sample,
+				 struct perf_session *session __unused,
+				 struct thread *thread)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -217,6 +218,10 @@ static void python_process_event(int cpu, void *data,
 	unsigned n = 0;
 	int type;
 	int pid;
+	int cpu = sample->cpu;
+	void *data = sample->raw_data;
+	unsigned long long nsecs = sample->time;
+	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index f7af2fc..66f4b78 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -36,11 +36,10 @@ static int stop_script_unsupported(void)
 	return 0;
 }
 
-static void process_event_unsupported(int cpu __unused,
-				      void *data __unused,
-				      int size __unused,
-				      unsigned long long nsecs __unused,
-				      char *comm __unused)
+static void process_event_unsupported(union perf_event *event __unused,
+				      struct perf_sample *sample __unused,
+				      struct perf_session *session __unused,
+				      struct thread *thread __unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b5f12ca..5f7b513 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "parse-events.h"
+#include "session.h"
 
 #define __unused __attribute__((unused))
 
@@ -278,8 +279,10 @@ struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
-	void (*process_event) (int cpu, void *data, int size,
-			       unsigned long long nsecs, char *comm);
+	void (*process_event) (union perf_event *event,
+			       struct perf_sample *sample,
+			       struct perf_session *session,
+			       struct thread *thread);
 	int (*generate_script) (const char *outfile);
 };
 
-- 
1.7.4

