Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab2ERCwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:17351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab2ERCwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145391864"
Date: Fri, 18 May 2012 10:48:56 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <robert.richter@amd.com>,
        <ak@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf script: Add general python handler to process
 non-tracepoint events
Message-ID: <20120518104856.0ba4da7a@feng-i7>
In-Reply-To: <20120517154315.GA2636@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
	<20120517154315.GA2636@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Thanks for your review!

On Thu, 17 May 2012 12:43:15 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Wed, May 16, 2012 at 08:59:13PM +0800, Feng Tang escreveu:
> > This patch just follows Robert Richter's idea and the commit 37a058ea0
> > 	"perf script: Add generic perl handler to process events"
> > to similarly add a python handler for general events other than tracepoints.
> > 
> > For non-tracepoint events, this patch will try to find a function named
> > "process_general_event" in the python script, and pass the event
> 
> But in perl isn't it named "process_event"? Can't we use the same
> convention in the python case?

Good point, will comply with the perl code.

> 
> > header, attribute, perf_sample, raw_data in format of raw string. And
> > the python script can use "struct" module's unpack function to disasemble
> > the needed info and process.
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  .../util/scripting-engines/trace-event-python.c    |   60
> > +++++++++++++++++++- 1 files changed, 59 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/scripting-engines/trace-event-python.c
> > b/tools/perf/util/scripting-engines/trace-event-python.c index
> > c2623c6..aaf2679 100644 ---
> > a/tools/perf/util/scripting-engines/trace-event-python.c +++
> > b/tools/perf/util/scripting-engines/trace-event-python.c @@ -324,6 +325,63
> > @@ static void python_process_event(union perf_event *pevent __unused,
> > Py_DECREF(t); }
> >  
> > +static void python_process_general_event(union perf_event *pevent __unused,
> > +				 struct perf_sample *sample,
> > +				 struct perf_evsel *evsel __unused,
> > +				 struct machine *machine __unused,
> > +				 struct thread *thread __unused)
> > +{
> > +	PyObject *handler, *retval, *t;
> > +	static char handler_name[64];
> > +	unsigned n = 0;
> > +	void *data = sample->raw_data;
> > +
> > +	t = PyTuple_New(MAX_FIELDS);
> > +	if (!t)
> > +		Py_FatalError("couldn't create Python tuple");
> > +
> > +	sprintf(handler_name, "process_general_event");
> 
> Strange use of sprintf, if you think it is safe to not bounds check, use
> strcpy(), if you still want to use sprintf, please instead use:
> 
> 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");

Ok, will change it. Following is the update patch:


>From 87b855a7c85438f45e1fc89250e392c1d6365ec6 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Fri, 11 May 2012 16:58:05 +0800
Subject: [PATCH] perf script: Add general python handler to process non-tracepoint events

This patch just follows Robert Richter's idea and the commit 37a058ea0
	"perf script: Add generic perl handler to process events"
to similarly add a python handler for general events other than tracepoints.

For non-tracepoint events, this patch will try to find a function named
"process_event" in the python script, and pass the event attribute,
perf_sample, raw_data in format of raw string. And the python script can
use "struct" module's unpack function to disasemble the needed info and process.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../util/scripting-engines/trace-event-python.c    |   60 +++++++++++++++++++-
 1 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c2623c6..6daa12f 100644
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
+				 struct perf_evsel *evsel,
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
+	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
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


