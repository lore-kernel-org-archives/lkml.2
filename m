Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2IKX4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:56:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:42274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2IKXxY (ORCPT
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
Subject: [PATCH 02/18] perf sched: Remove die() calls
Date: Tue, 11 Sep 2012 20:52:54 -0300
Message-Id: <1347407590-30960-3-git-send-email-acme@infradead.org>
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

Just use pr_err() + return -1 and perf_session__process_events to abort
when some event would call die(), then let the perf's main() exit doing
whatever it needs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-88cwdogxqomsy9tfr8r0as58@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |  281 ++++++++++++++++++++++++++++----------------
 1 file changed, 179 insertions(+), 102 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a25a023..782f66d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -423,8 +423,8 @@ static int self_open_counters(void)
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 
 	if (fd < 0)
-		die("Error: sys_perf_event_open() syscall returned"
-		    "with %d (%s)\n", fd, strerror(errno));
+		pr_debug("Error: sys_perf_event_open() syscall returned"
+			 "with %d (%s)\n", fd, strerror(errno));
 	return fd;
 }
 
@@ -450,7 +450,8 @@ static void *thread_func(void *ctx)
 	sprintf(comm2, ":%s", this_task->comm);
 	prctl(PR_SET_NAME, comm2);
 	fd = self_open_counters();
-
+	if (fd < 0)
+		return NULL;
 again:
 	ret = sem_post(&this_task->ready_for_work);
 	BUG_ON(ret);
@@ -726,30 +727,30 @@ struct trace_migrate_task_event {
 };
 
 struct trace_sched_handler {
-	void (*switch_event)(struct trace_switch_event *,
-			     struct machine *,
-			     struct event_format *,
-			     struct perf_sample *sample);
-
-	void (*runtime_event)(struct trace_runtime_event *,
-			      struct machine *,
-			      struct perf_sample *sample);
+	int (*switch_event)(struct trace_switch_event *event,
+			    struct machine *machine,
+			    struct event_format *tp_format,
+			    struct perf_sample *sample);
 
-	void (*wakeup_event)(struct trace_wakeup_event *,
-			     struct machine *,
-			     struct event_format *,
+	int (*runtime_event)(struct trace_runtime_event *event,
+			     struct machine *machine,
 			     struct perf_sample *sample);
 
-	void (*fork_event)(struct trace_fork_event *,
-			   struct event_format *event);
+	int (*wakeup_event)(struct trace_wakeup_event *event,
+			    struct machine *machine,
+			    struct event_format *tp_format,
+			    struct perf_sample *sample);
 
-	void (*migrate_task_event)(struct trace_migrate_task_event *,
-				   struct machine *machine,
-				   struct perf_sample *sample);
+	int (*fork_event)(struct trace_fork_event *event,
+			  struct event_format *tp_format);
+
+	int (*migrate_task_event)(struct trace_migrate_task_event *event,
+				  struct machine *machine,
+				  struct perf_sample *sample);
 };
 
 
-static void
+static int
 replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		    struct machine *machine __used,
 		    struct event_format *event, struct perf_sample *sample)
@@ -769,11 +770,12 @@ replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
 
 	add_sched_event_wakeup(waker, sample->time, wakee);
+	return 0;
 }
 
 static u64 cpu_last_switched[MAX_CPUS];
 
-static void
+static int
 replay_switch_event(struct trace_switch_event *switch_event,
 		    struct machine *machine __used,
 		    struct event_format *event,
@@ -788,7 +790,7 @@ replay_switch_event(struct trace_switch_event *switch_event,
 		printf("sched_switch event %p\n", event);
 
 	if (cpu >= MAX_CPUS || cpu < 0)
-		return;
+		return 0;
 
 	timestamp0 = cpu_last_switched[cpu];
 	if (timestamp0)
@@ -796,8 +798,10 @@ replay_switch_event(struct trace_switch_event *switch_event,
 	else
 		delta = 0;
 
-	if (delta < 0)
-		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
+	if (delta < 0) {
+		pr_debug("hm, delta: %" PRIu64 " < 0 ?\n", delta);
+		return -1;
+	}
 
 	if (verbose) {
 		printf(" ... switch from %s/%d to %s/%d [ran %" PRIu64 " nsecs]\n",
@@ -813,10 +817,12 @@ replay_switch_event(struct trace_switch_event *switch_event,
 
 	add_sched_event_run(prev, timestamp, delta);
 	add_sched_event_sleep(prev, timestamp, switch_event->prev_state);
+
+	return 0;
 }
 
 
-static void
+static int
 replay_fork_event(struct trace_fork_event *fork_event,
 		  struct event_format *event)
 {
@@ -827,6 +833,7 @@ replay_fork_event(struct trace_fork_event *fork_event,
 	}
 	register_pid(fork_event->parent_pid, fork_event->parent_comm);
 	register_pid(fork_event->child_pid, fork_event->child_comm);
+	return 0;
 }
 
 static struct trace_sched_handler replay_ops  = {
@@ -911,22 +918,26 @@ __thread_latency_insert(struct rb_root *root, struct work_atoms *data,
 	rb_insert_color(&data->node, root);
 }
 
-static void thread_atoms_insert(struct thread *thread)
+static int thread_atoms_insert(struct thread *thread)
 {
 	struct work_atoms *atoms = zalloc(sizeof(*atoms));
-	if (!atoms)
-		die("No memory");
+	if (!atoms) {
+		pr_err("No memory at %s\n", __func__);
+		return -1;
+	}
 
 	atoms->thread = thread;
 	INIT_LIST_HEAD(&atoms->work_list);
 	__thread_latency_insert(&atom_root, atoms, &cmp_pid);
+	return 0;
 }
 
-static void
+static int
 latency_fork_event(struct trace_fork_event *fork_event __used,
 		   struct event_format *event __used)
 {
 	/* should insert the newcomer */
+	return 0;
 }
 
 __used
@@ -937,14 +948,16 @@ static char sched_out_state(struct trace_switch_event *switch_event)
 	return str[switch_event->prev_state];
 }
 
-static void
+static int
 add_sched_out_event(struct work_atoms *atoms,
 		    char run_state,
 		    u64 timestamp)
 {
 	struct work_atom *atom = zalloc(sizeof(*atom));
-	if (!atom)
-		die("Non memory");
+	if (!atom) {
+		pr_err("Non memory at %s", __func__);
+		return -1;
+	}
 
 	atom->sched_out_time = timestamp;
 
@@ -954,6 +967,7 @@ add_sched_out_event(struct work_atoms *atoms,
 	}
 
 	list_add_tail(&atom->list, &atoms->work_list);
+	return 0;
 }
 
 static void
@@ -1000,7 +1014,7 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 	atoms->nb_atoms++;
 }
 
-static void
+static int
 latency_switch_event(struct trace_switch_event *switch_event,
 		     struct machine *machine,
 		     struct event_format *event __used,
@@ -1021,38 +1035,49 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	else
 		delta = 0;
 
-	if (delta < 0)
-		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
-
+	if (delta < 0) {
+		pr_err("hm, delta: %" PRIu64 " < 0 ?\n", delta);
+		return -1;
+	}
 
 	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
 	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
-		thread_atoms_insert(sched_out);
+		if (thread_atoms_insert(sched_out))
+			return -1;
 		out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
-		if (!out_events)
-			die("out-event: Internal tree error");
+		if (!out_events) {
+			pr_err("out-event: Internal tree error");
+			return -1;
+		}
 	}
-	add_sched_out_event(out_events, sched_out_state(switch_event), timestamp);
+	if (add_sched_out_event(out_events, sched_out_state(switch_event), timestamp))
+		return -1;
 
 	in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
 	if (!in_events) {
-		thread_atoms_insert(sched_in);
+		if (thread_atoms_insert(sched_in))
+			return -1;
 		in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
-		if (!in_events)
-			die("in-event: Internal tree error");
+		if (!in_events) {
+			pr_err("in-event: Internal tree error");
+			return -1;
+		}
 		/*
 		 * Take came in we have not heard about yet,
 		 * add in an initial atom in runnable state:
 		 */
-		add_sched_out_event(in_events, 'R', timestamp);
+		if (add_sched_out_event(in_events, 'R', timestamp))
+			return -1;
 	}
 	add_sched_in_event(in_events, timestamp);
+
+	return 0;
 }
 
-static void
+static int
 latency_runtime_event(struct trace_runtime_event *runtime_event,
 		      struct machine *machine, struct perf_sample *sample)
 {
@@ -1063,17 +1088,22 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
 	if (!atoms) {
-		thread_atoms_insert(thread);
+		if (thread_atoms_insert(thread))
+			return -1;
 		atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
-		if (!atoms)
-			die("in-event: Internal tree error");
-		add_sched_out_event(atoms, 'R', timestamp);
+		if (!atoms) {
+			pr_debug("in-event: Internal tree error");
+			return -1;
+		}
+		if (add_sched_out_event(atoms, 'R', timestamp))
+			return -1;
 	}
 
 	add_runtime_event(atoms, runtime_event->runtime, timestamp);
+	return 0;
 }
 
-static void
+static int
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		     struct machine *machine, struct event_format *event __used,
 		     struct perf_sample *sample)
@@ -1085,16 +1115,20 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 	/* Note for later, it may be interesting to observe the failing cases */
 	if (!wakeup_event->success)
-		return;
+		return 0;
 
 	wakee = machine__findnew_thread(machine, wakeup_event->pid);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
-		thread_atoms_insert(wakee);
+		if (thread_atoms_insert(wakee))
+			return -1;
 		atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
-		if (!atoms)
-			die("wakeup-event: Internal tree error");
-		add_sched_out_event(atoms, 'S', timestamp);
+		if (!atoms) {
+			pr_debug("wakeup-event: Internal tree error");
+			return -1;
+		}
+		if (add_sched_out_event(atoms, 'S', timestamp))
+			return -1;
 	}
 
 	BUG_ON(list_empty(&atoms->work_list));
@@ -1112,14 +1146,15 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	nr_timestamps++;
 	if (atom->sched_out_time > timestamp) {
 		nr_unordered_timestamps++;
-		return;
+		return 0;
 	}
 
 	atom->state = THREAD_WAIT_CPU;
 	atom->wake_up_time = timestamp;
+	return 0;
 }
 
-static void
+static int
 latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 			   struct machine *machine, struct perf_sample *sample)
 {
@@ -1132,17 +1167,21 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	 * Only need to worry about migration when profiling one CPU.
 	 */
 	if (profile_cpu == -1)
-		return;
+		return 0;
 
 	migrant = machine__findnew_thread(machine, migrate_task_event->pid);
 	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
 	if (!atoms) {
-		thread_atoms_insert(migrant);
+		if (thread_atoms_insert(migrant))
+			return -1;
 		register_pid(migrant->pid, migrant->comm);
 		atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
-		if (!atoms)
-			die("migration-event: Internal tree error");
-		add_sched_out_event(atoms, 'R', timestamp);
+		if (!atoms) {
+			pr_debug("migration-event: Internal tree error");
+			return -1;
+		}
+		if (add_sched_out_event(atoms, 'R', timestamp))
+			return -1;
 	}
 
 	BUG_ON(list_empty(&atoms->work_list));
@@ -1154,6 +1193,8 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 
 	if (atom->sched_out_time > timestamp)
 		nr_unordered_timestamps++;
+
+	return 0;
 }
 
 static struct trace_sched_handler lat_ops  = {
@@ -1328,7 +1369,7 @@ static void sort_lat(void)
 
 static struct trace_sched_handler *trace_handler;
 
-static void
+static int
 process_sched_wakeup_event(struct perf_tool *tool __used,
 			   struct event_format *event,
 			   struct perf_sample *sample,
@@ -1337,6 +1378,7 @@ process_sched_wakeup_event(struct perf_tool *tool __used,
 {
 	void *data = sample->raw_data;
 	struct trace_wakeup_event wakeup_event;
+	int err = 0;
 
 	FILL_COMMON_FIELDS(wakeup_event, event, data);
 
@@ -1347,7 +1389,9 @@ process_sched_wakeup_event(struct perf_tool *tool __used,
 	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
-		trace_handler->wakeup_event(&wakeup_event, machine, event, sample);
+		err = trace_handler->wakeup_event(&wakeup_event, machine, event, sample);
+
+	return err;
 }
 
 /*
@@ -1363,7 +1407,7 @@ static struct thread *curr_thread[MAX_CPUS];
 static char next_shortname1 = 'A';
 static char next_shortname2 = '0';
 
-static void
+static int
 map_switch_event(struct trace_switch_event *switch_event,
 		 struct machine *machine,
 		 struct event_format *event __used,
@@ -1387,9 +1431,10 @@ map_switch_event(struct trace_switch_event *switch_event,
 	else
 		delta = 0;
 
-	if (delta < 0)
-		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
-
+	if (delta < 0) {
+		pr_debug("hm, delta: %" PRIu64 " < 0 ?\n", delta);
+		return -1;
+	}
 
 	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
 	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
@@ -1438,16 +1483,18 @@ map_switch_event(struct trace_switch_event *switch_event,
 	} else {
 		printf("\n");
 	}
+
+	return 0;
 }
 
-static void
+static int
 process_sched_switch_event(struct perf_tool *tool __used,
 			   struct event_format *event,
 			   struct perf_sample *sample,
 			   struct machine *machine,
 			   struct thread *thread __used)
 {
-	int this_cpu = sample->cpu;
+	int this_cpu = sample->cpu, err = 0;
 	void *data = sample->raw_data;
 	struct trace_switch_event switch_event;
 
@@ -1470,12 +1517,13 @@ process_sched_switch_event(struct perf_tool *tool __used,
 			nr_context_switch_bugs++;
 	}
 	if (trace_handler->switch_event)
-		trace_handler->switch_event(&switch_event, machine, event, sample);
+		err = trace_handler->switch_event(&switch_event, machine, event, sample);
 
 	curr_pid[this_cpu] = switch_event.next_pid;
+	return err;
 }
 
-static void
+static int
 process_sched_runtime_event(struct perf_tool *tool __used,
 			    struct event_format *event,
 			    struct perf_sample *sample,
@@ -1484,6 +1532,7 @@ process_sched_runtime_event(struct perf_tool *tool __used,
 {
 	void *data = sample->raw_data;
 	struct trace_runtime_event runtime_event;
+	int err = 0;
 
 	FILL_ARRAY(runtime_event, comm, event, data);
 	FILL_FIELD(runtime_event, pid, event, data);
@@ -1491,10 +1540,12 @@ process_sched_runtime_event(struct perf_tool *tool __used,
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
-		trace_handler->runtime_event(&runtime_event, machine, sample);
+		err = trace_handler->runtime_event(&runtime_event, machine, sample);
+
+	return err;
 }
 
-static void
+static int
 process_sched_fork_event(struct perf_tool *tool __used,
 			 struct event_format *event,
 			 struct perf_sample *sample,
@@ -1503,6 +1554,7 @@ process_sched_fork_event(struct perf_tool *tool __used,
 {
 	void *data = sample->raw_data;
 	struct trace_fork_event fork_event;
+	int err = 0;
 
 	FILL_COMMON_FIELDS(fork_event, event, data);
 
@@ -1512,10 +1564,12 @@ process_sched_fork_event(struct perf_tool *tool __used,
 	FILL_FIELD(fork_event, child_pid, event, data);
 
 	if (trace_handler->fork_event)
-		trace_handler->fork_event(&fork_event, event);
+		err = trace_handler->fork_event(&fork_event, event);
+
+	return err;
 }
 
-static void
+static int
 process_sched_exit_event(struct perf_tool *tool __used,
 			 struct event_format *event,
 			 struct perf_sample *sample __used,
@@ -1524,9 +1578,11 @@ process_sched_exit_event(struct perf_tool *tool __used,
 {
 	if (verbose)
 		printf("sched_exit event %p\n", event);
+
+	return 0;
 }
 
-static void
+static int
 process_sched_migrate_task_event(struct perf_tool *tool __used,
 				 struct event_format *event,
 				 struct perf_sample *sample,
@@ -1535,6 +1591,7 @@ process_sched_migrate_task_event(struct perf_tool *tool __used,
 {
 	void *data = sample->raw_data;
 	struct trace_migrate_task_event migrate_task_event;
+	int err = 0;
 
 	FILL_COMMON_FIELDS(migrate_task_event, event, data);
 
@@ -1544,13 +1601,16 @@ process_sched_migrate_task_event(struct perf_tool *tool __used,
 	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
-		trace_handler->migrate_task_event(&migrate_task_event, machine, sample);
+		err = trace_handler->migrate_task_event(&migrate_task_event, machine, sample);
+
+	return err;
 }
 
-typedef void (*tracepoint_handler)(struct perf_tool *tool, struct event_format *event,
-				   struct perf_sample *sample,
-				   struct machine *machine,
-				   struct thread *thread);
+typedef int (*tracepoint_handler)(struct perf_tool *tool,
+				  struct event_format *tp_format,
+				  struct perf_sample *sample,
+				  struct machine *machine,
+				  struct thread *thread);
 
 static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
 						 union perf_event *event __used,
@@ -1559,6 +1619,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
 						 struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->pid);
+	int err = 0;
 
 	if (thread == NULL) {
 		pr_debug("problem processing %s event, skipping it.\n",
@@ -1571,10 +1632,10 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __used,
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
-		f(tool, evsel->tp_format, sample, machine, thread);
+		err = f(tool, evsel->tp_format, sample, machine, thread);
 	}
 
-	return 0;
+	return err;
 }
 
 static struct perf_tool perf_sched = {
@@ -1585,9 +1646,8 @@ static struct perf_tool perf_sched = {
 	.ordered_samples = true,
 };
 
-static void read_events(bool destroy, struct perf_session **psession)
+static int read_events(bool destroy, struct perf_session **psession)
 {
-	int err = -EINVAL;
 	const struct perf_evsel_str_handler handlers[] = {
 		{ "sched:sched_switch",	      process_sched_switch_event, },
 		{ "sched:sched_stat_runtime", process_sched_runtime_event, },
@@ -1600,16 +1660,20 @@ static void read_events(bool destroy, struct perf_session **psession)
 	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_sched);
-	if (session == NULL)
-		die("No Memory");
+	if (session == NULL) {
+		pr_debug("No Memory for session\n");
+		return -1;
+	}
 
-	err = perf_session__set_tracepoints_handlers(session, handlers);
-	assert(err == 0);
+	if (perf_session__set_tracepoints_handlers(session, handlers))
+		goto out_delete;
 
 	if (perf_session__has_traces(session, "record -R")) {
-		err = perf_session__process_events(session, &perf_sched);
-		if (err)
-			die("Failed to process events, error %d", err);
+		int err = perf_session__process_events(session, &perf_sched);
+		if (err) {
+			pr_err("Failed to process events, error %d", err);
+			goto out_delete;
+		}
 
 		nr_events      = session->hists.stats.nr_events[0];
 		nr_lost_events = session->hists.stats.total_lost;
@@ -1621,6 +1685,12 @@ static void read_events(bool destroy, struct perf_session **psession)
 
 	if (psession)
 		*psession = session;
+
+	return 0;
+
+out_delete:
+	perf_session__delete(session);
+	return -1;
 }
 
 static void print_bad_events(void)
@@ -1653,13 +1723,14 @@ static void print_bad_events(void)
 	}
 }
 
-static void __cmd_lat(void)
+static int __cmd_lat(void)
 {
 	struct rb_node *next;
 	struct perf_session *session;
 
 	setup_pager();
-	read_events(false, &session);
+	if (read_events(false, &session))
+		return -1;
 	sort_lat();
 
 	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
@@ -1686,6 +1757,7 @@ static void __cmd_lat(void)
 	printf("\n");
 
 	perf_session__delete(session);
+	return 0;
 }
 
 static struct trace_sched_handler map_ops  = {
@@ -1695,16 +1767,18 @@ static struct trace_sched_handler map_ops  = {
 	.fork_event		= NULL,
 };
 
-static void __cmd_map(void)
+static int __cmd_map(void)
 {
 	max_cpu = sysconf(_SC_NPROCESSORS_CONF);
 
 	setup_pager();
-	read_events(true, NULL);
+	if (read_events(true, NULL))
+		return -1;
 	print_bad_events();
+	return 0;
 }
 
-static void __cmd_replay(void)
+static int __cmd_replay(void)
 {
 	unsigned long i;
 
@@ -1713,7 +1787,8 @@ static void __cmd_replay(void)
 
 	test_calibrations();
 
-	read_events(true, NULL);
+	if (read_events(true, NULL))
+		return -1;
 
 	printf("nr_run_events:        %ld\n", nr_run_events);
 	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
@@ -1734,6 +1809,8 @@ static void __cmd_replay(void)
 	printf("------------------------------------------------------------\n");
 	for (i = 0; i < replay_repeat; i++)
 		run_one_test();
+
+	return 0;
 }
 
 
@@ -1865,11 +1942,11 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 				usage_with_options(latency_usage, latency_options);
 		}
 		setup_sorting();
-		__cmd_lat();
+		return __cmd_lat();
 	} else if (!strcmp(argv[0], "map")) {
 		trace_handler = &map_ops;
 		setup_sorting();
-		__cmd_map();
+		return __cmd_map();
 	} else if (!strncmp(argv[0], "rep", 3)) {
 		trace_handler = &replay_ops;
 		if (argc) {
@@ -1877,7 +1954,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 			if (argc)
 				usage_with_options(replay_usage, replay_options);
 		}
-		__cmd_replay();
+		return __cmd_replay();
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
-- 
1.7.9.2.358.g22243

