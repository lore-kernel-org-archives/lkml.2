Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0HZSOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60842 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab0HZSOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:39 -0400
Message-Id: <20100826181341.122795854@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 07/11] sched rename struct task in_iowait field to sched_in_iowait
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-rename-task-in-iowait.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename task struct in_iowait to sched_in_iowait, since it's only
scheduler-specific. Extracted from a patch originally from Peter Zijlstra.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    7 +++----
 kernel/sched.c        |    8 ++++----
 kernel/sched_fair.c   |    2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng.git/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.git.orig/include/linux/sched.h
+++ linux-2.6-lttng.git/include/linux/sched.h
@@ -1233,11 +1233,10 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
-	unsigned in_iowait:1;
 
-
-	/* Revert to default priority/policy when forking */
-	unsigned sched_reset_on_fork:1;
+	unsigned sched_in_iowait:1;		/* Called io_schedule() */
+	unsigned sched_reset_on_fork:1;		/* Revert to default
+						 * priority/policy on fork */
 
 	pid_t pid;
 	pid_t tgid;
Index: linux-2.6-lttng.git/kernel/sched.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched.c
+++ linux-2.6-lttng.git/kernel/sched.c
@@ -4957,9 +4957,9 @@ void __sched io_schedule(void)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
-	current->in_iowait = 1;
+	current->sched_in_iowait = 1;
 	schedule();
-	current->in_iowait = 0;
+	current->sched_in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
@@ -4972,9 +4972,9 @@ long __sched io_schedule_timeout(long ti
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
-	current->in_iowait = 1;
+	current->sched_in_iowait = 1;
 	ret = schedule_timeout(timeout);
-	current->in_iowait = 0;
+	current->sched_in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -693,7 +693,7 @@ static void enqueue_sleeper(struct cfs_r
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
-			if (tsk->in_iowait) {
+			if (tsk->sched_in_iowait) {
 				se->statistics.iowait_sum += delta;
 				se->statistics.iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);

