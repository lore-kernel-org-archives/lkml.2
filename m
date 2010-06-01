Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0FAMRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:17:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab0FAMRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:17:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf scripts python: Give field dict to unhandled callback
Date: Tue,  1 Jun 2010 09:17:28 -0300
Message-Id: <1275394648-13234-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275394648-13234-1-git-send-email-acme@infradead.org>
References: <1275394648-13234-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Tardy <tardyp@gmail.com>

trace_unhandled() callback does not allow to access event fields, this patch
resolves the problem.

It can also been used as a more pythonic and flexible way for script writters
to demux event types

This will for example greatly simplify pytimechart event demux.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1275340329-2397-1-git-send-email-tardyp@gmail.com>
Signed-off-by: Pierre Tardy <tardyp@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/python/check-perf-trace.py      |    3 +-
 .../util/scripting-engines/trace-event-python.c    |   50 +++++++++++++------
 2 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
index 964d934..d9f7893 100644
--- a/tools/perf/scripts/python/check-perf-trace.py
+++ b/tools/perf/scripts/python/check-perf-trace.py
@@ -51,8 +51,7 @@ def kmem__kmalloc(event_name, context, common_cpu,
 
 		flag_str("kmem__kmalloc", "gfp_flags", gfp_flags)),
 
-def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
-		common_pid, common_comm):
+def trace_unhandled(event_name, context, event_fields_dict):
     try:
         unhandled[event_name] += 1
     except TypeError:
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 81f39ca..33a6325 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -208,7 +208,7 @@ static void python_process_event(int cpu, void *data,
 				 int size __unused,
 				 unsigned long long nsecs, char *comm)
 {
-	PyObject *handler, *retval, *context, *t, *obj;
+	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long long val;
@@ -232,6 +232,14 @@ static void python_process_event(int cpu, void *data,
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && !PyCallable_Check(handler))
+		handler = NULL;
+	if (!handler) {
+		dict = PyDict_New();
+		if (!dict)
+			Py_FatalError("couldn't create Python dict");
+	}
 	s = nsecs / NSECS_PER_SEC;
 	ns = nsecs - s * NSECS_PER_SEC;
 
@@ -242,12 +250,20 @@ static void python_process_event(int cpu, void *data,
 	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
 	PyTuple_SetItem(t, n++,
 			PyCObject_FromVoidPtr(scripting_context, NULL));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(s));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
-	PyTuple_SetItem(t, n++, PyString_FromString(comm));
 
+	if (handler) {
+		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
+		PyTuple_SetItem(t, n++, PyInt_FromLong(s));
+		PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
+		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
+		PyTuple_SetItem(t, n++, PyString_FromString(comm));
+	} else {
+		PyDict_SetItemString(dict, "common_cpu", PyInt_FromLong(cpu));
+		PyDict_SetItemString(dict, "common_s", PyInt_FromLong(s));
+		PyDict_SetItemString(dict, "common_ns", PyInt_FromLong(ns));
+		PyDict_SetItemString(dict, "common_pid", PyInt_FromLong(pid));
+		PyDict_SetItemString(dict, "common_comm", PyString_FromString(comm));
+	}
 	for (field = event->format.fields; field; field = field->next) {
 		if (field->flags & FIELD_IS_STRING) {
 			int offset;
@@ -272,27 +288,31 @@ static void python_process_event(int cpu, void *data,
 					obj = PyLong_FromUnsignedLongLong(val);
 			}
 		}
-		PyTuple_SetItem(t, n++, obj);
+		if (handler)
+			PyTuple_SetItem(t, n++, obj);
+		else
+			PyDict_SetItemString(dict, field->name, obj);
+
 	}
+	if (!handler)
+		PyTuple_SetItem(t, n++, dict);
 
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
 
-	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (handler && PyCallable_Check(handler)) {
+	if (handler) {
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
 	} else {
 		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
 		if (handler && PyCallable_Check(handler)) {
-			if (_PyTuple_Resize(&t, N_COMMON_FIELDS) == -1)
-				Py_FatalError("error resizing Python tuple");
 
 			retval = PyObject_CallObject(handler, t);
 			if (retval == NULL)
 				handler_call_die("trace_unhandled");
 		}
+		Py_DECREF(dict);
 	}
 
 	Py_DECREF(t);
@@ -548,12 +568,10 @@ static int python_generate_script(const char *outfile)
 	}
 
 	fprintf(ofp, "def trace_unhandled(event_name, context, "
-		"common_cpu, common_secs, common_nsecs,\n\t\t"
-		"common_pid, common_comm):\n");
+		"event_fields_dict):\n");
 
-	fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
-		"common_secs, common_nsecs,\n\t\tcommon_pid, "
-		"common_comm)\n\n");
+	fprintf(ofp, "\t\tprint ' '.join(['%%s=%%s'%%(k,str(v))"
+		"for k,v in sorted(event_fields_dict.items())])\n\n");
 
 	fprintf(ofp, "def print_header("
 		"event_name, cpu, secs, nsecs, pid, comm):\n"
-- 
1.6.2.5

