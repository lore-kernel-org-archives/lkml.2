Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0CROg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:36:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:44825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0CROg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:36:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       zhiteng.huang@intel.com, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf events: Change perf parameter --pid to process-wide collection instead of thread-wide
Date: Thu, 18 Mar 2010 11:36:05 -0300
Message-Id: <1268922965-14774-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268922965-14774-1-git-send-email-acme@infradead.org>
References: <1268922965-14774-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Parameter --pid (or -p) of perf currently means a thread-wide collection.
For exmaple, if a process whose id is 8888 has 10 threads, 'perf top -p 8888'
just collects the main thread statistics. That's misleading. Users are
used to attach a whole process when debugging a process by gdb. To follow
normal usage style, the patch change --pid to process-wide collection and
add --tid (-t) to mean a thread-wide collection.

Usage example is:

 # perf top -p 8888
 # perf record -p 8888 -f sleep 10
 # perf stat -p 8888 -f sleep 10

Above commands collect the statistics of all threads of process 8888.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: zhiteng.huang@intel.com
Cc: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |  260 ++++++++++++++++++++++++++-----------------
 tools/perf/builtin-stat.c   |  110 +++++++++++++------
 tools/perf/builtin-top.c    |  162 +++++++++++++++++----------
 tools/perf/util/thread.c    |   32 ++++++
 tools/perf/util/thread.h    |    1 +
 5 files changed, 372 insertions(+), 193 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e2b35ad..bb5b23d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -27,7 +27,7 @@
 #include <unistd.h>
 #include <sched.h>
 
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static long			default_interval		=      0;
 
@@ -43,6 +43,9 @@ static int			raw_samples			=      0;
 static int			system_wide			=      0;
 static int			profile_cpu			=     -1;
 static pid_t			target_pid			=     -1;
+static pid_t			target_tid			=     -1;
+static pid_t			*all_tids			=      NULL;
+static int			thread_num			=      0;
 static pid_t			child_pid			=     -1;
 static int			inherit				=      1;
 static int			force				=      0;
@@ -60,7 +63,7 @@ static struct timeval		this_read;
 
 static u64			bytes_written			=      0;
 
-static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
+static struct pollfd		*event_array;
 
 static int			nr_poll				=      0;
 static int			nr_cpu				=      0;
@@ -77,7 +80,7 @@ struct mmap_data {
 	unsigned int		prev;
 };
 
-static struct mmap_data		mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct mmap_data		*mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static unsigned long mmap_read_head(struct mmap_data *md)
 {
@@ -225,12 +228,13 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid)
+static void create_counter(int counter, int cpu)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
+	int thread_index;
 	int ret;
 	struct {
 		u64 count;
@@ -280,115 +284,124 @@ static void create_counter(int counter, int cpu, pid_t pid)
 		attr->enable_on_exec = 1;
 	}
 
+	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
-	fd[nr_cpu][counter] = sys_perf_event_open(attr, pid, cpu, group_fd, 0);
-
-	if (fd[nr_cpu][counter] < 0) {
-		int err = errno;
-
-		if (err == EPERM || err == EACCES)
-			die("Permission error - are you root?\n"
-			    "\t Consider tweaking /proc/sys/kernel/perf_event_paranoid.\n");
-		else if (err ==  ENODEV && profile_cpu != -1)
-			die("No such device - did you specify an out-of-range profile CPU?\n");
+		fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
+				all_tids[thread_index], cpu, group_fd, 0);
+
+		if (fd[nr_cpu][counter][thread_index] < 0) {
+			int err = errno;
+
+			if (err == EPERM || err == EACCES)
+				die("Permission error - are you root?\n"
+					"\t Consider tweaking"
+					" /proc/sys/kernel/perf_event_paranoid.\n");
+			else if (err ==  ENODEV && profile_cpu != -1) {
+				die("No such device - did you specify"
+					" an out-of-range profile CPU?\n");
+			}
 
-		/*
-		 * If it's cycles then fall back to hrtimer
-		 * based cpu-clock-tick sw counter, which
-		 * is always available even if no PMU support:
-		 */
-		if (attr->type == PERF_TYPE_HARDWARE
-			&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
-
-			if (verbose)
-				warning(" ... trying to fall back to cpu-clock-ticks\n");
-			attr->type = PERF_TYPE_SOFTWARE;
-			attr->config = PERF_COUNT_SW_CPU_CLOCK;
-			goto try_again;
-		}
-		printf("\n");
-		error("perfcounter syscall returned with %d (%s)\n",
-			fd[nr_cpu][counter], strerror(err));
+			/*
+			 * If it's cycles then fall back to hrtimer
+			 * based cpu-clock-tick sw counter, which
+			 * is always available even if no PMU support:
+			 */
+			if (attr->type == PERF_TYPE_HARDWARE
+					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+
+				if (verbose)
+					warning(" ... trying to fall back to cpu-clock-ticks\n");
+				attr->type = PERF_TYPE_SOFTWARE;
+				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				goto try_again;
+			}
+			printf("\n");
+			error("perfcounter syscall returned with %d (%s)\n",
+					fd[nr_cpu][counter][thread_index], strerror(err));
 
 #if defined(__i386__) || defined(__x86_64__)
-		if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
-			die("No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the \"lapic\" boot parameter to force-enable it.\n");
+			if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
+				die("No hardware sampling interrupt available."
+				    " No APIC? If so then you can boot the kernel"
+				    " with the \"lapic\" boot parameter to"
+				    " force-enable it.\n");
 #endif
 
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-		exit(-1);
-	}
+			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			exit(-1);
+		}
 
-	h_attr = get_header_attr(attr, counter);
-	if (h_attr == NULL)
-		die("nomem\n");
+		h_attr = get_header_attr(attr, counter);
+		if (h_attr == NULL)
+			die("nomem\n");
 
-	if (!file_new) {
-		if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
-			fprintf(stderr, "incompatible append\n");
-			exit(-1);
+		if (!file_new) {
+			if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
+				fprintf(stderr, "incompatible append\n");
+				exit(-1);
+			}
 		}
-	}
 
-	if (read(fd[nr_cpu][counter], &read_data, sizeof(read_data)) == -1) {
-		perror("Unable to read perf file descriptor\n");
-		exit(-1);
-	}
+		if (read(fd[nr_cpu][counter][thread_index], &read_data, sizeof(read_data)) == -1) {
+			perror("Unable to read perf file descriptor\n");
+			exit(-1);
+		}
 
-	if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
-		pr_warning("Not enough memory to add id\n");
-		exit(-1);
-	}
+		if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
+			pr_warning("Not enough memory to add id\n");
+			exit(-1);
+		}
 
-	assert(fd[nr_cpu][counter] >= 0);
-	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
+		assert(fd[nr_cpu][counter][thread_index] >= 0);
+		fcntl(fd[nr_cpu][counter][thread_index], F_SETFL, O_NONBLOCK);
 
-	/*
-	 * First counter acts as the group leader:
-	 */
-	if (group && group_fd == -1)
-		group_fd = fd[nr_cpu][counter];
-	if (multiplex && multiplex_fd == -1)
-		multiplex_fd = fd[nr_cpu][counter];
+		/*
+		 * First counter acts as the group leader:
+		 */
+		if (group && group_fd == -1)
+			group_fd = fd[nr_cpu][counter][thread_index];
+		if (multiplex && multiplex_fd == -1)
+			multiplex_fd = fd[nr_cpu][counter][thread_index];
 
-	if (multiplex && fd[nr_cpu][counter] != multiplex_fd) {
+		if (multiplex && fd[nr_cpu][counter][thread_index] != multiplex_fd) {
 
-		ret = ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
-		assert(ret != -1);
-	} else {
-		event_array[nr_poll].fd = fd[nr_cpu][counter];
-		event_array[nr_poll].events = POLLIN;
-		nr_poll++;
-
-		mmap_array[nr_cpu][counter].counter = counter;
-		mmap_array[nr_cpu][counter].prev = 0;
-		mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
-		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
-		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
-			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-			exit(-1);
+			ret = ioctl(fd[nr_cpu][counter][thread_index], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
+			assert(ret != -1);
+		} else {
+			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
+			event_array[nr_poll].events = POLLIN;
+			nr_poll++;
+
+			mmap_array[nr_cpu][counter][thread_index].counter = counter;
+			mmap_array[nr_cpu][counter][thread_index].prev = 0;
+			mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
+			mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
+			if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
+				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+				exit(-1);
+			}
 		}
-	}
 
-	if (filter != NULL) {
-		ret = ioctl(fd[nr_cpu][counter],
-			    PERF_EVENT_IOC_SET_FILTER, filter);
-		if (ret) {
-			error("failed to set filter with %d (%s)\n", errno,
-			      strerror(errno));
-			exit(-1);
+		if (filter != NULL) {
+			ret = ioctl(fd[nr_cpu][counter][thread_index],
+					PERF_EVENT_IOC_SET_FILTER, filter);
+			if (ret) {
+				error("failed to set filter with %d (%s)\n", errno,
+						strerror(errno));
+				exit(-1);
+			}
 		}
 	}
 }
 
-static void open_counters(int cpu, pid_t pid)
+static void open_counters(int cpu)
 {
 	int counter;
 
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu, pid);
+		create_counter(counter, cpu);
 
 	nr_cpu++;
 }
@@ -529,6 +542,9 @@ static int __cmd_record(int argc, const char **argv)
 			exit(-1);
 		}
 
+		if (!system_wide && target_tid == -1 && target_pid == -1)
+			all_tids[0] = child_pid;
+
 		close(child_ready_pipe[1]);
 		close(go_pipe[0]);
 		/*
@@ -541,17 +557,12 @@ static int __cmd_record(int argc, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	if (forks && target_pid == -1 && !system_wide)
-		pid = child_pid;
-	else
-		pid = target_pid;
-
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
-		open_counters(profile_cpu, pid);
+		open_counters(profile_cpu);
 	} else {
 		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(cpumap[i], pid);
+			open_counters(cpumap[i]);
 	}
 
 	if (file_new) {
@@ -576,7 +587,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!system_wide && profile_cpu == -1)
-		event__synthesize_thread(target_pid, process_synthesized_event,
+		event__synthesize_thread(target_tid, process_synthesized_event,
 					 session);
 	else
 		event__synthesize_threads(process_synthesized_event, session);
@@ -599,11 +610,16 @@ static int __cmd_record(int argc, const char **argv)
 
 	for (;;) {
 		int hits = samples;
+		int thread;
 
 		for (i = 0; i < nr_cpu; i++) {
 			for (counter = 0; counter < nr_counters; counter++) {
-				if (mmap_array[i][counter].base)
-					mmap_read(&mmap_array[i][counter]);
+				for (thread = 0;
+					thread < thread_num; thread++) {
+					if (mmap_array[i][counter][thread].base)
+						mmap_read(&mmap_array[i][counter][thread]);
+				}
+
 			}
 		}
 
@@ -616,8 +632,15 @@ static int __cmd_record(int argc, const char **argv)
 
 		if (done) {
 			for (i = 0; i < nr_cpu; i++) {
-				for (counter = 0; counter < nr_counters; counter++)
-					ioctl(fd[i][counter], PERF_EVENT_IOC_DISABLE);
+				for (counter = 0;
+					counter < nr_counters;
+					counter++) {
+					for (thread = 0;
+						thread < thread_num;
+						thread++)
+						ioctl(fd[i][counter][thread],
+							PERF_EVENT_IOC_DISABLE);
+				}
 			}
 		}
 	}
@@ -649,7 +672,9 @@ static const struct option options[] = {
 	OPT_CALLBACK(0, "filter", NULL, "filter",
 		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
-		    "record events on existing pid"),
+		    "record events on existing process id"),
+	OPT_INTEGER('t', "tid", &target_tid,
+		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
@@ -690,10 +715,12 @@ static const struct option options[] = {
 int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
+	int i,j;
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && !system_wide && profile_cpu == -1)
+	if (!argc && target_pid == -1 && target_tid == -1 &&
+		!system_wide && profile_cpu == -1)
 		usage_with_options(record_usage, options);
 
 	symbol__init();
@@ -704,6 +731,37 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
 	}
 
+	if (target_pid != -1) {
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0) {
+			fprintf(stderr, "Can't find all threads of pid %d\n",
+					target_pid);
+			usage_with_options(record_usage, options);
+		}
+	} else {
+		all_tids=malloc(sizeof(pid_t));
+		if (!all_tids)
+			return -ENOMEM;
+
+		all_tids[0] = target_tid;
+		thread_num = 1;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++) {
+			fd[i][j] = malloc(sizeof(int)*thread_num);
+			mmap_array[i][j] = malloc(
+				sizeof(struct mmap_data)*thread_num);
+			if (!fd[i][j] || !mmap_array[i][j])
+				return -ENOMEM;
+		}
+	}
+	event_array = malloc(
+		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+	if (!event_array)
+		return -ENOMEM;
+
 	/*
 	 * User specified count overrides default frequency.
 	 */
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5f41244..c92f90f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -46,6 +46,7 @@
 #include "util/debug.h"
 #include "util/header.h"
 #include "util/cpumap.h"
+#include "util/thread.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -74,10 +75,13 @@ static int			run_count			=  1;
 static int			inherit				=  1;
 static int			scale				=  1;
 static pid_t			target_pid			= -1;
+static pid_t			target_tid			= -1;
+static pid_t			*all_tids			=  NULL;
+static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static int			null_run			=  0;
 
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			event_scaled[MAX_COUNTERS];
 
@@ -140,9 +144,10 @@ struct stats			runtime_branches_stats;
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_event_open() syscall returned with %d (%s)\n"
 
-static void create_perf_stat_counter(int counter, int pid)
+static void create_perf_stat_counter(int counter)
 {
 	struct perf_event_attr *attr = attrs + counter;
+	int thread;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -152,10 +157,11 @@ static void create_perf_stat_counter(int counter, int pid)
 		unsigned int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpumap[cpu], -1, 0);
-			if (fd[cpu][counter] < 0 && verbose)
+			fd[cpu][counter][0] = sys_perf_event_open(attr,
+					-1, cpumap[cpu], -1, 0);
+			if (fd[cpu][counter][0] < 0 && verbose)
 				fprintf(stderr, ERR_PERF_OPEN, counter,
-					fd[cpu][counter], strerror(errno));
+					fd[cpu][counter][0], strerror(errno));
 		}
 	} else {
 		attr->inherit	     = inherit;
@@ -163,11 +169,14 @@ static void create_perf_stat_counter(int counter, int pid)
 			attr->disabled = 1;
 			attr->enable_on_exec = 1;
 		}
-
-		fd[0][counter] = sys_perf_event_open(attr, pid, -1, -1, 0);
-		if (fd[0][counter] < 0 && verbose)
-			fprintf(stderr, ERR_PERF_OPEN, counter,
-				fd[0][counter], strerror(errno));
+		for (thread = 0; thread < thread_num; thread++) {
+			fd[0][counter][thread] = sys_perf_event_open(attr,
+				all_tids[thread], -1, -1, 0);
+			if (fd[0][counter][thread] < 0 && verbose)
+				fprintf(stderr, ERR_PERF_OPEN, counter,
+					fd[0][counter][thread],
+					strerror(errno));
+		}
 	}
 }
 
@@ -192,25 +201,28 @@ static void read_counter(int counter)
 	unsigned int cpu;
 	size_t res, nv;
 	int scaled;
-	int i;
+	int i, thread;
 
 	count[0] = count[1] = count[2] = 0;
 
 	nv = scale ? 3 : 1;
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		if (fd[cpu][counter] < 0)
-			continue;
-
-		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
-		assert(res == nv * sizeof(u64));
-
-		close(fd[cpu][counter]);
-		fd[cpu][counter] = -1;
-
-		count[0] += single_count[0];
-		if (scale) {
-			count[1] += single_count[1];
-			count[2] += single_count[2];
+		for (thread = 0; thread < thread_num; thread++) {
+			if (fd[cpu][counter][thread] < 0)
+				continue;
+
+			res = read(fd[cpu][counter][thread],
+					single_count, nv * sizeof(u64));
+			assert(res == nv * sizeof(u64));
+
+			close(fd[cpu][counter][thread]);
+			fd[cpu][counter][thread] = -1;
+
+			count[0] += single_count[0];
+			if (scale) {
+				count[1] += single_count[1];
+				count[2] += single_count[2];
+			}
 		}
 	}
 
@@ -253,7 +265,6 @@ static int run_perf_stat(int argc __used, const char **argv)
 	unsigned long long t0, t1;
 	int status = 0;
 	int counter;
-	int pid;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
 	char buf;
@@ -299,6 +310,9 @@ static int run_perf_stat(int argc __used, const char **argv)
 			exit(-1);
 		}
 
+		if (target_tid == -1 && target_pid == -1 && !system_wide)
+			all_tids[0] = child_pid;
+
 		/*
 		 * Wait for the child to be ready to exec.
 		 */
@@ -309,12 +323,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	if (target_pid == -1)
-		pid = child_pid;
-	else
-		pid = target_pid;
 	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter, pid);
+		create_perf_stat_counter(counter);
 
 	/*
 	 * Enable counters and exec the command:
@@ -433,12 +443,14 @@ static void print_stat(int argc, const char **argv)
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, " Performance counter stats for ");
-	if(target_pid == -1) {
+	if(target_pid == -1 && target_tid == -1) {
 		fprintf(stderr, "\'%s", argv[0]);
 		for (i = 1; i < argc; i++)
 			fprintf(stderr, " %s", argv[i]);
-	}else
-		fprintf(stderr, "task pid \'%d", target_pid);
+	} else if (target_pid != -1)
+		fprintf(stderr, "process id \'%d", target_pid);
+	else
+		fprintf(stderr, "thread id \'%d", target_tid);
 
 	fprintf(stderr, "\'");
 	if (run_count > 1)
@@ -493,7 +505,9 @@ static const struct option options[] = {
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
-		    "stat events on existing pid"),
+		    "stat events on existing process id"),
+	OPT_INTEGER('t', "tid", &target_tid,
+		    "stat events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('c', "scale", &scale,
@@ -510,10 +524,11 @@ static const struct option options[] = {
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	int status;
+	int i,j;
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1)
+	if (!argc && target_pid == -1 && target_tid == -1)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
@@ -529,6 +544,31 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	else
 		nr_cpus = 1;
 
+	if (target_pid != -1) {
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0) {
+			fprintf(stderr, "Can't find all threads of pid %d\n",
+					target_pid);
+			usage_with_options(stat_usage, options);
+		}
+	} else {
+		all_tids=malloc(sizeof(pid_t));
+		if (!all_tids)
+			return -ENOMEM;
+
+		all_tids[0] = target_tid;
+		thread_num = 1;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++) {
+			fd[i][j] = malloc(sizeof(int)*thread_num);
+			if (!fd[i][j])
+				return -ENOMEM;
+		}
+	}
+
 	/*
 	 * We dont want to block the signals - that would cause
 	 * child tasks to inherit that and Ctrl-C would not work.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 887ebbf..5f3ac9f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -55,7 +55,7 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			system_wide			=      0;
 
@@ -65,6 +65,9 @@ static int			count_filter			=      5;
 static int			print_entries;
 
 static int			target_pid			=     -1;
+static int			target_tid			=     -1;
+static pid_t			*all_tids			=      NULL;
+static int			thread_num			=      0;
 static int			inherit				=      0;
 static int			profile_cpu			=     -1;
 static int			nr_cpus				=      0;
@@ -524,13 +527,15 @@ static void print_sym_table(void)
 
 	if (target_pid != -1)
 		printf(" (target_pid: %d", target_pid);
+	else if (target_tid != -1)
+		printf(" (target_tid: %d", target_tid);
 	else
 		printf(" (all");
 
 	if (profile_cpu != -1)
 		printf(", cpu: %d)\n", profile_cpu);
 	else {
-		if (target_pid != -1)
+		if (target_tid != -1)
 			printf(")\n");
 		else
 			printf(", %d CPUs)\n", nr_cpus);
@@ -1129,16 +1134,21 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 	md->prev = old;
 }
 
-static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
-static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct pollfd *event_array;
+static struct mmap_data *mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static void perf_session__mmap_read(struct perf_session *self)
 {
-	int i, counter;
+	int i, counter, thread_index;
 
 	for (i = 0; i < nr_cpus; i++) {
 		for (counter = 0; counter < nr_counters; counter++)
-			perf_session__mmap_read_counter(self, &mmap_array[i][counter]);
+			for (thread_index = 0;
+				thread_index < thread_num;
+				thread_index++) {
+				perf_session__mmap_read_counter(self,
+					&mmap_array[i][counter][thread_index]);
+			}
 	}
 }
 
@@ -1149,9 +1159,10 @@ static void start_counter(int i, int counter)
 {
 	struct perf_event_attr *attr;
 	int cpu;
+	int thread_index;
 
 	cpu = profile_cpu;
-	if (target_pid == -1 && profile_cpu == -1)
+	if (target_tid == -1 && profile_cpu == -1)
 		cpu = cpumap[i];
 
 	attr = attrs + counter;
@@ -1167,55 +1178,58 @@ static void start_counter(int i, int counter)
 	attr->inherit		= (cpu < 0) && inherit;
 	attr->mmap		= 1;
 
+	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
-	fd[i][counter] = sys_perf_event_open(attr, target_pid, cpu, group_fd, 0);
-
-	if (fd[i][counter] < 0) {
-		int err = errno;
+		fd[i][counter][thread_index] = sys_perf_event_open(attr,
+				all_tids[thread_index], cpu, group_fd, 0);
+
+		if (fd[i][counter][thread_index] < 0) {
+			int err = errno;
+
+			if (err == EPERM || err == EACCES)
+				die("No permission - are you root?\n");
+			/*
+			 * If it's cycles then fall back to hrtimer
+			 * based cpu-clock-tick sw counter, which
+			 * is always available even if no PMU support:
+			 */
+			if (attr->type == PERF_TYPE_HARDWARE
+					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+
+				if (verbose)
+					warning(" ... trying to fall back to cpu-clock-ticks\n");
+
+				attr->type = PERF_TYPE_SOFTWARE;
+				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				goto try_again;
+			}
+			printf("\n");
+			error("perfcounter syscall returned with %d (%s)\n",
+					fd[i][counter][thread_index], strerror(err));
+			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			exit(-1);
+		}
+		assert(fd[i][counter][thread_index] >= 0);
+		fcntl(fd[i][counter][thread_index], F_SETFL, O_NONBLOCK);
 
-		if (err == EPERM || err == EACCES)
-			die("No permission - are you root?\n");
 		/*
-		 * If it's cycles then fall back to hrtimer
-		 * based cpu-clock-tick sw counter, which
-		 * is always available even if no PMU support:
+		 * First counter acts as the group leader:
 		 */
-		if (attr->type == PERF_TYPE_HARDWARE
-			&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
-
-			if (verbose)
-				warning(" ... trying to fall back to cpu-clock-ticks\n");
-
-			attr->type = PERF_TYPE_SOFTWARE;
-			attr->config = PERF_COUNT_SW_CPU_CLOCK;
-			goto try_again;
-		}
-		printf("\n");
-		error("perfcounter syscall returned with %d (%s)\n",
-			fd[i][counter], strerror(err));
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-		exit(-1);
+		if (group && group_fd == -1)
+			group_fd = fd[i][counter][thread_index];
+
+		event_array[nr_poll].fd = fd[i][counter][thread_index];
+		event_array[nr_poll].events = POLLIN;
+		nr_poll++;
+
+		mmap_array[i][counter][thread_index].counter = counter;
+		mmap_array[i][counter][thread_index].prev = 0;
+		mmap_array[i][counter][thread_index].mask = mmap_pages*page_size - 1;
+		mmap_array[i][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ, MAP_SHARED, fd[i][counter][thread_index], 0);
+		if (mmap_array[i][counter][thread_index].base == MAP_FAILED)
+			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
-	assert(fd[i][counter] >= 0);
-	fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
-
-	/*
-	 * First counter acts as the group leader:
-	 */
-	if (group && group_fd == -1)
-		group_fd = fd[i][counter];
-
-	event_array[nr_poll].fd = fd[i][counter];
-	event_array[nr_poll].events = POLLIN;
-	nr_poll++;
-
-	mmap_array[i][counter].counter = counter;
-	mmap_array[i][counter].prev = 0;
-	mmap_array[i][counter].mask = mmap_pages*page_size - 1;
-	mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ, MAP_SHARED, fd[i][counter], 0);
-	if (mmap_array[i][counter].base == MAP_FAILED)
-		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 }
 
 static int __cmd_top(void)
@@ -1231,8 +1245,8 @@ static int __cmd_top(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (target_pid != -1)
-		event__synthesize_thread(target_pid, event__process, session);
+	if (target_tid != -1)
+		event__synthesize_thread(target_tid, event__process, session);
 	else
 		event__synthesize_threads(event__process, session);
 
@@ -1243,7 +1257,7 @@ static int __cmd_top(void)
 	}
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(event_array, nr_poll, 100);
+	poll(&event_array[0], nr_poll, 100);
 
 	perf_session__mmap_read(session);
 
@@ -1286,7 +1300,9 @@ static const struct option options[] = {
 	OPT_INTEGER('c', "count", &default_interval,
 		    "event period to sample"),
 	OPT_INTEGER('p', "pid", &target_pid,
-		    "profile events on existing pid"),
+		    "profile events on existing process id"),
+	OPT_INTEGER('t', "tid", &target_tid,
+		    "profile events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_INTEGER('C', "CPU", &profile_cpu,
@@ -1327,6 +1343,7 @@ static const struct option options[] = {
 int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
+	int i,j;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
@@ -1334,8 +1351,39 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(top_usage, options);
 
+	if (target_pid != -1) {
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0) {
+			fprintf(stderr, "Can't find all threads of pid %d\n",
+				target_pid);
+			usage_with_options(top_usage, options);
+		}
+	} else {
+		all_tids=malloc(sizeof(pid_t));
+		if (!all_tids)
+			return -ENOMEM;
+
+		all_tids[0] = target_tid;
+		thread_num = 1;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++) {
+			fd[i][j] = malloc(sizeof(int)*thread_num);
+			mmap_array[i][j] = malloc(
+				sizeof(struct mmap_data)*thread_num);
+			if (!fd[i][j] || !mmap_array[i][j])
+				return -ENOMEM;
+		}
+	}
+	event_array = malloc(
+		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+	if (!event_array)
+		return -ENOMEM;
+
 	/* CPU and PID are mutually exclusive */
-	if (target_pid != -1 && profile_cpu != -1) {
+	if (target_tid > 0 && profile_cpu != -1) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
 		profile_cpu = -1;
@@ -1376,7 +1424,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		attrs[counter].sample_period = default_interval;
 	}
 
-	if (target_pid != -1 || profile_cpu != -1)
+	if (target_tid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
 	else
 		nr_cpus = read_cpu_map();
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fa96831..ea65062 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,37 @@
 #include "util.h"
 #include "debug.h"
 
+int find_all_tid(int pid, pid_t ** all_tid)
+{
+	char name[256];
+	int items;
+	struct dirent **namelist = NULL;
+	int ret = 0;
+	int i;
+
+	sprintf(name, "/proc/%d/task", pid);
+	items = scandir(name, &namelist, NULL, NULL);
+	if (items <= 0)
+                return -ENOENT;
+	*all_tid = malloc(sizeof(pid_t) * items);
+	if (!*all_tid) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+
+	for (i = 0; i < items; i++)
+		(*all_tid)[i] = atoi(namelist[i]->d_name);
+
+	ret = items;
+
+failure:
+	for (i=0; i<items; i++)
+		free(namelist[i]);
+	free(namelist);
+
+	return ret;
+}
+
 void map_groups__init(struct map_groups *self)
 {
 	int i;
@@ -348,3 +379,4 @@ struct symbol *map_groups__find_symbol(struct map_groups *self,
 
 	return NULL;
 }
+
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index dcf7030..a81426a 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -23,6 +23,7 @@ struct thread {
 	int			comm_len;
 };
 
+int find_all_tid(int pid, pid_t ** all_tid);
 void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
-- 
1.6.2.5

