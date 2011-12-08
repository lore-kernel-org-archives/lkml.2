Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab1LHGd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:33:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46960 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1LHGd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:33:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Dec 2011 15:32:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, rientjes@google.com, dchinner@redhat.com
Subject: [PATCH v4] oom: add tracepoints for oom_score_adj
Message-Id: <20111208153230.9c68eab3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111208104705.b2e50039.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111207095434.5f2fed4b.kamezawa.hiroyu@jp.fujitsu.com>
	<4EDF99B2.6040007@jp.fujitsu.com>
	<20111208104705.b2e50039.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011 10:47:05 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 07 Dec 2011 11:52:02 -0500
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
  - [pid] comm
> >  - pid:comm
> >  - comm:pid
> >  - comm-pid    (ftrace specific)
> > 
> > Why do we need to introduce alternative printing style?
> > 
> 

v4 here
==
>From 5dc1f8c879ae424d5853af255df8860494209e39 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 7 Dec 2011 09:58:16 +0900
Subject: [PATCH] oom: trace point for oom_score_adj

oom_score_adj is set to prevent a task from being killed by OOM-Killer.
Some daemons sets this value and their children inerit it sometimes.
Because inheritance of oom_score_adj is done automatically, users
can be confused at seeing the value and finds it's hard to debug.

This patch adds trace point for oom_score_adj. This adds 3 trace
points. at
	- update oom_score_adj
	- fork()
	- rename task->comm(typically, exec())

At fork and rename, this trace has filters as task->signal->oom_score_adj != 0.
Then, users can extract information required for fixing oom problem easily.

<...>-2456  [002]    87.347612: oom_score_adj_update: task 2456:bash updates oom_score_adj=-1000
<...>-2456  [002]    90.228660: oom_score_adj_inherited: new_task=2480 oom_score_adj=-1000
ls-2480  [007]    90.229122: oom_score_task_rename: rename task 2480:bash to ls oom_score_adj=-1000
<...>-2456  [006]   111.024606: oom_score_adj_inherited: new_task=2482 oom_score_adj=-1000
bash-2482  [003]   111.025174: oom_score_task_rename: rename task 2482:bash to bash oom_score_adj=-1000

Changelog v3->v4:
  - change format from pid[comm] to pid:comm
  - updated patch description.

Changelog v2->v3:
  - use TRACE_EVENT_CONDITION to check condition.
  - use %d for pid.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/exec.c                  |    4 ++
 fs/proc/base.c             |    3 ++
 include/trace/events/oom.h |   84 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c              |    5 +++
 mm/oom_kill.c              |    6 +++
 5 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/oom.h

diff --git a/fs/exec.c b/fs/exec.c
index ca141db..9e99cf9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -59,6 +59,8 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+
+#include <trace/events/oom.h>
 #include "internal.h"
 
 int core_uses_pid;
@@ -1054,6 +1056,8 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
 
+	trace_oom_score_task_rename(tsk, buf);
+
 	/*
 	 * Threads may access current->comm without holding
 	 * the task lock, so write the string carefully.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1050b1c..f201e64 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -87,6 +87,7 @@
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
+#include <trace/events/oom.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1166,6 +1167,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	else
 		task->signal->oom_score_adj = (oom_adjust * OOM_SCORE_ADJ_MAX) /
 								-OOM_DISABLE;
+	trace_oom_score_adj_update(task);
 err_sighand:
 	unlock_task_sighand(task, &flags);
 err_task_lock:
@@ -1253,6 +1255,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 	task->signal->oom_score_adj = oom_score_adj;
 	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
 		task->signal->oom_score_adj_min = oom_score_adj;
+	trace_oom_score_adj_update(task);
 	/*
 	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
 	 * always attainable.
diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
new file mode 100644
index 0000000..275155c
--- /dev/null
+++ b/include/trace/events/oom.h
@@ -0,0 +1,84 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM oom
+
+#if !defined(_TRACE_OOM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OOM_H
+#include <linux/tracepoint.h>
+
+TRACE_EVENT_CONDITION(oom_score_adj_inherited,
+
+	TP_PROTO(struct task_struct *task),
+	
+	TP_ARGS(task),
+
+	TP_CONDITION(task->signal->oom_score_adj != 0),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,		newpid)
+		__field(	  int,		oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->newpid = task->pid;
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("new_task=%d oom_score_adj=%d",
+		__entry->newpid, __entry->oom_score_adj)
+);
+
+TRACE_EVENT_CONDITION(oom_score_task_rename,
+
+	TP_PROTO(struct task_struct *task, char *comm),
+
+	TP_ARGS(task, comm),
+
+	TP_CONDITION(task->signal->oom_score_adj != 0),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	 pid)
+		__array(         char,   oldcomm,   TASK_COMM_LEN   )
+		__array(         char,   newcomm,   TASK_COMM_LEN   )
+		__field(	  int,   oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		 memcpy(__entry->oldcomm, task->comm, TASK_COMM_LEN);
+		 memcpy(__entry->newcomm, comm, TASK_COMM_LEN);
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("rename task %d:%s to %s oom_score_adj=%d",
+		__entry->pid, __entry->oldcomm, __entry->newcomm,
+		__entry->oom_score_adj)
+);
+
+TRACE_EVENT(oom_score_adj_update,
+
+	TP_PROTO(struct task_struct *task),
+
+	TP_ARGS(task),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
+		__array(	char,	comm,	TASK_COMM_LEN )
+		__field(	 int,	oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("task %d:%s updates oom_score_adj=%d",
+		__entry->pid, __entry->comm, __entry->oom_score_adj)
+);
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
diff --git a/kernel/fork.c b/kernel/fork.c
index e20518d..758e5db 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -76,6 +76,7 @@
 #include <asm/tlbflush.h>
 
 #include <trace/events/sched.h>
+#include <trace/events/oom.h>
 
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
@@ -1390,6 +1391,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
 	perf_event_fork(p);
+
+	if (!(clone_flags & CLONE_THREAD))
+		trace_oom_score_adj_inherited(p);
+
 	return p;
 
 bad_fork_free_pid:
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e2e1402..46b6d0a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -33,6 +33,10 @@
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/freezer.h>
+#include <linux/ftrace.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/oom.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -55,6 +59,7 @@ void compare_swap_oom_score_adj(int old_val, int new_val)
 	spin_lock_irq(&sighand->siglock);
 	if (current->signal->oom_score_adj == old_val)
 		current->signal->oom_score_adj = new_val;
+	trace_oom_score_adj_update(current);
 	spin_unlock_irq(&sighand->siglock);
 }
 
@@ -74,6 +79,7 @@ int test_set_oom_score_adj(int new_val)
 	spin_lock_irq(&sighand->siglock);
 	old_val = current->signal->oom_score_adj;
 	current->signal->oom_score_adj = new_val;
+	trace_oom_score_adj_update(current);
 	spin_unlock_irq(&sighand->siglock);
 
 	return old_val;
-- 
1.7.4.1


