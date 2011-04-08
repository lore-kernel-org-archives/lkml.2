Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab1DHRfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:35:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55671 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab1DHRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wU1pqu9yJdsxLAtgUjBpkAufRJlgPDNnt7uIrRLwPJOBle7A/9o+z5yY5aqbSEIP2m
         mGgQSCBZ/u3+zWd6c6RqqqkI2qdoHAI6g6qznQlDvOGBlZWyuTO40j8GKXM7VqqoGW+N
         NsM3Y7lhFExfDvVGO2VSlXNpR6kfHoHHXX3P8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task breakpoints
Date: Fri,  8 Apr 2011 19:34:23 +0200
Message-Id: <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: v2.6.33.. <stable@kernel.org>
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
index 83bd2e2..15badfa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1534,6 +1534,9 @@ struct task_struct {
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_t ptrace_bp_refcnt;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/exit.c b/kernel/exit.c
index 6a488ad..437e327 100644
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

