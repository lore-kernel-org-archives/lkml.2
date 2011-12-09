Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1LIRn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:43:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57345 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1LIRnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:43:53 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] perf: fix comm for processes with named threads
Date: Fri,  9 Dec 2011 10:43:37 -0700
Message-Id: <1323452619-10374-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
References: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf does not properly handle monitoring of processes with named threads.
For example:

$ ps -C myapp -L
  PID   LWP TTY          TIME CMD
25118 25118 ?        00:00:00 myapp
25118 25119 ?        00:00:00 myapp:worker

perf record -e cs -c 1 -fo /tmp/perf.data -p 25118 -- sleep 10
perf report --stdio -i /tmp/perf.data
   100.00%  myapp:worker  [kernel.kallsyms]  [k] perf_event_task_sched_out

The process name is set to the name of the last thread it finds for the
process.

The Problem:
perf-top and perf-record both create a thread_map of threads to be
monitored. That map is used in perf_event__synthesize_thread_map which
loops over the entries in thread_map and calls __event__synthesize_thread
to generate COMM and MMAP events.

__event__synthesize_thread calls perf_event__synthesize_comm which opens
/proc/pid/status, reads the name of the task and its thread group id.
That's all fine. The problem is that it then reads /proc/pid/task and
generates COMM events for each task it finds - but using the name found
in /proc/pid/status where pid is the thread of interest.

The end result (looping over thread_map + synthesizing comm events for
each thread each time) means the name of the last thread processed sets
the name for all threads in the process - which is not good for
multithreaded processes with named threads.

The Fix:
perf_event__synthesize_comm has an input argument (full) that decides
whether to process task entries for each pid it is passed. It currently
never set to 0 (perf_event__synthesize_comm has a single caller and it
always passes the value 1). Let's fix that.

Add the full input argument to __event__synthesize_thread which passes
it to perf_event__synthesize_comm. For thread/process monitoring set full
to 0 which means COMM and MMAP events are only generated for the pid
passed to it. For system wide monitoring set full to 1 so that COMM events
are generated for all threads in a process.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/event.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 97c479b..c424324 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -261,11 +261,12 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 
 static int __event__synthesize_thread(union perf_event *comm_event,
 				      union perf_event *mmap_event,
-				      pid_t pid, perf_event__handler_t process,
+				      pid_t pid, int full,
+					  perf_event__handler_t process,
 				      struct perf_tool *tool,
 				      struct machine *machine)
 {
-	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, 1,
+	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
 						 process, machine);
 	if (tgid == -1)
 		return -1;
@@ -279,7 +280,7 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct machine *machine)
 {
 	union perf_event *comm_event, *mmap_event;
-	int err = -1, thread;
+	int err = -1, thread, j;
 
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
@@ -292,11 +293,36 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 	err = 0;
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
-					       threads->map[thread],
+					       threads->map[thread], 0,
 					       process, tool, machine)) {
 			err = -1;
 			break;
 		}
+
+		/*
+		 * comm.pid is set to thread group id by
+		 * perf_event__synthesize_comm
+		 */
+		if ((int) comm_event->comm.pid != threads->map[thread]) {
+			bool need_leader = true;
+
+			/* is thread group leader in thread_map? */
+			for (j = 0; j < threads->nr; ++j) {
+				if ((int) comm_event->comm.pid == threads->map[j]) {
+					need_leader = false;
+					break;
+				}
+			}
+
+			/* if not, generate events for it */
+			if (need_leader &&
+				__event__synthesize_thread(comm_event, mmap_event,
+					       comm_event->comm.pid, 0,
+					       process, tool, machine)) {
+				err = -1;
+				break;
+			}
+		}
 	}
 	free(mmap_event);
 out_free_comm:
@@ -333,7 +359,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		__event__synthesize_thread(comm_event, mmap_event, pid,
+		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
 					   process, tool, machine);
 	}
 
-- 
1.7.7.3

