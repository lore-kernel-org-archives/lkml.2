Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030706Ab2HHRO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:14:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54207 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030663Ab2HHROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/11] perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
Date: Wed,  8 Aug 2012 14:13:45 -0300
Message-Id: <1344446028-21381-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Both perl and python script start processing events other than trace
points, and it's useful to pass the resolved symbol and the dso info to
the event handler in script for better analysis and statistics.

Struct thread is already a member of struct addr_location, using
addr_location will keep the thread info, while providing additional
symbol and dso info if exist, so that the script itself doesn't need to
bother to do the symbol resolving and dso searching work.

Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344419875-21665-3-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c                        |    5 +++--
 .../perf/util/scripting-engines/trace-event-perl.c |   11 ++++++-----
 .../util/scripting-engines/trace-event-python.c    |   13 +++++++------
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    5 +++--
 5 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6425612..30a9cb8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -396,9 +396,10 @@ static void print_sample_bts(union perf_event *event,
 
 static void process_event(union perf_event *event, struct perf_sample *sample,
 			  struct perf_evsel *evsel, struct machine *machine,
-			  struct thread *thread)
+			  struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	struct thread *thread = al->thread;
 
 	if (output[attr->type].fields == 0)
 		return;
@@ -511,7 +512,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, thread);
+	scripting_ops->process_event(event, sample, evsel, machine, &al);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 52580d0..d280010 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -261,7 +261,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __unused,
-				    struct thread *thread)
+				    struct addr_location *al)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -272,6 +272,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	dSP;
@@ -349,7 +350,7 @@ static void perl_process_event_generic(union perf_event *event,
 				       struct perf_sample *sample,
 				       struct perf_evsel *evsel,
 				       struct machine *machine __unused,
-				       struct thread *thread __unused)
+				       struct addr_location *al __unused)
 {
 	dSP;
 
@@ -375,10 +376,10 @@ static void perl_process_event(union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread)
+			       struct addr_location *al)
 {
-	perl_process_tracepoint(event, sample, evsel, machine, thread);
-	perl_process_event_generic(event, sample, evsel, machine, thread);
+	perl_process_tracepoint(event, sample, evsel, machine, al);
+	perl_process_event_generic(event, sample, evsel, machine, al);
 }
 
 static void run_start_sub(void)
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index b9010d8..24711b3 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -225,7 +225,7 @@ static void python_process_tracepoint(union perf_event *perf_event __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __unused,
-				 struct thread *thread)
+				 struct addr_location *al)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -238,6 +238,7 @@ static void python_process_tracepoint(union perf_event *perf_event __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
@@ -342,7 +343,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 					 struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct machine *machine __unused,
-					 struct thread *thread __unused)
+					 struct addr_location *al __unused)
 {
 	PyObject *handler, *retval, *t;
 	static char handler_name[64];
@@ -361,7 +362,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 		goto exit;
 	}
 
-	/* Pass 3 parameters: event_attr, perf_sample, raw data */
+	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread name */
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)&evsel->attr, sizeof(evsel->attr)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)sample, sizeof(*sample)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(data, sample->raw_size));
@@ -380,17 +381,17 @@ static void python_process_event(union perf_event *perf_event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine,
-				 struct thread *thread)
+				 struct addr_location *al)
 {
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
 		python_process_tracepoint(perf_event, sample, evsel,
-					  machine, thread);
+					  machine, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
 		python_process_general_event(perf_event, sample, evsel,
-					     machine, thread);
+					     machine, al);
 	}
 }
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index aceb8ee..302ff26 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -39,7 +39,7 @@ static void process_event_unsupported(union perf_event *event __unused,
 				      struct perf_sample *sample __unused,
 				      struct perf_evsel *evsel __unused,
 				      struct machine *machine __unused,
-				      struct thread *thread __unused)
+				      struct addr_location *al __unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index cee1635..7575dfd 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -9,7 +9,6 @@ struct machine;
 struct perf_sample;
 union perf_event;
 struct perf_tool;
-struct thread;
 
 extern int header_page_size_size;
 extern int header_page_ts_size;
@@ -76,6 +75,8 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 void tracing_data_put(struct tracing_data *tdata);
 
 
+struct addr_location;
+
 struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
@@ -84,7 +85,7 @@ struct scripting_ops {
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread);
+			       struct addr_location *al);
 	int (*generate_script) (struct pevent *pevent, const char *outfile);
 };
 
-- 
1.7.9.2.358.g22243

