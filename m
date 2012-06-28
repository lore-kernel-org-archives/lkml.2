Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2F1JUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:20:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:2529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab2F1JTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159147519"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v4 2/5] perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
Date: Thu, 28 Jun 2012 17:15:31 +0800
Message-Id: <1340874934-25661-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1340874934-25661-1-git-send-email-feng.tang@intel.com>
References: <1340874934-25661-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both perl and python script start processing events other than trace
points, and it's useful to pass the resolved symbol and the dso info to
the event handler in script for better analysis and statistics.

Struct thread is already a member of struct addr_location, using
addr_location will keep the thread info, while providing additional
symbol and dso info if exist, so that the script itself doesn't need to
bother to do the symbol resolving and dso searching work.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1339999839-14007-3-git-send-email-feng.tang@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c                        |    5 +++--
 .../perf/util/scripting-engines/trace-event-perl.c |   13 +++++++------
 .../util/scripting-engines/trace-event-python.c    |   13 +++++++------
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    5 +++--
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1e60ab7..e588090 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -420,9 +420,10 @@ static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
 			  struct machine *machine,
-			  struct thread *thread)
+			  struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	struct thread *thread = al->thread;
 
 	if (output[attr->type].fields == 0)
 		return;
@@ -538,7 +539,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 		return 0;
 
 	scripting_ops->process_event(event, scr->session->pevent,
-				     sample, evsel, machine, thread);
+				     sample, evsel, machine, &al);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b3620fe..3f64cd0 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -258,7 +258,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __unused,
-				    struct thread *thread)
+				    struct addr_location *al)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -270,6 +270,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	dSP;
@@ -347,9 +348,9 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 
 static void perl_process_event_generic(union perf_event *pevent __unused,
 				       struct perf_sample *sample,
-				       struct perf_evsel *evsel __unused,
+				       struct perf_evsel *evsel,
 				       struct machine *machine __unused,
-				       struct thread *thread __unused)
+				       struct addr_location *al __unused)
 {
 	dSP;
 
@@ -376,10 +377,10 @@ static void perl_process_event(union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread)
+			       struct addr_location *al)
 {
-	perl_process_tracepoint(event, pevent, sample, evsel, machine, thread);
-	perl_process_event_generic(event, sample, evsel, machine, thread);
+	perl_process_tracepoint(event, pevent, sample, evsel, machine, al);
+	perl_process_event_generic(event, sample, evsel, machine, al);
 }
 
 static void run_start_sub(void)
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 3fae022..0be4ec0 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -216,7 +216,7 @@ static void python_process_tracepoint(union perf_event *perf_event __unused,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __unused,
 				      struct machine *machine __unused,
-				      struct thread *thread)
+				      struct addr_location *al)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -230,6 +230,7 @@ static void python_process_tracepoint(union perf_event *perf_event __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
@@ -337,7 +338,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 					 struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct machine *machine __unused,
-					 struct thread *thread __unused)
+					 struct addr_location *al __unused)
 {
 	PyObject *handler, *retval, *t;
 	static char handler_name[64];
@@ -356,7 +357,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 		goto exit;
 	}
 
-	/* Pass 3 parameters: event_attr, perf_sample, raw data */
+	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread name */
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)&evsel->attr, sizeof(evsel->attr)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)sample, sizeof(*sample)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(data, sample->raw_size));
@@ -376,17 +377,17 @@ static void python_process_event(union perf_event *perf_event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine,
-				 struct thread *thread)
+				 struct addr_location *al)
 {
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
 		python_process_tracepoint(perf_event, pevent, sample, evsel,
-					  machine, thread);
+					  machine, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
 		python_process_general_event(perf_event, pevent, sample, evsel,
-					     machine, thread);
+					     machine, al);
 	}
 }
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 474aa7a..c8dc56c 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -40,7 +40,7 @@ static void process_event_unsupported(union perf_event *event __unused,
 				      struct perf_sample *sample __unused,
 				      struct perf_evsel *evsel __unused,
 				      struct machine *machine __unused,
-				      struct thread *thread __unused)
+				      struct addr_location *al __unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 8fef1d6..8ec1de7 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -9,7 +9,6 @@ struct machine;
 struct perf_sample;
 union perf_event;
 struct perf_tool;
-struct thread;
 
 extern int header_page_size_size;
 extern int header_page_ts_size;
@@ -74,6 +73,8 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 void tracing_data_put(struct tracing_data *tdata);
 
 
+struct addr_location;
+
 struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
@@ -83,7 +84,7 @@ struct scripting_ops {
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread);
+			       struct addr_location *al);
 	int (*generate_script) (struct pevent *pevent, const char *outfile);
 };
 
-- 
1.7.1

