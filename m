Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966255Ab2EPNC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:02:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:40313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961Ab2EPNC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:02:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153608640"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/3] perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
Date: Wed, 16 May 2012 20:59:14 +0800
Message-Id: <1337173155-25780-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
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
---
 tools/perf/builtin-script.c                        |    5 +++--
 .../perf/util/scripting-engines/trace-event-perl.c |   11 ++++++-----
 .../util/scripting-engines/trace-event-python.c    |   16 ++++++++--------
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    4 +++-
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index d4ce733..417fe7d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -405,9 +405,10 @@ static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
 			  struct machine *machine,
-			  struct thread *thread)
+			  struct addr_location *al __unused)
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
index e30749e..8f5eacc 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -252,7 +252,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __unused,
-				    struct thread *thread)
+				    struct addr_location *al __unused)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -264,6 +264,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	dSP;
@@ -342,7 +343,7 @@ static void perl_process_event_generic(union perf_event *pevent __unused,
 				       struct perf_sample *sample,
 				       struct perf_evsel *evsel __unused,
 				       struct machine *machine __unused,
-				       struct thread *thread __unused)
+				       struct addr_location *al __unused)
 {
 	dSP;
 
@@ -368,10 +369,10 @@ static void perl_process_event(union perf_event *pevent,
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
index aaf2679..a202881 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -210,7 +210,7 @@ static void python_process_tracepoint(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel __unused,
 				 struct machine *machine __unused,
-				 struct thread *thread)
+				 struct addr_location *al)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -224,6 +224,7 @@ static void python_process_tracepoint(union perf_event *pevent __unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
+	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
@@ -327,9 +328,9 @@ static void python_process_tracepoint(union perf_event *pevent __unused,
 
 static void python_process_general_event(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
-				 struct perf_evsel *evsel __unused,
+				 struct perf_evsel *evsel,
 				 struct machine *machine __unused,
-				 struct thread *thread __unused)
+				 struct addr_location *al)
 {
 	PyObject *handler, *retval, *t;
 	static char handler_name[64];
@@ -341,14 +342,13 @@ static void python_process_general_event(union perf_event *pevent __unused,
 		Py_FatalError("couldn't create Python tuple");
 
 	sprintf(handler_name, "process_general_event");
-
 	handler = PyDict_GetItemString(main_dict, handler_name);
 	if (handler && !PyCallable_Check(handler)) {
 		handler = NULL;
 		goto exit;
 	}
 
-	/* Pass 3 parameters: event_attr, perf_sample, raw data */
+	/* Pass 3 parameters: event_attr, perf_sample, raw data, thread name */
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
@@ -370,15 +370,15 @@ static void python_process_event(union perf_event *pevent,
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
index 58ae14c..dc20ca0 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -289,6 +289,8 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
+struct addr_location;
+
 struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
@@ -297,7 +299,7 @@ struct scripting_ops {
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct thread *thread);
+			       struct addr_location *al);
 	int (*generate_script) (const char *outfile);
 };
 
-- 
1.7.1

