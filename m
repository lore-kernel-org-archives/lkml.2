Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1LBFqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:46:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55866 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LBFqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:46:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Dec 2011 14:44:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [3.2-rc3] OOM killer doesn't kill the obvious memory hog
Message-Id: <20111202144441.4c2ff29e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111202033148.GA7046@dastard>
References: <20111201093644.GW7046@dastard>
	<20111201185001.5bf85500.kamezawa.hiroyu@jp.fujitsu.com>
	<20111201124634.GY7046@dastard>
	<alpine.DEB.2.00.1112011432110.27778@chino.kir.corp.google.com>
	<20111202015921.GZ7046@dastard>
	<20111202033148.GA7046@dastard>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011 14:31:48 +1100
Dave Chinner <david@fromorbit.com> wrote:

> So, it's a distro bug - sshd should never be started from from udev
> context because of this inherited oom_score_adj thing.
> Interestingly, the ifup ssh restart script says this:
> 
> # We'd like to use 'reload' here, but it has some problems; see #502444.
> if [ -x /usr/sbin/invoke-rc.d ]; then
>         invoke-rc.d ssh restart >/dev/null 2>&1 || true
> else
>         /etc/init.d/ssh restart >/dev/null 2>&1 || true
> fi
> 
> Bug 502444 describes the exact startup race condition that I've just
> found. It does a ssh server restart because reload causes the sshd
> server to fail to start if a start is currently in progress.  So,
> rather than solving the start vs reload race condition, it got a
> bandaid (use restart to restart sshd from the reload context) and
> left it as a landmine.....
> 

Thank you for chasing. 
Hm, BTW, do you think this kind of tracepoint is useful for debugging ?
This patch is just an example.

==
>From ed565cbf842e0b30827fba7bfdbc724fe21d9d2d Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 2 Dec 2011 14:10:51 +0900
Subject: [PATCH] oom_score_adj trace point.

oom_score_adj is set by some daemon and launch tasks ans inherited
to applications, sometimes unexpectedly.

This patch is for debugging oom_score_adj inheritance. This
adds trace points for oom_score_adj inheritance.

    bash-2501  [002]   448.860197: oom_score_adj_update: task 2501[bash] updates oom_score_adj=-1000
    bash-2501  [002]   455.678190: oom_score_adj_inherited: new task 2527 inherited oom_score_adj -1000
    ls-2527  [007]   455.678683: oom_score_task_rename: task 2527[bash] to [ls] oom_score_adj=-1000
    bash-2501  [007]   461.632103: oom_score_adj_inherited: new task 2528 inherited oom_score_adj -1000
    bash-2501  [007]   461.632335: oom_score_adj_inherited: new task 2529 inherited oom_score_adj -1000
    ls-2528  [003]   461.632983: oom_score_task_rename: task 2528[bash] to [ls] oom_score_adj=-1000
    less-2529  [005]   461.633086: oom_score_task_rename: task 2529[bash] to [less] oom_score_adj=-1000
    bash-2501  [004]   474.888710: oom_score_adj_update: task 2501[bash] updates oom_score_adj=0

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/exec.c                  |    5 +++
 fs/proc/base.c             |    3 ++
 include/trace/events/oom.h |   80 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c              |    5 +++
 mm/oom_kill.c              |    6 +++
 5 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/oom.h

diff --git a/fs/exec.c b/fs/exec.c
index 3625464..340760f 100644
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
@@ -1054,6 +1056,9 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
 
+	if (tsk->signal->oom_score_adj)
+		trace_oom_score_task_rename(tsk, buf);
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
index 0000000..e161ae5
--- /dev/null
+++ b/include/trace/events/oom.h
@@ -0,0 +1,80 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM oom
+
+#if !defined(_TRACE_OOM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OOM_H
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(oom_score_adj_inherited,
+
+	TP_PROTO(struct task_struct *task),
+	
+	TP_ARGS(task),
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
+	TP_printk("new task %d inherited oom_score_adj %d",
+		__entry->newpid, __entry->oom_score_adj)
+);
+
+TRACE_EVENT(oom_score_task_rename,
+
+	TP_PROTO(struct task_struct *task, char *comm),
+
+	TP_ARGS(task, comm),
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
+	TP_printk("task %d[%s] to [%s] oom_score_adj=%d",
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
+	TP_printk("task %d[%s] updates oom_score_adj=%d",
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
index e20518d..634aa84 100644
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
+	if (!(clone_flags & CLONE_THREAD) && p->signal->oom_score_adj)
+		trace_oom_score_adj_inherited(p);
+
 	return p;
 
 bad_fork_free_pid:
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3134ee2..5c8b2aa 100644
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


