Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1KDL42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:56:28 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36863 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab1KDL41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:56:27 -0400
Date: Fri, 4 Nov 2011 17:26:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Venki Pallipadi <venki@google.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        kamalesh@linux.vnet.ibm.com
Subject: [PATCH] perf bench sched cpu-matrix benchmark
Message-ID: <20111104115620.GA25704@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During the discussion of the nohz load balancer fix 
(https://lkml.org/lkml/2011/9/27/197), Ingo Molnar suggested
to replace the simple while1 loop, used for publishing the 
test results with cpu-matrix test. This patch adds cpu-matrix 
benchmark under perf bench.

TODO:
	- Provide option to run main thread at real-time priority.
	- Provide option for changing scheduling priority/policy
	  of worker threads.


perf bench: Add sched cpu-matrix benchmark

perf bench sched cpu-matrix benchmark is a matrix multiplication
workload, which can be replaced with the traditional while1 
cpu hog.

Example of usage:

% perf bench sched cpu-matrix 
# Running sched/cpu-matrix benchmark...

Multiplication of [20] x [20] matrix, using [1] threads
 Total time: 0.000170 [sec]

% perf bench sched cpu-matrix -s1k -t3 
# Running sched/cpu-matrix benchmark...
elapsed time = 0.100066 sec, progress = 27270868
elapsed time = 0.100079 sec, progress = 27299841
elapsed time = 0.100071 sec, progress = 27253513
elapsed time = 0.100073 sec, progress = 27272693
elapsed time = 0.100090 sec, progress = 10208415

Multiplication of [1024] x [1024] matrix, using [3] threads
 Total time: 0.500495 [sec]

% perf bench --format=simple sched cpu-matrix -s1k -t3 
 Total time: 0.454764 [sec]

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> 
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

--
 tools/perf/Makefile           |    1 +
 tools/perf/bench/bench.h      |    2 +
 tools/perf/bench/cpu-matrix.c |  410 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c    |    3 +
 4 files changed, 416 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b98e307..02bd562 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -363,6 +363,7 @@ ifeq ($(RAW_ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
+BUILTIN_OBJS += $(OUTPUT)bench/cpu-matrix.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..174465a 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -4,6 +4,8 @@
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
+extern int bench_cpu_matrix(int argc, const char **argv,
+				const char *prefix __used);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/cpu-matrix.c b/tools/perf/bench/cpu-matrix.c
new file mode 100644
index 0000000..95bbdfa
--- /dev/null
+++ b/tools/perf/bench/cpu-matrix.c
@@ -0,0 +1,410 @@
+/*
+ * cpu matrix multiplication benchmark
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) IBM Corporation, 2011
+ *
+ * Authors: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
+ *	    Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../builtin.h"
+#include "bench.h"
+
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <math.h>
+
+#define DEFAULT_ITERATIONS 1
+#define DEFAULT_MATRIX_SIZE 20
+#define DEFAULT_NUM_THREADS 1
+#define DEFAULT_SLEEP_MSEC 0
+
+static int iterations = DEFAULT_ITERATIONS;
+static const char *mat_size_str = "20";
+static unsigned int mat_size = DEFAULT_MATRIX_SIZE;
+static int num_threads = DEFAULT_NUM_THREADS;
+
+static int ready_count;
+static int sleep_msec = DEFAULT_SLEEP_MSEC;
+static pthread_mutex_t ready_lock = PTHREAD_MUTEX_INITIALIZER;
+
+static inline void barf(const char *str)
+{
+	if (errno)
+		perror(str);
+	else
+		printf("%s\n", str);
+
+	exit(1);
+}
+
+static inline void *galloc(size_t size)
+{
+	void *ptr = malloc(size);
+
+	if (!ptr)
+		barf("malloc ");
+
+	return ptr;
+}
+
+
+static inline void populate_matrix(unsigned int *matrix, int size)
+{
+	unsigned int i;
+
+	for (i = 0; i < ((u64)size * (u64)size); i++)
+		*(matrix + i) = random() % 100;
+}
+
+static const struct option options[] = {
+	OPT_STRING('s', "matrix size", &mat_size_str, "20",
+			"Specify the size of the square matrix. "
+			"Available unit: K, M (upper and lower)"),
+	OPT_INTEGER('i', "iterations", &iterations,
+			"Specify number of iterations"),
+	OPT_INTEGER('t', "num_threads", &num_threads,
+			"Specify number of threads"),
+	OPT_INTEGER('p', "sleep_msec", &sleep_msec,
+			"Progress to be printed every P millseconds."),
+	OPT_END()
+};
+
+static const char *const bench_cpu_matrix_usage[] = {
+	"perf bench sched cpu_matrix <options>",
+	NULL
+};
+
+struct thread_work {
+	unsigned int *a, *b, *c;	/* Matrix A, B, C */
+	unsigned int progress;		/* Multiplication count */
+	unsigned int prev_progress;	/* Used for calculating delta */
+	int size;			/* No. of rows handled by a thread */
+	int start_row;			/* Row to start multiplication */
+	int done;			/* Indication of the thread job done */
+	int num_threads;		/* Number of threads */
+	int iter_count;			/* Number of iterations */
+};
+
+/*
+ * Returns the delta/difference between previous progress
+ * and current progress, where progress is summation of
+ * multiplications done by each thread.
+ */
+static u64 thread_progress(struct thread_work *work, int thread_count)
+{
+	int i;
+	u64 total_progress = 0;
+
+	for (i = 0; i < thread_count; i++) {
+		unsigned int progress, prev_progress, delta;
+
+		progress = work[i].progress;
+		prev_progress = work[i].prev_progress;
+		delta = progress - prev_progress;
+
+		work[i].prev_progress = progress;
+
+		total_progress += delta;
+	}
+
+	return total_progress;
+}
+
+/*
+ * Returns 1 if all the threads are done with multiplication
+ * else return 0.
+ */
+static inline int all_threads_done(struct thread_work *work, int thread_count)
+{
+	int i, done = 0;
+
+	for (i = 0; i < thread_count; ++i) {
+		if (work[i].done)
+			done++;
+	}
+
+	if (done >= thread_count)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Prints the progress of multipilcations done by all threads
+ * every sleep_msec
+ */
+static void print_progress(struct thread_work *work, int thread_count)
+{
+	struct timeval start, end, delta;
+	u64 curr_progress = 0;
+
+	if (!sleep_msec)
+		return;
+
+	delta.tv_sec = 0;
+	delta.tv_usec = 0;
+
+	gettimeofday(&start, NULL);
+
+	while (!all_threads_done(work, thread_count)) {
+		usleep(sleep_msec);
+		gettimeofday(&end, NULL);
+		curr_progress = thread_progress(work, thread_count);
+		timersub(&end, &start, &delta);
+		start = end;
+
+		printf("elapsed time = %lu.%06lu sec, progress = %lu\n",
+				delta.tv_sec, delta.tv_usec, curr_progress);
+		fflush(stdout);
+	}
+
+}
+
+/*
+ * Multiples single row X no. of columns.
+ */
+static void row_col_multiply(unsigned int *a, unsigned int *b, unsigned int *c,
+				int row_num, int col_num, int size,
+				struct thread_work *work)
+{
+	int i, j, k, sum = 0;
+
+	for (i = 0; i < size; ++i) {
+		j = *(a + (row_num * size) + i);
+		k = *(b + (i * size) + col_num);
+		sum += (j * k);
+		work->progress++;
+	}
+
+	*(c + (row_num * size) + col_num) = sum;
+}
+
+static void *thread_fn(void *arg)
+{
+	struct thread_work *work = arg;
+	int row, col, i, j, k;
+	unsigned int *a = work->a, *b = work->b, *c = work->c;
+
+	pthread_mutex_lock(&ready_lock);
+	ready_count++;
+	pthread_mutex_unlock(&ready_lock);
+
+	/*
+	 * Wait for all the threads to start up
+	 */
+	while (ready_count < work->num_threads)
+		cpu_relax();
+
+	/*
+	 * Iteration loop
+	 */
+	for (k = 0; k < work->iter_count; k++) {
+		row = work->start_row;
+
+		/*
+		 * Rows the thread is suppose to work on
+		 */
+		for (i = 0; i < work->size; i++, row++) {
+			/*
+			 * Reset the column to first column
+			 */
+			col = 0;
+
+			for (j = 0; j < work->size; j++, col++)
+				row_col_multiply(a, b, c, row, col,
+						 work->size, work);
+		}
+	}
+
+	work->done = 1;
+
+	return NULL;
+}
+
+/*
+ * Core function to create threads and assign work to them.
+ */
+static void matrix_multiply(unsigned int *a, unsigned int *b, unsigned int *c,
+				int matrix_size, int iter_count,
+				int thread_count)
+{
+	int i;
+	unsigned int per_thread_work, rem, row_idx = 0;
+	struct thread_work *work_arr;
+	pthread_t *thread_ids;
+
+	assert(thread_count > 0);
+
+	work_arr = galloc(thread_count * sizeof(struct thread_work));
+	thread_ids = galloc(thread_count * sizeof(pthread_t));
+
+	per_thread_work = matrix_size / thread_count;
+	rem = matrix_size;
+
+	for (i = 0; i < thread_count; ++i) {
+		int num_rows, rc;
+
+		/*
+		 * If the thread is the last thread, assign it all the
+		 * remaining rows
+		 */
+		if (i == (thread_count - 1))
+			num_rows = rem;
+		else
+			num_rows = (rem > per_thread_work) ?
+						 per_thread_work : rem;
+
+		rem -= num_rows;
+		work_arr[i].a = a;
+		work_arr[i].b = b;
+		work_arr[i].c = c;
+		work_arr[i].iter_count = iter_count;
+		work_arr[i].size = num_rows;
+		work_arr[i].start_row = row_idx;
+		work_arr[i].progress = 0;
+		work_arr[i].prev_progress = 0;
+		work_arr[i].done = 0;
+		work_arr[i].num_threads = thread_count;
+
+		row_idx += num_rows;
+
+		rc = pthread_create(&thread_ids[i], NULL, thread_fn,
+							 &work_arr[i]);
+		if (rc != 0)
+			barf("pthread_create ");
+	}
+
+	assert(!rem);
+	assert(row_idx == mat_size);
+
+	print_progress(work_arr, thread_count);
+
+	for (i = 0; i < thread_count; ++i)
+		pthread_join(thread_ids[i], NULL);
+
+	free(work_arr);
+	free(thread_ids);
+}
+
+#define K 1024LL
+
+static int parse_mat_size(const char *str)
+{
+	unsigned int i;
+	int unit = 1;
+	s64 length = -1;
+
+	if (!isdigit(str[0]))
+		return -1;
+
+	for (i = 1; i < strlen(str); i++) {
+		switch (str[i]) {
+		case 'k':
+		case 'K':
+			unit = (unit == 1 ? K : -1);
+			break;
+		case 'm':
+		case 'M':
+			unit = (unit == 1 ? (K * K) : -1);
+			break;
+		default:
+			if (!isdigit(str[i]))
+				goto out_err;
+			break;
+		}
+	}
+
+	if (unit > 0)
+		length = atoll(str) * unit;
+
+	if (length > INT_MAX)
+		length = -1;
+
+out_err:
+	return (int)length;
+}
+
+
+int bench_cpu_matrix(int argc, const char **argv,
+			const char *prefix __used)
+{
+
+	unsigned int *mat_a, *mat_b, *mat_c;
+	struct timeval start, stop, diff;
+	size_t alloc_size;
+
+	errno = 0;
+
+	parse_options(argc, argv, options, bench_cpu_matrix_usage, 0);
+	mat_size = parse_mat_size(mat_size_str);
+	if ((int)mat_size <= 0)
+		barf("Invalid size of matrix ");
+
+	if (iterations <= 0)
+		barf("Invalid loop(s) of iterations ");
+
+	if (num_threads <= 0)
+		barf("Invalid number of threads ");
+
+	alloc_size = (u64)mat_size * (u64)mat_size * sizeof(unsigned int);
+
+	mat_a = galloc(alloc_size);
+	mat_b = galloc(alloc_size);
+	mat_c = galloc(alloc_size);
+
+	sleep_msec *= 1000;
+
+	populate_matrix(mat_a, mat_size);
+	populate_matrix(mat_b, mat_size);
+
+	gettimeofday(&start, NULL);
+
+	matrix_multiply(mat_a, mat_b, mat_c, mat_size, iterations, num_threads);
+
+	gettimeofday(&stop, NULL);
+	timersub(&stop, &start, &diff);
+
+	free(mat_a);
+	free(mat_b);
+	free(mat_c);
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf("\nMultiplication of [%d] x [%d] matrix,"
+			" using [%d] threads\n",
+				 mat_size, mat_size, num_threads);
+		printf(" %s: %lu.%06lu [sec]\n", "Total time",
+				diff.tv_sec, diff.tv_usec);
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf(" %s: %lu.%06lu [sec]\n", "Total time",
+				diff.tv_sec, diff.tv_usec);
+		break;
+	default:
+		barf("Unknown benchmark format");
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..df84428 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -42,6 +42,9 @@ static struct bench_suite sched_suites[] = {
 	{ "pipe",
 	  "Flood of communication over pipe() between two processes",
 	  bench_sched_pipe      },
+	{ "cpu-matrix",
+	  "Benchmark to run cpu matrix multiplication",
+	  bench_cpu_matrix      },
 	suite_all,
 	{ NULL,
 	  NULL,
