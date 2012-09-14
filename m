Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2INGHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:07:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2INGHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:07:08 -0400
Date: Thu, 13 Sep 2012 23:06:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-kracdpw8wqlr0xjh75uk8g11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Don'
 t read all tracepoint variables in advance
Git-Commit-ID: 9ec3f4e437ede2f3b5087d412abe16a0219b3b99
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:06:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ec3f4e437ede2f3b5087d412abe16a0219b3b99
Gitweb:     http://git.kernel.org/tip/9ec3f4e437ede2f3b5087d412abe16a0219b3b99
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Sep 2012 19:29:17 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 20:39:19 -0300

perf sched: Don't read all tracepoint variables in advance

Do it just at the actual consumer of these fields, that way we avoid
needless lookups:

  [root@sandy ~]# perf sched record sleep 30s
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 8.585 MB perf.data (~375063 samples) ]

Before:

  [root@sandy ~]# perf stat -r 10 perf sched lat > /dev/null

   Performance counter stats for 'perf sched lat' (10 runs):

          103.592215 task-clock                #    0.993 CPUs utilized            ( +-  0.33% )
                  12 context-switches          #    0.114 K/sec                    ( +-  3.29% )
                   0 cpu-migrations            #    0.000 K/sec
               7,605 page-faults               #    0.073 M/sec                    ( +-  0.00% )
         345,796,112 cycles                    #    3.338 GHz                      ( +-  0.07% ) [82.90%]
         106,876,796 stalled-cycles-frontend   #   30.91% frontend cycles idle     ( +-  0.38% ) [83.23%]
          62,060,877 stalled-cycles-backend    #   17.95% backend  cycles idle     ( +-  0.80% ) [67.14%]
         628,246,586 instructions              #    1.82  insns per cycle
                                               #    0.17  stalled cycles per insn  ( +-  0.04% ) [83.64%]
         134,962,057 branches                  # 1302.820 M/sec                    ( +-  0.10% ) [83.64%]
           1,233,037 branch-misses             #    0.91% of all branches          ( +-  0.29% ) [83.41%]

         0.104333272 seconds time elapsed                                          ( +-  0.33% )

  [root@sandy ~]# perf stat -r 10 perf sched lat > /dev/null

   Performance counter stats for 'perf sched lat' (10 runs):

         98.848272 task-clock                #    0.993 CPUs utilized            ( +-  0.48% )
                11 context-switches          #    0.112 K/sec                    ( +-  2.83% )
                 0 cpu-migrations            #    0.003 K/sec                    ( +- 50.92% )
             7,604 page-faults               #    0.077 M/sec                    ( +-  0.00% )
       332,216,085 cycles                    #    3.361 GHz                      ( +-  0.14% ) [82.87%]
       100,623,710 stalled-cycles-frontend   #   30.29% frontend cycles idle     ( +-  0.53% ) [82.95%]
        58,788,692 stalled-cycles-backend    #   17.70% backend  cycles idle     ( +-  0.59% ) [67.15%]
       609,402,433 instructions              #    1.83  insns per cycle
                                             #    0.17  stalled cycles per insn  ( +-  0.04% ) [83.76%]
       131,277,138 branches                  # 1328.067 M/sec                    ( +-  0.06% ) [83.77%]
         1,117,871 branch-misses             #    0.85% of all branches          ( +-  0.32% ) [83.51%]

       0.099580430 seconds time elapsed                                          ( +-  0.48% )

  [root@sandy ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-kracdpw8wqlr0xjh75uk8g11@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |  277 +++++++++++++++----------------------------
 1 files changed, 97 insertions(+), 180 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0df5e7a..af305f5 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -97,73 +97,25 @@ struct work_atoms {
 
 typedef int (*sort_fn_t)(struct work_atoms *, struct work_atoms *);
 
-struct trace_switch_event {
-	char *prev_comm;
-	u32  prev_pid;
-	u32  prev_prio;
-	u64  prev_state;
-	char *next_comm;
-	u32  next_pid;
-	u32  next_prio;
-};
-
-struct trace_runtime_event {
-	char *comm;
-	u32  pid;
-	u64  runtime;
-	u64  vruntime;
-};
+struct perf_sched;
 
-struct trace_wakeup_event {
-	char *comm;
-	u32  pid;
-	u32  prio;
-	u32  success;
-	u32  cpu;
-};
+struct trace_sched_handler {
+	int (*switch_event)(struct perf_sched *sched, struct perf_evsel *evsel,
+			    struct perf_sample *sample, struct machine *machine);
 
-struct trace_fork_event {
-	char *parent_comm;
-	u32  parent_pid;
-	char *child_comm;
-	u32   child_pid;
-};
+	int (*runtime_event)(struct perf_sched *sched, struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct machine *machine);
 
-struct trace_migrate_task_event {
-	char *comm;
-	u32  pid;
-	u32  prio;
-	u32  cpu;
-};
+	int (*wakeup_event)(struct perf_sched *sched, struct perf_evsel *evsel,
+			    struct perf_sample *sample, struct machine *machine);
 
-struct perf_sched;
-
-struct trace_sched_handler {
-	int (*switch_event)(struct perf_sched *sched,
-			    struct trace_switch_event *event,
-			    struct machine *machine,
-			    struct perf_evsel *evsel,
-			    struct perf_sample *sample);
-
-	int (*runtime_event)(struct perf_sched *sched,
-			     struct trace_runtime_event *event,
-			     struct machine *machine,
-			     struct perf_sample *sample);
-
-	int (*wakeup_event)(struct perf_sched *sched,
-			    struct trace_wakeup_event *event,
-			    struct machine *machine,
-			    struct perf_evsel *evsel,
-			    struct perf_sample *sample);
-
-	int (*fork_event)(struct perf_sched *sched,
-			  struct trace_fork_event *event,
-			  struct perf_evsel *evsel);
+	int (*fork_event)(struct perf_sched *sched, struct perf_evsel *evsel,
+			  struct perf_sample *sample);
 
 	int (*migrate_task_event)(struct perf_sched *sched,
-				  struct trace_migrate_task_event *event,
-				  struct machine *machine,
-				  struct perf_sample *sample);
+				  struct perf_evsel *evsel,
+				  struct perf_sample *sample,
+				  struct machine *machine);
 };
 
 struct perf_sched {
@@ -700,33 +652,36 @@ static void test_calibrations(struct perf_sched *sched)
 
 static int
 replay_wakeup_event(struct perf_sched *sched,
-		    struct trace_wakeup_event *wakeup_event,
-		    struct machine *machine __maybe_unused,
-		    struct perf_evsel *evsel, struct perf_sample *sample)
+		    struct perf_evsel *evsel, struct perf_sample *sample,
+		    struct machine *machine __maybe_unused)
 {
+	const char *comm = perf_evsel__strval(evsel, sample, "comm");
+	const u32 pid	 = perf_evsel__intval(evsel, sample, "pid");
 	struct task_desc *waker, *wakee;
 
 	if (verbose) {
 		printf("sched_wakeup event %p\n", evsel);
 
-		printf(" ... pid %d woke up %s/%d\n",
-		       sample->tid, wakeup_event->comm, wakeup_event->pid);
+		printf(" ... pid %d woke up %s/%d\n", sample->tid, comm, pid);
 	}
 
 	waker = register_pid(sched, sample->tid, "<unknown>");
-	wakee = register_pid(sched, wakeup_event->pid, wakeup_event->comm);
+	wakee = register_pid(sched, pid, comm);
 
 	add_sched_event_wakeup(sched, waker, sample->time, wakee);
 	return 0;
 }
 
-static int
-replay_switch_event(struct perf_sched *sched,
-		    struct trace_switch_event *switch_event,
-		    struct machine *machine __maybe_unused,
-		    struct perf_evsel *evsel,
-		    struct perf_sample *sample)
+static int replay_switch_event(struct perf_sched *sched,
+			       struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct machine *machine __maybe_unused)
 {
+	const char *prev_comm  = perf_evsel__strval(evsel, sample, "prev_comm"),
+		   *next_comm  = perf_evsel__strval(evsel, sample, "next_comm");
+	const u32 prev_pid = perf_evsel__intval(evsel, sample, "prev_pid"),
+		  next_pid = perf_evsel__intval(evsel, sample, "next_pid");
+	const u64 prev_state = perf_evsel__intval(evsel, sample, "prev_state");
 	struct task_desc *prev, __maybe_unused *next;
 	u64 timestamp0, timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -749,35 +704,36 @@ replay_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	if (verbose) {
-		printf(" ... switch from %s/%d to %s/%d [ran %" PRIu64 " nsecs]\n",
-			switch_event->prev_comm, switch_event->prev_pid,
-			switch_event->next_comm, switch_event->next_pid,
-			delta);
-	}
+	pr_debug(" ... switch from %s/%d to %s/%d [ran %" PRIu64 " nsecs]\n",
+		 prev_comm, prev_pid, next_comm, next_pid, delta);
 
-	prev = register_pid(sched, switch_event->prev_pid, switch_event->prev_comm);
-	next = register_pid(sched, switch_event->next_pid, switch_event->next_comm);
+	prev = register_pid(sched, prev_pid, prev_comm);
+	next = register_pid(sched, next_pid, next_comm);
 
 	sched->cpu_last_switched[cpu] = timestamp;
 
 	add_sched_event_run(sched, prev, timestamp, delta);
-	add_sched_event_sleep(sched, prev, timestamp, switch_event->prev_state);
+	add_sched_event_sleep(sched, prev, timestamp, prev_state);
 
 	return 0;
 }
 
-static int
-replay_fork_event(struct perf_sched *sched, struct trace_fork_event *fork_event,
-		  struct perf_evsel *evsel)
+static int replay_fork_event(struct perf_sched *sched, struct perf_evsel *evsel,
+			     struct perf_sample *sample)
 {
+	const char *parent_comm = perf_evsel__strval(evsel, sample, "parent_comm"),
+		   *child_comm  = perf_evsel__strval(evsel, sample, "child_comm");
+	const u32 parent_pid  = perf_evsel__intval(evsel, sample, "parent_pid"),
+		  child_pid  = perf_evsel__intval(evsel, sample, "child_pid");
+
 	if (verbose) {
 		printf("sched_fork event %p\n", evsel);
-		printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
-		printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
+		printf("... parent: %s/%d\n", parent_comm, parent_pid);
+		printf("...  child: %s/%d\n", child_comm, child_pid);
 	}
-	register_pid(sched, fork_event->parent_pid, fork_event->parent_comm);
-	register_pid(sched, fork_event->child_pid, fork_event->child_comm);
+
+	register_pid(sched, parent_pid, parent_comm);
+	register_pid(sched, child_pid, child_comm);
 	return 0;
 }
 
@@ -870,18 +826,18 @@ static int thread_atoms_insert(struct perf_sched *sched, struct thread *thread)
 }
 
 static int latency_fork_event(struct perf_sched *sched __maybe_unused,
-			      struct trace_fork_event *fork_event __maybe_unused,
-			      struct perf_evsel *evsel __maybe_unused)
+			      struct perf_evsel *evsel __maybe_unused,
+			      struct perf_sample *sample __maybe_unused)
 {
 	/* should insert the newcomer */
 	return 0;
 }
 
-static char sched_out_state(struct trace_switch_event *switch_event)
+static char sched_out_state(u64 prev_state)
 {
 	const char *str = TASK_STATE_TO_CHAR_STR;
 
-	return str[switch_event->prev_state];
+	return str[prev_state];
 }
 
 static int
@@ -951,13 +907,14 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 	atoms->nb_atoms++;
 }
 
-static int
-latency_switch_event(struct perf_sched *sched,
-		     struct trace_switch_event *switch_event,
-		     struct machine *machine,
-		     struct perf_evsel *evsel __maybe_unused,
-		     struct perf_sample *sample)
+static int latency_switch_event(struct perf_sched *sched,
+				struct perf_evsel *evsel,
+				struct perf_sample *sample,
+				struct machine *machine)
 {
+	const u32 prev_pid = perf_evsel__intval(evsel, sample, "prev_pid"),
+		  next_pid = perf_evsel__intval(evsel, sample, "next_pid");
+	const u64 prev_state = perf_evsel__intval(evsel, sample, "prev_state");
 	struct work_atoms *out_events, *in_events;
 	struct thread *sched_out, *sched_in;
 	u64 timestamp0, timestamp = sample->time;
@@ -978,8 +935,8 @@ latency_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
-	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
+	sched_out = machine__findnew_thread(machine, prev_pid);
+	sched_in = machine__findnew_thread(machine, next_pid);
 
 	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
@@ -991,7 +948,7 @@ latency_switch_event(struct perf_sched *sched,
 			return -1;
 		}
 	}
-	if (add_sched_out_event(out_events, sched_out_state(switch_event), timestamp))
+	if (add_sched_out_event(out_events, sched_out_state(prev_state), timestamp))
 		return -1;
 
 	in_events = thread_atoms_search(&sched->atom_root, sched_in, &sched->cmp_pid);
@@ -1015,12 +972,14 @@ latency_switch_event(struct perf_sched *sched,
 	return 0;
 }
 
-static int
-latency_runtime_event(struct perf_sched *sched,
-		      struct trace_runtime_event *runtime_event,
-		      struct machine *machine, struct perf_sample *sample)
+static int latency_runtime_event(struct perf_sched *sched,
+				 struct perf_evsel *evsel,
+				 struct perf_sample *sample,
+				 struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, runtime_event->pid);
+	const u32 pid	   = perf_evsel__intval(evsel, sample, "pid");
+	const u64 runtime  = perf_evsel__intval(evsel, sample, "runtime");
+	struct thread *thread = machine__findnew_thread(machine, pid);
 	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -1038,27 +997,27 @@ latency_runtime_event(struct perf_sched *sched,
 			return -1;
 	}
 
-	add_runtime_event(atoms, runtime_event->runtime, timestamp);
+	add_runtime_event(atoms, runtime, timestamp);
 	return 0;
 }
 
-static int
-latency_wakeup_event(struct perf_sched *sched,
-		     struct trace_wakeup_event *wakeup_event,
-		     struct machine *machine,
-		     struct perf_evsel *evsel __maybe_unused,
-		     struct perf_sample *sample)
+static int latency_wakeup_event(struct perf_sched *sched,
+				struct perf_evsel *evsel,
+				struct perf_sample *sample,
+				struct machine *machine)
 {
+	const u32 pid	  = perf_evsel__intval(evsel, sample, "pid"),
+		  success = perf_evsel__intval(evsel, sample, "success");
 	struct work_atoms *atoms;
 	struct work_atom *atom;
 	struct thread *wakee;
 	u64 timestamp = sample->time;
 
 	/* Note for later, it may be interesting to observe the failing cases */
-	if (!wakeup_event->success)
+	if (!success)
 		return 0;
 
-	wakee = machine__findnew_thread(machine, wakeup_event->pid);
+	wakee = machine__findnew_thread(machine, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, wakee))
@@ -1095,11 +1054,12 @@ latency_wakeup_event(struct perf_sched *sched,
 	return 0;
 }
 
-static int
-latency_migrate_task_event(struct perf_sched *sched,
-			   struct trace_migrate_task_event *migrate_task_event,
-			   struct machine *machine, struct perf_sample *sample)
+static int latency_migrate_task_event(struct perf_sched *sched,
+				      struct perf_evsel *evsel,
+				      struct perf_sample *sample,
+				      struct machine *machine)
 {
+	const u32 pid = perf_evsel__intval(evsel, sample, "pid");
 	u64 timestamp = sample->time;
 	struct work_atoms *atoms;
 	struct work_atom *atom;
@@ -1111,7 +1071,7 @@ latency_migrate_task_event(struct perf_sched *sched,
 	if (sched->profile_cpu == -1)
 		return 0;
 
-	migrant = machine__findnew_thread(machine, migrate_task_event->pid);
+	migrant = machine__findnew_thread(machine, pid);
 	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
@@ -1296,28 +1256,17 @@ static int process_sched_wakeup_event(struct perf_tool *tool,
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 
-	if (sched->tp_handler->wakeup_event) {
-		struct trace_wakeup_event event = {
-			.comm	 = perf_evsel__strval(evsel, sample, "comm"),
-			.pid	 = perf_evsel__intval(evsel, sample, "pid"),
-			.prio	 = perf_evsel__intval(evsel, sample, "prio"),
-			.success = perf_evsel__intval(evsel, sample, "success"),
-			.cpu	 = perf_evsel__intval(evsel, sample, "cpu"),
-		};
-
-		return sched->tp_handler->wakeup_event(sched, &event, machine, evsel, sample);
-	}
+	if (sched->tp_handler->wakeup_event)
+		return sched->tp_handler->wakeup_event(sched, evsel, sample, machine);
 
 	return 0;
 }
 
-static int
-map_switch_event(struct perf_sched *sched,
-		 struct trace_switch_event *switch_event,
-		 struct machine *machine,
-		 struct perf_evsel *evsel __maybe_unused,
-		 struct perf_sample *sample)
+static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
+			    struct perf_sample *sample, struct machine *machine)
 {
+	const u32 prev_pid = perf_evsel__intval(evsel, sample, "prev_pid"),
+		  next_pid = perf_evsel__intval(evsel, sample, "next_pid");
 	struct thread *sched_out __maybe_unused, *sched_in;
 	int new_shortname;
 	u64 timestamp0, timestamp = sample->time;
@@ -1341,8 +1290,8 @@ map_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, switch_event->prev_pid);
-	sched_in = machine__findnew_thread(machine, switch_event->next_pid);
+	sched_out = machine__findnew_thread(machine, prev_pid);
+	sched_in = machine__findnew_thread(machine, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
 
@@ -1411,19 +1360,8 @@ static int process_sched_switch_event(struct perf_tool *tool,
 			sched->nr_context_switch_bugs++;
 	}
 
-	if (sched->tp_handler->switch_event) {
-		struct trace_switch_event event = {
-			.prev_comm  = perf_evsel__strval(evsel, sample, "prev_comm"),
-			.prev_pid   = prev_pid,
-			.prev_prio  = perf_evsel__intval(evsel, sample, "prev_prio"),
-			.prev_state = perf_evsel__intval(evsel, sample, "prev_state"),
-			.next_comm  = perf_evsel__strval(evsel, sample, "next_comm"),
-			.next_pid   = next_pid,
-			.next_prio  = perf_evsel__intval(evsel, sample, "next_prio"),
-		};
-
-		err = sched->tp_handler->switch_event(sched, &event, machine, evsel, sample);
-	}
+	if (sched->tp_handler->switch_event)
+		err = sched->tp_handler->switch_event(sched, evsel, sample, machine);
 
 	sched->curr_pid[this_cpu] = next_pid;
 	return err;
@@ -1436,15 +1374,8 @@ static int process_sched_runtime_event(struct perf_tool *tool,
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 
-	if (sched->tp_handler->runtime_event) {
-		struct trace_runtime_event event = {
-			.comm	  = perf_evsel__strval(evsel, sample, "comm"),
-			.pid	  = perf_evsel__intval(evsel, sample, "pid"),
-			.runtime  = perf_evsel__intval(evsel, sample, "runtime"),
-			.vruntime = perf_evsel__intval(evsel, sample, "vruntime"),
-		};
-		return sched->tp_handler->runtime_event(sched, &event, machine, sample);
-	}
+	if (sched->tp_handler->runtime_event)
+		return sched->tp_handler->runtime_event(sched, evsel, sample, machine);
 
 	return 0;
 }
@@ -1456,15 +1387,8 @@ static int process_sched_fork_event(struct perf_tool *tool,
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 
-	if (sched->tp_handler->fork_event) {
-		struct trace_fork_event event = {
-			.parent_comm = perf_evsel__strval(evsel, sample, "parent_comm"),
-			.child_comm  = perf_evsel__strval(evsel, sample, "child_comm"),
-			.parent_pid  = perf_evsel__intval(evsel, sample, "parent_pid"),
-			.child_pid  = perf_evsel__intval(evsel, sample, "child_pid"),
-		};
-		return sched->tp_handler->fork_event(sched, &event, evsel);
-	}
+	if (sched->tp_handler->fork_event)
+		return sched->tp_handler->fork_event(sched, evsel, sample);
 
 	return 0;
 }
@@ -1485,15 +1409,8 @@ static int process_sched_migrate_task_event(struct perf_tool *tool,
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 
-	if (sched->tp_handler->migrate_task_event) {
-		struct trace_migrate_task_event event = {
-			.comm = perf_evsel__strval(evsel, sample, "comm"),
-			.pid  = perf_evsel__intval(evsel, sample, "pid"),
-			.prio = perf_evsel__intval(evsel, sample, "prio"),
-			.cpu  = perf_evsel__intval(evsel, sample, "cpu"),
-		};
-		return sched->tp_handler->migrate_task_event(sched, &event, machine, sample);
-	}
+	if (sched->tp_handler->migrate_task_event)
+		return sched->tp_handler->migrate_task_event(sched, evsel, sample, machine);
 
 	return 0;
 }
