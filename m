Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab1ESSc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49747 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933788Ab1ESScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:25 -0400
X-Sasl-enc: NBJrf3y95h4Icwj+qbJbYPtbrm58NmhKWf4CZ+fazpZE 1305829944
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:26 2011
Message-Id: <20110519183125.956320673@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [04/24] ptrace: Prepare to fix racy accesses on task breakpoints
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 3541
Lines: 117

From: Frederic Weisbecker <fweisbec@gmail.com>

commit bf26c018490c2fce7fe9b629083b96ce0e6ad019 upstream.

When a task is traced and is in a stopped state, the tracer
may execute a ptrace request to examine the tracee state and
get its task struct. Right after, the tracee can be killed
and thus its breakpoints released.
This can happen concurrently when the tracer is in the middle
of reading or modifying these breakpoints, leading to dereferencing
a freed pointer.

Hence, to prepare the fix, create a generic breakpoint reference
holding API. When a reference on the breakpoints of a task is
held, the breakpoints won't be released until the last reference
is dropped. After that, no more ptrace request on the task's
breakpoints can be serviced for the tracer.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/1302284067-7860-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ptrace.h |   13 ++++++++++++-
 include/linux/sched.h  |    3 +++
 kernel/exit.c          |    2 +-
 kernel/ptrace.c        |   17 +++++++++++++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -168,6 +168,10 @@ static inline void ptrace_init_task(stru
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 	}
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_set(&child->ptrace_bp_refcnt, 1);
+#endif
 }
 
 /**
@@ -336,6 +340,13 @@ extern int task_current_syscall(struct t
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
-#endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+extern int ptrace_get_breakpoints(struct task_struct *tsk);
+extern void ptrace_put_breakpoints(struct task_struct *tsk);
+#else
+static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+
+#endif /* __KERNEL */
 
 #endif
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1568,6 +1568,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_t ptrace_bp_refcnt;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1001,7 +1001,7 @@ NORET_TYPE void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	flush_ptrace_hw_breakpoint(tsk);
+	ptrace_put_breakpoints(tsk);
 	/*
 	 * Flush inherited counters to the parent - before the parent
 	 * gets woken up by child-exit notifications.
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/hw_breakpoint.h>
 
 
 /*
@@ -762,3 +763,19 @@ asmlinkage long compat_sys_ptrace(compat
 	return ret;
 }
 #endif	/* CONFIG_COMPAT */
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+int ptrace_get_breakpoints(struct task_struct *tsk)
+{
+	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
+		return 0;
+
+	return -1;
+}
+
+void ptrace_put_breakpoints(struct task_struct *tsk)
+{
+	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
+		flush_ptrace_hw_breakpoint(tsk);
+}
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */


