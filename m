Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1EDU3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:29:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:59465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1EDU3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:29:15 -0400
Date: Wed, 4 May 2011 20:28:27 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-bf26c018490c2fce7fe9b629083b96ce0e6ad019@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, lethal@linux-sh.org,
        fweisbec@gmail.com, stable@kernel.org, tglx@linutronix.de,
        oleg@redhat.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, lethal@linux-sh.org,
        fweisbec@gmail.com, stable@kernel.org, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ptrace: Prepare to fix racy accesses on task breakpoints
Git-Commit-ID: bf26c018490c2fce7fe9b629083b96ce0e6ad019
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 20:28:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf26c018490c2fce7fe9b629083b96ce0e6ad019
Gitweb:     http://git.kernel.org/tip/bf26c018490c2fce7fe9b629083b96ce0e6ad019
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 7 Apr 2011 16:53:20 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 25 Apr 2011 17:28:24 +0200

ptrace: Prepare to fix racy accesses on task breakpoints

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
