Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0EaVgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:36:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48853 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0EaVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TwFOPui6iOGZC7VdmCWsiz0wRee1Xe0+NZHS9kAzl922Z4ddrj7bIifi0Fpg1shvmy
         nVmUc/lsk5O66p4YyzF0V1jja4jpxJWTSMY9ZLMSixVK4j1Xn/zp1fGneHFAqAXkxBLS
         Vq349RWdEWz9c+8wZY4ydG4dBleT+Aau/1saI=
Subject: Re: [PATCH] trace-event-python: give field dict to unhandled
 callback
From: Tom Zanussi <tzanussi@gmail.com>
To: Pierre Tardy <tardyp@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1275340329-2397-1-git-send-email-tardyp@gmail.com>
References: <AANLkTimP7PwL7sRV_FVaa57JhWZ9wHJBYRnnbXPdj-ls@mail.gmail.com>
	 <1275340329-2397-1-git-send-email-tardyp@gmail.com>
Content-Type: text/plain
Date: Mon, 31 May 2010 16:36:03 -0500
Message-Id: <1275341763.12629.0.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 23:12 +0200, Pierre Tardy wrote:
> trace_unhandled() callback does not allow to access event fields, this
> patch resolves the problem.
> 
> It can also been used as a more pythonic and flexible way for script
> writters to demux event types
> 
> This will for example greatly simplify pytimechart event demux.
> 
> Signed-off-by: Pierre Tardy <tardyp@gmail.com>

Acked-by: Tom Zanussi <tzanussi@gmail.com>

Looks good, thanks,

Tom

> ---
>  tools/perf/scripts/python/check-perf-trace.py      |    3 +-
>  .../util/scripting-engines/trace-event-python.c    |   50 +++++++++++++------
>  2 files changed, 35 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
> index 964d934..d9f7893 100644
> --- a/tools/perf/scripts/python/check-perf-trace.py
> +++ b/tools/perf/scripts/python/check-perf-trace.py
> @@ -51,8 +51,7 @@ def kmem__kmalloc(event_name, context, common_cpu,
>  
>  		flag_str("kmem__kmalloc", "gfp_flags", gfp_flags)),
>  
> -def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
> -		common_pid, common_comm):
> +def trace_unhandled(event_name, context, event_fields_dict):
>      try:
>          unhandled[event_name] += 1
>      except TypeError:
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 81f39ca..33a6325 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -208,7 +208,7 @@ static void python_process_event(int cpu, void *data,
>  				 int size __unused,
>  				 unsigned long long nsecs, char *comm)
>  {
> -	PyObject *handler, *retval, *context, *t, *obj;
> +	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
>  	static char handler_name[256];
>  	struct format_field *field;
>  	unsigned long long val;
> @@ -232,6 +232,14 @@ static void python_process_event(int cpu, void *data,
>  
>  	sprintf(handler_name, "%s__%s", event->system, event->name);
>  
> +	handler = PyDict_GetItemString(main_dict, handler_name);
> +	if (handler && !PyCallable_Check(handler))
> +		handler = NULL;
> +	if (!handler) {
> +		dict = PyDict_New();
> +		if (!dict)
> +			Py_FatalError("couldn't create Python dict");
> +	}
>  	s = nsecs / NSECS_PER_SEC;
>  	ns = nsecs - s * NSECS_PER_SEC;
>  
> @@ -242,12 +250,20 @@ static void python_process_event(int cpu, void *data,
>  	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
>  	PyTuple_SetItem(t, n++,
>  			PyCObject_FromVoidPtr(scripting_context, NULL));
> -	PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
> -	PyTuple_SetItem(t, n++, PyInt_FromLong(s));
> -	PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
> -	PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
> -	PyTuple_SetItem(t, n++, PyString_FromString(comm));
>  
> +	if (handler) {
> +		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
> +		PyTuple_SetItem(t, n++, PyInt_FromLong(s));
> +		PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
> +		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
> +		PyTuple_SetItem(t, n++, PyString_FromString(comm));
> +	} else {
> +		PyDict_SetItemString(dict, "common_cpu", PyInt_FromLong(cpu));
> +		PyDict_SetItemString(dict, "common_s", PyInt_FromLong(s));
> +		PyDict_SetItemString(dict, "common_ns", PyInt_FromLong(ns));
> +		PyDict_SetItemString(dict, "common_pid", PyInt_FromLong(pid));
> +		PyDict_SetItemString(dict, "common_comm", PyString_FromString(comm));
> +	}
>  	for (field = event->format.fields; field; field = field->next) {
>  		if (field->flags & FIELD_IS_STRING) {
>  			int offset;
> @@ -272,27 +288,31 @@ static void python_process_event(int cpu, void *data,
>  					obj = PyLong_FromUnsignedLongLong(val);
>  			}
>  		}
> -		PyTuple_SetItem(t, n++, obj);
> +		if (handler)
> +			PyTuple_SetItem(t, n++, obj);
> +		else
> +			PyDict_SetItemString(dict, field->name, obj);
> +
>  	}
> +	if (!handler)
> +		PyTuple_SetItem(t, n++, dict);
>  
>  	if (_PyTuple_Resize(&t, n) == -1)
>  		Py_FatalError("error resizing Python tuple");
>  
> -	handler = PyDict_GetItemString(main_dict, handler_name);
> -	if (handler && PyCallable_Check(handler)) {
> +	if (handler) {
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
>  	} else {
>  		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
>  		if (handler && PyCallable_Check(handler)) {
> -			if (_PyTuple_Resize(&t, N_COMMON_FIELDS) == -1)
> -				Py_FatalError("error resizing Python tuple");
>  
>  			retval = PyObject_CallObject(handler, t);
>  			if (retval == NULL)
>  				handler_call_die("trace_unhandled");
>  		}
> +		Py_DECREF(dict);
>  	}
>  
>  	Py_DECREF(t);
> @@ -548,12 +568,10 @@ static int python_generate_script(const char *outfile)
>  	}
>  
>  	fprintf(ofp, "def trace_unhandled(event_name, context, "
> -		"common_cpu, common_secs, common_nsecs,\n\t\t"
> -		"common_pid, common_comm):\n");
> +		"event_fields_dict):\n");
>  
> -	fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
> -		"common_secs, common_nsecs,\n\t\tcommon_pid, "
> -		"common_comm)\n\n");
> +	fprintf(ofp, "\t\tprint ' '.join(['%%s=%%s'%%(k,str(v))"
> +		"for k,v in sorted(event_fields_dict.items())])\n\n");
>  
>  	fprintf(ofp, "def print_header("
>  		"event_name, cpu, secs, nsecs, pid, comm):\n"

