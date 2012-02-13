Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2BMSda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:33:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62347 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2BMSd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:33:28 -0500
Date: Mon, 13 Feb 2012 16:33:21 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] perf stat: Convert to perf_maps_opts
Message-ID: <20120213183321.GE15955@infradead.org>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
 <1329118064-9412-3-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329118064-9412-3-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 13, 2012 at 04:27:34PM +0900, Namhyung Kim escreveu:
> Use struct perf_maps_opts as it is introduces by previous patch.
> This is a preparation of further changes.

This one ok, as the other ones that are just makes the tools use 'struct
perf_target'

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/builtin-stat.c |   50 +++++++++++++++++++++++---------------------
>  1 files changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index d14b37ad7638..14a30c2b9fe0 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -175,22 +175,17 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
>  
>  struct perf_evlist		*evsel_list;
>  
> -static bool			system_wide			=  false;
>  static int			run_idx				=  0;
> -
>  static int			run_count			=  1;
>  static bool			no_inherit			= false;
>  static bool			scale				=  true;
>  static bool			no_aggr				= false;
> -static pid_t			target_pid			= -1;
> -static pid_t			target_tid			= -1;
>  static pid_t			child_pid			= -1;
>  static bool			null_run			=  false;
>  static int			detailed_run			=  0;
>  static bool			sync_run			=  false;
>  static bool			big_num				=  true;
>  static int			big_num_opt			=  -1;
> -static const char		*cpu_list;
>  static const char		*csv_sep			= NULL;
>  static bool			csv_output			= false;
>  static bool			group				= false;
> @@ -198,6 +193,11 @@ static const char		*output_name			= NULL;
>  static FILE			*output				= NULL;
>  static int			output_fd;
>  
> +static struct perf_maps_opts maps = {
> +	.target_pid		= -1,
> +	.target_tid		= -1,
> +};
> +
>  static volatile int done = 0;
>  
>  struct stats
> @@ -293,10 +293,10 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  
>  	attr->inherit = !no_inherit;
>  
> -	if (system_wide)
> +	if (maps.system_wide)
>  		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
>  						group, group_fd);
> -	if (target_pid == -1 && target_tid == -1) {
> +	if (maps.target_pid == -1 && maps.target_tid == -1) {
>  		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
> @@ -446,7 +446,8 @@ static int run_perf_stat(int argc __used, const char **argv)
>  			exit(-1);
>  		}
>  
> -		if (target_tid == -1 && target_pid == -1 && !system_wide)
> +		if (maps.target_tid == -1 && maps.target_pid == -1 &&
> +		    !maps.system_wide)
>  			evsel_list->threads->map[0] = child_pid;
>  
>  		/*
> @@ -476,7 +477,7 @@ static int run_perf_stat(int argc __used, const char **argv)
>  				error("You may not have permission to collect %sstats.\n"
>  				      "\t Consider tweaking"
>  				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
> -				      system_wide ? "system-wide " : "");
> +				      maps.system_wide ? "system-wide " : "");
>  			} else {
>  				error("open_counter returned with %d (%s). "
>  				      "/bin/dmesg may provide additional information.\n",
> @@ -968,14 +969,14 @@ static void print_stat(int argc, const char **argv)
>  	if (!csv_output) {
>  		fprintf(output, "\n");
>  		fprintf(output, " Performance counter stats for ");
> -		if(target_pid == -1 && target_tid == -1) {
> +		if(maps.target_pid == -1 && maps.target_tid == -1) {
>  			fprintf(output, "\'%s", argv[0]);
>  			for (i = 1; i < argc; i++)
>  				fprintf(output, " %s", argv[i]);
> -		} else if (target_pid != -1)
> -			fprintf(output, "process id \'%d", target_pid);
> +		} else if (maps.target_pid != -1)
> +			fprintf(output, "process id \'%d", maps.target_pid);
>  		else
> -			fprintf(output, "thread id \'%d", target_tid);
> +			fprintf(output, "thread id \'%d", maps.target_tid);
>  
>  		fprintf(output, "\'");
>  		if (run_count > 1)
> @@ -1049,11 +1050,11 @@ static const struct option options[] = {
>  		     "event filter", parse_filter),
>  	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
>  		    "child tasks do not inherit counters"),
> -	OPT_INTEGER('p', "pid", &target_pid,
> +	OPT_INTEGER('p', "pid", &maps.target_pid,
>  		    "stat events on existing process id"),
> -	OPT_INTEGER('t', "tid", &target_tid,
> +	OPT_INTEGER('t', "tid", &maps.target_tid,
>  		    "stat events on existing thread id"),
> -	OPT_BOOLEAN('a', "all-cpus", &system_wide,
> +	OPT_BOOLEAN('a', "all-cpus", &maps.system_wide,
>  		    "system-wide collection from all CPUs"),
>  	OPT_BOOLEAN('g', "group", &group,
>  		    "put the counters into a counter group"),
> @@ -1072,7 +1073,7 @@ static const struct option options[] = {
>  	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
>  			   "print large numbers with thousands\' separators",
>  			   stat__set_big_num),
> -	OPT_STRING('C', "cpu", &cpu_list, "cpu",
> +	OPT_STRING('C', "cpu", &maps.cpu_list, "cpu",
>  		    "list of cpus to monitor in system-wide"),
>  	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
>  		    "disable CPU count aggregation"),
> @@ -1190,13 +1191,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	} else if (big_num_opt == 0) /* User passed --no-big-num */
>  		big_num = false;
>  
> -	if (!argc && target_pid == -1 && target_tid == -1)
> +	if (!argc && maps.target_pid == -1 && maps.target_tid == -1)
>  		usage_with_options(stat_usage, options);
>  	if (run_count <= 0)
>  		usage_with_options(stat_usage, options);
>  
>  	/* no_aggr, cgroup are for system-wide only */
> -	if ((no_aggr || nr_cgroups) && !system_wide) {
> +	if ((no_aggr || nr_cgroups) && !maps.system_wide) {
>  		fprintf(stderr, "both cgroup and no-aggregation "
>  			"modes only available in system-wide mode\n");
>  
> @@ -1206,17 +1207,18 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	if (add_default_attributes())
>  		goto out;
>  
> -	if (target_pid != -1)
> -		target_tid = target_pid;
> +	if (maps.target_pid != -1)
> +		maps.target_tid = maps.target_pid;
>  
> -	evsel_list->threads = thread_map__new(target_pid, target_tid, UINT_MAX);
> +	evsel_list->threads = thread_map__new(maps.target_pid, maps.target_tid,
> +					      UINT_MAX);
>  	if (evsel_list->threads == NULL) {
>  		pr_err("Problems finding threads of monitor\n");
>  		usage_with_options(stat_usage, options);
>  	}
>  
> -	if (system_wide)
> -		evsel_list->cpus = cpu_map__new(cpu_list);
> +	if (maps.system_wide)
> +		evsel_list->cpus = cpu_map__new(maps.cpu_list);
>  	else
>  		evsel_list->cpus = cpu_map__dummy_new();
>  
> -- 
> 1.7.9
