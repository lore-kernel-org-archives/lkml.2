Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0K3TZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:25:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58229 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0K3TZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=QHT0G04Z5o22BmyL3plh45DywO/lhvabZ3gk42ZlQmaNEe0YIrxObJ13CloiD2R74u
         GYQsNToLvSSY1zVc+af2q3+cXo42GEeIRtuiz/7lZVf3vtkrkhTcLrEoW27FAPpd9cwQ
         Os+ij44CPx8yl6pM+eQCn/xBElwul0RfUA6SE=
Date: Tue, 30 Nov 2010 17:19:05 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf tools: Add option to show time history of event
 samples
Message-ID: <20101130191905.GB9706@ghostprotocols.net>
References: <1291072029-19178-1-git-send-email-daahern@cisco.com>
 <1291072029-19178-3-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291072029-19178-3-git-send-email-daahern@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding more people to the CC, hope they can stick some Acked-by on the
final version of this patch.

Em Mon, Nov 29, 2010 at 04:07:09PM -0700, David Ahern escreveu:
> Add a timehist option to perf record to save cpu and kernel timestamp
> with each sample. Add timehist option to perf report to display the
> cpu and timestamps for each event sample rather than generating a
> histogram. The timehist option leverages the reference timestamp
> from the perf header to create time-of-day stamps.
> 
> This option has been extremely in analyzing context switches. The
> time history output can be mined for data such as how long a process
> runs when scheduled in, where it is when scheduled out (ie., backtrace)
> and how long between schedule in events.

Suggestion: Please put some example output on the commit log message,
that way reviewers can have a glimpse of how it looks like.

More comments below.
 
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/builtin-record.c |    8 +++
>  tools/perf/builtin-report.c |  120 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 126 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 024e144..2496b04 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -49,6 +49,7 @@ static int			group				=      0;
>  static int			realtime_prio			=      0;
>  static bool			raw_samples			=  false;
>  static bool			system_wide			=  false;
> +static bool			time_history			=  false;
>  static pid_t			target_pid			=     -1;
>  static pid_t			target_tid			=     -1;
>  static pid_t			*all_tids			=      NULL;
> @@ -281,6 +282,11 @@ static void create_counter(int counter, int cpu)
>  	if (system_wide)
>  		attr->sample_type	|= PERF_SAMPLE_CPU;
>  
> +	if (time_history) {
> +		attr->sample_type	|= PERF_SAMPLE_TIME;
> +		attr->sample_type	|= PERF_SAMPLE_CPU;
> +	}
> +
>  	if (raw_samples) {
>  		attr->sample_type	|= PERF_SAMPLE_TIME;
>  		attr->sample_type	|= PERF_SAMPLE_RAW;
> @@ -840,6 +846,8 @@ const struct option record_options[] = {
>  		    "do not update the buildid cache"),
>  	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
>  		    "do not collect buildids in perf.data"),
> +	OPT_BOOLEAN(0, "timehist", &time_history,
> +		    "collect data for time history report"),
>  	OPT_END()
>  };
>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 5de405d..042dc7c 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -35,6 +35,7 @@ static char		const *input_name = "perf.data";
>  static bool		force, use_tui, use_stdio;
>  static bool		hide_unresolved;
>  static bool		dont_use_callchains;
> +static bool		time_history;
>  
>  static bool		show_threads;
>  static struct perf_read_values	show_threads_values;
> @@ -124,6 +125,106 @@ out_free_syms:
>  	return err;
>  }
>  
> +static const char *timestr(u64 timestamp, struct perf_session *session)
> +{
> +	struct tm ltime;
> +	u64 dt;
> +	struct timeval tv_dt, tv_res;
> +	static char tstr[64];
> +
> +	dt = timestamp - session->header.nsec_ref;
> +	tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
> +	tv_dt.tv_usec = (suseconds_t) ((dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000);
> +
> +	timeradd(&session->header.tv_ref, &tv_dt, &tv_res);
> +
> +	if ((session->header.nsec_ref == 0) ||
> +		(localtime_r(&tv_res.tv_sec, &ltime) == NULL)) {
> +		snprintf(tstr, sizeof(tstr), "00:00:00.000000 %16Ld", timestamp);
> +	} else {
> +		char date[64];
> +		strftime(date, sizeof(date), "%H:%M:%S", &ltime);
> +		snprintf(tstr, sizeof(tstr), "%s.%06ld %16Ld",
> +		         date, tv_res.tv_usec, timestamp);
> +	}
> +
> +	return tstr;
> +}
> +
> +#define TIMEHIST_FMT  "%33s  %3d  %-16s %5d  %16Lx  %s (%s)\n"
> +
> +static void timehist_header(void)
> +{
> +	printf("%33s  %3s  %-16s %5s  %16s  %s (%s)\n",
> +		   "  Time-of-Day   Kernel Timestamp",
> +	       "cpu", "Command Name", "PID",
> +	       "    IP    ", "Symbol Name", "DSO Name");
> +}
> +
> +static int perf_session__print_sample(struct perf_session *self,

Please replace self with 'session', Thomas suggested that and I agreed
that its better. We'll slowly rename all those self variables.

> +					struct addr_location *al,
> +					struct sample_data *data)
> +{
> +	static int show_timehist_error = 1;
> +	u64 timestamp = 0;
> +	struct map_symbol *syms = NULL;
> +	struct symbol *parent = NULL;
> +	const char *tstr;
> +
> +	if (show_timehist_error &&
> +		((data->cpu == (u32) -1) || !(self->sample_type & PERF_SAMPLE_TIME))) {
> +		pr_err("Data for time history missing in perf event samples.\n"
> +		       "Did you record with -T option?\n");

--timehist

As you used:

+	OPT_BOOLEAN(0, "timehist", &time_history,
+		    "Dump time history of event samples"),

In a branch I'm working on I'm using 'T' to mean "--sample_time", i.e.
to ask for just PERF_SAMPLE_TIME

> +		show_timehist_error = 0;
> +	}
> +
> +	if (self->sample_type & PERF_SAMPLE_TIME)
> +		timestamp = data->time;
> +
> +	tstr = timestr(timestamp, self);
> +
> +
> +	if ((symbol_conf.use_callchain) && data->callchain) {
> +		u64 i;
> +
> +		syms = perf_session__resolve_callchain(self, al->thread,
> +						       data->callchain, &parent);
> +		if (syms == NULL)
> +			return -ENOMEM;
> +
> +		for (i = 0; i < data->callchain->nr; ++i) {
> +			const char *symname = "", *dsoname = "";
> +
> +			if (syms[i].sym && syms[i].sym->name)
> +				symname = syms[i].sym->name;
> +			else if (hide_unresolved)
> +				continue;
> +
> +			if (syms[i].map && syms[i].map->dso &&
> +					syms[i].map->dso->name)
> +				dsoname = syms[i].map->dso->name;
> +			else if (hide_unresolved)
> +				continue;
> +
> +			printf(TIMEHIST_FMT,
> +				   tstr, data->cpu,
> +				   al->thread->comm, al->thread->pid,
> +				   data->callchain->ips[i], symname, dsoname);
> +		}
> +
> +		free(syms);
> +
> +	} else {
> +		printf(TIMEHIST_FMT,
> +			   tstr, data->cpu,
> +			   al->thread->comm, al->thread->pid, al->addr,
> +			   al->sym->name, al->map->dso->name);
> +	}
> +	printf("\n");
> +
> +	return 0;
> +}
> +
>  static int add_event_total(struct perf_session *session,
>  			   struct sample_data *data,
>  			   struct perf_event_attr *attr)
> @@ -165,7 +266,9 @@ static int process_sample_event(event_t *event, struct perf_session *session)
>  	if (al.filtered || (hide_unresolved && al.sym == NULL))
>  		return 0;
>  
> -	if (perf_session__add_hist_entry(session, &al, &data)) {
> +	if (time_history) {
> +		perf_session__print_sample(session, &al, &data);
> +	} else if (perf_session__add_hist_entry(session, &al, &data)) {
>  		pr_debug("problem incrementing symbol period, skipping event\n");
>  		return -1;
>  	}
> @@ -318,6 +421,14 @@ static int __cmd_report(void)
>  	if (ret)
>  		goto out_delete;
>  
> +	if (time_history) {
> +		if (!session->header.nsec_ref) {
> +			pr_err("Reference timestamp missing in perf.data file.\n"
> +			       "Cannot convert kernel timestamps to time-of-day.\n");
> +		}
> +		timehist_header();
> +	}
> +
>  	ret = perf_session__process_events(session, &event_ops);
>  	if (ret)
>  		goto out_delete;
> @@ -333,6 +444,9 @@ static int __cmd_report(void)
>  	if (verbose > 2)
>  		perf_session__fprintf_dsos(session, stdout);
>  
> +	if (time_history)
> +		goto out_delete;
> +
>  	next = rb_first(&session->hists_tree);
>  	while (next) {
>  		struct hists *hists;
> @@ -478,6 +592,8 @@ static const struct option options[] = {
>  		   "columns '.' is reserved."),
>  	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
>  		    "Only display entries resolved to a symbol"),
> +	OPT_BOOLEAN(0, "timehist", &time_history,
> +		    "Dump time history of event samples"),
>  	OPT_END()
>  };
>  
> @@ -485,7 +601,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  {
>  	argc = parse_options(argc, argv, options, report_usage, 0);
>  
> -	if (use_stdio)
> +	if (use_stdio || time_history)
>  		use_browser = 0;
>  	else if (use_tui)
>  		use_browser = 1;
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
