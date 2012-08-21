Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2HUPdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:33:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2HUPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:33:18 -0400
Date: Tue, 21 Aug 2012 08:32:44 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-fd6b858a1e110c76e701cd9972a284ed2a7bcc33@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        peterz@infradead.org, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1344419875-21665-4-git-send-email-feng.tang@intel.com>
References: <1344419875-21665-4-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts python: Pass event/thread/
 dso name and symbol info to event handler in python
Git-Commit-ID: fd6b858a1e110c76e701cd9972a284ed2a7bcc33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:32:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd6b858a1e110c76e701cd9972a284ed2a7bcc33
Gitweb:     http://git.kernel.org/tip/fd6b858a1e110c76e701cd9972a284ed2a7bcc33
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed, 8 Aug 2012 17:57:53 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:48:02 -0300

perf scripts python: Pass event/thread/dso name and symbol info to event handler in python

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
 
