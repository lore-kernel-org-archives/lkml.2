Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2INGGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:06:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2INGGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:06:11 -0400
Date: Thu, 13 Sep 2012 23:05:49 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-weu9t63zkrfrazkn0gxj48xy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Use perf_evsel__{int,str}val
Git-Commit-ID: 2b7fcbc5a9c719a306af1c4986a9f5c2cbfcec65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:05:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b7fcbc5a9c719a306af1c4986a9f5c2cbfcec65
Gitweb:     http://git.kernel.org/tip/2b7fcbc5a9c719a306af1c4986a9f5c2cbfcec65
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Sep 2012 19:29:17 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 19:33:51 -0300

perf sched: Use perf_evsel__{int,str}val

This patch also stops reading the common fields, as they were not being used except
for one ->common_pid case that was replaced by sample->tid, i.e. the info is already
in the perf_sample struct.

Also it only fills the _event structures when there is a handler.

  [root@sandy ~]# perf sched record sleep 30s
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 8.585 MB perf.data (~375063 samples) ]

Before:

  [root@sandy ~]# perf stat -r 10 perf sched lat > /dev/null

   Performance counter stats for 'perf sched lat' (10 runs):

          129.117838 task-clock                #    0.994 CPUs utilized            ( +-  0.28% )
                  14 context-switches          #    0.111 K/sec                    ( +-  2.10% )
                   0 cpu-migrations            #    0.002 K/sec                    ( +- 66.67% )
               7,654 page-faults               #    0.059 M/sec                    ( +-  0.67% )
         438,121,661 cycles                    #    3.393 GHz                      ( +-  0.06% ) [83.06%]
         150,808,605 stalled-cycles-frontend   #   34.42% frontend cycles idle     ( +-  0.14% ) [83.10%]
          80,748,941 stalled-cycles-backend    #   18.43% backend  cycles idle     ( +-  0.64% ) [66.73%]
         758,605,879 instructions              #    1.73  insns per cycle
                                               #    0.20  stalled cycles per insn  ( +-  0.08% ) [83.54%]
         162,164,321 branches                  # 1255.940 M/sec                    ( +-  0.10% ) [83.70%]
           1,609,903 branch-misses             #    0.99% of all branches          ( +-  0.08% ) [83.62%]

         0.129949153 seconds time elapsed                                          ( +-  0.28% )

After:

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

  [root@sandy ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-weu9t63zkrfrazkn0gxj48xy@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |  249 ++++++++++++++++----------------------------
 1 files changed, 90 insertions(+), 159 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 79f88fa..0df5e7a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -98,82 +98,40 @@ struct work_atoms {
 typedef int (*sort_fn_t)(struct work_atoms *, struct work_atoms *);
 
 struct trace_switch_event {
-	u32  size;
-
-	u16  common_type;
-	u8   common_flags;
-	u8   common_preempt_count;
-	u32  common_pid;
-	u32  common_tgid;
-
-	char prev_comm[16];
+	char *prev_comm;
 	u32  prev_pid;
 	u32  prev_prio;
 	u64  prev_state;
-	char next_comm[16];
+	char *next_comm;
 	u32  next_pid;
 	u32  next_prio;
 };
 
 struct trace_runtime_event {
-	u32  size;
-
-	u16  common_type;
-	u8   common_flags;
-	u8   common_preempt_count;
-	u32  common_pid;
-	u32  common_tgid;
-
-	char comm[16];
+	char *comm;
 	u32  pid;
 	u64  runtime;
 	u64  vruntime;
 };
 
 struct trace_wakeup_event {
-	u32  size;
-
-	u16  common_type;
-	u8   common_flags;
-	u8   common_preempt_count;
-	u32  common_pid;
-	u32  common_tgid;
-
-	char comm[16];
+	char *comm;
 	u32  pid;
-
 	u32  prio;
 	u32  success;
 	u32  cpu;
 };
 
 struct trace_fork_event {
-	u32  size;
-
-	u16  common_type;
-	u8   common_flags;
-	u8   common_preempt_count;
-	u32  common_pid;
-	u32  common_tgid;
-
-	char parent_comm[16];
+	char *parent_comm;
 	u32  parent_pid;
-	char child_comm[16];
+	char *child_comm;
 	u32   child_pid;
 };
 
 struct trace_migrate_task_event {
-	u32  size;
-
-	u16  common_type;
-	u8   common_flags;
-	u8   common_preempt_count;
-	u32  common_pid;
-	u32  common_tgid;
-
-	char comm[16];
+	char *comm;
 	u32  pid;
-
 	u32  prio;
 	u32  cpu;
 };
@@ -184,7 +142,7 @@ struct trace_sched_handler {
 	int (*switch_event)(struct perf_sched *sched,
 			    struct trace_switch_event *event,
 			    struct machine *machine,
-			    struct event_format *tp_format,
+			    struct perf_evsel *evsel,
 			    struct perf_sample *sample);
 
 	int (*runtime_event)(struct perf_sched *sched,
@@ -195,12 +153,12 @@ struct trace_sched_handler {
 	int (*wakeup_event)(struct perf_sched *sched,
 			    struct trace_wakeup_event *event,
 			    struct machine *machine,
-			    struct event_format *tp_format,
+			    struct perf_evsel *evsel,
 			    struct perf_sample *sample);
 
 	int (*fork_event)(struct perf_sched *sched,
 			  struct trace_fork_event *event,
-			  struct event_format *tp_format);
+			  struct perf_evsel *evsel);
 
 	int (*migrate_task_event)(struct perf_sched *sched,
 				  struct trace_migrate_task_event *event,
@@ -740,40 +698,22 @@ static void test_calibrations(struct perf_sched *sched)
 	printf("the sleep test took %" PRIu64 " nsecs\n", T1 - T0);
 }
 
-#define FILL_FIELD(ptr, field, event, data)	\
-	ptr.field = (typeof(ptr.field)) raw_field_value(event, #field, data)
-
-#define FILL_ARRAY(ptr, array, event, data)			\
-do {								\
-	void *__array = raw_field_ptr(event, #array, data);	\
-	memcpy(ptr.array, __array, sizeof(ptr.array));	\
-} while(0)
-
-#define FILL_COMMON_FIELDS(ptr, event, data)			\
-do {								\
-	FILL_FIELD(ptr, common_type, event, data);		\
-	FILL_FIELD(ptr, common_flags, event, data);		\
-	FILL_FIELD(ptr, common_preempt_count, event, data);	\
-	FILL_FIELD(ptr, common_pid, event, data);		\
-	FILL_FIELD(ptr, common_tgid, event, data);		\
-} while (0)
-
 static int
 replay_wakeup_event(struct perf_sched *sched,
 		    struct trace_wakeup_event *wakeup_event,
 		    struct machine *machine __maybe_unused,
-		    struct event_format *event, struct perf_sample *sample)
+		    struct perf_evsel *evsel, struct perf_sample *sample)
 {
 	struct task_desc *waker, *wakee;
 
 	if (verbose) {
-		printf("sched_wakeup event %p\n", event);
+		printf("sched_wakeup event %p\n", evsel);
 
 		printf(" ... pid %d woke up %s/%d\n",
-		       wakeup_event->common_pid, wakeup_event->comm, wakeup_event->pid);
+		       sample->tid, wakeup_event->comm, wakeup_event->pid);
 	}
 
-	waker = register_pid(sched, wakeup_event->common_pid, "<unknown>");
+	waker = register_pid(sched, sample->tid, "<unknown>");
 	wakee = register_pid(sched, wakeup_event->pid, wakeup_event->comm);
 
 	add_sched_event_wakeup(sched, waker, sample->time, wakee);
@@ -784,7 +724,7 @@ static int
 replay_switch_event(struct perf_sched *sched,
 		    struct trace_switch_event *switch_event,
 		    struct machine *machine __maybe_unused,
-		    struct event_format *event,
+		    struct perf_evsel *evsel,
 		    struct perf_sample *sample)
 {
 	struct task_desc *prev, __maybe_unused *next;
@@ -793,7 +733,7 @@ replay_switch_event(struct perf_sched *sched,
 	s64 delta;
 
 	if (verbose)
-		printf("sched_switch event %p\n", event);
+		printf("sched_switch event %p\n", evsel);
 
 	if (cpu >= MAX_CPUS || cpu < 0)
 		return 0;
@@ -829,10 +769,10 @@ replay_switch_event(struct perf_sched *sched,
 
 static int
 replay_fork_event(struct perf_sched *sched, struct trace_fork_event *fork_event,
-		  struct event_format *event)
+		  struct perf_evsel *evsel)
 {
 	if (verbose) {
-		printf("sched_fork event %p\n", event);
+		printf("sched_fork event %p\n", evsel);
 		printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
 		printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
 	}
@@ -931,7 +871,7 @@ static int thread_atoms_insert(struct perf_sched *sched, struct thread *thread)
 
 static int latency_fork_event(struct perf_sched *sched __maybe_unused,
 			      struct trace_fork_event *fork_event __maybe_unused,
-			      struct event_format *event __maybe_unused)
+			      struct perf_evsel *evsel __maybe_unused)
 {
 	/* should insert the newcomer */
 	return 0;
@@ -1015,7 +955,7 @@ static int
 latency_switch_event(struct perf_sched *sched,
 		     struct trace_switch_event *switch_event,
 		     struct machine *machine,
-		     struct event_format *event __maybe_unused,
+		     struct perf_evsel *evsel __maybe_unused,
 		     struct perf_sample *sample)
 {
 	struct work_atoms *out_events, *in_events;
@@ -1106,7 +1046,7 @@ static int
 latency_wakeup_event(struct perf_sched *sched,
 		     struct trace_wakeup_event *wakeup_event,
 		     struct machine *machine,
-		     struct event_format *event __maybe_unused,
+		     struct perf_evsel *evsel __maybe_unused,
 		     struct perf_sample *sample)
 {
 	struct work_atoms *atoms;
@@ -1350,34 +1290,32 @@ static void perf_sched__sort_lat(struct perf_sched *sched)
 }
 
 static int process_sched_wakeup_event(struct perf_tool *tool,
-				      struct event_format *event,
+				      struct perf_evsel *evsel,
 				      struct perf_sample *sample,
 				      struct machine *machine)
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
-	void *data = sample->raw_data;
-	struct trace_wakeup_event wakeup_event;
-	int err = 0;
-
-	FILL_COMMON_FIELDS(wakeup_event, event, data);
 
-	FILL_ARRAY(wakeup_event, comm, event, data);
-	FILL_FIELD(wakeup_event, pid, event, data);
-	FILL_FIELD(wakeup_event, prio, event, data);
-	FILL_FIELD(wakeup_event, success, event, data);
-	FILL_FIELD(wakeup_event, cpu, event, data);
+	if (sched->tp_handler->wakeup_event) {
+		struct trace_wakeup_event event = {
+			.comm	 = perf_evsel__strval(evsel, sample, "comm"),
+			.pid	 = perf_evsel__intval(evsel, sample, "pid"),
+			.prio	 = perf_evsel__intval(evsel, sample, "prio"),
+			.success = perf_evsel__intval(evsel, sample, "success"),
+			.cpu	 = perf_evsel__intval(evsel, sample, "cpu"),
+		};
 
-	if (sched->tp_handler->wakeup_event)
-		err = sched->tp_handler->wakeup_event(sched, &wakeup_event, machine, event, sample);
+		return sched->tp_handler->wakeup_event(sched, &event, machine, evsel, sample);
+	}
 
-	return err;
+	return 0;
 }
 
 static int
 map_switch_event(struct perf_sched *sched,
 		 struct trace_switch_event *switch_event,
 		 struct machine *machine,
-		 struct event_format *event __maybe_unused,
+		 struct perf_evsel *evsel __maybe_unused,
 		 struct perf_sample *sample)
 {
 	struct thread *sched_out __maybe_unused, *sched_in;
@@ -1455,120 +1393,113 @@ map_switch_event(struct perf_sched *sched,
 }
 
 static int process_sched_switch_event(struct perf_tool *tool,
-				      struct event_format *event,
+				      struct perf_evsel *evsel,
 				      struct perf_sample *sample,
 				      struct machine *machine)
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	int this_cpu = sample->cpu, err = 0;
-	void *data = sample->raw_data;
-	struct trace_switch_event switch_event;
-
-	FILL_COMMON_FIELDS(switch_event, event, data);
-
-	FILL_ARRAY(switch_event, prev_comm, event, data);
-	FILL_FIELD(switch_event, prev_pid, event, data);
-	FILL_FIELD(switch_event, prev_prio, event, data);
-	FILL_FIELD(switch_event, prev_state, event, data);
-	FILL_ARRAY(switch_event, next_comm, event, data);
-	FILL_FIELD(switch_event, next_pid, event, data);
-	FILL_FIELD(switch_event, next_prio, event, data);
+	u32 prev_pid = perf_evsel__intval(evsel, sample, "prev_pid"),
+	    next_pid = perf_evsel__intval(evsel, sample, "next_pid");
 
 	if (sched->curr_pid[this_cpu] != (u32)-1) {
 		/*
 		 * Are we trying to switch away a PID that is
 		 * not current?
 		 */
-		if (sched->curr_pid[this_cpu] != switch_event.prev_pid)
+		if (sched->curr_pid[this_cpu] != prev_pid)
 			sched->nr_context_switch_bugs++;
 	}
-	if (sched->tp_handler->switch_event)
-		err = sched->tp_handler->switch_event(sched, &switch_event, machine, event, sample);
 
-	sched->curr_pid[this_cpu] = switch_event.next_pid;
+	if (sched->tp_handler->switch_event) {
+		struct trace_switch_event event = {
+			.prev_comm  = perf_evsel__strval(evsel, sample, "prev_comm"),
+			.prev_pid   = prev_pid,
+			.prev_prio  = perf_evsel__intval(evsel, sample, "prev_prio"),
+			.prev_state = perf_evsel__intval(evsel, sample, "prev_state"),
+			.next_comm  = perf_evsel__strval(evsel, sample, "next_comm"),
+			.next_pid   = next_pid,
+			.next_prio  = perf_evsel__intval(evsel, sample, "next_prio"),
+		};
+
+		err = sched->tp_handler->switch_event(sched, &event, machine, evsel, sample);
+	}
+
+	sched->curr_pid[this_cpu] = next_pid;
 	return err;
 }
 
 static int process_sched_runtime_event(struct perf_tool *tool,
-				       struct event_format *event,
+				       struct perf_evsel *evsel,
 				       struct perf_sample *sample,
 				       struct machine *machine)
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
-	void *data = sample->raw_data;
-	struct trace_runtime_event runtime_event;
-	int err = 0;
 
-	FILL_ARRAY(runtime_event, comm, event, data);
-	FILL_FIELD(runtime_event, pid, event, data);
-	FILL_FIELD(runtime_event, runtime, event, data);
-	FILL_FIELD(runtime_event, vruntime, event, data);
-
-	if (sched->tp_handler->runtime_event)
-		err = sched->tp_handler->runtime_event(sched, &runtime_event, machine, sample);
+	if (sched->tp_handler->runtime_event) {
+		struct trace_runtime_event event = {
+			.comm	  = perf_evsel__strval(evsel, sample, "comm"),
+			.pid	  = perf_evsel__intval(evsel, sample, "pid"),
+			.runtime  = perf_evsel__intval(evsel, sample, "runtime"),
+			.vruntime = perf_evsel__intval(evsel, sample, "vruntime"),
+		};
+		return sched->tp_handler->runtime_event(sched, &event, machine, sample);
+	}
 
-	return err;
+	return 0;
 }
 
 static int process_sched_fork_event(struct perf_tool *tool,
-				    struct event_format *event,
+				    struct perf_evsel *evsel,
 				    struct perf_sample *sample,
 				    struct machine *machine __maybe_unused)
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
-	void *data = sample->raw_data;
-	struct trace_fork_event fork_event;
-	int err = 0;
-
-	FILL_COMMON_FIELDS(fork_event, event, data);
 
-	FILL_ARRAY(fork_event, parent_comm, event, data);
-	FILL_FIELD(fork_event, parent_pid, event, data);
-	FILL_ARRAY(fork_event, child_comm, event, data);
-	FILL_FIELD(fork_event, child_pid, event, data);
-
-	if (sched->tp_handler->fork_event)
-		err = sched->tp_handler->fork_event(sched, &fork_event, event);
+	if (sched->tp_handler->fork_event) {
+		struct trace_fork_event event = {
+			.parent_comm = perf_evsel__strval(evsel, sample, "parent_comm"),
+			.child_comm  = perf_evsel__strval(evsel, sample, "child_comm"),
+			.parent_pid  = perf_evsel__intval(evsel, sample, "parent_pid"),
+			.child_pid  = perf_evsel__intval(evsel, sample, "child_pid"),
+		};
+		return sched->tp_handler->fork_event(sched, &event, evsel);
+	}
 
-	return err;
+	return 0;
 }
 
 static int process_sched_exit_event(struct perf_tool *tool __maybe_unused,
-				    struct event_format *event,
+				    struct perf_evsel *evsel,
 				    struct perf_sample *sample __maybe_unused,
 				    struct machine *machine __maybe_unused)
 {
-	if (verbose)
-		printf("sched_exit event %p\n", event);
-
+	pr_debug("sched_exit event %p\n", evsel);
 	return 0;
 }
 
 static int process_sched_migrate_task_event(struct perf_tool *tool,
-					    struct event_format *event,
+					    struct perf_evsel *evsel,
 					    struct perf_sample *sample,
 					    struct machine *machine)
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
-	void *data = sample->raw_data;
-	struct trace_migrate_task_event migrate_task_event;
-	int err = 0;
 
-	FILL_COMMON_FIELDS(migrate_task_event, event, data);
-
-	FILL_ARRAY(migrate_task_event, comm, event, data);
-	FILL_FIELD(migrate_task_event, pid, event, data);
-	FILL_FIELD(migrate_task_event, prio, event, data);
-	FILL_FIELD(migrate_task_event, cpu, event, data);
-
-	if (sched->tp_handler->migrate_task_event)
-		err = sched->tp_handler->migrate_task_event(sched, &migrate_task_event, machine, sample);
+	if (sched->tp_handler->migrate_task_event) {
+		struct trace_migrate_task_event event = {
+			.comm = perf_evsel__strval(evsel, sample, "comm"),
+			.pid  = perf_evsel__intval(evsel, sample, "pid"),
+			.prio = perf_evsel__intval(evsel, sample, "prio"),
+			.cpu  = perf_evsel__intval(evsel, sample, "cpu"),
+		};
+		return sched->tp_handler->migrate_task_event(sched, &event, machine, sample);
+	}
 
-	return err;
+	return 0;
 }
 
 typedef int (*tracepoint_handler)(struct perf_tool *tool,
-				  struct event_format *tp_format,
+				  struct perf_evsel *evsel,
 				  struct perf_sample *sample,
 				  struct machine *machine);
 
@@ -1592,7 +1523,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
-		err = f(tool, evsel->tp_format, sample, machine);
+		err = f(tool, evsel, sample, machine);
 	}
 
 	return err;
