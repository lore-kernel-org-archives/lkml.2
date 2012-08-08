Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030711Ab2HHRPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:15:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:45882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030625Ab2HHROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/11] perf script: Add general python handler to process non-tracepoint events
Date: Wed,  8 Aug 2012 14:13:44 -0300
Message-Id: <1344446028-21381-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344419875-21665-2-git-send-email-feng.tang@intel.com
[ committer note: Fixed up wrt da37896, i.e. pevent parm in script event handlers ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    |   59 +++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index df7d33d..b9010d8 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -32,6 +32,7 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
+#include "../evsel.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
@@ -220,7 +221,7 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 	return event;
 }
 
-static void python_process_event(union perf_event *perf_event __unused,
+static void python_process_tracepoint(union perf_event *perf_event __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __unused,
@@ -337,6 +338,62 @@ static void python_process_event(union perf_event *perf_event __unused,
 	Py_DECREF(t);
 }
 
+static void python_process_general_event(union perf_event *perf_event __unused,
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
+				 struct perf_sample *sample,
+				 struct perf_evsel *evsel,
+				 struct machine *machine,
+				 struct thread *thread)
+{
+	switch (evsel->attr.type) {
+	case PERF_TYPE_TRACEPOINT:
+		python_process_tracepoint(perf_event, sample, evsel,
+					  machine, thread);
+		break;
+	/* Reserve for future process_hw/sw/raw APIs */
+	default:
+		python_process_general_event(perf_event, sample, evsel,
+					     machine, thread);
+	}
+}
+
 static int run_start_sub(void)
 {
 	PyObject *handler, *retval;
-- 
1.7.9.2.358.g22243

