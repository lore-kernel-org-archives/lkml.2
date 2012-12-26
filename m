Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2LZCxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:53:46 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44622 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2LZCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:53:40 -0500
X-AuditID: 85900ec0-d727cb900000152f-f2-50da66b1aef6
Subject: [PATCH v4 -tip 3/3] tracing: add description of snapshot to
 Documentation/trace/ftrace.txt
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: linux-doc@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Rob Landley <rob@landley.net>, yrl.pp-manager.tt@hitachi.com,
        masami.hiramatsu.pt@hitachi.com
Date: Wed, 26 Dec 2012 11:53:09 +0900
Message-ID: <20121226025309.3252.150.stgit@liselsia>
In-Reply-To: <20121226025243.3252.61095.stgit@liselsia>
References: <20121226025243.3252.61095.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds snapshot description in ftrace documentation.
This description includes what the snapshot is and how to use it.

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/trace/ftrace.txt |   83 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 6f51fed..53d6a3c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1842,6 +1842,89 @@ an error.
  # cat buffer_size_kb
 85
 
+Snapshot
+--------
+CONFIG_TRACER_SNAPSHOT makes a generic snapshot feature
+available to all non latency tracers. (Latency tracers which
+record max latency, such as "irqsoff" or "wakeup", can't use
+this feature, since those are already using the snapshot
+mechanism internally.)
+
+Snapshot preserves a current trace buffer at a particular point
+in time without stopping tracing. Ftrace swaps the current
+buffer with a spare buffer, and tracing continues in the new
+current (=previous spare) buffer.
+
+The following debugfs files in "tracing" are related to this
+feature:
+
+  snapshot:
+
+	This is used to take a snapshot and to read the output
+	of the snapshot. Echo 1 into this file to allocate a
+	spare buffer and to take a snapshot (swap), then read
+	the snapshot from this file in the same format as
+	"trace" (described above in the section "The File
+	System"). Both reads snapshot and tracing are executable
+	in parallel. When the spare buffer is allocated, echoing
+	0 frees it, and echoing else (positive) values clear the
+	snapshot contents.
+	More details are shown in the table below.
+
+	status\input  |     0      |     1      |    else    |
+	--------------+------------+------------+------------+
+	not allocated |(do nothing)| alloc+swap |   EINVAL   |
+	--------------+------------+------------+------------+
+	allocated     |    free    |    swap    |   clear    |
+	--------------+------------+------------+------------+
+
+Here is an example of using the snapshot feature.
+
+ # echo 1 > events/sched/enable
+ # echo 1 > snapshot
+ # cat snapshot
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 71/71   #P:8
+#
+#                              _-----=> irqs-off
+#                             / _----=> need-resched
+#                            | / _---=> hardirq/softirq
+#                            || / _--=> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [005] d...  2440.603828: sched_switch: prev_comm=swapper/5 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2242 next_prio=120
+           sleep-2242  [005] d...  2440.603846: sched_switch: prev_comm=snapshot-test-2 prev_pid=2242 prev_prio=120 prev_state=R ==> next_comm=kworker/5:1 next_pid=60 next_prio=120
+[...]
+          <idle>-0     [002] d...  2440.707230: sched_switch: prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2229 next_prio=120
+
+ # cat trace
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 77/77   #P:8
+#
+#                              _-----=> irqs-off
+#                             / _----=> need-resched
+#                            | / _---=> hardirq/softirq
+#                            || / _--=> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [007] d...  2440.707395: sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2243 next_prio=120
+ snapshot-test-2-2229  [002] d...  2440.707438: sched_switch: prev_comm=snapshot-test-2 prev_pid=2229 prev_prio=120 prev_state=S ==> next_comm=swapper/2 next_pid=0 next_prio=120
+[...]
+
+
+If you try to use this snapshot feature when current tracer is
+one of the latency tracers, you will get the following results.
+
+ # echo wakeup > current_tracer
+ # echo 1 > snapshot
+bash: echo: write error: Device or resource busy
+ # cat snapshot
+cat: snapshot: Device or resource busy
+
 -----------
 
 More details can be found in the source code, in the

