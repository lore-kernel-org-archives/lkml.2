Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2F0S6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:58:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2F0S6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:58:50 -0400
Date: Wed, 27 Jun 2012 15:58:17 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 3/3] perf script/python: Pass event/thread/dso name
 and symbol info to event handler in python
Message-ID: <20120627185817.GD20530@infradead.org>
References: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
 <1339999839-14007-4-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1339999839-14007-4-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Mon, Jun 18, 2012 at 02:10:39PM +0800, Feng Tang escreveu:
> Also as suggested by Arnaldo, pack all these parameters to a dictionary,
> which is more expandable for adding new parameters while keep the
> compatibility for old scripts.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  .../util/scripting-engines/trace-event-python.c    |   32 +++++++++++++++----
>  1 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 97f4fad..e8ac480 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -336,15 +336,23 @@ static void python_process_general_event(union perf_event *pevent __unused,
>  				 struct machine *machine __unused,
>  				 struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *t;
> +	PyObject *handler, *retval, *t, *dict;
>  	static char handler_name[64];
>  	unsigned n = 0;
> -	void *data = sample->raw_data;
> +	struct thread *thread = al->thread;
>  
> +	/*
> +	 * Use the MAX_FIELDS to make the function expandable, though
> +	 * currently there is only one itme for the tuple.
> +	 */
>  	t = PyTuple_New(MAX_FIELDS);
>  	if (!t)
>  		Py_FatalError("couldn't create Python tuple");
>  
> +	dict = PyDict_New();
> +	if (!dict)
> +		Py_FatalError("couldn't create Python dictionary");
> +
>  	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
>  
>  	handler = PyDict_GetItemString(main_dict, handler_name);
> @@ -353,14 +361,23 @@ static void python_process_general_event(union perf_event *pevent __unused,
>  		goto exit;
>  	}
>  
> -	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread name */
> -	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> +	PyDict_SetItemString(dict, "ev_name", PyString_FromString(event_name(evsel)));
> +	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
>  			(const char *)&evsel->attr, sizeof(evsel->attr)));
> -	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> +	PyDict_SetItemString(dict, "sample", PyString_FromStringAndSize(
>  			(const char *)sample, sizeof(*sample)));
> -	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> -			data, sample->raw_size));
> +	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
> +			(const char *)sample->raw_data, sample->raw_size));
> +	PyDict_SetItemString(dict, "comm",
> +			PyString_FromString(thread->comm));
> +	PyDict_SetItemString(dict, "dso",
> +			PyString_FromString(al->map->dso->name));
> +	if (al->sym) {
> +		PyDict_SetItemString(dict, "symbol",
> +			PyString_FromString(al->sym->name));
> +	}
>  
> +	PyTuple_SetItem(t, n++, dict);

Now old scrips will break, as the tuple they expect:

 (attr, sample, raw_data)

will not be there.

To not break those scripts you must leave it there and add the new ones
in a python compatible way. I.e. have you tested the existing scripts
using the new perf tool with your patches applied? They must continue to
work.

I.e. leave the old tuple and add the dict at the end somehow.

The first two patches in this series don't apply anymore, please find
them attached fixed, please check if they work as expected.

- Arnaldo

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-script-Add-general-python-handler-to-process-no.patch"

>From 429bf5a8d5b27b444cbdfaea088d883d8921fb48 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 27 Jun 2012 15:07:02 -0300
Subject: [PATCH 1/2] perf script: Add general python handler to process non-tracepoint events
Content-Type: text/plain; charset="UTF-8"

This patch just follows Robert Richter's idea and the commit 37a058ea0
	"perf script: Add generic perl handler to process events"
to similarly add a python handler for general events other than tracepoints.

For non-tracepoint events, this patch will try to find a function named
"process_event" in the python script, and pass the event attribute,
perf_sample, raw_data in format of raw string. And the python script can
use "struct" module's unpack function to disasemble the needed info and process.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
http://lkml.kernel.org/r/1339999839-14007-2-git-send-email-feng.tang@intel.com
[ committer note: Fixed up wrt da37896, i.e. pevent parm in script event handlers ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    |   71 ++++++++++++++++++--
 1 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index a8ca2f8..3fae022 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -31,6 +31,7 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
+#include "../evsel.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
@@ -210,12 +211,12 @@ struct event_format *find_cache_event(struct pevent *pevent, int type)
 	return event;
 }
 
-static void python_process_event(union perf_event *perf_event __unused,
-				 struct pevent *pevent,
-				 struct perf_sample *sample,
-				 struct perf_evsel *evsel __unused,
-				 struct machine *machine __unused,
-				 struct thread *thread)
+static void python_process_tracepoint(union perf_event *perf_event __unused,
+				      struct pevent *pevent,
+				      struct perf_sample *sample,
+				      struct perf_evsel *evsel __unused,
+				      struct machine *machine __unused,
+				      struct thread *thread)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -331,6 +332,64 @@ static void python_process_event(union perf_event *perf_event __unused,
 	Py_DECREF(t);
 }
 
+static void python_process_general_event(union perf_event *perf_event __unused,
+					 struct pevent *pevent,
+					 struct perf_sample *sample,
+					 struct perf_evsel *evsel,
+					 struct machine *machine __unused,
+					 struct thread *thread __unused)
+{
+	PyObject *handler, *retval, *t;
+	static char handler_name[64];
+	unsigned n = 0;
+	void *data = sample->raw_data;
+
+	t = PyTuple_New(MAX_FIELDS);
+	if (!t)
+		Py_FatalError("couldn't create Python tuple");
+
+	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
+
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && !PyCallable_Check(handler)) {
+		handler = NULL;
+		goto exit;
+	}
+
+	/* Pass 3 parameters: event_attr, perf_sample, raw data */
+	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)&evsel->attr, sizeof(evsel->attr)));
+	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)sample, sizeof(*sample)));
+	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(data, sample->raw_size));
+
+	if (_PyTuple_Resize(&t, n) == -1)
+		Py_FatalError("error resizing Python tuple");
+
+	retval = PyObject_CallObject(handler, t);
+	if (retval == NULL)
+		handler_call_die(handler_name);
+exit:
+	Py_DECREF(t);
+}
+
+static void python_process_event(union perf_event *perf_event,
+				 struct pevent *pevent,
+				 struct perf_sample *sample,
+				 struct perf_evsel *evsel,
+				 struct machine *machine,
+				 struct thread *thread)
+{
+	switch (evsel->attr.type) {
+	case PERF_TYPE_TRACEPOINT:
+		python_process_tracepoint(perf_event, pevent, sample, evsel,
+					  machine, thread);
+		break;
+	/* Reserve for future process_hw/sw/raw APIs */
+	default:
+		python_process_general_event(perf_event, pevent, sample, evsel,
+					     machine, thread);
+	}
+}
+
 static int run_start_sub(void)
 {
 	PyObject *handler, *retval;
-- 
1.7.1


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-perf-script-Replace-struct-thread-with-struct-addr_l.patch"

>From 16c5860d9f34236920ebb71b346417c638aa7198 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 27 Jun 2012 15:24:16 -0300
Subject: [PATCH 2/2] perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
Content-Type: text/plain; charset="UTF-8"

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


--TRYliJ5NKNqkz5bu--
