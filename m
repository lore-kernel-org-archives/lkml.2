Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2HFSTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:19:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44845 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2HFSTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:19:46 -0400
Date: Mon, 6 Aug 2012 15:19:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] perf: teach perf inject to merge sched_stat_* and
 sched_switch events
Message-ID: <20120806181941.GG21441@infradead.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
 <1344247319-304069-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344247319-304069-3-git-send-email-avagin@openvz.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 06, 2012 at 02:01:58PM +0400, Andrew Vagin escreveu:
> You may want to know where and how long a task is sleeping. A callchain
> may be found in sched_switch and a time slice in stat_iowait, so I add
> handler in perf inject for merging this events.
> 
> My code saves sched_switch event for each process and when it meets
> stat_iowait, it reports the sched_switch event, because this event
> contains a correct callchain. By another words it replaces all
> stat_iowait events on proper sched_switch events.
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  tools/perf/builtin-inject.c |   96 ++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 91 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index d04b7a4..247f41c 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -13,6 +13,8 @@
>  #include "util/debug.h"
>  
>  #include "util/parse-options.h"
> +#include "util/trace-event.h"
> +
>  
>  static char		const *input_name	= "-";
>  static const char	*output_name		= "-";
> @@ -21,6 +23,9 @@ static int		output;
>  static u64		bytes_written;
>  
>  static bool		inject_build_ids;
> +static bool		inject_sched_stat;
> +
> +struct perf_session	*session;

Why do we need to insert even more globals?
  
>  static int perf_event__repipe_synth(struct perf_tool *tool __used,
>  				    union perf_event *event,
> @@ -47,7 +52,7 @@ static int perf_event__repipe_synth(struct perf_tool *tool __used,
>  
>  static int perf_event__repipe_op2_synth(struct perf_tool *tool,
>  					union perf_event *event,
> -					struct perf_session *session __used)
> +					struct perf_session *s __used)

What is the point of the above hunk?

>  {
>  	return perf_event__repipe_synth(tool, event, NULL);
>  }
> @@ -59,7 +64,7 @@ static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
>  }
>  
>  static int perf_event__repipe_tracing_data_synth(union perf_event *event,
> -						 struct perf_session *session __used)
> +						 struct perf_session *s __used)

Ditto

>  {
>  	return perf_event__repipe_synth(NULL, event, NULL);
>  }
> @@ -119,12 +124,12 @@ static int perf_event__repipe_task(struct perf_tool *tool,
>  }
>  
>  static int perf_event__repipe_tracing_data(union perf_event *event,
> -					   struct perf_session *session)
> +					   struct perf_session *s)
>  {
>  	int err;
>  
>  	perf_event__repipe_synth(NULL, event, NULL);
> -	err = perf_event__process_tracing_data(event, session);
> +	err = perf_event__process_tracing_data(event, s);

Ditto

>  
>  	return err;
>  }
> @@ -210,6 +215,83 @@ repipe:
>  	return 0;
>  }
>  
> +struct event_entry {
> +	struct list_head list;

Is this really the head of a list? Or is this a node that will allow
event_entry instances to be added to a head of a list? If the former,
please rename this to "node".

> +	u32		 pid;
> +	union perf_event event[0];
> +};
> +
> +static LIST_HEAD(samples);
> +
> +static int perf_event__sched_stat(struct perf_tool *tool,
> +				      union perf_event *event,
> +				      struct perf_sample *sample,
> +				      struct perf_evsel *evsel __used,
> +				      struct machine *machine)
> +{
> +	int type;
> +	struct event_format *e;
> +	const char *evname = NULL;
> +	uint32_t size;
> +	struct event_entry *ent;
> +	union perf_event *event_sw = NULL;
> +	struct perf_sample sample_sw;
> +	int sched_process_exit;
> +
> +	size = event->header.size;
> +
> +	type = trace_parse_common_type(session->pevent, sample->raw_data);
> +	e = pevent_find_event(session->pevent, type);
> +	if (e)
> +		evname = e->name;
> +
> +	sched_process_exit = !strcmp(evname, "sched_process_exit");
> +
> +	if (!strcmp(evname, "sched_switch") ||  sched_process_exit) {
                                              extra space
> +		list_for_each_entry(ent, &samples, list)
> +			if (sample->pid == ent->pid)
> +				break;
> +
> +		if (&ent->list != &samples) {
> +			list_del(&ent->list);
> +			free(ent);
> +		}
> +
> +		if (sched_process_exit)
> +			return 0;
> +
> +		ent = malloc(size + sizeof(struct event_entry));

Can malloc fail?

> +		ent->pid = sample->pid;
> +		memcpy(&ent->event, event, size);
> +		list_add(&ent->list, &samples);
> +		return 0;
> +
> +	} else if (!strncmp(evname, "sched_stat_", 11)) {
> +		u32 pid;
> +
> +		pid = raw_field_value(e, "pid", sample->raw_data);
> +
> +		list_for_each_entry(ent, &samples, list) {
> +			if (pid == ent->pid)
> +				break;
> +		}
> +
> +		if (&ent->list == &samples)
> +			return 0;
> +
> +		event_sw = &ent->event[0];
> +		perf_session__parse_sample(session, event_sw, &sample_sw);
> +		sample_sw.period = sample->period;
> +		sample_sw.time = sample->time;
> +		perf_session__synthesize_sample(session, event_sw, &sample_sw);

Please use perf_evsel__parse_sample, recently introduced.

> +		perf_event__repipe(tool, event_sw, &sample_sw, machine);
> +		return 0;
> +	}
> +
> +	perf_event__repipe(tool, event, sample, machine);
> +
> +	return 0;
> +}
>  struct perf_tool perf_inject = {
>  	.sample		= perf_event__repipe_sample,
>  	.mmap		= perf_event__repipe,
> @@ -235,7 +317,6 @@ static void sig_handler(int sig __attribute__((__unused__)))
>  
>  static int __cmd_inject(void)
>  {
> -	struct perf_session *session;
>  	int ret = -EINVAL;
>  
>  	signal(SIGINT, sig_handler);
> @@ -245,6 +326,9 @@ static int __cmd_inject(void)
>  		perf_inject.mmap	 = perf_event__repipe_mmap;
>  		perf_inject.fork	 = perf_event__repipe_task;
>  		perf_inject.tracing_data = perf_event__repipe_tracing_data;
> +	} else if (inject_sched_stat) {
> +		perf_inject.sample	= perf_event__sched_stat;
> +		perf_inject.ordered_samples = true;
>  	}
>  
>  	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
> @@ -272,6 +356,8 @@ static const char * const report_usage[] = {
>  static const struct option options[] = {
>  	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
>  		    "Inject build-ids into the output stream"),
> +	OPT_BOOLEAN('s', "sched-stat", &inject_sched_stat,
> +		    "Set source call-chains for sched:shed-stat-*"),

You're adding an option, needs to be documented on
perf/tools/Documentation/

>  	OPT_STRING('i', "input", &input_name, "file",
>  		    "input file name"),
>  	OPT_STRING('o', "output", &output_name, "file",
> -- 
> 1.7.1
