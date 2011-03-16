Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1CPNyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:54:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:33023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1CPNyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:54:08 -0400
Date: Wed, 16 Mar 2011 13:53:43 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1299734608-5223-2-git-send-email-daahern@cisco.com>
References: <1299734608-5223-2-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Change process_event prototype
Message-ID: <tip-be6d842a65babc54e2b204b382df2529e304be48@git.kernel.org>
Git-Commit-ID: be6d842a65babc54e2b204b382df2529e304be48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:53:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be6d842a65babc54e2b204b382df2529e304be48
Gitweb:     http://git.kernel.org/tip/be6d842a65babc54e2b204b382df2529e304be48
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 9 Mar 2011 22:23:23 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 17:05:50 -0300

perf script: Change process_event prototype

Prepare for handling of samples for any event type.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-2-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 
