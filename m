Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1ECNZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:25:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65460 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1ECNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MkGIHE3HQe0LppB1JXAlnFGb0w7w5AHDtBKGgozO/dsm6dH8bzRMfIkVl36NtoTAGD
         wgrB71nUIagUqmcDbmll3vLJyfyt679a3eacckenQ/lktrnZ83peIg96cs44h1SV/8cF
         yG+flYuNKIiinV4tOVlnQY2RGHgthFkWX4tZM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, "v2.6.33.." <stable@kernel.org>
Subject: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task breakpoints
Date: Tue,  3 May 2011 15:25:20 +0200
Message-Id: <1304429124-2376-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
References: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: v2.6.33.. <stable@kernel.org>
Link: http://lkml.kernel.org/r/1302284067-7860-2-git-send-email-fweisbec@gmail.com
---
 include/linux/ptrace.h |   13 ++++++++++++-
 include/linux/sched.h  |    3 +++
 kernel/exit.c          |    2 +-
 kernel/ptrace.c        |   17 +++++++++++++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index a1147e5..9178d5c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -189,6 +189,10 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 	}
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_set(&child->ptrace_bp_refcnt, 1);
+#endif
 }
 
 /**
@@ -350,6 +354,13 @@ extern int task_current_syscall(struct task_struct *target, long *callno,
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18d63ce..781abd1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1537,6 +1537,9 @@ struct task_struct {
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_t ptrace_bp_refcnt;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/exit.c b/kernel/exit.c
index f5d2f63..8dd8741 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1016,7 +1016,7 @@ NORET_TYPE void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	flush_ptrace_hw_breakpoint(tsk);
+	ptrace_put_breakpoints(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0fc1eed..dc7ab65 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/regset.h>
+#include <linux/hw_breakpoint.h>
 
 
 /*
@@ -879,3 +880,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
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
-- 
1.7.3.2

