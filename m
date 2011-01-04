Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1ADIYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:24:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:59134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1ADIYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:24:19 -0500
Date: Tue, 4 Jan 2011 08:23:31 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Steal the counter reading routines from stat
Message-ID: <tip-c52b12ed2511e6c031a0295fd903ea72b93701fb@git.kernel.org>
Git-Commit-ID: c52b12ed2511e6c031a0295fd903ea72b93701fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:23:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c52b12ed2511e6c031a0295fd903ea72b93701fb
Gitweb:     http://git.kernel.org/tip/c52b12ed2511e6c031a0295fd903ea72b93701fb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 3 Jan 2011 17:45:52 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 Jan 2011 00:22:55 -0200

perf evsel: Steal the counter reading routines from stat

Making them hopefully generic enough to be used in 'perf test',
well see.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |  121 +++++++++++----------------------------------
 tools/perf/util/evsel.c   |   88 ++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h   |   79 +++++++++++++++++++++++++++++
 3 files changed, 196 insertions(+), 92 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 589ba3a..a8b00b4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -93,12 +93,6 @@ static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 
-struct cpu_counts {
-	u64 val;
-	u64 ena;
-	u64 run;
-};
-
 static volatile int done = 0;
 
 struct stats
@@ -108,15 +102,11 @@ struct stats
 
 struct perf_stat {
 	struct stats	  res_stats[3];
-	int		  scaled;
-	struct cpu_counts cpu_counts[];
 };
 
-static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel, int ncpus)
+static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
-	size_t priv_size = (sizeof(struct perf_stat) +
-			    (ncpus * sizeof(struct cpu_counts)));
-	evsel->priv = zalloc(priv_size);
+	evsel->priv = zalloc(sizeof(struct perf_stat));
 	return evsel->priv == NULL ? -ENOMEM : 0;
 }
 
@@ -238,52 +228,14 @@ static inline int nsec_counter(struct perf_evsel *evsel)
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
-static void read_counter_aggr(struct perf_evsel *counter)
+static int read_counter_aggr(struct perf_evsel *counter)
 {
 	struct perf_stat *ps = counter->priv;
-	u64 count[3], single_count[3];
-	int cpu;
-	size_t res, nv;
-	int scaled;
-	int i, thread;
-
-	count[0] = count[1] = count[2] = 0;
-
-	nv = scale ? 3 : 1;
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		for (thread = 0; thread < thread_num; thread++) {
-			if (FD(counter, cpu, thread) < 0)
-				continue;
-
-			res = read(FD(counter, cpu, thread),
-					single_count, nv * sizeof(u64));
-			assert(res == nv * sizeof(u64));
-
-			close(FD(counter, cpu, thread));
-			FD(counter, cpu, thread) = -1;
-
-			count[0] += single_count[0];
-			if (scale) {
-				count[1] += single_count[1];
-				count[2] += single_count[2];
-			}
-		}
-	}
-
-	scaled = 0;
-	if (scale) {
-		if (count[2] == 0) {
-			ps->scaled = -1;
-			count[0] = 0;
-			return;
-		}
+	u64 *count = counter->counts->aggr.values;
+	int i;
 
-		if (count[2] < count[1]) {
-			ps->scaled = 1;
-			count[0] = (unsigned long long)
-				((double)count[0] * count[1] / count[2] + 0.5);
-		}
-	}
+	if (__perf_evsel__read(counter, nr_cpus, thread_num, scale) < 0)
+		return -1;
 
 	for (i = 0; i < 3; i++)
 		update_stats(&ps->res_stats[i], count[i]);
@@ -302,46 +254,24 @@ static void read_counter_aggr(struct perf_evsel *counter)
 		update_stats(&runtime_cycles_stats[0], count[0]);
 	if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 		update_stats(&runtime_branches_stats[0], count[0]);
+
+	return 0;
 }
 
 /*
  * Read out the results of a single counter:
  * do not aggregate counts across CPUs in system-wide mode
  */
-static void read_counter(struct perf_evsel *counter)
+static int read_counter(struct perf_evsel *counter)
 {
-	struct cpu_counts *cpu_counts = counter->priv;
-	u64 count[3];
+	u64 *count;
 	int cpu;
-	size_t res, nv;
-
-	count[0] = count[1] = count[2] = 0;
-
-	nv = scale ? 3 : 1;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
+			return -1;
 
-		if (FD(counter, cpu, 0) < 0)
-			continue;
-
-		res = read(FD(counter, cpu, 0), count, nv * sizeof(u64));
-
-		assert(res == nv * sizeof(u64));
-
-		close(FD(counter, cpu, 0));
-		FD(counter, cpu, 0) = -1;
-
-		if (scale) {
-			if (count[2] == 0) {
-				count[0] = 0;
-			} else if (count[2] < count[1]) {
-				count[0] = (unsigned long long)
-				((double)count[0] * count[1] / count[2] + 0.5);
-			}
-		}
-		cpu_counts[cpu].val = count[0]; /* scaled count */
-		cpu_counts[cpu].ena = count[1];
-		cpu_counts[cpu].run = count[2];
+		count = counter->counts->cpu[cpu].values;
 
 		if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
 			update_stats(&runtime_nsecs_stats[cpu], count[0]);
@@ -350,6 +280,8 @@ static void read_counter(struct perf_evsel *counter)
 		if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 			update_stats(&runtime_branches_stats[cpu], count[0]);
 	}
+
+	return 0;
 }
 
 static int run_perf_stat(int argc __used, const char **argv)
@@ -449,12 +381,17 @@ static int run_perf_stat(int argc __used, const char **argv)
 	update_stats(&walltime_nsecs_stats, t1 - t0);
 
 	if (no_aggr) {
-		list_for_each_entry(counter, &evsel_list, node)
+		list_for_each_entry(counter, &evsel_list, node) {
 			read_counter(counter);
+			perf_evsel__close_fd(counter, nr_cpus, 1);
+		}
 	} else {
-		list_for_each_entry(counter, &evsel_list, node)
+		list_for_each_entry(counter, &evsel_list, node) {
 			read_counter_aggr(counter);
+			perf_evsel__close_fd(counter, nr_cpus, thread_num);
+		}
 	}
+
 	return WEXITSTATUS(status);
 }
 
@@ -550,7 +487,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 {
 	struct perf_stat *ps = counter->priv;
 	double avg = avg_stats(&ps->res_stats[0]);
-	int scaled = ps->scaled;
+	int scaled = counter->counts->scaled;
 
 	if (scaled == -1) {
 		fprintf(stderr, "%*s%s%-24s\n",
@@ -590,14 +527,13 @@ static void print_counter_aggr(struct perf_evsel *counter)
  */
 static void print_counter(struct perf_evsel *counter)
 {
-	struct perf_stat *ps = counter->priv;
 	u64 ena, run, val;
 	int cpu;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		val = ps->cpu_counts[cpu].val;
-		ena = ps->cpu_counts[cpu].ena;
-		run = ps->cpu_counts[cpu].run;
+		val = counter->counts->cpu[cpu].val;
+		ena = counter->counts->cpu[cpu].ena;
+		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
 			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
 				csv_output ? 0 : -4,
@@ -818,7 +754,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	}
 
 	list_for_each_entry(pos, &evsel_list, node) {
-		if (perf_evsel__alloc_stat_priv(pos, nr_cpus) < 0 ||
+		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
+		    perf_evsel__alloc_counts(pos, nr_cpus) < 0 ||
 		    perf_evsel__alloc_fd(pos, nr_cpus, thread_num) < 0)
 			goto out_free_fd;
 	}
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6539ec9..3f5de51 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1,6 +1,8 @@
 #include "evsel.h"
 #include "util.h"
 
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+
 struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
@@ -21,15 +23,101 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
+int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
+{
+	evsel->counts = zalloc((sizeof(*evsel->counts) +
+				(ncpus * sizeof(struct perf_counts_values))));
+	return evsel->counts != NULL ? 0 : -ENOMEM;
+}
+
 void perf_evsel__free_fd(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->fd);
 	evsel->fd = NULL;
 }
 
+void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	int cpu, thread;
+
+	for (cpu = 0; cpu < ncpus; cpu++)
+		for (thread = 0; thread < nthreads; ++thread) {
+			close(FD(evsel, cpu, thread));
+			FD(evsel, cpu, thread) = -1;
+		}
+}
+
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
 	free(evsel);
 }
+
+int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
+			      int cpu, int thread, bool scale)
+{
+	struct perf_counts_values count;
+	size_t nv = scale ? 3 : 1;
+
+	if (FD(evsel, cpu, thread) < 0)
+		return -EINVAL;
+
+	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
+		return -errno;
+
+	if (scale) {
+		if (count.run == 0)
+			count.val = 0;
+		else if (count.run < count.ena)
+			count.val = (u64)((double)count.val * count.ena / count.run + 0.5);
+	} else
+		count.ena = count.run = 0;
+
+	evsel->counts->cpu[cpu] = count;
+	return 0;
+}
+
+int __perf_evsel__read(struct perf_evsel *evsel,
+		       int ncpus, int nthreads, bool scale)
+{
+	size_t nv = scale ? 3 : 1;
+	int cpu, thread;
+	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
+
+	aggr->val = 0;
+
+	for (cpu = 0; cpu < ncpus; cpu++) {
+		for (thread = 0; thread < nthreads; thread++) {
+			if (FD(evsel, cpu, thread) < 0)
+				continue;
+
+			if (readn(FD(evsel, cpu, thread),
+				  &count, nv * sizeof(u64)) < 0)
+				return -errno;
+
+			aggr->val += count.val;
+			if (scale) {
+				aggr->ena += count.ena;
+				aggr->run += count.run;
+			}
+		}
+	}
+
+	evsel->counts->scaled = 0;
+	if (scale) {
+		if (aggr->run == 0) {
+			evsel->counts->scaled = -1;
+			aggr->val = 0;
+			return 0;
+		}
+
+		if (aggr->run < aggr->ena) {
+			evsel->counts->scaled = 1;
+			aggr->val = (u64)((double)aggr->val * aggr->ena / aggr->run + 0.5);
+		}
+	} else
+		aggr->ena = aggr->run = 0;
+
+	return 0;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8a5cfb6..8b48ef1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -2,15 +2,34 @@
 #define __PERF_EVSEL_H 1
 
 #include <linux/list.h>
+#include <stdbool.h>
 #include <linux/perf_event.h>
 #include "types.h"
 #include "xyarray.h"
+ 
+struct perf_counts_values {
+	union {
+		struct {
+			u64 val;
+			u64 ena;
+			u64 run;
+		};
+		u64 values[3];
+	};
+};
+
+struct perf_counts {
+	s8		   	  scaled;
+	struct perf_counts_values aggr;
+	struct perf_counts_values cpu[];
+};
 
 struct perf_evsel {
 	struct list_head	node;
 	struct perf_event_attr	attr;
 	char			*filter;
 	struct xyarray		*fd;
+	struct perf_counts	*counts;
 	int			idx;
 	void			*priv;
 };
@@ -19,10 +38,70 @@ struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
+void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
 	 evsel->attr.config == PERF_COUNT_##c)
 
+int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
+			      int cpu, int thread, bool scale);
+
+/**
+ * perf_evsel__read_on_cpu - Read out the results on a CPU and thread
+ *
+ * @evsel - event selector to read value
+ * @cpu - CPU of interest
+ * @thread - thread of interest
+ */
+static inline int perf_evsel__read_on_cpu(struct perf_evsel *evsel,
+					  int cpu, int thread)
+{
+	return __perf_evsel__read_on_cpu(evsel, cpu, thread, false);
+}
+
+/**
+ * perf_evsel__read_on_cpu_scaled - Read out the results on a CPU and thread, scaled
+ *
+ * @evsel - event selector to read value
+ * @cpu - CPU of interest
+ * @thread - thread of interest
+ */
+static inline int perf_evsel__read_on_cpu_scaled(struct perf_evsel *evsel,
+						 int cpu, int thread)
+{
+	return __perf_evsel__read_on_cpu(evsel, cpu, thread, true);
+}
+
+int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
+		       bool scale);
+
+/**
+ * perf_evsel__read - Read the aggregate results on all CPUs
+ *
+ * @evsel - event selector to read value
+ * @ncpus - Number of cpus affected, from zero
+ * @nthreads - Number of threads affected, from zero
+ */
+static inline int perf_evsel__read(struct perf_evsel *evsel,
+				    int ncpus, int nthreads)
+{
+	return __perf_evsel__read(evsel, ncpus, nthreads, false);
+}
+
+/**
+ * perf_evsel__read_scaled - Read the aggregate results on all CPUs, scaled
+ *
+ * @evsel - event selector to read value
+ * @ncpus - Number of cpus affected, from zero
+ * @nthreads - Number of threads affected, from zero
+ */
+static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
+					  int ncpus, int nthreads)
+{
+	return __perf_evsel__read(evsel, ncpus, nthreads, true);
+}
+
 #endif /* __PERF_EVSEL_H */
