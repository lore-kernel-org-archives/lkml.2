Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0LLVcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 16:32:14 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:52350 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab0LLVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 16:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F3DnQVzItTbgywGoR8Gei8lXPvwuFFRpInrwc8k/YaxpVfJK5RohehR0lf+H4XiQti
         HyXK0VvUZ8COwu5W0hLsY1Znz/MyyEOHgqndoNpgMaaI9odxhVBsS6dirwDjxcYkLDOd
         iLyd6uKFaUV2Z7Q0jaatyXqFKab5oXUvqnuBQ=
Date: Sun, 12 Dec 2010 22:32:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Add option to show time history of
 event samples
Message-ID: <20101212213202.GC1784@nowhere>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
 <1291773285-16254-3-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291773285-16254-3-git-send-email-daahern@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 06:54:45PM -0700, David Ahern wrote:
> Add a timehist option to perf record to save cpu and kernel timestamp
> with each sample.
> 
> Add timehist option to perf report to display a pretty-print format
> of the timestamp, cpu, and event data each event rather than
> generating a histogram. The timehist option leverages the reference
> timestamp from the perf header to correlate kernel timestamps to
> time-of-day which allows correlating with external (non-perf)
> log files.
> 
> As an example, consider recording context switches:
>     perf record -e cs -c 1 -ga --timehist
> 
> Today the 'perf report -D' option gives output in the form
> 0 182392227877 0x17d8f8 [0xd8]: PERF_RECORD_SAMPLE(IP, 1): \
> 	1861/1861: 0xffffffff810348d2 period: 2057672
> ... chain: nr:21
> .....  0: ffffffffffffff80
> .....  1: ffffffff810348d2
> .....  2: ffffffff8139c02b
> .....  3: ffffffffa004b4a3
> .....  4: ffffffff8139c79c
> .....  5: ffffffff8139c83d
> .....  6: ffffffffa004b43f
> .....  7: ffffffffa00ec135
> .....  8: ffffffffa00ec214
> .....  9: ffffffffa00f01ec
> ..... 10: ffffffffa00f0439
> ..... 11: ffffffffa00d6e8b
> ..... 12: ffffffff8110b763
> ..... 13: ffffffff8110b883
> ..... 14: ffffffff8110ddcd
> ..... 15: ffffffff8110e45d
> ..... 16: ffffffff81101f36
> ..... 17: ffffffff81101ff3
> ..... 18: ffffffff81002c82
> ..... 19: fffffffffffffe00
> ..... 20: 00002acfd31ce050
>  ... thread: cc1:1861
>  ...... dso: /lib/modules/2.6.37-rc5/build/vmlinux
> 
> With the timehist option 'perf report --timehist' displays the same sample as
> (lines wrapped to < 80 and truncated here):
> 
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff810348d2  perf_event_task_sched_out ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8139c02b  schedule ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffffa004b4a3  rpc_wait_bit_killable (/lib/modules/2.6.37-rc5/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8139c79c  __wait_on_bit ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8139c83d  out_of_line_wait_on_bit ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffffa004b43f  __rpc_wait_for_completion_task (/lib/modules/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffffa00ec135  nfs4_wait_for_completion_rpc_task (/lib/modules/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffffa00ec214  nfs4_run_open_task (/lib/modules/2.6.37-rc5/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffffa00f01ec  nfs4_do_open.clone.21 (/lib/modules/2.6.37-rc5/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
>  	ffffffffa00f0439  nfs4_atomic_open (/lib/modules/2.6.37-rc5/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffffa00d6e8b  nfs_open_revalidate (/lib/modules/2.6.37-rc5/...
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8110b763  do_revalidate ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8110b883  do_lookup ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8110ddcd  do_last ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff8110e45d  do_filp_open ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff81101f36  do_sys_open ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff81101ff3  sys_open ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	ffffffff81002c82  system_call ([kernel.kallsyms])
> 17:11:10.174502     182392227877    0  cc1   1861  \
> 	    2acfd31ce050  __GI___libc_open (/lib64/libc-2.12.90.so)
> 
> While the line lengths are horrible for a git commit message and email,
> the data is indispensable. It allows you to see each schedule out point,
> where the process is when it gets scheduled out and, with additional
> processing on the timehist output, time between schedule-in events and
> time on the processor.
> 
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/builtin-record.c |    8 +++
>  tools/perf/builtin-report.c |  131 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 137 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 699dd21..cf30c98 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -51,6 +51,7 @@ static int			realtime_prio			=      0;
>  static bool			raw_samples			=  false;
>  static bool			sample_id_all_avail		=   true;
>  static bool			system_wide			=  false;
> +static bool			time_history			=  false;
>  static pid_t			target_pid			=     -1;
>  static pid_t			target_tid			=     -1;
>  static pid_t			*all_tids			=      NULL;
> @@ -288,6 +289,11 @@ static void create_counter(int counter, int cpu)
>  	if (sample_time)
>  		attr->sample_type	|= PERF_SAMPLE_TIME;
>  
> +	if (time_history) {
> +		attr->sample_type	|= PERF_SAMPLE_TIME;
> +		attr->sample_type	|= PERF_SAMPLE_CPU;
> +	}
> +
>  	if (raw_samples) {
>  		attr->sample_type	|= PERF_SAMPLE_TIME;
>  		attr->sample_type	|= PERF_SAMPLE_RAW;
> @@ -863,6 +869,8 @@ const struct option record_options[] = {
>  		    "do not update the buildid cache"),
>  	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
>  		    "do not collect buildids in perf.data"),
> +	OPT_BOOLEAN(0, "timehist", &time_history,
> +		    "collect data for time history report"),
>  	OPT_END()
>  };

It seems you should only to the gettimeofday() / clock_gettime()
record if you have time_history set?

Thanks.

>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 904519f..bcde3c2 100644
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
> @@ -124,6 +125,117 @@ out_free_syms:
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
> +#define TIMEHIST_FMT  "%32s  %3d  %-16s %5d  %16Lx  %s (%s)\n"
> +
> +static void timehist_header(void)
> +{
> +	printf("%32s  %3s  %-16s %5s  %16s  %s (%s)\n",
> +		   "  Time-of-Day   Kernel Timestamp",
> +	       "cpu", "Command Name", "PID",
> +	       "    IP    ", "Symbol Name", "DSO Name");
> +}
> +
> +static int perf_session__print_sample(struct perf_session *session,
> +					struct addr_location *al,
> +					struct sample_data *data)
> +{
> +	static int show_timehist_error = 1;
> +	u64 timestamp = 0;
> +	struct map_symbol *syms = NULL;
> +	struct symbol *parent = NULL;
> +	const char *tstr;
> +	bool need_spacer = false;
> +
> +	if (show_timehist_error && ((data->cpu == (u32) -1) ||
> +		 !(session->sample_type & PERF_SAMPLE_TIME))) {
> +		pr_err("Data for time history missing in perf event samples.\n"
> +		       "Did you record with --timehist option?\n");
> +		show_timehist_error = 0;
> +	}
> +
> +	if (session->sample_type & PERF_SAMPLE_TIME)
> +		timestamp = data->time;
> +
> +	tstr = timestr(timestamp, session);
> +
> +
> +	if ((symbol_conf.use_callchain) && data->callchain) {
> +		u64 i;
> +
> +		syms = perf_session__resolve_callchain(session, al->thread,
> +						   data->callchain, &parent);
> +		if (syms == NULL)
> +			return -ENOMEM;
> +
> +		for (i = 0; i < data->callchain->nr; ++i) {
> +			const char *symname = "", *dsoname = "";
> +
> +			if (data->callchain->ips[i] >= PERF_CONTEXT_MAX)
> +				continue;
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
> +
> +			need_spacer = true;
> +		}
> +
> +		free(syms);
> +
> +	} else {
> +		printf(TIMEHIST_FMT,
> +			   tstr, data->cpu,
> +			   al->thread->comm, al->thread->pid, al->addr,
> +			   al->sym->name, al->map->dso->name);
> +
> +		need_spacer = true;
> +	}
> +
> +	/* put a gap between records */
> +	if (need_spacer)
> +		printf("\n");
> +
> +	return 0;
> +}
> +
>  static int add_event_total(struct perf_session *session,
>  			   struct sample_data *data,
>  			   struct perf_event_attr *attr)
> @@ -165,7 +277,9 @@ static int process_sample_event(event_t *event, struct sample_data *sample,
>  	if (al.filtered || (hide_unresolved && al.sym == NULL))
>  		return 0;
>  
> -	if (perf_session__add_hist_entry(session, &al, sample)) {
> +	if (time_history) {
> +		perf_session__print_sample(session, &al, sample);
> +	} else if (perf_session__add_hist_entry(session, &al, sample)) {
>  		pr_debug("problem incrementing symbol period, skipping event\n");
>  		return -1;
>  	}
> @@ -319,6 +433,14 @@ static int __cmd_report(void)
>  	if (ret)
>  		goto out_delete;
>  
> +	if (time_history) {
> +		if (!session->header.nsec_ref) {
> +			pr_err("Reference timestamp missing in perf.data file.\n"
> +			  "Cannot convert kernel timestamps to time-of-day.\n");
> +		}
> +		timehist_header();
> +	}
> +
>  	ret = perf_session__process_events(session, &event_ops);
>  	if (ret)
>  		goto out_delete;
> @@ -334,6 +456,9 @@ static int __cmd_report(void)
>  	if (verbose > 2)
>  		perf_session__fprintf_dsos(session, stdout);
>  
> +	if (time_history)
> +		goto out_delete;
> +
>  	next = rb_first(&session->hists_tree);
>  	while (next) {
>  		struct hists *hists;
> @@ -479,6 +604,8 @@ static const struct option options[] = {
>  		   "columns '.' is reserved."),
>  	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
>  		    "Only display entries resolved to a symbol"),
> +	OPT_BOOLEAN(0, "timehist", &time_history,
> +		    "Dump time history of event samples"),
>  	OPT_END()
>  };
>  
> @@ -486,7 +613,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
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
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
