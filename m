Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2ERPfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab2ERPfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:35:50 -0400
Date: Fri, 18 May 2012 12:34:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, robert.richter@amd.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf script: Add general python handler to process
 non-tracepoint events
Message-ID: <20120518153432.GE2636@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
 <20120517154315.GA2636@infradead.org>
 <20120518104856.0ba4da7a@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518104856.0ba4da7a@feng-i7>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 18, 2012 at 10:48:56AM +0800, Feng Tang escreveu:
> Hi Arnaldo,
> 
> Thanks for your review!

you're welcome, keep sending patches ;-)
 
> 
> Ok, will change it. Following is the update patch:

Please next time answer the suggestions/requests inline then send a
separate patchset, with "[PATCH N/M v2] patch summary", its the norm for
such cases and makes the scales things up for maintainers :-)

I'll process this one now.

- Arnaldo
 
> 
> From 87b855a7c85438f45e1fc89250e392c1d6365ec6 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Fri, 11 May 2012 16:58:05 +0800
> Subject: [PATCH] perf script: Add general python handler to process non-tracepoint events
> 
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
> ---
>  .../util/scripting-engines/trace-event-python.c    |   60 +++++++++++++++++++-
>  1 files changed, 59 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index c2623c6..6daa12f 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -31,6 +31,7 @@
>  #include "../event.h"
>  #include "../thread.h"
>  #include "../trace-event.h"
> +#include "../evsel.h"
>  
>  PyMODINIT_FUNC initperf_trace_context(void);
>  
> @@ -205,7 +206,7 @@ static inline struct event *find_cache_event(int type)
>  	return event;
>  }
>  
> -static void python_process_event(union perf_event *pevent __unused,
> +static void python_process_tracepoint(union perf_event *pevent __unused,
>  				 struct perf_sample *sample,
>  				 struct perf_evsel *evsel __unused,
>  				 struct machine *machine __unused,
> @@ -324,6 +325,63 @@ static void python_process_event(union perf_event *pevent __unused,
>  	Py_DECREF(t);
>  }
>  
> +static void python_process_general_event(union perf_event *pevent __unused,
> +				 struct perf_sample *sample,
> +				 struct perf_evsel *evsel,
> +				 struct machine *machine __unused,
> +				 struct thread *thread __unused)
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
> +		handler = NULL;
> +		goto exit;
> +	}
> +
> +	/* Pass 3 parameters: event_attr, perf_sample, raw data */
> +	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> +			(const char *)&evsel->attr, sizeof(evsel->attr)));
> +	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> +			(const char *)sample, sizeof(*sample)));
> +	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> +			data, sample->raw_size));
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
> +static void python_process_event(union perf_event *pevent,
> +				 struct perf_sample *sample,
> +				 struct perf_evsel *evsel,
> +				 struct machine *machine,
> +				 struct thread *thread)
> +{
> +	switch (evsel->attr.type) {
> +	case PERF_TYPE_TRACEPOINT:
> +		python_process_tracepoint(pevent, sample, evsel, machine, thread);
> +		break;
> +	/* Reserve for future process_hw/sw/raw APIs */
> +	default:
> +		python_process_general_event(pevent, sample, evsel, machine, thread);
> +	}
> +}
> +
>  static int run_start_sub(void)
>  {
>  	PyObject *handler, *retval;
> -- 
> 1.7.1
> 
