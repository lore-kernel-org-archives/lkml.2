Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2BVQL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:11:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2BVQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:11:55 -0500
Date: Wed, 22 Feb 2012 08:10:41 -0800
From: tip-bot for David Smith <dsmith@redhat.com>
Message-ID: <tip-49667d4aec91c766bb0519db798713ee6c90e7d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        viro@zeniv.linux.org.uk, hch@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        dsmith@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, tglx@linutronix.de, dsmith@redhat.com,
        mingo@elte.hu
In-Reply-To: <4F314D19.7030504@redhat.com>
References: <4F314D19.7030504@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracepoint, vfs, sched: Add exec() tracepoint
Git-Commit-ID: 49667d4aec91c766bb0519db798713ee6c90e7d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:11:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49667d4aec91c766bb0519db798713ee6c90e7d5
Gitweb:     http://git.kernel.org/tip/49667d4aec91c766bb0519db798713ee6c90e7d5
Author:     David Smith <dsmith@redhat.com>
AuthorDate: Tue, 7 Feb 2012 10:11:05 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 12:21:54 +0100

tracepoint, vfs, sched: Add exec() tracepoint

Added a minimal exec tracepoint. Exec is an important major event
in the life of a task, like fork(), clone() or exit(), all of
which we already trace.

[ We also do scheduling re-balancing during exec() - so it's useful
  from a scheduler instrumentation POV as well. ]

If you want to watch a task start up, when it gets exec'ed is a good place
to start.  With the addition of this tracepoint, exec's can be monitored
and better picture of general system activity can be obtained. This
tracepoint will also enable better process life tracking, allowing you to
answer questions like "what process keeps starting up binary X?".

This tracepoint can also be useful in ftrace filtering and trigger
conditions: i.e. starting or stopping filtering when exec is called.

Signed-off-by: David Smith <dsmith@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F314D19.7030504@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/exec.c                    |    9 ++++++---
 include/trace/events/sched.h |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index aeb135c..d0d2080 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -63,6 +63,8 @@
 #include <trace/events/task.h>
 #include "internal.h"
 
+#include <trace/events/sched.h>
+
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
@@ -1401,9 +1403,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			 */
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
-				if (depth == 0)
-					ptrace_event(PTRACE_EVENT_EXEC,
-							old_pid);
+				if (depth == 0) {
+					trace_sched_process_exec(current, old_pid, bprm);
+					ptrace_event(PTRACE_EVENT_EXEC, old_pid);
+				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 6ba596b..e61ddfe 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -6,6 +6,7 @@
 
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
+#include <linux/binfmts.h>
 
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
@@ -276,6 +277,32 @@ TRACE_EVENT(sched_process_fork,
 );
 
 /*
+ * Tracepoint for exec:
+ */
+TRACE_EVENT(sched_process_exec,
+
+	TP_PROTO(struct task_struct *p, pid_t old_pid,
+		 struct linux_binprm *bprm),
+
+	TP_ARGS(p, old_pid, bprm),
+
+	TP_STRUCT__entry(
+		__string(	filename,	bprm->filename	)
+		__field(	pid_t,		pid		)
+		__field(	pid_t,		old_pid		)
+	),
+
+	TP_fast_assign(
+		__assign_str(filename, bprm->filename);
+		__entry->pid		= p->pid;
+		__entry->old_pid	= p->pid;
+	),
+
+	TP_printk("filename=%s pid=%d old_pid=%d", __get_str(filename),
+		  __entry->pid, __entry->old_pid)
+);
+
+/*
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
