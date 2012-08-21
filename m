Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2HUPX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:23:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2HUPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:23:55 -0400
Date: Tue, 21 Aug 2012 08:23:33 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-fc537qykjjqzvyol5fecx6ug@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        avagin@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        avagin@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Use perf_sample
Git-Commit-ID: 7f7f8d0bea5d6bb985f4ae84ca3daff34802fd32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:23:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f7f8d0bea5d6bb985f4ae84ca3daff34802fd32
Gitweb:     http://git.kernel.org/tip/7f7f8d0bea5d6bb985f4ae84ca3daff34802fd32
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 11:33:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:46:19 -0300

perf sched: Use perf_sample

To reduce the number of parameters passed to the various event handling
functions.

Cc: Andrey Wagin <avagin@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fc537qykjjqzvyol5fecx6ug@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |  113 ++++++++++++++-----------------------------
 1 files changed, 37 insertions(+), 76 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 30ef82a..a25a023 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -729,46 +729,30 @@ struct trace_sched_handler {
 	void (*switch_event)(struct trace_switch_event *,
 			     struct machine *,
 			     struct event_format *,
-			     int cpu,
-			     u64 timestamp,
-			     struct thread *thread);
+			     struct perf_sample *sample);
 
 	void (*runtime_event)(struct trace_runtime_event *,
 			      struct machine *,
-			      struct event_format *,
-			      int cpu,
-			      u64 timestamp,
-			      struct thread *thread);
+			      struct perf_sample *sample);
 
 	void (*wakeup_event)(struct trace_wakeup_event *,
 			     struct machine *,
 			     struct event_format *,
-			     int cpu,
-			     u64 timestamp,
-			     struct thread *thread);
+			     struct perf_sample *sample);
 
 	void (*fork_event)(struct trace_fork_event *,
-			   struct event_format *,
-			   int cpu,
-			   u64 timestamp,
-			   struct thread *thread);
+			   struct event_format *event);
 
 	void (*migrate_task_event)(struct trace_migrate_task_event *,
-			   struct machine *machine,
-			   struct event_format *,
-			   int cpu,
-			   u64 timestamp,
-			   struct thread *thread);
+				   struct machine *machine,
+				   struct perf_sample *sample);
 };
 
 
 static void
 replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		    struct machine *machine __used,
-		    struct event_format *event,
-		    int cpu __used,
-		    u64 timestamp __used,
-		    struct thread *thread __used)
+		    struct event_format *event, struct perf_sample *sample)
 {
 	struct task_desc *waker, *wakee;
 
@@ -784,7 +768,7 @@ replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	waker = register_pid(wakeup_event->common_pid, "<unknown>");
 	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
 
-	add_sched_event_wakeup(waker, timestamp, wakee);
+	add_sched_event_wakeup(waker, sample->time, wakee);
 }
 
 static u64 cpu_last_switched[MAX_CPUS];
@@ -793,12 +777,11 @@ static void
 replay_switch_event(struct trace_switch_event *switch_event,
 		    struct machine *machine __used,
 		    struct event_format *event,
-		    int cpu,
-		    u64 timestamp,
-		    struct thread *thread __used)
+		    struct perf_sample *sample)
 {
 	struct task_desc *prev, __used *next;
-	u64 timestamp0;
+	u64 timestamp0, timestamp = sample->time;
+	int cpu = sample->cpu;
 	s64 delta;
 
 	if (verbose)
@@ -835,10 +818,7 @@ replay_switch_event(struct trace_switch_event *switch_event,
 
 static void
 replay_fork_event(struct trace_fork_event *fork_event,
-		  struct event_format *event,
-		  int cpu __used,
-		  u64 timestamp __used,
-		  struct thread *thread __used)
+		  struct event_format *event)
 {
 	if (verbose) {
 		printf("sched_fork event %p\n", event);
@@ -944,10 +924,7 @@ static void thread_atoms_insert(struct thread *thread)
 
 static void
 latency_fork_event(struct trace_fork_event *fork_event __used,
-		   struct event_format *event __used,
-		   int cpu __used,
-		   u64 timestamp __used,
-		   struct thread *thread __used)
+		   struct event_format *event __used)
 {
 	/* should insert the newcomer */
 }
@@ -1027,13 +1004,12 @@ static void
 latency_switch_event(struct trace_switch_event *switch_event,
 		     struct machine *machine,
 		     struct event_format *event __used,
-		     int cpu,
-		     u64 timestamp,
-		     struct thread *thread __used)
+		     struct perf_sample *sample)
 {
 	struct work_atoms *out_events, *in_events;
 	struct thread *sched_out, *sched_in;
-	u64 timestamp0;
+	u64 timestamp0, timestamp = sample->time;
+	int cpu = sample->cpu;
 	s64 delta;
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
@@ -1078,14 +1054,12 @@ latency_switch_event(struct trace_switch_event *switch_event,
 
 static void
 latency_runtime_event(struct trace_runtime_event *runtime_event,
-		     struct machine *machine,
-		     struct event_format *event __used,
-		     int cpu,
-		     u64 timestamp,
-		     struct thread *this_thread __used)
+		      struct machine *machine, struct perf_sample *sample)
 {
 	struct thread *thread = machine__findnew_thread(machine, runtime_event->pid);
 	struct work_atoms *atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+	u64 timestamp = sample->time;
+	int cpu = sample->cpu;
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
 	if (!atoms) {
@@ -1101,15 +1075,13 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 
 static void
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
-		     struct machine *machine,
-		     struct event_format *__event __used,
-		     int cpu __used,
-		     u64 timestamp,
-		     struct thread *thread __used)
+		     struct machine *machine, struct event_format *event __used,
+		     struct perf_sample *sample)
 {
 	struct work_atoms *atoms;
 	struct work_atom *atom;
 	struct thread *wakee;
+	u64 timestamp = sample->time;
 
 	/* Note for later, it may be interesting to observe the failing cases */
 	if (!wakeup_event->success)
@@ -1149,12 +1121,9 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 static void
 latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
-		     struct machine *machine,
-		     struct event_format *__event __used,
-		     int cpu __used,
-		     u64 timestamp,
-		     struct thread *thread __used)
+			   struct machine *machine, struct perf_sample *sample)
 {
+	u64 timestamp = sample->time;
 	struct work_atoms *atoms;
 	struct work_atom *atom;
 	struct thread *migrant;
@@ -1364,7 +1333,7 @@ process_sched_wakeup_event(struct perf_tool *tool __used,
 			   struct event_format *event,
 			   struct perf_sample *sample,
 			   struct machine *machine,
-			   struct thread *thread)
+			   struct thread *thread __used)
 {
 	void *data = sample->raw_data;
 	struct trace_wakeup_event wakeup_event;
@@ -1378,8 +1347,7 @@ process_sched_wakeup_event(struct perf_tool *tool __used,
 	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
-		trace_handler->wakeup_event(&wakeup_event, machine, event,
-					    sample->cpu, sample->time, thread);
+		trace_handler->wakeup_event(&wakeup_event, machine, event, sample);
 }
 
 /*
@@ -1399,15 +1367,13 @@ static void
 map_switch_event(struct trace_switch_event *switch_event,
 		 struct machine *machine,
 		 struct event_format *event __used,
-		 int this_cpu,
-		 u64 timestamp,
-		 struct thread *thread __used)
+		 struct perf_sample *sample)
 {
 	struct thread *sched_out __used, *sched_in;
 	int new_shortname;
-	u64 timestamp0;
+	u64 timestamp0, timestamp = sample->time;
 	s64 delta;
-	int cpu;
+	int cpu, this_cpu = sample->cpu;
 
 	BUG_ON(this_cpu >= MAX_CPUS || this_cpu < 0);
 
@@ -1479,7 +1445,7 @@ process_sched_switch_event(struct perf_tool *tool __used,
 			   struct event_format *event,
 			   struct perf_sample *sample,
 			   struct machine *machine,
-			   struct thread *thread)
+			   struct thread *thread __used)
 {
 	int this_cpu = sample->cpu;
 	void *data = sample->raw_data;
@@ -1504,8 +1470,7 @@ process_sched_switch_event(struct perf_tool *tool __used,
 			nr_context_switch_bugs++;
 	}
 	if (trace_handler->switch_event)
-		trace_handler->switch_event(&switch_event, machine, event,
-					    this_cpu, sample->time, thread);
+		trace_handler->switch_event(&switch_event, machine, event, sample);
 
 	curr_pid[this_cpu] = switch_event.next_pid;
 }
@@ -1515,7 +1480,7 @@ process_sched_runtime_event(struct perf_tool *tool __used,
 			    struct event_format *event,
 			    struct perf_sample *sample,
 			    struct machine *machine,
-			    struct thread *thread)
+			    struct thread *thread __used)
 {
 	void *data = sample->raw_data;
 	struct trace_runtime_event runtime_event;
@@ -1526,8 +1491,7 @@ process_sched_runtime_event(struct perf_tool *tool __used,
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
-		trace_handler->runtime_event(&runtime_event, machine, event,
-					     sample->cpu, sample->time, thread);
+		trace_handler->runtime_event(&runtime_event, machine, sample);
 }
 
 static void
@@ -1535,7 +1499,7 @@ process_sched_fork_event(struct perf_tool *tool __used,
 			 struct event_format *event,
 			 struct perf_sample *sample,
 			 struct machine *machine __used,
-			 struct thread *thread)
+			 struct thread *thread __used)
 {
 	void *data = sample->raw_data;
 	struct trace_fork_event fork_event;
@@ -1548,8 +1512,7 @@ process_sched_fork_event(struct perf_tool *tool __used,
 	FILL_FIELD(fork_event, child_pid, event, data);
 
 	if (trace_handler->fork_event)
-		trace_handler->fork_event(&fork_event, event,
-					  sample->cpu, sample->time, thread);
+		trace_handler->fork_event(&fork_event, event);
 }
 
 static void
@@ -1568,7 +1531,7 @@ process_sched_migrate_task_event(struct perf_tool *tool __used,
 				 struct event_format *event,
 				 struct perf_sample *sample,
 				 struct machine *machine,
-				 struct thread *thread)
+				 struct thread *thread __used)
 {
 	void *data = sample->raw_data;
 	struct trace_migrate_task_event migrate_task_event;
@@ -1581,9 +1544,7 @@ process_sched_migrate_task_event(struct perf_tool *tool __used,
 	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
-		trace_handler->migrate_task_event(&migrate_task_event, machine,
-						  event, sample->cpu,
-						  sample->time, thread);
+		trace_handler->migrate_task_event(&migrate_task_event, machine, sample);
 }
 
 typedef void (*tracepoint_handler)(struct perf_tool *tool, struct event_format *event,
