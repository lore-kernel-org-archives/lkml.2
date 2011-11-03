Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab1KCQAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:00:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689Ab1KCQAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:00:14 -0400
Message-ID: <4EB2BA74.5070207@redhat.com>
Date: Thu, 03 Nov 2011 10:59:48 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH v2] Tracepoint: add exec tracepoint
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version corrects 2 small problems.  Include linux/binfmts.h in trace/events/sched.h to provide definition of 'struct linux_binprm'.  To avoid future abi problems, add 'struct task_struct' parameter (like most of the other sched tracepoints have).

---
From: David Smith <dsmith@redhat.com>

Added general purpose exec tracepoint.  The 'bprm' argument gives details of the exec.

Signed-off-by: David Smith <dsmith@redhat.com>
---
 fs/exec.c                    |    6 +++++-
 include/trace/events/sched.h |   23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..b0f4919 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -61,6 +61,8 @@
 #include <asm/tlb.h>
 #include "internal.h"
 
+#include <trace/events/sched.h>
+
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
@@ -1401,9 +1403,11 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			 */
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
-				if (depth == 0)
+				if (depth == 0) {
+					trace_sched_process_exec(current, bprm);
 					ptrace_event(PTRACE_EVENT_EXEC,
 							old_pid);
+				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..ca8d084 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -6,6 +6,7 @@
 
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
+#include <linux/binfmts.h>
 
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
@@ -276,6 +277,28 @@ TRACE_EVENT(sched_process_fork,
 );
 
 /*
+ * Tracepoint for exec:
+ */
+TRACE_EVENT(sched_process_exec,
+
+	TP_PROTO(struct task_struct *p, struct linux_binprm *bprm),
+
+	TP_ARGS(p, bprm),
+
+	TP_STRUCT__entry(
+		__string(	filename,	bprm->filename	)
+		__field(	pid_t,		pid		)
+	),
+
+	TP_fast_assign(
+		__assign_str(filename, bprm->filename);
+		__entry->pid	= p->pid;
+	),
+
+	TP_printk("filename=%s pid=%d", __get_str(filename), __entry->pid)
+);
+
+/*
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
