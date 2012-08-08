Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282Ab2HHKDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:03:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:64865 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab2HHKDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,732,1336374000"; 
   d="scan'208";a="177396369"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v5 3/5] perf script/python: Pass event/thread/dso name and symbol info to event handler in python
Date: Wed,  8 Aug 2012 17:57:53 +0800
Message-Id: <1344419875-21665-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344419875-21665-1-git-send-email-feng.tang@intel.com>
References: <1344419875-21665-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also as suggested by Arnaldo, pack all these parameters to a dictionary,
which is more expandable for adding new parameters while keeping the
compatibility for old scripts.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>
---
 .../util/scripting-engines/trace-event-python.c    |   35 ++++++++++++++++---
 1 files changed, 29 insertions(+), 6 deletions(-)

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
1.7.1

