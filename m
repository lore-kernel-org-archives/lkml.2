Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2BEOX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 09:23:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63464 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2BEOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 09:23:57 -0500
Date: Sun, 5 Feb 2012 12:23:49 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Jean-Michel Hautbois <jhautbois@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Specifying some processes to record using perf
Message-ID: <20120205142349.GE30158@infradead.org>
References: <CAL8zT=gX5=S9fd1MdYyYVYg+35anmK-aJwFj9fUiKNuMSb8n_w@mail.gmail.com>
 <CAL8zT=jXmSWbEQO2T2Kpp2_Yei5VJ+sGVt5U2vJwPo=6T2YY1g@mail.gmail.com>
 <4F2ABAC6.5060200@gmail.com>
 <4F2DBD1F.20909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2DBD1F.20909@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Feb 04, 2012 at 04:19:59PM -0700, David Ahern escreveu:
> On 02/02/2012 09:33 AM, David Ahern wrote:
> > 
> > On 02/02/2012 08:52 AM, Jean-Michel Hautbois wrote:
> >> Hi all,
> >>
> >> I am using perf and I have several process and threads to record.
> >> I know that some threads in particular are interesting, and I don't
> >> find a way to specify multiple threads in perf record.
> >> The "-t" option takes only one thread IIUC.
> 
> Found some time on the plane ride home to give this a shot. The attached
> applies on top of the perf/core branch in:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> 
> You can specify multiple threads or multiple processing using a
> comma-separated list. e.g., -t tid1,tid2,... or -p pid1,pid2,... (not both).
> 
> It still needs more testing, but let me know how it works for what you need.
> 
> Arnaldo: would you mind scanning this and see if there are any major
> problems/objections with the approach?

It looks ok, but I wouldn't remove the existing specialized thread_map
constructors, i.e. no need to first transform getpid() into an string to
then pass to a generic constructor that would then back convert it into
a pid_t :-)

Just add new constructors for CSV strings, like:

struct thread_map *thread_map__new_by_pids(const char *pid_list);

struct thread_map *thread_map__new_by_tids(const char *pid_list);

with the expected results, i.e. they would just tokenize and call the
more basic constructors, at least in the by_pids, then concatenating the
results, etc.

- Arnaldo
 
> David
> 
> 

> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index ff9a66e..a5766b4 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -52,11 +52,11 @@ OPTIONS
>  
>  -p::
>  --pid=::
> -	Record events on existing process ID.
> +	Record events on existing process ID (comma separated list).
>  
>  -t::
>  --tid=::
> -        Record events on existing thread ID.
> +        Record events on existing thread ID (comma separated list).
>  
>  -u::
>  --uid=::
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 8966b9a..2fa173b 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -35,11 +35,11 @@ OPTIONS
>          child tasks do not inherit counters
>  -p::
>  --pid=<pid>::
> -        stat events on existing process id
> +        stat events on existing process id (comma separated list)
>  
>  -t::
>  --tid=<tid>::
> -        stat events on existing thread id
> +        stat events on existing thread id (comma separated list)
>  
>  
>  -a::
> diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
> index ab1454e..4a5680c 100644
> --- a/tools/perf/Documentation/perf-top.txt
> +++ b/tools/perf/Documentation/perf-top.txt
> @@ -72,11 +72,11 @@ Default is to monitor all CPUS.
>  
>  -p <pid>::
>  --pid=<pid>::
> -	Profile events on existing Process ID.
> +	Profile events on existing Process ID (comma separated list).
>  
>  -t <tid>::
>  --tid=<tid>::
> -        Profile events on existing thread ID.
> +        Profile events on existing thread ID (comma separated list).
>  
>  -u::
>  --uid=::
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 32870ee..3c1b6c7 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -655,8 +655,6 @@ static const char * const record_usage[] = {
>   */
>  static struct perf_record record = {
>  	.opts = {
> -		.target_pid	     = -1,
> -		.target_tid	     = -1,
>  		.mmap_pages	     = UINT_MAX,
>  		.user_freq	     = UINT_MAX,
>  		.user_interval	     = ULLONG_MAX,
> @@ -680,9 +678,9 @@ const struct option record_options[] = {
>  		     parse_events_option),
>  	OPT_CALLBACK(0, "filter", &record.evlist, "filter",
>  		     "event filter", parse_filter),
> -	OPT_INTEGER('p', "pid", &record.opts.target_pid,
> +	OPT_STRING('p', "pid", &record.opts.target_pid, "pid",
>  		    "record events on existing process id"),
> -	OPT_INTEGER('t', "tid", &record.opts.target_tid,
> +	OPT_STRING('t', "tid", &record.opts.target_tid, "tid",
>  		    "record events on existing thread id"),
>  	OPT_INTEGER('r', "realtime", &record.realtime_prio,
>  		    "collect data with this RT SCHED_FIFO priority"),
> @@ -749,7 +747,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  
>  	argc = parse_options(argc, argv, record_options, record_usage,
>  			    PARSE_OPT_STOP_AT_NON_OPTION);
> -	if (!argc && rec->opts.target_pid == -1 && rec->opts.target_tid == -1 &&
> +	if (!argc && !rec->opts.target_pid && !rec->opts.target_tid &&
>  		!rec->opts.system_wide && !rec->opts.cpu_list && !rec->uid_str)
>  		usage_with_options(record_usage, record_options);
>  
> @@ -795,7 +793,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  	if (rec->uid_str != NULL && rec->opts.uid == UINT_MAX - 1)
>  		goto out_free_fd;
>  
> -	if (rec->opts.target_pid != -1)
> +	if (rec->opts.target_pid)
>  		rec->opts.target_tid = rec->opts.target_pid;
>  
>  	if (perf_evlist__create_maps(evsel_list, rec->opts.target_pid,
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 459b862..da9db2c 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -182,8 +182,8 @@ static int			run_count			=  1;
>  static bool			no_inherit			= false;
>  static bool			scale				=  true;
>  static bool			no_aggr				= false;
> -static pid_t			target_pid			= -1;
> -static pid_t			target_tid			= -1;
> +static const char		*target_pid;
> +static const char		*target_tid;
>  static pid_t			child_pid			= -1;
>  static bool			null_run			=  false;
>  static int			detailed_run			=  0;
> @@ -296,7 +296,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  	if (system_wide)
>  		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
>  						group, group_fd);
> -	if (target_pid == -1 && target_tid == -1) {
> +	if (!target_pid && !target_tid) {
>  		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
> @@ -446,7 +446,7 @@ static int run_perf_stat(int argc __used, const char **argv)
>  			exit(-1);
>  		}
>  
> -		if (target_tid == -1 && target_pid == -1 && !system_wide)
> +		if (!target_tid && !target_pid && !system_wide)
>  			evsel_list->threads->map[0] = child_pid;
>  
>  		/*
> @@ -960,14 +960,14 @@ static void print_stat(int argc, const char **argv)
>  	if (!csv_output) {
>  		fprintf(output, "\n");
>  		fprintf(output, " Performance counter stats for ");
> -		if(target_pid == -1 && target_tid == -1) {
> +		if (!target_pid && !target_tid) {
>  			fprintf(output, "\'%s", argv[0]);
>  			for (i = 1; i < argc; i++)
>  				fprintf(output, " %s", argv[i]);
> -		} else if (target_pid != -1)
> -			fprintf(output, "process id \'%d", target_pid);
> +		} else if (target_pid)
> +			fprintf(output, "process id \'%s", target_pid);
>  		else
> -			fprintf(output, "thread id \'%d", target_tid);
> +			fprintf(output, "thread id \'%s", target_tid);
>  
>  		fprintf(output, "\'");
>  		if (run_count > 1)
> @@ -1041,10 +1041,10 @@ static const struct option options[] = {
>  		     "event filter", parse_filter),
>  	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
>  		    "child tasks do not inherit counters"),
> -	OPT_INTEGER('p', "pid", &target_pid,
> -		    "stat events on existing process id"),
> -	OPT_INTEGER('t', "tid", &target_tid,
> -		    "stat events on existing thread id"),
> +	OPT_STRING('p', "pid", &target_pid, "pid",
> +		   "stat events on existing process id"),
> +	OPT_STRING('t', "tid", &target_tid, "tid",
> +		   "stat events on existing thread id"),
>  	OPT_BOOLEAN('a', "all-cpus", &system_wide,
>  		    "system-wide collection from all CPUs"),
>  	OPT_BOOLEAN('g', "group", &group,
> @@ -1182,7 +1182,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	} else if (big_num_opt == 0) /* User passed --no-big-num */
>  		big_num = false;
>  
> -	if (!argc && target_pid == -1 && target_tid == -1)
> +	if (!argc && !target_pid && !target_tid)
>  		usage_with_options(stat_usage, options);
>  	if (run_count <= 0)
>  		usage_with_options(stat_usage, options);
> @@ -1198,7 +1198,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	if (add_default_attributes())
>  		goto out;
>  
> -	if (target_pid != -1)
> +	if (target_pid)
>  		target_tid = target_pid;
>  
>  	evsel_list->threads = thread_map__new(target_pid, target_tid, UINT_MAX);
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 70c4eb2..23ac482 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -264,6 +264,20 @@ static int trace_event__id(const char *evname)
>  	return err;
>  }
>  
> +static struct thread_map *test__thread_map(void)
> +{
> +	struct thread_map *threads;
> +	char pidstr[16];
> +
> +	sprintf(pidstr, "%d", getpid());
> +	threads = thread_map__new(NULL, pidstr, UINT_MAX);
> +
> +	if (threads == NULL)
> +		pr_debug("thread_map__new\n");
> +
> +	return threads;
> +}
> +
>  static int test__open_syscall_event(void)
>  {
>  	int err = -1, fd;
> @@ -278,11 +292,9 @@ static int test__open_syscall_event(void)
>  		return -1;
>  	}
>  
> -	threads = thread_map__new(-1, getpid(), UINT_MAX);
> -	if (threads == NULL) {
> -		pr_debug("thread_map__new\n");
> +	threads = test__thread_map();
> +	if (threads == NULL)
>  		return -1;
> -	}
>  
>  	memset(&attr, 0, sizeof(attr));
>  	attr.type = PERF_TYPE_TRACEPOINT;
> @@ -344,11 +356,9 @@ static int test__open_syscall_event_on_all_cpus(void)
>  		return -1;
>  	}
>  
> -	threads = thread_map__new(-1, getpid(), UINT_MAX);
> -	if (threads == NULL) {
> -		pr_debug("thread_map__new\n");
> +	threads = test__thread_map();
> +	if (threads == NULL)
>  		return -1;
> -	}
>  
>  	cpus = cpu_map__new(NULL);
>  	if (cpus == NULL) {
> @@ -492,11 +502,9 @@ static int test__basic_mmap(void)
>  		expected_nr_events[i] = random() % 257;
>  	}
>  
> -	threads = thread_map__new(-1, getpid(), UINT_MAX);
> -	if (threads == NULL) {
> -		pr_debug("thread_map__new\n");
> +	threads = test__thread_map();
> +	if (threads == NULL)
>  		return -1;
> -	}
>  
>  	cpus = cpu_map__new(NULL);
>  	if (cpus == NULL) {
> @@ -1010,8 +1018,6 @@ realloc:
>  static int test__PERF_RECORD(void)
>  {
>  	struct perf_record_opts opts = {
> -		.target_pid = -1,
> -		.target_tid = -1,
>  		.no_delay   = true,
>  		.freq	    = 10,
>  		.mmap_pages = 256,
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index d869b21..94d55cb 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -965,7 +965,7 @@ static int __cmd_top(struct perf_top *top)
>  	if (ret)
>  		goto out_delete;
>  
> -	if (top->target_tid != -1 || top->uid != UINT_MAX)
> +	if (top->target_tid || top->uid != UINT_MAX)
>  		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
>  						  perf_event__process,
>  						  &top->session->host_machine);
> @@ -1103,8 +1103,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  	struct perf_top top = {
>  		.count_filter	     = 5,
>  		.delay_secs	     = 2,
> -		.target_pid	     = -1,
> -		.target_tid	     = -1,
>  		.uid		     = UINT_MAX,
>  		.freq		     = 1000, /* 1 KHz */
>  		.sample_id_all_avail = true,
> @@ -1118,9 +1116,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  		     parse_events_option),
>  	OPT_INTEGER('c', "count", &top.default_interval,
>  		    "event period to sample"),
> -	OPT_INTEGER('p', "pid", &top.target_pid,
> +	OPT_STRING('p', "pid", &top.target_pid, "pid",
>  		    "profile events on existing process id"),
> -	OPT_INTEGER('t', "tid", &top.target_tid,
> +	OPT_STRING('t', "tid", &top.target_tid, "tid",
>  		    "profile events on existing thread id"),
>  	OPT_BOOLEAN('a', "all-cpus", &top.system_wide,
>  			    "system-wide collection from all CPUs"),
> @@ -1210,13 +1208,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  		goto out_delete_evlist;
>  
>  	/* CPU and PID are mutually exclusive */
> -	if (top.target_tid > 0 && top.cpu_list) {
> +	if (top.target_tid && top.cpu_list) {
>  		printf("WARNING: PID switch overriding CPU\n");
>  		sleep(1);
>  		top.cpu_list = NULL;
>  	}
>  
> -	if (top.target_pid != -1)
> +	if (top.target_pid)
>  		top.target_tid = top.target_pid;
>  
>  	if (perf_evlist__create_maps(top.evlist, top.target_pid,
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 92af168..deb17db 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -186,8 +186,8 @@ extern const char perf_version_string[];
>  void pthread__unblock_sigwinch(void);
>  
>  struct perf_record_opts {
> -	pid_t	     target_pid;
> -	pid_t	     target_tid;
> +	const char   *target_pid;
> +	const char   *target_tid;
>  	uid_t	     uid;
>  	bool	     call_graph;
>  	bool	     group;
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index a6d50e3..cfe273f 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -593,15 +593,15 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
>  	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
>  }
>  
> -int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
> -			     pid_t target_tid, uid_t uid, const char *cpu_list)
> +int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
> +			     const char *target_tid, uid_t uid, const char *cpu_list)
>  {
>  	evlist->threads = thread_map__new(target_pid, target_tid, uid);
>  
>  	if (evlist->threads == NULL)
>  		return -1;
>  
> -	if (uid != UINT_MAX || (cpu_list == NULL && target_tid != -1))
> +	if (uid != UINT_MAX || (cpu_list == NULL && target_tid))
>  		evlist->cpus = cpu_map__dummy_new();
>  	else
>  		evlist->cpus = cpu_map__new(cpu_list);
> @@ -820,7 +820,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
>  		exit(-1);
>  	}
>  
> -	if (!opts->system_wide && opts->target_tid == -1 && opts->target_pid == -1)
> +	if (!opts->system_wide && !opts->target_tid && !opts->target_pid)
>  		evlist->threads->map[0] = evlist->workload.pid;
>  
>  	close(child_ready_pipe[1]);
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index 9c51660..666745a 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -106,8 +106,8 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
>  	evlist->threads	= threads;
>  }
>  
> -int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
> -			     pid_t tid, uid_t uid, const char *cpu_list);
> +int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
> +			     const char *tid, uid_t uid, const char *cpu_list);
>  void perf_evlist__delete_maps(struct perf_evlist *evlist);
>  int perf_evlist__set_filters(struct perf_evlist *evlist);
>  
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index dcfefab..6c568d2 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -130,7 +130,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
>  	attr->mmap = track;
>  	attr->comm = track;
>  
> -	if (opts->target_pid == -1 && opts->target_tid == -1 && !opts->system_wide) {
> +	if (!opts->target_pid && !opts->target_tid && !opts->system_wide) {
>  		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index e03b58a..867948f 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -426,9 +426,10 @@ static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
>  				 PyObject *args, PyObject *kwargs)
>  {
>  	static char *kwlist[] = { "pid", "tid", "uid", NULL };
> -	int pid = -1, tid = -1, uid = UINT_MAX;
> +	char *pid = NULL, *tid = NULL;
> +	int uid = UINT_MAX;
>  
> -	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|iii",
> +	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ssi",
>  					 kwlist, &pid, &tid, &uid))
>  		return -1;
>  
> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
> index 3d4b6c5..e629df2 100644
> --- a/tools/perf/util/thread_map.c
> +++ b/tools/perf/util/thread_map.c
> @@ -6,7 +6,10 @@
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <unistd.h>
> +#include <ctype.h>
> +#include <string.h>
>  #include "thread_map.h"
> +#include "debug.h"
>  
>  /* Skip "." and ".." directories */
>  static int filter(const struct dirent *dir)
> @@ -17,46 +20,134 @@ static int filter(const struct dirent *dir)
>  		return 1;
>  }
>  
> -struct thread_map *thread_map__new_by_pid(pid_t pid)
> +static pid_t get_next_task_id(char **str)
>  {
> -	struct thread_map *threads;
> +	char *p, *pend;
> +	pid_t ret = -1;
> +
> +	pend = p = *str;
> +
> +	/* only expecting digits separated by commas */
> +	while (isdigit(*pend))
> +		++pend;
> +
> +	if (*pend == ',') {
> +		*pend = '\0';
> +		pend++;
> +
> +		/* catch strings ending in a comma - like '1234,' */
> +		if (*pend == '\0') {
> +			ui__error("task id strings should not end in a comma\n");
> +			goto out;
> +		}
> +	}
> +
> +	/* only convert if all characters are valid */
> +	if (*pend == '\0') {
> +		ret = atoi(p);
> +		*str = pend;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +static struct thread_map *thread_map__new_by_pid(const char *pid_str)
> +{
> +	struct thread_map *threads = NULL;
>  	char name[256];
> -	int items;
> +	int items, total_tasks = 0;
>  	struct dirent **namelist = NULL;
> -	int i;
> +	int i, j = 0;
> +	char *ostr, *str;
> +	pid_t pid;
>  
> -	sprintf(name, "/proc/%d/task", pid);
> -	items = scandir(name, &namelist, filter, NULL);
> -	if (items <= 0)
> +	ostr = strdup(pid_str);
> +	if (!ostr)
>  		return NULL;
> +	str = ostr;
> +
> +	while(*str) {
> +		pid = get_next_task_id(&str);
> +		if (pid < 0) {
> +			free(threads);
> +			threads = NULL;
> +			break;
> +		}
>  
> -	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
> -	if (threads != NULL) {
> -		for (i = 0; i < items; i++)
> -			threads->map[i] = atoi(namelist[i]->d_name);
> -		threads->nr = items;
> +		sprintf(name, "/proc/%d/task", pid);
> +		items = scandir(name, &namelist, filter, NULL);
> +		if (items <= 0)
> +			break;
> +
> +		total_tasks += items;
> +		if (threads)
> +			threads = realloc(threads, sizeof(*threads) + sizeof(pid_t) * total_tasks);
> +		else
> +			threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
> +
> +		if (threads != NULL) {
> +			for (i = 0; i < items; i++)
> +				threads->map[j++] = atoi(namelist[i]->d_name);
> +			threads->nr = total_tasks;
> +		}
> +
> +		for (i=0; i<items; i++)
> +			free(namelist[i]);
> +		free(namelist);
> +
> +		if (!threads)
> +			break;
>  	}
>  
> -	for (i=0; i<items; i++)
> -		free(namelist[i]);
> -	free(namelist);
> +	free(ostr);
>  
>  	return threads;
>  }
>  
> -struct thread_map *thread_map__new_by_tid(pid_t tid)
> +static struct thread_map *thread_map__new_by_tid(const char *tid_str)
>  {
> -	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
> -
> -	if (threads != NULL) {
> -		threads->map[0] = tid;
> +	struct thread_map *threads = NULL;
> +	char *str;
> +	int ntasks = 0;
> +	pid_t tid;
> +
> +	if (!tid_str) {
> +		threads = malloc(sizeof(*threads) + sizeof(pid_t));
> +		threads->map[1] = -1;
>  		threads->nr	= 1;
> +		return threads;
> +	}
> +
> +   	str = strdup(tid_str);
> +	if (!str)
> +		return NULL;
> +
> +	while(*str) {
> +		tid = get_next_task_id(&str);
> +		if (tid < 0) {
> +			free(threads);
> +			threads = NULL;
> +			break;
> +		}
> +
> +		ntasks++;
> +		if (threads)
> +			threads = realloc(threads, sizeof(*threads) + sizeof(pid_t) * ntasks);
> +		else
> +			threads = malloc(sizeof(*threads) + sizeof(pid_t));
> +
> +		if (threads == NULL)
> +			break;
> +
> +		threads->map[ntasks-1] = tid;
> +		threads->nr	= ntasks;
>  	}
>  
>  	return threads;
>  }
>  
> -struct thread_map *thread_map__new_by_uid(uid_t uid)
> +static struct thread_map *thread_map__new_by_uid(uid_t uid)
>  {
>  	DIR *proc;
>  	int max_threads = 32, items, i;
> @@ -141,12 +232,12 @@ out_free_closedir:
>  	goto out_closedir;
>  }
>  
> -struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
> +struct thread_map *thread_map__new(const char *pid, const char *tid, uid_t uid)
>  {
> -	if (pid != -1)
> +	if (pid)
>  		return thread_map__new_by_pid(pid);
>  
> -	if (tid == -1 && uid != UINT_MAX)
> +	if (!tid && uid != UINT_MAX)
>  		return thread_map__new_by_uid(uid);
>  
>  	return thread_map__new_by_tid(tid);
> diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
> index c75ddba..b067114 100644
> --- a/tools/perf/util/thread_map.h
> +++ b/tools/perf/util/thread_map.h
> @@ -9,10 +9,7 @@ struct thread_map {
>  	int map[];
>  };
>  
> -struct thread_map *thread_map__new_by_pid(pid_t pid);
> -struct thread_map *thread_map__new_by_tid(pid_t tid);
> -struct thread_map *thread_map__new_by_uid(uid_t uid);
> -struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid);
> +struct thread_map *thread_map__new(const char *pid, const char *tid, uid_t uid);
>  void thread_map__delete(struct thread_map *threads);
>  
>  size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
> diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
> index e4370ca..09fe579 100644
> --- a/tools/perf/util/top.c
> +++ b/tools/perf/util/top.c
> @@ -69,11 +69,11 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
>  
>  	ret += SNPRINTF(bf + ret, size - ret, "], ");
>  
> -	if (top->target_pid != -1)
> -		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %d",
> +	if (top->target_pid)
> +		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %s",
>  				top->target_pid);
> -	else if (top->target_tid != -1)
> -		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %d",
> +	else if (top->target_tid)
> +		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %s",
>  				top->target_tid);
>  	else if (top->uid_str != NULL)
>  		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
> @@ -85,7 +85,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
>  		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
>  				top->evlist->cpus->nr > 1 ? "s" : "", top->cpu_list);
>  	else {
> -		if (top->target_tid != -1)
> +		if (top->target_tid)
>  			ret += SNPRINTF(bf + ret, size - ret, ")");
>  		else
>  			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
> diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
> index def3e53..49eb848 100644
> --- a/tools/perf/util/top.h
> +++ b/tools/perf/util/top.h
> @@ -23,7 +23,7 @@ struct perf_top {
>  	u64		   guest_us_samples, guest_kernel_samples;
>  	int		   print_entries, count_filter, delay_secs;
>  	int		   freq;
> -	pid_t		   target_pid, target_tid;
> +	const char	   *target_pid, *target_tid;
>  	uid_t		   uid;
>  	bool		   hide_kernel_symbols, hide_user_symbols, zero;
>  	bool		   system_wide;
> diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
> index d0c0139..1240bd6 100644
> --- a/tools/perf/util/usage.c
> +++ b/tools/perf/util/usage.c
> @@ -83,7 +83,7 @@ void warning(const char *warn, ...)
>  	va_end(params);
>  }
>  
> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
> +uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
>  {
>  	struct passwd pwd, *result;
>  	char buf[1024];
> @@ -91,8 +91,8 @@ uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
>  	if (str == NULL)
>  		return UINT_MAX;
>  
> -	/* CPU and PID are mutually exclusive */
> -	if (tid > 0 || pid > 0) {
> +	/* UUID and PID are mutually exclusive */
> +	if (tid || pid) {
>  		ui__warning("PID/TID switch overriding UID\n");
>  		sleep(1);
>  		return UINT_MAX;
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 232d17e..7917b09 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -245,7 +245,7 @@ struct perf_event_attr;
>  
>  void event_attr_init(struct perf_event_attr *attr);
>  
> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid);
> +uid_t parse_target_uid(const char *str, const char *tid, const char *pid);
>  
>  #define _STR(x) #x
>  #define STR(x) _STR(x)

