Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2IKX4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:56:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:42275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2IKXxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/18] perf sched: Use perf_tool as ancestor
Date: Tue, 11 Sep 2012 20:53:07 -0300
Message-Id: <1347407590-30960-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can remove all the globals.

Before:

   text	   data	    bss	    dec	    hex	filename
1586833	 110368	1438600	3135801	 2fd939	/tmp/oldperf

After:

   text	   data	    bss	    dec	    hex	filename
1629329	  93568	 848328	2571225	 273bd9	/root/bin/perf

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-oph40vikij0crjz4eyapneov@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 1136 ++++++++++++++++++++++----------------------
 1 file changed, 562 insertions(+), 574 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index af11b1a..79f88fa 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -23,26 +23,12 @@
 #include <pthread.h>
 #include <math.h>
 
-static const char		*input_name;
-
-static char			default_sort_order[] = "avg, max, switch, runtime";
-static const char		*sort_order = default_sort_order;
-
-static int			profile_cpu = -1;
-
 #define PR_SET_NAME		15               /* Set process name */
 #define MAX_CPUS		4096
-
-static u64			run_measurement_overhead;
-static u64			sleep_measurement_overhead;
-
 #define COMM_LEN		20
 #define SYM_LEN			129
-
 #define MAX_PID			65536
 
-static unsigned long		nr_tasks;
-
 struct sched_atom;
 
 struct task_desc {
@@ -80,44 +66,6 @@ struct sched_atom {
 	struct task_desc	*wakee;
 };
 
-static struct task_desc		*pid_to_task[MAX_PID];
-
-static struct task_desc		**tasks;
-
-static pthread_mutex_t		start_work_mutex = PTHREAD_MUTEX_INITIALIZER;
-static u64			start_time;
-
-static pthread_mutex_t		work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER;
-
-static unsigned long		nr_run_events;
-static unsigned long		nr_sleep_events;
-static unsigned long		nr_wakeup_events;
-
-static unsigned long		nr_sleep_corrections;
-static unsigned long		nr_run_events_optimized;
-
-static unsigned long		targetless_wakeups;
-static unsigned long		multitarget_wakeups;
-
-static u64			cpu_usage;
-static u64			runavg_cpu_usage;
-static u64			parent_cpu_usage;
-static u64			runavg_parent_cpu_usage;
-
-static unsigned long		nr_runs;
-static u64			sum_runtime;
-static u64			sum_fluct;
-static u64			run_avg;
-
-static unsigned int		replay_repeat = 10;
-static unsigned long		nr_timestamps;
-static unsigned long		nr_unordered_timestamps;
-static unsigned long		nr_state_machine_bugs;
-static unsigned long		nr_context_switch_bugs;
-static unsigned long		nr_events;
-static unsigned long		nr_lost_chunks;
-static unsigned long		nr_lost_events;
-
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
 enum thread_state {
@@ -149,11 +97,169 @@ struct work_atoms {
 
 typedef int (*sort_fn_t)(struct work_atoms *, struct work_atoms *);
 
-static struct rb_root		atom_root, sorted_atom_root;
+struct trace_switch_event {
+	u32  size;
+
+	u16  common_type;
+	u8   common_flags;
+	u8   common_preempt_count;
+	u32  common_pid;
+	u32  common_tgid;
+
+	char prev_comm[16];
+	u32  prev_pid;
+	u32  prev_prio;
+	u64  prev_state;
+	char next_comm[16];
+	u32  next_pid;
+	u32  next_prio;
+};
+
+struct trace_runtime_event {
+	u32  size;
+
+	u16  common_type;
+	u8   common_flags;
+	u8   common_preempt_count;
+	u32  common_pid;
+	u32  common_tgid;
+
+	char comm[16];
+	u32  pid;
+	u64  runtime;
+	u64  vruntime;
+};
+
+struct trace_wakeup_event {
+	u32  size;
 
-static u64			all_runtime;
-static u64			all_count;
+	u16  common_type;
+	u8   common_flags;
+	u8   common_preempt_count;
+	u32  common_pid;
+	u32  common_tgid;
 
+	char comm[16];
+	u32  pid;
+
+	u32  prio;
+	u32  success;
+	u32  cpu;
+};
+
+struct trace_fork_event {
+	u32  size;
+
+	u16  common_type;
+	u8   common_flags;
+	u8   common_preempt_count;
+	u32  common_pid;
+	u32  common_tgid;
+
+	char parent_comm[16];
+	u32  parent_pid;
+	char child_comm[16];
+	u32   child_pid;
+};
+
+struct trace_migrate_task_event {
+	u32  size;
+
+	u16  common_type;
+	u8   common_flags;
+	u8   common_preempt_count;
+	u32  common_pid;
+	u32  common_tgid;
+
+	char comm[16];
+	u32  pid;
+
+	u32  prio;
+	u32  cpu;
+};
+
+struct perf_sched;
+
+struct trace_sched_handler {
+	int (*switch_event)(struct perf_sched *sched,
+			    struct trace_switch_event *event,
+			    struct machine *machine,
+			    struct event_format *tp_format,
+			    struct perf_sample *sample);
+
+	int (*runtime_event)(struct perf_sched *sched,
+			     struct trace_runtime_event *event,
+			     struct machine *machine,
+			     struct perf_sample *sample);
+
+	int (*wakeup_event)(struct perf_sched *sched,
+			    struct trace_wakeup_event *event,
+			    struct machine *machine,
+			    struct event_format *tp_format,
+			    struct perf_sample *sample);
+
+	int (*fork_event)(struct perf_sched *sched,
+			  struct trace_fork_event *event,
+			  struct event_format *tp_format);
+
+	int (*migrate_task_event)(struct perf_sched *sched,
+				  struct trace_migrate_task_event *event,
+				  struct machine *machine,
+				  struct perf_sample *sample);
+};
+
+struct perf_sched {
+	struct perf_tool tool;
+	const char	 *input_name;
+	const char	 *sort_order;
+	unsigned long	 nr_tasks;
+	struct task_desc *pid_to_task[MAX_PID];
+	struct task_desc **tasks;
+	const struct trace_sched_handler *tp_handler;
+	pthread_mutex_t	 start_work_mutex;
+	pthread_mutex_t	 work_done_wait_mutex;
+	int		 profile_cpu;
+/*
+ * Track the current task - that way we can know whether there's any
+ * weird events, such as a task being switched away that is not current.
+ */
+	int		 max_cpu;
+	u32		 curr_pid[MAX_CPUS];
+	struct thread	 *curr_thread[MAX_CPUS];
+	char		 next_shortname1;
+	char		 next_shortname2;
+	unsigned int	 replay_repeat;
+	unsigned long	 nr_run_events;
+	unsigned long	 nr_sleep_events;
+	unsigned long	 nr_wakeup_events;
+	unsigned long	 nr_sleep_corrections;
+	unsigned long	 nr_run_events_optimized;
+	unsigned long	 targetless_wakeups;
+	unsigned long	 multitarget_wakeups;
+	unsigned long	 nr_runs;
+	unsigned long	 nr_timestamps;
+	unsigned long	 nr_unordered_timestamps;
+	unsigned long	 nr_state_machine_bugs;
+	unsigned long	 nr_context_switch_bugs;
+	unsigned long	 nr_events;
+	unsigned long	 nr_lost_chunks;
+	unsigned long	 nr_lost_events;
+	u64		 run_measurement_overhead;
+	u64		 sleep_measurement_overhead;
+	u64		 start_time;
+	u64		 cpu_usage;
+	u64		 runavg_cpu_usage;
+	u64		 parent_cpu_usage;
+	u64		 runavg_parent_cpu_usage;
+	u64		 sum_runtime;
+	u64		 sum_fluct;
+	u64		 run_avg;
+	u64		 all_runtime;
+	u64		 all_count;
+	u64		 cpu_last_switched[MAX_CPUS];
+	struct rb_root	 atom_root, sorted_atom_root;
+	struct list_head sort_list, cmp_pid;
+};
 
 static u64 get_nsecs(void)
 {
@@ -164,13 +270,13 @@ static u64 get_nsecs(void)
 	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 }
 
-static void burn_nsecs(u64 nsecs)
+static void burn_nsecs(struct perf_sched *sched, u64 nsecs)
 {
 	u64 T0 = get_nsecs(), T1;
 
 	do {
 		T1 = get_nsecs();
-	} while (T1 + run_measurement_overhead < T0 + nsecs);
+	} while (T1 + sched->run_measurement_overhead < T0 + nsecs);
 }
 
 static void sleep_nsecs(u64 nsecs)
@@ -183,24 +289,24 @@ static void sleep_nsecs(u64 nsecs)
 	nanosleep(&ts, NULL);
 }
 
-static void calibrate_run_measurement_overhead(void)
+static void calibrate_run_measurement_overhead(struct perf_sched *sched)
 {
 	u64 T0, T1, delta, min_delta = 1000000000ULL;
 	int i;
 
 	for (i = 0; i < 10; i++) {
 		T0 = get_nsecs();
-		burn_nsecs(0);
+		burn_nsecs(sched, 0);
 		T1 = get_nsecs();
 		delta = T1-T0;
 		min_delta = min(min_delta, delta);
 	}
-	run_measurement_overhead = min_delta;
+	sched->run_measurement_overhead = min_delta;
 
 	printf("run measurement overhead: %" PRIu64 " nsecs\n", min_delta);
 }
 
-static void calibrate_sleep_measurement_overhead(void)
+static void calibrate_sleep_measurement_overhead(struct perf_sched *sched)
 {
 	u64 T0, T1, delta, min_delta = 1000000000ULL;
 	int i;
@@ -213,7 +319,7 @@ static void calibrate_sleep_measurement_overhead(void)
 		min_delta = min(min_delta, delta);
 	}
 	min_delta -= 10000;
-	sleep_measurement_overhead = min_delta;
+	sched->sleep_measurement_overhead = min_delta;
 
 	printf("sleep measurement overhead: %" PRIu64 " nsecs\n", min_delta);
 }
@@ -246,8 +352,8 @@ static struct sched_atom *last_event(struct task_desc *task)
 	return task->atoms[task->nr_events - 1];
 }
 
-static void
-add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
+static void add_sched_event_run(struct perf_sched *sched, struct task_desc *task,
+				u64 timestamp, u64 duration)
 {
 	struct sched_atom *event, *curr_event = last_event(task);
 
@@ -256,7 +362,7 @@ add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
 	 * to it:
 	 */
 	if (curr_event && curr_event->type == SCHED_EVENT_RUN) {
-		nr_run_events_optimized++;
+		sched->nr_run_events_optimized++;
 		curr_event->duration += duration;
 		return;
 	}
@@ -266,12 +372,11 @@ add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
 	event->type = SCHED_EVENT_RUN;
 	event->duration = duration;
 
-	nr_run_events++;
+	sched->nr_run_events++;
 }
 
-static void
-add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
-		       struct task_desc *wakee)
+static void add_sched_event_wakeup(struct perf_sched *sched, struct task_desc *task,
+				   u64 timestamp, struct task_desc *wakee)
 {
 	struct sched_atom *event, *wakee_event;
 
@@ -281,11 +386,11 @@ add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
 
 	wakee_event = last_event(wakee);
 	if (!wakee_event || wakee_event->type != SCHED_EVENT_SLEEP) {
-		targetless_wakeups++;
+		sched->targetless_wakeups++;
 		return;
 	}
 	if (wakee_event->wait_sem) {
-		multitarget_wakeups++;
+		sched->multitarget_wakeups++;
 		return;
 	}
 
@@ -294,89 +399,89 @@ add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
 	wakee_event->specific_wait = 1;
 	event->wait_sem = wakee_event->wait_sem;
 
-	nr_wakeup_events++;
+	sched->nr_wakeup_events++;
 }
 
-static void
-add_sched_event_sleep(struct task_desc *task, u64 timestamp,
-		      u64 task_state __maybe_unused)
+static void add_sched_event_sleep(struct perf_sched *sched, struct task_desc *task,
+				  u64 timestamp, u64 task_state __maybe_unused)
 {
 	struct sched_atom *event = get_new_event(task, timestamp);
 
 	event->type = SCHED_EVENT_SLEEP;
 
-	nr_sleep_events++;
+	sched->nr_sleep_events++;
 }
 
-static struct task_desc *register_pid(unsigned long pid, const char *comm)
+static struct task_desc *register_pid(struct perf_sched *sched,
+				      unsigned long pid, const char *comm)
 {
 	struct task_desc *task;
 
 	BUG_ON(pid >= MAX_PID);
 
-	task = pid_to_task[pid];
+	task = sched->pid_to_task[pid];
 
 	if (task)
 		return task;
 
 	task = zalloc(sizeof(*task));
 	task->pid = pid;
-	task->nr = nr_tasks;
+	task->nr = sched->nr_tasks;
 	strcpy(task->comm, comm);
 	/*
 	 * every task starts in sleeping state - this gets ignored
 	 * if there's no wakeup pointing to this sleep state:
 	 */
-	add_sched_event_sleep(task, 0, 0);
+	add_sched_event_sleep(sched, task, 0, 0);
 
-	pid_to_task[pid] = task;
-	nr_tasks++;
-	tasks = realloc(tasks, nr_tasks*sizeof(struct task_task *));
-	BUG_ON(!tasks);
-	tasks[task->nr] = task;
+	sched->pid_to_task[pid] = task;
+	sched->nr_tasks++;
+	sched->tasks = realloc(sched->tasks, sched->nr_tasks * sizeof(struct task_task *));
+	BUG_ON(!sched->tasks);
+	sched->tasks[task->nr] = task;
 
 	if (verbose)
-		printf("registered task #%ld, PID %ld (%s)\n", nr_tasks, pid, comm);
+		printf("registered task #%ld, PID %ld (%s)\n", sched->nr_tasks, pid, comm);
 
 	return task;
 }
 
 
-static void print_task_traces(void)
+static void print_task_traces(struct perf_sched *sched)
 {
 	struct task_desc *task;
 	unsigned long i;
 
-	for (i = 0; i < nr_tasks; i++) {
-		task = tasks[i];
+	for (i = 0; i < sched->nr_tasks; i++) {
+		task = sched->tasks[i];
 		printf("task %6ld (%20s:%10ld), nr_events: %ld\n",
 			task->nr, task->comm, task->pid, task->nr_events);
 	}
 }
 
-static void add_cross_task_wakeups(void)
+static void add_cross_task_wakeups(struct perf_sched *sched)
 {
 	struct task_desc *task1, *task2;
 	unsigned long i, j;
 
-	for (i = 0; i < nr_tasks; i++) {
-		task1 = tasks[i];
+	for (i = 0; i < sched->nr_tasks; i++) {
+		task1 = sched->tasks[i];
 		j = i + 1;
-		if (j == nr_tasks)
+		if (j == sched->nr_tasks)
 			j = 0;
-		task2 = tasks[j];
-		add_sched_event_wakeup(task1, 0, task2);
+		task2 = sched->tasks[j];
+		add_sched_event_wakeup(sched, task1, 0, task2);
 	}
 }
 
-static void process_sched_event(struct task_desc *this_task __maybe_unused,
-				struct sched_atom *atom)
+static void perf_sched__process_event(struct perf_sched *sched,
+				      struct sched_atom *atom)
 {
 	int ret = 0;
 
 	switch (atom->type) {
 		case SCHED_EVENT_RUN:
-			burn_nsecs(atom->duration);
+			burn_nsecs(sched, atom->duration);
 			break;
 		case SCHED_EVENT_SLEEP:
 			if (atom->wait_sem)
@@ -439,14 +544,23 @@ static u64 get_cpu_usage_nsec_self(int fd)
 	return runtime;
 }
 
+struct sched_thread_parms {
+	struct task_desc  *task;
+	struct perf_sched *sched;
+};
+
 static void *thread_func(void *ctx)
 {
-	struct task_desc *this_task = ctx;
+	struct sched_thread_parms *parms = ctx;
+	struct task_desc *this_task = parms->task;
+	struct perf_sched *sched = parms->sched;
 	u64 cpu_usage_0, cpu_usage_1;
 	unsigned long i, ret;
 	char comm2[22];
 	int fd;
 
+	free(parms);
+
 	sprintf(comm2, ":%s", this_task->comm);
 	prctl(PR_SET_NAME, comm2);
 	fd = self_open_counters();
@@ -455,16 +569,16 @@ static void *thread_func(void *ctx)
 again:
 	ret = sem_post(&this_task->ready_for_work);
 	BUG_ON(ret);
-	ret = pthread_mutex_lock(&start_work_mutex);
+	ret = pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(ret);
-	ret = pthread_mutex_unlock(&start_work_mutex);
+	ret = pthread_mutex_unlock(&sched->start_work_mutex);
 	BUG_ON(ret);
 
 	cpu_usage_0 = get_cpu_usage_nsec_self(fd);
 
 	for (i = 0; i < this_task->nr_events; i++) {
 		this_task->curr_event = i;
-		process_sched_event(this_task, this_task->atoms[i]);
+		perf_sched__process_event(sched, this_task->atoms[i]);
 	}
 
 	cpu_usage_1 = get_cpu_usage_nsec_self(fd);
@@ -472,15 +586,15 @@ again:
 	ret = sem_post(&this_task->work_done_sem);
 	BUG_ON(ret);
 
-	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	ret = pthread_mutex_lock(&sched->work_done_wait_mutex);
 	BUG_ON(ret);
-	ret = pthread_mutex_unlock(&work_done_wait_mutex);
+	ret = pthread_mutex_unlock(&sched->work_done_wait_mutex);
 	BUG_ON(ret);
 
 	goto again;
 }
 
-static void create_tasks(void)
+static void create_tasks(struct perf_sched *sched)
 {
 	struct task_desc *task;
 	pthread_attr_t attr;
@@ -492,128 +606,129 @@ static void create_tasks(void)
 	err = pthread_attr_setstacksize(&attr,
 			(size_t) max(16 * 1024, PTHREAD_STACK_MIN));
 	BUG_ON(err);
-	err = pthread_mutex_lock(&start_work_mutex);
+	err = pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(err);
-	err = pthread_mutex_lock(&work_done_wait_mutex);
+	err = pthread_mutex_lock(&sched->work_done_wait_mutex);
 	BUG_ON(err);
-	for (i = 0; i < nr_tasks; i++) {
-		task = tasks[i];
+	for (i = 0; i < sched->nr_tasks; i++) {
+		struct sched_thread_parms *parms = malloc(sizeof(*parms));
+		BUG_ON(parms == NULL);
+		parms->task = task = sched->tasks[i];
+		parms->sched = sched;
 		sem_init(&task->sleep_sem, 0, 0);
 		sem_init(&task->ready_for_work, 0, 0);
 		sem_init(&task->work_done_sem, 0, 0);
 		task->curr_event = 0;
-		err = pthread_create(&task->thread, &attr, thread_func, task);
+		err = pthread_create(&task->thread, &attr, thread_func, parms);
 		BUG_ON(err);
 	}
 }
 
-static void wait_for_tasks(void)
+static void wait_for_tasks(struct perf_sched *sched)
 {
 	u64 cpu_usage_0, cpu_usage_1;
 	struct task_desc *task;
 	unsigned long i, ret;
 
-	start_time = get_nsecs();
-	cpu_usage = 0;
-	pthread_mutex_unlock(&work_done_wait_mutex);
+	sched->start_time = get_nsecs();
+	sched->cpu_usage = 0;
+	pthread_mutex_unlock(&sched->work_done_wait_mutex);
 
-	for (i = 0; i < nr_tasks; i++) {
-		task = tasks[i];
+	for (i = 0; i < sched->nr_tasks; i++) {
+		task = sched->tasks[i];
 		ret = sem_wait(&task->ready_for_work);
 		BUG_ON(ret);
 		sem_init(&task->ready_for_work, 0, 0);
 	}
-	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	ret = pthread_mutex_lock(&sched->work_done_wait_mutex);
 	BUG_ON(ret);
 
 	cpu_usage_0 = get_cpu_usage_nsec_parent();
 
-	pthread_mutex_unlock(&start_work_mutex);
+	pthread_mutex_unlock(&sched->start_work_mutex);
 
-	for (i = 0; i < nr_tasks; i++) {
-		task = tasks[i];
+	for (i = 0; i < sched->nr_tasks; i++) {
+		task = sched->tasks[i];
 		ret = sem_wait(&task->work_done_sem);
 		BUG_ON(ret);
 		sem_init(&task->work_done_sem, 0, 0);
-		cpu_usage += task->cpu_usage;
+		sched->cpu_usage += task->cpu_usage;
 		task->cpu_usage = 0;
 	}
 
 	cpu_usage_1 = get_cpu_usage_nsec_parent();
-	if (!runavg_cpu_usage)
-		runavg_cpu_usage = cpu_usage;
-	runavg_cpu_usage = (runavg_cpu_usage*9 + cpu_usage)/10;
+	if (!sched->runavg_cpu_usage)
+		sched->runavg_cpu_usage = sched->cpu_usage;
+	sched->runavg_cpu_usage = (sched->runavg_cpu_usage * 9 + sched->cpu_usage) / 10;
 
-	parent_cpu_usage = cpu_usage_1 - cpu_usage_0;
-	if (!runavg_parent_cpu_usage)
-		runavg_parent_cpu_usage = parent_cpu_usage;
-	runavg_parent_cpu_usage = (runavg_parent_cpu_usage*9 +
-				   parent_cpu_usage)/10;
+	sched->parent_cpu_usage = cpu_usage_1 - cpu_usage_0;
+	if (!sched->runavg_parent_cpu_usage)
+		sched->runavg_parent_cpu_usage = sched->parent_cpu_usage;
+	sched->runavg_parent_cpu_usage = (sched->runavg_parent_cpu_usage * 9 +
+					 sched->parent_cpu_usage)/10;
 
-	ret = pthread_mutex_lock(&start_work_mutex);
+	ret = pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(ret);
 
-	for (i = 0; i < nr_tasks; i++) {
-		task = tasks[i];
+	for (i = 0; i < sched->nr_tasks; i++) {
+		task = sched->tasks[i];
 		sem_init(&task->sleep_sem, 0, 0);
 		task->curr_event = 0;
 	}
 }
 
-static void run_one_test(void)
+static void run_one_test(struct perf_sched *sched)
 {
 	u64 T0, T1, delta, avg_delta, fluct;
 
 	T0 = get_nsecs();
-	wait_for_tasks();
+	wait_for_tasks(sched);
 	T1 = get_nsecs();
 
 	delta = T1 - T0;
-	sum_runtime += delta;
-	nr_runs++;
+	sched->sum_runtime += delta;
+	sched->nr_runs++;
 
-	avg_delta = sum_runtime / nr_runs;
+	avg_delta = sched->sum_runtime / sched->nr_runs;
 	if (delta < avg_delta)
 		fluct = avg_delta - delta;
 	else
 		fluct = delta - avg_delta;
-	sum_fluct += fluct;
-	if (!run_avg)
-		run_avg = delta;
-	run_avg = (run_avg*9 + delta)/10;
+	sched->sum_fluct += fluct;
+	if (!sched->run_avg)
+		sched->run_avg = delta;
+	sched->run_avg = (sched->run_avg * 9 + delta) / 10;
 
-	printf("#%-3ld: %0.3f, ",
-		nr_runs, (double)delta/1000000.0);
+	printf("#%-3ld: %0.3f, ", sched->nr_runs, (double)delta / 1000000.0);
 
-	printf("ravg: %0.2f, ",
-		(double)run_avg/1e6);
+	printf("ravg: %0.2f, ", (double)sched->run_avg / 1e6);
 
 	printf("cpu: %0.2f / %0.2f",
-		(double)cpu_usage/1e6, (double)runavg_cpu_usage/1e6);
+		(double)sched->cpu_usage / 1e6, (double)sched->runavg_cpu_usage / 1e6);
 
 #if 0
 	/*
 	 * rusage statistics done by the parent, these are less
-	 * accurate than the sum_exec_runtime based statistics:
+	 * accurate than the sched->sum_exec_runtime based statistics:
 	 */
 	printf(" [%0.2f / %0.2f]",
-		(double)parent_cpu_usage/1e6,
-		(double)runavg_parent_cpu_usage/1e6);
+		(double)sched->parent_cpu_usage/1e6,
+		(double)sched->runavg_parent_cpu_usage/1e6);
 #endif
 
 	printf("\n");
 
-	if (nr_sleep_corrections)
-		printf(" (%ld sleep corrections)\n", nr_sleep_corrections);
-	nr_sleep_corrections = 0;
+	if (sched->nr_sleep_corrections)
+		printf(" (%ld sleep corrections)\n", sched->nr_sleep_corrections);
+	sched->nr_sleep_corrections = 0;
 }
 
-static void test_calibrations(void)
+static void test_calibrations(struct perf_sched *sched)
 {
 	u64 T0, T1;
 
 	T0 = get_nsecs();
-	burn_nsecs(1e6);
+	burn_nsecs(sched, 1e6);
 	T1 = get_nsecs();
 
 	printf("the run test took %" PRIu64 " nsecs\n", T1 - T0);
@@ -643,115 +758,9 @@ do {								\
 	FILL_FIELD(ptr, common_tgid, event, data);		\
 } while (0)
 
-
-
-struct trace_switch_event {
-	u32 size;
-
-	u16 common_type;
-	u8 common_flags;
-	u8 common_preempt_count;
-	u32 common_pid;
-	u32 common_tgid;
-
-	char prev_comm[16];
-	u32 prev_pid;
-	u32 prev_prio;
-	u64 prev_state;
-	char next_comm[16];
-	u32 next_pid;
-	u32 next_prio;
-};
-
-struct trace_runtime_event {
-	u32 size;
-
-	u16 common_type;
-	u8 common_flags;
-	u8 common_preempt_count;
-	u32 common_pid;
-	u32 common_tgid;
-
-	char comm[16];
-	u32 pid;
-	u64 runtime;
-	u64 vruntime;
-};
-
-struct trace_wakeup_event {
-	u32 size;
-
-	u16 common_type;
-	u8 common_flags;
-	u8 common_preempt_count;
-	u32 common_pid;
-	u32 common_tgid;
-
-	char comm[16];
-	u32 pid;
-
-	u32 prio;
-	u32 success;
-	u32 cpu;
-};
-
-struct trace_fork_event {
-	u32 size;
-
-	u16 common_type;
-	u8 common_flags;
-	u8 common_preempt_count;
-	u32 common_pid;
-	u32 common_tgid;
-
-	char parent_comm[16];
-	u32 parent_pid;
-	char child_comm[16];
-	u32 child_pid;
-};
-
-struct trace_migrate_task_event {
-	u32 size;
-
-	u16 common_type;
-	u8 common_flags;
-	u8 common_preempt_count;
-	u32 common_pid;
-	u32 common_tgid;
-
-	char comm[16];
-	u32 pid;
-
-	u32 prio;
-	u32 cpu;
-};
-
-struct trace_sched_handler {
-	int (*switch_event)(struct trace_switch_event *event,
-			    struct machine *machine,
-			    struct event_format *tp_format,
-			    struct perf_sample *sample);
-
-	int (*runtime_event)(struct trace_runtime_event *event,
-			     struct machine *machine,
-			     struct perf_sample *sample);
-
-	int (*wakeup_event)(struct trace_wakeup_event *event,
-			    struct machine *machine,
-			    struct event_format *tp_format,
-			    struct perf_sample *sample);
-
-	int (*fork_event)(struct trace_fork_event *event,
-			  struct event_format *tp_format);
-
-	int (*migrate_task_event)(struct trace_migrate_task_event *event,
-				  struct machine *machine,
-				  struct perf_sample *sample);
-};
-
-
 static int
-replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
+replay_wakeup_event(struct perf_sched *sched,
+		    struct trace_wakeup_event *wakeup_event,
 		    struct machine *machine __maybe_unused,
 		    struct event_format *event, struct perf_sample *sample)
 {
@@ -761,22 +770,19 @@ replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		printf("sched_wakeup event %p\n", event);
 
 		printf(" ... pid %d woke up %s/%d\n",
-			wakeup_event->common_pid,
-			wakeup_event->comm,
-			wakeup_event->pid);
+		       wakeup_event->common_pid, wakeup_event->comm, wakeup_event->pid);
 	}
 
-	waker = register_pid(wakeup_event->common_pid, "<unknown>");
-	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
+	waker = register_pid(sched, wakeup_event->common_pid, "<unknown>");
+	wakee = register_pid(sched, wakeup_event->pid, wakeup_event->comm);
 
-	add_sched_event_wakeup(waker, sample->time, wakee);
+	add_sched_event_wakeup(sched, waker, sample->time, wakee);
 	return 0;
 }
 
-static u64 cpu_last_switched[MAX_CPUS];
-
 static int
-replay_switch_event(struct trace_switch_event *switch_event,
+replay_switch_event(struct perf_sched *sched,
+		    struct trace_switch_event *switch_event,
 		    struct machine *machine __maybe_unused,
 		    struct event_format *event,
 		    struct perf_sample *sample)
@@ -792,7 +798,7 @@ replay_switch_event(struct trace_switch_event *switch_event,
 	if (cpu >= MAX_CPUS || cpu < 0)
 		return 0;
 
-	timestamp0 = cpu_last_switched[cpu];
+	timestamp0 = sched->cpu_last_switched[cpu];
 	if (timestamp0)
 		delta = timestamp - timestamp0;
 	else
@@ -810,20 +816,19 @@ replay_switch_event(struct trace_switch_event *switch_event,
 			delta);
 	}
 
-	prev = register_pid(switch_event->prev_pid, switch_event->prev_comm);
-	next = register_pid(switch_event->next_pid, switch_event->next_comm);
+	prev = register_pid(sched, switch_event->prev_pid, switch_event->prev_comm);
+	next = register_pid(sched, switch_event->next_pid, switch_event->next_comm);
 
-	cpu_last_switched[cpu] = timestamp;
+	sched->cpu_last_switched[cpu] = timestamp;
 
-	add_sched_event_run(prev, timestamp, delta);
-	add_sched_event_sleep(prev, timestamp, switch_event->prev_state);
+	add_sched_event_run(sched, prev, timestamp, delta);
+	add_sched_event_sleep(sched, prev, timestamp, switch_event->prev_state);
 
 	return 0;
 }
 
-
 static int
-replay_fork_event(struct trace_fork_event *fork_event,
+replay_fork_event(struct perf_sched *sched, struct trace_fork_event *fork_event,
 		  struct event_format *event)
 {
 	if (verbose) {
@@ -831,25 +836,17 @@ replay_fork_event(struct trace_fork_event *fork_event,
 		printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
 		printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
 	}
-	register_pid(fork_event->parent_pid, fork_event->parent_comm);
-	register_pid(fork_event->child_pid, fork_event->child_comm);
+	register_pid(sched, fork_event->parent_pid, fork_event->parent_comm);
+	register_pid(sched, fork_event->child_pid, fork_event->child_comm);
 	return 0;
 }
 
-static struct trace_sched_handler replay_ops  = {
-	.wakeup_event		= replay_wakeup_event,
-	.switch_event		= replay_switch_event,
-	.fork_event		= replay_fork_event,
-};
-
 struct sort_dimension {
 	const char		*name;
 	sort_fn_t		cmp;
 	struct list_head	list;
 };
 
-static LIST_HEAD(cmp_pid);
-
 static int
 thread_lat_cmp(struct list_head *list, struct work_atoms *l, struct work_atoms *r)
 {
@@ -918,7 +915,7 @@ __thread_latency_insert(struct rb_root *root, struct work_atoms *data,
 	rb_insert_color(&data->node, root);
 }
 
-static int thread_atoms_insert(struct thread *thread)
+static int thread_atoms_insert(struct perf_sched *sched, struct thread *thread)
 {
 	struct work_atoms *atoms = zalloc(sizeof(*atoms));
 	if (!atoms) {
@@ -928,11 +925,12 @@ static int thread_atoms_insert(struct thread *thread)
 
 	atoms->thread = thread;
 	INIT_LIST_HEAD(&atoms->work_list);
-	__thread_latency_insert(&atom_root, atoms, &cmp_pid);
+	__thread_latency_insert(&sched->atom_root, atoms, &sched->cmp_pid);
 	return 0;
 }
 
-static int latency_fork_event(struct trace_fork_event *fork_event __maybe_unused,
+static int latency_fork_event(struct perf_sched *sched __maybe_unused,
+			      struct trace_fork_event *fork_event __maybe_unused,
 			      struct event_format *event __maybe_unused)
 {
 	/* should insert the newcomer */
@@ -1014,7 +1012,8 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 }
 
 static int
-latency_switch_event(struct trace_switch_event *switch_event,
+latency_switch_event(struct perf_sched *sched,
+		     struct trace_switch_event *switch_event,
 		     struct machine *machine,
 		     struct event_format *event __maybe_unused,
 		     struct perf_sample *sample)
@@ -1027,8 +1026,8 @@ latency_switch_event(struct trace_switch_event *switch_event,
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
 
-	timestamp0 = cpu_last_switched[cpu];
-	cpu_last_switched[cpu] = timestamp;
+	timestamp0 = sched->cpu_last_switched[cpu];
+	sched->cpu_last_switched[cpu] = timestamp;
 	if (timestamp0)
 		delta = timestamp - timestamp0;
 	else
@@ -1042,11 +1041,11 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
 	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
 
-	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
-		if (thread_atoms_insert(sched_out))
+		if (thread_atoms_insert(sched, sched_out))
 			return -1;
-		out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+		out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 		if (!out_events) {
 			pr_err("out-event: Internal tree error");
 			return -1;
@@ -1055,11 +1054,11 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	if (add_sched_out_event(out_events, sched_out_state(switch_event), timestamp))
 		return -1;
 
-	in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+	in_events = thread_atoms_search(&sched->atom_root, sched_in, &sched->cmp_pid);
 	if (!in_events) {
-		if (thread_atoms_insert(sched_in))
+		if (thread_atoms_insert(sched, sched_in))
 			return -1;
-		in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+		in_events = thread_atoms_search(&sched->atom_root, sched_in, &sched->cmp_pid);
 		if (!in_events) {
 			pr_err("in-event: Internal tree error");
 			return -1;
@@ -1077,19 +1076,20 @@ latency_switch_event(struct trace_switch_event *switch_event,
 }
 
 static int
-latency_runtime_event(struct trace_runtime_event *runtime_event,
+latency_runtime_event(struct perf_sched *sched,
+		      struct trace_runtime_event *runtime_event,
 		      struct machine *machine, struct perf_sample *sample)
 {
 	struct thread *thread = machine__findnew_thread(machine, runtime_event->pid);
-	struct work_atoms *atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
 	if (!atoms) {
-		if (thread_atoms_insert(thread))
+		if (thread_atoms_insert(sched, thread))
 			return -1;
-		atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+		atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 		if (!atoms) {
 			pr_debug("in-event: Internal tree error");
 			return -1;
@@ -1103,7 +1103,8 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 }
 
 static int
-latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
+latency_wakeup_event(struct perf_sched *sched,
+		     struct trace_wakeup_event *wakeup_event,
 		     struct machine *machine,
 		     struct event_format *event __maybe_unused,
 		     struct perf_sample *sample)
@@ -1118,11 +1119,11 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		return 0;
 
 	wakee = machine__findnew_thread(machine, wakeup_event->pid);
-	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
-		if (thread_atoms_insert(wakee))
+		if (thread_atoms_insert(sched, wakee))
 			return -1;
-		atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+		atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 		if (!atoms) {
 			pr_debug("wakeup-event: Internal tree error");
 			return -1;
@@ -1140,12 +1141,12 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	 * one CPU, or are only looking at only one, so don't
 	 * make useless noise.
 	 */
-	if (profile_cpu == -1 && atom->state != THREAD_SLEEPING)
-		nr_state_machine_bugs++;
+	if (sched->profile_cpu == -1 && atom->state != THREAD_SLEEPING)
+		sched->nr_state_machine_bugs++;
 
-	nr_timestamps++;
+	sched->nr_timestamps++;
 	if (atom->sched_out_time > timestamp) {
-		nr_unordered_timestamps++;
+		sched->nr_unordered_timestamps++;
 		return 0;
 	}
 
@@ -1155,7 +1156,8 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 }
 
 static int
-latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
+latency_migrate_task_event(struct perf_sched *sched,
+			   struct trace_migrate_task_event *migrate_task_event,
 			   struct machine *machine, struct perf_sample *sample)
 {
 	u64 timestamp = sample->time;
@@ -1166,16 +1168,16 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	/*
 	 * Only need to worry about migration when profiling one CPU.
 	 */
-	if (profile_cpu == -1)
+	if (sched->profile_cpu == -1)
 		return 0;
 
 	migrant = machine__findnew_thread(machine, migrate_task_event->pid);
-	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
+	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
-		if (thread_atoms_insert(migrant))
+		if (thread_atoms_insert(sched, migrant))
 			return -1;
-		register_pid(migrant->pid, migrant->comm);
-		atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
+		register_pid(sched, migrant->pid, migrant->comm);
+		atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 		if (!atoms) {
 			pr_debug("migration-event: Internal tree error");
 			return -1;
@@ -1189,23 +1191,15 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 	atom->sched_in_time = atom->sched_out_time = atom->wake_up_time = timestamp;
 
-	nr_timestamps++;
+	sched->nr_timestamps++;
 
 	if (atom->sched_out_time > timestamp)
-		nr_unordered_timestamps++;
+		sched->nr_unordered_timestamps++;
 
 	return 0;
 }
 
-static struct trace_sched_handler lat_ops  = {
-	.wakeup_event		= latency_wakeup_event,
-	.switch_event		= latency_switch_event,
-	.runtime_event		= latency_runtime_event,
-	.fork_event		= latency_fork_event,
-	.migrate_task_event	= latency_migrate_task_event,
-};
-
-static void output_lat_thread(struct work_atoms *work_list)
+static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_list)
 {
 	int i;
 	int ret;
@@ -1219,8 +1213,8 @@ static void output_lat_thread(struct work_atoms *work_list)
 	if (!strcmp(work_list->thread->comm, "swapper"))
 		return;
 
-	all_runtime += work_list->total_runtime;
-	all_count += work_list->nb_atoms;
+	sched->all_runtime += work_list->total_runtime;
+	sched->all_count   += work_list->nb_atoms;
 
 	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->pid);
 
@@ -1246,11 +1240,6 @@ static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
 	return 0;
 }
 
-static struct sort_dimension pid_sort_dimension = {
-	.name			= "pid",
-	.cmp			= pid_cmp,
-};
-
 static int avg_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	u64 avgl, avgr;
@@ -1272,11 +1261,6 @@ static int avg_cmp(struct work_atoms *l, struct work_atoms *r)
 	return 0;
 }
 
-static struct sort_dimension avg_sort_dimension = {
-	.name			= "avg",
-	.cmp			= avg_cmp,
-};
-
 static int max_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->max_lat < r->max_lat)
@@ -1287,11 +1271,6 @@ static int max_cmp(struct work_atoms *l, struct work_atoms *r)
 	return 0;
 }
 
-static struct sort_dimension max_sort_dimension = {
-	.name			= "max",
-	.cmp			= max_cmp,
-};
-
 static int switch_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->nb_atoms < r->nb_atoms)
@@ -1302,11 +1281,6 @@ static int switch_cmp(struct work_atoms *l, struct work_atoms *r)
 	return 0;
 }
 
-static struct sort_dimension switch_sort_dimension = {
-	.name			= "switch",
-	.cmp			= switch_cmp,
-};
-
 static int runtime_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->total_runtime < r->total_runtime)
@@ -1317,28 +1291,38 @@ static int runtime_cmp(struct work_atoms *l, struct work_atoms *r)
 	return 0;
 }
 
-static struct sort_dimension runtime_sort_dimension = {
-	.name			= "runtime",
-	.cmp			= runtime_cmp,
-};
-
-static struct sort_dimension *available_sorts[] = {
-	&pid_sort_dimension,
-	&avg_sort_dimension,
-	&max_sort_dimension,
-	&switch_sort_dimension,
-	&runtime_sort_dimension,
-};
-
-#define NB_AVAILABLE_SORTS	(int)(sizeof(available_sorts) / sizeof(struct sort_dimension *))
-
-static LIST_HEAD(sort_list);
-
 static int sort_dimension__add(const char *tok, struct list_head *list)
 {
-	int i;
+	size_t i;
+	static struct sort_dimension avg_sort_dimension = {
+		.name = "avg",
+		.cmp  = avg_cmp,
+	};
+	static struct sort_dimension max_sort_dimension = {
+		.name = "max",
+		.cmp  = max_cmp,
+	};
+	static struct sort_dimension pid_sort_dimension = {
+		.name = "pid",
+		.cmp  = pid_cmp,
+	};
+	static struct sort_dimension runtime_sort_dimension = {
+		.name = "runtime",
+		.cmp  = runtime_cmp,
+	};
+	static struct sort_dimension switch_sort_dimension = {
+		.name = "switch",
+		.cmp  = switch_cmp,
+	};
+	struct sort_dimension *available_sorts[] = {
+		&pid_sort_dimension,
+		&avg_sort_dimension,
+		&max_sort_dimension,
+		&switch_sort_dimension,
+		&runtime_sort_dimension,
+	};
 
-	for (i = 0; i < NB_AVAILABLE_SORTS; i++) {
+	for (i = 0; i < ARRAY_SIZE(available_sorts); i++) {
 		if (!strcmp(available_sorts[i]->name, tok)) {
 			list_add_tail(&available_sorts[i]->list, list);
 
@@ -1349,31 +1333,28 @@ static int sort_dimension__add(const char *tok, struct list_head *list)
 	return -1;
 }
 
-static void setup_sorting(void);
-
-static void sort_lat(void)
+static void perf_sched__sort_lat(struct perf_sched *sched)
 {
 	struct rb_node *node;
 
 	for (;;) {
 		struct work_atoms *data;
-		node = rb_first(&atom_root);
+		node = rb_first(&sched->atom_root);
 		if (!node)
 			break;
 
-		rb_erase(node, &atom_root);
+		rb_erase(node, &sched->atom_root);
 		data = rb_entry(node, struct work_atoms, node);
-		__thread_latency_insert(&sorted_atom_root, data, &sort_list);
+		__thread_latency_insert(&sched->sorted_atom_root, data, &sched->sort_list);
 	}
 }
 
-static struct trace_sched_handler *trace_handler;
-
-static int process_sched_wakeup_event(struct perf_tool *tool __maybe_unused,
+static int process_sched_wakeup_event(struct perf_tool *tool,
 				      struct event_format *event,
 				      struct perf_sample *sample,
 				      struct machine *machine)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	void *data = sample->raw_data;
 	struct trace_wakeup_event wakeup_event;
 	int err = 0;
@@ -1386,27 +1367,15 @@ static int process_sched_wakeup_event(struct perf_tool *tool __maybe_unused,
 	FILL_FIELD(wakeup_event, success, event, data);
 	FILL_FIELD(wakeup_event, cpu, event, data);
 
-	if (trace_handler->wakeup_event)
-		err = trace_handler->wakeup_event(&wakeup_event, machine, event, sample);
+	if (sched->tp_handler->wakeup_event)
+		err = sched->tp_handler->wakeup_event(sched, &wakeup_event, machine, event, sample);
 
 	return err;
 }
 
-/*
- * Track the current task - that way we can know whether there's any
- * weird events, such as a task being switched away that is not current.
- */
-static int max_cpu;
-
-static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
-
-static struct thread *curr_thread[MAX_CPUS];
-
-static char next_shortname1 = 'A';
-static char next_shortname2 = '0';
-
 static int
-map_switch_event(struct trace_switch_event *switch_event,
+map_switch_event(struct perf_sched *sched,
+		 struct trace_switch_event *switch_event,
 		 struct machine *machine,
 		 struct event_format *event __maybe_unused,
 		 struct perf_sample *sample)
@@ -1419,11 +1388,11 @@ map_switch_event(struct trace_switch_event *switch_event,
 
 	BUG_ON(this_cpu >= MAX_CPUS || this_cpu < 0);
 
-	if (this_cpu > max_cpu)
-		max_cpu = this_cpu;
+	if (this_cpu > sched->max_cpu)
+		sched->max_cpu = this_cpu;
 
-	timestamp0 = cpu_last_switched[this_cpu];
-	cpu_last_switched[this_cpu] = timestamp;
+	timestamp0 = sched->cpu_last_switched[this_cpu];
+	sched->cpu_last_switched[this_cpu] = timestamp;
 	if (timestamp0)
 		delta = timestamp - timestamp0;
 	else
@@ -1437,37 +1406,37 @@ map_switch_event(struct trace_switch_event *switch_event,
 	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
 	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
 
-	curr_thread[this_cpu] = sched_in;
+	sched->curr_thread[this_cpu] = sched_in;
 
 	printf("  ");
 
 	new_shortname = 0;
 	if (!sched_in->shortname[0]) {
-		sched_in->shortname[0] = next_shortname1;
-		sched_in->shortname[1] = next_shortname2;
+		sched_in->shortname[0] = sched->next_shortname1;
+		sched_in->shortname[1] = sched->next_shortname2;
 
-		if (next_shortname1 < 'Z') {
-			next_shortname1++;
+		if (sched->next_shortname1 < 'Z') {
+			sched->next_shortname1++;
 		} else {
-			next_shortname1='A';
-			if (next_shortname2 < '9') {
-				next_shortname2++;
+			sched->next_shortname1='A';
+			if (sched->next_shortname2 < '9') {
+				sched->next_shortname2++;
 			} else {
-				next_shortname2='0';
+				sched->next_shortname2='0';
 			}
 		}
 		new_shortname = 1;
 	}
 
-	for (cpu = 0; cpu <= max_cpu; cpu++) {
+	for (cpu = 0; cpu <= sched->max_cpu; cpu++) {
 		if (cpu != this_cpu)
 			printf(" ");
 		else
 			printf("*");
 
-		if (curr_thread[cpu]) {
-			if (curr_thread[cpu]->pid)
-				printf("%2s ", curr_thread[cpu]->shortname);
+		if (sched->curr_thread[cpu]) {
+			if (sched->curr_thread[cpu]->pid)
+				printf("%2s ", sched->curr_thread[cpu]->shortname);
 			else
 				printf(".  ");
 		} else
@@ -1485,11 +1454,12 @@ map_switch_event(struct trace_switch_event *switch_event,
 	return 0;
 }
 
-static int process_sched_switch_event(struct perf_tool *tool __maybe_unused,
+static int process_sched_switch_event(struct perf_tool *tool,
 				      struct event_format *event,
 				      struct perf_sample *sample,
 				      struct machine *machine)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	int this_cpu = sample->cpu, err = 0;
 	void *data = sample->raw_data;
 	struct trace_switch_event switch_event;
@@ -1504,26 +1474,27 @@ static int process_sched_switch_event(struct perf_tool *tool __maybe_unused,
 	FILL_FIELD(switch_event, next_pid, event, data);
 	FILL_FIELD(switch_event, next_prio, event, data);
 
-	if (curr_pid[this_cpu] != (u32)-1) {
+	if (sched->curr_pid[this_cpu] != (u32)-1) {
 		/*
 		 * Are we trying to switch away a PID that is
 		 * not current?
 		 */
-		if (curr_pid[this_cpu] != switch_event.prev_pid)
-			nr_context_switch_bugs++;
+		if (sched->curr_pid[this_cpu] != switch_event.prev_pid)
+			sched->nr_context_switch_bugs++;
 	}
-	if (trace_handler->switch_event)
-		err = trace_handler->switch_event(&switch_event, machine, event, sample);
+	if (sched->tp_handler->switch_event)
+		err = sched->tp_handler->switch_event(sched, &switch_event, machine, event, sample);
 
-	curr_pid[this_cpu] = switch_event.next_pid;
+	sched->curr_pid[this_cpu] = switch_event.next_pid;
 	return err;
 }
 
-static int process_sched_runtime_event(struct perf_tool *tool __maybe_unused,
+static int process_sched_runtime_event(struct perf_tool *tool,
 				       struct event_format *event,
 				       struct perf_sample *sample,
 				       struct machine *machine)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	void *data = sample->raw_data;
 	struct trace_runtime_event runtime_event;
 	int err = 0;
@@ -1533,17 +1504,18 @@ static int process_sched_runtime_event(struct perf_tool *tool __maybe_unused,
 	FILL_FIELD(runtime_event, runtime, event, data);
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
-	if (trace_handler->runtime_event)
-		err = trace_handler->runtime_event(&runtime_event, machine, sample);
+	if (sched->tp_handler->runtime_event)
+		err = sched->tp_handler->runtime_event(sched, &runtime_event, machine, sample);
 
 	return err;
 }
 
-static int process_sched_fork_event(struct perf_tool *tool __maybe_unused,
+static int process_sched_fork_event(struct perf_tool *tool,
 				    struct event_format *event,
 				    struct perf_sample *sample,
 				    struct machine *machine __maybe_unused)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	void *data = sample->raw_data;
 	struct trace_fork_event fork_event;
 	int err = 0;
@@ -1555,8 +1527,8 @@ static int process_sched_fork_event(struct perf_tool *tool __maybe_unused,
 	FILL_ARRAY(fork_event, child_comm, event, data);
 	FILL_FIELD(fork_event, child_pid, event, data);
 
-	if (trace_handler->fork_event)
-		err = trace_handler->fork_event(&fork_event, event);
+	if (sched->tp_handler->fork_event)
+		err = sched->tp_handler->fork_event(sched, &fork_event, event);
 
 	return err;
 }
@@ -1572,11 +1544,12 @@ static int process_sched_exit_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-static int process_sched_migrate_task_event(struct perf_tool *tool __maybe_unused,
+static int process_sched_migrate_task_event(struct perf_tool *tool,
 					    struct event_format *event,
 					    struct perf_sample *sample,
 					    struct machine *machine)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	void *data = sample->raw_data;
 	struct trace_migrate_task_event migrate_task_event;
 	int err = 0;
@@ -1588,8 +1561,8 @@ static int process_sched_migrate_task_event(struct perf_tool *tool __maybe_unuse
 	FILL_FIELD(migrate_task_event, prio, event, data);
 	FILL_FIELD(migrate_task_event, cpu, event, data);
 
-	if (trace_handler->migrate_task_event)
-		err = trace_handler->migrate_task_event(&migrate_task_event, machine, sample);
+	if (sched->tp_handler->migrate_task_event)
+		err = sched->tp_handler->migrate_task_event(sched, &migrate_task_event, machine, sample);
 
 	return err;
 }
@@ -1625,15 +1598,8 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 	return err;
 }
 
-static struct perf_tool perf_sched = {
-	.sample		 = perf_sched__process_tracepoint_sample,
-	.comm		 = perf_event__process_comm,
-	.lost		 = perf_event__process_lost,
-	.fork		 = perf_event__process_task,
-	.ordered_samples = true,
-};
-
-static int read_events(bool destroy, struct perf_session **psession)
+static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
+				   struct perf_session **psession)
 {
 	const struct perf_evsel_str_handler handlers[] = {
 		{ "sched:sched_switch",	      process_sched_switch_event, },
@@ -1646,7 +1612,7 @@ static int read_events(bool destroy, struct perf_session **psession)
 	};
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_sched);
+	session = perf_session__new(sched->input_name, O_RDONLY, 0, false, &sched->tool);
 	if (session == NULL) {
 		pr_debug("No Memory for session\n");
 		return -1;
@@ -1656,15 +1622,15 @@ static int read_events(bool destroy, struct perf_session **psession)
 		goto out_delete;
 
 	if (perf_session__has_traces(session, "record -R")) {
-		int err = perf_session__process_events(session, &perf_sched);
+		int err = perf_session__process_events(session, &sched->tool);
 		if (err) {
 			pr_err("Failed to process events, error %d", err);
 			goto out_delete;
 		}
 
-		nr_events      = session->hists.stats.nr_events[0];
-		nr_lost_events = session->hists.stats.total_lost;
-		nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
+		sched->nr_events      = session->hists.stats.nr_events[0];
+		sched->nr_lost_events = session->hists.stats.total_lost;
+		sched->nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
 	}
 
 	if (destroy)
@@ -1680,213 +1646,158 @@ out_delete:
 	return -1;
 }
 
-static void print_bad_events(void)
+static void print_bad_events(struct perf_sched *sched)
 {
-	if (nr_unordered_timestamps && nr_timestamps) {
+	if (sched->nr_unordered_timestamps && sched->nr_timestamps) {
 		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
-			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
-			nr_unordered_timestamps, nr_timestamps);
+			(double)sched->nr_unordered_timestamps/(double)sched->nr_timestamps*100.0,
+			sched->nr_unordered_timestamps, sched->nr_timestamps);
 	}
-	if (nr_lost_events && nr_events) {
+	if (sched->nr_lost_events && sched->nr_events) {
 		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
-			(double)nr_lost_events/(double)nr_events*100.0,
-			nr_lost_events, nr_events, nr_lost_chunks);
+			(double)sched->nr_lost_events/(double)sched->nr_events * 100.0,
+			sched->nr_lost_events, sched->nr_events, sched->nr_lost_chunks);
 	}
-	if (nr_state_machine_bugs && nr_timestamps) {
+	if (sched->nr_state_machine_bugs && sched->nr_timestamps) {
 		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
-			(double)nr_state_machine_bugs/(double)nr_timestamps*100.0,
-			nr_state_machine_bugs, nr_timestamps);
-		if (nr_lost_events)
+			(double)sched->nr_state_machine_bugs/(double)sched->nr_timestamps*100.0,
+			sched->nr_state_machine_bugs, sched->nr_timestamps);
+		if (sched->nr_lost_events)
 			printf(" (due to lost events?)");
 		printf("\n");
 	}
-	if (nr_context_switch_bugs && nr_timestamps) {
+	if (sched->nr_context_switch_bugs && sched->nr_timestamps) {
 		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
-			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
-			nr_context_switch_bugs, nr_timestamps);
-		if (nr_lost_events)
+			(double)sched->nr_context_switch_bugs/(double)sched->nr_timestamps*100.0,
+			sched->nr_context_switch_bugs, sched->nr_timestamps);
+		if (sched->nr_lost_events)
 			printf(" (due to lost events?)");
 		printf("\n");
 	}
 }
 
-static int __cmd_lat(void)
+static int perf_sched__lat(struct perf_sched *sched)
 {
 	struct rb_node *next;
 	struct perf_session *session;
 
 	setup_pager();
-	if (read_events(false, &session))
+	if (perf_sched__read_events(sched, false, &session))
 		return -1;
-	sort_lat();
+	perf_sched__sort_lat(sched);
 
 	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
 	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |\n");
 	printf(" ---------------------------------------------------------------------------------------------------------------\n");
 
-	next = rb_first(&sorted_atom_root);
+	next = rb_first(&sched->sorted_atom_root);
 
 	while (next) {
 		struct work_atoms *work_list;
 
 		work_list = rb_entry(next, struct work_atoms, node);
-		output_lat_thread(work_list);
+		output_lat_thread(sched, work_list);
 		next = rb_next(next);
 	}
 
 	printf(" -----------------------------------------------------------------------------------------\n");
 	printf("  TOTAL:                |%11.3f ms |%9" PRIu64 " |\n",
-		(double)all_runtime/1e6, all_count);
+		(double)sched->all_runtime / 1e6, sched->all_count);
 
 	printf(" ---------------------------------------------------\n");
 
-	print_bad_events();
+	print_bad_events(sched);
 	printf("\n");
 
 	perf_session__delete(session);
 	return 0;
 }
 
-static struct trace_sched_handler map_ops  = {
-	.wakeup_event		= NULL,
-	.switch_event		= map_switch_event,
-	.runtime_event		= NULL,
-	.fork_event		= NULL,
-};
-
-static int __cmd_map(void)
+static int perf_sched__map(struct perf_sched *sched)
 {
-	max_cpu = sysconf(_SC_NPROCESSORS_CONF);
+	sched->max_cpu = sysconf(_SC_NPROCESSORS_CONF);
 
 	setup_pager();
-	if (read_events(true, NULL))
+	if (perf_sched__read_events(sched, true, NULL))
 		return -1;
-	print_bad_events();
+	print_bad_events(sched);
 	return 0;
 }
 
-static int __cmd_replay(void)
+static int perf_sched__replay(struct perf_sched *sched)
 {
 	unsigned long i;
 
-	calibrate_run_measurement_overhead();
-	calibrate_sleep_measurement_overhead();
+	calibrate_run_measurement_overhead(sched);
+	calibrate_sleep_measurement_overhead(sched);
 
-	test_calibrations();
+	test_calibrations(sched);
 
-	if (read_events(true, NULL))
+	if (perf_sched__read_events(sched, true, NULL))
 		return -1;
 
-	printf("nr_run_events:        %ld\n", nr_run_events);
-	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
-	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+	printf("nr_run_events:        %ld\n", sched->nr_run_events);
+	printf("nr_sleep_events:      %ld\n", sched->nr_sleep_events);
+	printf("nr_wakeup_events:     %ld\n", sched->nr_wakeup_events);
 
-	if (targetless_wakeups)
-		printf("target-less wakeups:  %ld\n", targetless_wakeups);
-	if (multitarget_wakeups)
-		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
-	if (nr_run_events_optimized)
+	if (sched->targetless_wakeups)
+		printf("target-less wakeups:  %ld\n", sched->targetless_wakeups);
+	if (sched->multitarget_wakeups)
+		printf("multi-target wakeups: %ld\n", sched->multitarget_wakeups);
+	if (sched->nr_run_events_optimized)
 		printf("run atoms optimized: %ld\n",
-			nr_run_events_optimized);
+			sched->nr_run_events_optimized);
 
-	print_task_traces();
-	add_cross_task_wakeups();
+	print_task_traces(sched);
+	add_cross_task_wakeups(sched);
 
-	create_tasks();
+	create_tasks(sched);
 	printf("------------------------------------------------------------\n");
-	for (i = 0; i < replay_repeat; i++)
-		run_one_test();
+	for (i = 0; i < sched->replay_repeat; i++)
+		run_one_test(sched);
 
 	return 0;
 }
 
-
-static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|map|replay|script}",
-	NULL
-};
-
-static const struct option sched_options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
-		    "dump raw trace in ASCII"),
-	OPT_END()
-};
-
-static const char * const latency_usage[] = {
-	"perf sched latency [<options>]",
-	NULL
-};
-
-static const struct option latency_options[] = {
-	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): runtime, switch, avg, max"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
-	OPT_INTEGER('C', "CPU", &profile_cpu,
-		    "CPU to profile on"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
-		    "dump raw trace in ASCII"),
-	OPT_END()
-};
-
-static const char * const replay_usage[] = {
-	"perf sched replay [<options>]",
-	NULL
-};
-
-static const struct option replay_options[] = {
-	OPT_UINTEGER('r', "repeat", &replay_repeat,
-		     "repeat the workload replay N times (-1: infinite)"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
-		    "dump raw trace in ASCII"),
-	OPT_END()
-};
-
-static void setup_sorting(void)
+static void setup_sorting(struct perf_sched *sched, const struct option *options,
+			  const char * const usage_msg[])
 {
-	char *tmp, *tok, *str = strdup(sort_order);
+	char *tmp, *tok, *str = strdup(sched->sort_order);
 
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok, &sort_list) < 0) {
+		if (sort_dimension__add(tok, &sched->sort_list) < 0) {
 			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(latency_usage, latency_options);
+			usage_with_options(usage_msg, options);
 		}
 	}
 
 	free(str);
 
-	sort_dimension__add("pid", &cmp_pid);
+	sort_dimension__add("pid", &sched->cmp_pid);
 }
 
-static const char *record_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-m", "1024",
-	"-c", "1",
-	"-e", "sched:sched_switch",
-	"-e", "sched:sched_stat_wait",
-	"-e", "sched:sched_stat_sleep",
-	"-e", "sched:sched_stat_iowait",
-	"-e", "sched:sched_stat_runtime",
-	"-e", "sched:sched_process_exit",
-	"-e", "sched:sched_process_fork",
-	"-e", "sched:sched_wakeup",
-	"-e", "sched:sched_migrate_task",
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
+	const char * const record_args[] = {
+		"record",
+		"-a",
+		"-R",
+		"-f",
+		"-m", "1024",
+		"-c", "1",
+		"-e", "sched:sched_switch",
+		"-e", "sched:sched_stat_wait",
+		"-e", "sched:sched_stat_sleep",
+		"-e", "sched:sched_stat_iowait",
+		"-e", "sched:sched_stat_runtime",
+		"-e", "sched:sched_process_exit",
+		"-e", "sched:sched_process_fork",
+		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_migrate_task",
+	};
 
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
@@ -1907,6 +1818,83 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	const char default_sort_order[] = "avg, max, switch, runtime";
+	struct perf_sched sched = {
+		.tool = {
+			.sample		 = perf_sched__process_tracepoint_sample,
+			.comm		 = perf_event__process_comm,
+			.lost		 = perf_event__process_lost,
+			.fork		 = perf_event__process_task,
+			.ordered_samples = true,
+		},
+		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
+		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
+		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
+		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
+		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
+		.sort_order	      = default_sort_order,
+		.replay_repeat	      = 10,
+		.profile_cpu	      = -1,
+		.next_shortname1      = 'A',
+		.next_shortname2      = '0',
+	};
+	const struct option latency_options[] = {
+	OPT_STRING('s', "sort", &sched.sort_order, "key[,key2...]",
+		   "sort by key(s): runtime, switch, avg, max"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_INTEGER('C', "CPU", &sched.profile_cpu,
+		    "CPU to profile on"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+	};
+	const struct option replay_options[] = {
+	OPT_UINTEGER('r', "repeat", &sched.replay_repeat,
+		     "repeat the workload replay N times (-1: infinite)"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+	};
+	const struct option sched_options[] = {
+	OPT_STRING('i', "input", &sched.input_name, "file",
+		    "input file name"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+	};
+	const char * const latency_usage[] = {
+		"perf sched latency [<options>]",
+		NULL
+	};
+	const char * const replay_usage[] = {
+		"perf sched replay [<options>]",
+		NULL
+	};
+	const char * const sched_usage[] = {
+		"perf sched [<options>] {record|latency|map|replay|script}",
+		NULL
+	};
+	struct trace_sched_handler lat_ops  = {
+		.wakeup_event	    = latency_wakeup_event,
+		.switch_event	    = latency_switch_event,
+		.runtime_event	    = latency_runtime_event,
+		.fork_event	    = latency_fork_event,
+		.migrate_task_event = latency_migrate_task_event,
+	};
+	struct trace_sched_handler map_ops  = {
+		.switch_event	    = map_switch_event,
+	};
+	struct trace_sched_handler replay_ops  = {
+		.wakeup_event	    = replay_wakeup_event,
+		.switch_event	    = replay_switch_event,
+		.fork_event	    = replay_fork_event,
+	};
+
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
@@ -1922,26 +1910,26 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
-		trace_handler = &lat_ops;
+		sched.tp_handler = &lat_ops;
 		if (argc > 1) {
 			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
 			if (argc)
 				usage_with_options(latency_usage, latency_options);
 		}
-		setup_sorting();
-		return __cmd_lat();
+		setup_sorting(&sched, latency_options, latency_usage);
+		return perf_sched__lat(&sched);
 	} else if (!strcmp(argv[0], "map")) {
-		trace_handler = &map_ops;
-		setup_sorting();
-		return __cmd_map();
+		sched.tp_handler = &map_ops;
+		setup_sorting(&sched, latency_options, latency_usage);
+		return perf_sched__map(&sched);
 	} else if (!strncmp(argv[0], "rep", 3)) {
-		trace_handler = &replay_ops;
+		sched.tp_handler = &replay_ops;
 		if (argc) {
 			argc = parse_options(argc, argv, replay_options, replay_usage, 0);
 			if (argc)
 				usage_with_options(replay_usage, replay_options);
 		}
-		return __cmd_replay();
+		return perf_sched__replay(&sched);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
-- 
1.7.9.2.358.g22243

