Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab1KCBhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933766Ab1KCBhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.285225069@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [100/107] deal with races in /proc/*/{syscall,stack,personality}
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit a9712bc12c40c172e393f85a9b2ba8db4bf59509 upstream.

All of those are rw-r--r-- and all are broken for suid - if you open
a file before the target does suid-root exec, you'll be still able
to access it.  For personality it's not a big deal, but for syscall
and stack it's a real problem.

Fix: check that task is tracable for you at the time of read().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |   69 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 19 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -328,6 +328,23 @@ static int proc_pid_wchan(struct task_st
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
@@ -337,6 +354,7 @@ static int proc_pid_stack(struct seq_fil
 {
 	struct stack_trace trace;
 	unsigned long *entries;
+	int err;
 	int i;
 
 	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
@@ -347,15 +365,20 @@ static int proc_pid_stack(struct seq_fil
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
 
@@ -527,18 +550,22 @@ static int proc_pid_syscall(struct task_
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
 
@@ -2497,8 +2524,12 @@ static int proc_tgid_io_accounting(struc
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
@@ -2517,13 +2548,13 @@ static const struct pid_entry tgid_base_
 	REG("environ",    S_IRUSR, proc_environ_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUSR, proc_pid_personality),
+	ONE("personality", S_IRUGO, proc_pid_personality),
 	INF("limits",	  S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2551,7 +2582,7 @@ static const struct pid_entry tgid_base_
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	ONE("stack",      S_IRUGO, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -2856,13 +2887,13 @@ static const struct pid_entry tid_base_s
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUSR, proc_pid_personality),
+	ONE("personality", S_IRUGO, proc_pid_personality),
 	INF("limits",	 S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	INF("syscall",   S_IRUGO, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
@@ -2889,7 +2920,7 @@ static const struct pid_entry tid_base_s
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	ONE("stack",      S_IRUGO, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),


