Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2HIFlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:41:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47813 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2HIFlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:41:10 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-57-50234d726955
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf script python: Correct handler check and spelling errors
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
	<1344446028-21381-12-git-send-email-acme@infradead.org>
	<878vdoydj2.fsf@sejong.aot.lge.com> <20120809132401.64a18d27@feng-i7>
Date: Thu, 09 Aug 2012 14:35:13 +0900
In-Reply-To: <20120809132401.64a18d27@feng-i7> (Feng Tang's message of "Thu, 9
	Aug 2012 13:24:01 +0800")
Message-ID: <87zk64wru6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012 13:24:01 +0800, Feng Tang wrote:
> From 3332f03c6e8f641e26430a25704c364c2f30d833 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Thu, 9 Aug 2012 12:50:56 +0800
> Subject: [PATCH] perf script python: Correct handler check and spelling errors
>
> Correct the checking for handler returned by PyDict_GetItemString(), also
> fix some spelling error and remove some data code in event_analyzing_sample.py,
> as suggested by Namhyung Kim.
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
[SNIP]
> -
> -def trace_unhandled(event_name, context, event_fields_dict):
> -		print ' '.join(['%s=%s'%(k,str(v))for k,v in sorted(event_fields_dict.items())])

I guess we need to have the trace_unhandled as a safety net since it can
be called from the scripting-engine?

Thanks,
Namhyung


> -
> -def print_header(event_name, cpu, secs, nsecs, pid, comm):
> -	print "%-20s %5u %05u.%09u %8u %-20s " % \
> -	(event_name, cpu, secs, nsecs, pid, comm),
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 7e3f576..afba097 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -343,7 +343,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
>  					 struct perf_sample *sample,
>  					 struct perf_evsel *evsel,
>  					 struct machine *machine __unused,
> -					 struct addr_location *al __unused)
> +					 struct addr_location *al)
>  {
>  	PyObject *handler, *retval, *t, *dict;
>  	static char handler_name[64];
> @@ -352,7 +352,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
>  
>  	/*
>  	 * Use the MAX_FIELDS to make the function expandable, though
> -	 * currently there is only one itme for the tuple.
> +	 * currently there is only one item for the tuple.
>  	 */
>  	t = PyTuple_New(MAX_FIELDS);
>  	if (!t)
> @@ -365,10 +365,8 @@ static void python_process_general_event(union perf_event *perf_event __unused,
>  	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
>  
>  	handler = PyDict_GetItemString(main_dict, handler_name);
> -	if (handler && !PyCallable_Check(handler)) {
> -		handler = NULL;
> +	if (!handler || !PyCallable_Check(handler))
>  		goto exit;
> -	}
>  
>  	PyDict_SetItemString(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
>  	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
