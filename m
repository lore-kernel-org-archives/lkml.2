Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699Ab2HHRPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:15:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54199 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030649Ab2HHROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/11] perf scripts python: Pass event/thread/dso name and symbol info to event handler in python
Date: Wed,  8 Aug 2012 14:13:46 -0300
Message-Id: <1344446028-21381-10-git-send-email-acme@infradead.org>
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

Also as suggested by Arnaldo, pack all these parameters to a dictionary,
which is more expandable for adding new parameters while keeping the
compatibility for old scripts.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344419875-21665-4-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    |   35 ++++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 24711b3..7e3f576 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -345,15 +345,23 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 					 struct machine *machine __unused,
 					 struct addr_location *al __unused)
 {
-	PyObject *handler, *retval, *t;
+	PyObject *handler, *retval, *t, *dict;
 	static char handler_name[64];
 	unsigned n = 0;
-	void *data = sample->raw_data;
+	struct thread *thread = al->thread;
 
+	/*
+	 * Use the MAX_FIELDS to make the function expandable, though
+	 * currently there is only one itme for the tuple.
+	 */
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
+	dict = PyDict_New();
+	if (!dict)
+		Py_FatalError("couldn't create Python dictionary");
+
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
 
 	handler = PyDict_GetItemString(main_dict, handler_name);
@@ -362,11 +370,25 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 		goto exit;
 	}
 
-	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread name */
-	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)&evsel->attr, sizeof(evsel->attr)));
-	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)sample, sizeof(*sample)));
-	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(data, sample->raw_size));
+	PyDict_SetItemString(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
+	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
+			(const char *)&evsel->attr, sizeof(evsel->attr)));
+	PyDict_SetItemString(dict, "sample", PyString_FromStringAndSize(
+			(const char *)sample, sizeof(*sample)));
+	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
+			(const char *)sample->raw_data, sample->raw_size));
+	PyDict_SetItemString(dict, "comm",
+			PyString_FromString(thread->comm));
+	if (al->map) {
+		PyDict_SetItemString(dict, "dso",
+			PyString_FromString(al->map->dso->name));
+	}
+	if (al->sym) {
+		PyDict_SetItemString(dict, "symbol",
+			PyString_FromString(al->sym->name));
+	}
 
+	PyTuple_SetItem(t, n++, dict);
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
 
@@ -374,6 +396,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 	if (retval == NULL)
 		handler_call_die(handler_name);
 exit:
+	Py_DECREF(dict);
 	Py_DECREF(t);
 }
 
-- 
1.7.9.2.358.g22243

