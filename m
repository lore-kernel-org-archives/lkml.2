Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab2EPNC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:02:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:40313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab2EPNC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153608609"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/3] perf script: Add general python handler to process non-tracepoint events
Date: Wed, 16 May 2012 20:59:13 +0800
Message-Id: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just follows Robert Richter's idea and the commit 37a058ea0
	"perf script: Add generic perl handler to process events"
to similarly add a python handler for general events other than tracepoints.

For non-tracepoint events, this patch will try to find a function named
"process_general_event" in the python script, and pass the event
header, attribute, perf_sample, raw_data in format of raw string. And
the python script can use "struct" module's unpack function to disasemble
the needed info and process.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../util/scripting-engines/trace-event-python.c    |   60 +++++++++++++++++++-
 1 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c2623c6..aaf2679 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -31,6 +31,7 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
+#include "../evsel.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
@@ -205,7 +206,7 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void python_process_event(union perf_event *pevent __unused,
+static void python_process_tracepoint(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel __unused,
 				 struct machine *machine __unused,
@@ -324,6 +325,63 @@ static void python_process_event(union perf_event *pevent __unused,
 	Py_DECREF(t);
 }
 
+static void python_process_general_event(union perf_event *pevent __unused,
+				 struct perf_sample *sample,
+				 struct perf_evsel *evsel __unused,
+				 struct machine *machine __unused,
+				 struct thread *thread __unused)
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
+	sprintf(handler_name, "process_general_event");
+
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && !PyCallable_Check(handler)) {
+		handler = NULL;
+		goto exit;
+	}
+
+	/* Pass 3 parameters: event_attr, perf_sample, raw data */
+	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
+			(const char *)&evsel->attr, sizeof(evsel->attr)));
+	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
+			(const char *)sample, sizeof(*sample)));
+	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
+			data, sample->raw_size));
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
+static void python_process_event(union perf_event *pevent,
+				 struct perf_sample *sample,
+				 struct perf_evsel *evsel,
+				 struct machine *machine,
+				 struct thread *thread)
+{
+	switch (evsel->attr.type) {
+	case PERF_TYPE_TRACEPOINT:
+		python_process_tracepoint(pevent, sample, evsel, machine, thread);
+		break;
+	/* Reserve for future process_hw/sw/raw APIs */
+	default:
+		python_process_general_event(pevent, sample, evsel, machine, thread);
+	}
+}
+
 static int run_start_sub(void)
 {
 	PyObject *handler, *retval;
-- 
1.7.1

