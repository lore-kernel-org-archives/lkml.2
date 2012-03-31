Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2CaRVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 13:21:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2CaRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 13:21:06 -0400
Date: Sat, 31 Mar 2012 10:20:48 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-6308191f6f55d3629c7dbe72dfb856ad9fa560fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, dvlasenk@redhat.com,
        tglx@linutronix.de, oleg@redhat.com, dsmith@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, dvlasenk@redhat.com,
        tglx@linutronix.de, oleg@redhat.com, dsmith@redhat.com
In-Reply-To: <20120330162636.GA4857@redhat.com>
References: <20120330162636.GA4857@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing, sched, vfs: Fix 'old_pid'
  usage in trace_sched_process_exec()
Git-Commit-ID: 6308191f6f55d3629c7dbe72dfb856ad9fa560fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 10:20:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6308191f6f55d3629c7dbe72dfb856ad9fa560fd
Gitweb:     http://git.kernel.org/tip/6308191f6f55d3629c7dbe72dfb856ad9fa560fd
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 30 Mar 2012 18:26:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 31 Mar 2012 11:53:22 +0200

tracing, sched, vfs: Fix 'old_pid' usage in trace_sched_process_exec()

1. TRACE_EVENT(sched_process_exec) forgets to actually use the
   old pid argument, it sets ->old_pid = p->pid.

2. search_binary_handler() uses the wrong pid number. tracepoint
   needs the global pid_t from the root namespace, while old_pid
   is the virtual pid number as it seen by the tracer/parent.

With this patch we have two pid_t's in search_binary_handler(),
not really nice. Perhaps we should switch to "struct pid*", but
in this case it would be better to cleanup the current code
first and move the "depth == 0" code outside.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Smith <dsmith@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Link: http://lkml.kernel.org/r/20120330162636.GA4857@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/exec.c                    |    7 ++++---
 include/trace/events/sched.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 23559c2..644f6c4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1370,7 +1370,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
-	pid_t old_pid;
+	pid_t old_pid, old_vpid;
 
 	retval = security_bprm_check(bprm);
 	if (retval)
@@ -1381,8 +1381,9 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 		return retval;
 
 	/* Need to fetch pid before load_binary changes it */
+	old_pid = current->pid;
 	rcu_read_lock();
-	old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
 	rcu_read_unlock();
 
 	retval = -ENOENT;
@@ -1405,7 +1406,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			if (retval >= 0) {
 				if (depth == 0) {
 					trace_sched_process_exec(current, old_pid, bprm);
-					ptrace_event(PTRACE_EVENT_EXEC, old_pid);
+					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index fbc7b1a..ea7a203 100644
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
