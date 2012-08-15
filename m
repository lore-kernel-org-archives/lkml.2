Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2HOUPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:15:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:36936 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab2HOTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 100/165] deal with races in /proc/*/{syscall,stack,personality}
Date: Wed, 15 Aug 2012 15:47:24 -0400
Message-ID: <1345060109-9187-101-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a9712bc12c40c172e393f85a9b2ba8db4bf59509 upstream.

All of those are rw-r--r-- and all are broken for suid - if you open
a file before the target does suid-root exec, you'll be still able
to access it.  For personality it's not a big deal, but for syscall
and stack it's a real problem.

Fix: check that task is tracable for you at the time of read().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[PG: in .34 cred_guard_mutex is in task, not task->signal]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/proc/base.c | 69 ++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 19 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 08741b0..16af014 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -329,6 +329,23 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_KALLSYMS */
 
+static int lock_trace(struct task_struct *task)
+{
+	int err = mutex_lock_killable(&task->cred_guard_mutex);
+	if (err)
+		return err;
+	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
+		mutex_unlock(&task->cred_guard_mutex);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static void unlock_trace(struct task_struct *task)
+{
+	mutex_unlock(&task->cred_guard_mutex);
+}
+
 #ifdef CONFIG_STACKTRACE
 
 #define MAX_STACK_TRACE_DEPTH	64
@@ -338,6 +355,7 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 {
 	struct stack_trace trace;
 	unsigned long *entries;
+	int err;
 	int i;
 
 	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
@@ -348,15 +366,20 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.max_entries	= MAX_STACK_TRACE_DEPTH;
 	trace.entries		= entries;
 	trace.skip		= 0;
-	save_stack_trace_tsk(task, &trace);
 
-	for (i = 0; i < trace.nr_entries; i++) {
-		seq_printf(m, "[<%p>] %pS\n",
-			   (void *)entries[i], (void *)entries[i]);
+	err = lock_trace(task);
+	if (!err) {
+		save_stack_trace_tsk(task, &trace);
+
+		for (i = 0; i < trace.nr_entries; i++) {
+			seq_printf(m, "[<%p>] %pS\n",
+				   (void *)entries[i], (void *)entries[i]);
+		}
+		unlock_trace(task);
 	}
 	kfree(entries);
 
-	return 0;
+	return err;
 }
 #endif
 
@@ -528,18 +551,22 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 {
 	long nr;
 	unsigned long args[6], sp, pc;
+	int res = lock_trace(task);
+	if (res)
+		return res;
 
 	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
-		return sprintf(buffer, "running\n");
-
-	if (nr < 0)
-		return sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
-
-	return sprintf(buffer,
+		res = sprintf(buffer, "running\n");
+	else if (nr < 0)
+		res = sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+	else
+		res = sprintf(buffer,
 		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
 		       sp, pc);
+	unlock_trace(task);
+	return res;
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
@@ -2561,8 +2588,12 @@ static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
-	seq_printf(m, "%08x\n", task->personality);
-	return 0;
+	int err = lock_trace(task);
+	if (!err) {
+		seq_printf(m, "%08x\n", task->personality);
+		unlock_trace(task);
+	}
+	return err;
 }
 
 /*
@@ -2581,14 +2612,14 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("environ",    S_IRUSR, proc_environ_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUSR, proc_pid_personality),
+	ONE("personality", S_IRUGO, proc_pid_personality),
 	INF("limits",	  S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2616,7 +2647,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	ONE("stack",      S_IRUGO, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -2921,14 +2952,14 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUSR, proc_pid_personality),
+	ONE("personality", S_IRUGO, proc_pid_personality),
 	INF("limits",	 S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	INF("syscall",   S_IRUGO, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
@@ -2955,7 +2986,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	ONE("stack",      S_IRUGO, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
-- 
1.7.12.rc2

