Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2JBIPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:15:45 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:46210 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2JBIPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:15:37 -0400
X-AuditID: b753bd60-945e1ba000004744-fb-506aa20dfa62
X-AuditID: b753bd60-945e1ba000004744-fb-506aa20dfa62
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH -tip 0/4] tracing: make a snapshot feature available from
 userspace
To: rostedt@goodmis.org, rob@landley.net
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        fweisbec@gmail.com, mingo@redhat.com, jolsa@redhat.com,
        lizf@cn.fujitsu.com
Date: Tue, 02 Oct 2012 17:13:09 +0900
Message-ID: <20121002081309.8661.37629.stgit@falsita>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

This patch series make a snapshot feature available from userspace
via debugfs.
(But I know that you are working for multi-buffer. If these
patches collide with your work much, I will resubmit my patches
after that. What would you think?)


If we set CONFIG_TRACER_SNAPSHOT, this snapshot feature becomes
available to all non latency tracers. (Latency tracers which
record max latency, such as "irqsoff" or "wakeup", can't use
this feature, since those are already using the snapshot
mechanism internally.)

Snapshot preserves a trace buffer at a particular point in time
without stopping tracing. Ftrace swaps the current buffer with a
spare buffer, and tracing continues in the (previous) spare
buffer.

The following debugfs files in "tracing" are related to this
feature:

  snapshot:

	This is used to take a snapshot and to read the output
	of the snapshot. Echo 1 into this file to allocate a
	spare buffer and to take a snapshot, then read the
	snapshot from the file in the same format as "trace".
	Both reads snapshot and tracing are executable in
	parallel. Echoing 0 erases the snapshot contents.

  snapshot_allocate:

	This is used to pre-allocate or free a spare buffer.
	Echo 1 into this file to pre-allocate a spare buffer if
	you don't want to fail in the next snapshot due to
	memory allocation failure, or if you don't want to lose
	older trace data while allocating buffer. Echo 0 to free
	the spare buffer when the snapshot becomes unnecessary.
	If you take the next snapshot again, you can reuse the
	buffer, then just erase the snapshot contents by echoing
	1 into the "snapshot" file, instead of freeing the
	buffer.

	Reads from this file display whether the spare buffer is
	allocated. When current_tracer is changed, the allocated
	spare buffer is freed. If the next tracer is one of the
	latency tracers, this value turns into 1 and can't be
	changed, or else the value starts with 0.


Here is an example of using the snapshot feature.

 # echo 1 > snapshot_allocate (if you want to pre-allocate the spare buffer)
 # echo 1 > events/sched/enable
 # echo 1 > snapshot
 # cat snapshot
# tracer: nop
#
# entries-in-buffer/entries-written: 71/71   #P:8
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
          <idle>-0     [005] d...  2440.603828: sched_switch: prev_comm=swapper/5 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2242 next_prio=120
           sleep-2242  [005] d...  2440.603846: sched_switch: prev_comm=snapshot-test-2 prev_pid=2242 prev_prio=120 prev_state=R ==> next_comm=kworker/5:1 next_pid=60 next_prio=120
[...]
          <idle>-0     [002] d...  2440.707230: sched_switch: prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2229 next_prio=120
 # cat trace
# tracer: nop
#
# entries-in-buffer/entries-written: 77/77   #P:8
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
          <idle>-0     [007] d...  2440.707395: sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2243 next_prio=120
 snapshot-test-2-2229  [002] d...  2440.707438: sched_switch: prev_comm=snapshot-test-2 prev_pid=2229 prev_prio=120 prev_state=S ==> next_comm=swapper/2 next_pid=0 next_prio=120
[...]

---

Hiraku Toyooka (4):
      tracing: add description of snapshot to Documentation/trace/ftrace.txt
      tracing: make a snapshot feature available from userspace
      tracing: add a resize function for making one buffer equivalent to the other buffer
      tracing: change tracer's integer flags to bool


 Documentation/trace/ftrace.txt    |   97 +++++++++++++++
 include/linux/ftrace_event.h      |    3 
 kernel/trace/Kconfig              |   11 ++
 kernel/trace/trace.c              |  247 +++++++++++++++++++++++++++++++------
 kernel/trace/trace.h              |    5 -
 kernel/trace/trace_irqsoff.c      |   12 +-
 kernel/trace/trace_sched_wakeup.c |    8 +
 7 files changed, 332 insertions(+), 51 deletions(-)

-- 
Hiraku TOYOOKA
Linux Technology Center
Yokohama Research Laboratory
Hitachi Ltd.
