Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0IITya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:54:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:54454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0IITy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:54:29 -0400
Date: Thu, 9 Sep 2010 19:54:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix up delayed_put_task_struct()
Message-ID: <tip-4e231c7962ce711c7d8c2a4dc23ecd1e8fc28363@git.kernel.org>
Git-Commit-ID: 4e231c7962ce711c7d8c2a4dc23ecd1e8fc28363
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:54:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e231c7962ce711c7d8c2a4dc23ecd1e8fc28363
Gitweb:     http://git.kernel.org/tip/4e231c7962ce711c7d8c2a4dc23ecd1e8fc28363
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Sep 2010 21:01:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 21:07:09 +0200

perf: Fix up delayed_put_task_struct()

I missed a perf_event_ctxp user when converting it to an array. Pull this
last user into perf_event.c as well and fix it up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 ++
 kernel/exit.c              |    4 +---
 kernel/perf_event.c        |    8 ++++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c117352..93bf53a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -889,6 +889,7 @@ extern void perf_event_task_sched_out(struct task_struct *task, struct task_stru
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
+extern void perf_event_delayed_put(struct task_struct *task);
 extern void set_perf_event_pending(void);
 extern void perf_event_do_pending(void);
 extern void perf_event_print_debug(void);
@@ -1067,6 +1068,7 @@ perf_event_task_sched_out(struct task_struct *task,
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
+static inline void perf_event_delayed_put(struct task_struct *task)	{ }
 static inline void perf_event_do_pending(void)				{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
diff --git a/kernel/exit.c b/kernel/exit.c
index 0312022..e2bdf37 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -149,9 +149,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
-#ifdef CONFIG_PERF_EVENTS
-	WARN_ON_ONCE(tsk->perf_event_ctxp);
-#endif
+	perf_event_delayed_put(tsk);
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
 }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9819a69..eaf1c5d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5893,6 +5893,14 @@ again:
 	}
 }
 
+void perf_event_delayed_put(struct task_struct *task)
+{
+	int ctxn;
+
+	for_each_task_context_nr(ctxn)
+		WARN_ON_ONCE(task->perf_event_ctxp[ctxn]);
+}
+
 /*
  * inherit a event from parent task to child task:
  */
