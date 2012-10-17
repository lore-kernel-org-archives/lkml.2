Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2JQC4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:56:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34464 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JQC4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:56:40 -0400
X-AuditID: b753bd60-959e3ba000004744-2b-507e1e65332b
X-AuditID: b753bd60-959e3ba000004744-2b-507e1e65332b
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH v2 -tip 4/4] tracing: add description of snapshot to
 Documentation/trace/ftrace.txt
To: rostedt@goodmis.org
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 11:56:22 +0900
Message-ID: <20121017025622.2627.30144.stgit@falsita>
In-Reply-To: <20121017025608.2627.87497.stgit@falsita>
References: <20121017025608.2627.87497.stgit@falsita>
User-Agent: StGIT/0.14.3
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

 Documentation/trace/ftrace.txt |   97 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 6f51fed..68ac294 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1842,6 +1842,103 @@ an error.
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
+Snapshot preserves a trace buffer at a particular point in time
+without stopping tracing. Ftrace swaps the current buffer with a
+spare buffer, and tracing continues in the (previous) spare
+buffer.
+
+The following debugfs files in "tracing" are related to this
+feature:
+
+  snapshot:
+
+	This is used to take a snapshot and to read the output
+	of the snapshot. Echo 1 into this file to allocate a
+	spare buffer and to take a snapshot, then read the
+	snapshot from the file in the same format as "trace"
+	(described above in the section "The File System"). Both
+	reads snapshot and tracing are executable in parallel.
+	Echoing 0 erases the snapshot contents.
+
+  snapshot_allocate:
+
+	This is used to pre-allocate or free a spare buffer.
+	Echo 1 into this file to pre-allocate a spare buffer if
+	you don't want to fail in the next snapshot due to
+	memory allocation failure, or if you don't want to lose
+	older trace data while allocating buffer. Echo 0 to free
+	the spare buffer when the snapshot becomes unnecessary.
+	If you take the next snapshot again, you can reuse the
+	buffer, then just erase the snapshot contents by echoing
+	1 into the "snapshot" file, instead of freeing the
+	buffer.
+
+	Reads from this file display whether the spare buffer is
+	allocated. When current_tracer is changed, the allocated
+	spare buffer is freed. If the next tracer is one of the
+	latency tracers, this value turns into 1 and can't be
+	changed, or else the value starts with 0.
+
+
+Here is an example of using the snapshot feature.
+
+ # echo 1 > snapshot_allocate (if you want to pre-allocate the spare buffer)
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
+ # cat snapshot_allocate
+1
+ # echo 1 > snapshot_allocate
+bash: echo: write error: Device or resource busy
+ # echo 1 > snapshot
+bash: echo: write error: Device or resource busy
+ # cat snapshot
+cat: snapshot: Device or resource busy
+
 -----------
 
 More details can be found in the source code, in the

