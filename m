Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab1LOPbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:31:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1LOPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:31:04 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] perf, tool: Add new event group management
Date: Thu, 15 Dec 2011 16:30:38 +0100
Message-Id: <1323963039-7602-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current event grouping is basic. If you specify the '--group'
option for record/stat/top command, all the specified events become
members of a single group with the first event as a group leader.

This patch adds a functionality that allows to create event groups
based on the way they are specified on the command line. Extending
the '--group/-g' option power while preserving the current behaviour.

It is now possible to use '--group/-g' option with 'parsed' value,
which will create groups based on the command line events layout.

With the '--group/-g parsed' option specified, all events separated
by ',' within a single '-e' option now become members of a group with
the first event specified as a group leader. Another '-e' option with
multiple events creates separate group.

All groups are created with regards to threads and cpus. Thus
recording an event group within a 2 threads on server with
4 CPUs will create 8 separate groups.

Examples (first event in brackets is group leader):

  # 1 group (cpu-clock,task-clock)
  perf record --group -e cpu-clock,task-clock ls
  perf record --group parsed -e cpu-clock,task-clock ls

  # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
  perf record --group parsed -e cpu-clock,task-clock \
   -e minor-faults,major-faults ls

  # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
  perf record --group -e cpu-clock,task-clock \
   -e minor-faults,major-faults ls

  # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
  perf record --group parsed -e cpu-clock,task-clock \
   -e minor-faults,major-faults -e instructions ls

  # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
  perf record --group -e cpu-clock,task-clock \
   -e minor-faults,major-faults -e instructions ls

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile            |    2 ++
 tools/perf/builtin-record.c    |    8 +++++---
 tools/perf/builtin-stat.c      |   10 ++++++----
 tools/perf/builtin-top.c       |    8 +++++---
 tools/perf/perf.h              |    2 +-
 tools/perf/util/evsel.c        |   28 ++++++++++++++++++++++------
 tools/perf/util/evsel.h        |    9 +++++----
 tools/perf/util/group.c        |   23 +++++++++++++++++++++++
 tools/perf/util/group.h        |   25 +++++++++++++++++++++++++
 tools/perf/util/parse-events.c |    6 ++++++
 tools/perf/util/python.c       |    4 ++++
 tools/perf/util/top.h          |    2 +-
 12 files changed, 105 insertions(+), 22 deletions(-)
 create mode 100644 tools/perf/util/group.c
 create mode 100644 tools/perf/util/group.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ef6b621..c54b595 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -299,6 +299,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
+LIB_H += util/group.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -356,6 +357,7 @@ LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
+LIB_OBJS += $(OUTPUT)util/group.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 766fa0a..581c72d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,6 +26,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include "util/group.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -202,7 +203,7 @@ static void perf_record__open(struct perf_record *rec)
 		 */
 		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
-		if (opts->group && pos != first)
+		if (group_is_single(opts->group) && pos != first)
 			group_fd = first->fd;
 retry_sample_id:
 		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
@@ -688,8 +689,9 @@ const struct option record_options[] = {
 	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &record.opts.mmap_pages,
 		     "number of mmap data pages"),
-	OPT_BOOLEAN(0, "group", &record.opts.group,
-		    "put the counters into a counter group"),
+	OPT_CALLBACK_DEFAULT(0, "group", &record.opts.group, "[parsed]",
+		     "put the counters into a counter group",
+		     parse_group, PERF_GROUP_NONE),
 	OPT_BOOLEAN('g', "call-graph", &record.opts.call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_INCR('v', "verbose", &verbose,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index cc53de3..c28c852 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -55,6 +55,7 @@
 #include "util/cpumap.h"
 #include "util/thread.h"
 #include "util/thread_map.h"
+#include "util/group.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -193,7 +194,7 @@ static int			big_num_opt			=  -1;
 static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
-static bool			group				= false;
+static int			group;
 static const char		*output_name			= NULL;
 static FILE			*output				= NULL;
 static int			output_fd;
@@ -284,7 +285,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	struct perf_event_attr *attr = &evsel->attr;
 	struct xyarray *group_fd = NULL;
 
-	if (group && evsel != first)
+	if (group_is_single(group) && evsel != first)
 		group_fd = first->fd;
 
 	if (scale)
@@ -1068,8 +1069,9 @@ static const struct option options[] = {
 		    "stat events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('g', "group", &group,
-		    "put the counters into a counter group"),
+	OPT_CALLBACK_DEFAULT('g', "group", &group, "[parsed]",
+		    "put the counters into a counter group",
+		    parse_group, PERF_GROUP_NONE),
 	OPT_BOOLEAN('c', "scale", &scale,
 		    "scale/normalize counters"),
 	OPT_INCR('v', "verbose", &verbose,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c3836b9..c1f205c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -38,6 +38,7 @@
 #include "util/cpumap.h"
 #include "util/xyarray.h"
 #include "util/sort.h"
+#include "util/group.h"
 
 #include "util/debug.h"
 
@@ -830,7 +831,7 @@ static void perf_top__start_counters(struct perf_top *top)
 		struct perf_event_attr *attr = &counter->attr;
 		struct xyarray *group_fd = NULL;
 
-		if (top->group && counter != first)
+		if (group_is_single(top->group) && counter != first)
 			group_fd = first->fd;
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
@@ -1120,8 +1121,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 			    "dump the symbol table used for profiling"),
 	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
-	OPT_BOOLEAN('g', "group", &top.group,
-			    "put the counters into a counter group"),
+	OPT_CALLBACK_DEFAULT('g', "group", &top.group, "[parsed]",
+		    "put the counters into a counter group",
+		    parse_group, PERF_GROUP_NONE),
 	OPT_BOOLEAN('i', "inherit", &top.inherit,
 		    "child tasks inherit counters"),
 	OPT_STRING(0, "sym-annotate", &top.sym_filter, "symbol name",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ea804f5..b2aa37a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -189,7 +189,7 @@ struct perf_record_opts {
 	pid_t	     target_pid;
 	pid_t	     target_tid;
 	bool	     call_graph;
-	bool	     group;
+	int	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
 	bool	     no_inherit;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4a8c8b0..280286a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -14,6 +14,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
+#include "group.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
@@ -284,8 +285,17 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
+static int perf_evsel_group(struct perf_evsel *evsel,
+			    int cpu, int thread)
+{
+	if (evsel->group_leader)
+		return FD(evsel->group_leader, cpu, thread);
+
+	return -1;
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group,
+			      struct thread_map *threads, int group,
 			      struct xyarray *group_fds)
 {
 	int cpu, thread;
@@ -302,13 +312,19 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		int group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
+		int group_fd = -1;
+
+		if (group_is_single(group))
+			group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
 			if (!evsel->cgrp)
 				pid = threads->map[thread];
 
+			if (group_is_parsed(group))
+				group_fd = perf_evsel_group(evsel, cpu, thread);
+
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
@@ -318,7 +334,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 				goto out_close;
 			}
 
-			if (group && group_fd == -1)
+			if (group_is_single(group) && group_fd == -1)
 				group_fd = FD(evsel, cpu, thread);
 		}
 	}
@@ -363,7 +379,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group,
+		     struct thread_map *threads, int group,
 		     struct xyarray *group_fd)
 {
 	if (cpus == NULL) {
@@ -378,7 +394,7 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group,
+			     struct cpu_map *cpus, int group,
 			     struct xyarray *group_fd)
 {
 	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group,
@@ -386,7 +402,7 @@ int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group,
+				struct thread_map *threads, int group,
 				struct xyarray *group_fd)
 {
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 326b8e4..db9ee0b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -66,6 +66,7 @@ struct perf_evsel {
 		void		*data;
 	} handler;
 	bool 			supported;
+	struct perf_evsel	*group_leader;
 };
 
 struct cpu_map;
@@ -90,14 +91,14 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group,
+			     struct cpu_map *cpus, int group,
 			     struct xyarray *group_fds);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group,
+				struct thread_map *threads, int group,
 				struct xyarray *group_fds);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group,
-		     struct xyarray *group_fds);
+		     struct thread_map *threads, int group,
+		     struct xyarray *group_fd);
 void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
diff --git a/tools/perf/util/group.c b/tools/perf/util/group.c
new file mode 100644
index 0000000..89468a9
--- /dev/null
+++ b/tools/perf/util/group.c
@@ -0,0 +1,23 @@
+
+#include <linux/compiler.h>
+#include "types.h"
+#include "util.h"
+#include "parse-options.h"
+#include "group.h"
+
+int parse_group(const struct option *opt, const char *str,
+		int unset __used)
+{
+	int *group_opt = (int *) opt->value;
+
+	if (!str)
+		*group_opt = PERF_GROUP_SINGLE;
+	else if (!strcmp(str, "parsed"))
+		*group_opt = PERF_GROUP_PARSED;
+	else {
+		fprintf(stderr, "unknown group option value\n");
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/group.h b/tools/perf/util/group.h
new file mode 100644
index 0000000..ad80015
--- /dev/null
+++ b/tools/perf/util/group.h
@@ -0,0 +1,25 @@
+#ifndef __GROUP_H__
+#define __GROUP_H__
+
+struct option;
+
+enum perf_group_opt {
+	PERF_GROUP_NONE,
+	PERF_GROUP_SINGLE,
+	PERF_GROUP_PARSED
+};
+
+int parse_group(const struct option *opt, const char *str,
+		int unset);
+
+static inline bool group_is_single(int group)
+{
+	return group == PERF_GROUP_SINGLE;
+}
+
+static inline bool group_is_parsed(int group)
+{
+	return group == PERF_GROUP_PARSED;
+}
+
+#endif /* __GROUP_H__ */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b9c4189..b7913c3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -25,6 +25,7 @@ struct event_symbol {
 int parse_events_parse(void);
 
 static struct perf_evlist *__evlist;
+static struct perf_evsel *group_leader;
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -373,6 +374,10 @@ static int add_event(struct perf_event_attr *attr, char *name, char *mod)
 	if (!evsel->name)
 		return -ENOMEM;
 
+	evsel->group_leader = group_leader;
+	if (!group_leader)
+		group_leader = evsel;
+
 	strncpy(evsel->name, name, len);
 	return 0;
 }
@@ -696,6 +701,7 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 	int ret;
 
 	__evlist = evlist;
+	group_leader = NULL;
 
 	buffer = parse_events__scan_string(str);
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 9dd47a4..b91a43b 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -7,6 +7,7 @@
 #include "event.h"
 #include "cpumap.h"
 #include "thread_map.h"
+#include "group.h"
 
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
 #ifndef PyVarObject_HEAD_INIT
@@ -828,6 +829,9 @@ static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist, &group))
 		return NULL;
 
+	if (group)
+		group = PERF_GROUP_SINGLE;
+
 	if (perf_evlist__open(evlist, group) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index a248f3c..f545bc6 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -32,7 +32,7 @@ struct perf_top {
 	bool		   kptr_restrict_warned;
 	bool		   vmlinux_warned;
 	bool		   inherit;
-	bool		   group;
+	int		   group;
 	bool		   sample_id_all_avail;
 	bool		   dump_symtab;
 	const char	   *cpu_list;
-- 
1.7.4

