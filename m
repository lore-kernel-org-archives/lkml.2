Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2CEBQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:16:52 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44065 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2CEBQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:16:51 -0500
X-AuditID: 9c930197-b7ccaae000003d69-87-4f541400a033
Message-ID: <4F5413FC.9080904@lge.com>
Date: Mon, 05 Mar 2012 10:16:44 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Luigi Semenzato <semenzato@chromium.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: add PERF_RECORD_EXEC type, to distinguish from
 PERF_RECORD_COMM (DO NOT APPLY)
References: <1330716607-28227-1-git-send-email-semenzato@chromium.org>
In-Reply-To: <1330716607-28227-1-git-send-email-semenzato@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-03 4:30 AM, Luigi Semenzato wrote:
> ---- NOT FINISHED - NOT TESTED ---- rfc only
> 
> I agree with others that adding a new record type is the cleanest solution.
> This is more or less what it takes to add a new record type.  It may be
> more than we like but that's a separate problem.  I am open to other
> solutions.  I may be able to do a bit of refactoring to reduce the
> copy-paste, but of course the CL will grow as the refactoring would
> not be limited to COMM and EXEC.
> 
> ---- actual commit message below ----
> 
> Currently the kernel produces a PERF_RECORD_COMM type record both when
> a process execs and when it renames its "comm" name.  The "perf report"
> command interprets each COMM record as an exec, and flushes all
> mappings to executables when it encounters one.  This can result in the
> inability to correlate IP samples to function symbols.
> 
> This CL adds a PERF_RECORD_EXEC type, which doesn't contain the process
> name (the comm field).  Thus, an exec now must send two records, one EXEC
> and one COMM, whereas a rename sends only a COMM.
> 
> The change is mostly straightforward, but there are some complications
> in the synthesized events sent when "perf record" starts to account for
> existing processes.
> 
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>

I got a build failure after applying it. It seems you missed something like below.


> ---
>   fs/exec.c                  |    1 +
>   include/linux/perf_event.h |   19 +++++-
>   kernel/events/core.c       |  153 +++++++++++++++++++++++++++++++++++++++++---
>   tools/perf/builtin-test.c  |   24 ++-----
>   tools/perf/builtin-top.c   |    5 +-
>   tools/perf/util/event.c    |  148 +++++++++++++++++++++++++++++-------------
>   tools/perf/util/event.h    |   11 +++
>   tools/perf/util/evsel.c    |    5 +-
>   tools/perf/util/python.c   |   42 +++++++++++-
>   tools/perf/util/session.c  |   11 +++
>   tools/perf/util/thread.c   |    1 -
>   tools/perf/util/tool.h     |    1 +
>   12 files changed, 338 insertions(+), 83 deletions(-)
> 
[snip]
...

> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index e3c63ae..98a3cdf 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -869,8 +869,9 @@ static void perf_top__start_counters(struct perf_top *top)
>   		if (symbol_conf.use_callchain)
>   			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
> 
> -		attr->mmap = 1;
> -		attr->comm = 1;
> +		attr->exec_bit = 1;
> +		attr->comm_bit = 1;
> +		attr->mmap_bit = 1;

s/_bit/_attr/


>   		attr->inherit = top->inherit;
>   fallback_missing_features:
>   		if (top->exclude_guest_missing)
[snip]
...

> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 302d49a..84f59c7 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -127,8 +127,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
>   		attr->wakeup_events = 1;
>   	}
> 
> -	attr->mmap = track;
> -	attr->comm = track;
> +	attr->exec_bit = track;
> +	attr->comm_bit = track;
> +	attr->mmap_bit = track;

Ditto.


> 
>   	if (!opts->target_pid&&  !opts->target_tid&&  !opts->system_wide) {
>   		attr->disabled = 1;
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index e03b58a..000b48c 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -156,6 +156,33 @@ static PyTypeObject pyrf_comm_event__type = {
>   	.tp_repr	= (reprfunc)pyrf_comm_event__repr,
>   };
> 
> +static char pyrf_exec_event__doc[] = PyDoc_STR("perf exec event object.");
> +
> +static PyMemberDef pyrf_exec_event__members[] = {
> +	sample_members
> +	member_def(perf_event_header, type, T_UINT, "event type"),
> +	member_def(exec_event, pid, T_UINT, "event pid"),
> +	member_def(exec_event, tid, T_UINT, "event tid"),
> +	{ .name = NULL, },
> +};
> +
> +static PyObject *pyrf_exec_event__repr(struct pyrf_event *pevent)
> +{
> +	return PyString_FromFormat("{ type: exec, pid: %u, tid: %u }",
> +				   pevent->event.exec.pid,
> +				   pevent->event.exec.tid);
> +}
> +
> +static PyTypeObject pyrf_exec_event__type = {
> +	PyVarObject_HEAD_INIT(NULL, 0)
> +	.tp_name	= "perf.exec_event",
> +	.tp_basicsize	= sizeof(struct pyrf_event),
> +	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
> +	.tp_doc		= pyrf_exec_event__doc,
> +	.tp_members	= pyrf_exec_event__members,
> +	.tp_repr	= (reprfunc)pyrf_exec_event__repr,
> +};
> +
>   static char pyrf_throttle_event__doc[] = PyDoc_STR("perf throttle event object.");
> 
>   static PyMemberDef pyrf_throttle_event__members[] = {
> @@ -306,6 +333,9 @@ static int pyrf_event__setup_types(void)
>   	err = PyType_Ready(&pyrf_comm_event__type);
>   	if (err<  0)
>   		goto out;
> +	err = PyType_Ready(&pyrf_exec_event__type);
> +	if (err<  0)
> +		goto out;
>   	err = PyType_Ready(&pyrf_throttle_event__type);
>   	if (err<  0)
>   		goto out;
> @@ -323,6 +353,7 @@ static PyTypeObject *pyrf_event__type[] = {
>   	[PERF_RECORD_MMAP]	 =&pyrf_mmap_event__type,
>   	[PERF_RECORD_LOST]	 =&pyrf_lost_event__type,
>   	[PERF_RECORD_COMM]	 =&pyrf_comm_event__type,
> +	[PERF_RECORD_EXEC]	 =&pyrf_exec_event__type,
>   	[PERF_RECORD_EXIT]	 =&pyrf_task_event__type,
>   	[PERF_RECORD_THROTTLE]	 =&pyrf_throttle_event__type,
>   	[PERF_RECORD_UNTHROTTLE] =&pyrf_throttle_event__type,
> @@ -524,6 +555,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
>   		"precise_ip",
>   		"mmap_data",
>   		"sample_id_all",
> +		"exec",
>   		"wakeup_events",
>   		"bp_type",
>   		"bp_addr",
> @@ -548,7 +580,8 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
>   	    watermark = 0,
>   	    precise_ip = 0,
>   	    mmap_data = 0,
> -	    sample_id_all = 1;
> +	    sample_id_all = 1,
> +	    exec = 0;
>   	int idx = 0;
> 
>   	if (!PyArg_ParseTupleAndKeywords(args, kwargs,

-                                        "|iKiKKiiiiiiiiiiiiiiiiiiiiiKK", kwlist,
+                                        "|iKiKKiiiiiiiiiiiiiiiiiiiiiiKK", kwlist,
                                         &attr.type, &attr.config, &attr.sample_freq,
                                         &sample_period, &attr.sample_type,
                                         &attr.read_format, &disabled, &inherit,


> @@ -561,6 +594,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
>   					&mmap,&comm,&freq,&inherit_stat,
>   					&enable_on_exec,&task,&watermark,
>   					&precise_ip,&mmap_data,&sample_id_all,
> +					&exec,
>   					&attr.wakeup_events,&attr.bp_type,
>   					&attr.bp_addr,&attr.bp_len,&idx))
>   		return -1;

@@ -581,8 +615,8 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
        attr.exclude_kernel = exclude_kernel;
        attr.exclude_hv     = exclude_hv;
        attr.exclude_idle   = exclude_idle;
-       attr.mmap           = mmap;
-       attr.comm           = comm;
+       attr.mmap_attr      = mmap;
+       attr.comm_attr      = comm;
        attr.freq           = freq;
        attr.inherit_stat   = inherit_stat;
        attr.enable_on_exec = enable_on_exec;
@@ -591,6 +625,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
        attr.precise_ip     = precise_ip;
        attr.mmap_data      = mmap_data;
        attr.sample_id_all  = sample_id_all;
+       attr.exec_attr      = exec;

        perf_evsel__init(&pevsel->evsel, &attr, idx);
        return 0;

> @@ -733,10 +767,11 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
>   }
> 
>   static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
> -					 PyObject *args __used, PyObject *kwargs __used)
> +					 PyObject *args __used,
> +					 PyObject *kwargs __used)
>   {
>   	struct perf_evlist *evlist =&pevlist->evlist;
> -        PyObject *list = PyList_New(0);
> +	PyObject *list = PyList_New(0);
>   	int i;
> 
>   	for (i = 0; i<  evlist->nr_fds; ++i) {
> @@ -987,6 +1022,7 @@ static struct {
>   	{ "RECORD_MMAP",       PERF_RECORD_MMAP },
>   	{ "RECORD_LOST",       PERF_RECORD_LOST },
>   	{ "RECORD_COMM",       PERF_RECORD_COMM },
> +	{ "RECORD_EXEC",       PERF_RECORD_EXEC },
>   	{ "RECORD_EXIT",       PERF_RECORD_EXIT },
>   	{ "RECORD_THROTTLE",   PERF_RECORD_THROTTLE },
>   	{ "RECORD_UNTHROTTLE", PERF_RECORD_UNTHROTTLE },
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 9f833cf..a0bff02 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -343,6 +343,8 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
>   		tool->mmap = process_event_stub;
>   	if (tool->comm == NULL)
>   		tool->comm = process_event_stub;
> +	if (tool->exec == NULL)
> +		tool->exec = process_event_stub;
>   	if (tool->fork == NULL)
>   		tool->fork = process_event_stub;
>   	if (tool->exit == NULL)
> @@ -394,6 +396,12 @@ static void perf_event__comm_swap(union perf_event *event)
>   	event->comm.tid = bswap_32(event->comm.tid);
>   }
> 
> +static void perf_event__exec_swap(union perf_event *event)
> +{
> +	event->exec.pid = bswap_32(event->exec.pid);
> +	event->exec.tid = bswap_32(event->exec.tid);
> +}
> +
>   static void perf_event__mmap_swap(union perf_event *event)
>   {
>   	event->mmap.pid	  = bswap_32(event->mmap.pid);
> @@ -464,6 +472,7 @@ typedef void (*perf_event__swap_op)(union perf_event *event);
>   static perf_event__swap_op perf_event__swap_ops[] = {
>   	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
>   	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
> +	[PERF_RECORD_EXEC]		  = perf_event__exec_swap,
>   	[PERF_RECORD_FORK]		  = perf_event__task_swap,
>   	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
>   	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
> @@ -805,6 +814,8 @@ static int perf_session_deliver_event(struct perf_session *session,
>   		return tool->mmap(tool, event, sample, machine);
>   	case PERF_RECORD_COMM:
>   		return tool->comm(tool, event, sample, machine);
> +	case PERF_RECORD_EXEC:
> +		return tool->exec(tool, event, sample, machine);
>   	case PERF_RECORD_FORK:
>   		return tool->fork(tool, event, sample, machine);
>   	case PERF_RECORD_EXIT:
