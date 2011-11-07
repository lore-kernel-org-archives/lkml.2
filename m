Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1KGTtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:49:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1KGTtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:49:31 -0500
Message-ID: <4EB83634.8010607@redhat.com>
Date: Mon, 07 Nov 2011 13:49:08 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pedro Alves <pedro@codesourcery.com>
Subject: [RFC PATCH v3] Tracepoint: add exec tracepoint
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version adds 'old_pid' parameter and improves ChangeLog description.
---
From: David Smith <dsmith@redhat.com>

Added general purpose exec tracepoint. Exec is an important major
event in the life of a task (like fork or exit). If you want to watch
a task start up, when it gets exec'ed is a good place to start.  With
the addition of this tracepoint, exec's can be monitored and better
picture of general system activity can be obtained. This tracepoint
will also enable better process life tracking, allowing you to answer
questions like "what process keeps starting up process X?".

This tracepoint can also be useful in ftrace filtering (i.e. starting
or stopping filtering when exec is called)

Signed-off-by: David Smith <dsmith@redhat.com>
---
 fs/exec.c                    |    8 +++++++-
 include/trace/events/sched.h |   27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 3625464..0059e82 100644
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
@@ -1397,9 +1399,13 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
                         */
                        bprm->recursion_depth = depth;
                        if (retval >= 0) {
-                               if (depth == 0)
+                               if (depth == 0) {
+                                       trace_sched_process_exec(current,
+                                                                old_pid,
+                                                                bprm);
                                        ptrace_event(PTRACE_EVENT_EXEC,
                                                        old_pid);
+                               }
                                put_binfmt(fmt);
                                allow_write_access(bprm->file);
                                if (bprm->file)
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..731d0bf 100644
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
+       TP_PROTO(struct task_struct *p, pid_t old_pid,
+                struct linux_binprm *bprm),
+
+       TP_ARGS(p, old_pid, bprm),
+
+       TP_STRUCT__entry(
+               __string(       filename,       bprm->filename  )
+               __field(        pid_t,          pid             )
+               __field(        pid_t,          old_pid         )
+       ),
+
+       TP_fast_assign(
+               __assign_str(filename, bprm->filename);
+               __entry->pid            = p->pid;
+               __entry->old_pid        = p->pid;
+       ),
+
+       TP_printk("filename=%s pid=%d old_pid=%d", __get_str(filename),
+                 __entry->pid, __entry->old_pid)
+);
+
+/*
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
