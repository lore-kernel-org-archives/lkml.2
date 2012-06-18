Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2FRGOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:14:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:47903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab2FRGOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181384486"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 3/3] perf script/python: Pass event/thread/dso name and symbol info to event handler in python
Date: Mon, 18 Jun 2012 14:10:39 +0800
Message-Id: <1339999839-14007-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
References: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also as suggested by Arnaldo, pack all these parameters to a dictionary,
which is more expandable for adding new parameters while keep the
compatibility for old scripts.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../util/scripting-engines/trace-event-python.c    |   32 +++++++++++++++----
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 97f4fad..e8ac480 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -336,15 +336,23 @@ static void python_process_general_event(union perf_event *pevent __unused,
 				 struct machine *machine __unused,
 				 struct addr_location *al)
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
@@ -353,14 +361,23 @@ static void python_process_general_event(union perf_event *pevent __unused,
 		goto exit;
 	}
 
-	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread name */
-	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
+	PyDict_SetItemString(dict, "ev_name", PyString_FromString(event_name(evsel)));
+	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
+	PyDict_SetItemString(dict, "sample", PyString_FromStringAndSize(
 			(const char *)sample, sizeof(*sample)));
-	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
-			data, sample->raw_size));
+	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
+			(const char *)sample->raw_data, sample->raw_size));
+	PyDict_SetItemString(dict, "comm",
+			PyString_FromString(thread->comm));
+	PyDict_SetItemString(dict, "dso",
+			PyString_FromString(al->map->dso->name));
+	if (al->sym) {
+		PyDict_SetItemString(dict, "symbol",
+			PyString_FromString(al->sym->name));
+	}
 
+	PyTuple_SetItem(t, n++, dict);
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
 
@@ -368,6 +385,7 @@ static void python_process_general_event(union perf_event *pevent __unused,
 	if (retval == NULL)
 		handler_call_die(handler_name);
 exit:
+	Py_DECREF(dict);
 	Py_DECREF(t);
 }
 
-- 
1.7.1

