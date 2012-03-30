Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab2C3Qe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:34:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab2C3QeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:34:20 -0400
Date: Fri, 30 Mar 2012 18:26:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: David Smith <dsmith@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: fix the "old_pid" usage in
	trace_sched_process_exec()
Message-ID: <20120330162636.GA4857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. TRACE_EVENT(sched_process_exec) forgets to actually use the
   old pid argument, it sets ->old_pid = p->pid.

2. search_binary_handler() uses the wrong pid number. tracepoint
   needs the global pid_t from the root namespace, while old_pid
   is the virtual pid number as it seen by the tracer/parent.

With this patch we have two pid_t's in search_binary_handler(),
not really nice. Perhaps we should switch to "struct pid*", but
in this case it would be better to cleanup the current code first
and move the "depth == 0" code outside.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c                    |    7 ++++---
 include/trace/events/sched.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e48c66e..91db3e8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1372,7 +1372,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
-	pid_t old_pid;
+	pid_t old_pid, old_vpid;
 
 	retval = security_bprm_check(bprm);
 	if (retval)
@@ -1383,8 +1383,9 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 		return retval;
 
 	/* Need to fetch pid before load_binary changes it */
+	old_pid = current->pid;
 	rcu_read_lock();
-	old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
 	rcu_read_unlock();
 
 	retval = -ENOENT;
@@ -1407,7 +1408,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			if (retval >= 0) {
 				if (depth == 0) {
 					trace_sched_process_exec(current, old_pid, bprm);
-					ptrace_event(PTRACE_EVENT_EXEC, old_pid);
+					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e61ddfe..2f10e81 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -295,7 +295,7 @@ TRACE_EVENT(sched_process_exec,
 	TP_fast_assign(
 		__assign_str(filename, bprm->filename);
 		__entry->pid		= p->pid;
-		__entry->old_pid	= p->pid;
+		__entry->old_pid	= old_pid;
 	),
 
 	TP_printk("filename=%s pid=%d old_pid=%d", __get_str(filename),
-- 
1.5.5.1


