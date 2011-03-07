Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1CGQuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:50:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51782 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1CGQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lr6ljH90vZHu7L4kGOR+HttAGMpg+XuzH4MFUn74VEt9Xz85r4qZBdQQVFW5r7g+Sg
         6fJheeAWk0+wM16G2wIRMRdQMUQ3u6xz+tH6SrwLhN5NFCdAFrDdAkPNTrpgR64DuWXg
         mfy9xavQDFWE+aBaCAAhoF57+a4TmJ++B2if4=
Date: Mon, 7 Mar 2011 17:50:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 2/2] perf script: support custom field selection for
 output
Message-ID: <20110307165009.GF1873@nowhere>
References: <1299449795-12933-1-git-send-email-daahern@cisco.com>
 <1299449795-12933-3-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299449795-12933-3-git-send-email-daahern@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 03:16:35PM -0700, David Ahern wrote:
> Allow a user to select which fields to print to stdout for event data.
> Options include comm (command name), tid (thread id), pid (process id),
> time (perf timestamp), cpu, event (for event name), trace (for trace
> data), and sym (for IP, symbol name and DSO name).
> 
> This options allows dumping software events with symbols -- my primary
> goal -- and also symbols for trace events if a so desired.
> 
> Default is set to maintain compatibility with current output.
> 
> Thanks to Frederic Weisbecker for detailed suggestions on this approach.
> 
> 
> Examples (output compressed)
> 
> 1. trace, default format
> 
> perf record -ga -e sched:sched_switch
> perf script
> 
> swapper-0 [000]  534.955086: sched_switch: prev_comm=swapper prev_pid=0 ...
> sshd-1678 [000]  534.955093: sched_switch: prev_comm=sshd prev_pid=1678 ...
> sshd-1675 [001]  534.960353: sched_switch: prev_comm=sshd prev_pid=1675 ...
> 
> 2. trace, custom format
> 
> perf record -ga -e sched:sched_switch
> perf script -f comm,pid,time,trace,sym

Nice.

> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index 29ad942..f527287 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -112,6 +112,30 @@ OPTIONS
>  --debug-mode::
>          Do various checks like samples ordering and lost events.
>  
> +-k::
> +--vmlinux=<file>::
> +        vmlinux pathname
> +
> +--kallsyms=<file>::
> +        kallsyms pathname
> +
> +--symfs=<directory>::
> +        Look for files with symbols relative to this directory.
> +
> +-U::
> +--show-unresolved::
> +        Display all addresses including unresolved to a symbol.

We should always do it I think. As long as the sym format is asked, try
to resolve it, otherwise print the raw address.

> +
> +-G::
> +--hide-call-graph::
> +        When printing symbols do not display call chain.
> +
> +-f::
> +--fields
> +        Comma separated list of fields to print. Options are:
> +        comm, tid, pid, time, cpu, sym, trace, event
> +
> +--
>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 48bdf94..c6b9db1 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -12,6 +12,7 @@
>  #include "util/trace-event.h"
>  #include "util/parse-options.h"
>  #include "util/util.h"
> +#include "util/output.h"
>  
>  static char const		*script_name;
>  static char const		*generate_script_lang;
> @@ -19,6 +20,81 @@ static bool			debug_mode;
>  static u64			last_timestamp;
>  static u64			nr_unordered;
>  extern const struct option	record_options[];
> +static bool			show_unresolved;
> +static bool			no_callchain;
> +
> +struct output_option {
> +	const char *str;
> +	enum perf_output_field field;
> +} all_output_options [] = {
> +	{.str = "comm",  .field = PERF_OUTPUT_COMM},
> +	{.str = "tid",   .field = PERF_OUTPUT_TID},
> +	{.str = "pid",   .field = PERF_OUTPUT_PID},
> +	{.str = "time",  .field = PERF_OUTPUT_TIME},
> +	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
> +	{.str = "sym",   .field = PERF_OUTPUT_SYM},
> +	{.str = "trace", .field = PERF_OUTPUT_TRACE},
> +	{.str = "event", .field = PERF_OUTPUT_EVNAME},
> +};
> +
> +/* default set to maintain compatibility with current format */
> +#define output_fields_default   (PERF_OUTPUT_COMM | PERF_OUTPUT_PID | \
> +				PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
> +				PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE)
> +
> +u64 output_fields = output_fields_default;

Hm, we should have one default for tracepoint events and one
for others. For example dso and sym make sense for hardware,
breakpoint and software event, but it makes few sense for tracepoints.

> +
> +static void print_sample_oneline(struct perf_sample *sample,
> +			  struct perf_event_attr *attr,
> +			  struct thread *thread)
> +{
> +	const char *evname;
> +
> +	if (PRINT_FIELD(COMM)) {
> +		int n = 16;
> +		if (PRINT_FIELD(SYM) && !no_callchain)
> +			n = 1;
> +		printf("%*s ", n, thread->comm);
> +	}
> +
> +	if (PRINT_FIELD(PID) && PRINT_FIELD(TID))
> +		printf("%5d/%-5d ", sample->pid, sample->tid);
> +	else if (PRINT_FIELD(PID))
> +		printf("%5d ", sample->pid);
> +	else if (PRINT_FIELD(TID))
> +		printf("%5d ", sample->tid);
> +
> +	if (PRINT_FIELD(CPU))
> +		printf("[%03d] ", sample->cpu);
> +
> +	if (PRINT_FIELD(TIME)) {
> +		unsigned long secs, usecs, nsecs;
> +
> +		nsecs = sample->time;
> +		secs = nsecs / NSECS_PER_SEC;
> +		nsecs -= secs * NSECS_PER_SEC;
> +		usecs = nsecs / NSECS_PER_USEC;
> +		printf("%8lu.%06lu ", secs, usecs);
> +	}
> +
> +	if (PRINT_FIELD(EVNAME)) {
> +		if (attr->type == PERF_TYPE_TRACEPOINT) {
> +			struct event *event;
> +			int type;
> +
> +			type = trace_parse_common_type(sample->raw_data);
> +			event = trace_find_event(type);
> +			if (event)
> +				evname = event->name;
> +		} else
> +			evname = __event_name(attr->type, attr->config);
> +
> +		printf("%s ", evname ? evname : "(unknown)");
> +	}
> +
> +	if (!no_callchain)
> +		printf("\n");
> +}
>  
>  static void process_event(union perf_event *event __unused,
>  			  struct perf_sample *sample,
> @@ -31,8 +107,15 @@ static void process_event(union perf_event *event __unused,
>  	 * field, although it should be the same than this perf
>  	 * event pid
>  	 */
> -	print_event(sample->cpu, sample->raw_data, sample->raw_size,
> -		    sample->time, thread->comm);
> +	if (PRINT_FIELD(TRACE))
> +		print_event(sample->cpu, sample->raw_data,
> +			    sample->raw_size, sample->time,
> +			    thread->comm);

The print_event() thing we have in trace-event-parse.c should really handle only
the raw trace itself. More on that below when I reach that file.

> +	else
> +		print_sample_oneline(sample, attr, thread);
> +
> +	if (PRINT_FIELD(SYM))
> +		perf_session__print_symbols(event, sample, session, show_unresolved);
>  }
>  
>  struct script_spec {
>  	struct list_head	node;
>  	struct scripting_ops	*ops;
> @@ -297,6 +413,43 @@ static int parse_scriptname(const struct option *opt __used,
>  	return 0;
>  }
[...]
> diff --git a/tools/perf/util/output.h b/tools/perf/util/output.h
> new file mode 100644
> index 0000000..9d79852
> --- /dev/null
> +++ b/tools/perf/util/output.h
> @@ -0,0 +1,18 @@
> +#ifndef _PERF_OUTPUT_H
> +#define _PERF_OUTPUT_H
> +
> +enum perf_output_field {
> +    PERF_OUTPUT_COMM            = 1U << 0,
> +    PERF_OUTPUT_TID             = 1U << 1,
> +    PERF_OUTPUT_PID             = 1U << 2,
> +    PERF_OUTPUT_TIME            = 1U << 3,
> +    PERF_OUTPUT_CPU             = 1U << 4,
> +    PERF_OUTPUT_SYM             = 1U << 5,
> +    PERF_OUTPUT_TRACE           = 1U << 6,
> +    PERF_OUTPUT_EVNAME          = 1U << 7,
> +};
> +
> +extern u64 output_fields;
> +#define PRINT_FIELD(x)  (output_fields & PERF_OUTPUT_##x)
> +
> +#endif
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index a3a871f..c862a71 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -10,6 +10,7 @@
>  #include "session.h"
>  #include "sort.h"
>  #include "util.h"
> +#include "trace-event.h"
>  
>  static int perf_session__open(struct perf_session *self, bool force)
>  {
> @@ -1137,3 +1138,77 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
>  	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
>  	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
>  }
> +
> +void perf_session__print_symbols(union perf_event *event,
> +				struct perf_sample *sample,
> +				struct perf_session *session,
> +				bool show_unresolved)
> +{
> +	struct addr_location al;
> +	const char *symname, *dsoname;
> +	struct callchain_cursor *cursor = &session->callchain_cursor;
> +	struct callchain_cursor_node *node;
> +
> +	if (perf_event__preprocess_sample(event, session, &al, sample,
> +					  NULL) < 0) {
> +		error("problem processing %d event, skipping it.\n",
> +			event->header.type);
> +		return;
> +	}
> +
> +	if (symbol_conf.use_callchain && sample->callchain) {
> +
> +		if (perf_session__resolve_callchain(session, al.thread,
> +						sample->callchain, NULL) != 0) {
> +			if (verbose)
> +				error("Failed to resolve callchain. Skipping\n");
> +			return;
> +		}
> +		callchain_cursor_commit(cursor);
> +		if (cursor->nr == 0)
> +			return;

I guess you don't need the above check.

> +
> +		while (1) {
> +			node = callchain_cursor_current(cursor);
> +			if (!node)
> +				break;
> +
> +			if (node->sym && node->sym->name)
> +				symname = node->sym->name;
> +			else if (show_unresolved)
> +				symname = "";
> +			else
> +				goto next;
> +
> +			if (node->map && node->map->dso && node->map->dso->name)
> +				dsoname = node->map->dso->name;
> +			else if (show_unresolved)
> +				dsoname = "";
> +			else
> +				goto next;
> +
> +			printf("\t%16" PRIx64 " %s (%s)\n", node->ip, symname, dsoname);
> +
> +next:
> +			callchain_cursor_advance(cursor);
> +		}
> +		printf("\n");
> +
> +	} else {
> +		if (al.sym && al.sym->name)
> +			symname = al.sym->name;
> +		else if (show_unresolved)
> +			symname = "";
> +		else
> +			return;
> +
> +		if (al.map && al.map->dso && al.map->dso->name)
> +			dsoname = al.map->dso->name;
> +		else if (show_unresolved)
> +			dsoname = "";
> +		else
> +			return;
> +
> +		printf("%16" PRIx64 " %s (%s)\n", al.addr, symname, dsoname);
> +	}
> +}
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 977b3a1..d77a2fa 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -165,4 +165,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
>  					session->sample_id_all, sample);
>  }
>  
> +void perf_session__print_symbols(union perf_event *event,
> +				struct perf_sample *sample,
> +				struct perf_session *session,
> +				bool show_unresolved);
> +
>  #endif /* __PERF_SESSION_H */
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index d8e622d..9ac6524 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -32,6 +32,7 @@
>  #include "../perf.h"
>  #include "util.h"
>  #include "trace-event.h"
> +#include "output.h"
>  
>  int header_page_ts_offset;
>  int header_page_ts_size;
> @@ -2683,13 +2684,18 @@ static void print_graph_proc(int pid, const char *comm)
>  	/* sign + log10(MAX_INT) + '\0' */
>  	char pid_str[11];
>  	int spaces = 0;
> -	int len;
> +	int len = 0;
>  	int i;
>  
>  	sprintf(pid_str, "%d", pid);
>  
>  	/* 1 stands for the "-" character */
> -	len = strlen(comm) + strlen(pid_str) + 1;
> +	if (PRINT_FIELD(COMM) && PRINT_FIELD(PID))
> +		len = strlen(comm) + strlen(pid_str) + 1;
> +	else if (PRINT_FIELD(COMM))
> +		len = strlen(comm);
> +	else if (PRINT_FIELD(PID))
> +		len = strlen(pid_str);

For now we don't use that function because the function graph tracer
is not yet supported by perf.

Just forget about that, we'll take care of that later. Consider
pretty_print_func_graph() can't be called.

trace-event-parse.c and its print_event() pretty printing should not care
about the output format. It only needs to print the raw trace itself.
All the comm, time, etc... things should be handled from perf script
core.

In fact, print_event() should really be renamed print_trace() or something.

Other than that, looks like a right direction.

Thanks!
