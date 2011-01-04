Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab1ADDup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:50:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:43485 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1ADDtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:49:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 01/11] perf tools: Introduce event selectors
Date: Tue,  4 Jan 2011 01:48:15 -0200
Message-Id: <1294112905-25325-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Out of ad-hoc code and global arrays with hard coded sizes.

This is the first step on having a library that will be first
used on regression tests in the 'perf test' tool.

[acme@felicio linux]$ size /tmp/perf.before
   text	   data	    bss	    dec	    hex	filename
1273776	  97384	5104416	6475576	 62cf38	/tmp/perf.before
[acme@felicio linux]$ size /tmp/perf.new
   text	   data	    bss	    dec	    hex	filename
1275422	  97416	1392416	2765254	 2a31c6	/tmp/perf.new

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                |    4 +
 tools/perf/builtin-record.c        |  113 +++++++++++------------
 tools/perf/builtin-stat.c          |  175 ++++++++++++++++++++++--------------
 tools/perf/builtin-top.c           |  176 +++++++++++++++++++++---------------
 tools/perf/util/evsel.c            |   35 +++++++
 tools/perf/util/evsel.h            |   24 +++++
 tools/perf/util/header.c           |    9 +-
 tools/perf/util/header.h           |    3 +-
 tools/perf/util/parse-events.c     |   47 +++++++----
 tools/perf/util/parse-events.h     |   17 +++--
 tools/perf/util/trace-event-info.c |   30 ++++---
 tools/perf/util/trace-event.h      |    5 +-
 tools/perf/util/xyarray.c          |   20 ++++
 tools/perf/util/xyarray.h          |   20 ++++
 14 files changed, 433 insertions(+), 245 deletions(-)
 create mode 100644 tools/perf/util/evsel.c
 create mode 100644 tools/perf/util/evsel.h
 create mode 100644 tools/perf/util/xyarray.c
 create mode 100644 tools/perf/util/xyarray.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac6692c..1b9b13e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -396,6 +396,7 @@ LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/event.h
+LIB_H += util/evsel.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
@@ -404,6 +405,7 @@ LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
 LIB_H += util/util.h
+LIB_H += util/xyarray.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
@@ -433,6 +435,7 @@ LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
+LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
@@ -470,6 +473,7 @@ LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
+LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 50efbd5..e68aee3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -18,6 +18,7 @@
 
 #include "util/header.h"
 #include "util/event.h"
+#include "util/evsel.h"
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
@@ -27,13 +28,13 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
 };
 
-static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
-
 static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 static u64			sample_type;
@@ -81,7 +82,6 @@ static struct perf_session	*session;
 static const char		*cpu_list;
 
 struct mmap_data {
-	int			counter;
 	void			*base;
 	unsigned int		mask;
 	unsigned int		prev;
@@ -229,12 +229,12 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu)
+static void create_counter(struct perf_evsel *evsel, int cpu)
 {
-	char *filter = filters[counter];
-	struct perf_event_attr *attr = attrs + counter;
+	char *filter = evsel->filter;
+	struct perf_event_attr *attr = &evsel->attr;
 	struct perf_header_attr *h_attr;
-	int track = !counter; /* only the first counter needs these */
+	int track = !evsel->idx; /* only the first counter needs these */
 	int thread_index;
 	int ret;
 	struct {
@@ -320,10 +320,9 @@ retry_sample_id:
 
 	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
-		fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
-				all_tids[thread_index], cpu, group_fd, 0);
+		FD(evsel, nr_cpu, thread_index) = sys_perf_event_open(attr, all_tids[thread_index], cpu, group_fd, 0);
 
-		if (fd[nr_cpu][counter][thread_index] < 0) {
+		if (FD(evsel, nr_cpu, thread_index) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -360,7 +359,7 @@ try_again:
 			}
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
-					fd[nr_cpu][counter][thread_index], strerror(err));
+			      FD(evsel, nr_cpu, thread_index), strerror(err));
 
 #if defined(__i386__) || defined(__x86_64__)
 			if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
@@ -374,7 +373,7 @@ try_again:
 			exit(-1);
 		}
 
-		h_attr = get_header_attr(attr, counter);
+		h_attr = get_header_attr(attr, evsel->idx);
 		if (h_attr == NULL)
 			die("nomem\n");
 
@@ -385,7 +384,7 @@ try_again:
 			}
 		}
 
-		if (read(fd[nr_cpu][counter][thread_index], &read_data, sizeof(read_data)) == -1) {
+		if (read(FD(evsel, nr_cpu, thread_index), &read_data, sizeof(read_data)) == -1) {
 			perror("Unable to read perf file descriptor");
 			exit(-1);
 		}
@@ -395,43 +394,44 @@ try_again:
 			exit(-1);
 		}
 
-		assert(fd[nr_cpu][counter][thread_index] >= 0);
-		fcntl(fd[nr_cpu][counter][thread_index], F_SETFL, O_NONBLOCK);
+		assert(FD(evsel, nr_cpu, thread_index) >= 0);
+		fcntl(FD(evsel, nr_cpu, thread_index), F_SETFL, O_NONBLOCK);
 
 		/*
 		 * First counter acts as the group leader:
 		 */
 		if (group && group_fd == -1)
-			group_fd = fd[nr_cpu][counter][thread_index];
-
-		if (counter || thread_index) {
-			ret = ioctl(fd[nr_cpu][counter][thread_index],
-					PERF_EVENT_IOC_SET_OUTPUT,
-					fd[nr_cpu][0][0]);
+			group_fd = FD(evsel, nr_cpu, thread_index);
+
+		if (evsel->idx || thread_index) {
+			struct perf_evsel *first;
+			first = list_entry(evsel_list.next, struct perf_evsel, node);
+			ret = ioctl(FD(evsel, nr_cpu, thread_index),
+				    PERF_EVENT_IOC_SET_OUTPUT,
+				    FD(first, nr_cpu, 0));
 			if (ret) {
 				error("failed to set output: %d (%s)\n", errno,
 						strerror(errno));
 				exit(-1);
 			}
 		} else {
-			mmap_array[nr_cpu].counter = counter;
 			mmap_array[nr_cpu].prev = 0;
 			mmap_array[nr_cpu].mask = mmap_pages*page_size - 1;
 			mmap_array[nr_cpu].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
+				PROT_READ | PROT_WRITE, MAP_SHARED, FD(evsel, nr_cpu, thread_index), 0);
 			if (mmap_array[nr_cpu].base == MAP_FAILED) {
 				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
 				exit(-1);
 			}
 
-			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
+			event_array[nr_poll].fd = FD(evsel, nr_cpu, thread_index);
 			event_array[nr_poll].events = POLLIN;
 			nr_poll++;
 		}
 
 		if (filter != NULL) {
-			ret = ioctl(fd[nr_cpu][counter][thread_index],
-					PERF_EVENT_IOC_SET_FILTER, filter);
+			ret = ioctl(FD(evsel, nr_cpu, thread_index),
+				    PERF_EVENT_IOC_SET_FILTER, filter);
 			if (ret) {
 				error("failed to set filter with %d (%s)\n", errno,
 						strerror(errno));
@@ -446,11 +446,12 @@ try_again:
 
 static void open_counters(int cpu)
 {
-	int counter;
+	struct perf_evsel *pos;
 
 	group_fd = -1;
-	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu);
+
+	list_for_each_entry(pos, &evsel_list, node)
+		create_counter(pos, cpu);
 
 	nr_cpu++;
 }
@@ -537,7 +538,7 @@ static void mmap_read_all(void)
 
 static int __cmd_record(int argc, const char **argv)
 {
-	int i, counter;
+	int i;
 	struct stat st;
 	int flags;
 	int err;
@@ -604,7 +605,7 @@ static int __cmd_record(int argc, const char **argv)
 			goto out_delete_session;
 	}
 
-	if (have_tracepoints(attrs, nr_counters))
+	if (have_tracepoints(&evsel_list))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
 	/*
@@ -666,12 +667,6 @@ static int __cmd_record(int argc, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	nr_cpus = read_cpu_map(cpu_list);
-	if (nr_cpus < 1) {
-		perror("failed to collect number of CPUs");
-		return -1;
-	}
-
 	if (!system_wide && no_inherit && !cpu_list) {
 		open_counters(-1);
 	} else {
@@ -711,7 +706,7 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 		}
 
-		if (have_tracepoints(attrs, nr_counters)) {
+		if (have_tracepoints(&evsel_list)) {
 			/*
 			 * FIXME err <= 0 here actually means that
 			 * there were no tracepoints so its not really
@@ -720,8 +715,7 @@ static int __cmd_record(int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = event__synthesize_tracing_data(output, attrs,
-							     nr_counters,
+			err = event__synthesize_tracing_data(output, &evsel_list,
 							     process_synthesized_event,
 							     session);
 			if (err <= 0) {
@@ -795,13 +789,13 @@ static int __cmd_record(int argc, const char **argv)
 
 		if (done) {
 			for (i = 0; i < nr_cpu; i++) {
-				for (counter = 0;
-					counter < nr_counters;
-					counter++) {
+				struct perf_evsel *pos;
+
+				list_for_each_entry(pos, &evsel_list, node) {
 					for (thread = 0;
 						thread < thread_num;
 						thread++)
-						ioctl(fd[i][counter][thread],
+						ioctl(FD(pos, i, thread),
 							PERF_EVENT_IOC_DISABLE);
 				}
 			}
@@ -887,7 +881,8 @@ const struct option record_options[] = {
 
 int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, err = -ENOMEM;
+	int err = -ENOMEM;
+	struct perf_evsel *pos;
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
@@ -910,10 +905,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (no_buildid_cache || no_buildid)
 		disable_buildid_cache();
 
-	if (!nr_counters) {
-		nr_counters	= 1;
-		attrs[0].type	= PERF_TYPE_HARDWARE;
-		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
+	if (list_empty(&evsel_list) && perf_evsel_list__create_default() < 0) {
+		pr_err("Not enough memory for event selector list\n");
+		goto out_symbol_exit;
 	}
 
 	if (target_pid != -1) {
@@ -933,12 +927,15 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	for (i = 0; i < MAX_NR_CPUS; i++) {
-		for (j = 0; j < MAX_COUNTERS; j++) {
-			fd[i][j] = malloc(sizeof(int)*thread_num);
-			if (!fd[i][j])
-				goto out_free_fd;
-		}
+	nr_cpus = read_cpu_map(cpu_list);
+	if (nr_cpus < 1) {
+		perror("failed to collect number of CPUs");
+		return -1;
+	}
+
+	list_for_each_entry(pos, &evsel_list, node) {
+		if (perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
+			goto out_free_fd;
 	}
 	event_array = malloc(
 		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
@@ -968,10 +965,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 out_free_event_array:
 	free(event_array);
 out_free_fd:
-	for (i = 0; i < MAX_NR_CPUS; i++) {
-		for (j = 0; j < MAX_COUNTERS; j++)
-			free(fd[i][j]);
-	}
+	list_for_each_entry(pos, &evsel_list, node)
+		perf_evsel__free_fd(pos);
 	free(all_tids);
 	all_tids = NULL;
 out_symbol_exit:
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7ff746d..511ebaf 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
+#include "util/evsel.h"
 #include "util/debug.h"
 #include "util/header.h"
 #include "util/cpumap.h"
@@ -52,6 +53,8 @@
 #include <math.h>
 #include <locale.h>
 
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+
 #define DEFAULT_SEPARATOR	" "
 
 static struct perf_event_attr default_attrs[] = {
@@ -90,16 +93,11 @@ static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 
-
-static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
-
-static int			event_scaled[MAX_COUNTERS];
-
-static struct {
+struct cpu_counts {
 	u64 val;
 	u64 ena;
 	u64 run;
-} cpu_counts[MAX_NR_CPUS][MAX_COUNTERS];
+};
 
 static volatile int done = 0;
 
@@ -108,6 +106,26 @@ struct stats
 	double n, mean, M2;
 };
 
+struct perf_stat {
+	struct stats	  res_stats[3];
+	int		  scaled;
+	struct cpu_counts cpu_counts[];
+};
+
+static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel, int ncpus)
+{
+	size_t priv_size = (sizeof(struct perf_stat) +
+			    (ncpus * sizeof(struct cpu_counts)));
+	evsel->priv = zalloc(priv_size);
+	return evsel->priv == NULL ? -ENOMEM : 0;
+}
+
+static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
+{
+	free(evsel->priv);
+	evsel->priv = NULL;
+}
+
 static void update_stats(struct stats *stats, u64 val)
 {
 	double delta;
@@ -147,22 +165,21 @@ static double stddev_stats(struct stats *stats)
 	return sqrt(variance_mean);
 }
 
-struct stats			event_res_stats[MAX_COUNTERS][3];
 struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
 struct stats			runtime_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
-#define MATCH_EVENT(t, c, counter)			\
-	(attrs[counter].type == PERF_TYPE_##t &&	\
-	 attrs[counter].config == PERF_COUNT_##c)
+#define MATCH_EVENT(t, c, evsel)			\
+	(evsel->attr.type == PERF_TYPE_##t &&	\
+	 evsel->attr.config == PERF_COUNT_##c)
 
 #define ERR_PERF_OPEN \
 "counter %d, sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information."
 
-static int create_perf_stat_counter(int counter, bool *perm_err)
+static int create_perf_stat_counter(struct perf_evsel *evsel, bool *perm_err)
 {
-	struct perf_event_attr *attr = attrs + counter;
+	struct perf_event_attr *attr = &evsel->attr;
 	int thread;
 	int ncreated = 0;
 
@@ -174,13 +191,13 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 		int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter][0] = sys_perf_event_open(attr,
+			FD(evsel, cpu, 0) = sys_perf_event_open(attr,
 					-1, cpumap[cpu], -1, 0);
-			if (fd[cpu][counter][0] < 0) {
+			if (FD(evsel, cpu, 0) < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
-				error(ERR_PERF_OPEN, counter,
-					 fd[cpu][counter][0], strerror(errno));
+				error(ERR_PERF_OPEN, evsel->idx,
+					FD(evsel, cpu, 0), strerror(errno));
 			} else {
 				++ncreated;
 			}
@@ -192,13 +209,13 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 			attr->enable_on_exec = 1;
 		}
 		for (thread = 0; thread < thread_num; thread++) {
-			fd[0][counter][thread] = sys_perf_event_open(attr,
+			FD(evsel, 0, thread) = sys_perf_event_open(attr,
 				all_tids[thread], -1, -1, 0);
-			if (fd[0][counter][thread] < 0) {
+			if (FD(evsel, 0, thread) < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
-				error(ERR_PERF_OPEN, counter,
-					 fd[0][counter][thread],
+				error(ERR_PERF_OPEN, evsel->idx,
+					FD(evsel, 0, thread),
 					 strerror(errno));
 			} else {
 				++ncreated;
@@ -212,7 +229,7 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 /*
  * Does the counter have nsecs as a unit?
  */
-static inline int nsec_counter(int counter)
+static inline int nsec_counter(struct perf_evsel *counter)
 {
 	if (MATCH_EVENT(SOFTWARE, SW_CPU_CLOCK, counter) ||
 	    MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
@@ -225,8 +242,9 @@ static inline int nsec_counter(int counter)
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
-static void read_counter_aggr(int counter)
+static void read_counter_aggr(struct perf_evsel *counter)
 {
+	struct perf_stat *ps = counter->priv;
 	u64 count[3], single_count[3];
 	int cpu;
 	size_t res, nv;
@@ -238,15 +256,15 @@ static void read_counter_aggr(int counter)
 	nv = scale ? 3 : 1;
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		for (thread = 0; thread < thread_num; thread++) {
-			if (fd[cpu][counter][thread] < 0)
+			if (FD(counter, cpu, thread) < 0)
 				continue;
 
-			res = read(fd[cpu][counter][thread],
+			res = read(FD(counter, cpu, thread),
 					single_count, nv * sizeof(u64));
 			assert(res == nv * sizeof(u64));
 
-			close(fd[cpu][counter][thread]);
-			fd[cpu][counter][thread] = -1;
+			close(FD(counter, cpu, thread));
+			FD(counter, cpu, thread) = -1;
 
 			count[0] += single_count[0];
 			if (scale) {
@@ -259,20 +277,20 @@ static void read_counter_aggr(int counter)
 	scaled = 0;
 	if (scale) {
 		if (count[2] == 0) {
-			event_scaled[counter] = -1;
+			ps->scaled = -1;
 			count[0] = 0;
 			return;
 		}
 
 		if (count[2] < count[1]) {
-			event_scaled[counter] = 1;
+			ps->scaled = 1;
 			count[0] = (unsigned long long)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
 	}
 
 	for (i = 0; i < 3; i++)
-		update_stats(&event_res_stats[counter][i], count[i]);
+		update_stats(&ps->res_stats[i], count[i]);
 
 	if (verbose) {
 		fprintf(stderr, "%s: %Ld %Ld %Ld\n", event_name(counter),
@@ -294,8 +312,9 @@ static void read_counter_aggr(int counter)
  * Read out the results of a single counter:
  * do not aggregate counts across CPUs in system-wide mode
  */
-static void read_counter(int counter)
+static void read_counter(struct perf_evsel *counter)
 {
+	struct cpu_counts *cpu_counts = counter->priv;
 	u64 count[3];
 	int cpu;
 	size_t res, nv;
@@ -306,15 +325,15 @@ static void read_counter(int counter)
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 
-		if (fd[cpu][counter][0] < 0)
+		if (FD(counter, cpu, 0) < 0)
 			continue;
 
-		res = read(fd[cpu][counter][0], count, nv * sizeof(u64));
+		res = read(FD(counter, cpu, 0), count, nv * sizeof(u64));
 
 		assert(res == nv * sizeof(u64));
 
-		close(fd[cpu][counter][0]);
-		fd[cpu][counter][0] = -1;
+		close(FD(counter, cpu, 0));
+		FD(counter, cpu, 0) = -1;
 
 		if (scale) {
 			if (count[2] == 0) {
@@ -324,9 +343,9 @@ static void read_counter(int counter)
 				((double)count[0] * count[1] / count[2] + 0.5);
 			}
 		}
-		cpu_counts[cpu][counter].val = count[0]; /* scaled count */
-		cpu_counts[cpu][counter].ena = count[1];
-		cpu_counts[cpu][counter].run = count[2];
+		cpu_counts[cpu].val = count[0]; /* scaled count */
+		cpu_counts[cpu].ena = count[1];
+		cpu_counts[cpu].run = count[2];
 
 		if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
 			update_stats(&runtime_nsecs_stats[cpu], count[0]);
@@ -340,8 +359,9 @@ static void read_counter(int counter)
 static int run_perf_stat(int argc __used, const char **argv)
 {
 	unsigned long long t0, t1;
+	struct perf_evsel *counter;
 	int status = 0;
-	int counter, ncreated = 0;
+	int ncreated = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	bool perm_err = false;
 	const bool forks = (argc > 0);
@@ -401,7 +421,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	for (counter = 0; counter < nr_counters; counter++)
+	list_for_each_entry(counter, &evsel_list, node)
 		ncreated += create_perf_stat_counter(counter, &perm_err);
 
 	if (ncreated < nr_counters) {
@@ -433,25 +453,28 @@ static int run_perf_stat(int argc __used, const char **argv)
 	update_stats(&walltime_nsecs_stats, t1 - t0);
 
 	if (no_aggr) {
-		for (counter = 0; counter < nr_counters; counter++)
+		list_for_each_entry(counter, &evsel_list, node)
 			read_counter(counter);
 	} else {
-		for (counter = 0; counter < nr_counters; counter++)
+		list_for_each_entry(counter, &evsel_list, node)
 			read_counter_aggr(counter);
 	}
 	return WEXITSTATUS(status);
 }
 
-static void print_noise(int counter, double avg)
+static void print_noise(struct perf_evsel *evsel, double avg)
 {
+	struct perf_stat *ps;
+
 	if (run_count == 1)
 		return;
 
+	ps = evsel->priv;
 	fprintf(stderr, "   ( +- %7.3f%% )",
-			100 * stddev_stats(&event_res_stats[counter][0]) / avg);
+			100 * stddev_stats(&ps->res_stats[0]) / avg);
 }
 
-static void nsec_printout(int cpu, int counter, double avg)
+static void nsec_printout(int cpu, struct perf_evsel *counter, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
@@ -473,7 +496,7 @@ static void nsec_printout(int cpu, int counter, double avg)
 	}
 }
 
-static void abs_printout(int cpu, int counter, double avg)
+static void abs_printout(int cpu, struct perf_evsel *counter, double avg)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
@@ -528,10 +551,11 @@ static void abs_printout(int cpu, int counter, double avg)
  * Print out the results of a single counter:
  * aggregated counts in system-wide mode
  */
-static void print_counter_aggr(int counter)
+static void print_counter_aggr(struct perf_evsel *counter)
 {
-	double avg = avg_stats(&event_res_stats[counter][0]);
-	int scaled = event_scaled[counter];
+	struct perf_stat *ps = counter->priv;
+	double avg = avg_stats(&ps->res_stats[0]);
+	int scaled = ps->scaled;
 
 	if (scaled == -1) {
 		fprintf(stderr, "%*s%s%-24s\n",
@@ -555,8 +579,8 @@ static void print_counter_aggr(int counter)
 	if (scaled) {
 		double avg_enabled, avg_running;
 
-		avg_enabled = avg_stats(&event_res_stats[counter][1]);
-		avg_running = avg_stats(&event_res_stats[counter][2]);
+		avg_enabled = avg_stats(&ps->res_stats[1]);
+		avg_running = avg_stats(&ps->res_stats[2]);
 
 		fprintf(stderr, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
@@ -569,15 +593,16 @@ static void print_counter_aggr(int counter)
  * Print out the results of a single counter:
  * does not use aggregated count in system-wide
  */
-static void print_counter(int counter)
+static void print_counter(struct perf_evsel *counter)
 {
+	struct perf_stat *ps = counter->priv;
 	u64 ena, run, val;
 	int cpu;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		val = cpu_counts[cpu][counter].val;
-		ena = cpu_counts[cpu][counter].ena;
-		run = cpu_counts[cpu][counter].run;
+		val = ps->cpu_counts[cpu].val;
+		ena = ps->cpu_counts[cpu].ena;
+		run = ps->cpu_counts[cpu].run;
 		if (run == 0 || ena == 0) {
 			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
 				csv_output ? 0 : -4,
@@ -609,7 +634,8 @@ static void print_counter(int counter)
 
 static void print_stat(int argc, const char **argv)
 {
-	int i, counter;
+	struct perf_evsel *counter;
+	int i;
 
 	fflush(stdout);
 
@@ -632,10 +658,10 @@ static void print_stat(int argc, const char **argv)
 	}
 
 	if (no_aggr) {
-		for (counter = 0; counter < nr_counters; counter++)
+		list_for_each_entry(counter, &evsel_list, node)
 			print_counter(counter);
 	} else {
-		for (counter = 0; counter < nr_counters; counter++)
+		list_for_each_entry(counter, &evsel_list, node)
 			print_counter_aggr(counter);
 	}
 
@@ -720,8 +746,8 @@ static const struct option options[] = {
 
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
-	int status;
-	int i,j;
+	struct perf_evsel *pos;
+	int status = -ENOMEM;
 
 	setlocale(LC_ALL, "");
 
@@ -757,8 +783,18 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
-		memcpy(attrs, default_attrs, sizeof(default_attrs));
+		size_t c;
+
 		nr_counters = ARRAY_SIZE(default_attrs);
+
+		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
+			pos = perf_evsel__new(default_attrs[c].type,
+					      default_attrs[c].config,
+					      nr_counters);
+			if (pos == NULL)
+				goto out;
+			list_add(&pos->node, &evsel_list);
+		}
 	}
 
 	if (system_wide)
@@ -786,12 +822,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	for (i = 0; i < MAX_NR_CPUS; i++) {
-		for (j = 0; j < MAX_COUNTERS; j++) {
-			fd[i][j] = malloc(sizeof(int)*thread_num);
-			if (!fd[i][j])
-				return -ENOMEM;
-		}
+	list_for_each_entry(pos, &evsel_list, node) {
+		if (perf_evsel__alloc_stat_priv(pos, nr_cpus) < 0 ||
+		    perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
+			goto out_free_fd;
 	}
 
 	/*
@@ -814,6 +848,11 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	if (status != -1)
 		print_stat(argc, argv);
-
+out_free_fd:
+	list_for_each_entry(pos, &evsel_list, node) {
+		perf_evsel__free_fd(pos);
+		perf_evsel__free_stat_priv(pos);
+	}
+out:
 	return status;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ae15f04..13a836e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -21,6 +21,7 @@
 #include "perf.h"
 
 #include "util/color.h"
+#include "util/evsel.h"
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
@@ -29,6 +30,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/cpumap.h"
+#include "util/xyarray.h"
 
 #include "util/debug.h"
 
@@ -55,7 +57,7 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
 static bool			system_wide			=  false;
 
@@ -100,6 +102,7 @@ struct sym_entry		*sym_filter_entry		=   NULL;
 struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
 static int			sym_counter			=      0;
+static struct perf_evsel	*sym_evsel			=   NULL;
 static int			display_weighted		=     -1;
 static const char		*cpu_list;
 
@@ -353,7 +356,7 @@ static void show_details(struct sym_entry *syme)
 		return;
 
 	symbol = sym_entry__symbol(syme);
-	printf("Showing %s for %s\n", event_name(sym_counter), symbol->name);
+	printf("Showing %s for %s\n", event_name(sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
 	pthread_mutex_lock(&syme->src->lock);
@@ -460,7 +463,8 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 static void print_sym_table(void)
 {
 	int printed = 0, j;
-	int counter, snap = !display_weighted ? sym_counter : 0;
+	struct perf_evsel *counter;
+	int snap = !display_weighted ? sym_counter : 0;
 	float samples_per_sec = samples/delay_secs;
 	float ksamples_per_sec = kernel_samples/delay_secs;
 	float us_samples_per_sec = (us_samples)/delay_secs;
@@ -532,7 +536,9 @@ static void print_sym_table(void)
 	}
 
 	if (nr_counters == 1 || !display_weighted) {
-		printf("%Ld", (u64)attrs[0].sample_period);
+		struct perf_evsel *first;
+		first = list_entry(evsel_list.next, struct perf_evsel, node);
+		printf("%Ld", first->attr.sample_period);
 		if (freq)
 			printf("Hz ");
 		else
@@ -540,9 +546,9 @@ static void print_sym_table(void)
 	}
 
 	if (!display_weighted)
-		printf("%s", event_name(sym_counter));
-	else for (counter = 0; counter < nr_counters; counter++) {
-		if (counter)
+		printf("%s", event_name(sym_evsel));
+	else list_for_each_entry(counter, &evsel_list, node) {
+		if (counter->idx)
 			printf("/");
 
 		printf("%s", event_name(counter));
@@ -739,7 +745,7 @@ static void print_mapped_keys(void)
 	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", print_entries);
 
 	if (nr_counters > 1)
-		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_counter));
+		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_evsel));
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
 
@@ -826,19 +832,23 @@ static void handle_keypress(struct perf_session *session, int c)
 			break;
 		case 'E':
 			if (nr_counters > 1) {
-				int i;
-
 				fprintf(stderr, "\nAvailable events:");
-				for (i = 0; i < nr_counters; i++)
-					fprintf(stderr, "\n\t%d %s", i, event_name(i));
+
+				list_for_each_entry(sym_evsel, &evsel_list, node)
+					fprintf(stderr, "\n\t%d %s", sym_evsel->idx, event_name(sym_evsel));
 
 				prompt_integer(&sym_counter, "Enter details event counter");
 
 				if (sym_counter >= nr_counters) {
-					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(0));
+					sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
 					sym_counter = 0;
+					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(sym_evsel));
 					sleep(1);
+					break;
 				}
+				list_for_each_entry(sym_evsel, &evsel_list, node)
+					if (sym_evsel->idx == sym_counter)
+						break;
 			} else sym_counter = 0;
 			break;
 		case 'f':
@@ -978,7 +988,8 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 static void event__process_sample(const event_t *self,
 				  struct sample_data *sample,
-				  struct perf_session *session, int counter)
+				  struct perf_session *session,
+				  struct perf_evsel *evsel)
 {
 	u64 ip = self->ip.ip;
 	struct sym_entry *syme;
@@ -1071,9 +1082,9 @@ static void event__process_sample(const event_t *self,
 
 	syme = symbol__priv(al.sym);
 	if (!syme->skip) {
-		syme->count[counter]++;
+		syme->count[evsel->idx]++;
 		syme->origin = origin;
-		record_precise_ip(syme, counter, ip);
+		record_precise_ip(syme, evsel->idx, ip);
 		pthread_mutex_lock(&active_symbols_lock);
 		if (list_empty(&syme->node) || !syme->node.next)
 			__list_insert_active_sym(syme);
@@ -1082,12 +1093,24 @@ static void event__process_sample(const event_t *self,
 }
 
 struct mmap_data {
-	int			counter;
 	void			*base;
 	int			mask;
 	unsigned int		prev;
 };
 
+static int perf_evsel__alloc_mmap_per_thread(struct perf_evsel *evsel,
+					     int ncpus, int nthreads)
+{
+	evsel->priv = xyarray__new(ncpus, nthreads, sizeof(struct mmap_data));
+	return evsel->priv != NULL ? 0 : -ENOMEM;
+}
+
+static void perf_evsel__free_mmap(struct perf_evsel *evsel)
+{
+	xyarray__delete(evsel->priv);
+	evsel->priv = NULL;
+}
+
 static unsigned int mmap_read_head(struct mmap_data *md)
 {
 	struct perf_event_mmap_page *pc = md->base;
@@ -1100,8 +1123,11 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 }
 
 static void perf_session__mmap_read_counter(struct perf_session *self,
-					    struct mmap_data *md)
+					    struct perf_evsel *evsel,
+					    int cpu, int thread_idx)
 {
+	struct xyarray *mmap_array = evsel->priv;
+	struct mmap_data *md = xyarray__entry(mmap_array, cpu, thread_idx);
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -1155,7 +1181,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 
 		event__parse_sample(event, self, &sample);
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			event__process_sample(event, &sample, self, md->counter);
+			event__process_sample(event, &sample, self, evsel);
 		else
 			event__process(event, &sample, self);
 		old += size;
@@ -1165,28 +1191,31 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 }
 
 static struct pollfd *event_array;
-static struct mmap_data *mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static void perf_session__mmap_read(struct perf_session *self)
 {
-	int i, counter, thread_index;
+	struct perf_evsel *counter;
+	int i, thread_index;
 
 	for (i = 0; i < nr_cpus; i++) {
-		for (counter = 0; counter < nr_counters; counter++)
+		list_for_each_entry(counter, &evsel_list, node) {
 			for (thread_index = 0;
 				thread_index < thread_num;
 				thread_index++) {
 				perf_session__mmap_read_counter(self,
-					&mmap_array[i][counter][thread_index]);
+					counter, i, thread_index);
 			}
+		}
 	}
 }
 
 int nr_poll;
 int group_fd;
 
-static void start_counter(int i, int counter)
+static void start_counter(int i, struct perf_evsel *evsel)
 {
+	struct xyarray *mmap_array = evsel->priv;
+	struct mmap_data *mm;
 	struct perf_event_attr *attr;
 	int cpu = -1;
 	int thread_index;
@@ -1194,7 +1223,7 @@ static void start_counter(int i, int counter)
 	if (target_tid == -1)
 		cpu = cpumap[i];
 
-	attr = attrs + counter;
+	attr = &evsel->attr;
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -1209,10 +1238,10 @@ static void start_counter(int i, int counter)
 
 	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
-		fd[i][counter][thread_index] = sys_perf_event_open(attr,
+		FD(evsel, i, thread_index) = sys_perf_event_open(attr,
 				all_tids[thread_index], cpu, group_fd, 0);
 
-		if (fd[i][counter][thread_index] < 0) {
+		if (FD(evsel, i, thread_index) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -1236,29 +1265,29 @@ try_again:
 			}
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
-					fd[i][counter][thread_index], strerror(err));
+					FD(evsel, i, thread_index), strerror(err));
 			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			exit(-1);
 		}
-		assert(fd[i][counter][thread_index] >= 0);
-		fcntl(fd[i][counter][thread_index], F_SETFL, O_NONBLOCK);
+		assert(FD(evsel, i, thread_index) >= 0);
+		fcntl(FD(evsel, i, thread_index), F_SETFL, O_NONBLOCK);
 
 		/*
 		 * First counter acts as the group leader:
 		 */
 		if (group && group_fd == -1)
-			group_fd = fd[i][counter][thread_index];
+			group_fd = FD(evsel, i, thread_index);
 
-		event_array[nr_poll].fd = fd[i][counter][thread_index];
+		event_array[nr_poll].fd = FD(evsel, i, thread_index);
 		event_array[nr_poll].events = POLLIN;
 		nr_poll++;
 
-		mmap_array[i][counter][thread_index].counter = counter;
-		mmap_array[i][counter][thread_index].prev = 0;
-		mmap_array[i][counter][thread_index].mask = mmap_pages*page_size - 1;
-		mmap_array[i][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ, MAP_SHARED, fd[i][counter][thread_index], 0);
-		if (mmap_array[i][counter][thread_index].base == MAP_FAILED)
+		mm = xyarray__entry(mmap_array, i, thread_index);
+		mm->prev = 0;
+		mm->mask = mmap_pages*page_size - 1;
+		mm->base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ, MAP_SHARED, FD(evsel, i, thread_index), 0);
+		if (mm->base == MAP_FAILED)
 			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
 }
@@ -1266,8 +1295,8 @@ try_again:
 static int __cmd_top(void)
 {
 	pthread_t thread;
-	int i, counter;
-	int ret;
+	struct perf_evsel *counter;
+	int i, ret;
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
@@ -1283,7 +1312,7 @@ static int __cmd_top(void)
 
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
-		for (counter = 0; counter < nr_counters; counter++)
+		list_for_each_entry(counter, &evsel_list, node)
 			start_counter(i, counter);
 	}
 
@@ -1372,8 +1401,8 @@ static const struct option options[] = {
 
 int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
-	int counter;
-	int i,j;
+	struct perf_evsel *pos;
+	int status = -ENOMEM;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
@@ -1398,15 +1427,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	for (i = 0; i < MAX_NR_CPUS; i++) {
-		for (j = 0; j < MAX_COUNTERS; j++) {
-			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = zalloc(
-				sizeof(struct mmap_data)*thread_num);
-			if (!fd[i][j] || !mmap_array[i][j])
-				return -ENOMEM;
-		}
-	}
 	event_array = malloc(
 		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
 	if (!event_array)
@@ -1419,15 +1439,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		cpu_list = NULL;
 	}
 
-	if (!nr_counters)
-		nr_counters = 1;
-
-	symbol_conf.priv_size = (sizeof(struct sym_entry) +
-				 (nr_counters + 1) * sizeof(unsigned long));
-
-	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
-	if (symbol__init() < 0)
-		return -1;
+	if (!nr_counters && perf_evsel_list__create_default() < 0) {
+		pr_err("Not enough memory for event selector list\n");
+		return -ENOMEM;
+	}
 
 	if (delay_secs < 1)
 		delay_secs = 1;
@@ -1444,16 +1459,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		exit(EXIT_FAILURE);
 	}
 
-	/*
-	 * Fill in the ones not specifically initialized via -c:
-	 */
-	for (counter = 0; counter < nr_counters; counter++) {
-		if (attrs[counter].sample_period)
-			continue;
-
-		attrs[counter].sample_period = default_interval;
-	}
-
 	if (target_tid != -1)
 		nr_cpus = 1;
 	else
@@ -1462,11 +1467,38 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (nr_cpus < 1)
 		usage_with_options(top_usage, options);
 
+	list_for_each_entry(pos, &evsel_list, node) {
+		if (perf_evsel__alloc_mmap_per_thread(pos, nr_cpus, thread_num) < 0 ||
+		    perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
+			goto out_free_fd;
+		/*
+		 * Fill in the ones not specifically initialized via -c:
+		 */
+		if (pos->attr.sample_period)
+			continue;
+
+		pos->attr.sample_period = default_interval;
+	}
+
+	symbol_conf.priv_size = (sizeof(struct sym_entry) +
+				 (nr_counters + 1) * sizeof(unsigned long));
+
+	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
+	if (symbol__init() < 0)
+		return -1;
+
 	get_term_dimensions(&winsize);
 	if (print_entries == 0) {
 		update_print_entries(&winsize);
 		signal(SIGWINCH, sig_winch_handler);
 	}
 
-	return __cmd_top();
+	status = __cmd_top();
+out_free_fd:
+	list_for_each_entry(pos, &evsel_list, node) {
+		perf_evsel__free_fd(pos);
+		perf_evsel__free_mmap(pos);
+	}
+
+	return status;
 }
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
new file mode 100644
index 0000000..6539ec9
--- /dev/null
+++ b/tools/perf/util/evsel.c
@@ -0,0 +1,35 @@
+#include "evsel.h"
+#include "util.h"
+
+struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx)
+{
+	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+
+	if (evsel != NULL) {
+		evsel->idx	   = idx;
+		evsel->attr.type   = type;
+		evsel->attr.config = config;
+		INIT_LIST_HEAD(&evsel->node);
+	}
+
+	return evsel;
+}
+
+int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
+	return evsel->fd != NULL ? 0 : -ENOMEM;
+}
+
+void perf_evsel__free_fd(struct perf_evsel *evsel)
+{
+	xyarray__delete(evsel->fd);
+	evsel->fd = NULL;
+}
+
+void perf_evsel__delete(struct perf_evsel *evsel)
+{
+	assert(list_empty(&evsel->node));
+	xyarray__delete(evsel->fd);
+	free(evsel);
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
new file mode 100644
index 0000000..3eb3989
--- /dev/null
+++ b/tools/perf/util/evsel.h
@@ -0,0 +1,24 @@
+#ifndef __PERF_EVSEL_H
+#define __PERF_EVSEL_H 1
+
+#include <linux/list.h>
+#include <linux/perf_event.h>
+#include "types.h"
+#include "xyarray.h"
+
+struct perf_evsel {
+	struct list_head	node;
+	struct perf_event_attr	attr;
+	char			*filter;
+	struct xyarray		*fd;
+	int			idx;
+	void			*priv;
+};
+
+struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx);
+void perf_evsel__delete(struct perf_evsel *evsel);
+
+int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
+void perf_evsel__free_fd(struct perf_evsel *evsel);
+
+#endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 16a1602..ecb5a84 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -461,7 +461,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 
 		/* Write trace info */
 		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
-		read_tracing_data(fd, attrs, nr_counters);
+		read_tracing_data(fd, &evsel_list);
 		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
@@ -1131,8 +1131,7 @@ int event__process_event_type(event_t *self,
 	return 0;
 }
 
-int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
-				   int nb_events,
+int event__synthesize_tracing_data(int fd, struct list_head *pattrs,
 				   event__handler_t process,
 				   struct perf_session *session __unused)
 {
@@ -1143,7 +1142,7 @@ int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
 	memset(&ev, 0, sizeof(ev));
 
 	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
-	size = read_tracing_data_size(fd, pattrs, nb_events);
+	size = read_tracing_data_size(fd, pattrs);
 	if (size <= 0)
 		return size;
 	aligned_size = ALIGN(size, sizeof(u64));
@@ -1153,7 +1152,7 @@ int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
 
 	process(&ev, NULL, session);
 
-	err = read_tracing_data(fd, pattrs, nb_events);
+	err = read_tracing_data(fd, pattrs);
 	write_padded(fd, NULL, 0, padding);
 
 	return aligned_size;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 6335965..33f16be 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -113,8 +113,7 @@ int event__synthesize_event_types(event__handler_t process,
 int event__process_event_type(event_t *self,
 			      struct perf_session *session);
 
-int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
-				   int nb_events,
+int event__synthesize_tracing_data(int fd, struct list_head *pattrs,
 				   event__handler_t process,
 				   struct perf_session *session);
 int event__process_tracing_data(event_t *self,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c305305..2d948ad 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,6 +1,7 @@
 #include "../../../include/linux/hw_breakpoint.h"
 #include "util.h"
 #include "../perf.h"
+#include "evsel.h"
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
@@ -12,8 +13,7 @@
 
 int				nr_counters;
 
-struct perf_event_attr		attrs[MAX_COUNTERS];
-char				*filters[MAX_COUNTERS];
+LIST_HEAD(evsel_list);
 
 struct event_symbol {
 	u8		type;
@@ -266,10 +266,10 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
 	return name;
 }
 
-const char *event_name(int counter)
+const char *event_name(struct perf_evsel *evsel)
 {
-	u64 config = attrs[counter].config;
-	int type = attrs[counter].type;
+	u64 config = evsel->attr.config;
+	int type = evsel->attr.type;
 
 	return __event_name(type, config);
 }
@@ -814,9 +814,6 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 			return -1;
 
 	for (;;) {
-		if (nr_counters == MAX_COUNTERS)
-			return -1;
-
 		memset(&attr, 0, sizeof(attr));
 		ret = parse_event_symbols(&str, &attr);
 		if (ret == EVT_FAILED)
@@ -826,8 +823,13 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 			return -1;
 
 		if (ret != EVT_HANDLED_ALL) {
-			attrs[nr_counters] = attr;
-			nr_counters++;
+			struct perf_evsel *evsel;
+			evsel = perf_evsel__new(attr.type, attr.config,
+						nr_counters);
+			if (evsel == NULL)
+				return -1;
+			list_add_tail(&evsel->node, &evsel_list);
+			++nr_counters;
 		}
 
 		if (*str == 0)
@@ -844,21 +846,22 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 int parse_filter(const struct option *opt __used, const char *str,
 		 int unset __used)
 {
-	int i = nr_counters - 1;
-	int len = strlen(str);
+	struct perf_evsel *last = NULL;
 
-	if (i < 0 || attrs[i].type != PERF_TYPE_TRACEPOINT) {
+	if (!list_empty(&evsel_list))
+		last = list_entry(evsel_list.prev, struct perf_evsel, node);
+
+	if (last == NULL || last->attr.type != PERF_TYPE_TRACEPOINT) {
 		fprintf(stderr,
 			"-F option should follow a -e tracepoint option\n");
 		return -1;
 	}
 
-	filters[i] = malloc(len + 1);
-	if (!filters[i]) {
+	last->filter = strdup(str);
+	if (last->filter == NULL) {
 		fprintf(stderr, "not enough memory to hold filter string\n");
 		return -1;
 	}
-	strcpy(filters[i], str);
 
 	return 0;
 }
@@ -967,3 +970,15 @@ void print_events(void)
 
 	exit(129);
 }
+
+int perf_evsel_list__create_default(void)
+{
+	struct perf_evsel *evsel = perf_evsel__new(PERF_TYPE_HARDWARE,
+						   PERF_COUNT_HW_CPU_CYCLES, 0);
+	if (evsel == NULL)
+		return -ENOMEM;
+
+	list_add(&evsel->node, &evsel_list);
+	++nr_counters;
+	return 0;
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fc4ab3f..0f915a0 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,6 +4,15 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+#include <linux/perf_event.h>
+
+struct list_head;
+struct perf_evsel;
+
+extern struct list_head evsel_list;
+
+int perf_evsel_list__create_default(void);
+
 struct option;
 
 struct tracepoint_path {
@@ -13,14 +22,11 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
-extern bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events);
+extern bool have_tracepoints(struct list_head *evsel_list);
 
 extern int			nr_counters;
 
-extern struct perf_event_attr attrs[MAX_COUNTERS];
-extern char *filters[MAX_COUNTERS];
-
-extern const char *event_name(int ctr);
+const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
@@ -33,5 +39,4 @@ extern void print_events(void);
 extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
-
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index b157260..35729f4 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -34,11 +34,13 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <linux/list.h>
 #include <linux/kernel.h>
 
 #include "../perf.h"
 #include "trace-event.h"
 #include "debugfs.h"
+#include "evsel.h"
 
 #define VERSION "0.5"
 
@@ -469,16 +471,17 @@ out:
 }
 
 static struct tracepoint_path *
-get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
+get_tracepoints_path(struct list_head *pattrs)
 {
 	struct tracepoint_path path, *ppath = &path;
-	int i, nr_tracepoints = 0;
+	struct perf_evsel *pos;
+	int nr_tracepoints = 0;
 
-	for (i = 0; i < nb_events; i++) {
-		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
+	list_for_each_entry(pos, pattrs, node) {
+		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
 			continue;
 		++nr_tracepoints;
-		ppath->next = tracepoint_id_to_path(pattrs[i].config);
+		ppath->next = tracepoint_id_to_path(pos->attr.config);
 		if (!ppath->next)
 			die("%s\n", "No memory to alloc tracepoints list");
 		ppath = ppath->next;
@@ -487,21 +490,21 @@ get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 	return nr_tracepoints > 0 ? path.next : NULL;
 }
 
-bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
+bool have_tracepoints(struct list_head *pattrs)
 {
-	int i;
+	struct perf_evsel *pos;
 
-	for (i = 0; i < nb_events; i++)
-		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
+	list_for_each_entry(pos, pattrs, node)
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT)
 			return true;
 
 	return false;
 }
 
-int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
+int read_tracing_data(int fd, struct list_head *pattrs)
 {
 	char buf[BUFSIZ];
-	struct tracepoint_path *tps = get_tracepoints_path(pattrs, nb_events);
+	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
 
 	/*
 	 * What? No tracepoints? No sense writing anything here, bail out.
@@ -545,14 +548,13 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 	return 0;
 }
 
-ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
-			       int nb_events)
+ssize_t read_tracing_data_size(int fd, struct list_head *pattrs)
 {
 	ssize_t size;
 	int err = 0;
 
 	calc_data_size = 1;
-	err = read_tracing_data(fd, pattrs, nb_events);
+	err = read_tracing_data(fd, pattrs);
 	size = calc_data_size - 1;
 	calc_data_size = 0;
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b3e86b1..b5f12ca 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -262,9 +262,8 @@ raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
 unsigned long long eval_flag(const char *flag);
 
-int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
-ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
-			       int nb_events);
+int read_tracing_data(int fd, struct list_head *pattrs);
+ssize_t read_tracing_data_size(int fd, struct list_head *pattrs);
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
new file mode 100644
index 0000000..22afbf6
--- /dev/null
+++ b/tools/perf/util/xyarray.c
@@ -0,0 +1,20 @@
+#include "xyarray.h"
+#include "util.h"
+
+struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
+{
+	size_t row_size = ylen * entry_size;
+	struct xyarray *xy = zalloc(sizeof(*xy) + xlen * row_size);
+
+	if (xy != NULL) {
+		xy->entry_size = entry_size;
+		xy->row_size   = row_size;
+	}
+
+	return xy;
+}
+
+void xyarray__delete(struct xyarray *xy)
+{
+	free(xy);
+}
diff --git a/tools/perf/util/xyarray.h b/tools/perf/util/xyarray.h
new file mode 100644
index 0000000..c488a07
--- /dev/null
+++ b/tools/perf/util/xyarray.h
@@ -0,0 +1,20 @@
+#ifndef _PERF_XYARRAY_H_
+#define _PERF_XYARRAY_H_ 1
+
+#include <sys/types.h>
+
+struct xyarray {
+	size_t row_size;
+	size_t entry_size;
+	char contents[];
+};
+
+struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size);
+void xyarray__delete(struct xyarray *xy);
+
+static inline void *xyarray__entry(struct xyarray *xy, int x, int y)
+{
+	return &xy->contents[x * xy->row_size + y * xy->entry_size];
+}
+
+#endif /* _PERF_XYARRAY_H_ */
-- 
1.6.2.5

