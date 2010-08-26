Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0HZSOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46629 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0HZSOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:22 -0400
Message-Id: <20100826181341.894569424@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 10/11] sched: fork expedited
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-fork-expedited.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Impact: implement fork vruntime boosting when forks are performed from a
          interactive or timer wakeup chain. ]

Add new features:
INTERACTIVE_FORK_EXPEDITED
TIMER_FORK_EXPEDITED

to expedite forks performed from interactive and timer wakeup chains.

INTERACTIVE_FORK_EXPEDITED is needed to make timer_create() with sigev_notify =
SIGEV_THREAD POSIX API have lower latencies than it currently does. Yes,
spawning a new thread each time the timer fires is an utter ugliness, but this
is a standard API people rely on. We seem to have a two choices there: either:

1) we push for SIGEV_THREAD deprecation. This is, after all, an utter glibc
   mess, where thread creation and memory allocation failing is no dealt with,
   and where the helper thread waiting for the signal is created the first time
   timer_create() is invoked, and therefore keeps the cgroup/scheduler/etc. state
   of the first caller.
or
2) We try to support this standard behavior at the kernel level, with
   TIMER_FORK_EXPEDITED.


This patch brings down the average latency of wakeup-latency.c from 4000µs down
to 160µs by making sure the thread spawned when the timer fires is not put at
the end of the current period, but rather gets a vruntime boost.

This fork vruntime boost given by executing through an interactive or timer
wakeup chain is not transferrable to children. This is intended to try ensuring
some degree of safety against timer-based fork bombs.

Disabling START_DEBIT instead of doing these *_FORK_EXPEDITED does not give good
results under a make -j5 kernel build, uniprocessor machine: Xorg interactivity
suffers a lot.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h   |    3 ++-
 kernel/sched.c          |    8 ++++++++
 kernel/sched_fair.c     |    8 ++++++++
 kernel/sched_features.h |   11 +++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng.laptop/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.laptop.orig/include/linux/sched.h
+++ linux-2.6-lttng.laptop/include/linux/sched.h
@@ -1131,7 +1131,8 @@ struct sched_entity {
 	struct list_head	group_node;
 	unsigned int		on_rq:1,
 				interactive:1,
-				timer:1;
+				timer:1,
+				fork_expedited:1;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
Index: linux-2.6-lttng.laptop/kernel/sched.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched.c
+++ linux-2.6-lttng.laptop/kernel/sched.c
@@ -2504,6 +2504,14 @@ void sched_fork(struct task_struct *p, i
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+	if ((sched_feat(INTERACTIVE_FORK_EXPEDITED)
+	     && (current->sched_wake_interactive || current->se.interactive))
+	    || (sched_feat(TIMER_FORK_EXPEDITED)
+	     && (current->sched_wake_timer || current->se.timer)))
+		p->se.fork_expedited = 1;
+	else
+		p->se.fork_expedited = 0;
+
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 
Index: linux-2.6-lttng.laptop/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.laptop/kernel/sched_fair.c
@@ -731,6 +731,14 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	u64 vruntime = cfs_rq->min_vruntime;
 
 	/*
+	 * Expedite forks when requested rather than putting forked thread in a
+	 * delayed slot.
+	 */
+	if ((sched_feat(INTERACTIVE_FORK_EXPEDITED)
+	    || sched_feat(TIMER_FORK_EXPEDITED)) && se->fork_expedited)
+		initial = 0;
+
+	/*
 	 * The 'current' period is already promised to the current tasks,
 	 * however the extra weight of the new task will slow them down a
 	 * little, place the new task so that it fits in the slot that
Index: linux-2.6-lttng.laptop/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched_features.h
+++ linux-2.6-lttng.laptop/kernel/sched_features.h
@@ -59,9 +59,20 @@ SCHED_FEAT(DYN_MIN_VRUNTIME, 0)
  */
 SCHED_FEAT(INTERACTIVE, 0)
 /*
+ * Expedite forks performed from a wakeup chain coming from the input subsystem.
+ * Depends on the INTERACTIVE feature for following the wakeup chain across
+ * threads.
+ */
+SCHED_FEAT(INTERACTIVE_FORK_EXPEDITED, 0)
+/*
  * Timer subsystem next buddy affinity. Not transitive across new task wakeups.
  */
 SCHED_FEAT(TIMER, 0)
+/*
+ * Expedite forks performed from a wakeup chain coming from the timer subsystem.
+ * Depends on the TIMER feature for following the wakeup chain across threads.
+ */
+SCHED_FEAT(TIMER_FORK_EXPEDITED, 0)
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on

