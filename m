Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab2HIBAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 21:00:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62007 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675Ab2HIBAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 21:00:48 -0400
X-AuditID: 9c930179-b7bdcae000003d91-8f-50230bbe6277
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5 1/5] perf script: Add general python handler to process non-tracepoint events
References: <1344419875-21665-1-git-send-email-feng.tang@intel.com>
	<1344419875-21665-2-git-send-email-feng.tang@intel.com>
Date: Thu, 09 Aug 2012 09:54:53 +0900
In-Reply-To: <1344419875-21665-2-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Wed, 8 Aug 2012 17:57:51 +0800")
Message-ID: <87vcgsyjdu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Feng

On Wed,  8 Aug 2012 17:57:51 +0800, Feng Tang wrote:
> This patch just follows Robert Richter's idea and the commit 37a058ea0
> 	"perf script: Add generic perl handler to process events"
> to similarly add a python handler for general events other than tracepoints.
>
> For non-tracepoint events, this patch will try to find a function named
> "process_event" in the python script, and pass the event attribute,
> perf_sample, raw_data in format of raw string. And the python script can
> use "struct" module's unpack function to disasemble the needed info and process.
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Stephane Eranian <eranian@google.com>
> http://lkml.kernel.org/r/1339999839-14007-2-git-send-email-feng.tang@intel.com
> [ committer note: Fixed up wrt da37896, i.e. pevent parm in script event handlers ]
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  .../util/scripting-engines/trace-event-python.c    |   59 +++++++++++++++++++-
>  1 files changed, 58 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index df7d33d..b9010d8 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -32,6 +32,7 @@
>  #include "../event.h"
>  #include "../thread.h"
>  #include "../trace-event.h"
> +#include "../evsel.h"
>  
>  PyMODINIT_FUNC initperf_trace_context(void);
>  
> @@ -220,7 +221,7 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
>  	return event;
>  }
>  
> -static void python_process_event(union perf_event *perf_event __unused,
> +static void python_process_tracepoint(union perf_event *perf_event __unused,
>  				 struct perf_sample *sample,
>  				 struct perf_evsel *evsel,
>  				 struct machine *machine __unused,
> @@ -337,6 +338,62 @@ static void python_process_event(union perf_event *perf_event __unused,
>  	Py_DECREF(t);
>  }
>  
> +static void python_process_general_event(union perf_event *perf_event __unused,
> +					 struct perf_sample *sample,
> +					 struct perf_evsel *evsel,
> +					 struct machine *machine __unused,
> +					 struct thread *thread __unused)
> +{
> +	PyObject *handler, *retval, *t;
> +	static char handler_name[64];
> +	unsigned n = 0;
> +	void *data = sample->raw_data;
> +
> +	t = PyTuple_New(MAX_FIELDS);
> +	if (!t)
> +		Py_FatalError("couldn't create Python tuple");
> +
> +	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
> +
> +	handler = PyDict_GetItemString(main_dict, handler_name);
> +	if (handler && !PyCallable_Check(handler)) {

Shouldn't it be like below?

	if (!handler || !PyCallable_Check(handler))
		goto exit;

Otherwise we can end up calling PyObject_CallObject with NULL handler
if PyDict_GetItemString() returns NULL. And the handler won't be used
anymore so no need to set it to NULL (again).

Thanks,
Namhyung


> +		handler = NULL;
> +		goto exit;
> +	}
> +
> +	/* Pass 3 parameters: event_attr, perf_sample, raw data */
> +	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)&evsel->attr, sizeof(evsel->attr)));
> +	PyTuple_SetItem(t, n++, PyString_FromStringAndSize((void *)sample, sizeof(*sample)));
> +	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(data, sample->raw_size));
> +
> +	if (_PyTuple_Resize(&t, n) == -1)
> +		Py_FatalError("error resizing Python tuple");
> +
> +	retval = PyObject_CallObject(handler, t);
> +	if (retval == NULL)
> +		handler_call_die(handler_name);
> +exit:
> +	Py_DECREF(t);
> +}
> +
> +static void python_process_event(union perf_event *perf_event,
> +				 struct perf_sample *sample,
> +				 struct perf_evsel *evsel,
> +				 struct machine *machine,
> +				 struct thread *thread)
> +{
> +	switch (evsel->attr.type) {
> +	case PERF_TYPE_TRACEPOINT:
> +		python_process_tracepoint(perf_event, sample, evsel,
> +					  machine, thread);
> +		break;
> +	/* Reserve for future process_hw/sw/raw APIs */
> +	default:
> +		python_process_general_event(perf_event, sample, evsel,
> +					     machine, thread);
> +	}
> +}
> +
>  static int run_start_sub(void)
>  {
>  	PyObject *handler, *retval;
