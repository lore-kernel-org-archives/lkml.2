Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1LIAee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:34:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39184 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1LIAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:34:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Dec 2011 09:33:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, rientjes@google.com, dchinner@redhat.com
Subject: Re: [PATCH] oom: add tracepoints for oom_score_adj
Message-Id: <20111209093323.977284db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111209084103.e3fea1f7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111207095434.5f2fed4b.kamezawa.hiroyu@jp.fujitsu.com>
	<4EDF99B2.6040007@jp.fujitsu.com>
	<20111208104705.b2e50039.kamezawa.hiroyu@jp.fujitsu.com>
	<4EE0F4EF.4010301@jp.fujitsu.com>
	<20111209084103.e3fea1f7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011 08:41:03 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 08 Dec 2011 12:33:35 -0500
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
 see Documentation/trace/event.txt 5. Event filgtering
> > 
> > Now, both ftrace and perf have good filter feature. Isn't this enough?
> > 
> 
> Could you make patch ? Then, I stop this and go other probelm.
> 

Hmm, core of patch should be like this. But need some works on

 - How to debug oom in Documenation especially for trace-cmd users.
 - Other trace points sutable for 'task' tracing. maybe 'exit, stop, freeze' ?
 - at creating new task, what other members should be printed out ?
 - At renaming...don't we need reason for renaming ?

Hm. BTW, do you know how to write filtering in
/etc/sysconfig/trace-cmd.config ?




>From 3e19265f25dff2c86829ae8afbcc19d02bcefae0 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 9 Dec 2011 09:44:23 +0900
Subject: [PATCH] trace point for oom debugging.

beta version.
---
 fs/exec.c                   |    4 +++
 fs/proc/base.c              |    3 ++
 include/trace/events/oom.h  |   35 ++++++++++++++++++++++++
 include/trace/events/task.h |   63 +++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c               |    6 ++++
 mm/oom_kill.c               |    6 ++++
 6 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/oom.h
 create mode 100644 include/trace/events/task.h

diff --git a/fs/exec.c b/fs/exec.c
index ca141db..fd0bfbd 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -59,6 +59,8 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+
+#include <trace/events/task.h>
 #include "internal.h"
 
 int core_uses_pid;
@@ -1054,6 +1056,8 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
 
+	trace_task_rename(tsk, buf);
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
index 0000000..bb75e5c
--- /dev/null
+++ b/include/trace/events/oom.h
@@ -0,0 +1,35 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM oom
+
+#if !defined(_TRACE_OOM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OOM_H
+#include <linux/tracepoint.h>
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
+	TP_printk("pid=%d comm=%s oom_score_adj=%d",
+		__entry->pid, __entry->comm, __entry->oom_score_adj)
+);
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
new file mode 100644
index 0000000..df8f8f8
--- /dev/null
+++ b/include/trace/events/task.h
@@ -0,0 +1,63 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM task
+
+#if !defined(_TRACE_TASK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TASK_H
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(task_newtask,
+
+	TP_PROTO(struct task_struct *task, unsigned long clone_flags),
+
+	TP_ARGS(task, clone_flags),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
+		__array(	char,	comm, TASK_COMM_LEN)
+		__field( unsigned long, clone_flags)
+		__field(	int,    oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->clone_flags = clone_flags;
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("pid=%d comm=%s clone_flags=%ld oom_score_adj=%d",
+		__entry->pid, __entry->comm,
+		__entry->clone_flags, __entry->oom_score_adj)
+);
+
+TRACE_EVENT(task_rename,
+
+	TP_PROTO(struct task_struct *task, char *comm),
+
+	TP_ARGS(task, comm),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
+		__array(	char, oldcomm,  TASK_COMM_LEN)
+		__array(	char, newcomm,  TASK_COMM_LEN)
+		__field(	int, oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
+		memcpy(entry->newcomm, comm, TASK_COMM_LEN);
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("pid=%d oldcomm=%s newcomm=%s oom_score_adj=%d",
+		__entry->pid, __entry->oldcomm,
+		__entry->newcomm, __entry->oom_score_adj)
+);
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
diff --git a/kernel/fork.c b/kernel/fork.c
index e20518d..d93ef13 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -77,6 +77,9 @@
 
 #include <trace/events/sched.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/task.h>
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -1390,6 +1393,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
 	perf_event_fork(p);
+
+	trace_task_newtask(p, clone_flags);
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


