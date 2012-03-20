Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2CTUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab2CTUJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:09:27 -0400
Date: Tue, 20 Mar 2012 17:08:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120320200840.GA21163@infradead.org>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332267341-26338-4-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 20, 2012 at 07:15:41PM +0100, Jiri Olsa escreveu:
> The current event grouping is basic. If you specify the '--group'
> option for record/stat/top command, all the specified events become
> members of a single group with the first event as a group leader.
> 
> This patch adds a functionality that allows to create event groups
> based on the way they are specified on the command line. Extending
> the '--group/-g' option power while preserving the current behaviour.
> 
> It is now possible to use '--group/-g' option with 'parsed' value,
> which will create groups based on the command line events layout.
> 
> With the '--group/-g parsed' option specified, all events separated
> by ',' within a single '-e' option now become members of a group with
> the first event specified as a group leader. Another '-e' option with
> multiple events creates separate group.
> 
> All groups are created with regards to threads and cpus. Thus
> recording an event group within a 2 threads on server with
> 4 CPUs will create 8 separate groups.

Why not just set a rule that if -g is present then each -e CSV is a
separate group?

- Arnaldo
 
> Examples (first event in brackets is group leader):
> 
>   # 1 group (cpu-clock,task-clock)
>   perf record --group -e cpu-clock,task-clock ls
>   perf record --group parsed -e cpu-clock,task-clock ls
> 
>   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
>   perf record --group parsed -e cpu-clock,task-clock \
>    -e minor-faults,major-faults ls
> 
>   # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
>   perf record --group -e cpu-clock,task-clock \
>    -e minor-faults,major-faults ls
> 
>   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
>   perf record --group parsed -e cpu-clock,task-clock \
>    -e minor-faults,major-faults -e instructions ls
> 
>   # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
>   perf record --group -e cpu-clock,task-clock \
>    -e minor-faults,major-faults -e instructions ls
> 
> Updated automated test to check on group_leader settings.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/Makefile            |    2 ++
>  tools/perf/builtin-record.c    |    8 +++++---
>  tools/perf/builtin-stat.c      |   10 ++++++----
>  tools/perf/builtin-test.c      |   10 ++++++++++
>  tools/perf/builtin-top.c       |    8 +++++---
>  tools/perf/perf.h              |    3 ++-
>  tools/perf/util/evlist.c       |    4 ++--
>  tools/perf/util/evlist.h       |    3 ++-
>  tools/perf/util/evsel.c        |   32 +++++++++++++++++++++++++-------
>  tools/perf/util/evsel.h        |    9 ++++++---
>  tools/perf/util/group.c        |   22 ++++++++++++++++++++++
>  tools/perf/util/group.h        |   32 ++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c |   18 ++++++++++++++++++
>  tools/perf/util/parse-events.h |    3 ---
>  tools/perf/util/python.c       |    4 ++++
>  tools/perf/util/top.h          |    2 +-
>  16 files changed, 142 insertions(+), 28 deletions(-)
>  create mode 100644 tools/perf/util/group.c
>  create mode 100644 tools/perf/util/group.h
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index b492e3a..ea10b29 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -317,6 +317,7 @@ LIB_H += util/cpumap.h
>  LIB_H += util/top.h
>  LIB_H += $(ARCH_INCLUDE)
>  LIB_H += util/cgroup.h
> +LIB_H += util/group.h
>  
>  LIB_OBJS += $(OUTPUT)util/abspath.o
>  LIB_OBJS += $(OUTPUT)util/alias.o
> @@ -378,6 +379,7 @@ LIB_OBJS += $(OUTPUT)util/util.o
>  LIB_OBJS += $(OUTPUT)util/xyarray.o
>  LIB_OBJS += $(OUTPUT)util/cpumap.o
>  LIB_OBJS += $(OUTPUT)util/cgroup.o
> +LIB_OBJS += $(OUTPUT)util/group.o
>  
>  BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
>  
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index be4e1ee..a2c7dc2 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -26,6 +26,7 @@
>  #include "util/symbol.h"
>  #include "util/cpumap.h"
>  #include "util/thread_map.h"
> +#include "util/group.h"
>  
>  #include <unistd.h>
>  #include <sched.h>
> @@ -203,7 +204,7 @@ static void perf_record__open(struct perf_record *rec)
>  		 */
>  		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
>  
> -		if (opts->group && pos != first)
> +		if (group_is_single(opts->group) && pos != first)
>  			group_fd = first->fd;
>  fallback_missing_features:
>  		if (opts->exclude_guest_missing)
> @@ -791,8 +792,9 @@ const struct option record_options[] = {
>  	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
>  	OPT_UINTEGER('m', "mmap-pages", &record.opts.mmap_pages,
>  		     "number of mmap data pages"),
> -	OPT_BOOLEAN(0, "group", &record.opts.group,
> -		    "put the counters into a counter group"),
> +	OPT_CALLBACK_DEFAULT(0, "group", &record.opts.group, "[parsed]",
> +		    "put the counters into a counter group",
> +		     group_parse, PERF_GROUP_NONE),
>  	OPT_BOOLEAN('g', "call-graph", &record.opts.call_graph,
>  		    "do call-graph (stack chain/backtrace) recording"),
>  	OPT_INCR('v', "verbose", &verbose,
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index c941bb6..d0d3859 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -55,6 +55,7 @@
>  #include "util/cpumap.h"
>  #include "util/thread.h"
>  #include "util/thread_map.h"
> +#include "util/group.h"
>  
>  #include <sys/prctl.h>
>  #include <math.h>
> @@ -193,7 +194,7 @@ static int			big_num_opt			=  -1;
>  static const char		*cpu_list;
>  static const char		*csv_sep			= NULL;
>  static bool			csv_output			= false;
> -static bool			group				= false;
> +static enum perf_group_opt	group;
>  static const char		*output_name			= NULL;
>  static FILE			*output				= NULL;
>  static int			output_fd;
> @@ -284,7 +285,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  	struct perf_event_attr *attr = &evsel->attr;
>  	struct xyarray *group_fd = NULL;
>  
> -	if (group && evsel != first)
> +	if (group_is_single(group) && evsel != first)
>  		group_fd = first->fd;
>  
>  	if (scale)
> @@ -1055,8 +1056,9 @@ static const struct option options[] = {
>  		   "stat events on existing thread id"),
>  	OPT_BOOLEAN('a', "all-cpus", &system_wide,
>  		    "system-wide collection from all CPUs"),
> -	OPT_BOOLEAN('g', "group", &group,
> -		    "put the counters into a counter group"),
> +	OPT_CALLBACK_DEFAULT('g', "group", &group, "[parsed]",
> +		    "put the counters into a counter group",
> +		     group_parse, PERF_GROUP_NONE),
>  	OPT_BOOLEAN('c', "scale", &scale,
>  		    "scale/normalize counters"),
>  	OPT_INCR('v', "verbose", &verbose,
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 1c5b980..babdd77 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -14,6 +14,7 @@
>  #include "util/symbol.h"
>  #include "util/thread_map.h"
>  #include "util/pmu.h"
> +#include "util/group.h"
>  #include "../../include/linux/hw_breakpoint.h"
>  
>  #include <sys/mman.h>
> @@ -948,11 +949,14 @@ static int test__checkevent_pmu(struct perf_evlist *evlist)
>  static int test__checkevent_list(struct perf_evlist *evlist)
>  {
>  	struct perf_evsel *evsel;
> +	struct perf_evsel *parsed_leader;
>  
>  	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
>  
>  	/* r1 */
>  	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
> +	parsed_leader = evsel;
> +
>  	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
>  	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
>  	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
> @@ -961,6 +965,7 @@ static int test__checkevent_list(struct perf_evlist *evlist)
>  	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
>  	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
>  	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
> +	TEST_ASSERT_VAL("wrong parsed_leader", parsed_leader);
>  
>  	/* syscalls:sys_enter_open:k */
>  	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
> @@ -973,6 +978,8 @@ static int test__checkevent_list(struct perf_evlist *evlist)
>  	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
>  	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
>  	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
> +	TEST_ASSERT_VAL("wrong parsed_leader",
> +			evsel->parsed_leader == parsed_leader);
>  
>  	/* 1:1:hp */
>  	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
> @@ -982,6 +989,8 @@ static int test__checkevent_list(struct perf_evlist *evlist)
>  	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
>  	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
>  	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
> +	TEST_ASSERT_VAL("wrong parsed_leader",
> +			evsel->parsed_leader == parsed_leader);
>  
>  	return 0;
>  }
> @@ -1168,6 +1177,7 @@ static int test__PERF_RECORD(void)
>  		.no_delay   = true,
>  		.freq	    = 10,
>  		.mmap_pages = 256,
> +		.group      = PERF_GROUP_NONE,
>  	};
>  	cpu_set_t *cpu_mask = NULL;
>  	size_t cpu_mask_size = 0;
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index e3c63ae..fd04361 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -38,6 +38,7 @@
>  #include "util/cpumap.h"
>  #include "util/xyarray.h"
>  #include "util/sort.h"
> +#include "util/group.h"
>  
>  #include "util/debug.h"
>  
> @@ -850,7 +851,7 @@ static void perf_top__start_counters(struct perf_top *top)
>  		struct perf_event_attr *attr = &counter->attr;
>  		struct xyarray *group_fd = NULL;
>  
> -		if (top->group && counter != first)
> +		if (group_is_single(top->group) && counter != first)
>  			group_fd = first->fd;
>  
>  		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
> @@ -1153,8 +1154,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  			    "dump the symbol table used for profiling"),
>  	OPT_INTEGER('f', "count-filter", &top.count_filter,
>  		    "only display functions with more events than this"),
> -	OPT_BOOLEAN('g', "group", &top.group,
> -			    "put the counters into a counter group"),
> +	OPT_CALLBACK_DEFAULT('g', "group", &top.group, "[parsed]",
> +		    "put the counters into a counter group",
> +		    group_parse, PERF_GROUP_NONE),
>  	OPT_BOOLEAN('i', "inherit", &top.inherit,
>  		    "child tasks inherit counters"),
>  	OPT_STRING(0, "sym-annotate", &top.sym_filter, "symbol name",
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 89e3355..b80b69d 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -108,6 +108,7 @@ void get_term_dimensions(struct winsize *ws);
>  
>  #include "../../include/linux/perf_event.h"
>  #include "util/types.h"
> +#include "util/group.h"
>  #include <stdbool.h>
>  
>  struct perf_mmap {
> @@ -212,7 +213,6 @@ struct perf_record_opts {
>  	const char   *target_tid;
>  	uid_t	     uid;
>  	bool	     call_graph;
> -	bool	     group;
>  	bool	     inherit_stat;
>  	bool	     no_delay;
>  	bool	     no_inherit;
> @@ -232,6 +232,7 @@ struct perf_record_opts {
>  	u64	     default_interval;
>  	u64	     user_interval;
>  	const char   *cpu_list;
> +	enum perf_group_opt group;
>  };
>  
>  #endif
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 1986d80..c0bcffd 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -740,7 +740,7 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
>  	evlist->selected = evsel;
>  }
>  
> -int perf_evlist__open(struct perf_evlist *evlist, bool group)
> +int perf_evlist__open(struct perf_evlist *evlist, enum perf_group_opt group)
>  {
>  	struct perf_evsel *evsel, *first;
>  	int err, ncpus, nthreads;
> @@ -750,7 +750,7 @@ int perf_evlist__open(struct perf_evlist *evlist, bool group)
>  	list_for_each_entry(evsel, &evlist->entries, node) {
>  		struct xyarray *group_fd = NULL;
>  
> -		if (group && evsel != first)
> +		if (group_is_single(group) && evsel != first)
>  			group_fd = first->fd;
>  
>  		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads,
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index 21f1c9e..3115e8d 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -6,6 +6,7 @@
>  #include "../perf.h"
>  #include "event.h"
>  #include "util.h"
> +#include "group.h"
>  #include <unistd.h>
>  
>  struct pollfd;
> @@ -78,7 +79,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
>  
>  union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
>  
> -int perf_evlist__open(struct perf_evlist *evlist, bool group);
> +int perf_evlist__open(struct perf_evlist *evlist, enum perf_group_opt group);
>  
>  void perf_evlist__config_attrs(struct perf_evlist *evlist,
>  			       struct perf_record_opts *opts);
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 0221700..50a305d 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -14,6 +14,7 @@
>  #include "util.h"
>  #include "cpumap.h"
>  #include "thread_map.h"
> +#include "group.h"
>  
>  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
>  #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
> @@ -136,7 +137,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>  	attr->comm = track;
>  
>  	if (!opts->target_pid && !opts->target_tid && !opts->system_wide &&
> -	    (!opts->group || evsel == first)) {
> +	    (group_is_none(opts->group) || evsel == first)) {
>  		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
> @@ -293,8 +294,17 @@ int __perf_evsel__read(struct perf_evsel *evsel,
>  	return 0;
>  }
>  
> +static int parsed_leader_fd(struct perf_evsel *evsel,
> +			    int cpu, int thread)
> +{
> +	BUG_ON(!evsel->parsed_leader);
> +	/* The evsel->fd xyarray is initialized to -1. */
> +	return FD(evsel->parsed_leader, cpu, thread);
> +}
> +
>  static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> -			      struct thread_map *threads, bool group,
> +			      struct thread_map *threads,
> +			      enum perf_group_opt group,
>  			      struct xyarray *group_fds)
>  {
>  	int cpu, thread;
> @@ -311,13 +321,19 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  	}
>  
>  	for (cpu = 0; cpu < cpus->nr; cpu++) {
> -		int group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
> +		int group_fd = -1;
> +
> +		if (group_is_single(group))
> +			group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
>  
>  		for (thread = 0; thread < threads->nr; thread++) {
>  
>  			if (!evsel->cgrp)
>  				pid = threads->map[thread];
>  
> +			if (group_is_parsed(group))
> +				group_fd = parsed_leader_fd(evsel, cpu, thread);
> +
>  			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
>  								     pid,
>  								     cpus->map[cpu],
> @@ -327,7 +343,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  				goto out_close;
>  			}
>  
> -			if (group && group_fd == -1)
> +			if (group_is_single(group) && group_fd == -1)
>  				group_fd = FD(evsel, cpu, thread);
>  		}
>  	}
> @@ -372,7 +388,7 @@ static struct {
>  };
>  
>  int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> -		     struct thread_map *threads, bool group,
> +		     struct thread_map *threads, enum perf_group_opt group,
>  		     struct xyarray *group_fd)
>  {
>  	if (cpus == NULL) {
> @@ -387,7 +403,8 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  }
>  
>  int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
> -			     struct cpu_map *cpus, bool group,
> +			     struct cpu_map *cpus,
> +			     enum perf_group_opt group,
>  			     struct xyarray *group_fd)
>  {
>  	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group,
> @@ -395,7 +412,8 @@ int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
>  }
>  
>  int perf_evsel__open_per_thread(struct perf_evsel *evsel,
> -				struct thread_map *threads, bool group,
> +				struct thread_map *threads,
> +				enum perf_group_opt group,
>  				struct xyarray *group_fd)
>  {
>  	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group,
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 3158ca3..ae4023f 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -66,6 +66,7 @@ struct perf_evsel {
>  		void		*data;
>  	} handler;
>  	bool 			supported;
> +	struct perf_evsel       *parsed_leader;
>  };
>  
>  struct cpu_map;
> @@ -91,13 +92,15 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
>  void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
>  
>  int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
> -			     struct cpu_map *cpus, bool group,
> +			     struct cpu_map *cpus,
> +			     enum perf_group_opt group,
>  			     struct xyarray *group_fds);
>  int perf_evsel__open_per_thread(struct perf_evsel *evsel,
> -				struct thread_map *threads, bool group,
> +				struct thread_map *threads,
> +				enum perf_group_opt group,
>  				struct xyarray *group_fds);
>  int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> -		     struct thread_map *threads, bool group,
> +		     struct thread_map *threads, enum perf_group_opt group,
>  		     struct xyarray *group_fds);
>  void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
>  
> diff --git a/tools/perf/util/group.c b/tools/perf/util/group.c
> new file mode 100644
> index 0000000..68d18a2
> --- /dev/null
> +++ b/tools/perf/util/group.c
> @@ -0,0 +1,22 @@
> +#include <linux/compiler.h>
> +#include "types.h"
> +#include "util.h"
> +#include "parse-options.h"
> +#include "group.h"
> +
> +int group_parse(const struct option *opt, const char *str,
> +		int unset __used)
> +{
> +	int *group_opt = (int *) opt->value;
> +
> +	if (!str)
> +		*group_opt = PERF_GROUP_SINGLE;
> +	else if (!strcmp(str, "parsed"))
> +		*group_opt = PERF_GROUP_PARSED;
> +	else {
> +		fprintf(stderr, "unknown group option value\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> diff --git a/tools/perf/util/group.h b/tools/perf/util/group.h
> new file mode 100644
> index 0000000..f97520a
> --- /dev/null
> +++ b/tools/perf/util/group.h
> @@ -0,0 +1,32 @@
> +#ifndef __GROUP_H__
> +#define __GROUP_H__
> +
> +#include <stdbool.h>
> +
> +struct option;
> +
> +enum perf_group_opt {
> +	PERF_GROUP_NONE,
> +	PERF_GROUP_SINGLE,
> +	PERF_GROUP_PARSED
> +};
> +
> +int group_parse(const struct option *opt, const char *str,
> +		int unset);
> +
> +static inline bool group_is_none(enum perf_group_opt group)
> +{
> +	return group == PERF_GROUP_NONE;
> +}
> +
> +static inline bool group_is_single(enum perf_group_opt group)
> +{
> +	return group == PERF_GROUP_SINGLE;
> +}
> +
> +static inline bool group_is_parsed(enum perf_group_opt group)
> +{
> +	return group == PERF_GROUP_PARSED;
> +}
> +
> +#endif /* __GROUP_H__ */
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 5b3a0ef..b6bccab98 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -747,6 +747,18 @@ int parse_events_modifier(struct list_head *list, char *str)
>  	return 0;
>  }
>  
> +static void update_parsed_leader(struct list_head *list)
> +{
> +	struct perf_evsel *evsel, *parsed_leader = NULL;
> +
> +	list_for_each_entry(evsel, list, node) {
> +		if (!parsed_leader)
> +			parsed_leader = evsel;
> +
> +		evsel->parsed_leader = parsed_leader;
> +	}
> +}
> +
>  int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
>  {
>  	LIST_HEAD(list);
> @@ -761,6 +773,12 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
>  	parse_events__flush_buffer(buffer);
>  	parse_events__delete_buffer(buffer);
>  
> +	/*
> +	 * Populate the parsed_leader even if we failed,
> +	 * just to have complete data, because who knows.. ;)
> +	 */
> +	update_parsed_leader(&list);
> +
>  	if (!ret) {
>  		int entries = idx - evlist->nr_entries;
>  		perf_evlist__splice_list_tail(evlist, &list, entries);
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index ca069f8..d6c4d5d 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -64,9 +64,6 @@ void parse_events__free_terms(struct list_head *terms);
>  int parse_events_modifier(struct list_head *list __used, char *str __used);
>  int parse_events_add_tracepoint(struct list_head *list, int *idx,
>  				char *sys, char *event);
> -int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
> -			 unsigned long config1, unsigned long config2,
> -			 char *mod);
>  int parse_events_add_numeric(struct list_head *list, int *idx,
>  			     unsigned long type, unsigned long config,
>  			     struct list_head *head_config);
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index e03b58a..6030758 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -7,6 +7,7 @@
>  #include "event.h"
>  #include "cpumap.h"
>  #include "thread_map.h"
> +#include "group.h"
>  
>  /* Define PyVarObject_HEAD_INIT for python 2.5 */
>  #ifndef PyVarObject_HEAD_INIT
> @@ -828,6 +829,9 @@ static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
>  	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist, &group))
>  		return NULL;
>  
> +	if (group)
> +		group = PERF_GROUP_SINGLE;
> +
>  	if (perf_evlist__open(evlist, group) < 0) {
>  		PyErr_SetFromErrno(PyExc_OSError);
>  		return NULL;
> diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
> index ce61cb2..0d2cf8b 100644
> --- a/tools/perf/util/top.h
> +++ b/tools/perf/util/top.h
> @@ -33,7 +33,7 @@ struct perf_top {
>  	bool		   kptr_restrict_warned;
>  	bool		   vmlinux_warned;
>  	bool		   inherit;
> -	bool		   group;
> +	enum perf_group_opt group;
>  	bool		   sample_id_all_missing;
>  	bool		   exclude_guest_missing;
>  	bool		   dump_symtab;
> -- 
> 1.7.7.6
