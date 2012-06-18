Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2FRGOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:14:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:47903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2FRGOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181384479"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 2/3] perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
Date: Mon, 18 Jun 2012 14:10:38 +0800
Message-Id: <1339999839-14007-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
References: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both perl and python script start processing events other than trace
points, and it's useful to pass the resolved symbol and the dso info
to the event handler in script for better analysis and statistics.

Struct thread is already a member of struct addr_location, using
addr_location will keep the thread info, while providing additional
symbol and dso info if exist, so that the script itself doesn't need
to bother to do the symbol resolving and dso searching work.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-script.c                        |    5 +++--
 .../perf/util/scripting-engines/trace-event-perl.c |   13 +++++++------
 .../util/scripting-engines/trace-event-python.c    |   13 +++++++------
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    4 +++-
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 8e395a5..faddacc 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -405,9 +405,10 @@ static void process_event(union perf_event *event __unused,
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
@@ -520,7 +521,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, thread);
+	scripting_ops->process_event(event, sample, evsel, machine, &al);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 4c1b3d7..997ef5d 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -256,7 +256,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __unused,
-				    struct thread *thread)
+				    struct addr_location *al)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -268,6 +268,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	dSP;
@@ -344,9 +345,9 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 
 static void perl_process_event_generic(union perf_event *pevent __unused,
 				       struct perf_sample *sample,
-				       struct perf_evsel *evsel __unused,
+				       struct perf_evsel *evsel,
 				       struct machine *machine __unused,
-				       struct thread *thread __unused)
+				       struct addr_location *al __unused)
 {
 	dSP;
 
@@ -372,10 +373,10 @@ static void perl_process_event(union perf_event *pevent,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread)
+			       struct addr_location *al)
 {
-	perl_process_tracepoint(pevent, sample, evsel, machine, thread);
-	perl_process_event_generic(pevent, sample, evsel, machine, thread);
+	perl_process_tracepoint(pevent, sample, evsel, machine, al);
+	perl_process_event_generic(pevent, sample, evsel, machine, al);
 }
 
 static void run_start_sub(void)
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index ab441a4..97f4fad 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -214,7 +214,7 @@ static void python_process_tracepoint(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel __unused,
 				 struct machine *machine __unused,
-				 struct thread *thread)
+				 struct addr_location *al)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -228,6 +228,7 @@ static void python_process_tracepoint(union perf_event *pevent __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
@@ -333,7 +334,7 @@ static void python_process_general_event(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __unused,
-				 struct thread *thread __unused)
+				 struct addr_location *al)
 {
 	PyObject *handler, *retval, *t;
 	static char handler_name[64];
@@ -352,7 +353,7 @@ static void python_process_general_event(union perf_event *pevent __unused,
 		goto exit;
 	}
 
-	/* Pass 3 parameters: event_attr, perf_sample, raw data */
+	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread name */
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
@@ -374,15 +375,15 @@ static void python_process_event(union perf_event *pevent,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine,
-				 struct thread *thread)
+				 struct addr_location *al)
 {
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
-		python_process_tracepoint(pevent, sample, evsel, machine, thread);
+		python_process_tracepoint(pevent, sample, evsel, machine, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
-		python_process_general_event(pevent, sample, evsel, machine, thread);
+		python_process_general_event(pevent, sample, evsel, machine, al);
 	}
 }
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 18ae6c1..b26459e 100644
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
index 639852a..7b49397 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -72,6 +72,8 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 void tracing_data_put(struct tracing_data *tdata);
 
 
+struct addr_location;
+
 struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
@@ -80,7 +82,7 @@ struct scripting_ops {
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread);
+			       struct addr_location *al);
 	int (*generate_script) (const char *outfile);
 };
 
-- 
1.7.1

